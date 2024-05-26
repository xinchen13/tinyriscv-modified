import sys
import os


# 主函数
def main():
    filename = sys.argv[1]
    file_extension = os.path.splitext(filename)[1]

    if file_extension == ".bin":
        cmd = r'python ../tools/BinToMem_CLI.py' + ' ' + sys.argv[1] + ' ' + sys.argv[2]
        f = os.popen(cmd)
        f.close()
    elif file_extension == ".data":
        # 1.copy目标Mem文件到本地
        cmd = r'cp' + ' ' + sys.argv[1] + ' ' + sys.argv[2]
        f = os.popen(cmd)
        f.close()
    else:
        print("Usage: provide .bin or .data")
        sys.exit(1)

if __name__ == '__main__':
    sys.exit(main())