#!/bin/bash

cd frontend
if [ ! -d "node_modules" ]; then
  echo "正在安装依赖..."
  npm install
fi
npm run dev

