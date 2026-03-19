# LAMMPS + ReaxFF + Intel Optimizations (CPU/HPC)

This guide covers building LAMMPS with ReaxFF support and Intel compiler optimizations for CPU-based HPC clusters.

---

## 1. Load Compiler and MPI Modules

On the IBS cluster:
```bash
module load intel impi
```

---

## 2. Create CMake Preset

Create the file `lammps/cmake/presets/reax.cmake`:

```cmake
# Frequently used packages for reactive MD
set(ALL_PACKAGES BODY CLASS2 DIPOLE KSPACE MANYBODY MISC MOLECULE QEQ REPLICA RIGID USER-MEAMC USER-REAXC USER-INTEL)

foreach(PKG ${ALL_PACKAGES})
  set(PKG_${PKG} ON CACHE BOOL "" FORCE)
endforeach()
```

---

## 3. Apply Source Fix

Edit `src/memory.cpp` and add at the top:
```cpp
#include <string.h>
```

This fixes a missing header issue in some LAMMPS versions.

---

## 4. Compile

```bash
mkdir build && cd build
cmake -C ../cmake/presets/reax.cmake -D FFT=MKL ../cmake
cmake --build .
```

---

## 5. Run with Slurm (IBS Cluster)

Create a submission script (`queue_script.sh`):

```bash
#!/bin/sh
#SBATCH --job-name=vdlab_md
#SBATCH --partition=normal_cpu
#SBATCH --nodes=1
#SBATCH --ntasks=72
#SBATCH --output=%x.o%j
#SBATCH --error=%x.e%j

module purge
module load intel impi

unset I_MPI_PMI_LIBRARY

mpirun -np 72 /path/to/lammps/build/lmp -sf intel -in in.reax
```

Submit the job:
```bash
sbatch queue_script.sh
```

> **Note:** The `-sf intel` flag enables Intel-optimized pair styles for better CPU performance.
