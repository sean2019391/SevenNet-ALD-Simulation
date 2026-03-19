# Workstation GPU Job Management with Task Spooler (tsp)

Task Spooler (`tsp`) is a lightweight job queue manager for Linux workstations. It lets you queue multiple GPU jobs and run them sequentially or in parallel without manually monitoring GPU availability.

**Official documentation:** [Task Spooler Manual](https://github.com/justanhduc/task-spooler?tab=readme-ov-file#manual)

---

## Submitting Jobs

### Python scripts (assign specific GPUs)
```bash
tsp env CUDA_VISIBLE_DEVICES=0 python my_script.py
tsp env CUDA_VISIBLE_DEVICES=1 python my_script.py
tsp env CUDA_VISIBLE_DEVICES=2 python my_script.py
tsp env CUDA_VISIBLE_DEVICES=3 python my_script.py
```

### LAMMPS jobs (single GPU)
```bash
tsp env CUDA_VISIBLE_DEVICES=0 /path/to/lammps_chgnet/build/lmp -in in.Si_SW_relaxationshort -sf gpu -pk gpu 1
```

> **Note:** Replace the LAMMPS executable path with your own. The `-sf gpu -pk gpu 1` flags tell LAMMPS to use 1 GPU.

---

## Auto-GPU Queue Script

This script automatically detects a free GPU and submits the job:

```bash
#!/bin/bash

# Get the list of available GPUs
available_gpus=($(nvidia-smi --query-gpu=index --format=csv,noheader))

# Function to check if a GPU is in use
is_gpu_free() {
  gpu_id=$1
  nvidia-smi --query-compute-apps=gpu_uuid --format=csv,noheader -i $gpu_id | grep -q .
  return $?
}

# Find a free GPU
for gpu in "${available_gpus[@]}"; do
  if ! is_gpu_free $gpu; then
    export CUDA_VISIBLE_DEVICES=$gpu
    echo "Using GPU $gpu"
    break
  fi
done

tsp -S 4  # Allow up to 4 simultaneous GPU jobs
/path/to/lmp -in input_file -sf gpu -pk gpu 1  # Replace with your LAMMPS path and input file
```

**Submit using the script:**
```bash
tsp bash queue_script.sh
```

---

## Common tsp Commands

| Command | Action |
|---------|--------|
| `tsp` | List all queued and running jobs |
| `tsp -S N` | Set maximum simultaneous jobs to N |
| `tsp -k <job_id>` | Kill a running job |
| `tsp -r <job_id>` | Remove a queued (not yet running) job |
| `tsp -K` | Clear the entire job queue |
