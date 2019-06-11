#script to compare standard and PCICH score values of intergenic position

library("ggplot2")
library("gridExtra")
library("grid")
library("RColorBrewer")
library("Hmisc")
library("gtools")


###############################################################################################

#data

data<-read.table("../../PCHIC_exp/standard_PCICH_comparison/standard_PCHIC_merge.txt", sep = "\t", header = T, row.names = 1)
data[data=='NA'] <- "NA"
colnames(data)<-c("ANN_gene","standard_NCscore","PCHIC_gene","PCICH_NCscore")

data[5]<-NULL

res_file="standard_vs_PCHIC_plots.pdf"

#added columns

#columns to see differences between standard and PCICH value
data$score_change<-ifelse(data$standard_NCscore<data$PCICH_NCscore,"UP",ifelse(data$standard_NCscore==data$PCICH_NCscore, "EQ", "DW"))

#column to see if the gene name changes
data$gene_change<-ifelse(as.character(data$ANN_gene)!=as.character(data$PCHIC_gene),"New","Same")

#column to see how many new genes has been recovered
data$recovered<-ifelse(data$ANN_gene=="NOT_FOUND" & data$PCHIC_gene!="NOT_FOUND","1","0")

#table with only position with new assignation, columns are the two scores
#sub_PC<-data.frame(subset(data$PCICH_NCscore,data$gene_change=="New"))
#sub_PC$method<-"PC"


#sub_NC<-data.frame(subset(data$standard_NCscore,data$gene_change=="New"))
#sub_NC$method<-"NC"

only_new<-subset(data, data$gene_change=="New")
wilcox.test(only_new$standard_NCscore, only_new$PCICH_NCscore, alternative = "less")

###############################################################################################

#graphics

#scatterplot precomp vs new

p<-ggplot(data, aes(x=data$standard_NCscore, y=data$PCICH_NCscore))+geom_point()#+
 #stat_summary(fun.data=mean_cl_normal) + geom_smooth(method='glm')
p<-p + labs(title = "Standard vs new assignation NCscore",
            x = "Standard score", y= "PCHIC score")

#barplot of the score value column
a<-ggplot(data, aes(x=data$score_change))+geom_bar(aes(fill=gene_change))
a<-a + scale_fill_brewer(palette="Set1")
a<-a + annotate("text", x=1, y=nrow(na.omit(data[data$score_change=="DW",]))+150, label = nrow(na.omit(data[data$score_change=="DW",])) , color="black", size=5 )
a<-a + annotate("text", x=2, y=nrow(na.omit(data[data$score_change=="EQ",]))+150, label = nrow(na.omit(data[data$score_change=="EQ",])) , color="black", size=5 )
a<-a + annotate("text", x=3, y=nrow(na.omit(data[data$score_change=="UP",]))+150, label = nrow(na.omit(data[data$score_change=="UP",])) , color="black", size=5 )
a<-a + annotate("text", x=4, y=nrow(data[is.na(data$score_change),])+150, label = nrow(data[is.na(data$score_change),]) , color="black", size=5 )
a<-a + labs(title = "PCHIC gene reassignation result ", x= "Direction of SCORE change")

#wilcox.test(x, y, alternative = "two.sided")
