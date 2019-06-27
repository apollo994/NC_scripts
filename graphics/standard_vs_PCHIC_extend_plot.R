#script to compare standard and PCICH score values of intergenic position

library("ggplot2")
library("gridExtra")
library("grid")
library("RColorBrewer")
library("Hmisc")
library("gtools")
library("ggpubr")


###############################################################################################

#data

data<-read.table("../../dataset_and_res/manuel/intergenic/standard_RVIS_hi_low_merge.txt", sep = "\t", header = T)
data[data=='NA'] <- "NA"
my_col=colnames(data)
my_col=my_col[-1]
data[,ncol(data)]<-NULL
colnames(data)<-my_col


res_file="../../dataset_and_res/manuel/intergenic/PCHIC_reass_plots.pdf"

#added columns

#Reass or not
data$reas[which(data$PC_as_RV_low>0)]<-"reassigned"
data$reas[which(data$PC_as_RV_low==0)]<-"NOT_reassigned"

#multiple reass
data$var_gene[which(data$PC_as_RV_low>1)]<-"1-many"
data$var_gene[which(data$PC_as_RV_low==1)]<-"1-1"
data$var_gene[which(data$PC_as_RV_low==0)]<-"NA"
  
#only reassigned subset
re_data<-subset(data, data$reas=="reassigned")
#only multiple reass subset
mul_data<-subset(data,data$var_gene=="1-many")
#only_multiple reass and same chicago (diff gene hi low)
RVIS_choice<-subset(data,data$var_gene=="1-many" & as.character(data$PC_gene_RV_hi)!=as.character(data$PC_gene_RV_low))
#nuova colonna per vedere se lo score é salito con RVIS o no 
RVIS_choice<-RVIS_choice[complete.cases(RVIS_choice$NCsore_RV_hi) & complete.cases(RVIS_choice$NCsore_RV_low), ] 
RVIS_choice$direction[which(RVIS_choice$NCsore_RV_hi<RVIS_choice$NCsore_RV_low)]<-"opposite"
RVIS_choice$direction[which(RVIS_choice$NCsore_RV_hi>RVIS_choice$NCsore_RV_low)]<-"same"
#only single reass subset
sin_data<-subset(data,data$var_gene=="1-1")
#only variants that have higher NC score in RVIS low respect to RVIS HIgh (only NC score >0.1)
other_feature<-subset(RVIS_choice, as.numeric(RVIS_choice$NCsore_RV_hi)<as.numeric(RVIS_choice$NCsore_RV_low))
other_feature<-subset(other_feature,other_feature$NCsore_RV_low>0.1)
#wilcox.test(only_new$standard_NCscore, only_new$PCICH_NCscore, alternative = "less")

###############################################################################################

#graphics

#bar chart reassignation
f<-ggplot(data, aes(x=data$reas, fill=var_gene))+geom_bar()
f<-f+ annotate("text", x=1, y=nrow(data[data$reas=="NOT_reassigned",])-150, label = nrow(data[data$reas=="NOT_reassigned",]) , color="black", size=5 )
f<-f+ annotate("text", x=2, y=nrow(data[data$reas=="reassigned",])-150, label = nrow(data[data$var_gene=="1-1",]) , color="black", size=5 )
f<-f+ annotate("text", x=2, y=nrow(na.omit(data[data$var_gene=="1-many",]))-100, label = nrow(data[data$var_gene=="1-many",]) , color="black", size=5 )
f<-f+ labs(title = "Variant gene reassignation with PCHIC",  x = "Reassignation results",y="SNVs", 
           subtitle = paste(as.character(length(which(data$PC_as_RV_low>0)))," gene reassigned (",as.character(nrow(subset(data,data$PC_gene_RV_hi!="NOT_FOUND"))-nrow(subset(data,data$ANNOVAR_gene!="NOT_FOUND")))," gene orphan variants recovered)", sep = ""))
f

#scatterplot standard vs RVIS_hi

p<-ggplot(re_data, aes(x=re_data$NC_score, y=re_data$NCsore_RV_hi, color=var_gene))
p<-p+ geom_segment(aes(x = 0, y = 0, xend = 0.9, yend = 0.9), color="grey", size=0.1)
p<-p+ geom_point()
p<-p+labs(title = "Standard vs PCHIC assignation NCBoost score", subtitle = "NCBoost scores vary in both direction",
            x = "NCBoost score (standard)", y= "NCBoost score (PCHIC)")
p

#scatterplot RVIS_hi vs RVIS_low

t<-ggplot(mul_data, aes(x=mul_data$NCsore_RV_low, y=mul_data$NCsore_RV_hi, color=var_gene))
t<-t+ geom_segment(aes(x = 0, y = 0, xend = 0.9, yend = 0.9), color="grey", size=0.1)
t<-t+ geom_point()
t<-t+ theme(legend.position = "none")
t<-t+labs(title = "Effect of gene choice based RVIS score",
          x = "NCBoost score (RVIS low)", y= "NCBoost score (RVIS high)")
t

t1<-ggplot(mul_data, aes(x=mul_data$NCsore_RV_low, y=mul_data$NCsore_RV_hi, color=var_gene))
t1<-t1+ geom_segment(aes(x = 0, y = 0, xend = 0.9, yend = 0.9), color="grey", size=0.1)
t1<-t1+ geom_point()
t1<-t1+ geom_point(data=other_feature, aes(x=other_feature$NCsore_RV_low, y=other_feature$NCsore_RV_hi), colour="black")
t1<-t1+ theme(legend.position = "none")
t1<-t1+labs(title = "Effect of gene choice based RVIS score",
          x = "NCBoost score (RVIS low)", y= "NCBoost score (RVIS high)")
t1



#boxplot only pathogenic NCscore hi vs low RVS

bb<-boxplot(RVIS_choice$NCsore_RV_hi[RVIS_choice$NCsore_RV_hi>0.3], RVIS_choice$NCsore_RV_low[RVIS_choice$NCsore_RV_low>0.3])

#scatter plot of all gene feature in variants with lower NC score in higher RVIS genes 

s1<-ggplot(other_feature, aes(x=other_feature$pLI_RV_low, y=other_feature$pLI_RV_hi))+geom_point()
s1<-s1 + coord_fixed(ratio = 1)
s1<-s1+ geom_abline(intercept = 0, slope = 1)
s1<-s1 + labs(title = "pLI",
              x = "LOW RVIS", y= "High RVIS")

s2<-ggplot(other_feature, aes(x=other_feature$familyMemberCount_RV_low, y=other_feature$familyMemberCount_RV_hi))+geom_point()
s2<-s2 + coord_fixed(ratio = 1)
s2<-s2+ geom_abline(intercept = 0, slope = 1)
s2<-s2 + labs(title = "familyMemberCount",
              x = "LOW RVIS", y= "High RVIS")

s3<-ggplot(other_feature, aes(x=other_feature$ncRVIS_RV_low, y=other_feature$ncRVIS_RV_hi))+geom_point()
s3<-s3 + coord_fixed(ratio = 1)
s3<-s3+ geom_abline(intercept = 0, slope = 1)
s3<-s3 + labs(title = "ncRVIS",
              x = "LOW RVIS", y= "High RVIS")

s4<-ggplot(other_feature, aes(x=other_feature$ncGERP_RV_low, y=other_feature$ncGERP_RV_hi))+geom_point()
s4<-s4 + coord_fixed(ratio = 1)
s4<-s4+ geom_abline(intercept = 0, slope = 1)
s4<-s4 + labs(title = "ncGERP",
              x = "LOW RVIS", y= "High RVIS")

s5<-ggplot(other_feature, aes(x=other_feature$RVIS_percentile_RV_low, y=other_feature$RVIS_percentile_RV_hi))+geom_point()
s5<-s5 + coord_fixed(ratio = 1)
s5<-s5+ geom_abline(intercept = 0, slope = 1)
s5<-s5 + labs(title = "RVIS_percentile",
              x = "LOW RVIS", y= "High RVIS")

s6<-ggplot(other_feature, aes(x=other_feature$slr_dnds_RV_low, y=other_feature$slr_dnds_RV_hi))+geom_point()
s6<-s6 + coord_fixed(ratio = 1)
s6<-s6+ geom_abline(intercept = 0, slope = 1)
s6<-s6 + labs(title = "slr_dnds",
              x = "LOW RVIS", y= "High RVIS")

s7<-ggplot(other_feature, aes(x=other_feature$GDI_RV_low, y=other_feature$GDI_RV_hi))+geom_point()
s8<-s8+ geom_abline(intercept = 0, slope = 1)
s7<-s7 + labs(title = "GDI",
              x = "LOW RVIS", y= "High RVIS")

s8<-ggplot(other_feature, aes(x=other_feature$gene_age_RV_low, y=other_feature$gene_age_RV_hi))+geom_point()
s8<-s8 + coord_fixed(ratio = 1)
s8<-s8+ geom_abline(intercept = 0, slope = 1)
s8<-s8 + labs(title = "gene_age",
              x = "LOW RVIS", y= "High RVIS")

figure <- ggarrange(s1,s2,s3,s4,s5,s6,s7,s8, ncol = 2, nrow = 4, common.legend = TRUE)
annotate_figure(figure, top = text_grob("All gene features"))



########################################################################################################################

#pdf

pdf(res_file)
print(f)
print(p)
print(t)
print(t1)
print(figure)
dev.off()
dev.off()