import os
import shutil
import sys
from tqdm import tqdm

def copy_files(src, dest):
    # 获取源文件夹下的所有文件路径
    paths = []
    for root, dirs, files in os.walk(src):
        for file in files:
            # 忽略隐藏文件
            if not file.startswith('.'):
                path = os.path.join(root, file)
                paths.append(path)

    # 创建进度条
    pbar = tqdm(total=len(paths))

    # 复制文件
    for path in paths:
        filename = os.path.basename(path)
        dest_path = os.path.join(dest, filename)

        # 如果文件已经存在，则自动重命名
        if os.path.exists(dest_path):
            i = 1
            while True:
                new_filename = f"{filename} ({i})"
                new_path = os.path.join(dest, new_filename)
                if not os.path.exists(new_path):
                    dest_path = new_path
                    break
                i += 1

        shutil.copy2(path, dest_path)

        # 更新进度条
        pbar.update(1)

    # 关闭进度条
    pbar.close()

if __name__ == "__main__":
    # 获取命令行参数
    src = sys.argv[1]
    dest = sys.argv[2]

    # 如果源文件夹不存在，则打印错误提示
    if not os.path.exists(src):
        print(f"文件夹 {src} 不存在")
        sys.exit(1)

    # 如果目标文件夹不存在，则自动新建
    if not os.path.exists(dest):
        os.makedirs(dest)

    copy_files(src, dest)
