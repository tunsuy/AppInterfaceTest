package main

import (
	"bytes"
	"encoding/binary"
	"log"
)

//整形转换成字节
func IntToBytes(n interface{}) []byte {
	// x := uint32(n)

	bytesBuffer := bytes.NewBuffer([]byte{})
	binary.Write(bytesBuffer, binary.BigEndian, n)
	return bytesBuffer.Bytes()
}

//字节转换成整形
func BytesToInt(b []byte) uint32 {
	bytesBuffer := bytes.NewBuffer(b)

	var x uint32
	binary.Read(bytesBuffer, binary.BigEndian, &x)

	return x
}

//网络字节序转为本地字节序
func ntohl(netData []byte) []byte {
	hostData := make([]byte, 1024)
	buf := bytes.NewReader(netData)
	err := binary.Read(buf, binary.BigEndian, &hostData)
	if err != nil {
		log.Println("网络字节序转化失败....")
		return nil
	}
	return hostData
}

//本地字节序转为网络字节序
func htonl(hostData []byte) []byte {
	netData := new(bytes.Buffer)
	err := binary.Write(netData, binary.LittleEndian, hostData)
	if err != nil {
		log.Println("本地字节序转化失败....")
		return nil
	}
	return netData.Bytes()
}
