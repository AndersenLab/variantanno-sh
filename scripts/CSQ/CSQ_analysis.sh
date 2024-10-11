#!/bin/bash

if [[ $1 == "c_elegans" ]]; then
    vcf="/vast_data/WI/variation/20231213/vcf/WI.20231213.hard-filter.isotype.vcf.gz"
    gff="/vast_data/genomes/PRJNA13758/WS283/csq/c_elegans.PRJNA13758.WS283.csq.gff3"
    ref_genome="/vast_data/genomes/PRJNA13758/WS283/c_elegans.PRJNA13758.WS283.genome.fa"
elif [[ $1 == "c_tropicalis" ]]; then
    vcf="/vast_data/WI/variation/20231201/vcf/WI.20231201.hard-filter.isotype.vcf.gz"
    gff="/vast_data/genomes/NIC58_nanopore/June2021/csq/c_tropicalis.NIC58_nanopore.June2021.csq.gff3"
    ref_genome="/vast_data/genomes/NIC58_nanopore/June2021/c_tropicalis.NIC58_nanopore.June2021.genome.fa"
elif [[ $1 == "c_briggsae" ]]; then
    vcf="/home/loconn13/vast-eande106/data/c_briggsae/WI/variation/20240129/vcf/WI.20240129.hard-filter.isotype.vcf.gz"
    gff="/home/loconn13/vast-eande106/data/c_briggsae/genomes/QX1410_nanopore/Feb2020/csq/c_briggsae.QX1410_nanopore.Feb2020.csq.gff3"
    ref_genome="/home/loconn13/vast-eande106/data/c_briggsae/genomes/QX1410_nanopore/Feb2020/c_briggsae.QX1410_nanopore.Feb2020.genome.fa"
else
    echo "Unsupported organism: $1"
    exit 1
fi


mkdir -p /annotation_output/containerRun
output_file="/annotation_output/containerRun/$(basename ${vcf} .vcf.gz).bcsq.vcf.gz"

bcftools csq -O z --fasta-ref "$ref_genome" \
    --gff-annot "$gff" \
    --ncsq 224 \
    --phase a "$vcf" > "$output_file"