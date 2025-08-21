# Dockerfile（基于 PyTorch 2.0 / CUDA 11.7 运行时）
FROM pytorch/pytorch:2.0.0-cuda11.7-cudnn8-runtime

ENV DEBIAN_FRONTEND=noninteractive PIP_NO_CACHE_DIR=1
RUN apt-get update && apt-get install -y --no-install-recommends \
    git build-essential cmake ninja-build libgl1 libglib2.0-0 ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Python 基础
RUN python -m pip install -U pip setuptools wheel

# mmengine + mmdet（来自 PyPI）
RUN python -m pip install "mmengine>=0.6.0,<1.0.0" "mmdet==3.0.0rc6"

# 从 GitHub 源码编译 mmcv==2.0.1（不访问 openmmlab 下载站）
RUN git clone --depth 1 --branch v2.0.1 https://github.com/open-mmlab/mmcv.git /opt/mmcv && \
    python -m pip install -U ninja cmake && \
    bash -lc 'export MMCV_WITH_OPS=1 FORCE_CUDA=1 TORCH_CUDA_ARCH_LIST="7.0;7.5;8.0;8.6" && \
              python -m pip install -v -e /opt/mmcv'

WORKDIR /workspace
CMD ["/bin/bash"]
