# judge if nvshmem is already downloaded
if [ ! -f ./nvshmem_src_2.11.0-5.txz ]; then
    echo "nvshmem is not downloaded, downloading..."
    wget https://developer.nvidia.com/downloads/assets/secure/nvshmem/nvshmem_src_2.11.0-5.txz
else
    echo "nvshmem is already downloaded"
fi
tar -xvJf nvshmem_src_2.11.0-5.txz
mv nvshmem_src_2.11.0-5 ./3rdparty/nvshmem
