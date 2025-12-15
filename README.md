# 漏洞卡片管理系统

一个用于收录和管理漏洞卡片的系统，支持通过配置文件或管理平台编辑查看漏洞卡片内容。

## 项目结构

```
vulncard/
├── backend/          # Go 后端服务
│   ├── main.go      # 主程序入口
│   ├── models/      # 数据模型
│   ├── handlers/    # 请求处理器
│   └── go.mod       # Go 依赖管理
├── frontend/        # Vue 前端应用
│   ├── src/
│   │   ├── components/  # Vue 组件
│   │   ├── views/       # 页面视图
│   │   ├── router/      # 路由配置
│   │   └── main.js      # 入口文件
│   └── package.json     # 前端依赖
└── configs/         # 漏洞卡片配置文件（YAML格式）
    └── sql-injection.yaml
```

## 功能特性

- 📋 多视角展示：漏洞概述、受害者视角、攻击者视角、代码触发视角
- 📝 YAML 配置文件：易于理解和编辑
- 🎨 美观的 UI：基于 Element Plus 和自定义样式
- 🔄 RESTful API：标准的后端接口
- 📱 响应式设计：支持移动端和桌面端

## 快速开始

### 方式一：使用 Docker（推荐）

```bash
# 构建并启动所有服务
docker-compose up -d --build

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

服务访问地址：

- 前端：http://localhost:9091
- 后端 API：http://localhost:8001

### 方式二：本地开发

#### 后端启动

```bash
cd backend
go mod tidy
go run main.go
```

后端服务将在 `http://localhost:8080` 启动。

#### 前端启动

```bash
cd frontend
npm install
npm run dev
```

前端应用将在 `http://localhost:3000` 启动。

### Docker 常用命令

```bash
# 使用 Makefile（如果已安装 make）
make build      # 构建镜像
make up         # 启动服务
make down       # 停止服务
make logs       # 查看日志
make restart    # 重启服务

# 或直接使用 docker-compose
docker-compose build
docker-compose up -d
docker-compose down
docker-compose logs -f
```

### 配置文件

漏洞卡片配置文件位于 `configs/` 目录，使用 YAML 格式。可以参考 `configs/sql-injection.yaml` 创建新的漏洞卡片。

## 配置文件格式

配置文件使用 YAML 格式，包含以下主要部分：

- `name`: 漏洞名称
- `title`: 卡片标题
- `severity`: 严重程度（显示文本）
- `severity_level`: 严重程度等级（high/medium/low）
- `threat_level`: 威胁等级（严重/高危/中危/低危）
- `cvss_score`: CVSS 评分（0.0-10.0，可选）
- `cvss_vector`: CVSS 向量（可选）
- `cve`: CVE 编号（可选）
- `icon`: Font Awesome 图标类名
- `description`: 描述
- `perspectives`: 视角列表
  - `id`: 视角 ID
  - `name`: 视角名称
  - `icon`: 图标
  - `content`: 内容（支持列布局、信息框、代码示例、表格等）

详细格式请参考 `configs/sql-injection.yaml` 或 `configs/shiro-cve-2016-6802.yaml`。

关于 CVSS 评分和威胁等级的详细说明，请参考 [CVSS 评分指南](docs/cvss-guide.md)。

## API 接口

- `GET /api/vulnerabilities` - 获取所有漏洞卡片列表
- `GET /api/vulnerabilities/:id` - 获取指定漏洞卡片详情
- `PUT /api/vulnerabilities/:id` - 保存漏洞卡片

## 技术栈

- **后端**: Go 1.21+, Gin
- **前端**: Vue 3, Element Plus, Vue Router
- **配置**: YAML
- **图标**: Font Awesome 6.4.0

## 开发说明

### 添加新漏洞卡片

1. 在 `configs/` 目录创建新的 YAML 文件（如 `xss.yaml`）
2. 按照 `sql-injection.yaml` 的格式编写配置
3. 重启后端服务或刷新前端页面即可看到新卡片

### 自定义样式

前端样式主要在以下文件中：

- `frontend/src/views/CardView.vue` - 主卡片视图样式
- `frontend/src/components/*.vue` - 各组件样式

## 微信公众号集成

本项目支持在微信公众号中嵌入漏洞卡片。详细方案请参考 [微信公众号集成文档](docs/wechat-integration.md)。

### 快速开始

1. **部署应用**：将前端和后端部署到支持 HTTPS 的服务器
2. **在公众号文章中**：插入链接或二维码，指向漏洞卡片页面
3. **用户点击**：在微信内置浏览器中打开，享受完整的交互体验

## 许可证

MIT
