# CHGNet — Installation and LAMMPS Integration

CHGNet (Crystal Hamiltonian Graph Neural Network) is a universal machine-learning interatomic potential. This guide covers installation and LAMMPS setup.

---

## 1. Download LAMMPS (CHGNet Fork)

```bash
git clone https://github.com/advancesoftcorp/lammps.git
```

---

## 2. Install Anaconda

Download the installer for your system architecture:

| Architecture | Command |
|---|---|
| x86_64 (Intel/AMD) | `wget https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh` |
| aarch64 (ARM) | `wget https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-aarch64.sh` |
| ppc64le (PowerPC) | `wget https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-ppc64le.sh` |
| s390x (IBM z) | `wget https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-s390x.sh` |

Full archive: https://repo.anaconda.com/archive/

```bash
chmod +x Anaconda3-2024.06-1-Linux-{arch}.sh
./Anaconda3-2024.06-1-Linux-{arch}.sh
source ~/.bashrc
```

---

## 3. Set Up Conda Environment

```bash
conda create -n cnet python=3.10
conda activate cnet
pip install chgnet
pip install ase
pip install numpy==1.23.0
```

---

## 4. Build LAMMPS with CHGNet

```bash
cd lammps
mkdir build && cd build

# Enable required packages
cmake ../cmake -D PKG_PYTHON=ON -DPython_EXECUTABLE=$(which python3)
cmake ../cmake -D PKG_ML-CHGNET=ON
cmake ../cmake -D PKG_OPENMP=ON
cmake ../cmake -D PKG_GPU=ON

# Compile
cmake --build .
```

---

## 5. Running Simulations

| Mode | Command |
|------|---------|
| CPU (serial) | `/path/to/lmp -in inp.lammps` |
| CPU (OpenMP parallel) | `env OMP_NUM_THREADS=18 /path/to/lmp -sf omp -in inp.lammps` |
| GPU (serial) | `/path/to/lmp -in inp.lammps -sf gpu -pk gpu 1` |
| Background | Append `> output.log 2>&1 &` to any command above |

---

## 6. Slurm Queue Script (IBS Cluster)

```bash
#!/bin/sh
#SBATCH --job-name=vdlab_md
#SBATCH --partition=long_cpu
#SBATCH --nodes=1
#SBATCH --ntasks=36
#SBATCH --output=%x.o%j
#SBATCH --error=%x.e%j

module purge
module load intel

unset I_MPI_PMI_LIBRARY
export OMP_NUM_THREADS=4

/path/to/lammps_chgnet/build/lmp -sf omp -in inp_test.lammps
```

---

## 7. Wall Time Comparison

Performance tests comparing different execution environments:

- **IBS Dedicated CPU** — see benchmark images in original folder
- **Workstation CPU** — see benchmark images in original folder
- **IBS Slurm Queue (normal_cpu)** — see benchmark images in original folder

> The images are hosted on GitHub. See the original `CHGNET.md` for embedded screenshots.
