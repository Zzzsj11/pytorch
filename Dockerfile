# 基础镜像还是 torch2.0.1 + cu117
FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-devel

# 环境变量
ENV FORCE_CUDA="1" \
    TORCH_CUDA_ARCH_LIST="7.0;7.5;8.0;8.6+PTX" \
    PATH="/opt/conda/bin:$PATH"

# 常规依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
        git curl vim wget build-essential ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 升级 pip 并装基础包
RUN pip install --upgrade pip setuptools wheel -i https://pypi.tuna.tsinghua.edu.cn/simple \
 && pip install openmim -i https://pypi.tuna.tsinghua.edu.cn/simple \
 && pip install tensorboardX ptflops==0.7 wandb fvcore openpyxl timm==0.5.4 -i https://pypi.tuna.tsinghua.edu.cn/simple

# 指定安装 mmcv==2.0.1，使用官方 cu117+torch2.0 的索引
RUN pip install mmcv==2.0.1 \
    -f https://download.openmmlab.com/mmcv/dist/cu117/torch2.0/index.html

# 安装 mmdet==3.0.0rc6（跟 mmcv 2.x 匹配）
RUN pip install mmdet==3.0.0rc6 -i https://pypi.tuna.tsinghua.edu.cn/simple
