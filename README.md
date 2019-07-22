# NCtools


This repository contains a summary of the work done during my traineeship at Sanger Institute, UK.

The aim of this project is to implement some new features to [NCBoost](https://github.com/RausellLab/NCBoost) annotation pipeline. NCBoost is a machine learning model (gradient tree boosting) designed to assign pathogenicity score to non-coding genetic single nucleotide variants (SNVs) in humans. The model has been trained by the authors using experimentally validated non-coding pathogenic variants and the prediction is based on features that belong to the following categories:

+ Interspecies conservation
+ Recent and ongoing selection signals in humans
+ Gene-based features
+ Sequence context
+ Epigenetic features

In this context, during my project, I developed modified versions of the pipeline to:

+ annotate and score INDELS
+ implement chromatin-chroma interaction data during gene assignment step
+ visualize the score on genome browser interfaces

The original NCBoost scripts and file were downloaded on 11th April 2019 and my project took place in the following 4 month.

## How to run the pipelines

#### If you are working on the farm

The path to reach NCBoost scripts on the farm is `/nfs/team151/fz3/NCBoost`, all of them have to be run from this folder as designed by NCBoost authors.

#### If you are starting from zero

To use these pipelines a functioning NCBoost system needs to be installed and functioning on your machine, learn how to do that [here](https://github.com/RausellLab/NCBoost).

Then add all the scripts present in `NCtools/NCtools_scripts/` to the NCBoost folder `NCBoost/NCBoost_scripts/`.

The additional dependecy are [samtools](http://www.htslib.org/doc/samtools.html) and a the human reference genome sequence that you download from [ensambl](https://grch37.ensembl.org/index.html) ftp server:`ftp://ftp.ensembl.org/pub/grch37/current/fasta/homo_sapiens/dna/`

In the following section are presented descriptions of the pipelines, how to use them and run them as a job on the Sanger Institute HPC cluster.


### Annotation pipelines

Run this script for the standard annotation and scoring pipeline provided by NCBoost (bug fixed).
```
./NCBoost_scripts/ncboost_annotate.sh /path/to/inF.tsv /path/to/outF.tsv
```

\
Run this script to annotate and score INDELS variants using a representative SNVs.
The additional argument is the reference genome, for more detail see [here](https://github.com/apollo994/NCtools/tree/master/NCtool_scripts)
```
./NCBoost_scripts/ncboost_annotate_INDELS.sh /path/to/inF.tsv /path/to/outF.tsv \
                                             /pathto/reference_genome.fa
```

\
Run this script to use chromatin-chromatin interaction data (PCHiC) as gene to variant assignment method.
The additional arguments are the interaction table and the interaction threshold, for more detail see [here](https://github.com/apollo994/NCtools/tree/master/NCtool_scripts)
```
./NCBoost_scripts/ncboost_annotate_PCHIC.sh /pathto/inF.tsv /pathto/outF.tsv \
                                            /PCHIC_data.txt \
                                            5
```


### Visualisation pipeline

Run this script to generate a .wig file to display patogenicity score of a region of interest.
The first argument defines the genomic region (es. `13:32315086-32400266`), the second is the reference genome and the third (option) can be use to assign a name to the track.
An example of the resulting track is given below (intron region of gene IKZF1). 

```
./NCBoost_scripts/ncboost_visual.sh chr:start-end referenece.fa sample
```
![alt text](https://github.com/apollo994/NCtools/blob/master/pathogenicity_track_example.png)


### NCBoost on the farm



  
## References

1: Caron et al. (2019). NCBoost classifies pathogenic non-coding variants in Mendelian diseases through supervised learning on purifying selection signals in humans. Genome Biology. 20(1), 20:32.

2: Javierre et al.(2016). Lineage-Specific Genome Architecture Links Enhancers and Non-coding Disease Variants to Target Gene Promoters. Cell, 167(5), 1369-1384.e19.

## Contact

Please address comments and questions about NCtool to fabio.zanarello.94@gmail.com

## License

NCtools scripts are available under the Apache License 2.0. 

Read more about [here](http://www.apache.org/licenses/LICENSE-2.0)
