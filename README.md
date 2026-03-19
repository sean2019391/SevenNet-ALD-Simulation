# UNIST Semiconductor Process Research — Internship Notebook

This repository is a complete research notebook from my internship at **Ulsan National Institute of Science and Technology (UNIST)**, where I worked on semiconductor process research using atomistic simulation and machine-learning force fields (MLFFs).

## What You'll Find Here

- **Step-by-step manuals** for installing and running LAMMPS, SevenNet, CHGNet, GPUMD, ReaxFF, and VASP
- **Hands-on simulation tutorials** — silicon relaxation, thermal expansion, carbon tensile testing
- **ML force field fine-tuning workflows** using real VASP OUTCAR data (180 Diethylzinc slab files)
- **Study materials and seminar plans** on machine-learning interatomic potentials and graph neural networks
- **Lab management notes** for workstation and HPC cluster operations

## Research Focus

All work in this repository connects to one central theme: **using computational tools to understand atomic-scale behavior in semiconductor manufacturing**. This includes:

- Atomic Layer Deposition (ALD) surface reactions
- Plasma-material interactions
- Comparing conventional force fields (SW, Tersoff, COMB) with ML force fields (SevenNet, CHGNet)
- Training ML models from first-principles (DFT/VASP) data

## Repository Structure

```
├── manuals/                    # Tool installation & usage guides
│   ├── tutorials/              # Training notes + tutorials with real simulation files
│   │   ├── 01_silicon_relaxation/  # Silicon: relaxation + thermal expansion
│   │   └── 02_carbon_tensile/      # Carbon: relaxation + tensile deformation
│   └── VASP/                   # VASP benchmarks & error notes
├── study/                      # Reading lists, seminar plans, reference papers
│   └── Seminar_Materials/      # Weekly seminar papers and presentations
└── lab_management/             # Safety, admin, workstation/cluster management
```

## Recommended Reading Order

| Step | File | What You'll Learn |
|------|------|-------------------|
| 1 | `manuals/README.md` | Overview of all tool manuals |
| 2 | `manuals/tutorials/01_LAMMPS_Setup.md` | Full environment setup from scratch |
| 3 | `manuals/tutorials/02_SevenNet_Tutorials.md` | Running your first simulations |
| 4 | `manuals/tutorials/03_Fine_Tuning_Workflow.md` | Training ML models with real data |
| 5 | `manuals/Sevennet.md` | Quick-reference SevenNet commands |
| 6 | `study/Seminar_Plan.md` | Study roadmap and paper list |

## Key Tools

| Tool | Purpose |
|------|---------|
| [LAMMPS](https://docs.lammps.org/Manual.html) | Molecular dynamics simulation engine |
| [SevenNet](https://github.com/MDIL-SNU/SevenNet) | E(3)-equivariant graph neural network force field |
| [CHGNet](https://www.nature.com/articles/s42256-023-00716-3) | Crystal Hamiltonian graph neural network force field |
| [VASP](https://www.vasp.at/) | First-principles (DFT) calculation software |
| [OVITO](https://www.ovito.org/) | Atomistic trajectory visualization |

## Quick Start

If you want to jump straight into running simulations, start with `manuals/tutorials/01_LAMMPS_Setup.md`, then run the tutorial scripts in `01_silicon_relaxation/` and `02_carbon_tensile/`.
