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

data<-read.table("../../dataset_and_res/manuel/intergenic/standard_up_merge.txt", sep = "\t", header = T)
data[data=='NA'] <- "NA"
my_col=colnames(data)
my_col=my_col[-1]
data$NCsore_1<-NULL
colnames(data)<-my_col


res_file="../../dataset_and_res/manuel/intergenic/standard_up_merge.txt"

#added columns

#column to see if the NC_score is higher lower or equel
data$score_change[which(data$NC_score == data$NCsore_1)]<-"EQ"
data$score_change[which(data$NC_score > data$NCsore_1)]<-"DW"
data$score_change[which(data$NC_score < data$NCsore_1)]<-"UP"
data$score_change<-as.factor(data$score_change)

#column to see if the gene name changes
data$gene_change<-ifelse(as.character(data$ANNOVAR_gene)!=as.character(data$PC_gene_1),"New","Same")
data$gene_change<-as.factor(data$gene_change)

#column to see how many new genes has been recovered
data$recovered<-ifelse(data$ANNOVAR_gene=="NOT_FOUND" & data$PC_gene_1!="NOT_FOUND","1","0")
data$recovered<-as.factor(data$recovered)

#column to see if the RVIS score is higher lower or equel
data$RCVIS_change[which(data$ncRVIS == data$ncRVIS_1)]<-"EQ"
data$RCVIS_change[which(data$ncRVIS > data$ncRVIS_1)]<-"DW"
data$RCVIS_change[which(data$ncRVIS < data$ncRVIS_1)]<-"UP"
data$RCVIS_change<-as.factor(data$RCVIS_change)

#table with only position with new assignation, columns are the two scores
#sub_PC<-data.frame(subset(data$PCICH_NCscore,data$gene_change=="New"))
#sub_PC$method<-"PC"


#sub_NC<-data.frame(subset(data$standard_NCscore,data$gene_change=="New"))
#sub_NC$method<-"NC"

#only_new<-subset(data, data$gene_change=="New")
#wilcox.test(only_new$standard_NCscore, only_new$PCICH_NCscore, alternative = "less")

###############################################################################################

#graphics

#scatterplot precomp vs new

p<-ggplot(data, aes(x=data$NC_score, y=data$NCsore_1,color=data$RCVIS_change))+geom_point()
#p<-p + stat_summary(fun.data=mean_cl_normal) + geom_smooth(method='glm')
p<-p + labs(title = "Standard vs new random assignation NCscore",
            x = "Standard score", y= "PCHIC score")


#barplot of the score value column
a<-ggplot(data, aes(x=data$score_change))+geom_bar(aes(fill=data$RCVIS_change))
a<-a + scale_fill_brewer(palette="Set1")
a<-a + annotate("text", x=1, y=nrow(na.omit(data[data$score_change=="DW",]))+150, label = nrow(na.omit(data[data$score_change=="DW",])) , color="black", size=5 )
a<-a + annotate("text", x=2, y=nrow(na.omit(data[data$score_change=="EQ",]))+150, label = nrow(na.omit(data[data$score_change=="EQ",])) , color="black", size=5 )
a<-a + annotate("text", x=3, y=nrow(na.omit(data[data$score_change=="UP",]))+150, label = nrow(na.omit(data[data$score_change=="UP",])) , color="black", size=5 )
a<-a + annotate("text", x=4, y=nrow(data[is.na(data$score_change),])+150, label = nrow(data[is.na(data$score_change),]) , color="black", size=5 )
a<-a + labs(title = "PCHIC gene reassignation result ", x= "Direction of SCORE change")

#all gene feature scatter

s1<-ggplot(data, aes(x=data$pLI, y=data$pLI_1,color=data$score_change))+geom_point()
s1<-s1 + labs(title = "pLI",
            x = "Standard", y= "PCHIC")

s2<-ggplot(data, aes(x=data$familyMemberCount, y=data$familyMemberCount_1,color=data$score_change))+geom_point()
s2<-s2 + labs(title = "familyMemberCount",
              x = "Standard", y= "PCHIC")

s3<-ggplot(data, aes(x=data$ncRVIS, y=data$ncRVIS_1,color=data$score_change))+geom_point()
s3<-s3 + labs(title = "ncRVIS",
              x = "Standard", y= "PCHIC")

s4<-ggplot(data, aes(x=data$ncGERP, y=data$ncGERP_1,color=data$score_change))+geom_point()
s4<-s4 + labs(title = "ncGERP",
              x = "Standard", y= "PCHIC")

s5<-ggplot(data, aes(x=data$RVIS_percentile, y=data$RVIS_percentile_1,color=data$score_change))+geom_point()
s5<-s5 + labs(title = "RVIS_percentile",
              x = "Standard", y= "PCHIC")

s6<-ggplot(data, aes(x=data$slr_dnds, y=data$slr_dnds_1,color=data$score_change))+geom_point()
s6<-s6 + labs(title = "slr_dnds",
              x = "Standard", y= "PCHIC")

s7<-ggplot(data, aes(x=data$GDI, y=data$GDI_1,color=data$score_change))+geom_point()
s7<-s7 + labs(title = "GDI",
              x = "Standard", y= "PCHIC")

s8<-ggplot(data, aes(x=data$gene_age, y=data$gene_age_1,color=data$score_change))+geom_point()
s8<-s8 + labs(title = "gene_age",
              x = "Standard", y= "PCHIC")

figure <- ggarrange(s1,s2,s3,s4,s5,s6,s7,s8,
                    ncol = 2, nrow = 4, common.legend = TRUE)
figure


########################################################################################################################

#pdf


pdf(res_file)
print(p)
print(a)
print(figure)
dev.off()