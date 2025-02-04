#!/bin/bash

#SBATCH -J strainHDr                    # Job name
#SBATCH -A eande106                     # Allocation name
#SBATCH -p parallel                     # Partition/Queue name
#SBATCH -t 48:00:00                     # Job walltime/duration (hh:mm:ss)
#SBATCH -N 1                            # Number of nodes
#SBATCH -c 24                           # Number of cores
#SBATCH --mail-user=loconn13@jh.edu     # Email for job notifications
#SBATCH --mail-type=END                 # Notify when job ends
#SBATCH --output=/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/SLURM_output/mtRemovalHDR.oe  # Output log file
#SBATCH --error=/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/SLURM_output/mtRemovalHDR.rr 

if [[ $1 == "c_elegans" ]]; then
    strain_hdr_bed="/vast/eande106/data/c_elegans/WI/divergent_regions/20231213/20231213_c_elegans_divergent_regions_strain.bed.gz"
    vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/WI.20231213.hard-filter.isotype.biallelic.NoMt.vcf.gz"
    vcf_unfilt="/vast/eande106/data/c_elegans/WI/variation/20231213/vcf/WI.20231213.hard-filter.isotype.vcf.gz"
    output_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans"
elif [[ $1 == "c_tropicalis" ]]; then
    strain_hdr_bed="/vast/eande106/data/c_tropicalis/WI/divergent_regions/20231201/20231201_c_tropicalis_divergent_regions_strain.bed.gz"
    vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/WI.20231201.hard-filter.isotype.biallelic.NoMt.vcf.gz"
    vcf_unfilt="/vast/eande106/data/c_tropicalis/WI/variation/20231201/vcf/WI.20231201.hard-filter.isotype.vcf.gz"
    output_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis"
elif [[ $1 == "c_briggsae" ]]; then
    strain_hdr_bed=""
    vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/WI.20240129.hard-filter.isotype.biallelic.NoMt.vcf.gz"
    vcf_unfilt="/vast/eande106/data/c_briggsae/WI/variation/20240129/vcf/WI.20240129.hard-filter.isotype.vcf.gz"
    output_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae"
else
    echo "Unsupported organism: $1"
    exit 1
fi

# Filtering VCF to only biallelic sites
if [[ ! -f $vcf ]]; then
    bcftools view -m2 -M2 -e 'CHROM="MtDNA"' -O z -o $vcf $vcf_unfilt
    bcftools view -m2 -M2 -i 'CHROM="MtDNA"' -O z -o $output_dir/$(basename $vcf_unfilt .vcf.gz).onlyMt.vcf.gz $vcf_unfilt 
fi

# Create temporary directory
temp_dir=$(mktemp -d -p $output_dir)

# Extract list of strain names
sample_names=($(bcftools query -l $vcf))

# Convert VCF to BED format
vcf_bed="$temp_dir/vcf.bed"
bcftools query -f '%CHROM\t%POS\n' $vcf | awk '{print $1"\t"$2"\t"$2+1}' > $vcf_bed

# Create output file genotype matrix
output_file="$temp_dir/HDR_strain_matrix.tsv"
cut -f1,2 $vcf_bed > $output_file

# Iterate over every strain
for strain in ${sample_names[@]}; do

    temp="$temp_dir/temp_${strain}.bed"
    zgrep -w $strain $strain_hdr_bed > $temp # subset of master HDR BED file to only contain HDRs for the strain that is being iterated on

    # Identify variants within HDRs for the specific strain being iterated on
    intersect_bed="$temp_dir/${strain}_intersect.bed"
    bedtools intersect -a $vcf_bed -b $temp -wa | cut -f1,2 > $intersect_bed

    # Temporary file to hold new strain genotype data
    temp_geno="$temp_dir/temp_geno.txt"

    variant_positions="$temp_dir/variant_positions.tsv"
    cut -f1,2 $vcf_bed > $variant_positions

    # Generate genotype data for for each variant position
    awk -v intersect_bed=$intersect_bed -v strain=$strain '
    BEGIN {
        while (getline < intersect_bed > 0) arr[$1 FS $2] = 1
    }
    {
        if (strain == "N2") 
            print 0;
        else if (($1 FS $2) in arr) 
            print 1;
        else 
            print 0;
    }' $variant_positions > $temp_geno

    # Append new column to the genotype matrix
    paste -d '\t' $output_file $temp_geno > ${output_file}.tmp
    mv ${output_file}.tmp $output_file

    rm $temp #$temp_geno
done

zippped_output=${output_file}.gz
bgzip -c $output_file > $zippped_output
tabix -s1 -b2 -e2 $zippped_output

# Creating the final annotated VCF
final_vcf="${vcf%.vcf.gz}.HDR.vcf.gz"

# Must add a header to VCF
header=$temp_dir/HDR.hdr
echo '##FORMAT=<ID=HDR,Number=1,Type=Integer,Description="HDR annotation: 1 for YES, 0 for NO">'  > $header 

# Add HDR annotations to the VCF
sample_list=$temp_dir/samples.txt
bcftools query -l $vcf  > $sample_list

bcftools annotate \
    --annotations $zippped_output \
    --columns CHROM,POS,FORMAT/HDR \
    --header-lines $header \
    --samples-file $sample_list \
    --output $final_vcf \
    --output-type z \
    $vcf


### QC to make sure it is running correctly ###
# extract binary matrix for AB1 from $zippped_output
awk '{print $3}' $output_file > $temp_dir/AB1_genoMatrix.txt

# extract HDR annotation for AB1 (zeros and one)
bcftools query -f '%CHROM\t[%SAMPLE=%HDR]\n' -s AB1 $final_vcf | awk -F'=' '{print $2}' > $temp_dir/AB1_VCF.txt

if cmp -s $temp_dir/AB1_genoMatrix.txt $temp_dir/AB1_VCF.txt; then 
    rm -r $temp_dir
else   
    echo "HDR resolution may not have worked - binary matrices are different"


