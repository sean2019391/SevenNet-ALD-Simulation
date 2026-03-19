import shutil
import os

# Define the target directory
target_directory = "/home/<your_username>/OUTCAR_collection"

# Make sure the target directory exists
os.makedirs(target_directory, exist_ok=True)

# Initialize a counter to create unique file names
file_counter = 1

# Read the file list and move each file
with open("outcar_file_list.txt", "r") as file:
    for line in file:
        filepath = line.strip()
        if os.path.isfile(filepath):  # Check if the file exists
            # Open the OUTCAR file and check if it contains the required line
            with open(filepath, "r") as outcar_file:
                file_contents = outcar_file.read()
                if "reached required accuracy - stopping structural energy minimisation" not in file_contents:
                    print(f"Skipping {filepath} (does not contain the required line).")
                    continue  # Skip this file and move to the next one
            
            # Create a new unique filename for each OUTCAR file
            new_filename = f"OUTCAR_{file_counter}"
            destination_path = os.path.join(target_directory, new_filename)  
            
            # Move the file to the target directory with the new name 
            shutil.move(filepath, destination_path)

            # Increment the counter for the next file
            file_counter += 1
        else:
            print(f"File not found: {filepath}")
