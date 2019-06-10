# Barthelemy Caron, Clinical BioInformatics Lab, IMAGINE

# create a folder to gather the downloaded data
storage_folder='NCBoost_features'
mkdir $storage_folder

### Download CADD v1.3 prescored whole genome

bsub -G team151 -o cadd_1.out -M 4000 -J cadd_1 \
      -R"select[mem>=4000] rusage[mem=4000] span[hosts=1]" -n1 -q normal \
      -- "wget --directory-prefix=$storage_folder http://krishna.gs.washington.edu/download/CADD/v1.3/whole_genome_SNVs_inclAnno.tsv.gz"

bsub -G team151 -o cadd_2.out -M 4000 -J cadd_2 \
      -R"select[mem>=4000] rusage[mem=4000] span[hosts=1]" -n1 -q normal \
      -- "wget --directory-prefix=$storage_folder http://krishna.gs.washington.edu/download/CADD/v1.3/whole_genome_SNVs_inclAnno.tsv.gz.tbi"


### Download 1000 genome Project Tajima's D, FuLi's F* and D*

bsub -G team151 -o gen_proj1.out -M 4000 -J gen_proj1 \
      -R"select[mem>=4000] rusage[mem=4000] span[hosts=1]" -n1 -q normal \
      -- "wget --directory-prefix=$storage_folder http://hsb.upf.edu/hsb_data/positive_selection_NAR2013/FuLisD_CEU.whole_genome.pvalues.gz"

bsub -G team151 -o gen_proj2.out -M 4000 -J gen_proj2 \
      -R"select[mem>=4000] rusage[mem=4000] span[hosts=1]" -n1 -q normal \
      -- "wget --directory-prefix=$storage_folder http://hsb.upf.edu/hsb_data/positive_selection_NAR2013/FuLisD_CHB.whole_genome.pvalues.gz"

bsub -G team151 -o gen_proj3.out -M 4000 -J gen_proj3 \
      -R"select[mem>=4000] rusage[mem=4000] span[hosts=1]" -n1 -q normal \
      -- "wget --directory-prefix=$storage_folder http://hsb.upf.edu/hsb_data/positive_selection_NAR2013/FuLisD_YRI.whole_genome.pvalues.gz"

bsub -G team151 -o gen_proj4.out -M 4000 -J gen_proj4 \
      -R"select[mem>=4000] rusage[mem=4000] span[hosts=1]" -n1 -q normal \
      -- "wget --directory-prefix=$storage_folder http://hsb.upf.edu/hsb_data/positive_selection_NAR2013/FuLisF_CEU.whole_genome.pvalues.gz"

bsub -G team151 -o gen_proj5.out -M 4000 -J gen_proj5 \
      -R"select[mem>=4000] rusage[mem=4000] span[hosts=1]" -n1 -q normal \
      -- "wget --directory-prefix=$storage_folder http://hsb.upf.edu/hsb_data/positive_selection_NAR2013/FuLisF_CHB.whole_genome.pvalues.gz"

bsub -G team151 -o gen_proj6.out -M 4000 -J gen_proj6 \
      -R"select[mem>=4000] rusage[mem=4000] span[hosts=1]" -n1 -q normal \
      -- "wget --directory-prefix=$storage_folder http://hsb.upf.edu/hsb_data/positive_selection_NAR2013/FuLisF_YRI.whole_genome.pvalues.gz"

bsub -G team151 -o gen_proj7.out -M 4000 -J gen_proj7 \
      -R"select[mem>=4000] rusage[mem=4000] span[hosts=1]" -n1 -q normal \
      -- "wget --directory-prefix=$storage_folder http://hsb.upf.edu/hsb_data/positive_selection_NAR2013/TajimasD_CEU.whole_genome.pvalues.gz"


bsub -G team151 -o gen_proj8.out -M 4000 -J gen_proj8 \
      -R"select[mem>=4000] rusage[mem=4000] span[hosts=1]" -n1 -q normal \
      -- "wget --directory-prefix=$storage_folder http://hsb.upf.edu/hsb_data/positive_selection_NAR2013/TajimasD_CHB.whole_genome.pvalues.gz"

bsub -G team151 -o gen_proj9.out -M 4000 -J gen_proj9 \
      -R"select[mem>=4000] rusage[mem=4000] span[hosts=1]" -n1 -q normal \
      -- "wget --directory-prefix=$storage_folder http://hsb.upf.edu/hsb_data/positive_selection_NAR2013/TajimasD_YRI.whole_genome.pvalues.gz"


### Download CDTS score

bsub -G team151 -o CDTS.out -M 4000 -J CDTS \
      -R"select[mem>=4000] rusage[mem=4000] span[hosts=1]" -n1 -q normal \
      -- "wget --directory-prefix=$storage_folder http://www.hli-opendata.com/noncoding/Pipeline/CDTS_diff_perc_coordsorted_gnomAD_N15496_hg19.bed.gz"


### Download mean DAF and HET from GWAVA

bsub -G team151 -o GWAVA.out -M 4000 -J GWAVA \
      -R"select[mem>=4000] rusage[mem=4000] span[hosts=1]" -n1 -q normal \
      -- "wget --directory-prefix=$storage_folder ftp://ftp.sanger.ac.uk/pub/resources/software/gwava/v1.0/source_data/1kg/daf.bed.gz"

bsub -G team151 -o GWAVA2.out -M 4000 -J GWAVA2 \
      -R"select[mem>=4000] rusage[mem=4000] span[hosts=1]" -n1 -q normal \
      -- "wget --directory-prefix=$storage_folder ftp://ftp.sanger.ac.uk/pub/resources/software/gwava/v1.0/source_data/1kg/het_rates.bed.gz"


### Download GnomAD indexed and corresponding index files

bsub -G team151 -o GnomAD.out -M 4000 -J GnomAD \
      -R"select[mem>=4000] rusage[mem=4000] span[hosts=1]" -n1 -q normal \
      -- "for chr in {1..22} X; do
      	wget --directory-prefix=$storage_folder https://storage.googleapis.com/gnomad-public/release/2.0.2/vcf/genomes/gnomad.genomes.r2.0.2.sites.chr$chr.vcf.bgz
      	wget --directory-prefix=$storage_folder https://storage.googleapis.com/gnomad-public/release/2.0.2/vcf/genomes/gnomad.genomes.r2.0.2.sites.chr$chr.vcf.bgz.tbi
        done"
