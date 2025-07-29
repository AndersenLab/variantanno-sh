#!/bin/bash

#SBATCH -J VEP       # Job name
#SBATCH -A eande106          # Allocation name
#SBATCH -p parallel          # Partition/Queue name
#SBATCH -t 12:00:00          # Job walltime/duration (hh:mm:ss)
#SBATCH -N 1                 # Number of nodes
#SBATCH -n 12                 # Number of cores
#SBATCH --mail-user=loconn13@jh.edu  # Email for notifications
#SBATCH --mail-type=END      # Notify when job ends
#SBATCH --output=/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/VEP/c_briggsae/SLURM_output/0721_Cb.oe  # Output log
#SBATCH --error=/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/VEP/c_briggsae/SLURM_output/0721_Cb.rr  # Error log

# Select species-specific files based on input argument
if [[ $1 == "c_elegans" ]]; then
    gff="/vast/eande106/data/c_elegans/genomes/PRJNA13758/WS283/csq/c_elegans.PRJNA13758.WS283.csq.gff3"
    ref_genome="/genomes/PRJNA13758/WS283/c_elegans.PRJNA13758.WS283.genome.fa"
    vcf="WI.20250331.hard-filter.isotype.biallelic.NoMt.HDR.vcf.gz"           
elif [[ $1 == "c_tropicalis" ]]; then
    gff="/vast/eande106/data/c_tropicalis/genomes/NIC58_nanopore/June2021/csq/NIC58.update.April2025.noWBGeneID.csq.gff3"
    ref_genome="/genomes/NIC58_nanopore/June2021/c_tropicalis.NIC58_nanopore.June2021.genome.fa"
    vcf="WI.20250331.hard-filter.isotype.biallelic.NoMt.HDR.vcf.gz"
elif [[ $1 == "c_briggsae" ]]; then
    gff="/vast/eande106/data/c_briggsae/genomes/QX1410_nanopore/Feb2020/csq/QX1410.update.June2025.noWBGeneID.csq.gff3" 
    ref_genome="/genomes/QX1410_nanopore/Feb2020/c_briggsae.QX1410_nanopore.Feb2020.genome.fa"
    vcf="WI.20250626.hard-filter.isotype.biallelic.NoMt.HDR.vcf.gz"
else 
    echo "Please provide a selfing species: c_elegans, c_tropicalis, c_briggsae"
fi

# Container image and environment setup
container_image="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/container_images/loconn13999-ensemble_vep_2024_05_24.sif"
raw_data="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/raw_data"
output_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/VEP/$1/containerRun"
vcf_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/$1"
# plugins="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/raw_data/VEP/plugins"

module load singularity

mkdir -p $raw_data/VEP/$1
cd $raw_data/VEP/$1

# Sort GFF file for format that VEP needs
grep -v "#" $gff | sort -k1,1 -k4,4n -k5,5n -t$'\t' | bgzip -c > "$(basename $gff .gff3)_VEPsorted.gff3.gz"
tabix -p gff "$(basename $gff .gff3)_VEPsorted.gff3.gz"

mkdir -p $output_dir

# Run with only local files, no cache and no downloads
singularity exec --bind "$raw_data/VEP/$1:/raw_data" \
    --bind "$output_dir:/annotation_output" \
    --bind /vast/eande106/data/$1:/vast_data \
    --bind $vcf_dir:/vcf \
    $container_image vep \
    --vcf \
    --force_overwrite \
    --input_file /vcf/$vcf \
    --fasta /vast_data/$ref_genome \
    --gff /raw_data/$(basename $gff .gff3)_VEPsorted.gff3.gz \
    --output_file /annotation_output/$(basename $vcf .vcf.gz).VEP.vcf.gz \
    --compress_output bgzip 
    # --dir_plugins /VEPplugins \
    # --plugin Blosum62 \

# singularity exec --bind "$raw_data:/raw_data" \
#     --bind "$output_dir:/annotation_output" \
#     --bind /vast/eande106/data/$1:/vast_data \
#     --bind $vcf_dir:/vcf \
#     --bind $plugins:/VEPplugins \
#     $container_image vep \
#     --vcf \
#     --force_overwrite \
#     --input_file /vcf/$vcf \
#     --fasta /vast_data/$ref_genome \
#     --gff /raw_data/$(basename $gff .gff3)_VEPsorted.gff3.gz \
#     --output_file /annotation_output/$(basename $vcf .vcf.gz).BLOSUM.VEP.vcf.gz \
#     --dir_plugins /VEPplugins \
#     --plugin Blosum62 \
#     --vcf_info_field VEP \
#     --compress_output bgzip
