#!/bin/bash

#SBATCH -J CSQ_analysis                 # Job name
#SBATCH -A eande106                     # Allocation name
#SBATCH -p parallel                     # Partition/Queue name
#SBATCH -t 8:00:00                      # Job walltime/duration (hh:mm:ss)
#SBATCH -N 1                            # Number of nodes
#SBATCH -c 12                            # Number of cores per task
#SBATCH --mail-user=loconn13@jh.edu     # Email for job notifications
#SBATCH --mail-type=END                 # Notify when job ends
#SBATCH --output=/home/loconn13/vast-eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/CSQ/c_elegans/SLURM_output/CSQcontainer_final.oe  
#SBATCH --error=/home/loconn13/vast-eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/CSQ/c_elegans/SLURM_output/CSQcontainer_final.rr 

module load singularity  # Load Singularity module

# Define paths for binding directories
vast_data="/vast/eande106/data/$1"
output_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/CSQ/$1/containerRun"
containerImage="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/container_images/loconn13999-csq_annotation_2024_09_18.sif"
vcf_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/$1"


if [[ $1 == "c_elegans" ]]; then
    vcf="$vcf_dir/WI.20231213.hard-filter.isotype.biallelic.NoMt.HDR.vcf.gz"
    gff="/vast_data/genomes/PRJNA13758/WS283/csq/c_elegans.PRJNA13758.WS283.csq.gff3"
    ref_genome="/vast_data/genomes/PRJNA13758/WS283/c_elegans.PRJNA13758.WS283.genome.fa"
elif [[ $1 == "c_tropicalis" ]]; then
    vcf="$vcf_dir/"
    gff="/vast_data/genomes/NIC58_nanopore/June2021/csq/c_tropicalis.NIC58_nanopore.June2021.csq.gff3"
    ref_genome="/vast_data/genomes/NIC58_nanopore/June2021/c_tropicalis.NIC58_nanopore.June2021.genome.fa"
elif [[ $1 == "c_briggsae" ]]; then
    vcf="$vcf_dir/"
    gff="/vast_data/genomes/QX1410_nanopore/Feb2020/csq/c_briggsae.QX1410_nanopore.Feb2020.csq.gff3"
    ref_genome="/vast_data/genomes/QX1410_nanopore/Feb2020/c_briggsae.QX1410_nanopore.Feb2020.genome.fa"
else
    echo "Unsupported organism: $1"
    exit 1
fi

mkdir -p $output_dir

# Use singularity exec for non-interactive execution
singularity exec --bind $vast_data:/vast_data \
                 --bind $output_dir:/annotation_output \
                 --bind $vcf_dir:/vcf_dir \
                 $containerImage bcftools csq \
                 -O z --fasta-ref $ref_genome \
                 --gff-annot $gff \
                 --ncsq 224 \
                 --phase a $vcf > "$output_dir/$(basename ${vcf} .vcf.gz).bcsq.vcf.gz"

