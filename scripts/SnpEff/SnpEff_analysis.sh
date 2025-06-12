#!/bin/bash

if [[ $1 == "c_elegans" ]]; then
    vcf="/vcf_dir/WI.20250331.hard-filter.isotype.biallelic.onlyMt.vcf.gz"
    config="/snpeff_input/snpEff.config"
    database_name="c_elegans.PRJNA13758.WS283"
elif [[ $1 == "c_tropicalis" ]]; then
    vcf="/vcf_dir/WI.20250331.hard-filter.isotype.biallelic.onlyMt.vcf.gz"
    config="/snpeff_input/snpEff.config"
    database_name="c_tropicalis.NIC58_nanopore.June2021"
elif [[ $1 == "c_briggsae" ]]; then
    vcf="/vcf_dir/WI.20250331.hard-filter.isotype.biallelic.onlyMt.vcf.gz"
    config="/snpeff_input/snpEff.config"
    database_name="c_briggsae.QX1410_nanopore.Feb2020"
else
    echo "Unsupported organism: $1"
    exit 1
fi

mkdir -p /annotation_output/containerRun

output_file="/annotation_output/containerRun/$(basename ${vcf} .vcf.gz).snpeff.vcf.gz"

# Build the database
cd /snpeff_input #change to the data directory specified 

if [[ $1 == "c_elegans" ]] && [[ ! -f /snpeff_input/$database_name/snpEffectPredictor.bin ]]; then
    if ! java -jar /usr/bin/snpEff/snpEff/snpEff.jar build -noCheckCds -noCheckProtein -gtf22 -v $database_name; then
        echo "Error building SnpEff database for $1"
        exit 1
    fi
fi

if [[ $1 == "c_tropicalis" ]] && [[ ! -f /snpeff_input/$database_name/snpEffectPredictor.bin ]]; then
    if ! java -jar /usr/bin/snpEff/snpEff/snpEff.jar build -noCheckCds -noCheckProtein -gtf22 -v $database_name; then
        echo "Error building SnpEff database for $1"
        exit 1
    fi
fi

if [[ $1 == "c_briggsae" ]] && [[ ! -f /snpeff_input/$database_name/snpEffectPredictor.bin ]]; then
    if ! java -jar /usr/bin/snpEff/snpEff/snpEff.jar build -noCheckCds -noCheckProtein -gtf22 -v $database_name; then
        echo "Error building SnpEff database for $1"
        exit 1
    fi
fi

# Run SnpEff annotation
if ! bcftools view -O v $vcf | \
   java -jar /usr/bin/snpEff/snpEff/snpEff.jar eff -csvStats /annotation_output/containerRun/snpeff.stats.csv \
              -nodownload \
              -dataDir /snpeff_input \
              -config $config \
              $database_name | \
   bcftools view -O z > $output_file; then
    echo "Error during VCF annotation"
    exit 1
fi

 #params.snpeff_dir = /vast/eande106/data/c_elegans/genomes/PRJNA13758/WS283/snpeff
 #params.snpeff_reference = "${params.species}.${params.project}.${params.ws_build}"
