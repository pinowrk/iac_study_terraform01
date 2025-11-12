#!/bin/bash

# エラー時に処理を停止
set -e

# ログを記録
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "Starting user data script execution..."

# システムのアップデート
echo "Updating system packages..."
sudo yum update -y

# NGINXのインストール
echo "Installing NGINX..."
sudo yum install -y nginx

# NGINXの起動
echo "Starting NGINX service..."
sudo systemctl start nginx

# NGINX自動起動の有効化
echo "Enabling NGINX auto-start..."
sudo systemctl enable nginx

# 状態確認
echo "NGINX status:"
sudo systemctl status nginx --no-pager

echo "User data script completed successfully!"