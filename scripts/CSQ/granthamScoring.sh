#!/bin/bash

#SBATCH -J grantham       # Job name
#SBATCH -A eande106          # Allocation name
#SBATCH -p parallel          # Partition/Queue name
#SBATCH -t 48:00:00          # Job walltime/duration (hh:mm:ss)
#SBATCH -N 1                 # Number of nodes
#SBATCH -c 12                 # Number of cores
#SBATCH --mail-user=loconn13@jh.edu  # Email for notifications
#SBATCH --mail-type=END      # Notify when job ends
#SBATCH --output=/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/CSQ/c_elegans/SLURM_output/mtGrantham.oe  # Output log
#SBATCH --error=/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/CSQ/c_elegans/SLURM_output/mtGrantham.rr  # Error log

if [[ $1 == "c_elegans" ]]; then
    vcf="WI.20231213.hard-filter.isotype.biallelic.NoMt.HDR.bcsq.vcf.gz"           
elif [[ $1 == "c_tropicalis" ]]; then
    vcf=""
elif [[ $1 == "c_briggsae" ]]; then
    vcf=""
fi

container_image="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/container_images/loconn13999-jvarkit_vcfgrantham_2025_01_04.sif"
output_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/CSQ/$1/containerRun"

module load singularity

singularity exec --bind $output_dir:/annotation_output \
    $container_image \
    java -jar /opt/jvarkit/dist/jvarkit.jar vcfgrantham --out $output_dir/$(basename $vcf .vcf.gz).GRANTHAM.vcf.gz $output_dir/$vcf
