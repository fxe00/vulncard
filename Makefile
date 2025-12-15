.PHONY: build up down restart logs clean

# 构建所有镜像
build:
	docker-compose build

# 启动服务
up:
	docker-compose up -d

# 停止服务
down:
	docker-compose down

# 重启服务
restart:
	docker-compose restart

# 查看日志
logs:
	docker-compose logs -f

# 查看后端日志
logs-backend:
	docker-compose logs -f backend

# 查看前端日志
logs-frontend:
	docker-compose logs -f frontend

# 清理（停止并删除容器、网络）
clean:
	docker-compose down -v

# 重新构建并启动
rebuild:
	docker-compose up -d --build

# 进入后端容器
shell-backend:
	docker-compose exec backend sh

# 进入前端容器
shell-frontend:
	docker-compose exec frontend sh

