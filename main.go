package main

import (
	"fmt"
	"starter/module"
)

func main() {
	str := "he師l發lo,世。+-*界，6"
	tran := module.NewTranslation("english")
	new := tran.Convert(str)
	fmt.Println(new)
}
