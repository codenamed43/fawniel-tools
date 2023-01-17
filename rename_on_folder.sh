#!/bin/bash
# 
# 按照名称顺序重新命名文件为：所在文件夹名（编号）形式

# $# 变量表示脚本传入的参数个数
if [ $# -eq 0 ]; then
    echo "Usage: script.sh path/to/folder"
    exit 1
fi

folder=${1}
count=1

# 检查文件夹是否为空。如果是空的话，给出提示信息并退出脚本。
# -quit : 这个选项告诉 find 命令只在找到第一个文件时退出。
# grep -q 可以用来判断一个文件中是否包含某个字符串或者文本，而不需要输出匹配项的内容,只返回0或1。适用于在 shell 脚本中进行条件判断
if find "$folder" -mindepth 1 -print -quit | grep -q .; then
    for file in $(find "$folder" -type f); do
        filename=$(basename "$file")
        foldername=$(basename $(dirname "$file"))
        if [ "$foldername" != "$prev_foldername" ]; then
            count=1
        fi
        new_filename="$foldername($count)$filename"
        mv "$file" "$new_filename"
        count=$((count+1))
        prev_foldername=$foldername
    done
else
    echo "The folder is empty"
fi
