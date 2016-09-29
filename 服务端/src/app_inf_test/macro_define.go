package main

//服务器相关配置
const (
	IP   string = ""
	PORT uint32 = 8888
)

//自定义协议
type ProtocolHead struct {
	length uint32
	srv    uint16
	srvop  uint32
	flag   uint16
}

const minPacketLen int = 4 + 2 + 4

//服务码
const (
	SERVER_APPINF uint16 = (0x1)
)

func SRVOP_MAKE(SERVER_CODE uint16, OP_NUM uint32) uint32 {
	return uint32((SERVER_CODE << 8)) | OP_NUM
}

//操作码
var (
	SRVOP_APPINF_SEND_IOSINF_REQ = SRVOP_MAKE(SERVER_APPINF, 1)
	SRVOP_APPINF_SEND_IOSINF_RSP = SRVOP_MAKE(SERVER_APPINF, 2)
)

// func SRVOP_INI() {
// 	SRVOP_APPINF_SEND_IOSINF_REQ := SRVOP_MAKE(SERVER_APPINF, 1)
// 	SRVOP_APPINF_SEND_IOSINF_RSP := SRVOP_MAKE(SERVER_APPINF, 2)
// }

//全局变量
var (
	isCanSend bool
)
