#!/bin/bash

#SBATCH -J flatFileMerge
#SBATCH -A eande106
#SBATCH -p parallel
#SBATCH -t 8:00:00
#SBATCH -N 1
#SBATCH -c 12
#SBATCH --mail-user=loconn13@jh.edu
#SBATCH --mail-type=END
#SBATCH --output=/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/SLURM_output/mergeTest.oe  
#SBATCH --error=/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/SLURM_output/mergeTest.rr 

### WILL NEED TO ADJUST TO TAKE INTO ACCOUNT THE NON-HDR TSVS AND THE HDR TSVS FOR EVERY TOOL   
if [[ $1 == "c_elegans" ]]; then
    VEP_flatfile_nHDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/HDRres_merging/VEP_flatFile_nonHDR_c_elegans.tsv"
    VEP_flatfile_HDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/HDRres_merging/VEP_flatFile_HDR_c_elegans.tsv"

    CSQ_flatfile_nHDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/HDRres_merging/CSQ_flatFile_nonHDR_c_elegans.tsv"
    CSQ_flatfile_HDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/HDRres_merging/CSQ_flatFile_HDR_c_elegans.tsv"

    ANNOVAR_flatfile_nHDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/HDRres_merging/ANV_flatFile_nonHDR_c_elegans.tsv"
    ANNOVAR_flatfile_HDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/HDRres_merging/ANV_flatFile_HDR_c_elegans.tsv"

    SIFT_flatfile_nHDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/HDRres_merging/SIFT_flatFile_nonHDR_c_elegans.tsv"
    SIFT_flatfile_HDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/HDRres_merging/SIFT_flatFile_HDR_c_elegans.tsv"

    # SnpEff_flatfile="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/SnpEff_flatFile_c_elegans.tsv"
    output_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/HDRres_merging"
    HDR_BED_zipped="/vast/eande106/data/c_elegans/WI/divergent_regions/20231213/20231213_c_elegans_divergent_regions_all.bed.gz"

elif [[ $1 == "c_tropicalis" ]]; then
    VEP_flatfile_nHDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/HDRres_merging/VEP_flatFile_nonHDR_c_tropicalis.tsv"
    VEP_flatfile_HDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/VHDRres_merging/EP_flatFile_HDR_c_tropicalis.tsv"

    CSQ_flatfile_nHDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/HDRres_merging/CSQ_flatFile_nonHDR_c_tropicalis.tsv"
    CSQ_flatfile_HDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/HDRres_merging/CSQ_flatFile_HDR_c_tropicalis.tsv"
    
    ANNOVAR_flatfile_nHDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/HDRres_merging/ANV_flatFile_nonHDR_c_tropicalis.tsv"
    ANNOVAR_flatfile_HDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/HDRres_merging/ANV_flatFile_HDR_c_tropicalis.tsv"

    SIFT_flatfile_nHDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/HDRres_merging/SIFT_flatFile_nonHDR_c_tropicalis.tsv"
    SIFT_flatfile_HDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/HDRres_merging/SIFT_flatFile_HDR_c_tropicalis.tsv"

    # SnpEff_flatfile="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/SnpEff_flatFile_c_tropicalis.tsv"
    output_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/HDRres_merging"
    HDR_BED_zipped="/vast/eande106/data/c_tropicalis/WI/divergent_regions/20231201/20231201_c_tropicalis_divergent_regions_all.bed.gz"

elif [[ $1 == "c_briggsae" ]]; then
    VEP_flatfile_nHDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/HDRres_merging/EP_flatFile_nonHDR_c_briggsae.tsv"
    VEP_flatfile_HDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/HDRres_merging/VEP_flatFile_HDR_c_briggsae.tsv"

    CSQ_flatfile_nHDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/HDRres_merging/CSQ_flatFile_nonHDR_c_briggsae.tsv"
    CSQ_flatfile_HDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/HDRres_merging/CSQ_flatFile_HDR_c_briggsae.tsv"

    ANNOVAR_flatfile_nHDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/HDRres_merging/ANV_flatFile_nonHDR_c_briggsae.tsv"
    ANNOVAR_flatfile_HDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/HDRres_merging/ANV_flatFile_HDR_c_briggsae.tsv"

    SIFT_flatfile_nHDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/HDRres_merging/SIFT_flatFile_nonHDR_c_briggsae.tsv"
    SIFT_flatfile_HDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/HDRres_merging/SIFT_flatFile_HDR_c_briggsae.tsv"

    # SnpEff_flatfile="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/SnpEff_flatFile_c_briggsae.tsv"
    output_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/HDRres_merging"
    HDR_BED_zipped="/vast/eande106/data/c_briggsae/WI/divergent_regions/20240129/20240129_c_briggsae_divergent_regions_all.bed.gz" ####### NOT USABLE??? MODULATE SCRIPT SO THIS ISN'T USED #######

else
    echo "Unsupported organism: $1"
    exit 1
fi

# nonHDRmergedFile="$output_dir/nonHDRmerged_flatFile_$1.csv"

# # Create temporary files with concatenated first three columns as a "key"
# awk -F'\t' '{print $1"_"$2"_"$3"\t"$0}' $VEP_flatfile_nHDR > VEP_temp_nHDR.tsv
# awk -F'\t' '{print $1"_"$2"_"$3"\t"$0}' $CSQ_flatfile_nHDR > CSQ_temp_nHDR.tsv
# # awk -F'\t' '{print $1"_"$2"_"$3"\t"$0}' $SnpEff_flatfile > SnpEff_temp.tsv
# awk -F'\t' '{print $1"_"$2"_"$3"\t"$0}' $ANNOVAR_flatfile_nHDR > ANNOVAR_temp_nHDR.tsv
# awk -F'\t' '{print $1"_"$2"_"$3"\t"$0}' $SIFT_flatfile_nHDR > SIFT_temp_nHDR.tsv

# # Join based on the new concatenated key
# join -t $'\t' -1 1 -2 1 VEP_temp_nHDR.tsv CSQ_temp_nHDR.tsv > temp1_nHDR.tsv
# # join -t $'\t' -1 1 -2 1 temp1.tsv SnpEff_temp.tsv > temp2.tsv
# join -t $'\t' -1 1 -2 1 temp1_nHDR.tsv ANNOVAR_temp_nHDR.tsv > temp2_nHDR.tsv
# join -t $'\t' -1 1 -2 1 temp2_nHDR.tsv SIFT_temp_nHDR.tsv > $output_dir/temp_merged_nHDR.tsv
# # look at headers of temp_merged_nHDR.tsv to re-index the columns below


# if [ -f $nonHDRmergedFile ]; then
#     rm $nonHDRmergedFile
# fi

# Extract columns: first 3 from VEP, last column from VEP, and unique columns from each file
### WILL NEED TO MERGE ALL 10 FILES TOGETHER (2 FROM EACH TOOL (HDR AND NON-HDR), AND 5 TOOLS)
# awk -F'\t' '
# BEGIN {
#     OFS = ",";
#     print "CHROM", "POS", "REF", "ALT", "VEP_consequence", "VEP_impact", "VEP_AA_change", "CSQ_consequence", "CSQ_AA_change", "ANV_consequence", "ANV_impact", "ANV_AA_change", "SIFT_consequence", "SIFT_score", "SIFT_impact", "SIFT_AA_change", "BLOSUM_score", "GRANTHAM_score", "Percent_protein", "STRAINS", "In_HDR"
# }

# function sort_array(arr, sorted_arr, i, j, temp) {
#     n = length(arr);
#     for (i = 1; i <= n; i++) {
#         sorted_arr[i] = arr[i];
#     }
#     for (i = 1; i <= n; i++) {
#         for (j = i + 1; j <= n; j++) {
#             if (sorted_arr[i] > sorted_arr[j]) {
#                 temp = sorted_arr[i];
#                 sorted_arr[i] = sorted_arr[j];
#                 sorted_arr[j] = temp;
#             }
#         }
#     }
# }

# NR > 1 {
#     chrom = $2;
#     pos = $3;
#     ref = $4;
#     alt = $5;
#     vep_consequence = $6;
#     vep_impact = $7;
#     vep_aa_change = $8;
#     blosum_score = $9
#     csq_consequence = $15;
#     csq_aa_change = $16;
#     anv_consequence = $23;
#     anv_impact = $24;
#     anv_aa_change = $25;
#     sift_consequence = $31;
#     sift_score = $32;
#     sift_impact = $33;
#     sift_aa_change = $34;
#     grantham_score = $17;
#     all_samples_with_alt_vep = $10;
#     all_samples_with_alt_csq = $18;
#     all_samples_with_alt_anv = $26;
#     all_samples_with_alt_sift = $35;

#     # Split the comma-separated values into arrays
#     split(all_samples_with_alt_vep, vep_samples, ",");
#     split(all_samples_with_alt_csq, csq_samples, ",");
#     split(all_samples_with_alt_anv, anv_samples, ",");
#     split(all_samples_with_alt_sift, sift_samples, ",");

#     sort_array(vep_samples, sorted_vep_samples);
#     sort_array(csq_samples, sorted_csq_samples);
#     sort_array(anv_samples, sorted_anv_samples);
#     sort_array(sift_samples, sorted_sift_samples);

#     if (length(sorted_vep_samples) != length(sorted_csq_samples) || length(sorted_csq_samples) != length(sorted_anv_samples) || length(sorted_anv_samples) != length(sorted_sift_samples)) {
#         print "Error: SAMPLES length mismatch at line", NR;
#         exit 1;
#     }

#     for (i = 1; i <= length(sorted_vep_samples); i++) {
#         if (sorted_vep_samples[i] != sorted_csq_samples[i] || sorted_csq_samples[i] != sorted_anv_samples[i] || sorted_anv_samples[i] != sorted_sift_samples[i]) {
#             print "Error: SAMPLES mismatch at line", NR, "Sample index:", i, "VEP:", sorted_vep_samples[i], "CSQ:", sorted_csq_samples[i], "ANV:", sorted_anv_samples[i], "SIFT:", sorted_sift_samples[i];
#             exit 1;
#         }
#     }

#     print chrom, pos, ref, alt, vep_consequence, vep_impact, vep_aa_change, csq_consequence, csq_aa_change, anv_consequence, anv_impact, anv_aa_change, sift_consequence, sift_score, sift_impact, sift_aa_change, blosum_score, grantham_score, percent_protein, all_samples_with_alt_vep, "NO"
# }' $output_dir/temp_merged_nHDR.tsv > $nonHDRmergedFile

# # Cleanup temporary files
# rm VEP_temp_nHDR.tsv CSQ_temp_nHDR.tsv ANNOVAR_temp_nHDR.tsv SIFT_temp_nHDR.tsv temp1_nHDR.tsv temp2_nHDR.tsv $output_dir/temp_merged_nHDR.tsv





HDRmergedFile="$output_dir/HDRmerged_flatFile_$1.csv"

# Create temporary files with concatenated first three columns as a "key"
awk -F'\t' '{print $1"_"$2"_"$3"\t"$0}' $VEP_flatfile_HDR > VEP_temp.tsv
awk -F'\t' '{print $1"_"$2"_"$3"\t"$0}' $CSQ_flatfile_HDR > CSQ_temp.tsv
# awk -F'\t' '{print $1"_"$2"_"$3"\t"$0}' $SnpEff_flatfile > SnpEff_temp.tsv
awk -F'\t' '{print $1"_"$2"_"$3"\t"$0}' $ANNOVAR_flatfile_HDR > ANNOVAR_temp.tsv
awk -F'\t' '{print $1"_"$2"_"$3"\t"$0}' $SIFT_flatfile_HDR > SIFT_temp.tsv

# Join based on the new concatenated key
join -t $'\t' -1 1 -2 1 VEP_temp.tsv CSQ_temp.tsv > temp1.tsv
# join -t $'\t' -1 1 -2 1 temp1.tsv SnpEff_temp.tsv > temp2.tsv
join -t $'\t' -1 1 -2 1 temp1.tsv ANNOVAR_temp.tsv > temp2.tsv
join -t $'\t' -1 1 -2 1 temp2.tsv SIFT_temp.tsv > $output_dir/temp_merged.tsv

if [ -f $HDRmergedFile ]; then
    rm $HDRmergedFile
fi

# Extract columns: first 3 from VEP, last column from VEP, and unique columns from each file
### WILL NEED TO MERGE ALL 10 FILES TOGETHER (2 FROM EACH TOOL (HDR AND NON-HDR), AND 5 TOOLS)
awk -F'\t' '
BEGIN {
    OFS = ",";
    print "CHROM", "POS", "REF", "ALT", "VEP_consequence", "VEP_impact", "VEP_AA_change", "CSQ_consequence", "CSQ_AA_change", "ANV_consequence", "ANV_impact", "ANV_AA_change", "SIFT_consequence", "SIFT_score", "SIFT_impact", "SIFT_AA_change", "BLOSUM_score", "GRANTHAM_score", "STRAINS", "In_HDR"
}

function sort_array(arr, sorted_arr, i, j, temp) {
    n = length(arr);
    for (i = 1; i <= n; i++) {
        sorted_arr[i] = arr[i];
    }
    for (i = 1; i <= n; i++) {
        for (j = i + 1; j <= n; j++) {
            if (sorted_arr[i] > sorted_arr[j]) {
                temp = sorted_arr[i];
                sorted_arr[i] = sorted_arr[j];
                sorted_arr[j] = temp;
            }
        }
    }
}

NR > 1 {
    chrom = $2;
    pos = $3;
    ref = $4;
    alt = $5;
    vep_consequence = $6;
    vep_impact = $7;
    vep_aa_change = $8;
    blosum_score = $9
    csq_consequence = $15;
    csq_aa_change = $16;
    anv_consequence = $23;
    anv_impact = $24;
    anv_aa_change = $25;
    sift_consequence = $31;
    sift_score = $32;
    sift_impact = $33;
    sift_aa_change = $34;
    grantham_score = $17;
    all_samples_with_alt_vep = $10;
    all_samples_with_alt_csq = $18;
    all_samples_with_alt_anv = $26;
    all_samples_with_alt_sift = $35;

    # Split the comma-separated values into arrays
    split(all_samples_with_alt_vep, vep_samples, ",");
    split(all_samples_with_alt_csq, csq_samples, ",");
    split(all_samples_with_alt_anv, anv_samples, ",");
    split(all_samples_with_alt_sift, sift_samples, ",");

    sort_array(vep_samples, sorted_vep_samples);
    sort_array(csq_samples, sorted_csq_samples);
    sort_array(anv_samples, sorted_anv_samples);
    sort_array(sift_samples, sorted_sift_samples);

    if (length(sorted_vep_samples) != length(sorted_csq_samples) || length(sorted_csq_samples) != length(sorted_anv_samples) || length(sorted_anv_samples) != length(sorted_sift_samples)) {
        print "Error: SAMPLES length mismatch at line", NR;
        exit 1;
    }

    for (i = 1; i <= length(sorted_vep_samples); i++) {
        if (sorted_vep_samples[i] != sorted_csq_samples[i] || sorted_csq_samples[i] != sorted_anv_samples[i] || sorted_anv_samples[i] != sorted_sift_samples[i]) {
            print "Error: SAMPLES mismatch at line", NR, "Sample index:", i, "VEP:", sorted_vep_samples[i], "CSQ:", sorted_csq_samples[i], "ANV:", sorted_anv_samples[i], "SIFT:", sorted_sift_samples[i];
            exit 1;
        }
    }

    print chrom, pos, ref, alt, vep_consequence, vep_impact, vep_aa_change, csq_consequence, csq_aa_change, anv_consequence, anv_impact, anv_aa_change, sift_consequence, sift_score, sift_impact, sift_aa_change, blosum_score, grantham_score, all_samples_with_alt_vep, "YES"
}'  $output_dir/temp_merged.tsv > $HDRmergedFile

# Cleanup temporary files
rm VEP_temp.tsv CSQ_temp.tsv ANNOVAR_temp.tsv SIFT_temp.tsv temp1.tsv temp2.tsv $output_dir/temp_merged.tsv




# echo "Merged file created at $output_dir/finalMergedFile.csv"

# cat $nonHDRmergedFile $HDRmergedFile | sort -k1,1 -k2,2 > $output_dir/finalMergedFile.csv


















# ### MUST CHANGE INCORRECT STRAIN NAMES DUE TO ERROR IN SIFT ANALYSIS SCRIPT ###
# sed -i 's/PB3065/ECA2595/g' "$SIFT_flatfile"
# sed -i 's/CB48517/ECA2437/g' "$SIFT_flatfile"
# sed -i 's/CB48552/ECA2482/g' "$SIFT_flatfile"
# sed -i 's/CB48559/ECA2489/g' "$SIFT_flatfile"
# sed -i 's/CB48537/ECA2467/g' "$SIFT_flatfile"
# sed -i 's/CB48551/ECA2481/g' "$SIFT_flatfile"
# sed -i 's/PB3064/ECA2594/g' "$SIFT_flatfile"

# # Extract columns: first 3 from VEP, last column from VEP, and unique columns from each file
# ### WILL NEED TO MERGE ALL 10 FILES TOGETHER (2 FROM EACH TOOL (HDR AND NON-HDR), AND 5 TOOLS)
# awk -F'\t' '
# BEGIN {
#     OFS = ",";
#     print "CHROM", "POS", "REF", "ALT", "VEP_consequence", "VEP_impact", "VEP_AA_change", "SnpEff_consequence", "SnpEff_impact", "SnpEff_AA_change", "CSQ_consequence", "CSQ_AA_change", "ANV_consequence", "ANV_impact", "ANV_AA_change", "SIFT_consequence", "SIFT_score", "SIFT_impact", "SIFT_AA_change", "BLOSUM_score", "GRANTHAM_score", "Percent_protein", "STRAINS"
# }

# function sort_array(arr, sorted_arr, i, j, temp) {
#     n = length(arr);
#     for (i = 1; i <= n; i++) {
#         sorted_arr[i] = arr[i];
#     }
#     for (i = 1; i <= n; i++) {
#         for (j = i + 1; j <= n; j++) {
#             if (sorted_arr[i] > sorted_arr[j]) {
#                 temp = sorted_arr[i];
#                 sorted_arr[i] = sorted_arr[j];
#                 sorted_arr[j] = temp;
#             }
#         }
#     }
# }

# {
#     chrom = $2;
#     pos = $3;
#     ref = $4;
#     alt = $5;
#     vep_consequence = $6;
#     vep_impact = $7;
#     vep_aa_change = $8;
#     snpeff_consequence = $21;
#     snpeff_impact = $22;
#     snpeff_aa_change = $23;
#     csq_consequence = $14;
#     csq_aa_change = $15;
#     anv_consequence = $29;
#     anv_impact = $30;
#     anv_aa_change = $31;
#     sift_consequence = $40;
#     sift_score = $41;
#     sift_impact = $42;
#     sift_aa_change = $43;
#     blosum_score = $37;
#     grantham_score = $38;
#     percent_protein = $39;
#     all_samples_with_alt_vep = $9;
#     all_samples_with_alt_csq = $16;
#     all_samples_with_alt_snpeff = $24;
#     all_samples_with_alt_anv = $32;
#     all_samples_with_alt_sift = $44;

#     # Split the comma-separated values into arrays
#     split(all_samples_with_alt_vep, vep_samples, ",");
#     split(all_samples_with_alt_csq, csq_samples, ",");
#     split(all_samples_with_alt_snpeff, snpeff_samples, ",");
#     split(all_samples_with_alt_anv, anv_samples, ",");
#     split(all_samples_with_alt_sift, sift_samples, ",");

#     sort_array(vep_samples, sorted_vep_samples);
#     sort_array(csq_samples, sorted_csq_samples);
#     sort_array(snpeff_samples, sorted_snpeff_samples);
#     sort_array(anv_samples, sorted_anv_samples);
#     sort_array(sift_samples, sorted_sift_samples);

#     if (length(sorted_vep_samples) != length(sorted_csq_samples) || length(sorted_csq_samples) != length(sorted_snpeff_samples) || length(sorted_snpeff_samples) != length(sorted_anv_samples) || length(sorted_anv_samples) != length(sorted_sift_samples)) {
#         print "Error: SAMPLES length mismatch at line", NR;
#         exit 1;
#     }

#     for (i = 1; i <= length(sorted_vep_samples); i++) {
#         if (sorted_vep_samples[i] != sorted_csq_samples[i] || sorted_csq_samples[i] != sorted_snpeff_samples[i] || sorted_snpeff_samples[i] != sorted_anv_samples[i] || sorted_anv_samples[i] != sorted_sift_samples[i]) {
#             print "Error: SAMPLES mismatch at line", NR, "Sample index:", i, "VEP:", sorted_vep_samples[i], "CSQ:", sorted_csq_samples[i], "SnpEff:", sorted_snpeff_samples[i], "ANV:", sorted_anv_samples[i], "SIFT:", sorted_sift_samples[i];
#             exit 1;
#         }
#     }

#     print chrom, pos, ref, alt, vep_consequence, vep_impact, vep_aa_change, snpeff_consequence, snpeff_impact, snpeff_aa_change, csq_consequence, csq_aa_change, anv_consequence, anv_impact, anv_aa_change, sift_consequence, sift_score, sift_impact, sift_aa_change, blosum_score, grantham_score, percent_protein, all_samples_with_alt_vep
# }' temp_merged.tsv > "$merged_file"

# # Remove the second row from the merged file as the headers are printed twice
# sed '2d' "$merged_file" > "$output_dir/temp_file.csv" && mv "$output_dir/temp_file.csv" "$merged_file" #### FIXXXXX!!!!!

# # Cleanup temporary files
# rm VEP_temp.tsv CSQ_temp.tsv SnpEff_temp.tsv ANNOVAR_temp.tsv SIFT_temp.tsv temp1.tsv temp2.tsv temp3.tsv temp_merged.tsv

# echo "Merged file created at $merged_file"



# echo "Adding column for HDR variant resolution"

# # Paths to input files
# HDR_BED="$output_dir/20231213_c_elegans_divergent_regions_all.bed"
# OUTPUT_FILE="$output_dir/temp_final.csv"

# # Unzip HDR BED file if necessary
# if [ ! -f "$HDR_BED" ]; then
#     gunzip -c "$HDR_BED_zipped" > "$HDR_BED"
#     if [ $? -ne 0 ]; then
#         echo "Error unzipping $(basename "$HDR_BED_zipped")"
#         exit 1
#     fi
# fi

# # Merge HDR regions using bedtools merge ### Do not perform the merge
# HDR_MERGED_BED="$output_dir/HDR_merged.bed"
# bedtools merge -i "$HDR_BED" > "$HDR_MERGED_BED"
# if [ $? -ne 0 ]; then
#     echo "Error merging HDR BED file"
#     exit 1
# fi

# # Convert merged_file to BED format (assuming merged_file is a CSV with chromosome in column 1 and position in column 2)
# VARIANTS_BED="$output_dir/variants.bed"
# awk -F',' 'BEGIN {OFS="\t"} {print $1, $2, $2+1, $0}' "$merged_file" > "$VARIANTS_BED"

# # Use bedtools intersect to find overlaps
# INTERSECTED_BED="$output_dir/intersected.bed"
# bedtools intersect -a "$VARIANTS_BED" -b "$HDR_MERGED_BED" -wa -c > "$INTERSECTED_BED"

# # Process the intersected file to append TRUE/FALSE
# awk -F'\t' 'BEGIN {OFS=","} {split($4, arr, ","); if ($NF > 0) {print $4, "TRUE"} else {print $4, "FALSE"}}' "$INTERSECTED_BED" > "$OUTPUT_FILE"

# HEADER=$(head -n 1 "$merged_file")
# echo "$HEADER,HDR" > "$merged_file.tmp.csv"  # Create a new file with the header
# tail -n +2 "$OUTPUT_FILE" >> "$merged_file.tmp.csv"  # Append data (excluding header)
# mv "$merged_file.tmp.csv" "$merged_file"  # Move temporary file to final merged file location

# # Clean up temporary files
# rm "$HDR_BED"
# rm "$HDR_MERGED_BED"
# rm "$VARIANTS_BED"
# rm "$INTERSECTED_BED"

# echo "Created final CSV with HDR variant position resolution: $merged_file"