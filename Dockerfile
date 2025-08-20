# ===== Base: Torch 2.0.1 + CUDA 11.7（匹配 mmcv==2.0.1 的 cu117/torch2.0 组合）=====
FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-devel

# ---- 常用系统依赖 & 编译工具 ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential cmake ninja-build \
    libgl1-mesa-glx libglib2.0-0 libsm6 libxext6 libxrender1 ffmpeg \
    git curl zip nano psmisc ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# ---- Python 基础工具 & 国内镜像（可按需更换）----
ENV PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"
RUN pip install -U pip setuptools wheel openmim

# ---- 你列的依赖（走镜像站）----
RUN pip install tensorboardX ptflops==0.7 wandb fvcore openpyxl timm==0.5.4

# ---- 核心版本：mmdet 3.x、mmcv 2.x（mmcv 源码编译，避开证书问题）----
# mmdet 3.0.0rc6：与 mmrotate 1.x 体系兼容
RUN pip install "mmdet==3.0.0rc6"
# mmcv 2.0.1：用源码编译，避免去 download.openmmlab.com 拉 whl
RUN pip install --no-binary mmcv "mmcv==2.0.1"

# ---- 常见兼容修复 ----
# 1) mmengine pretty_text 需要新 yapf 的 verify 参数
# 2) Py3.8 + numpy 1.24.x 下，scipy 建议 1.10.1
RUN pip install "yapf>=0.40.0" "scipy==1.10.1"
