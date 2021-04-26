package main

import (
	"fmt"
	"os"
	"os/signal"
	"starter/module"
	"syscall"
)

func main() {
	str := "he師l發lo,世。+-*界，6"
	tran := module.NewTranslation("english")
	new := tran.Convert(str)
	fmt.Println(new)
	keepAlive()
}

func keepAlive() {
	//合建chan
	c := make(chan os.Signal)
	//监听指定信号 ctrl+c kill
	signal.Notify(c, os.Interrupt, os.Kill, syscall.SIGUSR1, syscall.SIGUSR2)
	//阻塞直到有信号传入
	fmt.Println("启动")
	//阻塞直至有信号传入
	s := <-c
	fmt.Println("退出信号", s)
}
