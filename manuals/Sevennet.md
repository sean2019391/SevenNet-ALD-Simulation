# SevenNet — Quick Reference Guide

SevenNet is an E(3)-equivariant graph neural network interatomic potential. This document is a compact command reference. For a detailed walkthrough, see `SangwonTheGreat/01_LAMMPS_Setup.md`.

---

## 1. Prerequisites

### Install Anaconda (if not already installed)
```bash
wget https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh
bash Anaconda3-latest-Linux-x86_64.sh
export PATH="/home/<your_username>/anaconda3/bin:$PATH"
exec $SHELL        # Restart shell
conda --version    # Verify installation
```

### Create conda environment
```bash
conda create -n sevn python=3.9
conda activate sevn
```

### Install PyTorch
> **Important:** The PyTorch version used for fine-tuning must match the version used to compile LAMMPS.

```bash
conda install pytorch==2.4.1 torchvision==0.19.1 torchaudio==2.4.1 pytorch-cuda=11.8 -c pytorch -c nvidia
conda install mkl-include    # Prevents MKL-related errors
```

---

## 2. Install SevenNet

```bash
pip install sevenn
```

---

## 3. Set CUDA Paths

Add these to `~/.bashrc` so they persist across sessions:
```bash
export PATH=/opt/openmpi/bin:/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/opt/openmpi/lib:/usr/local/cuda/lib64:$LD_LIBRARY_PATH
```

---

## 4. Build LAMMPS with SevenNet Support

### Download LAMMPS
```bash
git clone https://github.com/lammps/lammps.git lammps_sevenn --branch stable_2Aug2023_update3 --depth=1
```

### Apply SevenNet patch
```bash
sevenn_patch_lammps ./lammps_sevenn           # Standard patch
# OR with D3 dispersion correction (works with sevenn >= 0.10.1):
sevenn_patch_lammps ./lammps_sevenn --d3
```

### Install cmake and compile
```bash
conda install cmake
cd ./lammps_sevenn
mkdir build && cd build
cmake ../cmake -DCMAKE_PREFIX_PATH=`python -c 'import torch;print(torch.utils.cmake_prefix_path)'` -DMKL_INCLUDE_DIR=$CONDA_PREFIX/include
make -j4
```

---

## 5. Get a Pre-Trained Model

```bash
sevenn_get_model 7net-0       # Serial model (deployed_serial.pt)
sevenn_get_model 7net-0 -p    # Parallel model (deployed_parallel.pt)
```

---

## 6. Run LAMMPS with SevenNet

### Serial (single process)
```bash
/path/to/lammps_sevenn/build/lmp -in in.lmp
```

### With auto-GPU queue script
```bash
#!/bin/bash
available_gpus=($(nvidia-smi --query-gpu=index --format=csv,noheader))
is_gpu_free() {
  gpu_id=$1
  nvidia-smi --query-compute-apps=gpu_uuid --format=csv,noheader -i $gpu_id | grep -q .
  return $?
}
for gpu in "${available_gpus[@]}"; do
  if ! is_gpu_free $gpu; then
    export CUDA_VISIBLE_DEVICES=$gpu
    echo "Using GPU $gpu"
    break
  fi
done
/path/to/lammps_sevenn/build/lmp -in in.lmp
```
```bash
tsp bash queue_job.sh
```

### Parallel (multi-process with MPI)
```bash
mpirun -np 4 --mca pml ob1 --mca btl ^openib /path/to/lammps_sevenn/build/lmp -in in.lmp
```

> **Note:** Parallel runs have similar computation time to serial but use less memory per process.

---

## 7. Fine-Tuning

### Generate configuration file
```bash
sevenn_preset sevennet-0 > input.yaml    # For pre-trained model fine-tuning
# OR
sevenn_preset fine_tune > input.yaml
```

### Edit input.yaml
```yaml
load_trainset_path: ["/path/to/dataset_1/*", "/path/to/dataset_2/*"]
# load_validset_path and load_testset_path are optional — comment them out if not needed
```

### Run fine-tuning
```bash
sevenn input.yaml -s
```

> If Python version errors occur, verify that the conda environment uses a compatible Python version.

### Export the trained model
```bash
sevenn_get_model checkpoint_best.pth       # Creates deployed_serial.pt
sevenn_get_model checkpoint_best.pth -p    # Creates deployed_parallel.pt
```

> **Important:** `checkpoint_*.pth` files are training checkpoints, NOT deployable models. You must run `sevenn_get_model` to create `deployed_serial.pt` / `deployed_parallel.pt`.
