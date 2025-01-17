#!/bin/bash

if [[ $1 == "c_elegans" ]]; then
    config="/SIFT_input/c_elegans_config.txt"
    db_path="/SIFT_input/elegans_WS283_PRJNA13758_NEMATODE_DB" #path of where database will be built
    vcf_input="/masterVCF_dir/WI.20231213.hard-filter.isotype.biallelic.NoMt.HDR.vcf.gz"
elif [[ $1 == "c_tropicalis" ]]; then
    config="/SIFT_input/c_tropicalis_config.txt"
    db_path="/SIFT_input/tropicalis_NIC58_NEMATODE_DB" #path of where database will be built
    vcf_input="masterVCF_dir/"
elif [[ $1 == "c_briggsae" ]]; then
    config="/SIFT_input/"
    db_path="/SIFT_input/" #path of where database will be built
    vcf_input="masterVCF_dir/"
else
    echo "Unsupported organism: $1"
    exit 1
fi

# Creating a log file to track progress
mkdir -p /annotation_output/nematode_db_run/output_files
log_file="/annotation_output/nematode_db_run/output_files/log_SIFT.txt"
echo "Checking if SIFT database has been built..." > $log_file

# Building the SIFT database
if [ -d $db_path ] && [ "$(ls -A $db_path)" ]; then
    echo "Database has been built already, moving on to annotation...." >> $log_file
else
    echo "Building Database...." >> $log_file
    perl /scripts/make-SIFT-db-all.pl -config $config
fi

# Annotating a VCF
VCF="/annotation_output/nematode_db_run/$(basename $vcf_input .gz)"
annotatedVCF=${VCF%.vcf}_SIFTpredictions.vcf
finalVCF=${annotatedVCF%.vcf}.final.vcf.gz

zcat $vcf_input > $VCF
if ! java -jar /sift4g/SIFT4G_Annotator/SIFT4G_Annotator.jar -c -i $VCF \
      -d $db_path \
      -r /annotation_output/nematode_db_run/ -t; then
    echo "failed to run SIFT on concatenated VCF for c_elegans" >> $log_file
    exit 1
fi

sed 's/\bECA246\b/CB4853/g; s/\bECA248\b/CB4855/g; s/\bECA243\b/CB4851/g; s/\bECA250\b/CB4857/g; s/\bECA251\b/CB4858/g; s/\bECA259\b/PB306/g' $annotatedVCF | bgzip -c > $finalVCF
tabix -p vcf $finalVCF













# # Annotating individual strain VCFs
# echo "Starting SIFT Annotation of strain VCFs..." >> $log_file
# for vcf in /strainVCFs/*.vcf.gz; do
#   filename="$(basename $vcf .vcf.gz)"

#   if [ -d /annotation_output/nematode_db_run/$filename ]; then
#     continue  
#   fi 

#   mkdir -p /annotation_output/nematode_db_run/$filename

#   filename_2=$(basename $vcf .gz)
#   zcat $vcf > /annotation_output/nematode_db_run/$filename/$filename_2

#   decompressed_file=/annotation_output/nematode_db_run/$filename/$filename_2
    
#   java -jar /sift4g/SIFT4G_Annotator/SIFT4G_Annotator.jar -c -i $decompressed_file \
#       -d $db_path \
#       -r /annotation_output/nematode_db_run/$filename -t
  
# done
# echo "SIFT Annotation for all strains completed." >> $log_file



# # Concatenating all strain VCFs into a master VCF
# echo "Beginning the process of annotated VCF concatenation..." >> $log_file

# # Create a directory to congregate all of the annotated VCFs
# mkdir -p /annotation_output/nematode_db_run/ALL_annotatedVCFs

# # Move all annotated VCFs to the central directory
# for strain_dir in /annotation_output/nematode_db_run/*/; do
#   if [ "$(basename $strain_dir)" = "output_files" ]; then
#     continue  #skipping the "output_files" directory
#   fi
  
#   if [ -d $strain_dir ]; then
#     for vcf in $strain_dir/*_SIFTpredictions.vcf; do
#       if [ -f $vcf ]; then
#         dest_file="/annotation_output/nematode_db_run/ALL_annotatedVCFs/$(basename $vcf)"
#         if [ ! -f $dest_file ]; then
#           mv $vcf $dest_file
#         else
#           echo "File $dest_file already exists, skipping..." >> $log_file
#         fi
#       fi
#     done
#   fi
# done
# echo "VCF congregation into directory complete...."

# # Compress VCF files for bcftools to handle
# for vcf in /annotation_output/nematode_db_run/ALL_annotatedVCFs/*_SIFTpredictions.vcf; do
#     if [ ! -f $vcf.gz ]; then # if the compressed file does not exist, make it
#         bgzip -c $vcf > $vcf.gz
#         echo "Compressed $vcf" >> $log_file
#     fi
#     if [ ! -f $vcf.gz.tbi ]; then # if the indexed file does not exist, make it
#         tabix -p vcf $vcf.gz
#         echo "Indexed $vcf.gz" >> $log_file
#     fi
# done


# # Creating a list of all the annotated VCFs
# vcf_list="/annotation_output/nematode_db_run/ALL_annotatedVCFs/vcf_list.txt"
# ls -1 /annotation_output/nematode_db_run/ALL_annotatedVCFs/*_SIFTpredictions.vcf.gz > $vcf_list

# # Check if the list is not empty
# if [ -s "$vcf_list" ]; then 
#     merged_vcf="/annotation_output/nematode_db_run/WI.20231213.hard-filter.isotype.SIFTannotated.vcf.gz"
#     final_vcf="${merged_vcf%.vcf.gz}_FINAL.vcf.gz"

#     # Check if the final VCF already exists
#     if [ -f $final_vcf ]; then
#         echo "Final VCF already created, skipping all steps..." >> $log_file
#     else
#         # Check if the merged VCF does NOT exist and the final VCF does not exist
#         if [ ! -f $merged_vcf ]; then 
#             echo "Creating merged VCF..." >> $log_file
#             bcftools merge -l $vcf_list -Oz -o $merged_vcf
            
#             if [ -f $merged_vcf ]; then # Check if the merged VCF was created
#                 echo "Merging of $merged_vcf complete" >> $log_file
#             else
#                 echo "Merging failed" >> $log_file
#             fi
#         else
#             echo "Merged file already exists, continuing..." >> $log_file
#         fi

#         # Only proceed with alias name switching if the final VCF does not exist, but the merged file does
#         if [[ $1 == "c_elegans" ]]; then
#             if [ -f $merged_vcf ]; then
#                 echo "Changing isotype reference strain names back to their alias..." >> $log_file
#                     zcat $merged_vcf | sed 's/\bECA246\b/CB4853/g; s/\bECA248\b/CB4855/g; s/\bECA243\b/CB4851/g; s/\bECA250\b/CB4857/g; s/\bECA251\b/CB4858/g; s/\bECA259\b/PB306/g' | bgzip > ${merged_vcf%.gz}.tmp.gz
#                 if [ -f ${merged_vcf%.gz}.tmp.gz ]; then
#                     mv ${merged_vcf%.gz}.tmp.gz $final_vcf
#                     rm $merged_vcf
#                     echo "Strains changed back to their alias isotype name" >> $log_file
#                 else
#                     echo "Failed to create the modified VCF file..." >> $log_file
#                 fi
#             else
#                 echo "Merged VCF file not found for modification..." >> $log_file
#             fi
#         else 
#             echo "Species $1, creating final file from merged file"
#             mv $merged_vcf $final_vcf
#         fi
#     fi
# else
#     echo "No VCF files found to merge..." >> $log_file
# fi

# echo "SIFT annotation complete, and final concatenated VCF created!" >> $log_file

# # Removing all strain directories but keeping "output_files" and final VCF
# # find /annotation_output/nematode_db_run/ -mindepth 1 -maxdepth 1 -type d ! -name "output_files" -exec rm -rf {} +

# # echo "Removed individual strain directories, and kept the final VCF and log file: $final_vcf" >> $log_file