FROM docker.io/nvidia/cuda:12.1.0-cudnn8-devel-ubuntu20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

RUN apt-get update && \
    echo "Asia\nShanghai" | apt-get install -y tzdata && \
    apt-get install --reinstall zlibc zlib1g zlib1g-dev && \
    apt-get install libffi-dev libssl-dev libreadline-dev -y && \
    apt-get install -y \
    apt-utils \
    git \
    curl \
    ca-certificates \
    dirmngr \
    gpg \
    wget \
    vim \
    nano \
    zsh \
    autojump \
    screen \
    tmux \
    mpich \
    glibc-doc \
    manpages-posix-dev \
    ninja-build \
    build-essential nghttp2 libnghttp2-dev libssl-dev && \
    apt-get clean

# Install Python3.10
RUN wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz && \
    tar -zxf Python-3.10.0.tgz && \
    cd Python-3.10.0 && \
    ./configure --prefix=/usr/local/python3 && \
    ./configure --enable-optimizations && \
    make -j8 && \
    make install && \
    rm -rf /usr/bin/python3 && \
    ln -s /usr/local/bin/python3.10 /usr/bin/python && \
    ln -s /usr/local/bin/python3.10 /usr/bin/python3 && \
    ln -s /usr/local/bin/pip3 /usr/bin/pip && \
    cd .. && \
    rm -rf Python-3.10.0 Python-3.10.0.tgz

# Install zsh
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.0/zsh-in-docker.sh)" -- \
        -p git \
        -p github \
        -p colorize \
        -p colored-man-pages \
        -p brew \
        -p docker \
        -p docker-compose \
        -p autojump \
        -p python \
        -p autopep8 \
        -p extract \
        -p tmux \
        -p https://github.com/zsh-users/zsh-autosuggestions \
        -p https://github.com/zsh-users/zsh-syntax-highlighting

# Install cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.19.7/cmake-3.19.7-Linux-x86_64.sh && \
    chmod +x cmake-3.19.7-Linux-x86_64.sh && \
    ./cmake-3.19.7-Linux-x86_64.sh --skip-license --prefix=/usr/local && \
    rm cmake-3.19.7-Linux-x86_64.sh && \
    # verify installation equals to 3.19.7
    cmake --version | grep "3.19.7" || (echo "cmake version is not 3.19.7" && exit 1)

RUN mkdir -p /workspace/flux


