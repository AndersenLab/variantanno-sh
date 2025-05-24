library(dplyr)
library(stringr)
library(ape)

gff <- ape::read.gff("/vast/eande106/data/c_elegans/genomes/PRJNA13758/WS283/csq/c_elegans.PRJNA13758.WS283.csq.gff3")
gff$rowid <- seq_len(nrow(gff))

PC_genes <- gff %>%
  dplyr::filter(grepl("protein_coding", attributes) & type == "gene") 
  
PC_mRNA <- gff %>%
  dplyr::filter(grepl("protein_coding", attributes) & type == "mRNA") %>%
  dplyr::select(attributes) %>%
  dplyr::mutate(transcript_id = stringr::str_extract(attributes, "(?<=transcript:)[^;]+")) %>%
  dplyr::select(transcript_id) %>%
  dplyr::pull(transcript_id)

gff_transcripts <- gff %>%
  dplyr::mutate(transcript_id = stringr::str_extract(attributes, "(?<=transcript:)[^;]+"))

PC_L2L3 <- gff_transcripts %>%
  dplyr::filter(transcript_id %in% PC_mRNA) %>% 
  dplyr::select(-transcript_id)

PC_gff <- PC_genes %>% #### FIX so that indexing will work
  dplyr::bind_rows(PC_L2L3) %>%
  dplyr::arrange(rowid) %>%
  dplyr::mutate(score = ifelse(is.na(score),".",score), phase = ifelse(is.na(phase),".",phase))

write.table(PC_gff,"/vast/eande106/projects/Lance/THESIS_WORK/gene_annotation/raw_data/assemblies/elegans/gff/c_elegans.PRJNA13758.WS283.csq.PCfeaturesOnly.gff3", quote = F, row.names = F, col.names = F, sep = '\t')
