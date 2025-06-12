#!/bin/bash

#SBATCH -J Ce_SnpEff_fix
#SBATCH -A eande106
#SBATCH -p parallel
#SBATCH -t 48:00:00
#SBATCH -N 1
#SBATCH -c 36
#SBATCH --output=/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/SLURM_output/SnpEff_fix.oe  
#SBATCH --error=/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/SLURM_output/SnpEff_fix.rr 

if [[ $1 == "c_elegans" ]]; then
    VEP_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/VEP/c_elegans/containerRun/WI.20250331.hard-filter.isotype.biallelic.NoMt.HDR.VEP.vcf.gz"
    CSQ_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/CSQ/c_elegans/containerRun/WI.20250331.hard-filter.isotype.biallelic.NoMt.HDR.bcsq.vcf.gz"
    SnpEff_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/SnpEff/c_elegans/containerRun/WI.20250331.hard-filter.isotype.biallelic.onlyMt.snpeff.vcf.gz"
    SnpEff_preAnnoVCF="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/WI.20250331.hard-filter.isotype.biallelic.onlyMt.vcf.gz"
    ANNOVAR_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/ANNOVAR/c_elegans/containerRun/c_elegans.biallelic.NoMt.HDR.ANNOVAR.PRJNA13758.WS283_multianno.vcf"
    # SIFT_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/SIFT/c_elegans/nematode_db_run/WI.20250331.hard-filter.isotype.biallelic.NoMt.HDR_SIFTpredictions.final.vcf.gz"
    output_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/HDRres_merging"
elif [[ $1 == "c_tropicalis" ]]; then
    VEP_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/VEP/c_tropicalis/containerRun/WI.20250331.hard-filter.isotype.biallelic.NoMt.HDR.VEP.vcf.gz"
    CSQ_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/CSQ/c_tropicalis/containerRun/WI.20250331.hard-filter.isotype.biallelic.NoMt.HDR.bcsq.vcf.gz"
    SnpEff_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/SnpEff/c_tropicalis/containerRun/WI.20250331.hard-filter.isotype.biallelic.onlyMt.snpeff.vcf.gz"
    SnpEff_preAnnoVCF="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/WI.20250331.hard-filter.isotype.biallelic.onlyMt.vcf.gz"
    ANNOVAR_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/ANNOVAR/c_tropicalis/containerRun/c_tropicalis.biallelic.NoMt.HDR.ANNOVAR.NIC58_nanopore.June2021_multianno.vcf"
    # SIFT_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/SIFT/c_tropicalis/XXXXX"
    output_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/HDRres_merging"
elif [[ $1 == "c_briggsae" ]]; then
    VEP_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/VEP/c_briggsae/containerRun/WI.20250331.hard-filter.isotype.biallelic.NoMt.VEP.vcf.gz"
    CSQ_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/CSQ/c_briggsae/containerRun/WI.20250331.hard-filter.isotype.biallelic.NoMt.bcsq.vcf.gz"
    SnpEff_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/SnpEff/c_briggsae/containerRun/WI.20250331.hard-filter.isotype.biallelic.onlyMt.snpeff.vcf.gz"
    SnpEff_preAnnoVCF="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/WI.20250331.hard-filter.isotype.biallelic.onlyMt.vcf.gz"
    ANNOVAR_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/ANNOVAR/c_briggsae/containerRun/c_briggsae.biallelic.NoMt.HDR.ANNOVAR.QX1410_nanopore.Feb2020_multianno.vcf"
    # SIFT_annotated_vcf="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/SIFT/c_briggsae//XXXXX"
    output_dir="/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/HDRres_merging"
else
    echo "Unsupported organism: $1"
    exit 1
fi


### UNIT TEST TO COMPARE CHROM, POS, ALT, REF, AND GENOTYPE MATRIX FOR EVERY ANNOTATED VCF PRIOR TO TSV CREATION
# VEPcheck=$(mktemp)
# CSQcheck=$(mktemp)
# ANVcheck=$(mktemp)

# bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%SAMPLE=%GT:%HDR]\n' $VEP_annotated_vcf > $VEPcheck
# bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%SAMPLE=%GT:%HDR]\n' $CSQ_annotated_vcf > $CSQcheck
# bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%SAMPLE=%GT:%HDR]\n' $ANNOVAR_annotated_vcf > $ANVcheck

# # No HDR for briggsae
# # bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%SAMPLE=%GT]\n' $VEP_annotated_vcf > $VEPcheck
# # bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%SAMPLE=%GT]\n' $CSQ_annotated_vcf > $CSQcheck
# # bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%SAMPLE=%GT]\n' $ANNOVAR_annotated_vcf > $ANVcheck

# # Store VCF names in an array for easier comparison
# declare -A VCF_key
# VCF_key["$VEPcheck"]="VEP"
# VCF_key["$CSQcheck"]="CSQ"
# VCF_key["$ANVcheck"]="ANNOVAR"

# # Define an array of the generated files
# VCF_FILES=($VEPcheck $CSQcheck $ANVcheck)

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

# rm $VEPcheck $CSQcheck $ANVcheck

# # Exit if differences found
# if [[ $difference -eq 1 ]]; then
#     echo "ERROR: VCF files have differences. Exiting..."
#     exit 1
# else
#     echo "All VCFs match. Proceeding with analysis."
#     rm $output_dir/*_difference.txt
# fi


######################################################## For briggsae ############################################################################################################################################################################################################################################################################################################################################################################################################################################################################################
# CSQ
# BCSQ=missense|WBGene00022277|Y74C9A.3.1|protein_coding|-|226P>226L|4249G>A
# BCSQ=@1799727,synonymous|WBGene00022145|Y71G12B.5a.1|protein_coding|+|437T|1802558C>T
# BCSQ=*synonymous|WBGene00022145|Y71G12B.5a.1|protein_coding|+|400S|1801988C>T,@1799727,@1799884,@1801478,@1801900,synonymous|WBGene00022145|Y71G12B.5a.1|protein_coding|+|437T|1802558C>T
# BCSQ=synonymous|WBGene00001542|W03F11.2a.1|protein_coding|-|712V|2226063T>C,@2226065,synonymous|WBGene00001542|W03F11.2b.1|protein_coding|-|709V|2226063T>C
# synonymous|WBGene00022279|Y74C9A.5.1|protein_coding|-|425L|29124C>G,synonymous|WBGene00022279|Y74C9A.5.2|protein_coding|-|425L|29124C>G

# if [[ ! -f  "$output_dir/CSQ_flatFile_$1.tsv" ]]; then 
#     bcftools query \
#         -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/BCSQ[\t%SAMPLE=%GT]\n' \
#         "$CSQ_annotated_vcf" | \
#     awk -F'\t' '{
#         ALT_samples = "";  
#         for (i = 6; i <= NF; i++) { 
#             if ($i ~ /0\/1|1\/0|1\/1/) { 
#                 sub(/=.*/, "", $i);  
#                 ALT_samples = ALT_samples (ALT_samples ? " " : "") $i; 
#             }
#         }

#         if (ALT_samples != "") {  
#             # Grantham_score = ($5 != "." && $5 != "" ? $5 : "N/A");  # Default from column 5
            
#             if ($5 != ".") {
#                 split($5, csq_entries, ",");  # Split multiple annotations by ","

#                 for (j in csq_entries) {
#                     split(csq_entries[j], csq, "|");  # Extract annotation components
                    
#                     # temp_Grantham = Grantham_score;  # Default to original score

#                     if (csq[1] ~ /^@/) {
#                         CSQ_consequence = csq[1];  
#                         CSQ_AA_change = csq[1]; 
#                         DNA_change = csq[1];
#                         # temp_Grantham = csq[1];  # Override only for this row
#                         transcript = csq[1];  
#                     } else {
#                         CSQ_consequence = (csq[1] != "" ? csq[1] : "N/A");
#                         CSQ_AA_change = (csq[6] != "" ? csq[6] : "N/A");
#                         DNA_change = (csq[7] != "" ? csq[7] : "N/A");
#                         transcript = (csq[3] != "" ? csq[3] : "N/A");
#                     }

#                     print $1"\t"$2"\t"$3"\t"$4"\t"CSQ_consequence"\t"CSQ_AA_change"\t"DNA_change"\t"ALT_samples"\t"transcript;
#                 }
#             } else {
#                 print $1"\t"$2"\t"$3"\t"$4"\tN/A\tN/A\tN/A\t"ALT_samples"\tN/A";
#             }
#         }
#     }' >> "$output_dir/CSQ_flatFile_$1.tsv"
# else 
#     "CSQ briggsae flat file already exists."
# fi



# # VEP 
# # VEP=A|missense_variant|MODERATE|WBGene00022277|WBGene00022277|Transcript|Y74C9A.3.1|protein_coding|5/5||||759|677|226|P/L|cCt/cTt|||-1||||c_elegans.PRJNA13758.WS283.csq_VEPsorted.gff3.gz|-3|
# # I	344	A|downstream_gene_variant|MODIFIER|WBGene00022277|WBGene00022277|Transcript|Y74C9A.3.1|protein_coding|||||||||||3772|-1||||c_elegans.PRJNA13758.WS283.csq_VEPsorted.gff3.gz||,A|downstream_gene_variant|MODIFIER|WBGene00023193|WBGene00023193|Transcript|Y74C9A.6|snoRNA|||||||||||3403|-1||||c_elegans.PRJNA13758.WS283.csq_VEPsorted.gff3.gz||
 
# if [[ ! -f  "$output_dir/VEP_flatFile_$1.tsv" ]]; then 
#     bcftools query \
#         -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/CSQ[\t%SAMPLE=%GT]\n' \
#         "$VEP_annotated_vcf" | \
#     awk -F'\t' '{
#         ALT_samples = "";  
#         for (i = 6; i <= NF; i++) {  
#             if ($i ~ /0\/1|1\/0|1\/1/) { 
#                 sub(/=.*/, "", $i);  
#                 ALT_samples = ALT_samples (ALT_samples ? " " : "") $i; 
#             }
#         }
#         if (ALT_samples != "") {
#             if ($5 != ".") {
#                 split($5, annotations, ",");
#                 for (j in annotations) {
#                     split(annotations[j], vep, "|");  #split VEP annotation by pipe
#                     VEP_consequence = vep[2];  
#                     VEP_impact = vep[3];  
#                     VEP_AA_change = (vep[16] != "" ? vep[16] : "N/A");
#                     transcript = (vep[7] != "" ? vep[7] : "N/A");
#                     if (VEP_consequence == "intergenic_variant") {
#                         transcript = "N/A";
#                     } 
#                     # blosum62score = (vep[25] != "" ? vep[25] : "N/A");
#                     print $1"\t"$2"\t"$3"\t"$4"\t"VEP_consequence"\t"VEP_impact"\t"VEP_AA_change"\t"ALT_samples"\t"transcript; 
#                 }
#             } else {
#                 print $1"\t"$2"\t"$3"\t"$4"\tN/A\tN/A\tN/A\t"ALT_samples"\tN/A";
#             }
#         }
#     }' >> "$output_dir/VEP_flatFile_$1.tsv"
# else 
#     "VEP briggsae flat file already exists."
# fi


# # ANNOVAR 
# # ANNOVAR_DATE=2020-06-08;Func.refGene=exonic;Gene.refGene=gene:WBGene00022277;GeneDetail.refGene=.;ExonicFunc.refGene=nonsynonymous_SNV;AAChange.refGene=gene:WBGene00022277
# # ANNOVAR_DATE=2020-06-08;ExonicFunc.refGene=synonymous_SNV;AAChange.refGene=gene:WBGene00021355:transcript:Y37E3.17d.1:exon3:c.G321A:p.L107L,gene:WBGene00021355:transcript:Y37E3.17a.1:exon2:c.G300A:p.L100L,gene:WBGene00021355
# # I	29304	T	A	AC=4;AF=0.00327332;AN=1222;AS_BaseQRankSum=.;AS_FS=0;AS_InbreedingCoeff=0.8388;AS_MQ=60;AS_MQRankSum=.;AS_QD=26.97;AS_ReadPosRankSum=.;AS_SOR=0.757;DP=57077;ExcessHet=-0;FS=0;InbreedingCoeff=0.8388;MLEAC=12;MLEAF=0.003676;MQ=60;NS=611;QD=26.97;SOR=0.757;ANNOVAR_DATE=2020-06-08;Func.refGene=exonic;Gene.refGene=gene:WBGene00022279;GeneDetail.refGene=.;ExonicFunc.refGene=nonsynonymous_SNV;AAChange.refGene=gene:WBGene00022279:transcript:Y74C9A.5.2:exon5:c.A1095T:p.E365D,gene:WBGene00022279:transcript:Y74C9A.5.1:exon4:c.A1095T:p.E365D;ALLELE_END

# if [[ ! -f  "$output_dir/ANV_flatFile_$1.tsv" ]]; then 
#     bcftools query \
#         -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO[\t%SAMPLE=%GT]\n' \
#         "$ANNOVAR_annotated_vcf" | \
#     awk -F'\t' '{
#         ALT_samples = "";  
#         for (i = 6; i <= NF; i++) {  
#             if ($i ~ /0\/1|1\/0|1\/1/) {  
#                 sub(/=.*/, "", $i); 
#                 ALT_samples = ALT_samples (ALT_samples ? " " : "") $i; 
#             }
#         }
#         split($5, anv, ";"); 
#         if (ALT_samples != "") {
#             ANV_consequence = "N/A";  
#             ANV_impact = "N/A";       
#             ANV_AA_change = "N/A"; 
#             transcript = "N/A";  # Initialize transcript as N/A

#             for (field in anv) {
#                 split(anv[field], fields, "=");  # Split each ANV field by "=" to separate the tag from its value
                
#                 if (fields[1] == "Func.refGene") ANV_consequence = fields[2];
#                 else if (fields[1] == "ExonicFunc.refGene") ANV_impact = (fields[2] == "." ? "N/A" : fields[2]);
#                 else if (fields[1] == "AAChange.refGene") {
#                     split(fields[2], transcripts, ",");  # Split by commas if there are multiple annotations
#                     for (j in transcripts) {
#                         split(transcripts[j], AA_change_parts, ":");  # Split the AAChange.refGene value by colon
#                         ANV_AA_change = (AA_change_parts[7] != "" ? AA_change_parts[7] : "N/A");  # Get amino acid change
#                         transcript = (AA_change_parts[4] != "" ? AA_change_parts[4] : "N/A");  # Get transcript
                        
#                         print $1"\t"$2"\t"$3"\t"$4"\t"ANV_consequence"\t"ANV_impact"\t"ANV_AA_change"\t"ALT_samples"\t"transcript; 
#                     }
#                 }
#             }
#         }
#     }' >> "$output_dir/ANV_flatFile_$1.tsv"
# else 
#     "ANNOVAR briggsae flat file already exists."
# fi

# # SnpEff
# # MtDNA	11316	78	A|missense_variant|MODERATE|transcript:MTCE.33|null.20849|transcript|transcript:MTCE.33|pseudogene|1/1|n.914C>A|p.Thr305Lys|914/952|914/-1|305/-1||WARNING_TRANSCRIPT_MULTIPLE_STOP_CODONS,A|upstream_gene_variant|MODIFIER|transcript:MTCE.36|null.20850|transcript|transcript:MTCE.36|pseudogene||n.-1959C>A|||||1959|WARNING_TRANSCRIPT_MULTIPLE_STOP_CODONS,A|....


# if [[ ! -f  "$output_dir/SnpEff_flatFile_$1.tsv" ]]; then 

#     before="$output_dir/before_genotypes.tsv"s
#     after="$output_dir/after_genotypes.tsv"

#     bcftools query -f '[%CHROM\t%POS\t%SAMPLE=%GT]\n' $SnpEff_preAnnoVCF > $before
#     bcftools query -f '[%CHROM\t%POS\t%SAMPLE=%GT]\n' $SnpEff_annotated_vcf > $after

#     if cmp -s $before $after; then
#         # echo -e 'Chromosome,Position,REF,ALT,SnpEff_consequence,SnpEff_impact,SnpEff_AA_change,Grantham Score,Strains,Transcript' > $output_dir/finalMerge/SnpEff_flatFile_$1.csv

#         bcftools query \
#             -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/ANN[\t%SAMPLE=%GT]\n' \
#             $SnpEff_annotated_vcf | \
#         awk -F'\t' '{
#             ALT_samples = "";  # Initialize string to collect samples with alt allele
#             for (i = 6; i <= NF; i++) {  # Loop through fields containing sample=genotype
#                 if ($i ~ /0\/1|1\/0|1\/1/) {  # Check if sample has alt allele
#                     sub(/=.*/, "", $i);  # Remove genotype - leaving only sample name
#                     ALT_samples = ALT_samples (ALT_samples ? " " : "") $i;  # Append sample name
#                 }
#             }

#             if (ALT_samples != "") { 
#                 split($5, annotations, ",");  # Split multiple annotations into array
#                 for (j in annotations) {
#                     split(annotations[j], snpEff, "|");  # Split each annotation by pipe

#                     SnpEff_consequence = snpEff[2];
#                     SnpEff_impact = snpEff[3];
#                     SnpEff_AA_change = (snpEff[11] != "" ? snpEff[11] : "N/A");
#                     transcript = (snpEff[4] != "" ? snpEff[4] : "N/A");
#                     gsub(/transcript:/, "", transcript);  # Remove "transcript." from the transcript string
#                     if (SnpEff_consequence == "intergenic_region") {
#                         transcript = "N/A";
#                     }

#                     # # Only assign GRANTHAM_score for missense_variant or frameshift_variant
#                     # if (SnpEff_consequence == "missense_variant" || SnpEff_consequence == "frameshift_variant") {
#                     #     GRANTHAM_score = ($5 != "." ? $5 : "N/A");
#                     # } else {
#                     #     GRANTHAM_score = "N/A";  
#                     # }

#                     print $1"\t"$2"\t"$3"\t"$4"\t"SnpEff_consequence"\t"SnpEff_impact"\t"SnpEff_AA_change"\t"ALT_samples"\t"transcript; 
#                 }
#             }
#         }' >> $output_dir/SnpEff_flatFile_$1.tsv
#     else
#         echo "there are differences in mitochondrial genotype matrix"
#     fi

#     rm $before $after
# else 
#     "SnpEff briggsae flat file already exists."
# fi


############################################################################################################################################################################################################################################################################################################################################################################################################################################################################################







































######################################################## For elegans and tropicalis ###########################################################################################################################################################################################################################################################################################################################################################################################################################################################################################
# CSQ
# BCSQ=missense|WBGene00022277|Y74C9A.3.1|protein_coding|-|226P>226L|4249G>A
# BCSQ=@1799727,synonymous|WBGene00022145|Y71G12B.5a.1|protein_coding|+|437T|1802558C>T
# BCSQ=*synonymous|WBGene00022145|Y71G12B.5a.1|protein_coding|+|400S|1801988C>T,@1799727,@1799884,@1801478,@1801900,synonymous|WBGene00022145|Y71G12B.5a.1|protein_coding|+|437T|1802558C>T
# BCSQ=synonymous|WBGene00001542|W03F11.2a.1|protein_coding|-|712V|2226063T>C,@2226065,synonymous|WBGene00001542|W03F11.2b.1|protein_coding|-|709V|2226063T>C
# synonymous|WBGene00022279|Y74C9A.5.1|protein_coding|-|425L|29124C>G,synonymous|WBGene00022279|Y74C9A.5.2|protein_coding|-|425L|29124C>G

# # non-HDR variants
# if [[ ! -f  "$output_dir/CSQ_flatFile_nonHDR_$1.tsv" ]]; then 
#     bcftools query \
#         -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/BCSQ[\t%SAMPLE=%GT:%HDR]\n' -i 'HDR=0' \
#         "$CSQ_annotated_vcf" | \
#     awk -F'\t' '{
#         ALT_samples = "";  
#         for (i = 6; i <= NF; i++) { 
#             if ($i ~ /0\/1|1\/0|1\/1/) { 
#                 sub(/=.*/, "", $i);  
#                 ALT_samples = ALT_samples (ALT_samples ? " " : "") $i; 
#             }
#         }

#         if (ALT_samples != "") {  
#         # Grantham_score = ($5 != "." && $5 != "" ? $5 : "N/A");  # Default from column 5
            
#             if ($5 != ".") {
#                 split($5, csq_entries, ",");  # Split multiple annotations by ","

#                 for (j in csq_entries) {
#                     split(csq_entries[j], csq, "|");  # Extract annotation components
                    
#                     # temp_Grantham = Grantham_score;  # Default to original score

#                     if (csq[1] ~ /^@/) {
#                         CSQ_consequence = csq[1];  
#                         CSQ_AA_change = csq[1]; 
#                         DNA_change = csq[1];
#                         # temp_Grantham = csq[1];  # Override only for this row
#                         transcript = csq[1];  
#                     } else {
#                         CSQ_consequence = (csq[1] != "" ? csq[1] : "N/A");
#                         CSQ_AA_change = (csq[6] != "" ? csq[6] : "N/A");
#                         DNA_change = (csq[7] != "" ? csq[7] : "N/A");
#                         transcript = (csq[3] != "" ? csq[3] : "N/A");
#                     }

#                     print $1"\t"$2"\t"$3"\t"$4"\t"CSQ_consequence"\t"CSQ_AA_change"\t"DNA_change"\t"ALT_samples"\tNO\t"transcript;
#                 }
#             } else {
#                 print $1"\t"$2"\t"$3"\t"$4"\tN/A\tN/A\tN/A\t"ALT_samples"\tNO\tN/A";
#             }
#         }
#     }' >> "$output_dir/CSQ_flatFile_nonHDR_$1.tsv"
# else 
#     "CSQ elegans/tropicalis nonHDR flat file already exists."
# fi


# # HDR variants
# if [[ ! -f  "$output_dir/CSQ_flatFile_HDR_$1.tsv" ]]; then 
#     bcftools query \
#         -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/BCSQ[\t%SAMPLE=%GT:%HDR]\n' -i 'HDR=1' \
#         "$CSQ_annotated_vcf" | \
#     awk -F'\t' '{
#         ALT_samples = "";  
#         for (i = 6; i <= NF; i++) {  
#             if ($i ~ /0\/1|1\/0|1\/1/) { 
#                 sub(/=.*/, "", $i);  
#                 ALT_samples = ALT_samples (ALT_samples ? " " : "") $i; 
#             }
#         }

#         if (ALT_samples != "") {  
#             Grantham_score = ($5 != "." && $5 != "" ? $5 : "N/A");  # Default from column 5
            
#             if ($5 != ".") {
#                 split($5, csq_entries, ",");  # Split multiple annotations by ","

#                 for (j in csq_entries) {
#                     split(csq_entries[j], csq, "|");  # Extract annotation components
                    
#                     # temp_Grantham = Grantham_score;  # Default to original score

#                     if (csq[1] ~ /^@/) {
#                         CSQ_consequence = csq[1];  
#                         CSQ_AA_change = csq[1]; 
#                         DNA_change = csq[1];
#                         # temp_Grantham = csq[1];  # Override only for this row
#                         transcript = csq[1];  
#                     } else {
#                         CSQ_consequence = (csq[1] != "" ? csq[1] : "N/A");
#                         CSQ_AA_change = (csq[6] != "" ? csq[6] : "N/A");
#                         DNA_change = (csq[7] != "" ? csq[7] : "N/A");
#                         transcript = (csq[3] != "" ? csq[3] : "N/A");
#                     }

#                     print $1"\t"$2"\t"$3"\t"$4"\t"CSQ_consequence"\t"CSQ_AA_change"\t"DNA_change"\t"ALT_samples"\tYES\t"transcript;
#                 }
#             } else {
#                 print $1"\t"$2"\t"$3"\t"$4"\tN/A\tN/A\tN/A\t"ALT_samples"\tYES\tN/A";
#             }
#         }
#     }' >> "$output_dir/CSQ_flatFile_HDR_$1.tsv"
# else 
#     "CSQ elegans/tropicalis HDR flat file already exists."
# fi


# # VEP 
# # VEP=A|missense_variant|MODERATE|WBGene00022277|WBGene00022277|Transcript|Y74C9A.3.1|protein_coding|5/5||||759|677|226|P/L|cCt/cTt|||-1||||c_elegans.PRJNA13758.WS283.csq_VEPsorted.gff3.gz|-3|
# # I	344	A|downstream_gene_variant|MODIFIER|WBGene00022277|WBGene00022277|Transcript|Y74C9A.3.1|protein_coding|||||||||||3772|-1||||c_elegans.PRJNA13758.WS283.csq_VEPsorted.gff3.gz||,A|downstream_gene_variant|MODIFIER|WBGene00023193|WBGene00023193|Transcript|Y74C9A.6|snoRNA|||||||||||3403|-1||||c_elegans.PRJNA13758.WS283.csq_VEPsorted.gff3.gz||
 
# non-HDR variants
# if [[ ! -f  "$output_dir/VEP_flatFile_nonHDR_$1.tsv" ]]; then 
#     bcftools query \
#         -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/CSQ[\t%SAMPLE=%GT:%HDR]\n' -i 'HDR=0' \
#         "$VEP_annotated_vcf" | \
#     awk -F'\t' '{
#         ALT_samples = "";  
#         for (i = 6; i <= NF; i++) {  
#             if ($i ~ /0\/1|1\/0|1\/1/) { 
#                 sub(/=.*/, "", $i);  
#                 ALT_samples = ALT_samples (ALT_samples ? " " : "") $i; 
#             }
#         }
#         if (ALT_samples != "") {
#             if ($5 != ".") {
#                 split($5, annotations, ",");
#                 for (j in annotations) {
#                     split(annotations[j], vep, "|");  #split VEP annotation by pipe
#                     VEP_consequence = vep[2];  
#                     VEP_impact = vep[3];  
#                     VEP_AA_change = (vep[16] != "" ? vep[16] : "N/A");
#                     transcript = (vep[7] != "" ? vep[7] : "N/A");
#                     if (VEP_consequence == "intergenic_variant") {
#                         transcript = "N/A";
#                     }
#                     # blosum62score = (vep[25] != "" ? vep[25] : "N/A");
#                     print $1"\t"$2"\t"$3"\t"$4"\t"VEP_consequence"\t"VEP_impact"\t"VEP_AA_change"\t"ALT_samples"\tNO\t"transcript; 
#                 }
#             } else {
#                 print $1"\t"$2"\t"$3"\t"$4"\tN/A\tN/A\tN/A\t"ALT_samples"\tNO\tN/A";
#             }
#         }
#     }' >> "$output_dir/VEP_flatFile_nonHDR_$1.tsv"
# else 
#     "VEP elegans/tropicalis nonHDR flat file already exists."
# fi


# # HDR variants
# if [[ ! -f  "$output_dir/VEP_flatFile_HDR_$1.tsv" ]]; then 
#     bcftools query \
#         -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/CSQ[\t%SAMPLE=%GT:%HDR]\n' -i 'HDR=1' \
#         "$VEP_annotated_vcf" | \
#     awk -F'\t' '{
#         ALT_samples = "";  
#         for (i = 6; i <= NF; i++) {  
#             if ($i ~ /0\/1|1\/0|1\/1/) { 
#                 sub(/=.*/, "", $i);  
#                 ALT_samples = ALT_samples (ALT_samples ? " " : "") $i; 
#             }
#         }
#         if (ALT_samples != "") {
#             if ($5 != ".") {
#                 split($5, annotations, ",");
#                 for (j in annotations) {
#                     split(annotations[j], vep, "|");  #split VEP annotation by pipe
#                     VEP_consequence = vep[2];  
#                     VEP_impact = vep[3];  
#                     VEP_AA_change = (vep[16] != "" ? vep[16] : "N/A");
#                     transcript = (vep[7] != "" ? vep[7] : "N/A");
#                     if (VEP_consequence == "intergenic_variant") {
#                         transcript = "N/A";
#                     } 
#                     # blosum62score = (vep[25] != "" ? vep[25] : "N/A");
#                     print $1"\t"$2"\t"$3"\t"$4"\t"VEP_consequence"\t"VEP_impact"\t"VEP_AA_change"\t"ALT_samples"\tYES\t"transcript; 
#                 }
#             } else {
#                 print $1"\t"$2"\t"$3"\t"$4"\tN/A\tN/A\tN/A\t"ALT_samples"\tYES\tN/A";
#             }
#         }
#     }' >> "$output_dir/VEP_flatFile_HDR_$1.tsv"
# else 
#     "VEP elegans/tropicalis HDR flat file already exists."
# fi


# # ANNOVAR 
# # ANNOVAR_DATE=2020-06-08;Func.refGene=exonic;Gene.refGene=gene:WBGene00022277;GeneDetail.refGene=.;ExonicFunc.refGene=nonsynonymous_SNV;AAChange.refGene=gene:WBGene00022277
# # ANNOVAR_DATE=2020-06-08;ExonicFunc.refGene=synonymous_SNV;AAChange.refGene=gene:WBGene00021355:transcript:Y37E3.17d.1:exon3:c.G321A:p.L107L,gene:WBGene00021355:transcript:Y37E3.17a.1:exon2:c.G300A:p.L100L,gene:WBGene00021355
# # I	29304	T	A	AC=4;AF=0.00327332;AN=1222;AS_BaseQRankSum=.;AS_FS=0;AS_InbreedingCoeff=0.8388;AS_MQ=60;AS_MQRankSum=.;AS_QD=26.97;AS_ReadPosRankSum=.;AS_SOR=0.757;DP=57077;ExcessHet=-0;FS=0;InbreedingCoeff=0.8388;MLEAC=12;MLEAF=0.003676;MQ=60;NS=611;QD=26.97;SOR=0.757;ANNOVAR_DATE=2020-06-08;Func.refGene=exonic;Gene.refGene=gene:WBGene00022279;GeneDetail.refGene=.;ExonicFunc.refGene=nonsynonymous_SNV;AAChange.refGene=gene:WBGene00022279:transcript:Y74C9A.5.2:exon5:c.A1095T:p.E365D,gene:WBGene00022279:transcript:Y74C9A.5.1:exon4:c.A1095T:p.E365D;ALLELE_END

# # non-HDR variants
# if [[ ! -f  "$output_dir/ANV_flatFile_nonHDR_$1.tsv" ]]; then 
#     bcftools query \
#         -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO[\t%SAMPLE=%GT:%HDR]\n' -i 'HDR=0' \
#         "$ANNOVAR_annotated_vcf" | \
#     awk -F'\t' '{
#         ALT_samples = "";  
#         for (i = 6; i <= NF; i++) {  
#             if ($i ~ /0\/1|1\/0|1\/1/) {  
#                 sub(/=.*/, "", $i); 
#                 ALT_samples = ALT_samples (ALT_samples ? " " : "") $i; 
#             }
#         }
#         split($5, anv, ";"); 
#         if (ALT_samples != "") {
#             ANV_consequence = "N/A";  
#             ANV_impact = "N/A";       
#             ANV_AA_change = "N/A"; 
#             transcript = "N/A";  # Initialize transcript as N/A
#             divergent = "NO";

#             for (field in anv) {
#                 split(anv[field], fields, "=");  # Split each ANV field by "=" to separate the tag from its value
                
#                 if (fields[1] == "Func.refGene") ANV_consequence = fields[2];
#                 else if (fields[1] == "ExonicFunc.refGene") ANV_impact = (fields[2] == "." ? "N/A" : fields[2]);
#                 else if (fields[1] == "AAChange.refGene") {
#                     split(fields[2], transcripts, ",");  # Split by commas if there are multiple annotations
#                     for (j in transcripts) {
#                         split(transcripts[j], AA_change_parts, ":");  # Split the AAChange.refGene value by colon
#                         ANV_AA_change = (AA_change_parts[7] != "" ? AA_change_parts[7] : "N/A");  # Get amino acid change
#                         transcript = (AA_change_parts[4] != "" ? AA_change_parts[4] : "N/A");  # Get transcript
                        
#                         print $1"\t"$2"\t"$3"\t"$4"\t"ANV_consequence"\t"ANV_impact"\t"ANV_AA_change"\t"ALT_samples"\t"divergent"\t"transcript; 
#                     }
#                 }
#             }
#         }
#     }' >> "$output_dir/ANV_flatFile_nonHDR_$1.tsv"
# else 
#     "ANNOVAR elegans/tropicalis nonHDR flat file already exists."
# fi

# # HDR variants
# # echo -e "CHROM\tPOS\tREF\tALT\tANV_consequence\tANV_impact\tANV_AA_change\tALL_SAMPLES_WITH_ALT\tTRANSCRIPT" > "$output_dir/ANV_flatFile_HDR_$1.tsv"

# if [[ ! -f  "$output_dir/ANV_flatFile_HDR_$1.tsv" ]]; then 
#     bcftools query \
#         -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO[\t%SAMPLE=%GT:%HDR]\n' -i 'HDR=1' \
#         "$ANNOVAR_annotated_vcf" | \
#     awk -F'\t' '{
#         ALT_samples = "";  
#         for (i = 6; i <= NF; i++) {  
#             if ($i ~ /0\/1|1\/0|1\/1/) {  
#                 sub(/=.*/, "", $i); 
#                 ALT_samples = ALT_samples (ALT_samples ? " " : "") $i; 
#             }
#         }
#         split($5, anv, ";"); 
#         if (ALT_samples != "") {
#             ANV_consequence = "N/A";  
#             ANV_impact = "N/A";       
#             ANV_AA_change = "N/A"; 
#             transcript = "N/A";  # Initialize transcript as N/A
#             divergent = "YES";

#             for (field in anv) {
#                 split(anv[field], fields, "=");  # Split each ANV field by "=" to separate the tag from its value
                
#                 if (fields[1] == "Func.refGene") ANV_consequence = fields[2];
#                 else if (fields[1] == "ExonicFunc.refGene") ANV_impact = (fields[2] == "." ? "N/A" : fields[2]);
#                 else if (fields[1] == "AAChange.refGene") {
#                     split(fields[2], transcripts, ",");  # Split by commas if there are multiple annotations
#                     for (j in transcripts) {
#                         split(transcripts[j], AA_change_parts, ":");  # Split the AAChange.refGene value by colon
#                         ANV_AA_change = (AA_change_parts[7] != "" ? AA_change_parts[7] : "N/A");  # Get amino acid change
#                         transcript = (AA_change_parts[4] != "" ? AA_change_parts[4] : "N/A");  # Get transcript
                        
#                         print $1"\t"$2"\t"$3"\t"$4"\t"ANV_consequence"\t"ANV_impact"\t"ANV_AA_change"\t"ALT_samples"\t"divergent"\t"transcript; 
#                     }
#                 }
#             }
#         }
#     }' >> $output_dir/ANV_flatFile_HDR_$1.tsv
# else 
#     "ANNOVAR elegans/tropicalis HDR flat file already exists."
# fi

# # SnpEff
# # MtDNA	11316	78	A|missense_variant|MODERATE|transcript:MTCE.33|null.20849|transcript|transcript:MTCE.33|pseudogene|1/1|n.914C>A|p.Thr305Lys|914/952|914/-1|305/-1||WARNING_TRANSCRIPT_MULTIPLE_STOP_CODONS,A|upstream_gene_variant|MODIFIER|transcript:MTCE.36|null.20850|transcript|transcript:MTCE.36|pseudogene||n.-1959C>A|||||1959|WARNING_TRANSCRIPT_MULTIPLE_STOP_CODONS,A|....

if [[ ! -f  "$output_dir/SnpEff_flatFile_$1.tsv" ]]; then 
    before="$output_dir/before_genotypes.tsv"s
    after="$output_dir/after_genotypes.tsv"

    bcftools query -f '[%CHROM\t%POS\t%SAMPLE=%GT]\n' $SnpEff_preAnnoVCF > $before
    bcftools query -f '[%CHROM\t%POS\t%SAMPLE=%GT]\n' $SnpEff_annotated_vcf > $after

    if cmp -s $before $after; then
        # echo -e 'Chromosome,Position,REF,ALT,SnpEff_consequence,SnpEff_impact,SnpEff_AA_change,Grantham Score,Strains,Transcript' > $output_dir/finalMerge/SnpEff_flatFile_$1.csv

        bcftools query \
            -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/ANN[\t%SAMPLE=%GT]\n' \
            $SnpEff_annotated_vcf | \
        awk -F'\t' '{
            ALT_samples = "";  # Initialize string to collect samples with alt allele
            for (i = 6; i <= NF; i++) {  # Loop through fields containing sample=genotype
                if ($i ~ /0\/1|1\/0|1\/1/) {  # Check if sample has alt allele
                    sub(/=.*/, "", $i);  # Remove genotype - leaving only sample name
                    ALT_samples = ALT_samples (ALT_samples ? " " : "") $i;  # Append sample name
                }
            }

            if (ALT_samples != "") { 
                split($5, annotations, ",");  # Split multiple annotations into array
                for (j in annotations) {
                    split(annotations[j], snpEff, "|");  # Split each annotation by pipe

                    SnpEff_consequence = snpEff[2];
                    SnpEff_impact = snpEff[3];
                    SnpEff_AA_change = (snpEff[11] != "" ? snpEff[11] : "N/A");
                    transcript = (snpEff[4] != "" ? snpEff[4] : "N/A");
                    gsub(/transcript:/, "", transcript); # Remove "transcript:" from the transcript string
                    if (SnpEff_consequence == "intergenic_region") {
                        transcript = "N/A";
                    }

                    # # Only assign GRANTHAM_score for missense_variant or frameshift_variant
                    # if (SnpEff_consequence == "missense_variant" || SnpEff_consequence == "frameshift_variant") {
                    #     GRANTHAM_score = ($5 != "." ? $5 : "N/A");
                    # } else {
                    #     GRANTHAM_score = "N/A";  
                    # }

                    print $1"\t"$2"\t"$3"\t"$4"\t"SnpEff_consequence"\t"SnpEff_impact"\t"SnpEff_AA_change"\t"ALT_samples"\t"transcript; 
                }
            }
        }' >> $output_dir/SnpEff_flatFile_$1.tsv
    else
        echo "there are differences in mitochondrial genotype matrix"
    fi

    rm $before $after
else 
    "SnpEff elegans/tropicalis flat file already exists."
fi

































# # # SIFT 
# # # SIFTINFO=A|transcript.Y74C9A.3.1|gene.WBGene00022277|NA|CDS|NONSYNONYMOUS|P/L|226|0.00|3.45|25|novel|DELETERIOUS
# # # I	17917	T|transcript.Y74C9A.4a.1|gene.WBGene00022278|NA|CDS|SYNONYMOUS|G/G|560|1.00|3.35|7|novel|TOLERATED,T|transcript.Y74C9A.4b.1|gene.WBGene00022278|NA|CDS|SYNONYMOUS|G/G|563|1.00|3.36|7|novel|TOLERATED,T|transcript.Y74C9A.4c.1|gene.WBGene00022278|NA|CDS|SYNONYMOUS|G/G|532|1.00|3.35|7|novel|TOLERATED,T|transcript.Y74C9A.4d.1|gene.WBGene00022278|NA|CDS|SYNONYMOUS|G/G|273|1.00|3.36|7|novel|TOLERATEDecho -e "CHROM\tPOS\tREF\tALT\tSIFT_consequence\tSIFT_score\tSIFT_impact\tSIFT_AA_change\tALL_SAMPLES_WITH_ALT\tTRANSCRIPT" > "$output_dir/SIFT_flatFile_nonHDR_$1.tsv" ### NEED TO ACCOUNT FOR THE FACT THAT SIFT ONLY ANNOTATES SOME VARIANTS AND OTHER ANNOTATIONS ARE "."
# # echo -e "CHROM\tPOS\tREF\tALT\tSIFT_consequence\tSIFT_score\tSIFT_impact\tSIFT_AA_change\tALL_SAMPLES_WITH_ALT\tTRANSCRIPT" > "$output_dir/SIFT_flatFile_nonHDR_$1.tsv"

# # # non-HDR variants
# # bcftools query \
# #     -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/SIFTINFO[\t%SAMPLE=%GT:%HDR]\n' -i 'HDR=0' \
# #     "$SIFT_annotated_vcf" | \
# # awk -F'\t' '{
# #     ALT_samples = "";  # Initialize string to collect samples with alt allele
# #     for (i = 6; i <= NF; i++) {  # Loop through fields containing sample=genotype
# #         if ($i ~ /0\/1|1\/0|1\/1/) {  # Check if sample has alt allele
# #             sub(/=.*/, "", $i);  # Remove genotype - leaving only sample name
# #             ALT_samples = ALT_samples (ALT_samples ? " " : "") $i;  # Append sample name
# #         }
# #     }

# #     if (ALT_samples != "") {
# #         if ($5 != ".") {
# #             split($5, annotations, ",");
# #             for (j in annotations) {
# #                 split(annotations[j], sift, "|");  # Split SIFTINFO field by pipe
# #                 SIFT_consequence = (sift[6] != "" ? sift[6] : "N/A");
# #                 SIFT_score = (sift[9] == "NA" ? "N/A" : (sift[9] != "" ? sift[9] : "N/A"));
# #                 SIFT_impact = (sift[13] == "NA,A" || sift[13] == "NA" ? "N/A" : (sift[13] != "" ? gensub(/,.*/, "", "g", sift[13]) : "N/A"));
# #                 SIFT_AA_change = (sift[7] == "NA/NA" ? "N/A" : (sift[7] != "" ? sift[7] : "N/A"));
# #                 transcript = sift[2];
# #                 sub(/^transcript\./, "", transcript);  # Remove "transcript." from the transcript string

# #                 print $1"\t"$2"\t"$3"\t"$4"\t"SIFT_consequence"\t"SIFT_score"\t"SIFT_impact"\t"SIFT_AA_change"\t"ALT_samples"\t"transcript; 
# #             }
# #         } else {
# #             print $1"\t"$2"\t"$3"\t"$4"\tN/A\tN/A\tN/A\tN/A\t"ALT_samples"\tN/A"; 
# #         }   
# #     }
# # }' >> "$output_dir/SIFT_flatFile_nonHDR_$1.tsv"

# # # HDR variants
# # echo -e "CHROM\tPOS\tREF\tALT\tSIFT_consequence\tSIFT_score\tSIFT_impact\tSIFT_AA_change\tALL_SAMPLES_WITH_ALT\tTRANSCRIPT" > "$output_dir/SIFT_flatFile_HDR_$1.tsv"

# # bcftools query \
# #     -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/SIFTINFO[\t%SAMPLE=%GT:%HDR]\n' -i 'HDR=1' \
# #     "$SIFT_annotated_vcf" | \
# # awk -F'\t' '{
# #     ALT_samples = "";  # Initialize string to collect samples with alt allele
# #     for (i = 6; i <= NF; i++) {  # Loop through fields containing sample=genotype
# #         if ($i ~ /0\/1|1\/0|1\/1/) {  # Check if sample has alt allele
# #             sub(/=.*/, "", $i);  # Remove genotype - leaving only sample name
# #             ALT_samples = ALT_samples (ALT_samples ? " " : "") $i;  # Append sample name
# #         }
# #     }
    
# #     if (ALT_samples != "") {
# #         if ($5 != ".") {
# #             split($5, annotations, ",");
# #             for (j in annotations) {
# #                 split(annotations[j], sift, "|");  # Split SIFTINFO field by pipe
# #                 SIFT_consequence = (sift[6] != "" ? sift[6] : "N/A");
# #                 SIFT_score = (sift[9] == "NA" ? "N/A" : (sift[9] != "" ? sift[9] : "N/A"));
# #                 SIFT_impact = (sift[13] == "NA,A" || sift[13] == "NA" ? "N/A" : (sift[13] != "" ? gensub(/,.*/, "", "g", sift[13]) : "N/A"));
# #                 SIFT_AA_change = (sift[7] == "NA/NA" ? "N/A" : (sift[7] != "" ? sift[7] : "N/A"));
# #                 transcript = sift[2];
# #                 sub(/^transcript\./, "", transcript);  # Remove "transcript." from the transcript string

# #                 print $1"\t"$2"\t"$3"\t"$4"\t"SIFT_consequence"\t"SIFT_score"\t"SIFT_impact"\t"SIFT_AA_change"\t"ALT_samples"\t"transcript; 
# #             }
# #         } else {
# #             print $1"\t"$2"\t"$3"\t"$4"\tN/A\tN/A\tN/A\tN/A\t"ALT_samples"\tN/A"; 
# #         }   
# #     }
# # # }' >> "$output_dir/SIFT_flatFile_HDR_$1.tsv"