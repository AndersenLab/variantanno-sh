library(dplyr)
library(readr)
library(ggplot2)
library(tidyr)
library(cowplot)
library(patchwork)
library(stringr)
library(forcats)
library(tibble)

################################################# BRIGGSAE #################################################################################################################################################################################################### 
# VEP
V = readr::read_csv("/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/HDRres_merging/finalMerge/VEP_c_briggsae_WBGeneID_GRANTHAM_BLOSUM_PP_final_nonINSERTIONPP.csv")
# chrom,pos,ref,alt,consequence,impact,AA,strain,transcript_name,wbgene,gene_name,grantham_score,blosum_score,percent_protein

VEP_cb <- V %>%  
  dplyr::select(chrom, pos, consequence, transcript_name, grantham_score, blosum_score) %>%
  dplyr::rename(VEP_consequence = consequence) %>%
  dplyr::filter(grepl("splce_donor_variant", VEP_consequence) | grepl("inframe_insertion", VEP_consequence) | grepl("inframe_deletion", VEP_consequence) | grepl('frameshift_variant', VEP_consequence) | grepl("missense_variant", VEP_consequence) | grepl("start_lost", VEP_consequence) | grepl("splice_acceptor_variant", VEP_consequence) | grepl("stop_gained", VEP_consequence) | grepl("stop_lost", VEP_consequence)) %>%
  dplyr::mutate(blosum_score = na_if(blosum_score, "N/A")) %>% dplyr::mutate(blosum_score = as.numeric(blosum_score)) %>%
  dplyr::filter(is.na(blosum_score) | blosum_score < 0) %>%
  dplyr::mutate(grantham_score = na_if(grantham_score, "N/A")) %>% dplyr::mutate(grantham_score = as.numeric(grantham_score)) %>%
  dplyr::filter(is.na(grantham_score) | grantham_score >= 151) %>%
  dplyr::distinct(chrom, pos, VEP_consequence, transcript_name, .keep_all = TRUE) 

print(nrow(VEP_cb  %>% dplyr::filter(blosum_score > 0))) # 0
print(nrow(VEP_cb)) # 131281 
sum(duplicated(paste(VEP_cb$chrom, VEP_cb$pos, VEP_cb$VEP_consequence, VEP_cb$transcript_name))) # 0

# ANNOVAR
A = readr::read_csv("/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/HDRres_merging/finalMerge/ANNOVAR_c_briggsae_WBGeneID_GRANTHAM_BLOSUM_PP_final_nonINSERTIONPP.csv") 
# chrom,pos,ref,alt,consequence,impact,AA,strain,transcript_name,wbgene,gene_name,grantham_score,blosum_score,percent_protein

ANV_cb <- A %>%
  dplyr::select(chrom, pos, consequence, impact, transcript_name, grantham_score, blosum_score) %>%
  dplyr::rename(ANV_consequence = consequence, ANV_impact = impact) %>%
  dplyr::filter(grepl("splicing", ANV_consequence) | ANV_impact == "frameshift_insertion" | ANV_impact == "frameshift_deletion" | grepl("nonsynonymous_SNV", ANV_impact) | grepl("stopgain", ANV_impact) | grepl("stoploss", ANV_impact)) %>% 
  dplyr::mutate(blosum_score = na_if(blosum_score, "N/A")) %>% dplyr::mutate(blosum_score = as.numeric(blosum_score)) %>%
  dplyr::filter(is.na(blosum_score) | blosum_score < 0) %>%
  dplyr::mutate(grantham_score = na_if(grantham_score, "N/A")) %>% dplyr::mutate(grantham_score = as.numeric(grantham_score)) %>%
  dplyr::filter(is.na(grantham_score) | grantham_score >= 151) %>%
  dplyr::distinct(chrom, pos, ANV_impact, transcript_name, .keep_all = TRUE)

print(nrow(ANV_cb)) # 134627
sum(duplicated(paste(ANV_cb$chrom, ANV_cb$pos, ANV_cb$ANV_impact, ANV_cb$transcript_name))) # 0


# BCSQ
C = readr::read_csv("/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/HDRres_merging/finalMerge/CSQ_c_briggsae_WBGeneID_GRANTHAM_BLOSUM_PP_final_nonINSERTIONPP.csv") 
# chrom,pos,ref,alt,consequence,AA,DNAchange,strain,transcript_name,wbgene,gene_name,grantham_score,blosum_score,percent_protein

CSQ_cb <- C %>% 
  dplyr::select(chrom, pos, consequence, transcript_name, grantham_score, blosum_score) %>%
  dplyr::rename(CSQ_consequence = consequence) %>%
  dplyr::filter((grepl("splice_donor", CSQ_consequence) | grepl("inframe_insertion", CSQ_consequence) | grepl("inframe_deletion", CSQ_consequence) | grepl("frameshift", CSQ_consequence) | grepl("splice_acceptor", CSQ_consequence) | grepl("missense", CSQ_consequence) | grepl("start_lost", CSQ_consequence) | grepl("stop_gained", CSQ_consequence) | grepl("stop_lost", CSQ_consequence))) %>%
  dplyr::mutate(blosum_score = na_if(blosum_score, "N/A")) %>% dplyr::mutate(blosum_score = as.numeric(blosum_score)) %>%
  dplyr::filter(is.na(blosum_score) | blosum_score < 0) %>%
  dplyr::mutate(grantham_score = na_if(grantham_score, "N/A")) %>% dplyr::mutate(grantham_score = as.numeric(grantham_score)) %>%
  dplyr::filter(is.na(grantham_score) | grantham_score >= 151) %>%
  dplyr::distinct(chrom, pos, CSQ_consequence, transcript_name, .keep_all = TRUE) 

print(nrow(CSQ_cb %>% dplyr::filter(grantham_score < 151))) # 0
print(nrow(CSQ_cb)) # 156869
sum(duplicated(paste(CSQ_cb$chrom, CSQ_cb$pos, CSQ_cb$CSQ_consequence, CSQ_cb$transcript_name))) # 0


# Variants called per chromosome for BRIGGSAE - normalized by chromosome length
# bcftools view -H WI.20250331.hard-filter.isotype.biallelic.NoMt.vcf.gz | awk '{print $1,$2}' > noMt.chrom.pos.tsv
cb <- readr::read_delim("/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/noMt.chrom.pos.tsv", delim = " ", trim_ws = TRUE, col_names = c("chrom","pos")) %>%
  dplyr::group_by(chrom) %>%
  dplyr::summarise(varCount = n())

CSQ_cb_count <- CSQ_cb %>%
  dplyr::group_by(chrom) %>%
  dplyr::summarise(del_CSQ = n())

ANV_cb_count <- ANV_cb %>%
  dplyr::group_by(chrom) %>%
  dplyr::summarise(del_ANV = n())

VEP_cb_count <- VEP_cb %>%
  dplyr::group_by(chrom) %>%
  dplyr::summarise(del_VEP = n())

cb_join <- cb %>%
  dplyr::left_join(CSQ_cb_count, by = "chrom") %>%
  dplyr::left_join(ANV_cb_count, by = "chrom") %>%
  dplyr::left_join(VEP_cb_count, by = "chrom")


# awk '/^>/ {if (seq) {print chrom, length(seq)}; chrom = $0; seq = ""} /^>/ {next} {seq = seq $0} END {print chrom, length(seq)}' c_briggsae.QX1410_nanopore.Feb2020.genome.fa
# >I 15540809
# >II 16595099
# >III 14810976
# >IV 17080301
# >V 19933398
# >X 22220885
# >MtDNA 14590

cb_chr_sizes <- c("I" = 15540809, "II" = 16595099, "III" = 14810976, 
                    "IV" = 17080301, "V" = 19933398, "X" = 22220885)

cb_chrom <- cb_join %>%
  mutate(chr_size = case_when(
    chrom == "I"  ~ cb_chr_sizes["I"],
    chrom == "II" ~ cb_chr_sizes["II"],
    chrom == "III" ~ cb_chr_sizes["III"],
    chrom == "IV" ~ cb_chr_sizes["IV"],  
    chrom == "V"  ~ cb_chr_sizes["V"],
    chrom == "X"  ~ cb_chr_sizes["X"],
    TRUE ~ NA_real_  # Default case (if chrom is not one of the expected values)
  ))

cb_norm <- cb_chrom %>%
  dplyr::mutate(norm_counts = (varCount / chr_size)) %>%
  dplyr::mutate(norm_del_CSQ = (del_CSQ / chr_size)) %>%
  dplyr::mutate(norm_del_ANV = (del_ANV / chr_size)) %>%
  dplyr::mutate(norm_del_VEP = (del_VEP / chr_size)) %>%
  dplyr::select(-del_CSQ, -del_ANV, -del_VEP, -varCount, -chr_size)

cb_final <- cb_norm %>%
  rowwise() %>%
  mutate(
    norm_del_mean = mean(c(norm_del_CSQ, norm_del_ANV, norm_del_VEP), na.rm = TRUE),
    norm_del_sd = sd(c(norm_del_CSQ, norm_del_ANV, norm_del_VEP), na.rm = TRUE)
  ) %>%
  ungroup()

cb_plt <- ggplot(cb_final, aes(x = chrom)) +
  geom_bar(aes(y = norm_counts, fill = "Total"), alpha = 0.7, stat = "identity", position = "dodge") +
  geom_bar(aes(y = norm_del_mean, fill = "Predicted deleterious (avg)"), alpha = 0.7, stat = "identity", position = "dodge") +
  geom_errorbar(aes(
    ymin = norm_del_mean - norm_del_sd,
    ymax = norm_del_mean + norm_del_sd
  ), width = 0.2, position = position_dodge(width = 0.9)) +
  scale_fill_manual(
    name = "",
    values = c("Total" = "#53886C", "Predicted deleterious (avg)" = "greenyellow")
  ) +
  labs(y = "Normalized number of variants (per bp)") +
  theme(
    axis.text = element_text(face = 'bold'),
    panel.background = element_blank(),
    axis.text.x = element_text(color = 'black'),
    axis.title.x = element_blank(),
    axis.title.y = element_text(size = 13),
    legend.position = "top"
  )

cb_plt

top_plot <- ggplot(cb_final, aes(x = chrom)) +
  geom_bar(aes(y = norm_counts, fill = "Total"), stat = "identity", alpha = 0.7) +
  coord_cartesian(ylim = c(0.015, 0.065)) +
  scale_fill_manual(values = c("Total" = "#53886C")) +
  theme_minimal() +
  labs(title = "C. briggsae") + 
  theme(
    axis.title = element_blank(),
    axis.text.x = element_blank(),
    plot.title = element_text(size = 18, face = "italic", hjust = 0.5),
    axis.ticks.x = element_blank(),
    axis.text.y = element_text(size = 12, color = 'black'),
    legend.position = "none",
    panel.background = element_blank(),
    panel.grid = element_blank()) 
  # labs(y = "Variants (per bp)")

bottom_plot <- ggplot(cb_final, aes(x = chrom)) +
  geom_bar(aes(y = norm_counts, fill = "Total"), stat = "identity", alpha = 0.7) +
  geom_bar(aes(y = norm_del_mean, fill = "Predicted deleterious (avg)"), stat = "identity", alpha = 0.7) +
  geom_errorbar(aes(
    ymin = norm_del_mean - norm_del_sd,
    ymax = norm_del_mean + norm_del_sd
  ), width = 0.1, color = 'black') +
  coord_cartesian(ylim = c(0, 0.003)) +
  scale_fill_manual(values = c("Total" = "#53886C", "Predicted deleterious (avg)" = "palegreen")) +
  theme_minimal() +
  theme(
    axis.title = element_blank(),
    axis.text.x = element_text(size = 14, face = "bold"),
    legend.position = "none",
    axis.text.y = element_text(size = 12, color = 'black'),
    panel.background = element_blank(),
    panel.grid = element_blank()) 
  # labs(y = "Variants (per bp)", fill = "")

x <- top_plot / bottom_plot + plot_layout(heights = c(2, 1))
x





################################################# ELEGANS ####################################################################################################################################################################################################  
# VEP
V_e = readr::read_csv("/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/HDRres_merging/finalMerge/VEP_c_elegans_WBGeneID_GRANTHAM_BLOSUM_PP_final_nonINSERTIONPP.csv")
# chrom,pos,ref,alt,consequence,impact,AA,strain,divergent,transcript_name,wbgene,gene_name,grantham_score,blosum_score,percent_protein

VEP_ce <- V_e %>%  
  dplyr::select(chrom, pos, consequence, transcript_name, grantham_score, blosum_score) %>%
  dplyr::rename(VEP_consequence = consequence) %>%
  dplyr::filter(grepl("splce_donor_variant", VEP_consequence) | grepl("inframe_insertion", VEP_consequence) | grepl("inframe_deletion", VEP_consequence) | grepl('frameshift_variant', VEP_consequence) | grepl("missense_variant", VEP_consequence) | grepl("start_lost", VEP_consequence) | grepl("splice_acceptor_variant", VEP_consequence) | grepl("stop_gained", VEP_consequence) | grepl("stop_lost", VEP_consequence)) %>%
  dplyr::mutate(blosum_score = na_if(blosum_score, "N/A")) %>% dplyr::mutate(blosum_score = as.numeric(blosum_score)) %>%
  dplyr::filter(is.na(blosum_score) | blosum_score < 0) %>%
  dplyr::mutate(grantham_score = na_if(grantham_score, "N/A")) %>% dplyr::mutate(grantham_score = as.numeric(grantham_score)) %>%
  dplyr::filter(is.na(grantham_score) | grantham_score >= 151) %>%
  dplyr::distinct(chrom, pos, VEP_consequence, transcript_name, .keep_all = TRUE) 

print(nrow(VEP_ce  %>% dplyr::filter(blosum_score > 0))) # 0
print(nrow(VEP_ce)) # 84524 
sum(duplicated(paste(VEP_ce$chrom, VEP_ce$pos, VEP_ce$VEP_consequence, VEP_ce$transcript_name))) # 0

# ANNOVAR
A_e = readr::read_csv("/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/HDRres_merging/finalMerge/ANNOVAR_c_elegans_WBGeneID_GRANTHAM_BLOSUM_PP_final_nonINSERTIONPP.csv") 
# chrom,pos,ref,alt,consequence,impact,AA,strain,divergent,transcript_name,wbgene,gene_name,grantham_score,blosum_score,percent_protein

ANV_ce <- A_e %>%
  dplyr::select(chrom, pos, consequence, impact, transcript_name, grantham_score, blosum_score) %>%
  dplyr::rename(ANV_consequence = consequence, ANV_impact = impact) %>%
  dplyr::filter(grepl("splicing", ANV_consequence) | ANV_impact == "frameshift_insertion" | ANV_impact == "frameshift_deletion" | grepl("nonsynonymous_SNV", ANV_impact) | grepl("stopgain", ANV_impact) | grepl("stoploss", ANV_impact)) %>% 
  dplyr::mutate(blosum_score = na_if(blosum_score, "N/A")) %>% dplyr::mutate(blosum_score = as.numeric(blosum_score)) %>%
  dplyr::filter(is.na(blosum_score) | blosum_score < 0) %>%
  dplyr::mutate(grantham_score = na_if(grantham_score, "N/A")) %>% dplyr::mutate(grantham_score = as.numeric(grantham_score)) %>%
  dplyr::filter(is.na(grantham_score) | grantham_score >= 151) %>%
  dplyr::distinct(chrom, pos, ANV_impact, transcript_name, .keep_all = TRUE)

print(nrow(ANV_ce)) # 70787
sum(duplicated(paste(ANV_ce$chrom, ANV_ce$pos, ANV_ce$ANV_impact, ANV_ce$transcript_name))) # 0


# BCSQ
C_e = readr::read_csv("/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/HDRres_merging/finalMerge/CSQ_c_elegans_WBGeneID_GRANTHAM_BLOSUM_PP_final_nonINSERTIONPP.csv") 
# chrom,pos,ref,alt,consequence,AA,DNAchange,strain,divergent,transcript_name,wbgene,gene_name,grantham_score,blosum_score,percent_protein

CSQ_ce <- C_e %>% 
  dplyr::select(chrom, pos, consequence, transcript_name, grantham_score, blosum_score) %>%
  dplyr::rename(CSQ_consequence = consequence) %>%
  dplyr::filter((grepl("splice_donor", CSQ_consequence) | grepl("inframe_insertion", CSQ_consequence) | grepl("inframe_deletion", CSQ_consequence) | grepl("frameshift", CSQ_consequence) | grepl("splice_acceptor", CSQ_consequence) | grepl("missense", CSQ_consequence) | grepl("start_lost", CSQ_consequence) | grepl("stop_gained", CSQ_consequence) | grepl("stop_lost", CSQ_consequence))) %>%
  dplyr::mutate(blosum_score = na_if(blosum_score, "N/A")) %>% dplyr::mutate(blosum_score = as.numeric(blosum_score)) %>%
  dplyr::filter(is.na(blosum_score) | blosum_score < 0) %>%
  dplyr::mutate(grantham_score = na_if(grantham_score, "N/A")) %>% dplyr::mutate(grantham_score = as.numeric(grantham_score)) %>%
  dplyr::filter(is.na(grantham_score) | grantham_score >= 151) %>%
  dplyr::distinct(chrom, pos, CSQ_consequence, transcript_name, .keep_all = TRUE) 

print(nrow(CSQ_ce %>% dplyr::filter(grantham_score < 151))) # 0
print(nrow(CSQ_ce)) # 40745
sum(duplicated(paste(CSQ_ce$chrom, CSQ_ce$pos, CSQ_ce$CSQ_consequence, CSQ_ce$transcript_name))) # 0




# Variants called per chromosome for ELEGANS - normalized by chromosome length
# view -H WI.20250331.hard-filter.isotype.biallelic.NoMt.HDR.vcf.gz | awk '{print $1,$2}' > noMt.chrom.pos.tsv
ce <- readr::read_delim("/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/noMt.chrom.pos.tsv", delim = " ", trim_ws = TRUE, col_names = c("chrom","pos")) %>%
  dplyr::group_by(chrom) %>%
  dplyr::summarise(varCount = n())

CSQ_ce_count <- CSQ_ce %>%
  dplyr::group_by(chrom) %>%
  dplyr::summarise(del_CSQ = n())

ANV_ce_count <- ANV_ce %>%
  dplyr::group_by(chrom) %>%
  dplyr::summarise(del_ANV = n())

VEP_ce_count <- VEP_ce %>%
  dplyr::group_by(chrom) %>%
  dplyr::summarise(del_VEP = n())

ce_join <- ce %>%
  dplyr::left_join(CSQ_ce_count, by = "chrom") %>%
  dplyr::left_join(ANV_ce_count, by = "chrom") %>%
  dplyr::left_join(VEP_ce_count, by = "chrom")

ce_chr_sizes <- c("I" = 15072434, "II" = 15279421, "III" = 13783801, 
                 "IV" = 17493829, "V" = 20924180, "X" = 17718942)

ce_chrom <- ce_join %>%
  mutate(chr_size = case_when(
    chrom == "I"  ~ ce_chr_sizes["I"],
    chrom == "II" ~ ce_chr_sizes["II"],
    chrom == "III" ~ ce_chr_sizes["III"],
    chrom == "IV" ~ ce_chr_sizes["IV"],  
    chrom == "V"  ~ ce_chr_sizes["V"],
    chrom == "X"  ~ ce_chr_sizes["X"],
    TRUE ~ NA_real_  # Default case (if chrom is not one of the expected values)
  ))

ce_norm <- ce_chrom %>%
  dplyr::mutate(norm_counts = (varCount / chr_size)) %>%
  dplyr::mutate(norm_del_CSQ = (del_CSQ / chr_size)) %>%
  dplyr::mutate(norm_del_ANV = (del_ANV / chr_size)) %>%
  dplyr::mutate(norm_del_VEP = (del_VEP / chr_size)) %>%
  dplyr::select(-del_CSQ, -del_ANV, -del_VEP, -varCount, -chr_size)

ce_final <- ce_norm %>%
  rowwise() %>%
  mutate(
    norm_del_mean = mean(c(norm_del_CSQ, norm_del_ANV, norm_del_VEP), na.rm = TRUE),
    norm_del_sd = sd(c(norm_del_CSQ, norm_del_ANV, norm_del_VEP), na.rm = TRUE)
  ) %>%
  ungroup()

ce_plt <- ggplot(ce_final, aes(x = chrom)) +
  geom_bar(aes(y = norm_counts, fill = "Total"), alpha = 0.7, stat = "identity", position = "dodge") +
  geom_bar(aes(y = norm_del_mean, fill = "Predicted deleterious (avg)"), alpha = 0.7, stat = "identity", position = "dodge") +
  geom_errorbar(aes(
    ymin = norm_del_mean - norm_del_sd,
    ymax = norm_del_mean + norm_del_sd
  ), width = 0.2, position = position_dodge(width = 0.9)) +
  scale_fill_manual(
    name = "",
    values = c("Total" = "#DB6333", "Predicted deleterious (avg)" = "navajowhite2")
  ) +
  labs(y = "Normalized number of variants (per bp)") +
  theme(
    axis.text = element_text(face = 'bold'),
    panel.background = element_blank(),
    axis.text.x = element_text(color = 'black'),
    axis.title.x = element_blank(),
    axis.title.y = element_text(size = 13),
    legend.position = "top"
  )

ce_plt

top_plot <- ggplot(ce_final, aes(x = chrom)) +
  geom_bar(aes(y = norm_counts, fill = "Total"), stat = "identity", alpha = 0.7) +
  coord_cartesian(ylim = c(0.015, 0.065)) +
  scale_fill_manual(values = c("Total" = "#DB6333")) +
  theme_minimal() +
  labs(title = "C. elegans") + 
  theme(
    axis.title = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.text.y = element_text(size = 12, color = 'black'),
    plot.title = element_text(size = 18, face = "italic", hjust = 0.5),
    legend.position = "none",
    panel.background = element_blank(),
    panel.grid = element_blank()) 
# labs(y = "Variants (per bp)")

bottom_plot <- ggplot(ce_final, aes(x = chrom)) +
  geom_bar(aes(y = norm_counts, fill = "Total"), stat = "identity", alpha = 0.7) +
  geom_bar(aes(y = norm_del_mean, fill = "Predicted deleterious (avg)"), stat = "identity", alpha = 0.7) +
  geom_errorbar(aes(
    ymin = norm_del_mean - norm_del_sd,
    ymax = norm_del_mean + norm_del_sd
  ), width = 0.1, color = 'black') +
  coord_cartesian(ylim = c(0, 0.003)) +
  scale_fill_manual(values = c("Total" = "#DB6333", "Predicted deleterious (avg)" = "navajowhite2")) +
  theme_minimal() +
  theme(
    axis.title = element_blank(),
    axis.text.x = element_text(size = 14, face = "bold"),
    legend.position = "none",
    axis.text.y = element_text(size = 12, color = 'black'),
    panel.background = element_blank(),
    panel.grid = element_blank()) 
# labs(y = "Variants (per bp)", fill = "")

y <- top_plot / bottom_plot + plot_layout(heights = c(2, 1))
y







################################################# TROPICALIS ################################################################################################################################################################################################## 
# VEP
V_t = readr::read_csv("/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/HDRres_merging/finalMerge/VEP_c_tropicalis_WBGeneID_GRANTHAM_BLOSUM_PP_final_nonINSERTIONPP.csv")
# chrom,pos,ref,alt,consequence,impact,AA,strain,divergent,transcript_name,wbgene,gene_name,grantham_score,blosum_score,percent_protein

VEP_ct <- V_t %>%  
  dplyr::select(chrom, pos, consequence, transcript_name, grantham_score, blosum_score) %>%
  dplyr::rename(VEP_consequence = consequence) %>%
  dplyr::filter(grepl("splce_donor_variant", VEP_consequence) | grepl("inframe_insertion", VEP_consequence) | grepl("inframe_deletion", VEP_consequence) | grepl('frameshift_variant', VEP_consequence) | grepl("missense_variant", VEP_consequence) | grepl("start_lost", VEP_consequence) | grepl("splice_acceptor_variant", VEP_consequence) | grepl("stop_gained", VEP_consequence) | grepl("stop_lost", VEP_consequence)) %>%
  dplyr::mutate(blosum_score = na_if(blosum_score, "N/A")) %>% dplyr::mutate(blosum_score = as.numeric(blosum_score)) %>%
  dplyr::filter(is.na(blosum_score) | blosum_score < 0) %>%
  dplyr::mutate(grantham_score = na_if(grantham_score, "N/A")) %>% dplyr::mutate(grantham_score = as.numeric(grantham_score)) %>%
  dplyr::filter(is.na(grantham_score) | grantham_score >= 151) %>%
  dplyr::distinct(chrom, pos, VEP_consequence, transcript_name, .keep_all = TRUE) 

print(nrow(VEP_ct  %>% dplyr::filter(blosum_score > 0))) # 0
print(nrow(VEP_ct)) # 
sum(duplicated(paste(VEP_ct$chrom, VEP_ct$pos, VEP_ct$VEP_consequence, VEP_ct$transcript_name))) # 0

# ANNOVAR
A_t = readr::read_csv("/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/HDRres_merging/finalMerge/ANNOVAR_c_tropicalis_WBGeneID_GRANTHAM_BLOSUM_PP_final_nonINSERTIONPP.csv") 
# chrom,pos,ref,alt,consequence,impact,AA,strain,divergent,transcript_name,wbgene,gene_name,grantham_score,blosum_score,percent_protein

ANV_ct<- A_t %>%
  dplyr::select(chrom, pos, consequence, impact, transcript_name, grantham_score, blosum_score) %>%
  dplyr::rename(ANV_consequence = consequence, ANV_impact = impact) %>%
  dplyr::filter(grepl("splicing", ANV_consequence) | ANV_impact == "frameshift_insertion" | ANV_impact == "frameshift_deletion" | grepl("nonsynonymous_SNV", ANV_impact) | grepl("stopgain", ANV_impact) | grepl("stoploss", ANV_impact)) %>% 
  dplyr::mutate(blosum_score = na_if(blosum_score, "N/A")) %>% dplyr::mutate(blosum_score = as.numeric(blosum_score)) %>%
  dplyr::filter(is.na(blosum_score) | blosum_score < 0) %>%
  dplyr::mutate(grantham_score = na_if(grantham_score, "N/A")) %>% dplyr::mutate(grantham_score = as.numeric(grantham_score)) %>%
  dplyr::filter(is.na(grantham_score) | grantham_score >= 151) %>%
  dplyr::distinct(chrom, pos, ANV_impact, transcript_name, .keep_all = TRUE)

print(nrow(ANV_ct)) # 
sum(duplicated(paste(ANV_ct$chrom, ANV_ct$pos, ANV_ct$ANV_impact, ANV_ct$transcript_name))) # 0


# BCSQ
C_t = readr::read_csv("/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/HDRres_merging/finalMerge/CSQ_c_tropicalis_WBGeneID_GRANTHAM_BLOSUM_PP_final_nonINSERTIONPP.csv") 
# chrom,pos,ref,alt,consequence,AA,DNAchange,strain,divergent,transcript_name,wbgene,gene_name,grantham_score,blosum_score,percent_protein

CSQ_ct <- C_t %>% 
  dplyr::select(chrom, pos, consequence, transcript_name, grantham_score, blosum_score) %>%
  dplyr::rename(CSQ_consequence = consequence) %>%
  dplyr::filter((grepl("splice_donor", CSQ_consequence) | grepl("inframe_insertion", CSQ_consequence) | grepl("inframe_deletion", CSQ_consequence) | grepl("frameshift", CSQ_consequence) | grepl("splice_acceptor", CSQ_consequence) | grepl("missense", CSQ_consequence) | grepl("start_lost", CSQ_consequence) | grepl("stop_gained", CSQ_consequence) | grepl("stop_lost", CSQ_consequence))) %>%
  dplyr::mutate(blosum_score = na_if(blosum_score, "N/A")) %>% dplyr::mutate(blosum_score = as.numeric(blosum_score)) %>%
  dplyr::filter(is.na(blosum_score) | blosum_score < 0) %>%
  dplyr::mutate(grantham_score = na_if(grantham_score, "N/A")) %>% dplyr::mutate(grantham_score = as.numeric(grantham_score)) %>%
  dplyr::filter(is.na(grantham_score) | grantham_score >= 151) %>%
  dplyr::distinct(chrom, pos, CSQ_consequence, transcript_name, .keep_all = TRUE) 

print(nrow(CSQ_ct %>% dplyr::filter(grantham_score < 151))) # 0
print(nrow(CSQ_ct)) # 
sum(duplicated(paste(CSQ_ct$chrom, CSQ_ct$pos, CSQ_ct$CSQ_consequence, CSQ_ct$transcript_name))) # 0




# Variants called per chromosome for ELEGANS - normalized by chromosome length
# view -H WI.20250331.hard-filter.isotype.biallelic.NoMt.HDR.vcf.gz | awk '{print $1,$2}' > noMt.chrom.pos.tsv
ct <- readr::read_delim("/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/noMt.chrom.pos.tsv", delim = " ", trim_ws = TRUE, col_names = c("chrom","pos")) %>%
  dplyr::group_by(chrom) %>%
  dplyr::summarise(varCount = n())

CSQ_ct_count <- CSQ_ct %>%
  dplyr::group_by(chrom) %>%
  dplyr::summarise(del_CSQ = n())

ANV_ct_count <- ANV_ct %>%
  dplyr::group_by(chrom) %>%
  dplyr::summarise(del_ANV = n())

VEP_ct_count <- VEP_ct %>%
  dplyr::group_by(chrom) %>%
  dplyr::summarise(del_VEP = n())

ct_join <- ct %>%
  dplyr::left_join(CSQ_ct_count, by = "chrom") %>%
  dplyr::left_join(ANV_ct_count, by = "chrom") %>%
  dplyr::left_join(VEP_ct_count, by = "chrom")

# awk '/^>/ {if (seq) {print chrom, length(seq)}; chrom = $0; seq = ""} /^>/ {next} {seq = seq $0} END {print chrom, length(seq)}' c_tropicalis.NIC58_nanopore.June2021.genome.fa
# >I 12301352s
# >II 12746191
# >III 11893256
# >IV 13967141
# >V 15342032
# >X 15972007
# >MtDNA 13924
ct_chr_sizes <- c("I" = 12301352, "II" = 12746191, "III" = 11893256, 
                  "IV" = 13967141, "V" = 15972007, "X" = 15972007)

ct_chrom <- ct_join %>%
  mutate(chr_size = case_when(
    chrom == "I"  ~ ct_chr_sizes["I"],
    chrom == "II" ~ ct_chr_sizes["II"],
    chrom == "III" ~ ct_chr_sizes["III"],
    chrom == "IV" ~ ct_chr_sizes["IV"],  
    chrom == "V"  ~ ct_chr_sizes["V"],
    chrom == "X"  ~ ct_chr_sizes["X"],
    TRUE ~ NA_real_  # Default case (if chrom is not one of the expected values)
  ))

ct_norm <- ct_chrom %>%
  dplyr::mutate(norm_counts = (varCount / chr_size)) %>%
  dplyr::mutate(norm_del_CSQ = (del_CSQ / chr_size)) %>%
  dplyr::mutate(norm_del_ANV = (del_ANV / chr_size)) %>%
  dplyr::mutate(norm_del_VEP = (del_VEP / chr_size)) %>%
  dplyr::select(-del_CSQ, -del_ANV, -del_VEP, -varCount, -chr_size)

ct_final <- ct_norm %>%
  rowwise() %>%
  mutate(
    norm_del_mean = mean(c(norm_del_CSQ, norm_del_ANV, norm_del_VEP), na.rm = TRUE),
    norm_del_sd = sd(c(norm_del_CSQ, norm_del_ANV, norm_del_VEP), na.rm = TRUE)
  ) %>%
  ungroup()

ct_plt <- ggplot(ct_final, aes(x = chrom)) +
  geom_bar(aes(y = norm_counts, fill = "Total"), alpha = 0.7, stat = "identity", position = "dodge") +
  geom_bar(aes(y = norm_del_mean, fill = "Predicted deleterious (avg)"), alpha = 0.7, stat = "identity", position = "dodge") +
  geom_errorbar(aes(
    ymin = norm_del_mean - norm_del_sd,
    ymax = norm_del_mean + norm_del_sd
  ), width = 0.2, position = position_dodge(width = 0.9)) +
  scale_fill_manual(
    name = "",
    values = c("Total" = "#0719BC", "Predicted deleterious (avg)" = "lightblue")
  ) +
  labs(y = "Normalized number of variants (per bp)") +
  theme(
    axis.text = element_text(face = 'bold'),
    panel.background = element_blank(),
    axis.text.x = element_text(color = 'black'),
    axis.title.x = element_blank(),
    axis.title.y = element_text(size = 13),
    legend.position = "top"
  )

ct_plt

top_plot <- ggplot(ct_final, aes(x = chrom)) +
  geom_bar(aes(y = norm_counts, fill = "Total"), stat = "identity", alpha = 0.7) +
  coord_cartesian(ylim = c(0.015, 0.065)) +
  scale_fill_manual(values = c("Total" = "#0719BC")) +
  theme_minimal() +
  labs(title = "C. tropicalis") + 
  theme(
    axis.title = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.text.y = element_text(size = 12, color = 'black'),
    plot.title = element_text(size = 18, face = "italic", hjust = 0.5),
    legend.position = "none",
    panel.background = element_blank(),
    panel.grid = element_blank()) 
# labs(y = "Variants (per bp)")
# top_plot

bottom_plot <- ggplot(ct_final, aes(x = chrom)) +
  geom_bar(aes(y = norm_counts, fill = "Total"), stat = "identity", alpha = 0.7) +
  geom_bar(aes(y = norm_del_mean, fill = "Predicted deleterious (avg)"), stat = "identity", alpha = 0.7) +
  geom_errorbar(aes(
    ymin = norm_del_mean - norm_del_sd,
    ymax = norm_del_mean + norm_del_sd
  ), width = 0.1, color = 'black') +
  coord_cartesian(ylim = c(0, 0.003)) +
  scale_fill_manual(values = c("Total" = "#0719BC", "Predicted deleterious (avg)" = "lightblue")) +
  theme_minimal() +
  theme(
    axis.title = element_blank(),
    axis.text.x = element_text(size = 14, face = "bold"),
    legend.position = "none",
    axis.text.y = element_text(size = 12, color = 'black'),
    panel.background = element_blank(),
    panel.grid = element_blank()) 
# labs(y = "Variants (per bp)", fill = "")

z <- top_plot / bottom_plot + plot_layout(heights = c(2, 1))
z


# COWPLOT THEM TOGETHER
three_cowplot <- plot_grid(
  x, y, z,
  nrow = 1,
  rel_heights = c(1, 1), rel_widths = c(1,1,1),
  align = "hv"
)

three_cowplot


final_plot <- ggdraw() +
  draw_plot(three_cowplot, x = 0.05, width = 0.95) +  # shift the plots slightly to the right
  draw_label("Normalized variant counts (per bp)",
             x = 0.04, y = 0.5, angle = 90, vjust = 0.5, fontface = "bold", size = 14, color = "black") +
  theme(plot.background = element_rect(fill = "white", color = NA))
final_plot

# ggsave("/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/plots/variant_counting/c_elegans/del_variants.png", final_plot, width = 12, height = 6, dpi = 600)






















####################### A heat map of the major types of variant annotations for each strain, faceted by species ########################################################################################################################
cb_heatmap <- C %>%
  dplyr::mutate(species = "CB") %>%
  dplyr::filter(consequence != "N/A") %>%
  dplyr::select(chrom, pos, consequence, strain, species)

ct_heatmap <- C_t%>%
  dplyr::mutate(species = "CT") %>%
  dplyr::filter(consequence != "N/A") %>%
  dplyr::select(chrom, pos, consequence, strain, species)

ce_heatmap <- C_e %>%
  dplyr::mutate(species = "CE") %>%
  dplyr::filter(consequence != "N/A") %>%
  dplyr::select(chrom, pos, consequence, strain, species)

csq_heatmap <- cb_heatmap %>%
  dplyr::bind_rows(ct_heatmap) %>%
  dplyr::bind_rows(ce_heatmap) %>%
  dplyr::filter(grepl("missense", consequence) | grepl("splice", consequence) | grepl("frameshift", consequence) | grepl("stop_gained", consequence)) %>%
  tidyr::separate_rows(strain, sep = "\\s+") 

csq_b <- C %>%
  dplyr::distinct(chrom,pos) %>%
  nrow()

csq_e <- C_e %>%
  dplyr::distinct(chrom,pos) %>%
  nrow()

csq_t <- C_t %>%
  dplyr::distinct(chrom,pos) %>%
  nrow()

csq_heatmap_class <- csq_heatmap %>%
  dplyr::mutate(classification = case_when(
    str_detect(consequence, "splice")      ~ "splice_site",
    str_detect(consequence, "missense")    ~ "missense",
    str_detect(consequence, "frameshift")  ~ "frameshift",
    str_detect(consequence, "stop_gained") ~ "nonsense",
    TRUE                                   ~ "other"  # fallback
  )) %>%
  dplyr::select(-consequence, -chrom, -pos) %>%
  dplyr::group_by(strain,species,classification) %>%
  dplyr::summarise(consequence_count = n()) %>%
  dplyr::mutate(
    norm_consequence_count = dplyr::case_when(
      species == "CB" ~ consequence_count / csq_b,
      species == "CE" ~ consequence_count / csq_e,
      species == "CT" ~ consequence_count / csq_t,
      TRUE            ~ NA_real_
    )
  ) # normalize by total number of variants annotated by BCSQ for each species 


top_strains_per_species <- csq_heatmap_class %>%
  dplyr::group_by(species, strain) %>%
  dplyr::summarise(total = sum(norm_consequence_count, na.rm = TRUE)) %>%
  dplyr::arrange(species, desc(total)) %>%
  dplyr::group_by(species) %>%
  dplyr::slice_head(n = 20) %>%
  dplyr::ungroup()

# 2. Add strain_label conditional on top strains per species
csq_heatmap_top10 <- csq_heatmap_class %>%
  dplyr::left_join(top_strains_per_species, by = "strain") %>%
  dplyr::mutate(strain_label = if_else(!is.na(species.y), strain, "")) %>%
  dplyr::select(-species.y) %>%
  dplyr::rename(species = species.x)

# 3. Make strain a factor with levels ordered by total within species (optional but nice)
strain_order <- csq_heatmap_top10 %>%
  dplyr::group_by(species, strain) %>%
  dplyr::summarise(total = sum(norm_consequence_count, na.rm = TRUE)) %>%
  dplyr::arrange(species, desc(total)) %>%
  dplyr::group_by(species) %>%
  dplyr::mutate(rank = row_number()) %>%
  dplyr::arrange(species, rank) %>%
  dplyr::pull(strain)

csq_heatmap_class_2 <- csq_heatmap_top10 %>%
  dplyr::mutate(strain = factor(strain, levels = unique(strain_order))) 

csq_top20 <- csq_heatmap_class_2 %>%
  dplyr::filter(strain_label != "")



hm <- ggplot(csq_heatmap_class_2, aes(x = strain, y = classification, fill = norm_consequence_count)) +
  geom_tile() +
  scale_fill_viridis_c(option = "C", name = "Normalized variant count") +
  facet_wrap(~ species, scales = "free_x") +
  theme(
    axis.text.x = element_blank(),
    axis.title = element_blank(),
    strip.text = element_text(face = "bold", size = 16),
    panel.grid = element_blank(),
    axis.text.y = element_text(size = 14, face = 'bold', color = 'black'),
    panel.spacing = unit(0.1, "lines"),
    panel.background = element_blank(),
    axis.ticks.x = element_blank()
  ) 

hm

# ggsave("/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/plots/IWM_2025_poster/heatmap.png", hm, width = 14, height = 8, dpi = 600)

# 5. Plot with your heatmap code:
top10 <- ggplot(csq_top20, aes(x = strain_label, y = classification, fill = norm_consequence_count)) +
  geom_tile() +
  scale_fill_viridis_c(option = "C", name = "Normalized variant count") +
  facet_wrap(~ species, scales = "free_x") +
  theme(
    axis.text.x = element_text(angle = 75, vjust = 0.4, hjust = 0.2, size = 10),
    axis.title = element_blank(),
    strip.text = element_text(face = "bold", size = 16),
    panel.grid = element_blank(),
    axis.text.y = element_text(size = 14, color = 'black', face = 'bold'),
    legend.title = element_text(size = 13),
    legend.text = element_text(size = 12),
    panel.spacing = unit(0.1, "lines"),
    panel.background = element_blank(),
    axis.ticks.x = element_blank()
  ) 
top10











############### Distribution of where variants are called ####################################################################################################################################### 
cb_freq <- readr::read_delim("/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_briggsae/noMt.chrom.pos.tsv", delim = " ", trim_ws = TRUE, col_names = c("chrom","pos")) 

cb_binned <- cb_freq %>%
  dplyr::mutate(bin = (pos %/% 1000) * 1000) %>%  # floor to nearest 1000
  dplyr::count(chrom, bin, name = "variant_count") %>%
  dplyr::arrange(chrom, bin)

ce_freq <- readr::read_delim("/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/noMt.chrom.pos.tsv", delim = " ", trim_ws = TRUE, col_names = c("chrom","pos")) 

ce_binned <- ce_freq %>%
  dplyr::mutate(bin = (pos %/% 1000) * 1000) %>%  # floor to nearest 1000
  dplyr::count(chrom, bin, name = "variant_count") %>%
  dplyr::arrange(chrom, bin)


ct_freq <- readr::read_delim("/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/noMt.chrom.pos.tsv", delim = " ", trim_ws = TRUE, col_names = c("chrom","pos")) 
  
ct_binned <- ct_freq %>%
  dplyr::mutate(bin = (pos %/% 1000) * 1000) %>%  # floor to nearest 1000
  dplyr::count(chrom, bin, name = "variant_count") %>%
  dplyr::arrange(chrom, bin)


b <- ggplot(cb_binned) + 
  geom_point(aes(x = bin, y = variant_count), color = '#53886C', alpha = 0.7) +
  facet_wrap( ~chrom, nrow = 1, scales = "free_x") + 
  geom_smooth(aes(x = bin, y = variant_count), method = "loess", se = TRUE, color = "lightblue") +
  # ylab("Variants per kb") + 
  theme(
    axis.text.x = element_blank(),
    axis.title.x = element_blank(),
    axis.text.y = element_text(size = 14, color = 'black'),
    panel.grid = element_blank(),
    # axis.title.y = element_text(size = 14, color = 'black'),
    axis.title.y = element_blank(),
    axis.ticks.x = element_blank(),
    panel.background = element_blank(),
    strip.text = element_text(size = 16, color = "black")
  )
b  


e <- ggplot(ce_binned) + 
  geom_point(aes(x = bin, y = variant_count), color = '#DB6333', alpha = 0.7) +
  facet_wrap( ~chrom, nrow = 1, scales = "free_x") + 
  geom_smooth(aes(x = bin, y = variant_count), method = "loess", se = TRUE, color = "lightblue") +
  # ylab("Variants per kb") + 
  theme(
    axis.text.x = element_blank(),
    axis.title.x = element_blank(),
    axis.text.y = element_text(size = 14, color = 'black'),
    panel.grid = element_blank(),
    # axis.title.y = element_text(size = 14, color = 'black'),
    axis.title.y = element_blank(),
    axis.ticks.x = element_blank(),
    panel.background = element_blank(),
    strip.text = element_text(size = 16, color = "black")
  )
e 

t <- ggplot(ct_binned) + 
  geom_point(aes(x = bin, y = variant_count), color = '#0719BC', alpha = 0.7) +
  facet_wrap( ~chrom, nrow = 1, scales = "free_x") + 
  geom_smooth(aes(x = bin, y = variant_count), method = "loess", se = TRUE, color = "lightblue") +
  # ylab("Variants per kb") + 
  theme(
    axis.text.x = element_blank(),
    axis.title.x = element_blank(),
    axis.text.y = element_text(size = 14, color = 'black'),
    panel.grid = element_blank(),
    # axis.title.y = element_text(size = 14, color = 'black'),
    axis.title.y = element_blank(),
    axis.ticks.x = element_blank(),
    panel.background = element_blank(),
    strip.text = element_text(size = 16, color = "black")
  )
t

variant_cowplot <- plot_grid(
  b,e,t,
  nrow = 3,
  rel_heights = c(1, 1, 1), rel_widths = c(1,1,1),
  align = "v"
)

variant_cowplot

final_plot_2 <- ggdraw() +
  draw_plot(variant_cowplot, x = 0.04, width = 0.93) +
  draw_label("C. briggsae", x = 0.98, y = 0.85, angle = 270, vjust = 0.5, fontface = "bold.italic", size = 18, color = "black") +
  draw_label("C. elegans", x = 0.978, y = 0.5, angle = 270, vjust = 0.5, fontface = "bold.italic", size = 18, color = "black") +
  draw_label("C. tropicalis", x = 0.98, y = 0.15, angle = 270, vjust = 0.5, fontface = "bold.italic", size = 18, color = "black") +
  draw_label("Variants per kb", x = 0.02, y = 0.85, angle = 90, vjust = 0.5, size = 16, fontface = 'bold', color = "black") +
  draw_label("Variants per kb", x = 0.02, y = 0.5, angle = 90, vjust = 0.5, size = 16, fontface = 'bold', color = "black") +
  draw_label("Variants per kb", x = 0.02, y = 0.15, angle = 90, vjust = 0.5, size = 16, fontface = 'bold', color = "black") +
  theme(plot.background = element_rect(fill = "white", color = NA))
final_plot_2

# ggsave("/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/plots/IWM_2025_poster/variant_dist.png", final_plot_2, width = 18, height = 10, dpi = 600)

















############### Variant concordance bubble plot ####################################################################################################################################### 
###### BRIGGSAE ###### 
cVb <- V %>%
  dplyr::select(chrom, pos, consequence, transcript_name) %>%
  dplyr::filter(consequence != "N/A") %>%
  dplyr::rename(VEP_con = consequence) 

cAb <- A %>%
  dplyr::select(chrom, pos, consequence, impact, transcript_name) %>%
  dplyr::rename(ANV_con = impact) %>%
  dplyr::mutate(ANV_con = ifelse(consequence == "splicing","splicing", ANV_con)) %>%
  dplyr::filter(ANV_con != "N/A") %>%
  dplyr::select(-consequence)

cCb <- C %>%
  dplyr::select(chrom, pos, consequence, transcript_name) %>%
  dplyr::filter(consequence != "N/A") %>%
  dplyr::rename(CSQ_con = consequence) 

cb_consequence_concordance <- cVb %>%
  dplyr::full_join(cAb, by = c("chrom", "pos", "transcript_name")) %>%
  dplyr::full_join(cCb, by = c("chrom", "pos", "transcript_name"))


cb_consequence_concordance_naming <- cb_consequence_concordance %>%
  dplyr::mutate(ANV_con = gsub("nonsynonymous_SNV", "missense", ANV_con)) %>%
  dplyr::mutate(ANV_con = gsub("synonymous_SNV", "synonymous", ANV_con)) %>%
  dplyr::mutate(ANV_con = ifelse(grepl("frameshift", ANV_con), "frameshift", ANV_con)) %>%
  # dplyr::mutate(ANV_con = ifelse(grepl("splicing", ANV_con), "splice_region", ANV_con)) %>%
  dplyr::mutate(ANV_con = ifelse(grepl("stopgain", ANV_con), "nonsense", ANV_con)) %>%
  dplyr::mutate(VEP_con = gsub("synonymous_variant", "synonymous", VEP_con)) %>%
  dplyr::mutate(VEP_con = gsub("missense_variant", "missense", VEP_con)) %>%
  # dplyr::mutate(VEP_con = ifelse(grepl("splice", VEP_con), "splice_region", VEP_con)) %>%
  dplyr::mutate(VEP_con = ifelse(grepl("frameshift", VEP_con), "frameshift", VEP_con)) %>%
  # dplyr::mutate(VEP_con = ifelse(grepl("inframe", VEP_con), "frameshift", VEP_con)) %>%
  dplyr::mutate(VEP_con = ifelse(grepl("stop_gained", VEP_con), "nonsense", VEP_con)) %>%
  # dplyr::mutate(CSQ_con = ifelse(grepl("inframe", CSQ_con), "frameshift", CSQ_con)) %>%
  # dplyr::mutate(CSQ_con = ifelse(grepl("splice", CSQ_con), "splice_region", CSQ_con)) %>%
  dplyr::mutate(CSQ_con = gsub("\\*","", CSQ_con)) %>%
  dplyr::mutate(CSQ_con = ifelse(grepl("missense", CSQ_con), "missense", CSQ_con)) %>%
  dplyr::mutate(CSQ_con = ifelse(grepl("synonymous", CSQ_con), "synonymous", CSQ_con)) %>%
  dplyr::mutate(CSQ_con = ifelse(grepl("stop_gained", CSQ_con), "nonsense", CSQ_con)) %>%
  dplyr::filter(if_any(c(ANV_con, VEP_con, CSQ_con), ~ str_detect(.x, "frameshift|synonymous|missense|nonsense"))) 
  
cb_cons_filtered <- cb_consequence_concordance_naming %>%
  dplyr::mutate(concordance = if_else(!is.na(ANV_con) & !is.na(VEP_con) & !is.na(CSQ_con) & ANV_con == VEP_con & VEP_con == CSQ_con, TRUE, FALSE)) %>%
  dplyr::select(1,2,4,3,5,6,7) 


cb_long <- cb_cons_filtered %>%
  tidyr::pivot_longer(cols = c(ANV_con, VEP_con, CSQ_con),
               names_to = "tool", values_to = "consequence")

variant_counts_b <- cb_long %>%
  dplyr::group_by(tool, consequence) %>%
  dplyr::summarise(
    total = n(),
    concordant = sum(concordance),
    percent_concordant = round(100 * concordant / total, 2),
    .groups = "drop"
  ) %>%
  dplyr::arrange(tool, desc(total)) %>%
  dplyr::filter(consequence == "frameshift" | consequence == "synonymous" | consequence == "missense" | consequence == "nonsense") %>%
  dplyr::mutate(
    tool = gsub("ANV_con", "ANNOVAR", tool),
    tool = gsub("VEP_con", "VEP", tool),
    tool = gsub("CSQ_con", "CSQ", tool),
    species = "CB"
  ) %>%
  dplyr::select(tool, consequence, total, percent_concordant, species)



###### ELEGANS ###### 
cVe <- V_e %>%
  dplyr::select(chrom, pos, consequence, transcript_name) %>%
  dplyr::filter(consequence != "N/A") %>%
  dplyr::rename(VEP_con = consequence) 

cAe <- A_e %>%
  dplyr::select(chrom, pos, consequence, impact, transcript_name) %>%
  dplyr::rename(ANV_con = impact) %>%
  dplyr::mutate(ANV_con = ifelse(consequence == "splicing","splicing", ANV_con)) %>%
  dplyr::filter(ANV_con != "N/A") %>%
  dplyr::select(-consequence)

C_e = readr::read_tsv("/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_elegans/HDRres_merging/finalMerge/CSQ_c_elegans_WBGeneID.tsv", col_names = c("chrom","pos","ref","alt","consequence","AA","DNAchange","strain","divergent","transcript_name","WBGene","locus")) 
cCe <- C_e %>%
  dplyr::select(chrom, pos, consequence, transcript_name) %>%
  dplyr::filter(consequence != "N/A") %>%
  dplyr::rename(CSQ_con = consequence) 

ce_consequence_concordance <- cVe %>%
  dplyr::full_join(cAe, by = c("chrom", "pos", "transcript_name")) %>%
  dplyr::full_join(cCe, by = c("chrom", "pos", "transcript_name"))


ce_consequence_concordance_naming <- ce_consequence_concordance %>%
  dplyr::mutate(ANV_con = gsub("nonsynonymous_SNV", "missense", ANV_con)) %>%
  dplyr::mutate(ANV_con = gsub("synonymous_SNV", "synonymous", ANV_con)) %>%
  dplyr::mutate(ANV_con = ifelse(grepl("frameshift", ANV_con), "frameshift", ANV_con)) %>%
  dplyr::mutate(ANV_con = ifelse(grepl("stopgain", ANV_con), "nonsense", ANV_con)) %>%
  dplyr::mutate(VEP_con = gsub("synonymous_variant", "synonymous", VEP_con)) %>%
  dplyr::mutate(VEP_con = gsub("missense_variant", "missense", VEP_con)) %>%
  dplyr::mutate(VEP_con = ifelse(grepl("frameshift", VEP_con), "frameshift", VEP_con)) %>%
  dplyr::mutate(VEP_con = ifelse(grepl("stop_gained", VEP_con), "nonsense", VEP_con)) %>%
  dplyr::mutate(CSQ_con = gsub("\\*","", CSQ_con)) %>%
  dplyr::mutate(CSQ_con = ifelse(grepl("missense", CSQ_con), "missense", CSQ_con)) %>%
  dplyr::mutate(CSQ_con = ifelse(grepl("synonymous", CSQ_con), "synonymous", CSQ_con)) %>%
  dplyr::mutate(CSQ_con = ifelse(grepl("stop_gained", CSQ_con), "nonsense", CSQ_con)) %>%
  dplyr::filter(if_any(c(ANV_con, VEP_con, CSQ_con), ~ str_detect(.x, "frameshift|synonymous|missense|nonsense"))) 

ce_cons_filtered <- ce_consequence_concordance_naming %>%
  dplyr::mutate(concordance = if_else(!is.na(ANV_con) & !is.na(VEP_con) & !is.na(CSQ_con) & ANV_con == VEP_con & VEP_con == CSQ_con, TRUE, FALSE)) %>%
  dplyr::select(1,2,4,3,5,6,7) 


ce_long <- ce_cons_filtered %>%
  tidyr::pivot_longer(cols = c(ANV_con, VEP_con, CSQ_con),
                      names_to = "tool", values_to = "consequence")

variant_counts_e <- ce_long %>%
  dplyr::group_by(tool, consequence) %>%
  dplyr::summarise(
    total = n(),
    concordant = sum(concordance),
    percent_concordant = round(100 * concordant / total, 2),
    .groups = "drop"
  ) %>%
  dplyr::arrange(tool, desc(total)) %>%
  dplyr::filter(consequence == "frameshift" | consequence == "synonymous" | consequence == "missense" | consequence == "nonsense") %>%
  dplyr::mutate(
    tool = gsub("ANV_con", "ANNOVAR", tool),
    tool = gsub("VEP_con", "VEP", tool),
    tool = gsub("CSQ_con", "CSQ", tool),
    species = "CE"
  ) %>%
  dplyr::select(tool, consequence, total, percent_concordant, species)



###### TROPICALIS ###### 
cVt <- V_t %>%
  dplyr::select(chrom, pos, consequence, transcript_name) %>%
  dplyr::filter(consequence != "N/A") %>%
  dplyr::rename(VEP_con = consequence) 

cAt <- A_t %>%
  dplyr::select(chrom, pos, consequence, impact, transcript_name) %>%
  dplyr::rename(ANV_con = impact) %>%
  dplyr::mutate(ANV_con = ifelse(consequence == "splicing","splicing", ANV_con)) %>%
  dplyr::filter(ANV_con != "N/A") %>%
  dplyr::select(-consequence)

C_t = readr::read_tsv("/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/processed_data/flat_file_creation/c_tropicalis/HDRres_merging/finalMerge/CSQ_c_tropicalis_WBGeneID.tsv", col_names = c("chrom","pos","ref","alt","consequence","AA","DNAchange","strain","divergent","transcript_name","WBGene","locus")) 
cCt <- C_t %>%
  dplyr::select(chrom, pos, consequence, transcript_name) %>%
  dplyr::filter(consequence != "N/A") %>%
  dplyr::rename(CSQ_con = consequence) 

ct_consequence_concordance <- cVt %>%
  dplyr::full_join(cAt, by = c("chrom", "pos", "transcript_name")) %>%
  dplyr::full_join(cCt, by = c("chrom", "pos", "transcript_name"))


ct_consequence_concordance_naming <- ct_consequence_concordance %>%
  dplyr::mutate(ANV_con = gsub("nonsynonymous_SNV", "missense", ANV_con)) %>%
  dplyr::mutate(ANV_con = gsub("synonymous_SNV", "synonymous", ANV_con)) %>%
  dplyr::mutate(ANV_con = ifelse(grepl("frameshift", ANV_con), "frameshift", ANV_con)) %>%
  dplyr::mutate(ANV_con = ifelse(grepl("stopgain", ANV_con), "nonsense", ANV_con)) %>%
  dplyr::mutate(VEP_con = gsub("synonymous_variant", "synonymous", VEP_con)) %>%
  dplyr::mutate(VEP_con = gsub("missense_variant", "missense", VEP_con)) %>%
  dplyr::mutate(VEP_con = ifelse(grepl("frameshift", VEP_con), "frameshift", VEP_con)) %>%
  dplyr::mutate(VEP_con = ifelse(grepl("stop_gained", VEP_con), "nonsense", VEP_con)) %>%
  dplyr::mutate(CSQ_con = gsub("\\*","", CSQ_con)) %>%
  dplyr::mutate(CSQ_con = ifelse(grepl("missense", CSQ_con), "missense", CSQ_con)) %>%
  dplyr::mutate(CSQ_con = ifelse(grepl("synonymous", CSQ_con), "synonymous", CSQ_con)) %>%
  dplyr::mutate(CSQ_con = ifelse(grepl("stop_gained", CSQ_con), "nonsense", CSQ_con)) %>%
  dplyr::filter(if_any(c(ANV_con, VEP_con, CSQ_con), ~ str_detect(.x, "frameshift|synonymous|missense|nonsense"))) 

ct_cons_filtered <- ct_consequence_concordance_naming %>%
  dplyr::mutate(concordance = if_else(!is.na(ANV_con) & !is.na(VEP_con) & !is.na(CSQ_con) & ANV_con == VEP_con & VEP_con == CSQ_con, TRUE, FALSE)) %>%
  dplyr::select(1,2,4,3,5,6,7) 


ct_long <- ct_cons_filtered %>%
  tidyr::pivot_longer(cols = c(ANV_con, VEP_con, CSQ_con),
                      names_to = "tool", values_to = "consequence")

variant_counts_t <- ct_long %>%
  dplyr::group_by(tool, consequence) %>%
  dplyr::summarise(
    total = n(),
    concordant = sum(concordance),
    percent_concordant = round(100 * concordant / total, 2),
    .groups = "drop"
  ) %>%
  dplyr::arrange(tool, desc(total)) %>%
  dplyr::filter(consequence == "frameshift" | consequence == "synonymous" | consequence == "missense" | consequence == "nonsense") %>%
  dplyr::mutate(
    tool = gsub("ANV_con", "ANNOVAR", tool),
    tool = gsub("VEP_con", "VEP", tool),
    tool = gsub("CSQ_con", "CSQ", tool),
    species = "CT"
  ) %>%
  dplyr::select(tool, consequence, total, percent_concordant, species)




all_sp_variant_count <- variant_counts_b %>%
  dplyr::bind_rows(variant_counts_e) %>%
  dplyr::bind_rows(variant_counts_t)

###### plotting ###### 
all_sp_variant_count$consequence <- factor(
  all_sp_variant_count$consequence,
  levels = c("missense", "synonymous", "frameshift", "nonsense")
)

conc_plot <- ggplot(all_sp_variant_count, aes(x = consequence, y = tool, size = total, fill = percent_concordant)) +
  geom_point(shape = 21, alpha = 0.7) +
  facet_wrap(~species, nrow = 1) + 
  scale_fill_gradient2(
    low = "brown", mid = "gold1", high = "blue",
    midpoint = 55,
    name = "Percent Concordance"
  ) +
  scale_size_continuous(range = c(5, 17)) +
  labs(
    y = "Annotation Tool",
    size = "Variant Count"
  ) +
  theme(
    panel.background = element_blank(),
    panel.border = element_rect(fill = NA),
    strip.text = element_text(size = 16, color = "black", face = 'bold'),
    axis.title = element_blank(),
    legend.title = element_text(size = 14),
    axis.ticks.x = element_blank(),
    axis.text = element_text(size = 13.5, color = 'black', face = 'bold'),
    axis.text.x = element_text(angle = 0, hjust = 0.5)
  )
conc_plot

# ggsave("/vast/eande106/projects/Lance/THESIS_WORK/variant_annotation/plots/IWM_2025_poster/concordance_annotations.png", conc_plot, width = 20, height = 10, dpi = 600)
