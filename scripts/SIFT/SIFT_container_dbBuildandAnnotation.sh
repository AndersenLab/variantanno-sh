#!/bin/bash

#SBATCH -J SIFT_Analysis      # Job name
#SBATCH -A eande106                     # Allocation name
#SBATCH -p parallel                     # Partition/Queue name
#SBATCH -t 48:00:00                     # Job walltime/duration (hh:mm:ss)
#SBATCH -N 1                            # Number of nodes
#SBATCH -n 48                           # Number of cores per node
#SBATCH --mail-user=loconn13@jh.edu     # Email for job notifications
#SBATCH --mail-type=END                 # Notify when job ends
#SBATCH --output=/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/SIFT/c_elegans/SLURM_output/nematodeDBrun_c_elegansWN2069.oe  # Output log file
#SBATCH --error=/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/SIFT/c_elegans/SLURM_output/nematodeDBrun_c_elegansWN2069.rr 

# Path where database will be built
module load singularity  # Load Singularity module

# Define paths for binding directories
SIFT_input="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/raw_data/SIFT/$1/SIFT_input"
output_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/SIFT/$1"
masterVCF_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/$1"
containerImage="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/container_images/loconn13999-sift_image_final_v2_2024_07_30.sif"
sift4g="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/raw_data/SIFT/c_elegans/SIFT_input"
scripts="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/scripts/SIFT/scripts_to_build_SIFT_db"

# Use singularity exec for non-interactive execution
singularity exec --bind $SIFT_input:/SIFT_input \
                 --bind $output_dir:/annotation_output \
                 --bind $sift4g:/sift4g \
                 --bind $scripts:/scripts \
                 --bind $masterVCF_dir:/masterVCF_dir \
                 $containerImage /usr/bin/bash /vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/scripts/SIFT/c_elegans/BuildAnnotation_forSingularity.sh $1
  

# TO RUN:
# chmod +x /vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/scripts/SIFT/c_elgans/BuildAnnotation_forSingularity.sh
# sbatch /vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/scripts/SIFT/c_elegans/SIFT_container_dbBuildandAnnotation.sh



