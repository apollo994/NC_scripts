#script to plot the correlation between effect size and NCBoost score

library("ggplot2")
library("plyr")

###############################################################################################

#data

data<-read.table("my_vcf_updated_singleline.txt", sep = "\t", header = T)
#data[data=='NA'] <- NA

data$MAF_value<-ifelse(data$maf >= 0 & data$maf<0.01, '<0.01',
                       ifelse(data$maf >= 0.01 & data$maf<0.05, '0.01-0.05','common'))

data$NCBoost<-ifelse(data$NCBoost_Score >= 0 , 'Calculated','Not_calculated')
data$NCBoost[is.na(data$NCBoost)] <- "Not_calculated"


not_cds<-c("downstream_gene_variant",
           "intergenic_variant",
           "intron_variant",
           "mature_miRNA_variant",
           "regulatory_region_variant",
           "splice_region_variant",
           "TF_binding_site_variant",
           "upstream_gene_variant",
           "5_prime_UTR_variant",
           "3_prime_UTR_variant")
other<-c("",
         "non_coding_transcript_exon_variant")


data$worst_CSQ<-as.character(data$worst_CSQ)
data$in_out<-ifelse(data$worst_CSQ %in% not_cds, "Not_CDS",ifelse(data$worst_CSQ %in% other, "Other","CDS"))


p<-ggplot(data, aes(x=beta, y=NCBoost_Score)) +geom_point(aes(colour = MAF_value))
p<-p + facet_wrap(~phenotype, ncol=4, scales = "free")
p<-p + labs(title = "Positions precalculated by NCBoost",
            subtitle = "Plot of beta vs pathogenicity",
            x = "Effect size", y= "Pathogenicity score")


e<-ggplot(data, aes(x=data$NCBoost, y=data$beta)) + geom_boxplot(alpha=0.2 , varwidth=T)
e<-e + facet_wrap(~worst_CSQ, ncol = 4, scales = "free", shrink = T)
e<-e + labs(title = "Effect size distribution",
            subtitle = "Beta value in different worst_CSQ, NCScore calculated vs not calculated",
            x = "Effect size", y= "worst_CSQ")
e<-e + coord_cartesian(ylim = c(0.5,-0.5))


d<-ggplot(data, aes(x=data$in_out, fill=NCBoost)) + geom_bar()
d<-d + theme(axis.text.x = element_text(angle = 90))



print(d)



