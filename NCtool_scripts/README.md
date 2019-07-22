## NCtools scripts

Here you will find a brief description of the modification done to the pipeline to score and annotate INDELS and to use chromatin-chromatin interaction for gene assignment.
The last section describes the pipeline for generate a .wig file for pathogenicity score visualization on the genome browser.

### INDELS annotation

```
./NCBoost_scripts/ncboost_annotate_INDELS.sh /path/to/inF.tsv /path/to/outF.tsv \
                                             /pathto/reference_genome.fa
```

The strategy in use to annotate and score INDELS consists in convert the INDELS in a a list of representative SNVs.
This task is performed by `prepare_INDELS_from_input.py` and two examples (insertion and deletion) of the conversion are given below

#### INSERTION
```
chr start   end   ref  alt
1   12589   12589   G   ATT
```
is converted to SNV representing the following position:
```
chr start   end   ref  alt
1   12590   12590   A   G
```
The same is done for deletion.

#### DELETION
```
chr start   end   ref  alt
1   23345   23345   TTA   T
```
to:
```
chr start   end   ref  alt
1   23346   23346   G   A
```
The reference allele is retrieved using `samtools faidx` and the reference genome (an indexed version of the fasta file has to be present in the same folder), while the alternative is chosen randomly since is not relevant for the analysis.
The outputs of the script are:
+ `file_name.only_INDELS` is the representative SNVs file use for compute the score
+ `file_name.recovery_dict` describes INDELS to SNVs correspondence and is used in the last step by `INDELS_recovery_from_res.py` to re-covert SNVs in original INDELS


### Chromatin-Chromatin gene assignment

```
./NCBoost_scripts/ncboost_annotate_PCHIC.sh /pathto/inF.tsv /pathto/outF.tsv \
                                            /PCHIC_data.txt \
                                            5
```

This annotation pipeline calls `clean_annovar_PCIHC.py` instead of `clean_annovar.py` in order to assign the chromatin-chromatin interaction gene to the variant instead of the closer in linear space as done by ANNOVAR.
The gene-variant interactions are defined in `PCHIC_data.txt` with a plain tex tab separated file with the following columns (this header is mandatory):

```
var ENS sym max
chr1_1692321_T_C  ENSG00000078369 GNB1  9.535
chr1_1692321_T_C  ENSG00000231050 RP1-140A9.1 15.55
chr7_2231966_T_C  ENSG00000203301 AL590822.1  5.330
chr10_231976_G_C  ENSG00000162585 C1orf86 5.330
```

where `var` is the position of the variant, `ENS` and `sym` are respectively the ensembl and symbol ID of the interacting gene and `max` is the chicago score of the interaction.
The last argument defines the chicago score threshold to consider the interaction.
The chromatin-chromatin interaction assignment follows these rules:
+ Interactions lower than the threshold are not taken into account
+ If multiple genes interact with the same variant the stronger interaction is chosen
+ In case of equal chicago score the gene with the higher ncRVIS score is chosen
+ If there is no PCHiC interaction for the variant or the above rules are not satisfied the closer gene in linear space is assigned

During the assignment process is also created a temporary file called `file_name.PC_res` that contains the number of genes interacting with each variant.
The file is used at the end of the pipeline by `add_PC_stat.py` to add an extra column to the final result table in which the number of interaction per variants are displayed. Only interaction with chicago score higher than the threshold are taken into account.


### Visualization pipeline

```
./NCBoost_scripts/ncboost_viual.sh chr:start-end referenece.fa sample
```

The aim of this pipeline is to generate a visualizable pathogenicity score track on the genome browser.
Firstly a folder to store the result is created, then the `get_fake_SNVs.py` script generates a NCBoost input like file with all the position defined in `chr:start-end` using the `referenece.fa` (an indexed version of the .fa file has to be present in the same folder).
Then, NCBoost is called to compute the pathogenicity score for that positions and `convert_NC_to_wig.py` generates a .wig file ready to be uploaded on a genome browser.
Both ensambl and UCSC genome browsers can be used, the second is recommended since allows to display additional features present in the .wig file.

If you are not familiar with custom track have a look on the [ensembl](https://www.ensembl.org/info/website/upload/index.html) and [UCSC](https://genome.ucsc.edu/goldenPath/help/customTrack.html) tutorial pages.
