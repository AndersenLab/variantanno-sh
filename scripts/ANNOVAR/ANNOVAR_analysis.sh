#!/bin/bash

# Paths to files
if [[ $1 == "c_elegans" ]]; then
    gff="/vast_data/genomes/PRJNA13758/WS283/csq/c_elegans.PRJNA13758.WS283.csq.gff3"
    database_dir="/ANNOVAR_input/db_build_2"
    ref_genome="/vast_data/genomes/PRJNA13758/WS283/c_elegans.PRJNA13758.WS283.genome.fa"
    vcf="/vcf_dir/WI.20250331.hard-filter.isotype.biallelic.NoMt.HDR.vcf.gz"
    build_ver="PRJNA13758.WS283"
elif [[ $1 == "c_tropicalis" ]]; then
    gff="/vast_data/genomes/NIC58_nanopore/June2021/csq/NIC58.update.April2025.noWBGeneID.csq.gff3"
    database_dir="/ANNOVAR_input/db_build"
    ref_genome="/vast_data/genomes/NIC58_nanopore/June2021/c_tropicalis.NIC58_nanopore.June2021.genome.fa"
    vcf="/vcf_dir/WI.20250331.hard-filter.isotype.biallelic.NoMt.HDR.vcf.gz"
    build_ver="NIC58_nanopore.June2021"
elif [[ $1 == "c_briggsae" ]]; then
    gff="/vast_data/genomes/QX1410_nanopore/Feb2020/csq/QX1410.update.June2025.noWBGeneID.csq.gff3" 
    database_dir="/ANNOVAR_input/db_build"
    ref_genome="/vast_data/genomes/QX1410_nanopore/Feb2020/c_briggsae.QX1410_nanopore.Feb2020.genome.fa"
    vcf="/vcf_dir/WI.20250626.hard-filter.isotype.biallelic.NoMt.HDR.vcf.gz"
    build_ver="QX1410_nanopore.Feb2020"
fi 

# Check if database is made - if so, skip database creation
database="${build_ver}_refGeneMrna.fa"
if [ -f "$database_dir/$database" ]; then
    echo "Database exists, skipping database creation."
else
    # Check for presence of GFF annotation file, and convert to gtf
    if [ -f "$gff" ]; then
        gtf="${database_dir}/${build_ver}.gtf"
        if [ ! -f $gtf ]; then
            gffread "$gff" -T -o "$gtf"
        fi
    else 
        echo "missing GFF file"
    fi

    # Convert formatting for ANNOVAR 
    if [ -f "$gtf" ]; then
        input_file="${database_dir}/${build_ver}_refGene.txt"
        if [ ! -f "$input_file" ]; then
            if ! gtfToGenePred -genePredExt "$gtf" "$input_file"; then
                echo "Error converting GTF file to GenePred format"
                exit 1
            fi
        fi
        if [ -f "$input_file" ]; then
            echo "refGene.txt file created: ${input_file}"
        fi
    else
        echo "Missing GTF file"
    fi

    if [ -f "$input_file" ] && [ -f "$ref_genome" ]; then
        cd "$database_dir"
        if [ ! -f "$database" ]; then
            if ! perl /scripts/retrieve_seq_from_fasta.pl --format refGene --seqfile "$ref_genome" "$input_file" --out "$database"; then
                echo "Error creating database file ${database}"
                exit 1
            fi
        fi
        if [ -f "$database" ]; then 
            echo "database file, ${database}, successfully made"
        fi
    else 
        echo "RefGene.txt file or reference genome missing for database creation"
    fi
fi

# Perform ANNOVAR annotation
cd /annotation_output/
mkdir -p containerRun
cd containerRun
if [ -f $database_dir/$database ] && [ -f $gff ]; then 
    if ! perl /scripts/table_annovar.pl \
        $vcf $database_dir \
        --buildver $build_ver \
        --outfile "${1}.biallelic.NoMt.HDR.ANNOVAR" \
        --protocol refGene \
        --remove \
        --operation g \
        --thread 24 \
        --gff3dbfile $gff \
        --nopolish \
        --vcfinput; then
            echo "Error running annotation with ANNOVAR"
    fi
else
    echo "A file is missing... check VCF, database file, and GFF"
fi
