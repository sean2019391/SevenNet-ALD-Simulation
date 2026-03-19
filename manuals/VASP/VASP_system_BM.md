# VASP Benchmark Results

Use the input files in the directories below to determine the optimal number of cores for each system through benchmark calculations.

---

## Test Descriptions

### Light Calculation (SCF — Self-Consistent Field)
- **Directory:** `/opt/0.test_dummy/1.VASP_test_dummy` @ Workstation
- **Metric:** CPU-time (seconds) — lower is better

### Heavy Calculation (Ionic Relaxation)
- **Directory:** `/opt/0.test_dummy/2.VASP_test_dummy_long` @ Workstation
- **Wall time limit:** 15 minutes
- **Metric:** Iter(ion) and Iter(elec) — higher is better (more iterations completed = faster computation)

---

## System: Workstation (WS)

### 1 Node — Light Calculation

| Cores | Processes | Threads | CPU-time (s) |
|-------|-----------|---------|-------------|
| 24 | 6 | 4 | 421.050 |

---

## System: IBS Cluster

### 1 Node — Light Calculation

| Cores | Processes | Threads | CPU-time (s) |
|-------|-----------|---------|-------------|
| 36 | - | - | 167.567 |
| 72 | - | - | 159.528 |
| 144 | - | - | Failed |
| 72 | 1 | 72 | 191.562 |
| 72 | 2 | 36 | 438.284 |
| 72 | 6 | 12 | Failed |
| 72 | 12 | 6 | Failed |
| 72 | 18 | 4 | 438.306 |
| 72 | 36 | 2 | Failed |
| 72 | 72 | 1 | Failed |
| 144 | 1 | 144 | 3708.111 |
| 144 | 2 | 72 | 2003.819 |
| 144 | 4 | 36 | 1087.100 |
| 144 | 8 | 18 | 546.669 |
| 144 | 12 | 12 | 699.149 |
| 144 | 18 | 8 | Failed |
| 144 | 36 | 4 | Failed |
| 144 | 72 | 2 | Failed |
| 144 | 144 | 1 | Failed |

> **Best IBS config for light calculation:** 72 cores with default settings (159.5s)

### 1 Node — Heavy Calculation

| Cores | Processes | Threads | Iter(ion) | Iter(elec) |
|-------|-----------|---------|-----------|------------|
| 36 | - | - | 6 | 14 |
| 72 | - | - | 7 | 19 |
| 144 | - | - | Failed | - |
| 72 | 1 | 72 | 1 | 5 |
| 72 | 2 | 36 | 1 | 9 |
| 72 | 6 | 12 | 1 | 29 |
| 72 | 12 | 6 | 1 | 0 |
| 72 | 18 | 4 | 1 | 0 |
| 72 | 36 | 2 | 1 | 0 |
| 72 | 72 | 1 | 1 | 0 |
| 144 | 1 | 144 | 1 | 5 |
| 144 | 2 | 72 | 1 | 10 |
| 144 | 4 | 36 | 1 | 19 |
| 144 | 8 | 18 | 2 | 2 |
| 144 | 12 | 12 | 1 | 31 |
| 144 | 18 | 8 | 1 | 0 |
| 144 | 36 | 4 | 1 | 0 |
| 144 | 72 | 2 | 1 | 0 |
| 144 | 144 | 1 | Failed | - |

> **Best IBS config for heavy calculation:** 72 cores default (7 ion + 19 elec iterations)

---

## System: KISTI

### 1 Node — Light Calculation

| Cores | CPU-time (s) |
|-------|-------------|
| 16 | 1233.480 |
| 64 | 356.573 |

---

## System: ORCA Cluster

### 1 Node — Light Calculation

| Cores | Elapsed time (s) |
|-------|-----------------|
| 24 | 245.958 |
| 48 | 137.132 |
| 96 | 82.027 |

### 1 Node — Heavy Calculation

| Cores | Iter(ion) | Iter(elec) |
|-------|-----------|------------|
| 24 | 4 | 16 |
| 48 | 6 | 12 |
| 96 | 16 | 7 |

> **Best ORCA config:** 96 cores (fastest for both light and heavy calculations)
