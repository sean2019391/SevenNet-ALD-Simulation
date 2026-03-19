# SimpleNN — Setup Guide

SimpleNN is a neural network potential framework for generating machine-learning interatomic potentials.

---

## Prerequisites

| Requirement | Version |
|---|---|
| Python | 3.6 — 3.9 |
| PyTorch | 1.5.0 — 1.10.1 |
| LAMMPS | > 29 Oct 2020 |

---

## Installation

### 1. Create conda environment
```bash
conda create -n simplenn python=3.9
conda activate simplenn
```
> For conda installation instructions, see [CHGNET.md](CHGNET.md).

### 2. Install PyTorch (CPU-only)
```bash
conda install pytorch==1.10.1 torchvision==0.11.2 torchaudio==0.10.1 cpuonly -c pytorch
```

### 3. Install LAMMPS
```bash
mkdir mylammps && cd mylammps
wget https://download.lammps.org/tars/lammps.tar.gz
tar -xzvf lammps.tar.gz
cd lammps-29Aug2024/src
make mpi    # Build parallel LAMMPS executable
make
```
