package main

import (
	"log"
	"os"

	"vulncard/backend/handlers"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	// 启用 CORS
	r.Use(func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, DELETE")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	})

	// API 路由
	api := r.Group("/api")
	{
		api.GET("/vulnerabilities", handlers.ListVulnerabilities)
		api.GET("/vulnerabilities/:id", handlers.GetVulnerability)
		api.PUT("/vulnerabilities/:id", handlers.SaveVulnerability)
	}

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("服务器启动在 :%s", port)
	if err := r.Run(":" + port); err != nil {
		log.Fatal("服务器启动失败:", err)
	}
}
