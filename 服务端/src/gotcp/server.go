package gotcp

import (
	"log"
	"net"
	"sync"
	"time"
)

type Config struct {
	PacketSendChanLimit    uint32 // the limit of packet send channel
	PacketReceiveChanLimit uint32 // the limit of packet receive channel

	// ip   string
	// port uint32
}

type Server struct {
	config    *Config         // server configuration
	callback  ConnCallback    // message callbacks in connection
	protocol  Protocol        // customize packet protocol
	exitChan  chan struct{}   // notify all goroutines to shutdown
	waitGroup *sync.WaitGroup // wait for all goroutines
}

// NewServer creates a server
func NewServer(config *Config, callback ConnCallback, protocol Protocol) *Server {
	return &Server{
		config:    config,
		callback:  callback,
		protocol:  protocol,
		exitChan:  make(chan struct{}),
		waitGroup: &sync.WaitGroup{},
	}
}

// Start starts service
func (s *Server) Start(listener *net.TCPListener, acceptTimeout time.Duration) {
	s.waitGroup.Add(1)
	defer func() {
		listener.Close()
		s.waitGroup.Done()
	}()

	// listener, err := net.Listen("tcp", s.config.ip+":"+strconv.Itoa(s.config.port))
	// if err != nil {
	// 	log.Println("Server listen error: ", err)
	// }

	// log.Println("Server listen on port: ", strconv.Itoa(serv.port))

	//开始runloop
	for {
		select {
		case <-s.exitChan:
			log.Println("关闭传输通道exitChan....")
			return

		default:
		}

		listener.SetDeadline(time.Now().Add(acceptTimeout))

		conn, err := listener.AcceptTCP()
		if err != nil {
			continue
		}

		//waitGroup:一直等到所有的goroutine执行完成，并且阻塞主线程的执行，
		//直到所有的goroutine执行完成
		s.waitGroup.Add(1) //Add:添加或者减少等待goroutine的数量

		//开启一个新的协程处理新的连接
		go func() {
			newConn(conn, s).Do()
			s.waitGroup.Done() //Done:相当于Add(-1)
		}()
	}
}

// Stop stops service
func (s *Server) Stop() {
	close(s.exitChan)
	s.waitGroup.Wait() //执行阻塞，直到所有的WaitGroup数量变成0
}
