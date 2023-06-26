package main

import (
	"log"

	"go-docker/router"
)

func main() {
	router := router.InitRouter()
	err := router.Run(":3000")
	if err != nil {
		log.Fatalln("gin run error", err)
	}
}
