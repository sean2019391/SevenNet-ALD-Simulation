# Slurm Job Scheduler — Quick Reference

Slurm is the job scheduler used on HPC clusters (e.g., IBS, ORCA).

---

## Submit to a Specific Node

```bash
sbatch -w <node_name> <job_script>
```

Example (ORCA cluster nodes: `node01`, `node02`, `node03`):
```bash
sbatch -w node01 run_simulation.sh
```

---

## Change Job Priority

```bash
scontrol update job=<job_id> nice=<priority>
```

- **Lower value = higher priority**
- Must be an integer
- Example: `scontrol update job=12345 nice=-100` (makes it higher priority)
