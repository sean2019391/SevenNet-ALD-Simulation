# VASP Error Log

## Error 1: Segmentation Fault

```
forrtl: severe (174): SIGSEGV, segmentation fault occurred
```

**Cause:** Insufficient memory for the given system size and core count.

**Solutions:**
- Increase the number of CPU cores allocated to the job
- Reduce the simulation cell size (use a smaller supercell)
