#!/bin/bash

#SBATCH -J reformatVCF
#SBATCH -A eande106
#SBATCH -p parallel
#SBATCH -t 48:00:00
#SBATCH -N 1
#SBATCH -c 24
#SBATCH --output=/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/SLURM_output/individualFlatFiles.oe  
#SBATCH --error=/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/SLURM_output/individualFlatFiles.rr 

if [[ $1 == "c_elegans" ]]; then
    VEP_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/VEP/c_elegans/containerRun/WI.20231213.hard-filter.isotype.biallelic.NoMt.HDR.BLOSUM.VEP.vcf.gz"
    CSQ_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/CSQ/c_elegans/containerRun/WI.20231213.hard-filter.isotype.biallelic.NoMt.HDR.bcsq.GRANTHAM.vcf.gz"
    SnpEff_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/SnpEff/c_elegans/containerRun/WI.20231213.hard-filter.isotype.onlyMt.snpeff.GRANTHAM.vcf.gz"
    SnpEff_preAnnoVCF="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/WI.20231213.hard-filter.isotype.onlyMt.vcf.gz"
    ANNOVAR_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/ANNOVAR/c_elegans/containerRun/c_elegans.ANNOVAR.biallelic.HDR.NoMt.PRJNA13758.WS283_multianno.vcf"
    SIFT_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/SIFT/c_elegans/nematode_db_run/WI.20231213.hard-filter.isotype.biallelic.NoMt.HDR_SIFTpredictions.final.vcf.gz"
    output_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/HDRres_merging"
elif [[ $1 == "c_tropicalis" ]]; then
    VEP_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/VEP/c_tropicalis/containerRun/XXXXX"
    CSQ_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/CSQ/c_tropicalis/containerRun/XXXXX"
    SnpEff_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/SnpEff/c_tropicalis/containerRun/XXXXX"
    ANNOVAR_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/ANNOVAR/c_tropicalis/containerRun/XXXXX"
    SIFT_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/SIFT/c_tropicalis/XXXXX"
    output_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/HDRres_merging"

elif [[ $1 == "c_briggsae" ]]; then
    VEP_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/VEP/c_briggsae/containerRun/XXXXX"
    CSQ_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/CSQ/c_briggsae/containerRun/XXXXX"
    SnpEff_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/SnpEff/c_briggsae/containerRun/XXXXX"
    ANNOVAR_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/ANNOVAR/c_briggsae/containerRun/XXXXX"
    SIFT_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/SIFT/c_briggsae//XXXXX"
    output_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/HDRres_merging"
else
    echo "Unsupported organism: $1"
    exit 1
fi

### UNIT TEST TO COMPARE CHROM, POS, ALT, REF, AND GENOTYPE MATRIX FOR EVERY ANNOTATED VCF PRIOR TO TSV CREATION
# VEPcheck=$(mktemp)
# CSQcheck=$(mktemp)
# ANVcheck=$(mktemp)
# SIFTcheck=$(mktemp)

# bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%SAMPLE=%GT:%HDR]\n' $VEP_annotated_vcf > $VEPcheck
# bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%SAMPLE=%GT:%HDR]\n' $CSQ_annotated_vcf > $CSQcheck
# bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%SAMPLE=%GT:%HDR]\n' $ANNOVAR_annotated_vcf > $ANVcheck
# bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%SAMPLE=%GT:%HDR]\n' $SIFT_annotated_vcf > $SIFTcheck

# # Store VCF names in an array for easier comparison
# declare -A VCF_key
# VCF_key["$VEPcheck"]="VEP"
# VCF_key["$CSQcheck"]="CSQ"
# VCF_key["$ANVcheck"]="ANNOVAR"
# VCF_key["$SIFTcheck"]="SIFT"

# # Define an array of the generated files
# VCF_FILES=($VEPcheck $CSQcheck $ANVcheck $SIFTcheck)

# # Reference file (first in the list)
# reference=${VCF_FILES[0]} #using annotated VEP vcf as the "reference" for comparison 
# referenceName=${VCF_key[$reference]} # "VEP"

# difference=0
# # Compare each annotated VCF against the reference
# for file in ${VCF_FILES[@]:1}; do
#     if ! diff $reference $file > $output_dir/${referenceName}_${VCF_key[$file]}_difference.txt; then # negating exit status of 1 if the files are different so that script doesn't exit and the echo statement is printed
#         echo "Mismatch detected: $referenceName vs ${VCF_key[$file]}"
#         difference=1
#     fi
# done

# rm $VEPcheck $CSQcheck $ANVcheck $SIFTcheck

# # Exit if differences found
# if [[ $difference -eq 1 ]]; then
#     echo "ERROR: VCF files have differences. Exiting..."
#     exit 1
# else
#     echo "All VCFs match. Proceeding with analysis."
#     rm $output_dir/*_difference.txt
# fi





# ## NOTES ###
# # HOW DO WE HANDLE DISGREPANCIES OF MULTPLE ANNOTATION 







# CSQ
# BCSQ=missense|WBGene00022277|Y74C9A.3.1|protein_coding|-|226P>226L|4249G>A
# BCSQ=@1799727,synonymous|WBGene00022145|Y71G12B.5a.1|protein_coding|+|437T|1802558C>T
# BCSQ=*synonymous|WBGene00022145|Y71G12B.5a.1|protein_coding|+|400S|1801988C>T,@1799727,@1799884,@1801478,@1801900
# BCSQ=synonymous|WBGene00001542|W03F11.2a.1|protein_coding|-|712V|2226063T>C,@2226065,synonymous|WBGene00001542|W03F11.2b.1|protein_coding|-|709V|2226063T>C
echo -e "CHROM\tPOS\tREF\tALT\tCSQ_consequence\tCSQ_AA_change\tGRANTHAM_score\tALL_SAMPLES_WITH_ALT" > "$output_dir/CSQ_flatFile_nonHDR_$1.tsv"

# non-HDR variants
bcftools query \
    -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/GRANTHAM_SCORE\t%INFO/BCSQ[\t%SAMPLE=%GT:%HDR]\n' -i 'HDR=0' \
    "$CSQ_annotated_vcf" | \
awk -F'\t' '{
    ALT_samples = "";  
    for (i = 7; i <= NF; i++) {  
        if ($i ~ /0\/1|1\/0|1\/1/) { 
            sub(/=.*/, "", $i);  
            ALT_samples = ALT_samples (ALT_samples ? " " : "") $i; 
        }
    }
   
    CSQ_consequence = "N/A";
    CSQ_AA_change = "N/A";
    Grantham_score = "N/A";

    if ($5 != ".") {
        Grantham_score = $5;  # Assign Grantham score if present
    }

    if ($6 != ".") {
        split($6, csq, "|");  
        if (csq[1] ~ /^@/) { # If the first field starts with "@", split it further by a comma and extract "@position"
            split(csq[1], haplotype_parts, ",");
            CSQ_consequence = haplotype_parts[1];  
            CSQ_AA_change = haplotype_parts[1];    
        } else {
            CSQ_consequence = (csq[1] != "" ? csq[1] : "N/A");
            CSQ_AA_change = (csq[6] != "" ? csq[6] : "N/A");
        }
    }

    if (ALT_samples != "") {
        print $1"\t"$2"\t"$3"\t"$4"\t"CSQ_consequence"\t"CSQ_AA_change"\t"Grantham_score"\t"ALT_samples;
    }
}' >> "$output_dir/CSQ_flatFile_nonHDR_$1.tsv"

# HDR variants
echo -e "CHROM\tPOS\tREF\tALT\tCSQ_consequence\tCSQ_AA_change\tGRANTHAM_score\tALL_SAMPLES_WITH_ALT" > "$output_dir/CSQ_flatFile_HDR_$1.tsv"

bcftools query \
    -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/GRANTHAM_SCORE\t%INFO/BCSQ[\t%SAMPLE=%GT:%HDR]\n' -i 'HDR=1' \
    "$CSQ_annotated_vcf" | \
awk -F'\t' '{
    ALT_samples = "";  
    for (i = 7; i <= NF; i++) {  
        if ($i ~ /0\/1|1\/0|1\/1/) { 
            sub(/=.*/, "", $i);  
            ALT_samples = ALT_samples (ALT_samples ? " " : "") $i; 
        }
    }

    CSQ_consequence = "N/A";
    CSQ_AA_change = "N/A";
    Grantham_score = "N/A";

    if ($5 != ".") {
        Grantham_score = $5;  # Assign Grantham score if present
    }

    if ($6 != ".") {
        split($6, csq, "|");  
        if (csq[1] ~ /^@/) { # If the first field starts with "@", split it further by a comma and extract "@position"
            split(csq[1], haplotype_parts, ",");
            CSQ_consequence = haplotype_parts[1];  
            CSQ_AA_change = haplotype_parts[1];    
        } else {
            CSQ_consequence = (csq[1] != "" ? csq[1] : "N/A");
            CSQ_AA_change = (csq[6] != "" ? csq[6] : "N/A");
        }
    }

    if (ALT_samples != "") {
        print $1"\t"$2"\t"$3"\t"$4"\t"CSQ_consequence"\t"CSQ_AA_change"\t"Grantham_score"\t"ALT_samples;
    }
}' >> "$output_dir/CSQ_flatFile_HDR_$1.tsv"




# # VEP 
# # VEP=A|missense_variant|MODERATE|WBGene00022277|WBGene00022277|Transcript|Y74C9A.3.1|protein_coding|5/5||||759|677|226|P/L|cCt/cTt|||-1||||c_elegans.PRJNA13758.WS283.csq_VEPsorted.gff3.gz|-3|

# # EXTRACT BLOSUM AND GRANTHAM ANNOTATIONS
# echo -e "CHROM\tPOS\tREF\tALT\tVEP_consequence\tVEP_impact\tVEP_AA_change\tBLOSUM_score\tALL_SAMPLES_WITH_ALT" > "$output_dir/VEP_flatFile_nonHDR_$1.tsv"
 
# # non-HDR variants
# bcftools query \
#     -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/VEP[\t%SAMPLE=%GT:%HDR]\n' -i 'HDR=0' \
#     "$VEP_annotated_vcf" | \
# awk -F'\t' '{
#     ALT_samples = "";  
#     for (i = 6; i <= NF; i++) {  
#         if ($i ~ /0\/1|1\/0|1\/1/) { 
#             sub(/=.*/, "", $i);  
#             ALT_samples = ALT_samples (ALT_samples ? " " : "") $i; 
#         }
#     }
#     if (ALT_samples != "") {
#         split($5, fields, "|");  #split VEP annotation by pipe
#         VEP_consequence = fields[2];  
#         VEP_impact = fields[3];  
#         VEP_AA_change = (fields[16] != "" ? fields[16] : "N/A");
#         blosum62score = (fields[25] != "" ? fields[25] : "N/A");
#         print $1"\t"$2"\t"$3"\t"$4"\t"VEP_consequence"\t"VEP_impact"\t"VEP_AA_change"\t"blosum62score"\t"ALT_samples; 
#     }
# }' >> "$output_dir/VEP_flatFile_nonHDR_$1.tsv"


# # HDR variants
# echo -e "CHROM\tPOS\tREF\tALT\tVEP_consequence\tVEP_impact\tVEP_AA_change\tBLOSUM_score\tALL_SAMPLES_WITH_ALT" > "$output_dir/VEP_flatFile_HDR_$1.tsv"

# bcftools query \
#     -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/VEP[\t%SAMPLE=%GT:%HDR]\n' -i 'HDR=1' \
#     "$VEP_annotated_vcf" | \
# awk -F'\t' '{
#     ALT_samples = "";  #initialize string to collect samples with alt allele
#     for (i = 6; i <= NF; i++) {  #starts at the 6th column and iterates through all the remaining columns to the last column
#         if ($i ~ /0\/1|1\/0|1\/1/) {  #check if sample has alt allele via string matching for what is in each sample & IS within a HDR
#             sub(/=.*/, "", $i);  #remove genotype - leaving only sample name
#             ALT_samples = ALT_samples (ALT_samples ? " " : "") $i;  #append sample name
#         }
#     }
#     if (ALT_samples != "") {
#         split($5, fields, "|");  #split VEP annotation by pipe
#         VEP_consequence = fields[2];  
#         VEP_impact = fields[3];  
#         VEP_AA_change = (fields[16] != "" ? fields[16] : "N/A");
#         blosum62score = (fields[25] != "" ? fields[25] : "N/A");
#         print $1"\t"$2"\t"$3"\t"$4"\t"VEP_consequence"\t"VEP_impact"\t"VEP_AA_change"\t"blosum62score"\t"ALT_samples; 
#     }
# }' >> "$output_dir/VEP_flatFile_HDR_$1.tsv"



# ANNOVAR 
# ANNOVAR_DATE=2020-06-08;Func.refGene=exonic;Gene.refGene=gene:WBGene00022277;GeneDetail.refGene=.;ExonicFunc.refGene=nonsynonymous_SNV;AAChange.refGene=gene:WBGene00022277
# ANNOVAR_DATE=2020-06-08;ExonicFunc.refGene=synonymous_SNV;AAChange.refGene=gene:WBGene00021355:transcript:Y37E3.17d.1:exon3:c.G321A:p.L107L,gene:WBGene00021355:transcript:Y37E3.17a.1:exon2:c.G300A:p.L100L,gene:WBGene00021355

# echo -e "CHROM\tPOS\tREF\tALT\tANV_consequence\tANV_impact\tANV_AA_change\tALL_SAMPLES_WITH_ALT" > "$output_dir/ANV_flatFile_nonHDR_$1.tsv"

# # non-HDR variants
# bcftools query \
#     -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO[\t%SAMPLE=%GT:%HDR]\n' -i 'HDR=0' \
#     "$ANNOVAR_annotated_vcf" | \
# awk -F'\t' '{
#     split($5, anv, ";"); 
#     ALT_samples = "";  
#     for (i = 6; i <= NF; i++) {  
#         if ($i ~ /0\/1|1\/0|1\/1/) {  
#             sub(/=.*/, "", $i); 
#             ALT_samples = ALT_samples (ALT_samples ? " " : "") $i; 
#         }
#     }
#     if (ALT_samples != "") {
#         ANV_consequence = "N/A";  
#         ANV_impact = "N/A";       
#         ANV_AA_change = "N/A";    
#         for (field in anv) {
#             split(anv[field], fields, "=");  # Split each ANV field by "=" to separate the tag from its value
#             if (fields[1] == "Func.refGene") ANV_consequence = fields[2];
#             else if (fields[1] == "ExonicFunc.refGene") ANV_impact = (fields[2] == "." ? "N/A" : fields[2]);
#             else if (fields[1] == "AAChange.refGene") {
#                 split(fields[2], AA_change_parts, ":");  # Split the AAChange.refGene value by colon
#                 ANV_AA_change = (AA_change_parts[7] != "" ? gensub(/,gene$/, "", "g", AA_change_parts[7]) : "N/A");
#             }
#         }
#         print $1"\t"$2"\t"$3"\t"$4"\t"ANV_consequence"\t"ANV_impact"\t"ANV_AA_change"\t"ALT_samples; 
#     }
# }' >> "$output_dir/ANV_flatFile_nonHDR_$1.tsv"

# # HDR variants
# echo -e "CHROM\tPOS\tREF\tALT\tANV_consequence\tANV_impact\tANV_AA_change\tALL_SAMPLES_WITH_ALT" > "$output_dir/ANV_flatFile_HDR_$1.tsv"

# bcftools query \
#     -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO[\t%SAMPLE=%GT:%HDR]\n' -i 'HDR=1' \
#     "$ANNOVAR_annotated_vcf" | \
# awk -F'\t' '{
#     split($5, anv, ";"); 
#     ALT_samples = "";  
#     for (i = 6; i <= NF; i++) {  
#         if ($i ~ /0\/1|1\/0|1\/1/) {  
#             sub(/=.*/, "", $i); 
#             ALT_samples = ALT_samples (ALT_samples ? " " : "") $i; 
#         }
#     }
#     if (ALT_samples != "") {
#         ANV_consequence = "N/A";  
#         ANV_impact = "N/A";       
#         ANV_AA_change = "N/A";    
#         for (field in anv) {
#             split(anv[field], fields, "=");  # Split each ANV field by "=" to separate the tag from its value
#             if (fields[1] == "Func.refGene") ANV_consequence = fields[2];
#             else if (fields[1] == "ExonicFunc.refGene") ANV_impact = (fields[2] == "." ? "N/A" : fields[2]);
#             else if (fields[1] == "AAChange.refGene") {
#                 split(fields[2], AA_change_parts, ":");  # Split the AAChange.refGene value by colon
#                 ANV_AA_change = (AA_change_parts[7] != "" ? gensub(/,gene$/, "", "g", AA_change_parts[7]) : "N/A");
#             }
#         }
#         print $1"\t"$2"\t"$3"\t"$4"\t"ANV_consequence"\t"ANV_impact"\t"ANV_AA_change"\t"ALT_samples;
#     }
# }' >> "$output_dir/ANV_flatFile_HDR_$1.tsv"



# # SIFT 
# # SIFTINFO=A|transcript.Y74C9A.3.1|gene.WBGene00022277|NA|CDS|NONSYNONYMOUS|P/L|226|0.00|3.45|25|novel|DELETERIOUS
# # SIFTINFO=T|transcript.Y74C9A.4c.1|gene.WBGene00022278|NA|CDS|SYNONYMOUS|A/A|155|0.14|2.83|14|novel|TOLERATED,T
# echo -e "CHROM\tPOS\tREF\tALT\tSIFT_consequence\tSIFT_score\tSIFT_impact\tSIFT_AA_change\tALL_SAMPLES_WITH_ALT" > "$output_dir/SIFT_flatFile_nonHDR_$1.tsv" ### NEED TO ACCOUNT FOR THE FACT THAT SIFT ONLY ANNOTATES SOME VARIANTS AND OTHER ANNOTATIONS ARE "."

# # non-HDR variants
# bcftools query \
#     -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/SIFTINFO[\t%SAMPLE=%GT:%HDR]\n' -i 'HDR=0' \
#     "$SIFT_annotated_vcf" | \
# awk -F'\t' '{
#     ALT_samples = "";  # Initialize string to collect samples with alt allele
#     for (i = 6; i <= NF; i++) {  # Loop through fields containing sample=genotype
#         if ($i ~ /0\/1|1\/0|1\/1/) {  # Check if sample has alt allele
#             sub(/=.*/, "", $i);  # Remove genotype - leaving only sample name
#             ALT_samples = ALT_samples (ALT_samples ? " " : "") $i;  # Append sample name
#         }
#     }
    
#     SIFT_consequence = "N/A";
#     SIFT_score = "N/A";
#     SIFT_impact = "N/A";
#     SIFT_AA_change = "N/A";

#     if ($5 != ".") {
#         split($5, sift, "|");  # Split SIFTINFO field by pipe
#         SIFT_consequence = (sift[6] != "" ? sift[6] : "N/A");
#         SIFT_score = (sift[9] == "NA" ? "N/A" : (sift[9] != "" ? sift[9] : "N/A"));
#         SIFT_impact = (sift[13] == "NA,A" || sift[13] == "NA" ? "N/A" : (sift[13] != "" ? gensub(/,.*/, "", "g", sift[13]) : "N/A"));
#         SIFT_AA_change = (sift[7] == "NA/NA" ? "N/A" : (sift[7] != "" ? sift[7] : "N/A"));
#     }

#     if (ALT_samples != "") {
#         print $1"\t"$2"\t"$3"\t"$4"\t"SIFT_consequence"\t"SIFT_score"\t"SIFT_impact"\t"SIFT_AA_change"\t"ALT_samples; 
#     }
# }' >> "$output_dir/SIFT_flatFile_nonHDR_$1.tsv"

# # HDR variants
# echo -e "CHROM\tPOS\tREF\tALT\tSIFT_consequence\tSIFT_score\tSIFT_impact\tSIFT_AA_change\tALL_SAMPLES_WITH_ALT" > "$output_dir/SIFT_flatFile_HDR_$1.tsv"

# bcftools query \
#     -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/SIFTINFO[\t%SAMPLE=%GT:%HDR]\n' -i 'HDR=1' \
#     "$SIFT_annotated_vcf" | \
# awk -F'\t' '{
#     ALT_samples = "";  # Initialize string to collect samples with alt allele
#     for (i = 6; i <= NF; i++) {  # Loop through fields containing sample=genotype
#         if ($i ~ /0\/1|1\/0|1\/1/) {  # Check if sample has alt allele
#             sub(/=.*/, "", $i);  # Remove genotype - leaving only sample name
#             ALT_samples = ALT_samples (ALT_samples ? " " : "") $i;  # Append sample name
#         }
#     }
    
#     SIFT_consequence = "N/A";
#     SIFT_score = "N/A";
#     SIFT_impact = "N/A";
#     SIFT_AA_change = "N/A";

#     if ($5 != ".") {
#         split($5, sift, "|");  # Split SIFTINFO field by pipe
#         SIFT_consequence = (sift[6] != "" ? sift[6] : "N/A");
#         SIFT_score = (sift[9] == "NA" ? "N/A" : (sift[9] != "" ? sift[9] : "N/A"));
#         SIFT_impact = (sift[13] == "NA,A" || sift[13] == "NA" ? "N/A" : (sift[13] != "" ? gensub(/,.*/, "", "g", sift[13]) : "N/A"));
#         SIFT_AA_change = (sift[7] == "NA/NA" ? "N/A" : (sift[7] != "" ? sift[7] : "N/A"));
#     }

#     if (ALT_samples != "") {
#         print $1"\t"$2"\t"$3"\t"$4"\t"SIFT_consequence"\t"SIFT_score"\t"SIFT_impact"\t"SIFT_AA_change"\t"ALT_samples; 
#     }
# }' >> "$output_dir/SIFT_flatFile_HDR_$1.tsv"


# # SnpEff
# # ANN=T|missense_variant|MODERATE|transcript:MTCE.6|null.20830|transcript|transcript:MTCE.6|pseudogene|1/1|n.28C>T|p.Leu10Phe|28/55|28/-1|10/-1||WARNING_TRANSCRIPT_INCOMPLETE

# # Make sure same number of MtDNA variants before and after annotation
# mkdir -p $output_dir/finalMerge

# before="$output_dir/finalMerge/before_genotypes.tsv"s
# after="$output_dir/finalMerge/after_genotypes.tsv"

# bcftools query -f '[%CHROM\t%POS\t%SAMPLE=%GT]\n' $SnpEff_preAnnoVCF > $before
# bcftools query -f '[%CHROM\t%POS\t%SAMPLE=%GT]\n' $SnpEff_annotated_vcf > $after

# if cmp -s $before $after; then
#     echo -e "CHROM,POS,REF,ALT,SnpEff_consequence,SnpEff_impact,SnpEff_AA_change,GRANTHAM_score,ALL_SAMPLES_WITH_ALT" > "$output_dir/finalMerge/SnpEff_flatFile_$1.csv"

#     bcftools query \
#         -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/GRANTHAM_SCORE\t%INFO/ANN[\t%SAMPLE=%GT]\n' \
#         $SnpEff_annotated_vcf | \
#     awk -F'\t' '{
#         ALT_samples = "";  #initialize string to collect samples with alt allele
#         for (i = 7; i <= NF; i++) {  #loop through fields containing sample=genotype
#             if ($i ~ /0\/1|1\/0|1\/1/) {  #check if sample has alt allele
#                 sub(/=.*/, "", $i);  #remove genotype - leaving only sample name
#                 ALT_samples = ALT_samples (ALT_samples ? " " : "") $i;  #append sample name
#             }
#         }
#         GRANTHAM_score = "N/A";

#         if ($5 != ".") {
#             GRANTHAM_score = $5
#         }

#         split($6, snpEff, "|");  #split SIFTINFO field by pipe
#         SnpEff_consequence = snpEff[2];
#         SnpEff_impact = snpEff[3];  
#         SnpEff_AA_change = (snpEff[11] != "" ? snpEff[11] : "N/A");
#         print $1","$2","$3","$4","SnpEff_consequence","SnpEff_impact","SnpEff_AA_change","GRANTHAM_score","ALT_samples; 
#     }' >> "$output_dir/finalMerge/SnpEff_flatFile_$1.csv"
# else
#     echo "there are differences in genotype matrix"
# fi

# rm $before $after