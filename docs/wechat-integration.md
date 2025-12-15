# 微信公众号嵌入漏洞卡片方案

## 方案概述

微信公众号嵌入交互式内容有几种方式，针对漏洞卡片这种复杂的交互式组件，推荐以下方案：

## 方案一：外部链接跳转（推荐）

### 优点

- ✅ 完全保留交互功能
- ✅ 实现简单，无需额外开发
- ✅ 支持所有 Vue 组件和交互

### 实现方式

1. **部署前端应用**

   - 将前端应用部署到可访问的服务器（如：`https://yourdomain.com`）
   - 确保可以通过 HTTPS 访问（微信公众号要求）

2. **在公众号文章中嵌入**

   ```html
   <a href="https://yourdomain.com/card/sql-injection">查看 SQL 注入漏洞卡片</a>
   ```

   或者使用公众号编辑器的"插入链接"功能

3. **生成二维码**
   - 在文章中插入二维码图片
   - 用户扫码后跳转到漏洞卡片页面

### 示例代码

在公众号图文消息中：

```
【漏洞卡片展示】

点击下方链接或扫描二维码查看详细的 SQL 注入漏洞卡片：

🔗 查看漏洞卡片：https://yourdomain.com/card/sql-injection

[二维码图片]
```

## 方案二：小程序（适合长期使用）

### 优点

- ✅ 用户体验好，无需跳转
- ✅ 可以集成到公众号菜单
- ✅ 支持复杂交互

### 实现方式

1. **开发微信小程序**

   - 将 Vue 组件转换为小程序组件
   - 使用小程序框架（如 uni-app、Taro）可以复用部分代码

2. **在公众号中关联小程序**
   - 在公众号菜单中添加小程序入口
   - 在文章中插入小程序卡片

## 方案三：简化版 HTML（适合简单展示）

### 优点

- ✅ 可以直接嵌入公众号编辑器
- ✅ 无需跳转

### 缺点

- ❌ 功能受限（公众号编辑器不支持 JavaScript）
- ❌ 无法实现交互式切换视角
- ❌ 只能展示静态内容

### 实现方式

如果只需要静态展示，可以：

1. 将每个视角的内容分别截图
2. 在公众号文章中插入图片
3. 或者使用公众号支持的 HTML 标签（如表格、列表等）

## 推荐方案

**建议使用方案一（外部链接跳转）**，因为：

1. 实现最简单，无需额外开发
2. 完全保留所有交互功能
3. 用户体验良好（点击即打开）
4. 可以分享给其他平台

## 部署建议

### 前端部署

1. **构建生产版本**

   ```bash
   cd frontend
   npm run build
   ```

2. **部署到服务器**

   - 使用 Nginx 部署 `dist` 目录
   - 配置 HTTPS（必需）
   - 配置路由支持（SPA 应用）

3. **Nginx 配置示例**
   ```nginx
   server {
       listen 443 ssl;
       server_name yourdomain.com;

       ssl_certificate /path/to/cert.pem;
       ssl_certificate_key /path/to/key.pem;

       root /path/to/frontend/dist;
       index index.html;

       location / {
           try_files $uri $uri/ /index.html;
       }

       location /api {
           proxy_pass http://localhost:8080;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
       }
   }
   ```

### 后端部署

1. **编译 Go 程序**

   ```bash
   cd backend
   go build -o vulncard-server main.go
   ```

2. **使用 systemd 或 supervisor 管理服务**
   ```ini
   [program:vulncard]
   command=/path/to/vulncard-server
   directory=/path/to/backend
   autostart=true
   autorestart=true
   ```

## 公众号文章示例

```
📋 SQL 注入漏洞详解

SQL 注入是 Web 安全中最常见的漏洞之一。我们为您准备了一个交互式的漏洞卡片，帮助您从多个角度理解这个漏洞。

🔍 卡片包含以下视角：
• 漏洞概述 - 了解基本概念和原理
• 受害者视角 - 了解可能遭受的损害
• 攻击者视角 - 了解攻击方法和工具
• 代码触发 - 查看代码示例和修复方案

👉 点击下方链接查看完整卡片：
https://yourdomain.com/card/sql-injection

或者扫描二维码：
[二维码]
```

## 注意事项

1. **HTTPS 必需**：微信公众号要求所有外部链接必须使用 HTTPS
2. **域名备案**：如果使用国内服务器，需要域名备案
3. **移动端适配**：确保卡片在手机端显示正常
4. **加载速度**：优化资源加载，确保在微信中打开速度快
