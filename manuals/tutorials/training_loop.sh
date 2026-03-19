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

# Directory containing OUTCAR files (adjust if different)
OUTCAR_DIR="/home/<your_username>/OUTCAR_collection"

# YAML configuration file
CONFIG_FILE="input.yaml"

# Loop through OUTCAR files 1 to 181
for i in $(seq 2 181); do
    OUTCAR_FILE="${OUTCAR_DIR}/OUTCAR_${i}"

    # Update load_dataset_path in input.yaml with the current OUTCAR file
    # Using 'yq' command to update the YAML file (install yq if you haven't: 'sudo apt install yq')
    sed -i "s|load_dataset_path: \[.*\]|load_dataset_path: [\"$OUTCAR_FILE\"]|" $CONFIG_FILE

    # Train the model using the updated input.yaml
    echo "Training with $OUTCAR_FILE..."
    sevenn $CONFIG_FILE -s

    echo "Completed training for $OUTCAR_FILE"
done



