package main

import (
	"fmt"
	"os"
	"os/signal"
	"starter/module"
	"strings"
	"syscall"

	"github.com/spf13/viper"
)

func main() {
	str := "he師l發lo,世。+-*界，6"
	tran := module.NewTranslation("english")
	new := tran.Convert(str)
	fmt.Println(new)

	getenv := os.Getenv("JAVA_HOME")

	fmt.Println("环境变量：", getenv)

	LoadConfig("config.yaml")

	// viper.AutomaticEnv() // 读取匹配的环境变量

	// if env := viper.Get("JAVA_HOME"); env == nil {
	// 	fmt.Println("error!")
	// } else {
	// 	fmt.Printf("%#v\n", env)
	// }

	// // viper.SetEnvPrefix("IOT")   // 读取环境变量的前缀为APISERVER
	// replacer := strings.NewReplacer(".", "_")
	// viper.SetEnvKeyReplacer(replacer)

	level := viper.Get("log.level")

	fmt.Printf("level: %s \n", level)

	keepAlive()
}

// 读取配置
func LoadConfig(path string) {
	if path != "" {
		viper.SetConfigFile(path) // 如果指定了配置文件，则解析指定的配置文件
	} else {
		viper.AddConfigPath(".") // 如果没有指定配置文件，则解析默认的配置文件
		viper.SetConfigName("config")
	}
	viper.SetConfigType("yaml") // 设置配置文件格式为YAML
	viper.AutomaticEnv()        // 读取匹配的环境变量
	// viper.SetEnvPrefix("IOT")   // 读取环境变量的前缀为APISERVER
	replacer := strings.NewReplacer(".", "_")
	viper.SetEnvKeyReplacer(replacer)
	if err := viper.ReadInConfig(); err != nil { // viper解析配置文件
		panic(fmt.Errorf("Fatal error config file: %w \n", err))
	}
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
