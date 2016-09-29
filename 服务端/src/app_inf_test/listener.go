package main

import (
	"log"
	"net"
	"os"
	"os/signal"
	"runtime"
	"strconv"
	"syscall"
	"time"

	"gotcp"
)

type Callback struct{}

func (this *Callback) OnConnect(c *gotcp.Conn) bool {
	addr := c.GetRawConn().RemoteAddr()
	c.PutExtraData(addr)
	log.Println("OnConnect:", addr)
	return true
}

func (this *Callback) OnMessage(c *gotcp.Conn, p gotcp.Packet) bool {
	// customPacket := p.(*CustomPacket)
	// log.Printf("OnMessage:[%v] [%v]\n", customPacket.GetLength(), string(customPacket.GetBody()))

	if isCanSend {
		c.AsyncWritePacket(time.Second)
		isCanSend = false
	}

	return true
}

func (this *Callback) OnClose(c *gotcp.Conn) {
	log.Println("OnClose:", c.GetExtraData())
}

//start listens
func StartListen() {
	// listener, err := net.Listen("tcp", IP+":"+strconv.Itoa(int(PORT)))
	// if err != nil {
	// 	log.Println("Server listen error: ", err)
	// }

	// log.Println("Server listen on port: ", strconv.Itoa(int(PORT)))

	runtime.GOMAXPROCS(runtime.NumCPU())

	// creates a tcp listener
	tcpAddr, err := net.ResolveTCPAddr("tcp4", IP+":"+strconv.Itoa(int(PORT)))
	if err != nil {
		log.Println("解析TCPAddr error: ", err)
	}
	listener, err := net.ListenTCP("tcp", tcpAddr)
	if err != nil {
		log.Println("Listen tcp error: ", err)
	}

	config := &gotcp.Config{
		PacketSendChanLimit:    20,
		PacketReceiveChanLimit: 20,
		// ip: IP,
		// port: PORT,
	}
	srv := gotcp.NewServer(config, &Callback{}, &CustomProtocol{})

	// starts service
	go srv.Start(listener, time.Second)
	log.Println("listening:", listener.Addr())

	// catchs system signal
	chSig := make(chan os.Signal)
	signal.Notify(chSig, syscall.SIGINT, syscall.SIGTERM)
	log.Println("Signal: ", <-chSig)

	// stops service
	srv.Stop()
}
