# Part 3: Large-Scale Fine-Tuning with 180 OUTCAR Files

**Prerequisites:** Complete [01_LAMMPS_Setup.md](01_LAMMPS_Setup.md) and [02_SevenNet_Tutorials.md](02_SevenNet_Tutorials.md) first.

This is the most advanced workflow in the repository. It covers fine-tuning SevenNet using 180 Diethylzinc (DEZ) slab relaxation outputs from VASP — real research data, not tutorial examples.

---

## Background: What is DEZ?

**DEZ (Diethylzinc)** is a metalorganic precursor commonly used in Atomic Layer Deposition (ALD) of zinc-containing thin films. During ALD, DEZ reacts with water on semiconductor wafer surfaces to form a monoethylzinc layer. Understanding the atomic-scale behavior of DEZ on surfaces requires accurate interatomic potentials — which is exactly what this fine-tuning workflow produces.

---

## Step 1: Obtain the DEZ Slab Data

The `DEZ_Slab(relaxed)` dataset contains VASP relaxation outputs.

**Location:** Lab workstation
- Connect to the lab workstation (ask your supervisor for the IP and port)
- Directory: `0.materials`

> **Tip:** Use WinSCP to download the data to your local machine first, then upload to the GPU workstation.

---

## Step 2: Extract and Filter Valid OUTCAR Files

The dataset contains 181 OUTCAR files, but some are incomplete (VASP calculation did not converge). We need to filter these out.

**How to identify a valid OUTCAR:** A completed VASP relaxation contains this line near the end:
```
reached required accuracy - stopping structural energy minimisation
```

Files missing this line are invalid and must be skipped.

### Use the provided Python script: `move_outcar_files.py`

This script reads a list of OUTCAR paths, checks each for the convergence message, and copies valid files with sequential names (`OUTCAR_1`, `OUTCAR_2`, etc.).

**Result:** 180 valid files (OUTCAR_86 was identified as invalid — its VASP calculation did not converge).

---

## Step 3: First Manual Fine-Tuning Run

The first run must be done manually because you need to set up `input.yaml` from scratch.

### Generate the configuration
```bash
sevenn_preset fine_tune > input.yaml
```

### Edit input.yaml
```yaml
checkpoint: '7net-0'
load_dataset_path: ['/home/<user>/OUTCAR_collection/OUTCAR_1']
```

### Run fine-tuning
```bash
sevenn input.yaml -s
```

### Build graph data
```bash
sevenn_graph_build structure_list 5.0
```
> `5.0` is the cutoff distance in Angstroms. Adjust based on your system.

### Run inference
```bash
sevenn_inference checkpoint_best.pth graph_built.sevenn_data
```

---

## Step 4: Update input.yaml for Subsequent Runs

**Critical:** Before running the automated loop, change `checkpoint` in `input.yaml` from `'7net-0'` to `'checkpoint_best.pth'`. This ensures each run builds on the previous training result. Without this, every run restarts from the base model and all training progress is lost.

---

## Step 5: Automated Fine-Tuning Loop (OUTCAR 2–181)

The shell script `training_loop.sh` automates the remaining 179 training runs. It:

1. Detects a free GPU automatically
2. Loops from OUTCAR_2 to OUTCAR_181
3. Updates `input.yaml` to point to the current OUTCAR file
4. Runs `sevenn input.yaml -s` for each

### Submit the job
```bash
tsp bash training_loop.sh
```

`tsp` queues the job so it runs even if you disconnect from the workstation. Expect approximately **4 days** for the full loop to complete.

### Monitor progress

| Command | Action |
|---------|--------|
| `tsp` | Check queue status |
| `nvidia-smi` | Verify GPU utilization |
| `tsp -r <job_id>` | Remove a queued job |
| `tsp -K` | Clear the entire queue |
| `tsp -k <job_id>` | Kill a running job |

---

## Step 6: Build Graph Data

After the training loop completes:

```bash
sevenn_graph_build structure_list 5.0
```

This can take ~1 hour. Use `graph_build.sh` to auto-detect a free GPU:

```bash
tsp bash graph_build.sh
```

---

## Step 7: Generate Inference Results

```bash
sevenn_inference checkpoint_best.pth graph_built.sevenn_data
```

Creates `sevenn_infer_result/` containing predicted vs. reference energies and forces in CSV format.

---

## Step 8: Export Deployable Models

**Important distinction:**
- `checkpoint_best.pth` = training checkpoint (for continuing training). NOT usable as a model in LAMMPS.
- `deployed_serial.pt` / `deployed_parallel.pt` = actual models for LAMMPS simulations.

```bash
sevenn_get_model checkpoint_best.pth       # Creates deployed_serial.pt
sevenn_get_model checkpoint_best.pth -p    # Creates deployed_parallel.pt
```

---

## Step 9: Run Simulations with the Fine-Tuned Model

Use `deployed_serial.pt` in your LAMMPS input script:

```
pair_style       e3gnn
pair_coeff       * * /path/to/deployed_serial.pt Zn O C H
```

Then run:
```bash
~/lammps_sevenn/build/lmp -in in.lmp
```

---

## Results: Before vs. After Fine-Tuning

Training significantly improves simulation quality:
- **Before:** Large oscillations, unstable dynamics
- **After:** Reduced amplitude, smoother behavior, more physically realistic

> The before/after comparison graphs are available in the original Korean version of this document.

---

## Complete Workflow Summary

```
VASP DFT calculations
    ↓
181 OUTCAR files (DEZ slab relaxations)
    ↓
Filter invalid files → 180 valid OUTCARs
    ↓
Manual first run (OUTCAR_1 + base model 7net-0)
    ↓
Automated loop (OUTCAR_2 → OUTCAR_180, ~4 days)
    ↓
Build graph data (sevenn_graph_build)
    ↓
Run inference (sevenn_inference)
    ↓
Export model (sevenn_get_model → deployed_serial.pt)
    ↓
Run LAMMPS with fine-tuned model
    ↓
Compare before/after training behavior
```
