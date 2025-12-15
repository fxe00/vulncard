# Docker 部署指南

## 快速开始

### 使用 Docker Compose（推荐）

```bash
# 构建并启动所有服务
docker-compose up -d --build

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

### 服务访问

- **前端**: http://localhost:9091
- **后端 API**: http://localhost:8001

## 端口配置

- 前端容器端口：80 → 主机端口：9091
- 后端容器端口：8080 → 主机端口：8001

如需修改端口，编辑 `docker-compose.yml` 文件中的 `ports` 配置。

## 配置文件

配置文件通过 volume 挂载到容器中：

```yaml
volumes:
  - ./configs:/root/configs:ro
```

这意味着：

- 主机上的 `configs/` 目录会被挂载到容器的 `/root/configs`
- `:ro` 表示只读模式，容器不能修改配置文件
- 修改主机上的配置文件后，容器会自动读取新配置（无需重启）

## 常用命令

### 使用 Makefile

```bash
make build          # 构建所有镜像
make up             # 启动服务
make down           # 停止服务
make restart        # 重启服务
make logs           # 查看所有日志
make logs-backend   # 查看后端日志
make logs-frontend  # 查看前端日志
make rebuild        # 重新构建并启动
```

### 使用 docker-compose

```bash
# 构建镜像
docker-compose build

# 启动服务（后台运行）
docker-compose up -d

# 启动服务（前台运行，查看日志）
docker-compose up

# 停止服务
docker-compose down

# 查看日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs -f backend
docker-compose logs -f frontend

# 重启服务
docker-compose restart

# 进入容器
docker-compose exec backend sh
docker-compose exec frontend sh
```

## 单独构建和运行

### 后端

```bash
# 构建镜像
cd backend
docker build -t vulncard-backend .

# 运行容器
docker run -d \
  --name vulncard-backend \
  -p 8001:8080 \
  -v $(pwd)/../configs:/root/configs:ro \
  -e CONFIG_DIR=/root/configs \
  vulncard-backend
```

### 前端

```bash
# 构建镜像
cd frontend
docker build -t vulncard-frontend .

# 运行容器（需要先启动后端）
docker run -d \
  --name vulncard-frontend \
  -p 9091:80 \
  --link vulncard-backend:backend \
  vulncard-frontend
```

## 环境变量

### 后端环境变量

- `CONFIG_DIR`: 配置文件目录路径（默认：`/root/configs`）
- `PORT`: 服务端口（默认：`8080`）
- `TZ`: 时区设置（默认：`Asia/Shanghai`）

### 前端环境变量

前端使用 Nginx，通过 `nginx.conf` 配置。如需修改 API 代理地址，编辑 `frontend/nginx.conf` 中的 `proxy_pass` 配置。

## 网络配置

Docker Compose 会自动创建一个名为 `vulncard-network` 的桥接网络，前后端容器可以通过服务名（`backend`、`frontend`）互相访问。

## 故障排查

### 查看容器日志

```bash
# 查看所有日志
docker-compose logs

# 查看后端日志
docker-compose logs backend

# 查看前端日志
docker-compose logs frontend

# 实时跟踪日志
docker-compose logs -f backend
```

### 检查容器状态

```bash
# 查看运行中的容器
docker-compose ps

# 查看所有容器（包括停止的）
docker-compose ps -a
```

### 进入容器调试

```bash
# 进入后端容器
docker-compose exec backend sh

# 进入前端容器
docker-compose exec frontend sh
```

### 常见问题

1. **端口被占用**

   - 检查端口是否被其他服务占用：`lsof -i :8001` 或 `lsof -i :9091`
   - 修改 `docker-compose.yml` 中的端口映射

2. **配置文件找不到**

   - 确保 `configs/` 目录存在
   - 检查 volume 挂载是否正确

3. **前端无法访问后端**

   - 检查网络配置，确保前后端在同一网络
   - 检查 nginx 配置中的 `proxy_pass` 地址

4. **重新构建镜像**
   ```bash
   docker-compose build --no-cache
   docker-compose up -d
   ```

## 生产环境建议

1. **使用环境变量文件**

   ```bash
   # 创建 .env 文件
   BACKEND_PORT=8001
   FRONTEND_PORT=9091
   ```

2. **配置 HTTPS**

   - 使用 Nginx 反向代理配置 SSL 证书
   - 或使用 Traefik、Caddy 等工具

3. **数据持久化**

   - 如果需要保存数据，使用 Docker volumes

4. **资源限制**

   ```yaml
   deploy:
     resources:
       limits:
         cpus: "0.5"
         memory: 512M
   ```

5. **健康检查**
   ```yaml
   healthcheck:
     test: ["CMD", "curl", "-f", "http://localhost:8080/api/vulnerabilities"]
     interval: 30s
     timeout: 10s
     retries: 3
   ```
