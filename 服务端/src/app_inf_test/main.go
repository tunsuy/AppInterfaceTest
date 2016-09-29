package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"runtime"
)

var (
	logFileName    = flag.String("log", "cServer.log", "Log file name")
	configFileName = flag.String("configfile", "config.ini", "General configuration file")
)

func main() {
	//操作码初始化
	// SRVOP_INI()

	runtime.GOMAXPROCS(runtime.NumCPU())
	flag.Parse()

	//set logfile Stdout
	logFile, logErr := os.OpenFile(*logFileName, os.O_CREATE|os.O_RDWR|os.O_APPEND, 0666)
	if logErr != nil {
		fmt.Println("Fail to find", *logFile, "cServer start Failed")
		os.Exit(1)
	}
	log.SetOutput(logFile)
	log.SetFlags(log.Ldate | log.Ltime | log.Lshortfile)
	//set logfile Stdout End

	//start listen
	StartListen()

}
