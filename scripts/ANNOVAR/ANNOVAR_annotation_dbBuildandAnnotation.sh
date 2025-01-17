#!/bin/bash

#SBATCH -J ANVR_Analysis                # Job name
#SBATCH -A eande106                     # Allocation name
#SBATCH -p parallel                     # Partition/Queue name
#SBATCH -t 24:00:00                     # Job walltime/duration (hh:mm:ss)
#SBATCH -N 1                            # Number of nodes
#SBATCH -n 48                           # Number of cores
#SBATCH --mail-user=loconn13@jh.edu     # Email for job notifications
#SBATCH --mail-type=END                 # Notify when job ends
#SBATCH --output=/home/loconn13/vast-eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/ANNOVAR/c_elegans/SLURM_output/containerFinal.oe  # Output log file
#SBATCH --error=/home/loconn13/vast-eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/ANNOVAR/c_elegans/SLURM_output/containerFinal.rr 

module load singularity  # Load Singularity module

# Define paths for binding directories
ANNOVAR_input="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/raw_data/ANNOVAR/$1"
vast_data="/vast/eande106/data/$1"
output_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/ANNOVAR/$1"
containerImage="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/container_images/loconn13999-annovar_annotation_2024_10_09.sif"
scripts="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/scripts/ANNOVAR/c_elegans"
vcf_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/$1"

# Use singularity exec for non-interactive execution
singularity exec --bind "$ANNOVAR_input:/ANNOVAR_input" \
                 --bind "$output_dir:/annotation_output" \
                 --bind "$scripts:/scripts" \
                 --bind "$vast_data:/vast_data" \
                 --bind $vcf_dir:/vcf_dir \
                 "$containerImage" /usr/bin/bash /vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/scripts/ANNOVAR/c_elegans/ANNOVAR_analysis.sh $1
  

# TO RUN:
# chmod +x /home/loconn13/vast-eande106/projects/Lance/THESIS_WORK/variant_annotation/scripts/ANNOVAR/c_elgans/ANNOVAR_analysis.sh
# sbatch /home/loconn13/vast-eande106/projects/Lance/THESIS_WORK/variant_annotation/scripts/ANNOVAR/c_elegans/ANNOVAR_annotation_dbBuildandAnnotation.sh c_elegans