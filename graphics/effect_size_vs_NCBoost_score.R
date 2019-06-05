#script to plot the correlation between effect size and NCBoost score

library("ggplot2")

###############################################################################################

#data

data<-read.table("my_vcf_updated_singleline.txt", sep = "\t", header = T)
data[data=='NA'] <- NA

#position tested by NCBoost
NCscore<-data[!is.na(data$NCBoost_Score),]
NCscore_size=paste("N=",nrow(NCscore), sep = "")
#position tested by NCBoost and rare (MAF<=0.05)
NCscore_rare<-NCscore[NCscore$maf<=0.05,]
NCscore_rare<-NCscore_rare[complete.cases(NCscore_rare), ]
NCscore_rare_size=paste("N=",nrow(NCscore_rare), sep = "")
#NCboost score of position with MAF<0.01 and >=0.01
scores_rare<-NCscore[NCscore$maf<0.01,]
scores_rare<-scores_rare[complete.cases(scores_rare),]
scores_rare<-scores_rare$NCBoost_Score
size_scores_rare<-paste("N=",length(scores_rare), sep = "")

scores_NOT_rare<-NCscore[NCscore$maf>=0.01,]
scores_NOT_rare<-scores_NOT_rare[complete.cases(scores_NOT_rare),]
scores_NOT_rare<-scores_NOT_rare$NCBoost_Score
size_scores_NOT_rare<-paste("N=",length(scores_NOT_rare), sep = "")

rare = data.frame(group = "MAF<0.01", value = scores_rare)
NOT_rare = data.frame(group = "MAF>=0.01", value = scores_NOT_rare)
rare_NOT_rare=rbind(rare,NOT_rare)

#test the rare vs NOT_rare differences 
pv=signif(ks.test(scores_rare,scores_NOT_rare, alternative = "less")$p.value,4)
pv=paste("pv=",pv, sep="")

#position NOT tested by NCBoost
Not_NCscore<- data[is.na(data$NCBoost_Score),]
rare_Not_NCscore<-Not_NCscore[Not_NCscore$maf<=0.01,]
rare_Not_NCscore<-rare_Not_NCscore[complete.cases(rare_Not_NCscore$maf), ]


###############################################################################################

#graphics

#Scatterplot of pathogenicity vs beta in NCscore table
p<-ggplot(NCscore, aes(x=NCscore$beta, y=NCscore$NCBoost_Score)) +geom_point()
p<-p + annotate("text", x=1, y=0.8, label = NCscore_size , color="black", size=5 )
p<-p + labs(title = "Positions precalculated by NCBoost",
            subtitle = "Plot of beta vs pathogenicity",
            x = "Effect size", y= "Pathogenicity score")

#Scatterplot of pathogenicity vs beta in NCscore table
d<-ggplot(NCscore_rare, aes(x=NCscore_rare$maf, y=NCscore_rare$NCBoost_Score)) +geom_point()
d<-d + annotate("text", x=0.045, y=0.8, label = NCscore_rare_size , color="black", size=5 )
d<-d + labs(title = "Positions precalculated by NCBoost",
            subtitle = "Plot of MAF vs pathogenicity (MAF<0.05)",
            x = "MAF", y= "Pathogenicity score")

#boxplot of patogenicity distribution of position with MAF<0.01 respect all the other
e<-ggplot(rare_NOT_rare, aes(x=factor(group), y=value)) + geom_boxplot(fill=c("red","slateblue"), alpha=0.2)
e<-e + annotate("text", x=c(1.2), y=(0.2), label = size_scores_rare , color="black", size=4 )
e<-e + annotate("text", x=c(2.2), y=(0.12), label = size_scores_NOT_rare , color="black", size=4 )
e<-e + annotate("text", x=c(1.5), y=(0.88), label = "KS test" , color="black", size=5, fontface=2 )
e<-e + annotate("text", x=c(1.5), y=(0.85), label = pv , color="black", size=4 )
e<-e + labs(title = "Positions precalculated by NCBoost",
            subtitle = "Distribution of rare and not rare patogenicity score",
            x = "MAF", y= "Pathogenicity score")








