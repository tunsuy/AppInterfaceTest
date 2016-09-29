package main

import (
	"encoding/binary"
	"io"
	"log"
	"net"

	"gotcp"
)

var (
	recvDataIndex uint32
)

var recvData = make([]byte, 0, 1024)

type CustomPacket struct {
	buff []byte
}

func (this *CustomPacket) Serialize() []byte {
	return this.buff
}

func (this *CustomPacket) GetLength() uint32 {
	return binary.BigEndian.Uint32(this.buff[0:])
}

func (this *CustomPacket) GetBody() []byte {
	return this.buff[:]
}

func NewCustomPacket(buff []byte, hasLengthField bool) *CustomPacket {
	p := &CustomPacket{}

	if hasLengthField {
		p.buff = buff

	} else {
		p.buff = make([]byte, len(buff))
		// binary.BigEndian.PutUint32(p.buff[0:4], uint32(len(buff)))
		copy(p.buff[:], buff)
	}

	return p
}

type CustomProtocol struct {
}

func (this *CustomProtocol) ReadPacket(conn *net.TCPConn) (gotcp.Packet, error) {

	log.Println("持续读取client的请求数据...")

	buf := make([]byte, 1024)
	bufLen, err := conn.Read(buf)
	log.Println("buf: ", buf)
	if err != nil && err != io.EOF {
		log.Println("数据流读取 error：", err)
		return nil, err
	}

	if err == io.EOF {
		log.Println("Client主动关闭了连接...")
		return nil, err
	}

	recvDataIndex += uint32(bufLen)
	recvData = append(recvData, buf[:bufLen]...)

	var totalPacket = make([]byte, 1024)
	for {
		log.Println("数据处理中...")
		log.Println("recvDataIndex: ", recvDataIndex)
		log.Println("minPacketLen: ", uint32(minPacketLen))
		if recvDataIndex >= uint32(minPacketLen) {
			log.Println("recvData: ", recvData)
			totalLen := totalLengthOfPacket(recvData)
			log.Println("len(recvData): ", uint32(len(recvData)))
			log.Println("totalLen: ", totalLen)
			if uint32(len(recvData)) >= totalLen {
				//收到一个完整的包
				log.Println("收到一个完整的包...")
				isCanSend = true
				totalPacket = recvData[0:totalLen]
				recvData = recvData[totalLen:]
				recvDataIndex -= totalLen

				result := analysisRecvPacketData(totalPacket)
				if !result {
					log.Println("RecvPacketData is error!!!")
					break
				}
			} else {
				break
			}
		} else {
			break
		}

	}

	return NewCustomPacket(totalPacket, true), nil
}

func (this *CustomProtocol) WritePacket(conn *net.TCPConn) (gotcp.Packet, error) {

	log.Println("开始序列化返回给Client的rsp包...")

	protoHead := new(ProtocolHead)
	servRspData := dataFromSendIOSInfRsq(protoHead)

	//组装rsp包头
	var totalLen uint32 = uint32(minPacketLen + len(servRspData))
	var headBuf = make([]byte, 0, minPacketLen)
	totalLenByte := IntToBytes(totalLen)
	headBuf = append(headBuf, htonl(totalLenByte)...)
	srvByte := IntToBytes(protoHead.srv)
	headBuf = append(headBuf, htonl(srvByte)...)
	srvopByte := IntToBytes(protoHead.srvop)
	headBuf = append(headBuf, htonl(srvopByte)...)

	sendPacket := make([]byte, 0, 1024)
	sendPacket = append(sendPacket, headBuf[:]...)
	sendPacket = append(sendPacket, servRspData[:]...)

	log.Println("rsp包：", sendPacket)

	return NewCustomPacket(sendPacket, true), nil
}

//param mark - private function
func totalLengthOfPacket(packetData []byte) uint32 {
	hostData := ntohl(packetData)
	totalLenByte := hostData[0:4]
	totalLen := BytesToInt(totalLenByte)

	return totalLen
}
