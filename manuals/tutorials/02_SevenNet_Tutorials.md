# Part 2: Running SevenNet Tutorials and Comparing Force Fields

**Prerequisites:** Complete [01_LAMMPS_Setup.md](01_LAMMPS_Setup.md) first.

This guide walks through the two simulation tutorials, compares conventional vs. ML force fields, and introduces SevenNet's training pipeline.

---

## Background: What is a Machine Learning Force Field?

A **Machine Learning Force Field (MLFF)** uses trained neural networks to predict forces between atoms, instead of relying on fixed mathematical formulas (like Stillinger-Weber or Tersoff potentials).

- **Conventional force fields:** Based on empirical data and physics equations. Fast but limited in accuracy for complex chemistry.
- **MLFFs (e.g., SevenNet):** Trained on quantum mechanical (DFT) data. More accurate for complex interactions while remaining computationally affordable.

---

## Download the Tutorial Files

```bash
git clone https://github.com/VDLab-git/Lab_note
```

> **Note:** This is a private repository. You need a GitHub Personal Access Token:
> 1. GitHub → Settings → Developer settings → Personal access tokens → Generate new token
> 2. Enable `repo` and `read:org` permissions
> 3. Use:
> ```bash
> git clone https://<your-token>@github.com/VDLab-git/Lab_note
> ```

After cloning, the tutorials are in `SangwonTheGreat/tutorial_01/` and `tutorial_02/`.

---

## Tutorial 01: Silicon Relaxation

### Run with Stillinger-Weber (conventional force field)

```bash
cd tutorial_01
~/lammps/build/lmp -in in.Si_SW_relaxationshort
```

This script:
1. Creates a 4x4x4 silicon diamond lattice (lattice constant = 5.43 A)
2. Applies the SW potential (`Si.sw`)
3. Minimizes energy using conjugate gradient
4. Runs NPT dynamics at 5000 K for 5000 steps
5. Outputs density data (`out.rho.txt`) and trajectory (`dynamic.trj`)

### Run with SevenNet (ML force field)

```bash
~/lammps_sevenn/build/lmp -in in.Si_SevenNet_relaxationshort
```

Same simulation but using `pair_style e3gnn` with `deployed_serial.pt`.

### Compare the Results

The key difference is visible in the dynamics:
- **SW:** Larger oscillations, less stable behavior
- **SevenNet:** Smoother, more stable trajectory with smaller fluctuations

This demonstrates that ML force fields can produce more physically realistic dynamics than classical potentials.

---

## Tutorial 01: Thermal Expansion

### Run the thermal expansion workflow

```bash
~/lammps/build/lmp -in in.Si_SW_thermalexpansioncoeffshort
```

This script:
1. Minimizes the structure at 0 K and records the initial box length
2. Loops through temperatures: 100 K, 200 K, ..., 700 K
3. At each temperature:
   - Assigns velocities at the target temperature
   - Runs NPT for 3000 steps (3 ps)
   - Averages the box length over the last 70% of the run
4. Writes `(Temperature, avg_Lx)` pairs to `out_thermalexpansioncoeff.data`

The slope of the Temperature vs. Lx curve gives the **coefficient of thermal expansion (CTE)** — a key property for semiconductor materials where thermal mismatch causes stress and reliability issues.

### Analyze the results

Use the Jupyter notebook `cte.ipynb` to plot and fit the thermal expansion data.

---

## Tutorial 01: Available Input Scripts

| Script | Force Field | Simulation Type |
|--------|-------------|----------------|
| `in.Si_SW_relaxationshort` | Stillinger-Weber | Relaxation + NPT dynamics |
| `in.Si_SevenNet_relaxationshort` | SevenNet (e3gnn) | Relaxation + NPT dynamics |
| `in.Si_COMB_relaxationshort` | COMB | Relaxation + NPT dynamics |
| `in.Si_SW_thermalexpansioncoeffshort` | Stillinger-Weber | Thermal expansion loop |
| `in.Si_SevenNet_thermalexpansioncoeffshort` | SevenNet | Thermal expansion loop |
| `in.Si_COMB_thermalexpansioncoeffshort` | COMB | Thermal expansion loop |

### Supporting Files

| File | Description |
|------|-------------|
| `Si.sw` | Stillinger-Weber potential parameters |
| `Si.comb.txt` | COMB potential parameters |
| `Si.reaxff` | ReaxFF potential parameters |
| `log.lammps` | LAMMPS log output with thermodynamic data |
| `out.rho.txt` | Density vs. time data |
| `out_thermalexpansioncoeff.data` | Temperature vs. box length |
| `dynamic.trj` / `dynamics.trj` | Atomic trajectories (open in [OVITO](https://www.ovito.org/)) |
| `cte.ipynb` | Jupyter notebook for thermal expansion analysis |

---

## SevenNet Training: Fine-Tuning Example

### Run the built-in training example

```bash
cd ~/SevenNet/example_inputs/training
sevenn_preset fine_tune > input.yaml
```

Edit `input.yaml` to point to the training data:
```yaml
load_dataset_path: ['/home/<user>/SevenNet/example_inputs/data/label_1/*', '/home/<user>/SevenNet/example_inputs/data/label_2/*']
```

> Use the full path to each OUTCAR directory. This is more reliable than using `structure_list`.

### Run fine-tuning
```bash
sevenn input.yaml -s
```

For multi-GPU training:
```bash
torchrun --standalone --nnodes 1 --nproc_per_node <num_gpus> --no_python sevenn input.yaml -d
```

### Output files

| File | Description |
|------|-------------|
| `checkpoint_best.pth` | Best model checkpoint (lowest validation error) |
| `checkpoint_10.pth` ... `checkpoint_100.pth` | Checkpoints every 10 iterations |
| `log.sevenn` | Training log |
| `log.csv` | Training metrics in CSV format |
| `structure_list` | List of training structures |

### Build graph data
```bash
sevenn_graph_build structure_list 5.0
```
This preprocesses the OUTCAR data into `.sevenn_data` format with a cutoff distance of 5.0 A.

### Run inference
```bash
sevenn_inference checkpoint_best.pth graph_built.sevenn_data
```
This creates a `sevenn_infer_result/` folder with CSV files containing predicted vs. reference energies and forces.

### Key file types

| File | What it is |
|------|------------|
| `res.dat` | VASP POSCAR converted to LAMMPS data format (atom positions + box) |
| `deployed_serial.pt` | Trained model for single-process LAMMPS runs |
| `deployed_parallel.pt` | Trained model for multi-process (MPI) LAMMPS runs |
| `checkpoint_best.pth` | Training checkpoint — NOT a deployable model. Convert with `sevenn_get_model` |

---

**Next:** Go to [03_Fine_Tuning_Workflow.md](03_Fine_Tuning_Workflow.md) to learn large-scale fine-tuning with real research data.
