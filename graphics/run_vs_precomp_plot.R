#script to compare precomputed and new NCBoost values
#the input file have to be .tsv and need the followion information (or NA) 
# for each position:
# -NCBoost
# -precom_NCBoost_Score
# -annovar_annotation
# -precom_region
# -closest_gene_name
# -precom_closest_gene_name

library("ggplot2")
library("gridExtra")
library("grid")
library("RColorBrewer")
library("Hmisc")


###############################################################################################

#data

data<-read.table("manuel_run_precomp_merge.txt", sep = "\t", header = T)
data[data=='NA'] <- NA

res_file="manuel_plots.pdf"

#added columns

# -score_value (0=none, 1=only precomputed, 2=only new value, 3=both)
data$score_value<-ifelse(is.na(data$NCBoost) & is.na(data$precom_NCBoost_Score), "0",
                         (ifelse(data$NCBoost>0 & is.na(data$precom_NCBoost_Score), "1",
                                 (ifelse(is.na(data$NCBoost) & data$precom_NCBoost_Score>0,"2","3")))))
data$score_value<-as.factor(data$score_value)

# -new vs old REGION (discordant,concordant)
data$annovar_annotation<-as.character(data$annovar_annotation)
data$precom_region<-as.character(data$precom_region)
data$old_new_region<-ifelse(data$annovar_annotation==data$precom_region,"concordant","discordant")
data$old_new_region<-as.factor(data$old_new_region)

# -new vs old closest gene name (discordant,concordant)
data$closest_gene_name<-as.character(data$closest_gene_name)
data$precom_closest_gene_name<-as.character(data$closest_gene_name)
data$old_new_gene<-ifelse(data$closest_gene_name==data$precom_closest_gene_name,"concordant","discordant")
data$old_new_gene<-as.factor(data$old_new_gene)

# -new vs old NCScore value (discordant,concordant)
data$NCBoost<-as.character(data$NCBoost)
data$precom_NCBoost_Score<-as.character(data$precom_NCBoost_Score)
data$old_new_score<-ifelse(data$NCBoost==data$precom_NCBoost_Score,"concordant","discordant")
data$old_new_score<-as.factor(data$old_new_score)

data$NCBoost<-as.numeric(data$NCBoost)
data$precom_NCBoost_Score<-as.numeric(data$precom_NCBoost_Score)


###############################################################################################

#graphics

#scatterplot precomp vs new

p<-ggplot(data, aes(x=data$NCBoost, y=data$precom_NCBoost_Score))+geom_point()+
 stat_summary(fun.data=mean_cl_normal) + geom_smooth(method='glm')
p<-p + labs(title = "Run vs precomputed score results",
            x = "Run score", y= "Precomputet score")

#barplot of the score value column
a<-ggplot(data, aes(x=data$score_value))+geom_bar()
a<-a + scale_fill_brewer(palette="Set1")
a<-a + annotate("text", x=1, y=nrow(data[data$score_value==0,])+150, label = nrow(data[data$score_value==0,]) , color="black", size=5 )
a<-a + annotate("text", x=2, y=nrow(data[data$score_value==1,])+150, label = nrow(data[data$score_value==1,]) , color="black", size=5 )
a<-a + annotate("text", x=3, y=nrow(data[data$score_value==2,])+150, label = nrow(data[data$score_value==2,]) , color="black", size=5 )
a<-a + annotate("text", x=4, y=nrow(data[data$score_value==3,])+150, label = nrow(data[data$score_value==3,]) , color="black", size=5 )
a<-a + labs(title = "New vs precomputed score assignment",
            x = "0=no score, 1=only precomp, 2=only new, 3=both precomp and new")


pdf(res_file)
print (p)
print (a)
dev.off()






