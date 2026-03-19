# Research Narrative

## 1. Internship Summary

This notebook documents my research training during a semiconductor process research internship at UNIST. The materials show how I built a working foundation in atomistic simulation, machine-learning force fields, and semiconductor-process modeling — with particular focus on ALD-related surface reactions and plasma-material interactions.

This document organizes the full repository into a coherent research story:
- Why the simulations were important
- What tools were studied and used
- How the workflows were executed
- How the work connects to semiconductor process research

---

## 2. Core Research Theme

The central theme is the use of computational materials tools to understand and model atomic-scale behavior relevant to semiconductor manufacturing. The work spans three connected layers.

### 2.1 Semiconductor Process Context

Semiconductor fabrication depends on precise control of surface chemistry, thin-film growth, plasma exposure, and structural stability. In ALD, surface reactions occur sequentially at the atomic level — too small and fast to observe directly. Atomistic simulation fills this gap.

This repository covers:
- How atomic structures respond to temperature and pressure
- How force field choice affects predicted dynamics
- How ML-based potentials improve on older empirical force fields
- How DFT data can be prepared for fine-tuning ML models
- How simulation outputs can be interpreted for process-relevant insight

### 2.2 Atomistic Simulation Context

Molecular dynamics (MD) is the main simulation method used throughout. LAMMPS is the execution engine for all workflows, including:
- Structure generation and relaxation
- NPT dynamics for equilibration
- Density tracking and thermal expansion analysis
- Tensile deformation and stress-strain extraction
- Trajectory export for visualization in OVITO

### 2.3 Machine-Learning Force Field Context

A major training objective was understanding how ML interatomic potentials can be introduced into simulation workflows. The notes focus on SevenNet, but also cover CHGNet, SimpleNN, and broader MLFF concepts.

The practical question: if conventional potentials are too limited for complex local chemistry, can ML models provide a more realistic description while remaining computationally tractable?

---

## 3. Relevance to ALD Research

ALD is a surface-limited process. Precursor adsorption, ligand elimination, and surface saturation all occur through atomic-scale interactions. Atomistic simulation helps answer questions such as:
- Which surface configurations are stable under process conditions?
- How does temperature change structure and density?
- How does local bonding change under perturbation?
- Is a force field stable enough for predictive MD?

The DEZ fine-tuning notes are particularly relevant — DEZ (diethylzinc) is a classic zinc precursor for Zn-containing film processes. The notes document collecting and filtering 180 VASP OUTCAR files for SevenNet fine-tuning, representing real ALD-oriented computational groundwork.

---

## 4. Key Tools and Their Roles

### LAMMPS
The main MD engine. Used for structure generation, energy minimization, NPT simulation, density logging, thermal expansion, tensile deformation, and force field comparison.

### SevenNet
The primary ML force field framework. Used as a pre-trained model via `pair_style e3gnn` in LAMMPS, and fine-tuned from VASP OUTCAR datasets. The notes cover environment setup, LAMMPS patching, serial/parallel execution, fine-tuning, graph data building, inference, and model deployment.

### OVITO
Visualization tool for atomistic trajectories. Used to inspect structural relaxation, tensile deformation frame-by-frame, and communicate results visually.

### VASP
First-principles (DFT) code used upstream to generate reference data (energies, forces) for ML force field training.

### GPUMD, CHGNet, ReaxFF
Additional tools covered in the manuals, showing broader computational onboarding across multiple frameworks.

---

## 5. Main Workflows Documented

### 5.1 Silicon Relaxation and Equilibration
Builds a Si diamond lattice, applies SW or SevenNet potentials, minimizes, runs NPT dynamics. Compares stability between force field families.

### 5.2 Thermal Expansion
Steps temperature from 100–700 K, equilibrates at each point, records box length vs. temperature. Extracts the coefficient of thermal expansion.

### 5.3 Carbon Tensile Simulation
Reads a relaxed carbon structure, incrementally stretches the box in x, monitors stress and energy. Produces a stress-strain curve.

### 5.4 SevenNet Fine-Tuning with VASP Data
The strongest portfolio element. Covers data collection, filtering, organization, training loop automation, graph dataset construction, inference, and model deployment.

### 5.5 HPC and Workstation Usage
Notes for GPU job control (tsp), Slurm scheduling, node monitoring, environment preparation with conda, and CUDA path configuration.

---

## 6. What This Repository Demonstrates

### Technical Growth
Not just reading about tools — organized commands, installation flows, input scripts, training loops, and scheduler usage into a reusable notebook.

### Research Thinking
Consistently asks: What is the model doing? What assumptions are built in? How should outputs be interpreted? How can this scale to realistic datasets?

### Process Relevance
Aligned with semiconductor process research — ALD precursor context, plasma-material interaction reading, atomistic simulation, and MLFF fine-tuning.

### Reproducibility
Preserves not just results, but method: input scripts, potentials, logs, trajectories, notebooks, automation scripts, and scheduler notes.

---

## 7. Reproduction Steps

1. Set up conda environment with PyTorch and CUDA
2. Build LAMMPS (standard and SevenNet-patched)
3. Run baseline simulations with conventional force fields
4. Run equivalent simulations with SevenNet
5. Export trajectories and properties for analysis
6. Use OVITO for visual inspection
7. Prepare VASP OUTCAR reference data
8. Filter invalid data and organize training collection
9. Fine-tune SevenNet on curated dataset
10. Build graph data and run inference
11. Export deployment-ready model
12. Run LAMMPS with fine-tuned model
13. Compare pre- and post-training behavior
