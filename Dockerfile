# ---------- 基础镜像 ----------
FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-devel

# ---------- 基本环境变量 ----------
ENV DEBIAN_FRONTEND=noninteractive \
    TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0+PTX" \
    TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
    CMAKE_PREFIX_PATH="$(dirname $(which conda))/../"

# ---------- 系统依赖 ----------
RUN apt-get update && apt-get install -y \
    ffmpeg libsm6 libxext6 git ninja-build libglib2.0-0 libxrender-dev wget curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ---------- Python 依赖 ----------
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# ---------- 安装 OpenMMLab 栈 ----------
# 安装 openmim
RUN pip install --no-cache-dir openmim

# 固定版本：mmengine, mmcv, mmdet
RUN mim install "mmengine==0.7.1"
RUN pip install mmcv==2.0.1 -f https://download.openmmlab.com/mmcv/dist/cu117/torch2.0/index.html
RUN pip install mmdet==3.0.0rc6

# ---------- 安装 torchvision 对齐 Torch ----------
# Torch 2.0.1 <-> torchvision 0.15.2
RUN pip install --no-cache-dir torchvision==0.15.2

# ---------- 安装其他常用依赖 ----------
RUN pip install --no-cache-dir tensorboardX ptflops==0.7 wandb fvcore openpyxl timm==0.5.4

# ---------- 安装 MMRotate ----------
WORKDIR /mmrotate
RUN git clone https://github.com/open-mmlab/mmrotate.git -b 1.x .
RUN pip install -r requirements/build.txt
RUN pip install --no-cache-dir -e .

# 默认启动目录
WORKDIR /mmrotate
