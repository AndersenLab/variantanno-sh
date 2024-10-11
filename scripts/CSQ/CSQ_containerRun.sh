#!/bin/bash

#SBATCH -J CSQ_analysis                 # Job name
#SBATCH -A eande106                     # Allocation name
#SBATCH -p parallel                     # Partition/Queue name
#SBATCH -t 8:00:00                      # Job walltime/duration (hh:mm:ss)
#SBATCH -N 1                            # Number of nodes
#SBATCH -n 8                            # Number of cores
#SBATCH --mail-user=loconn13@jh.edu     # Email for job notifications
#SBATCH --mail-type=END                 # Notify when job ends
#SBATCH --output=/home/loconn13/vast-eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/CSQ/c_tropicalis/output_SLURM/CSQcoontainer_final.oe  
#SBATCH --error=/home/loconn13/vast-eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/CSQ/c_tropicalis/output_SLURM/CSQcoontainer_final.rr 

module load singularity  # Load Singularity module

# Define paths for binding directories
vast_data="/vast/eande106/data/$1"
output_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/CSQ/$1"
containerImage="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/container_images/loconn13999-csq_annotation_2024_09_18.sif"

# Use singularity exec for non-interactive execution
singularity exec --bind "$vast_data:/vast_data" \
                 --bind "$output_dir:/annotation_output" \
                 "$containerImage" /usr/bin/bash /vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/scripts/CSQ/c_elegans/CSQ_analysis.sh $1
  

# TO RUN:
# chmod +x /home/loconn13/vast-eande106/projects/Lance/THESIS_WORK/variant_annotation/scripts/CSQ/c_elgans/CSQ_analysis.sh
# sbatch /home/loconn13/vast-eande106/projects/Lance/THESIS_WORK/variant_annotation/scripts/CSQ/c_elegans/CSQ_containerRun.sh c_elegans