package main

import (
	"io"
	"log"

	"com_sangfor_moa_protobuf"
	"github.com/golang/protobuf/proto"
)

func dataFromSendIOSInfRsq(protoHead *ProtocolHead) []byte {
	servRsp := &com_sangfor_moa_protobuf.PB_SendIOSInfRsp{
		Result: proto.Int32(0),
	}
	servRspData, err := proto.Marshal(servRsp)
	if err != nil {
		log.Println("Server response data marshaling error: ", err)
		return nil
	}

	protoHead.srv = SERVER_APPINF
	protoHead.srvop = SRVOP_APPINF_SEND_IOSINF_RSP

	return servRspData
}

func analysisRecvPacketData(packetData []byte) bool {
	cliReq := &com_sangfor_moa_protobuf.PB_SendIOSInfReq{}
	err := proto.Unmarshal(packetData[minPacketLen:], cliReq)
	if err != nil && err != io.EOF {
		log.Println("Client request data unmarshaling error: ", err)
		return false
	}

	showCliReqData(cliReq)

	return true
}

//param mark - private function
func showCliReqData(cliReq *com_sangfor_moa_protobuf.PB_SendIOSInfReq) {
	log.Println("Client request data: ")

	var clientInfos []*com_sangfor_moa_protobuf.PB_IOSInfInfo = cliReq.GetIOSInfo()
	for _, clientInfo := range clientInfos {
		log.Println("className: ", clientInfo.GetClassName())
		log.Println("MethodName: ", clientInfo.GetMethodName())
	}
}
