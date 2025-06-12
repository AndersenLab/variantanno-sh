#!/bin/bash

#SBATCH -J snpEff                 # Job name
#SBATCH -A eande106                     # Allocation name
#SBATCH -p parallel                     # Partition/Queue name
#SBATCH -t 8:00:00                      # Job walltime/duration (hh:mm:ss)
#SBATCH -N 1                            # Number of nodes
#SBATCH -n 8                            # Number of cores
#SBATCH --mail-user=loconn13@jh.edu     # Email for job notifications
#SBATCH --mail-type=END                 # Notify when job ends
#SBATCH --output=/home/loconn13/vast-eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/SnpEff/c_tropicalis/SLURM_output/mitoFix0516.oe  
#SBATCH --error=/home/loconn13/vast-eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/SnpEff/c_tropicalis/SLURM_output/mitoFix0516.rr 

module load singularity  # Load Singularity module

# Define paths for binding directories
snpeff_input="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/raw_data/SnpEff/$1"
output_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/SnpEff/$1"
containerImage="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/container_images/loconn13999-snpeff_annotation_2024_09_19.sif"
vcf_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/$1"

# Use singularity exec for non-interactive execution
singularity exec --bind $snpeff_input:/snpeff_input \
                 --bind $output_dir:/annotation_output \
                 --bind $vcf_dir:/vcf_dir \
                 $containerImage /usr/bin/bash /vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/scripts/SnpEff/c_elegans/SnpEff_analysis.sh $1
  
# TO RUN:
# chmod +x /home/loconn13/vast-eande106/projects/Lance/THESIS_WORK/variant_annotation/scripts/SnpEff/c_elgans/SnpEff_analysis.sh
# sbatch /home/loconn13/vast-eande106/projects/Lance/THESIS_WORK/variant_annotation/scripts/SnpEff/c_elegans/SnpEff_containerRun.sh c_elegans
