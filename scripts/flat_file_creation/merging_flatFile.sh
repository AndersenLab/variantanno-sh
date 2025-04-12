#!/bin/bash

#SBATCH -J flatFileMerge
#SBATCH -A eande106
#SBATCH -p parallel
#SBATCH -t 48:00:00
#SBATCH -N 1
#SBATCH -c 12
#SBATCH --mail-user=loconn13@jh.edu
#SBATCH --mail-type=END
#SBATCH --output=/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/SLURM_output/newMerge.oe  
#SBATCH --error=/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/SLURM_output/newMerge.rr 

if [[ $1 == "c_elegans" ]]; then
    VEP_flatfile_nHDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/HDRres_merging/VEP_flatFile_nonHDR_c_elegans.tsv"
    VEP_flatfile_HDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/HDRres_merging/VEP_flatFile_HDR_c_elegans.tsv"

    CSQ_flatfile_nHDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/HDRres_merging/CSQ_flatFile_nonHDR_c_elegans.PP.tsv"
    CSQ_flatfile_HDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/HDRres_merging/CSQ_flatFile_HDR_c_elegans.PP.tsv"

    ANNOVAR_flatfile_nHDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/HDRres_merging/ANV_flatFile_nonHDR_c_elegans.tsv"
    ANNOVAR_flatfile_HDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/HDRres_merging/ANV_flatFile_HDR_c_elegans.tsv"

    SnpEff_flatfile="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/HDRres_merging/SnpEff_flatFile_c_elegans.tsv"
    output_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/HDRres_merging/finalMerge"
    gff="/vast/eande106/data/c_elegans/genomes/PRJNA13758/WS283/csq/c_elegans.PRJNA13758.WS283.csq.gff3"
    gtf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/raw_data/SnpEff/c_elegans/c_elegans.PRJNA13758.WS283/genes.gtf"

elif [[ $1 == "c_tropicalis" ]]; then
    VEP_flatfile_nHDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/HDRres_merging/VEP_flatFile_nonHDR_c_tropicalis.tsv"
    VEP_flatfile_HDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/VHDRres_merging/EP_flatFile_HDR_c_tropicalis.tsv"

    CSQ_flatfile_nHDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/HDRres_merging/CSQ_flatFile_nonHDR_c_tropicalis.PP.tsv"
    CSQ_flatfile_HDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/HDRres_merging/CSQ_flatFile_HDR_c_tropicalis.PP.tsv"
    
    ANNOVAR_flatfile_nHDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/HDRres_merging/ANV_flatFile_nonHDR_c_tropicalis.tsv"
    ANNOVAR_flatfile_HDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/HDRres_merging/ANV_flatFile_HDR_c_tropicalis.tsv"

    SnpEff_flatfile="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/SnpEff_flatFile_c_tropicalis.tsv"
    output_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/HDRres_merging/finalMerge"
    gff=""
    gtf=""

elif [[ $1 == "c_briggsae" ]]; then
    VEP_flatfile_nHDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/HDRres_merging/VEP_flatFile_nonHDR_c_briggsae.tsv"
    VEP_flatfile_HDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/HDRres_merging/VEP_flatFile_HDR_c_briggsae.tsv"

    CSQ_flatfile_nHDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/HDRres_merging/CSQ_flatFile_nonHDR_c_briggsae.PP.tsv"
    CSQ_flatfile_HDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/HDRres_merging/CSQ_flatFile_HDR_c_briggsae.PP.tsv"

    ANNOVAR_flatfile_nHDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/HDRres_merging/ANV_flatFile_nonHDR_c_briggsae.tsv"
    ANNOVAR_flatfile_HDR="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/HDRres_merging/ANV_flatFile_HDR_c_briggsae.tsv"

    SnpEff_flatfile="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/SnpEff_flatFile_c_briggsae.tsv"
    output_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/HDRres_merging/finalMerge"
    gff=""
    gtf=""

else
    echo "Unsupported organism: $1"
    exit 1
fi

mkdir -p $output_dir



#### ADDING WBGeneID ####

##### ADJUST HEADERS TO INCLUDE PERCENT PROTEIN AND GRANTHAM SCORE AND BLOSUM62 SCORE AFTER ALL OF THE LEFT JOINS
# echo -e 'Chromosome\tPosition\tREF\tALT\tVEP_consequence\tVEP_impact\tVEP_AA_change\tBLOSUM_score\tStrains\tDivergent\tTranscript\tWBGeneID' > $output_dir/VEP_flatFile_nonHDR_$1.tsv
# echo -e 'Chromosome\tPosition\tREF\tALT\tCSQ_consequence\tCSQ_AA_change\tDNA change\tGrantham Score\tStrains\tDivergent\tTranscript\tPercent Protein\tWBGeneID' > $output_dir/CSQ_header.tsv
# echo -e 'Chromosome\tPosition\tREF\tALT\tANV_consequence\tANV_impact\tANV_AA_change\tStrains\tDivergent\tTranscript\tWBGeneID' > $output_dir/ANV_header.tsv
# echo -e 'Chromosome\tPosition\tREF\tALT\tSnpEff_consequence\tSnpEff_impact\tSnpEff_AA_change\tGrantham Score\tStrains\tDivergent\tTranscript\tWBGeneID' > $output_dir/SnpEff_header.tsv

# cat $CSQ_flatfile_nHDR $CSQ_flatfile_HDR| sort -t$'\t' -k11,11 > $output_dir/CSQ_tempfinal_sorted.tsv
# cat $VEP_flatfile_nHDR $VEP_flatfile_HDR  | sort -t$'\t' -k11,11 > $output_dir/VEP_tempfinal_sorted.tsv
# cat $ANNOVAR_flatfile_nHDR $ANNOVAR_flatfile_HDR| sort -t$'\t' -k10,10 > $output_dir/ANNOVAR_tempfinal_sorted.tsv
# sort -t$'\t' -k10,10 $Snpeff_flatfile > $output_dir/SnpEff_tempfinal_sorted.tsv ### THIS DOESN'T SEEM TO BE WORKING????






# Extracting transcripts and WBGeneID's from GFF3
#### ADD ANY MORE EXCLUSIONS FROM BRIGGSAE  
#### TROPICALIS GFF - MtDNA doesn't have mRNA... just tRNA?




# awk -F'\t' '$3 != "gene" && $3 != "intron" && $3 != "exon" && $3 != "five_prime_UTR" && $3 != "three_prime_UTR" && $3 != "CDS" && $3 != "start_codon" && $3 != "stop_codon" {print $9}' $gff | \
# awk -F'[;=]' '{
#     transcript=""; wbgene="";
#     for(i=1; i<=NF; i++) {
#         if ($i == "ID" && $(i+1) ~ /^transcript:/) { transcript=$(i+1); gsub("transcript:", "", transcript); }
#         if ($i == "Parent" && $(i+1) ~ /^gene:WBGene/) { wbgene=$(i+1); gsub("gene:", "", wbgene); }
#     }
#     if (transcript != "" && wbgene != "") print transcript "\t" wbgene;
# }' > $output_dir/$(basename $gff).tsv
# sort -t$'\t' -k1,1 $output_dir/$(basename $gff).tsv > $output_dir/$(basename $gff)_sorted.tsv
# rm $output_dir/$(basename $gff).tsv


# Extracting trenscripts and WBGeneID's from GTF used with SnpEff
# awk -F'\t' '$3 == "transcript" {print $9}' $gtf | \
# awk -F'[ ";]+' -v OFS='t\' '{
#     transcript=""; wbgene="";
#     for(i=1; i<=NF; i++) {
#         if ($i == "transcript_id") { transcript=$(i+1); gsub(/^transcript:/, "", transcript); }
#         if ($i == "gene_id") { wbgene=$(i+1); gsub(/^gene:/, "", wbgene); }
#     }
#     if (transcript != "" && wbgene != "") print transcript "\t" wbgene;
# }' > $output_dir/$(basename $gtf).tsv
# sort -t$'\t' -k1,1 $output_dir/$(basename $gtf).tsv > $output_dir/$(basename $gtf)_SnpEff_sorted.tsv
# rm $output_dir/$(basename $gtf).tsv







### Left joining to all flat files ###
# ANNVOAR #
# join -t$'\t' -1 1 -2 10 -a 2 $output_dir/$(basename $gff)_sorted.tsv $output_dir/ANNOVAR_tempfinal_sorted.tsv | \
#         awk -F'\t' -v OFS='\t' '{
#                 if (NF == 11) {
#                         print $3, $4, $5, $6, $7, $8, $9, $10, $11, $1, $2
#                 } else {
#                         print $2, $3, $4, $5, $6, $7, $8, $9, $10, $1, $1
#                  }
#         }' > $output_dir/ANNOVAR_joined.tsv

# sort -k1,1 -k2,2n $output_dir/ANNOVAR_joined.tsv > $output_dir/ANNOVAR_${1}_WBGeneID.tsv
# rm $output_dir/ANNOVAR_tempfinal_sorted.tsv $output_dir/ANNOVAR_joined.tsv 


# # VEP #
# join -t$'\t' -1 1 -2 11 -a 2 $output_dir/$(basename $gff)_sorted.tsv $output_dir/VEP_tempfinal_sorted.tsv | \
#         awk -F'\t' -v OFS='\t' '{
#                 if (NF == 12) {
#                         print $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $1, $2
#                 } else {
#                         print $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $1, $1
#                  }
#         }' > $output_dir/VEP_joined.tsv

# sort -k1,1 -k2,2n $output_dir/VEP_joined.tsv > $output_dir/VEP_${1}_WBGeneID.tsv
# rm $output_dir/VEP_tempfinal_sorted.tsv $output_dir/VEP_joined.tsv 


# CSQ # 
# join -t$'\t' -1 1 -2 11 -a 2 $output_dir/$(basename $gff)_sorted.tsv $output_dir/CSQ_tempfinal_sorted.tsv | \
#         awk -F'\t' -v OFS='\t' '{
#                 if (NF == 13) {
#                         print $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $1, $2
#                 } else {
#                         print $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $1, $1
#                  }
#         }' > $output_dir/CSQ_joined.tsv

# sort -k1,1 -k2,2n $output_dir/CSQ_joined.tsv > $output_dir/CSQ_${1}_WBGeneID.tsv
# rm $output_dir/CSQ_tempfinal_sorted.tsv $output_dir/CSQ_joined.tsv 


# SnpEff #
# join -t$'\t' -1 1 -2 10 -a 2 $output_dir/$(basename $gtf)_SnpEff_sorted.tsv $output_dir/SnpEff_tempfinal_sorted.tsv | \
#         awk -F'\t' -v OFS='\t' '{
#                 if (NF == 11) {
#                         print $3, $4, $5, $6, $7, $8, $9, $10, $11, $1, $2
#                 } else {
#                         print $2, $3, $4, $5, $6, $7, $8, $9, $10, $1, $1
#                  }
#         }' > $output_dir/SnpEff_joined.tsv

# sort -k1,1 -k2,2n $output_dir/SnpEff_joined.tsv > $output_dir/SnpEff_${1}_WBGeneID.tsv
# rm $output_dir/SnpEff_tempfinal_sorted.tsv $output_dir/SnpEff_joined.tsv 



# Keys for left-joining - CHROM, POS, REF, ALT, TRANSCRIPT
# awk -F'\t' '{print $1"_"$2"_"$3"_"$4"_"$12"\t"$0}' $output_dir/CSQ_${1}_WBGeneID.tsv | sort -k1,1 -k2,2n > $output_dir/CSQ_key.tsv
# awk -F'\t' '{print $1"_"$2"_"$3"_"$4"_"$10"\t"$0}' $output_dir/ANNOVAR_${1}_WBGeneID.tsv | sort -k1,1 -k2,2n > $output_dir/ANNOVAR_key.tsv
# awk -F'\t' '{print $1"_"$2"_"$3"_"$4"_"$11"\t"$0}' $output_dir/VEP_${1}_WBGeneID.tsv | sort -k1,1 -k2,2n > $output_dir/VEP_key.tsv


#### Left-joining to add Grantham scores and percent protein ####
# awk -F'\t' '{print $1"_"$2"_"$3"_"$4"_"$12"\t"$8"\t"$11}' $output_dir/CSQ_${1}_WBGeneID.tsv | sort -k1,1 -k2,2n > $output_dir/CSQ_GS_PP.tsv

join -t $'\t' -1 1 -2 1 -a1 $output_dir/ANNOVAR_key.tsv $output_dir/CSQ_GS_PP.tsv | uniq \
| awk -F'\t' -v OFS='\t' '{
    if (NF == 12) {
        # Skip first field ($1), then add N/A fields
        for (i = 2; i <= NF; i++) printf "%s\t", $i;
        print "N/A", "N/A";
    } else if (NF == 14) {
        for (i = 2; i <= NF; i++) {
            printf "%s", $i;
            if (i < NF) printf "\t";
            else printf "\n";
        }
    }
}' > $output_dir/ANNOVAR_GS_PP.tsv

join -t $'\t' -1 1 -2 1 -a1 $output_dir/VEP_key.tsv $output_dir/CSQ_GS_PP.tsv | uniq \
| awk -F'\t' -v OFS='\t' '{
    if (NF == 13) {
        # Skip first field ($1), then add N/A fields
        for (i = 2; i <= NF; i++) printf "%s\t", $i;
        print "N/A", "N/A";
    } else if (NF == 15) {
        for (i = 2; i <= NF; i++) {
            printf "%s", $i;
            if (i < NF) printf "\t";
            else printf "\n";
        }
    }
}' > $output_dir/VEP_GS_PP.tsv

# check to see if all percent protein metics correspond with missense annotations made by ANNOVAR and VEP


#### Left-joining to add BLOSUM62 scores ####
# CSQ and ANNOVAR need BLOSUM62 scores

###### NO HDR RESOLUTION FOR BRIGGSAE


#### For BCSQ, VEP, and ANNOVAR flat files - extract CHROM and POS and grab unique lines and count - same number in noMt.HDR.vcf??? ####
# bcftools view -H WI.20250331.hard-filter.isotype.biallelic.NoMt.HDR.vcf.gz | wc -l = 2941052





























# # non-HDR region SNVs
# # head -500 $VEP_flatfile_nHDR > $output_dir/VEPsub.tsv
# # # head -500 $CSQ_flatFile_nHDR > $output_dir/CSQsub.tsv
# # head -500 $ANNOVAR_flatfile_nHDR > $output_dir/ANVsub.tsv

# # Create temporary files with concatenated first three columns as a "key"
# awk -F'\t' '{print $1"_"$2"_"$8"\t"$0}' $CSQ_flatfile_nHDR | sort -k1,1 -k2,2n > $output_dir/CSQ_temp_nHDR.tsv
# awk -F'\t' '{print $1"_"$2"_"$9"\t"$0}' $VEP_flatfile_nHDR | sort -k1,1 -k2,2n > $output_dir/VEP_temp_nHDR.tsv
# awk -F'\t' '{print $1"_"$2"_"$8"\t"$0}' $ANNOVAR_flatfile_nHDR | sort -k1,1 -k2,2n > $output_dir/ANNOVAR_temp_nHDR.tsv

# # Join based on the new concatenated key
# join -t $'\t' -1 1 -2 1 $output_dir/VEP_temp_nHDR.tsv $output_dir/CSQ_temp_nHDR.tsv | sort -k1,1 -k2,2n > $output_dir/temp1_nHDR.tsv
# join -t $'\t' -1 1 -2 1 $output_dir/temp1_nHDR.tsv $output_dir/ANNOVAR_temp_nHDR.tsv > $output_dir/temp2_nHDR.tsv

# # CHROM_POS_ALL_SAMPLES_WITH_ALT	CHROM	POS	REF	ALT	VEP_consequence	VEP_impact	VEP_AA_change	BLOSUM_score	ALL_SAMPLES_WITH_ALT	TRANSCRIPT	CHROM	POS	REF	ALT	CSQ_consequence	CSQ_AA_change	GRANTHAM_score	ALL_SAMPLES_WITH_ALT	TRANSCRIPT	PERCENT_PROTEIN	CHROM	POS	REF	ALT	ANV_consequence	ANV_impact	ANV_AA_change	ALL_SAMPLES_WITH_ALT	TRANSCRIPT
# # awk -F'\t' '{print $2,$3,$4,$5,$6,$9,$10,$11,$16,$18,$19,$20,$21,$26,$29,$30}'

# awk -F'\t' '
# BEGIN {
#     OFS = ",";
#     print "Chromosome", "Position", "REF", "ALT", "VEP_consequence", "VEP_impact", "VEP_AA_change", "CSQ_consequence", "CSQ_AA_change", "ANV_consequence", "ANV_impact", "ANV_AA_change", "BLOSUM62 Score", "Grantham Score", "Percent Protein", "Strains", "VEP transcript", "CSQ transcript", "ANNOVAR transcript", "Divergent"
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
#     blosum_score = $9;
#     vep_transcript = $11;
#     csq_consequence = $16;
#     csq_aa_change = $17;
#     grantham_score = $18;
#     csq_transcript = $20;
#     percent_protein = $21;
#     anv_consequence = $26;
#     anv_impact = $27;
#     anv_aa_change = $28;
#     anv_transcript = $30;
#     all_samples_with_alt_vep = $10;
#     all_samples_with_alt_csq = $19;
#     all_samples_with_alt_anv = $29;

#     split(all_samples_with_alt_vep, vep_samples, " ");
#     split(all_samples_with_alt_csq, csq_samples, " ");
#     split(all_samples_with_alt_anv, anv_samples, " ");

#     sort_array(vep_samples, sorted_vep_samples);
#     sort_array(csq_samples, sorted_csq_samples);
#     sort_array(anv_samples, sorted_anv_samples);

#     if (length(sorted_vep_samples) != length(sorted_csq_samples) || length(sorted_csq_samples) != length(sorted_anv_samples)) {
#         print "Error: SAMPLES length mismatch at line", NR;
#         exit 1;
#     }

#     for (i = 1; i <= length(sorted_vep_samples); i++) {
#         if (sorted_vep_samples[i] != sorted_csq_samples[i] || sorted_csq_samples[i] != sorted_anv_samples[i]) {
#         print "Error: SAMPLES mismatch at line" NR, "Sample index:" i, "VEP:" sorted_vep_samples[i], "CSQ:" sorted_csq_samples[i], "ANV:" sorted_anv_samples[i];
#             exit 1;
#         }
#     }

#     print chrom, pos, ref, alt, vep_consequence, vep_impact, vep_aa_change, csq_consequence, csq_aa_change, anv_consequence, anv_impact, anv_aa_change, blosum_score, grantham_score, percent_protein, all_samples_with_alt_vep, vep_transcript, csq_transcript, anv_transcript, "NO"
# }' $output_dir/temp2_nHDR.tsv > $output_dir/final_test_merge.csv




# awk -F'\t' '{print $1"_"$2"_"$8"\t"$0}' $CSQ_flatfile_HDR | sort -k1,1 -k2,2n > $output_dir/CSQ_temp_HDR.tsv
# awk -F'\t' '{print $1"_"$2"_"$9"\t"$0}' $VEP_flatfile_HDR | sort -k1,1 -k2,2n > $output_dir/VEP_temp_HDR.tsv
# awk -F'\t' '{print $1"_"$2"_"$8"\t"$0}' $ANNOVAR_flatfile_HDR | sort -k1,1 -k2,2n > $output_dir/ANNOVAR_temp_HDR.tsv

# # Join based on the new concatenated key
# join -t $'\t' -1 1 -2 1 $output_dir/VEP_temp_HDR.tsv $output_dir/CSQ_temp_HDR.tsv | sort -k1,1 -k2,2n > $output_dir/temp1_HDR.tsv
# join -t $'\t' -1 1 -2 1 $output_dir/temp1_HDR.tsv $output_dir/ANNOVAR_temp_HDR.tsv > $output_dir/temp2_HDR.tsv


# awk -F'\t' '
# BEGIN {
#     OFS = ",";
#     # print "Chromosome", "Position", "REF", "ALT", "VEP_consequence", "VEP_impact", "VEP_AA_change", "CSQ_consequence", "CSQ_AA_change", "ANV_consequence", "ANV_impact", "ANV_AA_change", "BLOSUM62 Score", "Grantham Score", "Strains", "VEP transcript", "CSQ transcript", "ANNOVAR transcript", "Divergent"
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
#     blosum_score = $9;
#     vep_transcript = $11;
#     csq_consequence = $16;
#     csq_aa_change = $17;
#     grantham_score = $18;
#     csq_transcript = $20;
#     percent_protein = $21;
#     anv_consequence = $26;
#     anv_impact = $27;
#     anv_aa_change = $28;
#     anv_transcript = $30;
#     all_samples_with_alt_vep = $10;
#     all_samples_with_alt_csq = $19;
#     all_samples_with_alt_anv = $29;

#     split(all_samples_with_alt_vep, vep_samples, " ");
#     split(all_samples_with_alt_csq, csq_samples, " ");
#     split(all_samples_with_alt_anv, anv_samples, " ");

#     sort_array(vep_samples, sorted_vep_samples);
#     sort_array(csq_samples, sorted_csq_samples);
#     sort_array(anv_samples, sorted_anv_samples);

#     if (length(sorted_vep_samples) != length(sorted_csq_samples) || length(sorted_csq_samples) != length(sorted_anv_samples)) {
#         print "Error: SAMPLES length mismatch at line", NR;
#         exit 1;
#     }

#     for (i = 1; i <= length(sorted_vep_samples); i++) {
#         if (sorted_vep_samples[i] != sorted_csq_samples[i] || sorted_csq_samples[i] != sorted_anv_samples[i]) {
#         print "Error: SAMPLES mismatch at line" NR, "Sample index:" i, "VEP:" sorted_vep_samples[i], "CSQ:" sorted_csq_samples[i], "ANV:" sorted_anv_samples[i];
#             exit 1;
#         }
#     }

#     print chrom, pos, ref, alt, vep_consequence, vep_impact, vep_aa_change, csq_consequence, csq_aa_change, anv_consequence, anv_impact, anv_aa_change, blosum_score, grantham_score, percent_protein, all_samples_with_alt_vep, vep_transcript, csq_transcript, anv_transcript, "YES"
# }' $output_dir/temp2_HDR.tsv > $output_dir/final_test_mergeHDR.csv


# cat $output_dir/final_test_merge.csv $output_dir/final_test_mergeHDR.csv | sort -t',' -k1,1 -k2,2n > $output_dir/${1}.final.merged.annotations.csv
