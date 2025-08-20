# ========= Base: Torch 2.0.1 + CUDA 11.7 =========
FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-devel

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple

# 常用依赖 & 编译工具（mmcv/mmdet/可视化常见依赖）
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential ninja-build git curl ca-certificates \
    libgl1-mesa-glx libglib2.0-0 ffmpeg && \
    rm -rf /var/lib/apt/lists/*

# Python 基础工具 & 你的第三方包
RUN pip install --upgrade pip setuptools wheel && \
    pip install openmim tensorboardX ptflops==0.7 wandb fvcore openpyxl timm==0.5.4 && \
    pip install "yapf>=0.40.0" "scipy==1.10.1"

# MM 系列（严格按你的要求）
# 1) mmengine：与 mmcv/mmdet/mmrotate 1.x 兼容
RUN pip install "mmengine>=0.10.0,<1.0.0"
# 2) mmcv==2.0.1 从 cu117/torch2.0 的官方索引安装
#    若遇到官方站证书问题，--trusted-host 可避免校验证书导致的失败
RUN pip install mmcv==2.0.1 \
    -f https://download.openmmlab.com/mmcv/dist/cu117/torch2.0/index.html \
    --trusted-host download.openmmlab.com
# 3) mmdet==3.0.0rc6
RUN pip install mmdet==3.0.0rc6

WORKDIR /workspace
CMD ["/bin/bash"]
