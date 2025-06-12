library(dplyr)
library(tidyr)
library(ape)
library(readr)

# C. tropicalis
gff_ct <- ape::read.gff("/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/raw_data/gff_corrections/NIC58.update.April2025.gff")

update_ct <- gff_ct %>%
  dplyr::mutate(attributes = ifelse(type == "mRNA" | type == "CDS", gsub("product=","locus=", attributes), attributes)) %>%
  dplyr::mutate(attributes = gsub("hypothetical protein", "hypothetical_protein", attributes)) %>%
  dplyr::mutate(attributes = ifelse(type == "gene" | type == "mRNA", paste0(attributes,";biotype=protein_coding"),attributes)) %>%
  dplyr::mutate(phase = as.character(phase)) %>%
  dplyr::mutate(score = as.character(score)) %>%
  dplyr::mutate(phase = ifelse(is.na(phase), ".", phase)) %>%
  dplyr::mutate(score = ifelse(is.na(score), ".", score)) %>%
  dplyr::mutate(attributes = ifelse(seqid == "MtDNA" & type == "CDS", gsub("ID=", "ID=CDS:", attributes), attributes)) %>%
  # dplyr::mutate(attributes = ifelse(seqid == "MtDNA" & type == "CDS", gsub("Parent=", "Parent=transcript:", attributes), attributes)) %>%
  dplyr::mutate(attributes = ifelse(seqid == "MtDNA" & type == "gene", gsub("ID=", "ID=gene:", attributes), attributes))


# write.table(update_ct,"/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/raw_data/gff_corrections/NIC58.update.April2025.csq.gff3",quote = FALSE, row.names = FALSE, sep = '\t', col.names = FALSE)




# C. briggsae
gff_cb <- ape::read.gff("/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/raw_data/gff_corrections/QX1410.update.April2025.gff")

update_cb <- gff_cb %>%
  dplyr::mutate(attributes = ifelse(type == "mRNA" | type == "CDS", gsub("product=","locus=", attributes), attributes)) %>%
  dplyr::mutate(attributes = gsub("hypothetical protein", "hypothetical_protein", attributes)) %>%
  dplyr::mutate(attributes = ifelse(type == "gene" | type == "mRNA", paste0(attributes,";biotype=protein_coding"),attributes)) %>%
  dplyr::mutate(phase = as.character(phase)) %>%
  dplyr::mutate(score = as.character(score)) %>%
  dplyr::mutate(phase = ifelse(is.na(phase), ".", phase)) %>%
  dplyr::mutate(score = ifelse(is.na(score), ".", score)) %>%
  dplyr::mutate(attributes = ifelse(seqid == "MtDNA" & type == "CDS", gsub("ID=", "ID=CDS:", attributes), attributes)) %>%
  # dplyr::mutate(attributes = ifelse(seqid == "MtDNA" & type == "CDS", gsub("Parent=", "Parent=transcript:", attributes), attributes)) %>%
  dplyr::mutate(attributes = ifelse(seqid == "MtDNA" & type == "gene", gsub("ID=", "ID=gene:", attributes), attributes))


# write.table(update_cb,"/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/raw_data/gff_corrections/QX1410.update.April2025.csq.gff3",quote = FALSE, row.names = FALSE, sep = '\t', col.names = FALSE)
