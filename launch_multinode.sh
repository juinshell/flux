#!/bin/bash
set -x
set -e
# libflux_cuda.so maybe installed under /usr/local/lib or ~/.local/lib/ by pip3
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:~/.local/lib/
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
FLUX_SRC_DIR=${SCRIPT_DIR}

# add flux python package to PYTHONPATH
export NVSHMEM_BOOTSTRAP_MPI_PLUGIN=nvshmem_bootstrap_torch.so
export NVSHMEM_DISABLE_CUDA_VMM=1 # moving from cpp to shell
export CUDA_DEVICE_MAX_CONNECTIONS=1

# set default communication env vars
export BYTED_TORCH_BYTECCL=O0
export NCCL_IB_TIMEOUT=${NCCL_IB_TIMEOUT:=23}

# nproc_per_node=$(nvidia-smi --list-gpus | wc -l)
nproc_per_node=$1
shift
nnodes=2
node_rank=$1
shift
master_addr="33.254.161.155"
master_port="23456"
additional_args="--rdzv-endpoint=${master_addr}:${master_port}"
IB_HCA=mlx5_bond_0
export NCCL_DEBUG=INFO
# export NCCL_IB_HCA=mlx5_bond_0

export NCCL_SOCKET_IFNAME=bond0


export NCCL_IB_GID_INDEX=${NCCL_IB_GID_INDEX:=3}
export NVSHMEM_IB_GID_INDEX=3


CMD="torchrun \
  --node_rank=${node_rank} \
  --nproc_per_node=${nproc_per_node} \
  --nnodes=${nnodes} \
  ${FLUX_EXTRA_TORCHRUN_ARGS} ${additional_args} $@"

echo ${CMD}
${CMD}

ret=$?
exit $ret

# ./launch_multinode.sh 4 0 test/python/ag_gemm/test_ag_kernel.py 8192 49152 12288 --dtype=float16 --iters=10
# ./launch_multinode.sh 4 1 test/python/ag_gemm/test_ag_kernel.py 8192 49152 12288 --dtype=float16 --iters=10

# export CUDA_VISIBLE_DEVICES=4,5,6,7
# ./launch_multinode.sh 4 0 test/python/gemm_rs/test_gemm_rs.py 8192 49152 12288 --dtype=float16 --iters=10
# ./launch_multinode.sh 4 1 test/python/gemm_rs/test_gemm_rs.py 8192 49152 12288 --dtype=float16 --iters=10