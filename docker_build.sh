#!/bin/bash
# docker build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) -t shmem-triton:latest .
# docker build -t shmem-triton:latest .
set -e
set -x
MY_KEY=$(cat ~/.ssh/id_rsa)
# get cuda arch
CUDA_ARCH=$(nvidia-smi --query-gpu=compute_cap --format=csv | tail -n +2 | head -n 1 | sed 's/\./ /g' | awk '{printf "%d%d", $1, $2}')
# build
sudo docker build --build-arg SSH_KEY="$MY_KEY" --build-arg ARCH="$CUDA_ARCH" $@ .