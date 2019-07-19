# Fabio Zanarello, Sanger Institute, 2019

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

data<-read.table("manuel_run_and_precomp.txt", sep = "\t", header = T)
data[data=='NA'] <- NA

plot_file="manuel_plots.pdf"
tab_file="manuel_run_and_precomp_formatted.txt"

#added columns

# -score_value (0=none, 1=only precomputed, 2=only new value, 3=both)
data$score_value<-ifelse(is.na(data$NCBoost) & is.na(data$precomp_NCBoost_score), "0",
                         (ifelse(data$NCBoost>0 & is.na(data$precomp_NCBoost_score), "1",
                                 (ifelse(is.na(data$NCBoost) & data$precomp_NCBoost_score>0,"2","3")))))
data$score_value<-as.factor(data$score_value)

# -new vs old REGION (discordant,concordant)
data$annovar_annotation<-as.character(data$annovar_annotation)
data$precomp_region<-as.character(data$precomp_region)
data$old_new_region<-ifelse(data$annovar_annotation==data$precomp_region,"concordant","discordant")
data$old_new_region<-as.factor(data$old_new_region)

# -new vs old closest gene name (discordant,concordant)
data$closest_gene_name<-as.character(data$closest_gene_name)
data$precomp_closest_gene_name<-as.character(data$precomp_closest_gene_name)
data$old_new_gene<-ifelse(data$closest_gene_name==data$precomp_closest_gene_name,"concordant","discordant")
data$old_new_gene<-as.factor(data$old_new_gene)

# -new vs old NCScore value (discordant,concordant)
data$NCBoost<-as.character(data$NCBoost)
data$precomp_NCBoost_score<-as.character(data$precomp_NCBoost_score)
data$old_new_score<-ifelse(data$NCBoost==data$precomp_NCBoost_score,"concordant","discordant")
data$old_new_score<-as.factor(data$old_new_score)

data$NCBoost<-as.numeric(data$NCBoost)
data$precomp_NCBoost_score<-as.numeric(data$precomp_NCBoost_score)


###############################################################################################

#graphics

#scatterplot precomp vs new

p<-ggplot(data, aes(x=data$NCBoost, y=data$precomp_NCBoost_score))+geom_point()+
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


pdf(plot_file)
print (p)
print (a)
dev.off()


##reformatting for print############################################

data_d<-data[!(is.na(data$NCBoost) & is.na(data$precomp_NCBoost_score)),]

data_d$score_value<-NULL
data_d$old_new_region<-NULL
data_d$old_new_gene<-NULL
data_d$old_new_score<-NULL

data_d$NC_final_score<-ifelse(!is.na(data_d$NCBoost),data_d$NCBoost, data_d$precomp_NCBoost_score)

write.table(data_d, tab_file, sep="\t", quote = F, row.names = F)
