#!/bin/bash

#SBATCH -J ANVR_Analysis      # Job name
#SBATCH -A eande106                     # Allocation name
#SBATCH -p parallel                     # Partition/Queue name
#SBATCH -t 24:00:00                     # Job walltime/duration (hh:mm:ss)
#SBATCH -N 1                            # Number of nodes
#SBATCH -n 24                           # Number of cores
#SBATCH --mail-user=loconn13@jh.edu     # Email for job notifications
#SBATCH --mail-type=END                 # Notify when job ends
#SBATCH --output=/home/loconn13/vast-eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/ANNOVAR/c_elegans/SLURM_output/containerFinal.oe  # Output log file
#SBATCH --error=/home/loconn13/vast-eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/ANNOVAR/c_elegans/SLURM_output/containerFinal.rr 

module load singularity  # Load Singularity module

# Define paths for binding directories
ANNOVAR_input="/home/loconn13/vast-eande106/projects/Lance/THESIS_WORK/variant_annotation/raw_data/ANNOVAR/c_elegans"
output_dir="/home/loconn13/vast-eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/ANNOVAR/c_elegans/"
containerImage="/home/loconn13/vast-eande106/projects/Lance/THESIS_WORK/variant_annotation/container_images/loconn13999-annovar_image_2024_08_19.sif"
scripts="/home/loconn13/vast-eande106/projects/Lance/THESIS_WORK/variant_annotation/scripts/ANNOVAR/c_elegans"

# Use singularity exec for non-interactive execution
singularity exec --bind "$ANNOVAR_input:/ANNOVAR_input" \
                 --bind "$output_dir:/annotation_output" \
                 --bind "$scripts:/scripts" \
                 "$containerImage" /usr/bin/bash /home/loconn13/vast-eande106/projects/Lance/THESIS_WORK/variant_annotation/scripts/ANNOVAR/c_elegans/ANNOVAR_analysis.sh
  

# TO RUN:
# chmod +x /home/loconn13/vast-eande106/projects/Lance/THESIS_WORK/variant_annotation/scripts/ANNOVAR/c_elgans/ANNOVAR_analysis.sh
# sbatch /home/loconn13/vast-eande106/projects/Lance/THESIS_WORK/variant_annotation/scripts/ANNOVAR/c_elegans/ANNOVAR_annotation_dbBuildandAnnotation.sh