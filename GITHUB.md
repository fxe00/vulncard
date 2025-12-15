# 上传项目到 GitHub 指南

## 步骤 1: 在 GitHub 上创建仓库

1. 登录 GitHub
2. 点击右上角的 "+" 号，选择 "New repository"
3. 填写仓库信息：
   - Repository name: `vulncard`（或你喜欢的名称）
   - Description: `漏洞卡片管理系统 - 用于收录和展示漏洞信息的交互式卡片系统`
   - 选择 Public 或 Private
   - **不要**勾选 "Initialize this repository with a README"（因为本地已有代码）
4. 点击 "Create repository"

## 步骤 2: 初始化本地 Git 仓库

```bash
# 在项目根目录执行
cd /Users/fxe00/code/go/vulncard

# 初始化 Git 仓库
git init

# 添加所有文件到暂存区
git add .

# 提交代码
git commit -m "Initial commit: 漏洞卡片管理系统"
```

## 步骤 3: 连接到 GitHub 远程仓库

```bash
# 添加远程仓库（将 YOUR_USERNAME 替换为你的 GitHub 用户名）
git remote add origin https://github.com/YOUR_USERNAME/vulncard.git

# 或者使用 SSH（如果你配置了 SSH key）
# git remote add origin git@github.com:YOUR_USERNAME/vulncard.git

# 查看远程仓库配置
git remote -v
```

## 步骤 4: 推送到 GitHub

```bash
# 推送代码到 GitHub（首次推送）
git branch -M main
git push -u origin main
```

## 后续更新代码

```bash
# 查看修改状态
git status

# 添加修改的文件
git add .

# 提交修改
git commit -m "描述你的修改内容"

# 推送到 GitHub
git push
```

## 常用 Git 命令

```bash
# 查看提交历史
git log --oneline

# 查看文件变更
git diff

# 创建新分支
git checkout -b feature/新功能名称

# 切换分支
git checkout main

# 合并分支
git merge feature/新功能名称

# 查看远程仓库信息
git remote -v

# 拉取最新代码
git pull origin main
```

## 注意事项

1. **敏感信息**：确保 `.env` 文件已添加到 `.gitignore`，不要提交包含 API 密钥、密码等敏感信息的文件

2. **大文件**：如果项目中有大文件，考虑使用 Git LFS（Large File Storage）

3. **提交信息**：使用有意义的提交信息，描述清楚每次修改的内容

4. **分支策略**：
   - `main` 分支：稳定版本
   - `develop` 分支：开发版本
   - `feature/*` 分支：新功能开发

## 项目结构说明

```
vulncard/
├── backend/          # Go 后端服务
├── frontend/         # Vue 前端应用
├── configs/          # 漏洞卡片配置文件（YAML）
├── docs/             # 项目文档
├── docker-compose.yml # Docker 编排配置
└── README.md         # 项目说明文档
```

## 许可证

建议在项目根目录添加 `LICENSE` 文件，选择合适的开源许可证（如 MIT、Apache 2.0 等）。
