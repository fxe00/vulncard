#!/bin/bash

# 上传项目到 GitHub 的便捷脚本
# 使用方法: ./upload-to-github.sh

set -e

echo "🚀 开始上传项目到 GitHub..."
echo ""

# 检查是否已初始化 Git
if [ ! -d ".git" ]; then
    echo "❌ 错误: 未找到 .git 目录，请先运行 'git init'"
    exit 1
fi

# 检查是否有未提交的更改
if [ -n "$(git status --porcelain)" ]; then
    echo "📝 检测到未提交的更改，正在添加文件..."
    git add .
    
    echo ""
    echo "请输入提交信息 (直接回车使用默认信息):"
    read -r commit_message
    
    if [ -z "$commit_message" ]; then
        commit_message="Initial commit: 漏洞卡片管理系统"
    fi
    
    git commit -m "$commit_message"
    echo "✅ 代码已提交"
else
    echo "✅ 没有未提交的更改"
fi

# 检查是否已设置远程仓库
if ! git remote | grep -q "origin"; then
    echo ""
    echo "⚠️  未检测到远程仓库配置"
    echo ""
    echo "请选择连接方式:"
    echo "1) HTTPS (https://github.com/USERNAME/REPO.git)"
    echo "2) SSH (git@github.com:USERNAME/REPO.git)"
    echo ""
    read -p "请输入选项 (1 或 2): " choice
    
    if [ "$choice" = "1" ]; then
        read -p "请输入 GitHub 仓库 HTTPS 地址: " repo_url
        git remote add origin "$repo_url"
    elif [ "$choice" = "2" ]; then
        read -p "请输入 GitHub 仓库 SSH 地址: " repo_url
        git remote add origin "$repo_url"
    else
        echo "❌ 无效选项，退出"
        exit 1
    fi
fi

# 检查当前分支
current_branch=$(git branch --show-current)
if [ -z "$current_branch" ]; then
    current_branch="main"
    git branch -M main
fi

echo ""
echo "📤 正在推送到 GitHub..."
echo "   远程仓库: $(git remote get-url origin)"
echo "   分支: $current_branch"
echo ""

# 首次推送
if ! git ls-remote --heads origin "$current_branch" | grep -q "$current_branch"; then
    echo "这是首次推送，使用 'git push -u origin $current_branch'"
    git push -u origin "$current_branch"
else
    echo "推送更新到远程仓库"
    git push
fi

echo ""
echo "✅ 上传完成！"
echo ""
echo "🌐 访问你的 GitHub 仓库:"
git remote get-url origin | sed 's/\.git$//' | sed 's/git@github.com:/https:\/\/github.com\//'

