FROM nvcr.io/nvidia/pytorch:24.07-py3

WORKDIR /workspace

ARG SSH_KEY

COPY ./config /root/.ssh/config

RUN mkdir -p /root/.ssh/ && \
    echo "$SSH_KEY" > /root/.ssh/id_rsa && \
    chmod -R 700 /root/.ssh/

RUN git clone git@github.com:juinshell/flux.git

WORKDIR /workspace/flux

RUN pip install ninja packaging
RUN git submodule update --init --recursive
RUN bash ./install_deps.sh
RUN OMP_NUM_THREADS=128 ./build.sh --arch "80;89;90" --nvshmem