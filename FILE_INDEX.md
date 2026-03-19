# File Index — Complete Repository Map

## Root

| File | Description |
|------|-------------|
| `README.md` | Main overview and reading guide |
| `RESEARCH_NOTEBOOK.md` | Detailed research narrative |
| `FILE_INDEX.md` | This file — complete repository inventory |
| `GITHUB_UPLOAD_STEPS.md` | Instructions for publishing to GitHub |

---

## `manuals/`

| File | Description |
|------|-------------|
| `README.md` | Index of all manual documents |
| `WSGPU.md` | Workstation GPU job submission with Task Spooler (tsp) |
| `Sevennet.md` | SevenNet installation, LAMMPS patching, and fine-tuning reference |
| `CHGNET.md` | CHGNet installation and LAMMPS integration |
| `GPUMD.md` | GPU-accelerated LAMMPS compilation with Kokkos |
| `lammps_reax.md` | ReaxFF LAMMPS build with Intel optimizations for CPU/HPC |
| `Job_Scheduler.md` | Slurm node selection and job priority commands |
| `SIMPLENN.md` | SimpleNN framework setup guide |

### `manuals/VASP/`

| File | Description |
|------|-------------|
| `VASP_Error.md` | VASP error troubleshooting (segfault / memory issues) |
| `VASP_system_BM.md` | VASP benchmark results across WS, IBS, KISTI, ORCA systems |

---

## `manuals/tutorials/`

### Training Guides

| File | Description |
|------|-------------|
| `01_LAMMPS_Setup.md` | Complete environment + LAMMPS + SevenNet setup from scratch |
| `02_SevenNet_Tutorials.md` | Tutorial execution, force field comparison, basic fine-tuning |
| `03_Fine_Tuning_Workflow.md` | Large-scale fine-tuning with 180 DEZ OUTCAR files |
| `04_AI_Deep_Learning_Seminar.md` | AI/deep learning code examples (neural nets, GPT model) |
| `05_Review_ML_for_Plasma_Material_Interactions.md` | Review connecting ML to semiconductor plasma processing |

### Helper Scripts

| File | Description |
|------|-------------|
| `move_outcar_files.py` | Python — filters valid OUTCAR files and renames them sequentially |
| `training_loop.sh` | Shell — automated SevenNet fine-tuning loop over 180 files |
| `graph_build.sh` | Shell — graph data preprocessing with auto GPU detection |

### `01_silicon_relaxation/` — Silicon Relaxation & Thermal Expansion

| File | Description |
|------|-------------|
| `in.Si_SW_relaxationshort` | Relaxation + NPT dynamics with Stillinger-Weber potential |
| `in.Si_SevenNet_relaxationshort` | Same simulation with SevenNet (e3gnn) |
| `in.Si_COMB_relaxationshort` | Same simulation with COMB potential |
| `in.Si_SW_thermalexpansioncoeffshort` | Thermal expansion loop with SW |
| `in.Si_SevenNet_thermalexpansioncoeffshort` | Thermal expansion loop with SevenNet |
| `in.Si_COMB_thermalexpansioncoeffshort` | Thermal expansion loop with COMB |
| `Si.sw` | Stillinger-Weber potential parameters |
| `Si.comb.txt` | COMB potential parameters |
| `Si.reaxff` | ReaxFF potential parameters |
| `log.lammps` | LAMMPS log output |
| `dynamic.trj` / `dynamics.trj` | Atomic trajectory files |
| `out.rho.txt` | Density tracking output |
| `out_thermalexpansioncoeff.data` | Temperature vs. box length data |
| `thermo_thermalexpansioncoeff.txt` | Step-by-step thermodynamic properties |
| `cte.ipynb` | Jupyter notebook for thermal expansion analysis |

### `02_carbon_tensile/` — Carbon Tensile Simulation

| File | Description |
|------|-------------|
| `in.C_relaxationshort` | Carbon relaxation with Tersoff potential |
| `in.C_tensileshort` | Tensile deformation with Tersoff |
| `in_SevenNet.C_relaxationshort` | Carbon relaxation with SevenNet |
| `in_SevenNet.C_tensileshort` | Tensile deformation with SevenNet |
| `BNC.tersoff` | Tersoff potential for B/N/C systems |
| `C.cif` | Carbon crystal structure (CIF format) |
| `C.data` | LAMMPS data file (converted from CIF) |
| `C_done_*.data` | Relaxed structures at various conditions |
| `log.lammps` | LAMMPS log output |
| `dynamic.trj` | Relaxation trajectory |
| `tensile_5000.trj` | Tensile deformation trajectory |
| `out.rho_0.1.txt` | Density output |
| `outC11_500.data` / `outC11_5000.data` | Stress-strain data |
| `stress-strain.xlsx` | Processed stress-strain spreadsheet |
| `ovito_session_saved.ovito` | OVITO visualization session |

---

## `study/`

| File | Description |
|------|-------------|
| `Seminar_Plan.md` | Weekly seminar schedule with paper links |
| `MLFF.md` | ML force field reference list |
| `tutorial_NNP.pdf` | Neural network potential study material |
| `practice_materials/` | Practice materials (MD simulations, distortion, GeTe) |
| `ref/simpleNN` | SimpleNN reference asset |

### `study/Seminar_Materials/`

| File | Description |
|------|-------------|
| `(Week4)-...Polyurea.pdf` | Coarse-graining paper (Iterative Boltzmann Inversion) |
| `(week5)...ATO_small.pptx` | Ar bombardment on TiO2 slab presentation |

---

## `lab_management/`

| File | Description |
|------|-------------|
| `Management.md` | Safety, travel approval, workstation/cluster setup, user management |
