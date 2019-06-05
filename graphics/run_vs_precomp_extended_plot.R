#script to compare precomputed and new NCBoost values

library("ggplot2")
library("gridExtra")
library("grid")
library("RColorBrewer")
library("Hmisc")


###############################################################################################

#data

data<-read.table("pre_plus_new_NCBoost_and_annotation_VCF_updated.txt", sep = "\t", header = T)
data[data=='NA'] <- NA

#columns to be added:

#new ranking
#data$new_value_rank[<-(rank(data2$NCboost_new_value, na.last = NA))/length(na.omit(data$NCboost_new_value))


#data$new_value_rank<-ifelse(complete.cases(data$NCboost_new_value),(rank(na.omit(data2$NCboost_new_value))/length(na.omit(data$NCboost_new_value))), NA )

# -rare
data$MAF_value<-ifelse(data$maf >= 0 & data$maf<0.01, '<0.01',
                       ifelse(data$maf >= 0.01 & data$maf<0.05, '0.01-0.05','common'))
data$MAF_value<-as.factor(data$MAF_value)

# -region (CDS, not_CDS, other), in_out column
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
data$in_out<-as.factor(data$in_out)

# -score_value (0=none, 1=only precomputed, 2=only new value, 3=both)
data$score_value<-ifelse(is.na(data$NCBoost_Score) & is.na(data$NCboost_new_value), "0",
                         (ifelse(data$NCBoost_Score>0 & is.na(data$NCboost_new_value), "1",
                          (ifelse(is.na(data$NCBoost_Score) & data$NCboost_new_value>0,"2","3")))))
data$score_value<-as.factor(data$score_value)

# -new vs old REGION (discordant,concordant)
data$region<-as.character(data$region)
data$NEW_region<-as.character(data$NEW_region)
data$old_new_region<-ifelse(data$region==data$NEW_region,"concordant","discordant")
data$old_new_region<-as.factor(data$old_new_region)

# -new vs old closest gene name (discordant,concordant)
data$closest_gene_name<-as.character(data$closest_gene_name)
data$NEW_closest_gene_name<-as.character(data$NEW_closest_gene_name)
data$old_new_gene<-ifelse(data$closest_gene_name==data$NEW_closest_gene_name,"concordant","discordant")
data$old_new_gene<-as.factor(data$old_new_gene)

#subset

#subset of the data that do not has pat score at all
subdata_NO_value<-data[data$score_value==0 & data$in_out=="Not_CDS",]

#subset of the data that have new pat score <0.2 and belongs to intronic, 5'UTR and 3'UTR
take_only<-c("intron_variant",
           "5_prime_UTR_variant",
           "3_prime_UTR_variant")

subdata_low_pat<-data[data$worst_CSQ %in% take_only, ]
subdata_low_pat<-subdata_low_pat[complete.cases(subdata_low_pat),]
subdata_low_pat$worst_CSQ<-as.factor(subdata_low_pat$worst_CSQ)

#to compute the lm and correlation
precomp_new_lm<-summary(lm(data$NCBoost_Score~data$NCboost_new_value))

precomp_new_values<-data[data$score_value==3,]

cor_precomp_new<-cor(precomp_new_values$NCBoost_Score,precomp_new_values$NCboost_new_value)

###############################################################################################

#graphics

#barplot of the score value column
a<-ggplot(data, aes(x=data$score_value,fill=data$in_out))+geom_bar()
a<-a + scale_fill_brewer(palette="Set1")
a<-a + annotate("text", x=1, y=4500, label = nrow(data[data$score_value==0,]) , color="black", size=5 )
a<-a + annotate("text", x=2, y=2000, label = nrow(data[data$score_value==1,]) , color="black", size=5 )
a<-a + annotate("text", x=3, y=7000, label = nrow(data[data$score_value==2,]) , color="black", size=5 )
a<-a + annotate("text", x=4, y=6800, label = nrow(data[data$score_value==3,]) , color="black", size=5 )
a<-a + labs(title = "New vs precomputed score results",
            x = "0=no score, 1=only precomp, 2=only new, 3=both precomp and new")


#general scatterplot precomp vs new

b1<-ggplot(data, aes(x=data$NCBoost_Score, y=data$NCboost_new_value))+geom_point()+
 stat_summary(fun.data=mean_cl_normal) + geom_smooth(method='glm')+ geom_segment(aes(x = 0, y = 0, xend = 0.9, yend = 0.9), color=)
b1<-b1 + labs(title = "Run vs precomputed score results",
            x = "pre_comp score", y= "NCboost run score")
print (b1)

#Scatterplot of old vs new data
b<-ggplot(data, aes(x=data$NCBoost_Score, y=data$NCboost_new_value))+geom_point(aes(colour = factor(MAF_value)), alpha=0.5)
b<-b + facet_wrap(~MAF_value)
b<-b + labs(title = "New vs precomputed score results",
            subtitle = "Deviation of precomp-new NCBoost pat score depending on MAF",
            x = "pre_comp score", y= "new score")

#Scatterplot of old vs new data only new pat<0.2 and intronic, 5'UTR and 3'UTR
c<-ggplot(subdata_low_pat, aes(x=subdata_low_pat$NCBoost_Score, y=subdata_low_pat$NCboost_new_value))+geom_point(aes(colour = factor(worst_CSQ)), alpha=0.5)
c<-c + facet_wrap(~worst_CSQ)
c<-c + scale_color_brewer(palette="Dark2")
c<-c + xlim(0,0.2)
c<-c + ylim(0,0.2)
c<-c + labs(title = "New vs precomputed score results",
            subtitle = "Intronic, 5'UTR and 3'UTR pat score <0.2 focus",
            x = "pre_comp score", y= "new score")

#scatterplot of old vs new region
d<-ggplot(data[complete.cases(data),], aes(x=data[complete.cases(data),]$NCBoost_Score, y=data[complete.cases(data),]$NCboost_new_value))+geom_point(aes(colour = factor(old_new_region)), alpha=0.5)
d<-d + facet_wrap(~old_new_region)
d<-d + labs(title = "New vs precomputed score results",
            subtitle = "Comparison of old and new region",
            x = "pre_comp score", y= "new score")

#scatterplot of old vs new gene
e<-ggplot(data[complete.cases(data),], aes(x=data[complete.cases(data),]$NCBoost_Score, y=data[complete.cases(data),]$NCboost_new_value))+geom_point(aes(colour = factor(old_new_gene)), alpha=0.5)
e<-e + facet_wrap(~old_new_gene)
e<-e + labs(title = "New vs precomputed score results",
            subtitle = "Comparison of old and new gene",
            x = "pre_comp score", y= "new score")

################################################################################################

#output

write.table(data, "pre_plus_new_NCBoost_vcf_updated_factor.txt", sep = "\t", quote = F)
write.table(subdata_NO_value, "never_scored_Not_CDS_position.txt", sep = "\t", quote = F)

pdf("NCBoost_run_results.pdf")
print(a)
print(b)
print(c)
print(grid.arrange(d, e, nrow = 2))
dev.off()










