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

# Run your command
sevenn_graph_build structure_file 5.0
