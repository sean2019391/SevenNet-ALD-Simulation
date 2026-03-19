# GPU-Accelerated LAMMPS with Kokkos

This guide covers compiling and running LAMMPS with GPU support using the Kokkos backend. This is the recommended approach for ReaxFF and other pair styles that support GPU acceleration.

> **Status:** Work in progress

---

## 1. Create a CMake Preset

Create a preset file at `lammps/cmake/presets/reax.cmake`:

```cmake
# Packages to enable (modify as needed)
set(ALL_PACKAGES BODY CLASS2 DIPOLE KSPACE MANYBODY MISC MEAM QEQ REAXFF GPU MOLECULE RIGID)

foreach(PKG ${ALL_PACKAGES})
  set(PKG_${PKG} ON CACHE BOOL "" FORCE)
endforeach()
```

> **Note:** Only GPU-supported packages should be included.

---

## 2. Compile LAMMPS with Kokkos + CUDA

```bash
mkdir build && cd build

cmake -C ../cmake/presets/reax.cmake \
  -D BUILD_MPI=ON \
  -D BUILD_OMP=OFF \
  -D PKG_KOKKOS=ON \
  -D Kokkos_ARCH_AMPERE86=ON \
  -D Kokkos_ENABLE_CUDA=ON \
  -D CMAKE_CUDA_COMPILER=$(which nvcc) \
  -D LAMMPS_MACHINE=gpu \
  -D GPU_API=CUDA \
  -DCMAKE_C_COMPILER=/usr/bin/gcc-11 \
  -DCMAKE_CXX_COMPILER=/usr/bin/g++-11 \
  -DCMAKE_CUDA_HOST_COMPILER=/usr/bin/gcc-11 \
  ../cmake

make -j4
```

> **GCC version matters:** CUDA requires a compatible host compiler. GCC 11 is specified explicitly here to avoid version conflicts.

---

## 3. Running on GPUs

### Serial (1 GPU)
```bash
mpirun -np 1 --mca pml ob1 --mca btl ^openib \
  /path/to/lmp_gpu -k on g 1 -sf kk -pk kokkos neigh half -in in.reax
```

### Parallel (multiple GPUs)
```bash
mpirun -np 2 --mca pml ob1 --mca btl ^openib \
  /path/to/lmp_gpu -k on g 2 -sf kk -pk kokkos neigh half -in in.reax
```

> Replace the number after `-np` and `g` with the number of GPUs you want to use.

---

## 4. Performance Comparison

| Configuration | Wall Time |
|---|---|
| 1 GPU | 0:04:07 |
| 2 GPUs | 0:03:06 |
| 3 GPUs | 0:03:42 |
| 4 GPUs | Failed |
| CPU (IBS, 72 cores) | 0:13:44 |

> **Takeaway:** 2 GPUs gave the best performance. Scaling beyond 2 GPUs showed diminishing returns or failures for this particular system size.

---

## 5. Supported Pair Styles

Check which pair styles support GPU/Kokkos/OpenMP acceleration:
https://docs.lammps.org/Commands_pair.html

---

## 6. References

- [Kokkos GPU performance discussion](https://matsci.org/t/performance-of-lammps-with-kokkos-gpu-on-multiple-gpus/52053/5)
- [HPC Carpentry: Kokkos GPU tutorial](https://www.hpc-carpentry.org/tuning_lammps/08-kokkos-gpu/index.html)
- [HPC Carpentry: Kokkos OpenMP tutorial](https://www.hpc-carpentry.org/tuning_lammps/07-kokkos-openmp/index.html)
- [LAMMPS package documentation](https://docs.lammps.org/package.html)
- [LAMMPS GPU compile video tutorial](https://youtu.be/jJTQ8-vjEb0?si=wdkjm8no46hFnfLw)
- [LAMMPS GPU compile guide](https://implant.fs.cvut.cz/lammps-gpu-compile/)
