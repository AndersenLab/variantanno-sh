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

cat $CSQ_flatfile_nHDR $CSQ_flatfile_HDR| sort -t$'\t' -k11,11 > $output_dir/CSQ_tempfinal_sorted.tsv
cat $VEP_flatfile_nHDR $VEP_flatfile_HDR  | sort -t$'\t' -k11,11 > $output_dir/VEP_tempfinal_sorted.tsv
cat $ANNOVAR_flatfile_nHDR $ANNOVAR_flatfile_HDR| sort -t$'\t' -k10,10 > $output_dir/ANNOVAR_tempfinal_sorted.tsv
# sort -t$'\t' -k10,10 $Snpeff_flatfile > $output_dir/SnpEff_tempfinal_sorted.tsv ### THIS DOESN'T SEEM TO BE WORKING????






# Extracting transcripts and WBGeneID's from GFF3
# ID=transcript:Y74C9A.3.1;Parent=gene:WBGene00022277;Name=Y74C9A.3.1;wormpep=CE28146;locus=homt-1;uniprot_id=Q9N4D9;biotype=protein_coding
##To ensure ncRNAs are extracted as some annotation tools annotate these (e.g., VEP)
# awk -F'\t' '$3 != "gene" && $3 != "intron" && $3 != "exon" && $3 != "five_prime_UTR" && $3 != "three_prime_UTR" && $3 != "CDS" && $3 != "start_codon" && $3 != "stop_codon" {print $9}' $gff | \
# awk -F'[;=]' '{
#     transcript=""; wbgene="";gene=""
#     for(i=1; i<=NF; i++) {
#         if ($i == "ID" && $(i+1) ~ /^transcript:/) { transcript=$(i+1); gsub("transcript:", "", transcript); }
#         if ($i == "ID" && $(i+1) ~ /^Pseudogene:/) { transcript=$(i+1); gsub("Pseudogene:", "", transcript); }
#         if ($i == "Parent" && $(i+1) ~ /^gene:/) { wbgene=$(i+1); gsub("gene:", "", wbgene); }
#         if ($i == "locus") { gene=$(i+1); }
#         if ($i == "Name") { name=$(i+1); } 
#     }
#     if (gene == "") { gene = name; }

#     if (transcript != "" && wbgene != "") print transcript "\t" wbgene "\t" gene;
# }' > $output_dir/$(basename $gff).tsv
# sort -t$'\t' -k1,1 $output_dir/$(basename $gff).tsv > $output_dir/$(basename $gff)_sorted.tsv
# rm $output_dir/$(basename $gff).tsv


# # Extracting transcripts and WBGeneID's from GTF used with SnpEff
# awk -F'\t' '$3 == "transcript" {print $9}' $gtf | \
# awk -F'[ ";]+' -v OFS='t\' '{
#     transcript=""; wbgene="";
#     for(i=1; i<=NF; i++) {
#         if ($i == "transcript_id") { transcript=$(i+1); sub(/^(transcript:|Pseudogene:)/, "", transcript); }
#         if ($i == "gene_id") { wbgene=$(i+1); gsub(/^gene:/, "", wbgene); }
#     }
#     if (transcript != "" && wbgene != "") print transcript "\t" wbgene;
# }' > $output_dir/$(basename $gtf).tsv
# sort -t$'\t' -k1,1 $output_dir/$(basename $gtf).tsv > $output_dir/$(basename $gtf)_SnpEff_sorted_temp.tsv
# rm $output_dir/$(basename $gtf).tsv
# # Adding gene ID to SnpEff GTF extracted transcripts and WBGeneIDs
# awk 'FNR==NR { map[$1] = $3; next } { print $0, (map[$1] ? map[$1] : "N/A") }' $output_dir/$(basename $gff)_sorted.tsv \
#     $output_dir/$(basename $gtf)_SnpEff_sorted_temp.tsv \
#     > $output_dir/$(basename $gtf)_SnpEff_sorted.tsv
# rm $output_dir/$(basename $gtf)_SnpEff_sorted_temp.tsv


# ### Left joining to all flat files ###
# # ANNVOAR # 
join -t$'\t' -1 1 -2 10 -a 2 $output_dir/$(basename $gff)_sorted.tsv $output_dir/ANNOVAR_tempfinal_sorted.tsv | \
        awk -F'\t' -v OFS='\t' '{
                if (NF == 11) {
                        print $3, $4, $5, $6, $7, $8, $9, $10, $11, $1, $2
                } else {
                        print $2, $3, $4, $5, $6, $7, $8, $9, $10, $1, $1
                 }
        }' > $output_dir/ANNOVAR_joined.tsv

sort -k1,1 -k2,2n $output_dir/ANNOVAR_joined.tsv > $output_dir/ANNOVAR_${1}_WBGeneID.tsv
# rm $output_dir/ANNOVAR_tempfinal_sorted.tsv $output_dir/ANNOVAR_joined.tsv 


# # VEP #
join -t$'\t' -1 1 -2 11 -a 2 $output_dir/$(basename $gff)_sorted.tsv $output_dir/VEP_tempfinal_sorted.tsv | \
        awk -F'\t' -v OFS='\t' '{
                if (NF == 12) {
                        print $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $1, $2
                } else {
                        print $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $1, $1
                 }
        }' > $output_dir/VEP_joined.tsv

sort -k1,1 -k2,2n $output_dir/VEP_joined.tsv > $output_dir/VEP_${1}_WBGeneID.tsv
# rm $output_dir/VEP_tempfinal_sorted.tsv $output_dir/VEP_joined.tsv 


# CSQ # 
join -t$'\t' -1 1 -2 11 -a 2 $output_dir/$(basename $gff)_sorted.tsv $output_dir/CSQ_tempfinal_sorted.tsv | \
        awk -F'\t' -v OFS='\t' '{
                if (NF == 13) {
                        print $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $1, $2
                } else {
                        print $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $1, $1
                 }
        }' > $output_dir/CSQ_joined.tsv

sort -k1,1 -k2,2n $output_dir/CSQ_joined.tsv > $output_dir/CSQ_${1}_WBGeneID.tsv
# rm $output_dir/CSQ_tempfinal_sorted.tsv $output_dir/CSQ_joined.tsv 


# SnpEff #
join -t$'\t' -1 1 -2 10 -a 2 $output_dir/$(basename $gtf)_SnpEff_sorted.tsv $output_dir/SnpEff_tempfinal_sorted.tsv | \
        awk -F'\t' -v OFS='\t' '{
                if (NF == 11) {
                        print $3, $4, $5, $6, $7, $8, $9, $10, $11, $1, $2
                } else {
                        print $2, $3, $4, $5, $6, $7, $8, $9, $10, $1, $1
                 }
        }' > $output_dir/SnpEff_joined.tsv

sort -k1,1 -k2,2n $output_dir/SnpEff_joined.tsv > $output_dir/SnpEff_${1}_WBGeneID.tsv
# rm $output_dir/SnpEff_tempfinal_sorted.tsv $output_dir/SnpEff_joined.tsv 



#### ADDING GRANTHAM SCORES ####
# CSQ 
# awk -F'\t' -v OFS='\t' '
# BEGIN {
#     grantham["A/R"]=112; grantham["A/N"]=111; grantham["A/D"]=126; grantham["A/C"]=195; grantham["A/Q"]=91;
#     grantham["A/E"]=107; grantham["A/G"]=60;  grantham["A/H"]=86;  grantham["A/I"]=94;  grantham["A/L"]=96;
#     grantham["A/K"]=106; grantham["A/M"]=84;  grantham["A/F"]=113; grantham["A/P"]=27;  grantham["A/S"]=99;
#     grantham["A/T"]=58;  grantham["A/W"]=148; grantham["A/Y"]=112; grantham["A/V"]=64;

#     grantham["R/N"]=86;  grantham["R/D"]=96;  grantham["R/C"]=180; grantham["R/Q"]=43;  grantham["R/E"]=54;
#     grantham["R/G"]=125; grantham["R/H"]=29;  grantham["R/I"]=97;  grantham["R/L"]=102; grantham["R/K"]=26;
#     grantham["R/M"]=91;  grantham["R/F"]=97;  grantham["R/P"]=103; grantham["R/S"]=110; grantham["R/T"]=71;
#     grantham["R/W"]=101; grantham["R/Y"]=77;  grantham["R/V"]=96;

#     grantham["N/D"]=23;  grantham["N/C"]=139; grantham["N/Q"]=46;  grantham["N/E"]=42;  grantham["N/G"]=80;
#     grantham["N/H"]=68;  grantham["N/I"]=149; grantham["N/L"]=153; grantham["N/K"]=94;  grantham["N/M"]=142;
#     grantham["N/F"]=158; grantham["N/P"]=91;  grantham["N/S"]=46;  grantham["N/T"]=65;  grantham["N/W"]=174;
#     grantham["N/Y"]=143; grantham["N/V"]=133;

#     grantham["D/C"]=154; grantham["D/Q"]=61;  grantham["D/E"]=45;  grantham["D/G"]=94;  grantham["D/H"]=81;
#     grantham["D/I"]=168; grantham["D/L"]=172; grantham["D/K"]=101; grantham["D/M"]=160; grantham["D/F"]=177;
#     grantham["D/P"]=108; grantham["D/S"]=65;  grantham["D/T"]=85;  grantham["D/W"]=181; grantham["D/Y"]=160;
#     grantham["D/V"]=152;

#     grantham["C/Q"]=154; grantham["C/E"]=158; grantham["C/G"]=159; grantham["C/H"]=174; grantham["C/I"]=198;
#     grantham["C/L"]=198; grantham["C/K"]=202; grantham["C/M"]=196; grantham["C/F"]=205; grantham["C/P"]=169;
#     grantham["C/S"]=112; grantham["C/T"]=149; grantham["C/W"]=215; grantham["C/Y"]=194; grantham["C/V"]=192;

#     grantham["Q/E"]=29;  grantham["Q/G"]=87;  grantham["Q/H"]=24;  grantham["Q/I"]=109; grantham["Q/L"]=113;
#     grantham["Q/K"]=53;  grantham["Q/M"]=101; grantham["Q/F"]=116; grantham["Q/P"]=76;  grantham["Q/S"]=68;
#     grantham["Q/T"]=42;  grantham["Q/W"]=130; grantham["Q/Y"]=99;  grantham["Q/V"]=96;

#     grantham["E/G"]=98;  grantham["E/H"]=40;  grantham["E/I"]=134; grantham["E/L"]=138; grantham["E/K"]=56;
#     grantham["E/M"]=126; grantham["E/F"]=140; grantham["E/P"]=93;  grantham["E/S"]=80;  grantham["E/T"]=65;
#     grantham["E/W"]=152; grantham["E/Y"]=122; grantham["E/V"]=121;

#     grantham["G/H"]=98;  grantham["G/I"]=135; grantham["G/L"]=138; grantham["G/K"]=127; grantham["G/M"]=127;
#     grantham["G/F"]=153; grantham["G/P"]=42;  grantham["G/S"]=56;  grantham["G/T"]=59;  grantham["G/W"]=184;
#     grantham["G/Y"]=147; grantham["G/V"]=109;

#     grantham["H/I"]=94;  grantham["H/L"]=99;  grantham["H/K"]=32;  grantham["H/M"]=87;  grantham["H/F"]=100;
#     grantham["H/P"]=77;  grantham["H/S"]=89;  grantham["H/T"]=47;  grantham["H/W"]=115; grantham["H/Y"]=83;
#     grantham["H/V"]=84;

#     grantham["I/L"]=5;   grantham["I/K"]=102; grantham["I/M"]=10;  grantham["I/F"]=21;  grantham["I/P"]=95;
#     grantham["I/S"]=142; grantham["I/T"]=89;  grantham["I/W"]=61;  grantham["I/Y"]=33;  grantham["I/V"]=29;

#     grantham["L/K"]=107; grantham["L/M"]=15;  grantham["L/F"]=22;  grantham["L/P"]=98;  grantham["L/S"]=145;
#     grantham["L/T"]=92;  grantham["L/W"]=61;  grantham["L/Y"]=36;  grantham["L/V"]=32;

#     grantham["K/M"]=95;  grantham["K/F"]=102; grantham["K/P"]=103; grantham["K/S"]=121; grantham["K/T"]=78;
#     grantham["K/W"]=110; grantham["K/Y"]=85;  grantham["K/V"]=97;

#     grantham["M/F"]=28;  grantham["M/P"]=87;  grantham["M/S"]=135; grantham["M/T"]=81;  grantham["M/W"]=67;
#     grantham["M/Y"]=36;  grantham["M/V"]=21;

#     grantham["F/P"]=114; grantham["F/S"]=155; grantham["F/T"]=103; grantham["F/W"]=40;  grantham["F/Y"]=22;
#     grantham["F/V"]=50;

#     grantham["P/S"]=74;  grantham["P/T"]=38;  grantham["P/W"]=147; grantham["P/Y"]=110; grantham["P/V"]=68;

#     grantham["S/T"]=58;  grantham["S/W"]=177; grantham["S/Y"]=144; grantham["S/V"]=124;

#     grantham["T/W"]=128; grantham["T/Y"]=92;  grantham["T/V"]=69;

#     grantham["W/Y"]=37;  grantham["W/V"]=88;

#     grantham["Y/V"]=55;
# }

# {
#     if ($5 ~ /missense/) {
        
#         # Extract amino acid substitution from column 6: e.g. 175D>175N -> D/N
#         match($6, /[0-9]+([A-Z])>[0-9]*([A-Z])/, aa)
#         ref = aa[1]
#         alt = aa[2]

#         key = ref "/" alt
#         rev_key = alt "/" ref  ### Grantham matrix is symmetrical

#         if (key in grantham)
#             print $0, grantham[key]
#         else if (rev_key in grantham)
#             print $0, grantham[rev_key]
#         else
#             print $0, "NO_GRANTHAM_SCORE"
#     } else {
#         print $0, "N/A"
#     }
# }
# ' $output_dir/CSQ_${1}_WBGeneID.tsv > $output_dir/CSQ_${1}_WBGeneID_GRANTHAM_test.tsv



# VEP 
# awk -F'\t' -v OFS='\t' '
# BEGIN {
    # grantham["A/R"]=112; grantham["A/N"]=111; grantham["A/D"]=126; grantham["A/C"]=195; grantham["A/Q"]=91;
    # grantham["A/E"]=107; grantham["A/G"]=60;  grantham["A/H"]=86;  grantham["A/I"]=94;  grantham["A/L"]=96;
    # grantham["A/K"]=106; grantham["A/M"]=84;  grantham["A/F"]=113; grantham["A/P"]=27;  grantham["A/S"]=99;
    # grantham["A/T"]=58;  grantham["A/W"]=148; grantham["A/Y"]=112; grantham["A/V"]=64;

    # grantham["R/N"]=86;  grantham["R/D"]=96;  grantham["R/C"]=180; grantham["R/Q"]=43;  grantham["R/E"]=54;
    # grantham["R/G"]=125; grantham["R/H"]=29;  grantham["R/I"]=97;  grantham["R/L"]=102; grantham["R/K"]=26;
    # grantham["R/M"]=91;  grantham["R/F"]=97;  grantham["R/P"]=103; grantham["R/S"]=110; grantham["R/T"]=71;
    # grantham["R/W"]=101; grantham["R/Y"]=77;  grantham["R/V"]=96;

    # grantham["N/D"]=23;  grantham["N/C"]=139; grantham["N/Q"]=46;  grantham["N/E"]=42;  grantham["N/G"]=80;
    # grantham["N/H"]=68;  grantham["N/I"]=149; grantham["N/L"]=153; grantham["N/K"]=94;  grantham["N/M"]=142;
    # grantham["N/F"]=158; grantham["N/P"]=91;  grantham["N/S"]=46;  grantham["N/T"]=65;  grantham["N/W"]=174;
    # grantham["N/Y"]=143; grantham["N/V"]=133;

    # grantham["D/C"]=154; grantham["D/Q"]=61;  grantham["D/E"]=45;  grantham["D/G"]=94;  grantham["D/H"]=81;
    # grantham["D/I"]=168; grantham["D/L"]=172; grantham["D/K"]=101; grantham["D/M"]=160; grantham["D/F"]=177;
    # grantham["D/P"]=108; grantham["D/S"]=65;  grantham["D/T"]=85;  grantham["D/W"]=181; grantham["D/Y"]=160;
    # grantham["D/V"]=152;

    # grantham["C/Q"]=154; grantham["C/E"]=158; grantham["C/G"]=159; grantham["C/H"]=174; grantham["C/I"]=198;
    # grantham["C/L"]=198; grantham["C/K"]=202; grantham["C/M"]=196; grantham["C/F"]=205; grantham["C/P"]=169;
    # grantham["C/S"]=112; grantham["C/T"]=149; grantham["C/W"]=215; grantham["C/Y"]=194; grantham["C/V"]=192;

    # grantham["Q/E"]=29;  grantham["Q/G"]=87;  grantham["Q/H"]=24;  grantham["Q/I"]=109; grantham["Q/L"]=113;
    # grantham["Q/K"]=53;  grantham["Q/M"]=101; grantham["Q/F"]=116; grantham["Q/P"]=76;  grantham["Q/S"]=68;
    # grantham["Q/T"]=42;  grantham["Q/W"]=130; grantham["Q/Y"]=99;  grantham["Q/V"]=96;

    # grantham["E/G"]=98;  grantham["E/H"]=40;  grantham["E/I"]=134; grantham["E/L"]=138; grantham["E/K"]=56;
    # grantham["E/M"]=126; grantham["E/F"]=140; grantham["E/P"]=93;  grantham["E/S"]=80;  grantham["E/T"]=65;
    # grantham["E/W"]=152; grantham["E/Y"]=122; grantham["E/V"]=121;

    # grantham["G/H"]=98;  grantham["G/I"]=135; grantham["G/L"]=138; grantham["G/K"]=127; grantham["G/M"]=127;
    # grantham["G/F"]=153; grantham["G/P"]=42;  grantham["G/S"]=56;  grantham["G/T"]=59;  grantham["G/W"]=184;
    # grantham["G/Y"]=147; grantham["G/V"]=109;

    # grantham["H/I"]=94;  grantham["H/L"]=99;  grantham["H/K"]=32;  grantham["H/M"]=87;  grantham["H/F"]=100;
    # grantham["H/P"]=77;  grantham["H/S"]=89;  grantham["H/T"]=47;  grantham["H/W"]=115; grantham["H/Y"]=83;
    # grantham["H/V"]=84;

    # grantham["I/L"]=5;   grantham["I/K"]=102; grantham["I/M"]=10;  grantham["I/F"]=21;  grantham["I/P"]=95;
    # grantham["I/S"]=142; grantham["I/T"]=89;  grantham["I/W"]=61;  grantham["I/Y"]=33;  grantham["I/V"]=29;

    # grantham["L/K"]=107; grantham["L/M"]=15;  grantham["L/F"]=22;  grantham["L/P"]=98;  grantham["L/S"]=145;
    # grantham["L/T"]=92;  grantham["L/W"]=61;  grantham["L/Y"]=36;  grantham["L/V"]=32;

    # grantham["K/M"]=95;  grantham["K/F"]=102; grantham["K/P"]=103; grantham["K/S"]=121; grantham["K/T"]=78;
    # grantham["K/W"]=110; grantham["K/Y"]=85;  grantham["K/V"]=97;

    # grantham["M/F"]=28;  grantham["M/P"]=87;  grantham["M/S"]=135; grantham["M/T"]=81;  grantham["M/W"]=67;
    # grantham["M/Y"]=36;  grantham["M/V"]=21;

    # grantham["F/P"]=114; grantham["F/S"]=155; grantham["F/T"]=103; grantham["F/W"]=40;  grantham["F/Y"]=22;
    # grantham["F/V"]=50;

    # grantham["P/S"]=74;  grantham["P/T"]=38;  grantham["P/W"]=147; grantham["P/Y"]=110; grantham["P/V"]=68;

    # grantham["S/T"]=58;  grantham["S/W"]=177; grantham["S/Y"]=144; grantham["S/V"]=124;

    # grantham["T/W"]=128; grantham["T/Y"]=92;  grantham["T/V"]=69;

    # grantham["W/Y"]=37;  grantham["W/V"]=88;

    # grantham["Y/V"]=55;
# }

# {
#     if ($5 ~ /missense_variant/) {
        
#         # Extract amino acid substitution from column 7: e.g.  D/N
#         match($7, /^([A-Z])\/([A-Z])$/, aa)
    
#         ref = aa[1]
#         alt = aa[2]

#         key = ref "/" alt
#         rev_key = alt "/" ref  ### Grantham matrix is symmetrical

#         if (key in grantham)
#             print $0, grantham[key]
#         else if (rev_key in grantham)
#             print $0, grantham[rev_key]
#         else
#             print $0, "NO_GRANTHAM_SCORE"
#     } else {
#         print $0, "N/A"
#     }
# }
# ' $output_dir/VEP_${1}_WBGeneID.tsv > $output_dir/VEP_${1}_WBGeneID_GRANTHAM_test.tsv



# ANNVOAR
# awk -F'\t' -v OFS='\t' '
# BEGIN {
#     grantham["A/R"]=112; grantham["A/N"]=111; grantham["A/D"]=126; grantham["A/C"]=195; grantham["A/Q"]=91;
#     grantham["A/E"]=107; grantham["A/G"]=60;  grantham["A/H"]=86;  grantham["A/I"]=94;  grantham["A/L"]=96;
#     grantham["A/K"]=106; grantham["A/M"]=84;  grantham["A/F"]=113; grantham["A/P"]=27;  grantham["A/S"]=99;
#     grantham["A/T"]=58;  grantham["A/W"]=148; grantham["A/Y"]=112; grantham["A/V"]=64;

#     grantham["R/N"]=86;  grantham["R/D"]=96;  grantham["R/C"]=180; grantham["R/Q"]=43;  grantham["R/E"]=54;
#     grantham["R/G"]=125; grantham["R/H"]=29;  grantham["R/I"]=97;  grantham["R/L"]=102; grantham["R/K"]=26;
#     grantham["R/M"]=91;  grantham["R/F"]=97;  grantham["R/P"]=103; grantham["R/S"]=110; grantham["R/T"]=71;
#     grantham["R/W"]=101; grantham["R/Y"]=77;  grantham["R/V"]=96;

#     grantham["N/D"]=23;  grantham["N/C"]=139; grantham["N/Q"]=46;  grantham["N/E"]=42;  grantham["N/G"]=80;
#     grantham["N/H"]=68;  grantham["N/I"]=149; grantham["N/L"]=153; grantham["N/K"]=94;  grantham["N/M"]=142;
#     grantham["N/F"]=158; grantham["N/P"]=91;  grantham["N/S"]=46;  grantham["N/T"]=65;  grantham["N/W"]=174;
#     grantham["N/Y"]=143; grantham["N/V"]=133;

#     grantham["D/C"]=154; grantham["D/Q"]=61;  grantham["D/E"]=45;  grantham["D/G"]=94;  grantham["D/H"]=81;
#     grantham["D/I"]=168; grantham["D/L"]=172; grantham["D/K"]=101; grantham["D/M"]=160; grantham["D/F"]=177;
#     grantham["D/P"]=108; grantham["D/S"]=65;  grantham["D/T"]=85;  grantham["D/W"]=181; grantham["D/Y"]=160;
#     grantham["D/V"]=152;

#     grantham["C/Q"]=154; grantham["C/E"]=158; grantham["C/G"]=159; grantham["C/H"]=174; grantham["C/I"]=198;
#     grantham["C/L"]=198; grantham["C/K"]=202; grantham["C/M"]=196; grantham["C/F"]=205; grantham["C/P"]=169;
#     grantham["C/S"]=112; grantham["C/T"]=149; grantham["C/W"]=215; grantham["C/Y"]=194; grantham["C/V"]=192;

#     grantham["Q/E"]=29;  grantham["Q/G"]=87;  grantham["Q/H"]=24;  grantham["Q/I"]=109; grantham["Q/L"]=113;
#     grantham["Q/K"]=53;  grantham["Q/M"]=101; grantham["Q/F"]=116; grantham["Q/P"]=76;  grantham["Q/S"]=68;
#     grantham["Q/T"]=42;  grantham["Q/W"]=130; grantham["Q/Y"]=99;  grantham["Q/V"]=96;

#     grantham["E/G"]=98;  grantham["E/H"]=40;  grantham["E/I"]=134; grantham["E/L"]=138; grantham["E/K"]=56;
#     grantham["E/M"]=126; grantham["E/F"]=140; grantham["E/P"]=93;  grantham["E/S"]=80;  grantham["E/T"]=65;
#     grantham["E/W"]=152; grantham["E/Y"]=122; grantham["E/V"]=121;

#     grantham["G/H"]=98;  grantham["G/I"]=135; grantham["G/L"]=138; grantham["G/K"]=127; grantham["G/M"]=127;
#     grantham["G/F"]=153; grantham["G/P"]=42;  grantham["G/S"]=56;  grantham["G/T"]=59;  grantham["G/W"]=184;
#     grantham["G/Y"]=147; grantham["G/V"]=109;

#     grantham["H/I"]=94;  grantham["H/L"]=99;  grantham["H/K"]=32;  grantham["H/M"]=87;  grantham["H/F"]=100;
#     grantham["H/P"]=77;  grantham["H/S"]=89;  grantham["H/T"]=47;  grantham["H/W"]=115; grantham["H/Y"]=83;
#     grantham["H/V"]=84;

#     grantham["I/L"]=5;   grantham["I/K"]=102; grantham["I/M"]=10;  grantham["I/F"]=21;  grantham["I/P"]=95;
#     grantham["I/S"]=142; grantham["I/T"]=89;  grantham["I/W"]=61;  grantham["I/Y"]=33;  grantham["I/V"]=29;

#     grantham["L/K"]=107; grantham["L/M"]=15;  grantham["L/F"]=22;  grantham["L/P"]=98;  grantham["L/S"]=145;
#     grantham["L/T"]=92;  grantham["L/W"]=61;  grantham["L/Y"]=36;  grantham["L/V"]=32;

#     grantham["K/M"]=95;  grantham["K/F"]=102; grantham["K/P"]=103; grantham["K/S"]=121; grantham["K/T"]=78;
#     grantham["K/W"]=110; grantham["K/Y"]=85;  grantham["K/V"]=97;

#     grantham["M/F"]=28;  grantham["M/P"]=87;  grantham["M/S"]=135; grantham["M/T"]=81;  grantham["M/W"]=67;
#     grantham["M/Y"]=36;  grantham["M/V"]=21;

#     grantham["F/P"]=114; grantham["F/S"]=155; grantham["F/T"]=103; grantham["F/W"]=40;  grantham["F/Y"]=22;
#     grantham["F/V"]=50;

#     grantham["P/S"]=74;  grantham["P/T"]=38;  grantham["P/W"]=147; grantham["P/Y"]=110; grantham["P/V"]=68;

#     grantham["S/T"]=58;  grantham["S/W"]=177; grantham["S/Y"]=144; grantham["S/V"]=124;

#     grantham["T/W"]=128; grantham["T/Y"]=92;  grantham["T/V"]=69;

#     grantham["W/Y"]=37;  grantham["W/V"]=88;

#     grantham["Y/V"]=55;
# }

# {
#     if ($6 ~ /nonsynonymous_SNV/) {
        
#         # Extract amino acid substitution from column 7: e.g.  p.E161V
#         match($7, /^p\.([A-Z])[0-9]+([A-Z])$/, aa)
    
#         ref = aa[1]
#         alt = aa[2]

#         key = ref "/" alt
#         rev_key = alt "/" ref  ### Grantham matrix is symmetrical

#         if (key in grantham)
#             print $0, grantham[key]
#         else if (rev_key in grantham)
#             print $0, grantham[rev_key]
#         else
#             print $0, "NO_GRANTHAM_SCORE"
#     } else {
#         print $0, "N/A"
#     }
# }
# ' $output_dir/ANNOVAR_${1}_WBGeneID.tsv > $output_dir/ANNOVAR_${1}_WBGeneID_GRANTHAM_test.tsv



# SnpEff p.Thr305Lys
# awk -F'\t' -v OFS='\t' '
# BEGIN {
#     # 3-letter to 1-letter amino acid codes
#     aa3to1["Ala"] = "A"; aa3to1["Arg"] = "R"; aa3to1["Asn"] = "N"; aa3to1["Asp"] = "D";
#     aa3to1["Cys"] = "C"; aa3to1["Gln"] = "Q"; aa3to1["Glu"] = "E"; aa3to1["Gly"] = "G";
#     aa3to1["His"] = "H"; aa3to1["Ile"] = "I"; aa3to1["Leu"] = "L"; aa3to1["Lys"] = "K";
#     aa3to1["Met"] = "M"; aa3to1["Phe"] = "F"; aa3to1["Pro"] = "P"; aa3to1["Ser"] = "S";
#     aa3to1["Thr"] = "T"; aa3to1["Trp"] = "W"; aa3to1["Tyr"] = "Y"; aa3to1["Val"] = "V";

#     # Grantham matrix
#     grantham["A/R"]=112; grantham["A/N"]=111; grantham["A/D"]=126; grantham["A/C"]=195; grantham["A/Q"]=91;
#     grantham["A/E"]=107; grantham["A/G"]=60;  grantham["A/H"]=86;  grantham["A/I"]=94;  grantham["A/L"]=96;
#     grantham["A/K"]=106; grantham["A/M"]=84;  grantham["A/F"]=113; grantham["A/P"]=27;  grantham["A/S"]=99;
#     grantham["A/T"]=58;  grantham["A/W"]=148; grantham["A/Y"]=112; grantham["A/V"]=64;

#     grantham["R/N"]=86;  grantham["R/D"]=96;  grantham["R/C"]=180; grantham["R/Q"]=43;  grantham["R/E"]=54;
#     grantham["R/G"]=125; grantham["R/H"]=29;  grantham["R/I"]=97;  grantham["R/L"]=102; grantham["R/K"]=26;
#     grantham["R/M"]=91;  grantham["R/F"]=97;  grantham["R/P"]=103; grantham["R/S"]=110; grantham["R/T"]=71;
#     grantham["R/W"]=101; grantham["R/Y"]=77;  grantham["R/V"]=96;

#     grantham["N/D"]=23;  grantham["N/C"]=139; grantham["N/Q"]=46;  grantham["N/E"]=42;  grantham["N/G"]=80;
#     grantham["N/H"]=68;  grantham["N/I"]=149; grantham["N/L"]=153; grantham["N/K"]=94;  grantham["N/M"]=142;
#     grantham["N/F"]=158; grantham["N/P"]=91;  grantham["N/S"]=46;  grantham["N/T"]=65;  grantham["N/W"]=174;
#     grantham["N/Y"]=143; grantham["N/V"]=133;

#     grantham["D/C"]=154; grantham["D/Q"]=61;  grantham["D/E"]=45;  grantham["D/G"]=94;  grantham["D/H"]=81;
#     grantham["D/I"]=168; grantham["D/L"]=172; grantham["D/K"]=101; grantham["D/M"]=160; grantham["D/F"]=177;
#     grantham["D/P"]=108; grantham["D/S"]=65;  grantham["D/T"]=85;  grantham["D/W"]=181; grantham["D/Y"]=160;
#     grantham["D/V"]=152;

#     grantham["C/Q"]=154; grantham["C/E"]=158; grantham["C/G"]=159; grantham["C/H"]=174; grantham["C/I"]=198;
#     grantham["C/L"]=198; grantham["C/K"]=202; grantham["C/M"]=196; grantham["C/F"]=205; grantham["C/P"]=169;
#     grantham["C/S"]=112; grantham["C/T"]=149; grantham["C/W"]=215; grantham["C/Y"]=194; grantham["C/V"]=192;

#     grantham["Q/E"]=29;  grantham["Q/G"]=87;  grantham["Q/H"]=24;  grantham["Q/I"]=109; grantham["Q/L"]=113;
#     grantham["Q/K"]=53;  grantham["Q/M"]=101; grantham["Q/F"]=116; grantham["Q/P"]=76;  grantham["Q/S"]=68;
#     grantham["Q/T"]=42;  grantham["Q/W"]=130; grantham["Q/Y"]=99;  grantham["Q/V"]=96;

#     grantham["E/G"]=98;  grantham["E/H"]=40;  grantham["E/I"]=134; grantham["E/L"]=138; grantham["E/K"]=56;
#     grantham["E/M"]=126; grantham["E/F"]=140; grantham["E/P"]=93;  grantham["E/S"]=80;  grantham["E/T"]=65;
#     grantham["E/W"]=152; grantham["E/Y"]=122; grantham["E/V"]=121;

#     grantham["G/H"]=98;  grantham["G/I"]=135; grantham["G/L"]=138; grantham["G/K"]=127; grantham["G/M"]=127;
#     grantham["G/F"]=153; grantham["G/P"]=42;  grantham["G/S"]=56;  grantham["G/T"]=59;  grantham["G/W"]=184;
#     grantham["G/Y"]=147; grantham["G/V"]=109;

#     grantham["H/I"]=94;  grantham["H/L"]=99;  grantham["H/K"]=32;  grantham["H/M"]=87;  grantham["H/F"]=100;
#     grantham["H/P"]=77;  grantham["H/S"]=89;  grantham["H/T"]=47;  grantham["H/W"]=115; grantham["H/Y"]=83;
#     grantham["H/V"]=84;

#     grantham["I/L"]=5;   grantham["I/K"]=102; grantham["I/M"]=10;  grantham["I/F"]=21;  grantham["I/P"]=95;
#     grantham["I/S"]=142; grantham["I/T"]=89;  grantham["I/W"]=61;  grantham["I/Y"]=33;  grantham["I/V"]=29;

#     grantham["L/K"]=107; grantham["L/M"]=15;  grantham["L/F"]=22;  grantham["L/P"]=98;  grantham["L/S"]=145;
#     grantham["L/T"]=92;  grantham["L/W"]=61;  grantham["L/Y"]=36;  grantham["L/V"]=32;

#     grantham["K/M"]=95;  grantham["K/F"]=102; grantham["K/P"]=103; grantham["K/S"]=121; grantham["K/T"]=78;
#     grantham["K/W"]=110; grantham["K/Y"]=85;  grantham["K/V"]=97;

#     grantham["M/F"]=28;  grantham["M/P"]=87;  grantham["M/S"]=135; grantham["M/T"]=81;  grantham["M/W"]=67;
#     grantham["M/Y"]=36;  grantham["M/V"]=21;

#     grantham["F/P"]=114; grantham["F/S"]=155; grantham["F/T"]=103; grantham["F/W"]=40;  grantham["F/Y"]=22;
#     grantham["F/V"]=50;

#     grantham["P/S"]=74;  grantham["P/T"]=38;  grantham["P/W"]=147; grantham["P/Y"]=110; grantham["P/V"]=68;

#     grantham["S/T"]=58;  grantham["S/W"]=177; grantham["S/Y"]=144; grantham["S/V"]=124;

#     grantham["T/W"]=128; grantham["T/Y"]=92;  grantham["T/V"]=69;

#     grantham["W/Y"]=37;  grantham["W/V"]=88;

#     grantham["Y/V"]=55;
# }

# {
#     if ($5 ~ /nonsynonymous/) {
        
#         # Extract amino acid substitution from column 7: e.g.  p.E161V
#         match($7, /^p\.([A-Z][a-z]{2})([0-9]+)([A-Z][a-z]{2})$/, m)

#         ref = aa3to1[m[1]]
#         alt = aa3to1[m[3]]

#         key = ref "/" alt
#         rev_key = alt "/" ref  ### Grantham matrix is symmetrical

#         if (key in grantham)
#             print $0, grantham[key]
#         else if (rev_key in grantham)
#             print $0, grantham[rev_key]
#         else
#             print $0, "NO_GRANTHAM_SCORE"
#     } else {
#         print $0, "N/A"
#     }
# }
# ' $output_dir/SnpEff_${1}_WBGeneID.tsv > $output_dir/SnpEff_${1}_WBGeneID_GRANTHAM_test.tsv



#### ADDING BLOSUM62 SCORES ####
# No need to add BLOSUM62 scores to SnpEff

# CSQ
# awk -F'\t' -v OFS='\t' '
# BEGIN {
#     # BLOSUM62 substitution matrix 
#     blosum["A/A"]=4;  blosum["A/R"]=-1; blosum["A/N"]=-2; blosum["A/D"]=-2; blosum["A/C"]=0;
#     blosum["A/Q"]=-1; blosum["A/E"]=-1; blosum["A/G"]=0;  blosum["A/H"]=-2; blosum["A/I"]=-1;
#     blosum["A/L"]=-1; blosum["A/K"]=-1; blosum["A/M"]=-1; blosum["A/F"]=-2; blosum["A/P"]=-1;
#     blosum["A/S"]=1;  blosum["A/T"]=0;  blosum["A/W"]=-3; blosum["A/Y"]=-2; blosum["A/V"]=0;

#     blosum["R/R"]=5;  blosum["R/N"]=0;  blosum["R/D"]=-2; blosum["R/C"]=-3; blosum["R/Q"]=1;
#     blosum["R/E"]=0;  blosum["R/G"]=-2; blosum["R/H"]=0;  blosum["R/I"]=-3; blosum["R/L"]=-2;
#     blosum["R/K"]=2;  blosum["R/M"]=-1; blosum["R/F"]=-3; blosum["R/P"]=-2; blosum["R/S"]=-1;
#     blosum["R/T"]=-1; blosum["R/W"]=-3; blosum["R/Y"]=-2; blosum["R/V"]=-3;

#     blosum["N/N"]=6;  blosum["N/D"]=1;  blosum["N/C"]=-3; blosum["N/Q"]=0;  blosum["N/E"]=0;
#     blosum["N/G"]=0;  blosum["N/H"]=1;  blosum["N/I"]=-3; blosum["N/L"]=-3; blosum["N/K"]=0;
#     blosum["N/M"]=-2; blosum["N/F"]=-3; blosum["N/P"]=-2; blosum["N/S"]=1;  blosum["N/T"]=0;
#     blosum["N/W"]=-4; blosum["N/Y"]=-2; blosum["N/V"]=-3;

#     blosum["D/D"]=6;  blosum["D/C"]=-3; blosum["D/Q"]=0;  blosum["D/E"]=2;  blosum["D/G"]=-1;
#     blosum["D/H"]=-1; blosum["D/I"]=-3; blosum["D/L"]=-4; blosum["D/K"]=-1; blosum["D/M"]=-3;
#     blosum["D/F"]=-3; blosum["D/P"]=-1; blosum["D/S"]=0;  blosum["D/T"]=-1; blosum["D/W"]=-4;
#     blosum["D/Y"]=-3; blosum["D/V"]=-3;

#     blosum["C/C"]=9;  blosum["C/Q"]=-3; blosum["C/E"]=-4; blosum["C/G"]=-3; blosum["C/H"]=-3;
#     blosum["C/I"]=-1; blosum["C/L"]=-1; blosum["C/K"]=-3; blosum["C/M"]=-1; blosum["C/F"]=-2;
#     blosum["C/P"]=-3; blosum["C/S"]=-1; blosum["C/T"]=-1; blosum["C/W"]=-2; blosum["C/Y"]=-2;
#     blosum["C/V"]=-1;

#     blosum["Q/Q"]=5;  blosum["Q/E"]=2;  blosum["Q/G"]=-2; blosum["Q/H"]=0;  blosum["Q/I"]=-3;
#     blosum["Q/L"]=-2; blosum["Q/K"]=1;  blosum["Q/M"]=0;  blosum["Q/F"]=-3; blosum["Q/P"]=-1;
#     blosum["Q/S"]=0;  blosum["Q/T"]=-1; blosum["Q/W"]=-2; blosum["Q/Y"]=-1; blosum["Q/V"]=-2;

#     blosum["E/E"]=5;  blosum["E/G"]=-2; blosum["E/H"]=0;  blosum["E/I"]=-3; blosum["E/L"]=-3;
#     blosum["E/K"]=1;  blosum["E/M"]=-2; blosum["E/F"]=-3; blosum["E/P"]=-1; blosum["E/S"]=0;
#     blosum["E/T"]=-1; blosum["E/W"]=-3; blosum["E/Y"]=-2; blosum["E/V"]=-2;

#     blosum["G/G"]=6;  blosum["G/H"]=-2; blosum["G/I"]=-4; blosum["G/L"]=-4; blosum["G/K"]=-2;
#     blosum["G/M"]=-3; blosum["G/F"]=-3; blosum["G/P"]=-2; blosum["G/S"]=0;  blosum["G/T"]=-2;
#     blosum["G/W"]=-2; blosum["G/Y"]=-3; blosum["G/V"]=-3;

#     blosum["H/H"]=8;  blosum["H/I"]=-3; blosum["H/L"]=-3; blosum["H/K"]=-1; blosum["H/M"]=-2;
#     blosum["H/F"]=-1; blosum["H/P"]=-2; blosum["H/S"]=-1; blosum["H/T"]=-2; blosum["H/W"]=-2;
#     blosum["H/Y"]=2;  blosum["H/V"]=-3;

#     blosum["I/I"]=4;  blosum["I/L"]=2;  blosum["I/K"]=-3; blosum["I/M"]=1;  blosum["I/F"]=0;
#     blosum["I/P"]=-3; blosum["I/S"]=-2; blosum["I/T"]=-1; blosum["I/W"]=-3; blosum["I/Y"]=-1;
#     blosum["I/V"]=3;

#     blosum["L/L"]=4;  blosum["L/K"]=-2; blosum["L/M"]=2;  blosum["L/F"]=0;  blosum["L/P"]=-3;
#     blosum["L/S"]=-2; blosum["L/T"]=-1; blosum["L/W"]=-2; blosum["L/Y"]=-1; blosum["L/V"]=1;

#     blosum["K/K"]=5;  blosum["K/M"]=-1; blosum["K/F"]=-3; blosum["K/P"]=-1; blosum["K/S"]=0;
#     blosum["K/T"]=-1; blosum["K/W"]=-3; blosum["K/Y"]=-2; blosum["K/V"]=-2;

#     blosum["M/M"]=5;  blosum["M/F"]=0;  blosum["M/P"]=-2; blosum["M/S"]=-1; blosum["M/T"]=-1;
#     blosum["M/W"]=-1; blosum["M/Y"]=-1; blosum["M/V"]=1;

#     blosum["F/F"]=6;  blosum["F/P"]=-4; blosum["F/S"]=-2; blosum["F/T"]=-2; blosum["F/W"]=1;
#     blosum["F/Y"]=3;  blosum["F/V"]=-1;

#     blosum["P/P"]=7;  blosum["P/S"]=-1; blosum["P/T"]=-1; blosum["P/W"]=-4; blosum["P/Y"]=-3;
#     blosum["P/V"]=-2;

#     blosum["S/S"]=4;  blosum["S/T"]=1;  blosum["S/W"]=-3; blosum["S/Y"]=-2; blosum["S/V"]=-2;

#     blosum["T/T"]=5;  blosum["T/W"]=-2; blosum["T/Y"]=-2; blosum["T/V"]=0;

#     blosum["W/W"]=11; blosum["W/Y"]=2;  blosum["W/V"]=-3;

#     blosum["Y/Y"]=7;  blosum["Y/V"]=-1;

#     blosum["V/V"]=4;
# }
# {
#     if ($5 ~ /missense/) {
#         match($6, /[0-9]+([A-Z])>[0-9]*([A-Z])/, aa)
#         ref = aa[1]
#         alt = aa[2]

#         key = ref "/" alt
#         rev_key = alt "/" ref # BLOSUM62 matrix is symmetrical

#         if (key in blosum)
#             print $0, blosum[key]
#         else if (rev_key in blosum)
#             print $0, blosum[rev_key]
#         else
#             print $0, "NO_BLOSUM_SCORE"
#     } else {
#         print $0, "N/A"
#     }
# }
# ' $output_dir/CSQ_${1}_WBGeneID_GRANTHAM_test.tsv > $output_dir/CSQ_${1}_WBGeneID_GRANTHAM_BLOSUM_test.tsv


# # VEP
# awk -F'\t' -v OFS='\t' '
# BEGIN {
#     # BLOSUM62 substitution matrix 
#     blosum["A/A"]=4;  blosum["A/R"]=-1; blosum["A/N"]=-2; blosum["A/D"]=-2; blosum["A/C"]=0;
#     blosum["A/Q"]=-1; blosum["A/E"]=-1; blosum["A/G"]=0;  blosum["A/H"]=-2; blosum["A/I"]=-1;
#     blosum["A/L"]=-1; blosum["A/K"]=-1; blosum["A/M"]=-1; blosum["A/F"]=-2; blosum["A/P"]=-1;
#     blosum["A/S"]=1;  blosum["A/T"]=0;  blosum["A/W"]=-3; blosum["A/Y"]=-2; blosum["A/V"]=0;

#     blosum["R/R"]=5;  blosum["R/N"]=0;  blosum["R/D"]=-2; blosum["R/C"]=-3; blosum["R/Q"]=1;
#     blosum["R/E"]=0;  blosum["R/G"]=-2; blosum["R/H"]=0;  blosum["R/I"]=-3; blosum["R/L"]=-2;
#     blosum["R/K"]=2;  blosum["R/M"]=-1; blosum["R/F"]=-3; blosum["R/P"]=-2; blosum["R/S"]=-1;
#     blosum["R/T"]=-1; blosum["R/W"]=-3; blosum["R/Y"]=-2; blosum["R/V"]=-3;

#     blosum["N/N"]=6;  blosum["N/D"]=1;  blosum["N/C"]=-3; blosum["N/Q"]=0;  blosum["N/E"]=0;
#     blosum["N/G"]=0;  blosum["N/H"]=1;  blosum["N/I"]=-3; blosum["N/L"]=-3; blosum["N/K"]=0;
#     blosum["N/M"]=-2; blosum["N/F"]=-3; blosum["N/P"]=-2; blosum["N/S"]=1;  blosum["N/T"]=0;
#     blosum["N/W"]=-4; blosum["N/Y"]=-2; blosum["N/V"]=-3;

#     blosum["D/D"]=6;  blosum["D/C"]=-3; blosum["D/Q"]=0;  blosum["D/E"]=2;  blosum["D/G"]=-1;
#     blosum["D/H"]=-1; blosum["D/I"]=-3; blosum["D/L"]=-4; blosum["D/K"]=-1; blosum["D/M"]=-3;
#     blosum["D/F"]=-3; blosum["D/P"]=-1; blosum["D/S"]=0;  blosum["D/T"]=-1; blosum["D/W"]=-4;
#     blosum["D/Y"]=-3; blosum["D/V"]=-3;

#     blosum["C/C"]=9;  blosum["C/Q"]=-3; blosum["C/E"]=-4; blosum["C/G"]=-3; blosum["C/H"]=-3;
#     blosum["C/I"]=-1; blosum["C/L"]=-1; blosum["C/K"]=-3; blosum["C/M"]=-1; blosum["C/F"]=-2;
#     blosum["C/P"]=-3; blosum["C/S"]=-1; blosum["C/T"]=-1; blosum["C/W"]=-2; blosum["C/Y"]=-2;
#     blosum["C/V"]=-1;

#     blosum["Q/Q"]=5;  blosum["Q/E"]=2;  blosum["Q/G"]=-2; blosum["Q/H"]=0;  blosum["Q/I"]=-3;
#     blosum["Q/L"]=-2; blosum["Q/K"]=1;  blosum["Q/M"]=0;  blosum["Q/F"]=-3; blosum["Q/P"]=-1;
#     blosum["Q/S"]=0;  blosum["Q/T"]=-1; blosum["Q/W"]=-2; blosum["Q/Y"]=-1; blosum["Q/V"]=-2;

#     blosum["E/E"]=5;  blosum["E/G"]=-2; blosum["E/H"]=0;  blosum["E/I"]=-3; blosum["E/L"]=-3;
#     blosum["E/K"]=1;  blosum["E/M"]=-2; blosum["E/F"]=-3; blosum["E/P"]=-1; blosum["E/S"]=0;
#     blosum["E/T"]=-1; blosum["E/W"]=-3; blosum["E/Y"]=-2; blosum["E/V"]=-2;

#     blosum["G/G"]=6;  blosum["G/H"]=-2; blosum["G/I"]=-4; blosum["G/L"]=-4; blosum["G/K"]=-2;
#     blosum["G/M"]=-3; blosum["G/F"]=-3; blosum["G/P"]=-2; blosum["G/S"]=0;  blosum["G/T"]=-2;
#     blosum["G/W"]=-2; blosum["G/Y"]=-3; blosum["G/V"]=-3;

#     blosum["H/H"]=8;  blosum["H/I"]=-3; blosum["H/L"]=-3; blosum["H/K"]=-1; blosum["H/M"]=-2;
#     blosum["H/F"]=-1; blosum["H/P"]=-2; blosum["H/S"]=-1; blosum["H/T"]=-2; blosum["H/W"]=-2;
#     blosum["H/Y"]=2;  blosum["H/V"]=-3;

#     blosum["I/I"]=4;  blosum["I/L"]=2;  blosum["I/K"]=-3; blosum["I/M"]=1;  blosum["I/F"]=0;
#     blosum["I/P"]=-3; blosum["I/S"]=-2; blosum["I/T"]=-1; blosum["I/W"]=-3; blosum["I/Y"]=-1;
#     blosum["I/V"]=3;

#     blosum["L/L"]=4;  blosum["L/K"]=-2; blosum["L/M"]=2;  blosum["L/F"]=0;  blosum["L/P"]=-3;
#     blosum["L/S"]=-2; blosum["L/T"]=-1; blosum["L/W"]=-2; blosum["L/Y"]=-1; blosum["L/V"]=1;

#     blosum["K/K"]=5;  blosum["K/M"]=-1; blosum["K/F"]=-3; blosum["K/P"]=-1; blosum["K/S"]=0;
#     blosum["K/T"]=-1; blosum["K/W"]=-3; blosum["K/Y"]=-2; blosum["K/V"]=-2;

#     blosum["M/M"]=5;  blosum["M/F"]=0;  blosum["M/P"]=-2; blosum["M/S"]=-1; blosum["M/T"]=-1;
#     blosum["M/W"]=-1; blosum["M/Y"]=-1; blosum["M/V"]=1;

#     blosum["F/F"]=6;  blosum["F/P"]=-4; blosum["F/S"]=-2; blosum["F/T"]=-2; blosum["F/W"]=1;
#     blosum["F/Y"]=3;  blosum["F/V"]=-1;

#     blosum["P/P"]=7;  blosum["P/S"]=-1; blosum["P/T"]=-1; blosum["P/W"]=-4; blosum["P/Y"]=-3;
#     blosum["P/V"]=-2;

#     blosum["S/S"]=4;  blosum["S/T"]=1;  blosum["S/W"]=-3; blosum["S/Y"]=-2; blosum["S/V"]=-2;

#     blosum["T/T"]=5;  blosum["T/W"]=-2; blosum["T/Y"]=-2; blosum["T/V"]=0;

#     blosum["W/W"]=11; blosum["W/Y"]=2;  blosum["W/V"]=-3;

#     blosum["Y/Y"]=7;  blosum["Y/V"]=-1;

#     blosum["V/V"]=4;
# }
# {
#     if ($5 ~ /missense_variant/) {
#         match($7, /^([A-Z])\/([A-Z])$/, aa)
#         ref = aa[1]
#         alt = aa[2]

#         key = ref "/" alt
#         rev_key = alt "/" ref # BLOSUM62 matrix is symmetrical

#         if (key in blosum)
#             print $0, blosum[key]
#         else if (rev_key in blosum)
#             print $0, blosum[rev_key]
#         else
#             print $0, "NO_BLOSUM_SCORE"
#     } else {
#         print $0, "N/A"
#     }
# }
# ' $output_dir/VEP_${1}_WBGeneID_GRANTHAM_test.tsv > $output_dir/VEP_${1}_WBGeneID_GRANTHAM_BLOSUM_test.tsv


# ANNOVAR
# awk -F'\t' -v OFS='\t' '
# BEGIN {
#     # BLOSUM62 substitution matrix 
#     blosum["A/A"]=4;  blosum["A/R"]=-1; blosum["A/N"]=-2; blosum["A/D"]=-2; blosum["A/C"]=0;
#     blosum["A/Q"]=-1; blosum["A/E"]=-1; blosum["A/G"]=0;  blosum["A/H"]=-2; blosum["A/I"]=-1;
#     blosum["A/L"]=-1; blosum["A/K"]=-1; blosum["A/M"]=-1; blosum["A/F"]=-2; blosum["A/P"]=-1;
#     blosum["A/S"]=1;  blosum["A/T"]=0;  blosum["A/W"]=-3; blosum["A/Y"]=-2; blosum["A/V"]=0;

#     blosum["R/R"]=5;  blosum["R/N"]=0;  blosum["R/D"]=-2; blosum["R/C"]=-3; blosum["R/Q"]=1;
#     blosum["R/E"]=0;  blosum["R/G"]=-2; blosum["R/H"]=0;  blosum["R/I"]=-3; blosum["R/L"]=-2;
#     blosum["R/K"]=2;  blosum["R/M"]=-1; blosum["R/F"]=-3; blosum["R/P"]=-2; blosum["R/S"]=-1;
#     blosum["R/T"]=-1; blosum["R/W"]=-3; blosum["R/Y"]=-2; blosum["R/V"]=-3;

#     blosum["N/N"]=6;  blosum["N/D"]=1;  blosum["N/C"]=-3; blosum["N/Q"]=0;  blosum["N/E"]=0;
#     blosum["N/G"]=0;  blosum["N/H"]=1;  blosum["N/I"]=-3; blosum["N/L"]=-3; blosum["N/K"]=0;
#     blosum["N/M"]=-2; blosum["N/F"]=-3; blosum["N/P"]=-2; blosum["N/S"]=1;  blosum["N/T"]=0;
#     blosum["N/W"]=-4; blosum["N/Y"]=-2; blosum["N/V"]=-3;

#     blosum["D/D"]=6;  blosum["D/C"]=-3; blosum["D/Q"]=0;  blosum["D/E"]=2;  blosum["D/G"]=-1;
#     blosum["D/H"]=-1; blosum["D/I"]=-3; blosum["D/L"]=-4; blosum["D/K"]=-1; blosum["D/M"]=-3;
#     blosum["D/F"]=-3; blosum["D/P"]=-1; blosum["D/S"]=0;  blosum["D/T"]=-1; blosum["D/W"]=-4;
#     blosum["D/Y"]=-3; blosum["D/V"]=-3;

#     blosum["C/C"]=9;  blosum["C/Q"]=-3; blosum["C/E"]=-4; blosum["C/G"]=-3; blosum["C/H"]=-3;
#     blosum["C/I"]=-1; blosum["C/L"]=-1; blosum["C/K"]=-3; blosum["C/M"]=-1; blosum["C/F"]=-2;
#     blosum["C/P"]=-3; blosum["C/S"]=-1; blosum["C/T"]=-1; blosum["C/W"]=-2; blosum["C/Y"]=-2;
#     blosum["C/V"]=-1;

#     blosum["Q/Q"]=5;  blosum["Q/E"]=2;  blosum["Q/G"]=-2; blosum["Q/H"]=0;  blosum["Q/I"]=-3;
#     blosum["Q/L"]=-2; blosum["Q/K"]=1;  blosum["Q/M"]=0;  blosum["Q/F"]=-3; blosum["Q/P"]=-1;
#     blosum["Q/S"]=0;  blosum["Q/T"]=-1; blosum["Q/W"]=-2; blosum["Q/Y"]=-1; blosum["Q/V"]=-2;

#     blosum["E/E"]=5;  blosum["E/G"]=-2; blosum["E/H"]=0;  blosum["E/I"]=-3; blosum["E/L"]=-3;
#     blosum["E/K"]=1;  blosum["E/M"]=-2; blosum["E/F"]=-3; blosum["E/P"]=-1; blosum["E/S"]=0;
#     blosum["E/T"]=-1; blosum["E/W"]=-3; blosum["E/Y"]=-2; blosum["E/V"]=-2;

#     blosum["G/G"]=6;  blosum["G/H"]=-2; blosum["G/I"]=-4; blosum["G/L"]=-4; blosum["G/K"]=-2;
#     blosum["G/M"]=-3; blosum["G/F"]=-3; blosum["G/P"]=-2; blosum["G/S"]=0;  blosum["G/T"]=-2;
#     blosum["G/W"]=-2; blosum["G/Y"]=-3; blosum["G/V"]=-3;

#     blosum["H/H"]=8;  blosum["H/I"]=-3; blosum["H/L"]=-3; blosum["H/K"]=-1; blosum["H/M"]=-2;
#     blosum["H/F"]=-1; blosum["H/P"]=-2; blosum["H/S"]=-1; blosum["H/T"]=-2; blosum["H/W"]=-2;
#     blosum["H/Y"]=2;  blosum["H/V"]=-3;

#     blosum["I/I"]=4;  blosum["I/L"]=2;  blosum["I/K"]=-3; blosum["I/M"]=1;  blosum["I/F"]=0;
#     blosum["I/P"]=-3; blosum["I/S"]=-2; blosum["I/T"]=-1; blosum["I/W"]=-3; blosum["I/Y"]=-1;
#     blosum["I/V"]=3;

#     blosum["L/L"]=4;  blosum["L/K"]=-2; blosum["L/M"]=2;  blosum["L/F"]=0;  blosum["L/P"]=-3;
#     blosum["L/S"]=-2; blosum["L/T"]=-1; blosum["L/W"]=-2; blosum["L/Y"]=-1; blosum["L/V"]=1;

#     blosum["K/K"]=5;  blosum["K/M"]=-1; blosum["K/F"]=-3; blosum["K/P"]=-1; blosum["K/S"]=0;
#     blosum["K/T"]=-1; blosum["K/W"]=-3; blosum["K/Y"]=-2; blosum["K/V"]=-2;

#     blosum["M/M"]=5;  blosum["M/F"]=0;  blosum["M/P"]=-2; blosum["M/S"]=-1; blosum["M/T"]=-1;
#     blosum["M/W"]=-1; blosum["M/Y"]=-1; blosum["M/V"]=1;

#     blosum["F/F"]=6;  blosum["F/P"]=-4; blosum["F/S"]=-2; blosum["F/T"]=-2; blosum["F/W"]=1;
#     blosum["F/Y"]=3;  blosum["F/V"]=-1;

#     blosum["P/P"]=7;  blosum["P/S"]=-1; blosum["P/T"]=-1; blosum["P/W"]=-4; blosum["P/Y"]=-3;
#     blosum["P/V"]=-2;

#     blosum["S/S"]=4;  blosum["S/T"]=1;  blosum["S/W"]=-3; blosum["S/Y"]=-2; blosum["S/V"]=-2;

#     blosum["T/T"]=5;  blosum["T/W"]=-2; blosum["T/Y"]=-2; blosum["T/V"]=0;

#     blosum["W/W"]=11; blosum["W/Y"]=2;  blosum["W/V"]=-3;

#     blosum["Y/Y"]=7;  blosum["Y/V"]=-1;

#     blosum["V/V"]=4;
# }
# {

#     if ($6 ~ /nonsynonymous_SNV/) {
        
#         # Extract amino acid substitution from column 7: e.g.  p.E161V
#         match($7, /^p\.([A-Z])[0-9]+([A-Z])$/, aa)
#         ref = aa[1]
#         alt = aa[2]

#         key = ref "/" alt
#         rev_key = alt "/" ref # BLOSUM62 matrix is symmetrical

#         if (key in blosum)
#             print $0, blosum[key]
#         else if (rev_key in blosum)
#             print $0, blosum[rev_key]
#         else
#             print $0, "NO_BLOSUM_SCORE"
#     } else {
#         print $0, "N/A"
#     }
# }
# ' $output_dir/ANNOVAR_${1}_WBGeneID_GRANTHAM_test.tsv > $output_dir/ANNOVAR_${1}_WBGeneID_GRANTHAM_BLOSUM_test.tsv 





# Look to see if numbers added via using an associative array are the same made by VEP and BCSQ


#### ADDING PERCENT PROTEIN #### 

#CSQ 
## Should add a header with columns in the desired order and comma-separated
# echo "chrom,pos,ref,alt,consequence,AA,DNAchange,grantham,strain,divergent,PP,transcript_name,wbgene,grantham_score,blosum_score,percent_protein" > $output_dir/CSQ_${1}_WBGeneID_GRANTHAM_BLOSUM_PP_test.csv

# while IFS=$'\t' read -r chrom pos ref alt consequence AA DNAchange grantham strain divergent PP transcript_name wbgene grantham_score blosum_score; do  ##will need to change

#     pp="N/A"

#     if [[ $consequence =~ missense|frameshift|stop|deletion|synonymous ]]; then

#         cds_temp=$(mktemp)

#         awk -v transcript=$transcript_name '$3 == "CDS" && $9 ~ transcript {print $1, $4, $5, $7}' OFS='\t' $gff > $cds_temp

#         CDS_total_len=$(awk '{sum += ($3 - $2 + 1)} END {print sum}' $cds_temp)

#         strand=$(awk 'NR==1 {print $4}' $cds_temp)

#         found=0
#         cum_len=0

#         if [[ $strand == "-" ]]; then
#             while read -r chr start end strand; do
#                 cds_segment=$(( end - start + 1 ))
#                 if (( pos >= start && pos <= end )); then
#                     nucl_number=$(( cum_len + (end - pos + 1) ))
#                     found=1
#                     break
#                 fi
#                 cum_len=$(( cum_len + cds_segment ))
#             done < <(sort -k2,2nr $cds_temp)
#         else
#             while read -r chr start end strand; do
#                 cds_segment=$(( end - start + 1 ))
#                 if (( pos >= start && pos <= end )); then
#                     nucl_number=$(( cum_len + (pos - start + 1) ))
#                     found=1
#                     break
#                 fi
#                 cum_len=$(( cum_len + cds_segment ))
#             done < <(sort -k2,2n $cds_temp)
#         fi

#         if (( found )) && (( CDS_total_len > 0 )); then
#             pp=$(awk -v r=$nucl_number -v t=$CDS_total_len 'BEGIN { printf "%.2f", (r / t * 100) }')
#         fi

#         echo "[DEBUG] $transcript_name pos=$pos nucl_number=$nucl_number CDS_total_len=$CDS_total_len pp=$pp" >> $output_dir/CSQ_debug_percent_protein.tsv

#         [[ -f $cds_temp ]] && rm $cds_temp
#     fi

#     echo "$chrom,$pos,$ref,$alt,$consequence,$AA,$DNAchange,$grantham,$strain,$divergent,$PP,$transcript_name,$wbgene,$grantham_score,$blosum_score,$pp" >> $output_dir/CSQ_${1}_WBGeneID_GRANTHAM_BLOSUM_PP_test.csv

# done < $output_dir/CSQ_${1}_WBGeneID_GRANTHAM_BLOSUM_test.tsv



# VEP
# echo "chrom,pos,ref,alt,consequence,impact,AA,blosum,strains,divergent,transcript_name,wbgene,grantham_score,blosum_score,percent_protein" > $output_dir/VEP_${1}_WBGeneID_GRANTHAM_BLOSUM_PP_test.csv

# while IFS=$'\t' read -r chrom pos ref alt consequence impact AA blosum strain divergent transcript_name wbgene grantham_score blosum_score; do  ##will need to change

#     pp="N/A"

#     if [[ $consequence =~ missense|frameshift|stop|deletion|synonymous ]]; then

#         cds_temp=$(mktemp)

#         awk -v transcript=$transcript_name '$3 == "CDS" && $9 ~ transcript {print $1, $4, $5, $7}' OFS='\t' $gff > $cds_temp

#         CDS_total_len=$(awk '{sum += ($3 - $2 + 1)} END {print sum}' $cds_temp)

#         strand=$(awk 'NR==1 {print $4}' $cds_temp)

#         found=0
#         cum_len=0

#         if [[ $strand == "-" ]]; then
#             while read -r chr start end strand; do
#                 cds_segment=$(( end - start + 1 ))
#                 if (( pos >= start && pos <= end )); then
#                     nucl_number=$(( cum_len + (end - pos + 1) ))
#                     found=1
#                     break
#                 fi
#                 cum_len=$(( cum_len + cds_segment ))
#             done < <(sort -k2,2nr $cds_temp)
#         else
#             while read -r chr start end strand; do
#                 cds_segment=$(( end - start + 1 ))
#                 if (( pos >= start && pos <= end )); then
#                     nucl_number=$(( cum_len + (pos - start + 1) ))
#                     found=1
#                     break
#                 fi
#                 cum_len=$(( cum_len + cds_segment ))
#             done < <(sort -k2,2n $cds_temp)
#         fi

#         if (( found )) && (( CDS_total_len > 0 )); then
#             pp=$(awk -v r=$nucl_number -v t=$CDS_total_len 'BEGIN { printf "%.2f", (r / t * 100) }')
#         fi

#         echo "[DEBUG] $transcript_name pos=$pos nucl_number=$nucl_number CDS_total_len=$CDS_total_len pp=$pp" >> $output_dir/debug_percent_protein.tsv

#         [[ -f $cds_temp ]] && rm $cds_temp
#     fi

#     echo "$chrom,$pos,$ref,$alt,$consequence,$impact,$AA,$blosum,$strain,$divergent,$transcript_name,$wbgene,$grantham_score,$blosum_score,$pp" >> $output_dir/VEP_${1}_WBGeneID_GRANTHAM_BLOSUM_PP_test.csv

# done < $output_dir/VEP_${1}_WBGeneID_GRANTHAM_BLOSUM_test.tsv


# # ANNOVAR
# echo "chrom,pos,ref,alt,consequence,impact,AA_change,strains,divergent,transcript_name,wbgene,grantham_score,blosum_score,percent_protein" > $output_dir/ANNOVAR_${1}_WBGeneID_GRANTHAM_BLOSUM_PP_test.csv

# while IFS=$'\t' read -r chrom pos ref alt consequence impact AA strain divergent transcript_name wbgene grantham_score blosum_score; do  ##will need to change

#     pp="N/A"

#     if [[ $consequence =~ missense|frameshift|stop|deletion|synonymous ]]; then

#         cds_temp=$(mktemp)

#         awk -v transcript=$transcript_name '$3 == "CDS" && $9 ~ transcript {print $1, $4, $5, $7}' OFS='\t' $gff > $cds_temp

#         CDS_total_len=$(awk '{sum += ($3 - $2 + 1)} END {print sum}' $cds_temp)

#         strand=$(awk 'NR==1 {print $4}' $cds_temp)

#         found=0
#         cum_len=0

#         if [[ $strand == "-" ]]; then
#             while read -r chr start end strand; do
#                 cds_segment=$(( end - start + 1 ))
#                 if (( pos >= start && pos <= end )); then
#                     nucl_number=$(( cum_len + (end - pos + 1) ))
#                     found=1
#                     break
#                 fi
#                 cum_len=$(( cum_len + cds_segment ))
#             done < <(sort -k2,2nr $cds_temp)
#         else
#             while read -r chr start end strand; do
#                 cds_segment=$(( end - start + 1 ))
#                 if (( pos >= start && pos <= end )); then
#                     nucl_number=$(( cum_len + (pos - start + 1) ))
#                     found=1
#                     break
#                 fi
#                 cum_len=$(( cum_len + cds_segment ))
#             done < <(sort -k2,2n $cds_temp)
#         fi

#         if (( found )) && (( CDS_total_len > 0 )); then
#             pp=$(awk -v r=$nucl_number -v t=$CDS_total_len 'BEGIN { printf "%.2f", (r / t * 100) }')
#         fi

#         echo "[DEBUG] $transcript_name pos=$pos nucl_number=$nucl_number CDS_total_len=$CDS_total_len pp=$pp" >> $output_dir/ANNOVAR_debug_percent_protein.tsv

#         [[ -f $cds_temp ]] && rm $cds_temp
#     fi

#     echo "$chrom,$pos,$ref,$alt,$consequence,$impact,$AA,$strain,$divergent,$transcript_name,$wbgene,$grantham_score,$blosum_score,$pp" >> $output_dir/ANNOVAR_${1}_WBGeneID_GRANTHAM_BLOSUM_PP_test.csv

# done < $output_dir/ANNOVAR_${1}_WBGeneID_GRANTHAM_BLOSUM_test.tsv