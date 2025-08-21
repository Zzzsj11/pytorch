# 基础镜像：PyTorch 2.0.1 + CUDA 11.7 + cuDNN8
FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-devel

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive

# 安装基本依赖
RUN apt-get update && apt-get install -y \
    git \
    wget \
    vim \
    curl \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# 创建 Conda 环境（可选，也可以直接用系统 Python）
RUN conda create -n openmmlab python=3.8 -y && \
    echo "conda activate openmmlab" >> ~/.bashrc
SHELL ["/bin/bash", "--login", "-c"]

# 激活环境
RUN conda activate openmmlab && \
    pip install --upgrade pip && \
    pip install -U openmim && \
    mim install mmengine && \
    pip install mmcv==2.0.1 -f https://download.openmmlab.com/mmcv/dist/cu117/torch2.0/index.html && \
    pip install mmdet==3.0.0rc6

# 将 mmrotate 源码复制进容器（假设 mmrotate 源码和 Dockerfile 在同一目录）
WORKDIR /workspace/mmrotate
COPY . /workspace/mmrotate

# 开发模式安装 mmrotate
RUN conda activate openmmlab && pip install -v -e .

# 默认进入 bash
CMD ["/bin/bash"]
