#!/bin/bash

# 批量压缩图片

# 检查是否提供了所需的参数
if [ $# -ne 3 ]; then
    echo "用法: $0 源文件夹 压缩质量(范围是0-51,0表示最高质量) 目标文件夹"
    exit 1
fi

# 将输入参数分配给变量
src_folder=$1
quality=$2
target_folder=$3

# 检查目标文件夹是否存在，如果不存在则创建
if [ ! -d "$target_folder" ]; then
    mkdir -p "$target_folder"
fi

# 遍历源文件夹中的所有文件和文件夹
for file in $(find "$src_folder" -type f); do
    # 获取文件在源文件夹中的相对路径
    rel_path=$(echo "$file" | awk -F "$src_folder/" '{print $2}')
    # 创建目标文件夹结构
    target_path="$target_folder/$(dirname "$rel_path")"
    if [ ! -d "$target_path" ]; then
        mkdir -p "$target_path"
    fi
    # 使用ffmpeg压缩图片
    ffmpeg -i "$file" -q:v "$quality" "$target_path/$(basename "$file")"
done
