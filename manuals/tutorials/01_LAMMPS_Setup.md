# Part 1: Complete LAMMPS + SevenNet Environment Setup

This guide takes you from a blank Linux machine to a fully working LAMMPS installation with SevenNet (machine-learning force field) support. Every step is explained so you understand not just *what* to type, but *why*.

---

## Step 1: Install Miniconda

Conda is a package and virtual environment manager. It keeps your Python libraries organized and isolated so different projects don't conflict with each other.

**Download the installer:**
```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
```

**Run the installer:**
```bash
bash Miniconda3-latest-Linux-x86_64.sh
```
When the license agreement appears, type `yes` to accept.

**Add conda to your PATH:**
```bash
export PATH="/home/<your_username>/miniconda3/bin:$PATH"
```

**Verify it works:**
```bash
conda --version
```

---

## Step 2: Create a Conda Environment

A conda environment is an isolated workspace with its own Python version and packages.

```bash
conda create -n sevn python=3.10
```

This creates an environment called `sevn` with Python 3.10.

**Check your environments:**
```bash
conda env list
```
You should see `sevn` in the list.

**Activate the environment:**
```bash
conda activate sevn
```
Your terminal prompt should change from `(base)` to `(sevn)`.

> **Remember:** Always activate this environment before working with SevenNet or LAMMPS.

---

## Step 3: Install PyTorch

PyTorch is the deep learning framework that SevenNet is built on. It **must be installed before SevenNet**.

**Compatible versions:**
- Python >= 3.8
- PyTorch >= 1.12.0 and < 2.5.0
- Recommended: PyTorch 2.2.2 + CUDA 12.1, or PyTorch 1.13.1 + CUDA 12.1

**For GPU (NVIDIA CUDA 11.8):**
```bash
pip install torch --index-url https://download.pytorch.org/whl/cu118
```

**For CPU only:**
```bash
pip install torch
```

**Prevent MKL-related errors** (Intel Math Kernel Library issues):
```bash
conda install mkl-include
```

> **Important:** Install PyTorch *before* SevenNet. The order matters.

---

## Step 4: Install SevenNet

SevenNet is a graph neural network-based interatomic potential. In LAMMPS input scripts, `pair_style e3gnn` means "use SevenNet."

```bash
pip install sevenn
```

You can also clone the official repository for examples and data:
```bash
git clone https://github.com/lammps/lammps.git
```

---

## Step 5: Set CUDA Paths

These environment variables tell the system where to find GPU libraries. Add them to `~/.bashrc` so they persist across sessions:

```bash
export PATH=/opt/openmpi/bin:/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/opt/openmpi/lib:/usr/local/cuda/lib64:$LD_LIBRARY_PATH
```

After editing `~/.bashrc`, reload it:
```bash
source ~/.bashrc
```

---

## Step 6: Download and Patch LAMMPS

LAMMPS (Large-scale Atomic/Molecular Massively Parallel Simulator) is the MD simulation engine.

**Download a SevenNet-compatible version:**
```bash
git clone https://github.com/lammps/lammps.git lammps_sevenn --branch stable_2Aug2023_update3 --depth=1
```

**Apply the SevenNet patch:**
```bash
sevenn_patch_lammps ./lammps_sevenn
```

This modifies the LAMMPS source code to recognize the `pair_style e3gnn` command.

---

## Step 7: Install CMake and Compile LAMMPS

CMake is a build system that converts source code into an executable program.

```bash
conda install cmake
# If that fails:
pip install cmake
```

**Compile LAMMPS:**
```bash
cd ./lammps_sevenn
mkdir build
cd build
cmake ../cmake -DCMAKE_PREFIX_PATH=`python -c 'import torch;print(torch.utils.cmake_prefix_path)'` -DMKL_INCLUDE_DIR=$CONDA_PREFIX/include
make -j4
```

After compilation, the executable is at: `lammps_sevenn/build/lmp`

---

## Step 8: Run Your First Simulation

**Activate the environment:**
```bash
conda activate sevn
```

**Run a serial SevenNet example:**
```bash
cd ~/SevenNet/example_inputs/md_serial_example
~/lammps_sevenn/build/lmp -in in.lmp
```

This runs LAMMPS using the `in.lmp` input script, which uses `pair_style e3gnn` (SevenNet).

**Run a parallel example:**
```bash
cd ~/SevenNet/example_inputs/md_parallel_example
~/lammps_sevenn/build/lmp -in in.lmp
```

> **Critical concept:** The LAMMPS executable you use depends on the `pair_style` in your input script:
> - `pair_style e3gnn` (SevenNet) → use `lammps_sevenn/build/lmp`
> - `pair_style sw`, `tersoff`, etc. → use the standard `lammps/build/lmp`

**If LAMMPS runs on CPU instead of GPU** (noticeably slow), force GPU usage:
```bash
~/lammps_sevenn/build/lmp -in in.lmp -sf gpu -pk gpu 1
```
The `-sf gpu -pk gpu 1` flags tell LAMMPS to use 1 GPU. Change the number (1–4) based on available GPUs.

**Check the output:** Read the `log.lammps` file to see thermodynamic output from your simulation.

---

## Summary of What You've Built

| Component | Location | Purpose |
|-----------|----------|---------|
| Conda environment `sevn` | System-wide | Isolated Python + PyTorch + SevenNet |
| SevenNet | `~/SevenNet/` | ML force field source code and examples |
| Standard LAMMPS | `~/lammps/build/lmp` | For conventional force fields (SW, Tersoff, etc.) |
| SevenNet LAMMPS | `~/lammps_sevenn/build/lmp` | For `pair_style e3gnn` |

---

**Next:** Go to [02_SevenNet_Tutorials.md](02_SevenNet_Tutorials.md) to run actual simulation tutorials.
