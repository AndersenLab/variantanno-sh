#!/bin/bash

# Paths to files
gff_annotation="/ANNOVAR_input/db_build_2/c_elegans.PRJNA13758.WS283.csq.gff3"
database="/ANNOVAR_input/db_build_2/c_elegans.PRJNA13758.WS283.csq_refGeneMrna.fa"
input_file="/ANNOVAR_input/db_build_2/c_elegans.PRJNA13758.WS283.csq_refGene.txt"
ref_genome="/ANNOVAR_input/db_build_2/c_elegans.PRJNA13758.WS283.genome.fa"

# Check for presence of GFF annotation file, and convert to gtf
if [ -f "${gff_annotation}" ]; then
    gffread "$gff_annotation" -T -o /ANNOVAR_input/db_build_2/c_elegans.PRJNA13758.WS283.csq.gtf
else 
    echo "gff file not present"
fi

# Convert formatting for ANNOVAR 
if [ ! -f "$input_file" ]; then
    gtfToGenePred -genePredExt /ANNOVAR_input/db_build_2/c_elegans.PRJNA13758.WS283.csq.gtf /ANNOVAR_input/db_build_2/c_elegans.PRJNA13758.WS283.csq_refGene.txt
fi

if [ ! -f "$database" ] && [ -f "$ref_genome" ]; then
    cd /ANNOVAR_input/db_build_2/
    perl /scripts/retrieve_seq_from_fasta.pl --format refGene --seqfile "$ref_genome" "$input_file" --out c_elegans.PRJNA13758.WS283.csq_refGeneMrna.fa 
fi

cd /annotation_output/
mkdir -p container_final_analysis
cd container_final_analysis
if [ -f "$input_file" ] && [ -f "$database" ] && [ -f "$gff_annotation" ]; then
    perl /scripts/table_annovar.pl \
    /ANNOVAR_input/WI.20231213.hard-filter.isotype.vcf.gz /ANNOVAR_input/db_build_2 \
    --buildver c_elegans.PRJNA13758.WS283.csq \
    --outfile C_elegans_ANNOVAR \
    --protocol refGene \
    --remove \
    --operation g \
    --thread 24 \
    --gff3dbfile /ANNOVAR_input/db_build_2/c_elegans.PRJNA13758.WS283.csq.gff3 \
    --nopolish \
    --vcfinput 
fi

