package router

import (
	"net/http"
	"runtime"

	"github.com/gin-gonic/gin"
)

func InitRouter() *gin.Engine {
	router := gin.Default()

	router.GET("/", func(context *gin.Context) {
		context.String(http.StatusOK, "hello gin in "+runtime.GOARCH)
	})
	return router
}
