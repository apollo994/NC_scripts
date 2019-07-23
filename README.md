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
+ bug fix


## How to run the pipelines

#### If you are working on the farm
The path to reach NCBoost on the farm is `/nfs/team151/fz3/NCBoost`, all the scripts are in `NCBoost/ncboost_scripts`.
All the commands described above may be run from the root NCBoost folder.

Some files are just linked in the NCBoost root directory, their physical location is:
+ `NCBoost_features -> /lustre/scratch119/humgen/teams/soranzo/users/fz3/NCBoost/NCBoost_features`
+ `python libraries -> /nfs/team151/fz3/pyPack`
+ `R libraries -> /nfs/team151/fz3/RPack`
+ `reference genome -> /lustre/scratch115/teams/soranzo/projects/MS_GWAS_txt_tables/reference_files/Homo_sapiens.GRCh37.dna.fa`

#### If you are starting from zero
Functioning NCBoost system needs to be installed on your machine to use these pipelines, learn how to do that [here](https://github.com/RausellLab/NCBoost).

Then, clone this repository in NCBoost root folder and copy all the scripts present in `NCtools/NCtools_scripts/` into `NCBoost_scripts/` folder.

IMPORTANT, `clean_annovar.py` will be replaced with the bug fixed version. 

The additional dependecy are [samtools](http://www.htslib.org/doc/samtools.html) and human reference genome sequence that you can download from [ensambl](https://grch37.ensembl.org/index.html) ftp server:`ftp://ftp.ensembl.org/pub/grch37/current/fasta/homo_sapiens/dna/`.

### Annotation pipelines

Run this script for the standard annotation and scoring pipeline provided by NCBoost ([bug fixed](https://github.com/apollo994/NCtools/tree/master/NCtool_scripts)).
```
./NCBoost_scripts/ncboost_annotate.sh /path/to/inF.tsv /path/to/outF.tsv
```

\
Run this script to annotate and score INDELS variants using a representative SNVs.
The additional argument is the reference genome, for more detail see [here](https://github.com/apollo994/NCtools/tree/master/NCtool_scripts)
If you are working on the farm you will find a reference geneome in `/NCBoost/ref_genome`.
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
If you are working on the farm you will find PCHIC intercation data in `/NCBoost/PCHIC_data`.

### Visualisation pipeline

Run this script to generate a .wig file to display patogenicity score of a region of interest.
The first argument defines the genomic region (es. `13:32315086-32400266`), the second is the reference genome and the third (optional) can be use to assign a name to the track.
An example of the resulting track is given below (intron region of gene IKZF1). 

```
./NCBoost_scripts/ncboost_visual.sh chr:start-end referenece.fa sample
```
![alt text](https://github.com/apollo994/NCtools/blob/master/pathogenicity_track_example.png)


#### Versions

The original NCBoost1.0 scripts and files were download on 11th of April 2019 and my project took place in the following 4 month.

+ NCBoost1.0
+ Homo sapien reference genome GRCh37 release 87 from ENSEMBL
+ ANNOVAR latest version (2018-Apr-16)
For NCBoost libraries version and dependencies have a look [here](https://github.com/apollo994/NCBoost/blob/master/libraries.txt) 
  
## References

1: Caron et al. (2019). NCBoost classifies pathogenic non-coding variants in Mendelian diseases through supervised learning on purifying selection signals in humans. Genome Biology. 20(1), 20:32.

2: Javierre et al.(2016). Lineage-Specific Genome Architecture Links Enhancers and Non-coding Disease Variants to Target Gene Promoters. Cell, 167(5), 1369-1384.e19.

## Contact

Please address comments and questions about NCtool to fabio.zanarello.94@gmail.com

## License

NCtools scripts are available under the Apache License 2.0. 

Read more about [here](http://www.apache.org/licenses/LICENSE-2.0)
