# NCtools


This repository contains a summary of the work done during my traineeship at Sanger Institute, UK. 

The aim of this project is to implement some new features to [NCBoost](https://github.com/RausellLab/NCBoost), machine learning model (gradient tree boosting) designed to assign pathogenicity score to non-coding genetic single nucleotide variants (SNVs) in humans. The model has been trained by the authors using experimentally validated non-coding pathogenic variants and the prediction is based on features that belong to the following categories:

+ Interspecies conservation
+ Recent and ongoing selection signals in humans
+ Gene-based features
+ Sequence context
+ Epigenetic features

In this context, during my project, I developed modified versions of the pipeline to:

+ annotate and score INDELS
+ implement chromatin-chroma interaction data during gene assignment step
+ visualize the score on genome browser interfaces

To use these pipelines a functioning NCBoost system needs to be installed and functioning, learn how to do that [here](https://github.com/RausellLab/NCBoost).
The only additional dependecy are [samtools](http://www.htslib.org/doc/samtools.html) and a the human reference genome sequence that you can get [here](ftp://ftp.ensembl.org/pub/grch37/current/fasta/homo_sapiens/dna/)  
 
In the following section are presented descriptions of the pipelines, how to use them and run them as a job on the Sanger Institute HPC cluster.


## Annotation pipelines:

```
./NCBoost_scripts/ncboost_annotate.sh /pathto/inF.tsv /pathto/outF.tsv 
```
Descrizione veloce 

```
./NCBoost_scripts/ncboost_annotate_INDELS.sh /pathto/inF.tsv /pathto/outF.tsv \
                                             /pathto/reference_genome.fasta
```
Descrizione veloce 

```
./NCBoost_scripts/ncboost_annotate_PCHIC.sh /pathto/inF.tsv /pathto/outF.tsv \
                                            /PCHIC_data.txt \
                                            5
```
Descrizione veloce

## Visualisation pipelines:

```
./NCBoost_scripts/ncboost_viual.sh chr:start-end referenece.fa sample
```
Descrizione veloce 


## References

Caron et al; (2019). NCBoost classifies pathogenic non-codingvariants in Mendelian diseases throughsupervised learning on purifying selectionsignals in humans. Genome Biology,20:32 


## Contact
Please address comments and questions about NCtool to fabio.zanarello.94@gmail.com

## License

Prendi e porta casa
