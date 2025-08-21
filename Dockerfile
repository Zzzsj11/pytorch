# 基础镜像，按你的环境选择合适的 CUDA + PyTorch 版本
# 这里示例用 PyTorch 2.0 + CUDA 11.7
FROM pytorch/pytorch:2.0.0-cuda11.7-cudnn8-runtime

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    git build-essential cmake ninja-build libgl1 libglib2.0-0 ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 升级 pip
RUN python -m pip install -U pip setuptools wheel

# 安装 OpenMMLab 依赖
RUN python -m pip install "mmengine>=0.6.0,<1.0.0" \
    "mmdet==3.0.0rc6"

# 关键：修复 numpy / scipy / yapf 版本
# - numpy 降级到 1.22.x（兼容 SciPy）
# - 升级 yapf >=0.40（支持 verify 参数）
RUN python -m pip install "numpy>=1.21,<1.23" "scipy>=1.7,<1.9" "yapf>=0.40"

# 编译安装 mmcv (从源码，避免证书过期的问题)
RUN git clone --depth 1 --branch v2.0.1 https://github.com/open-mmlab/mmcv.git /opt/mmcv && \
    python -m pip install -U ninja cmake && \
    bash -lc 'export MMCV_WITH_OPS=1 FORCE_CUDA=1 TORCH_CUDA_ARCH_LIST="7.0;7.5;8.0;8.6" && \
              python -m pip install -v -e /opt/mmcv'

# 设置工作目录
WORKDIR /workspace

# 默认启动命令
CMD ["/bin/bash"]
