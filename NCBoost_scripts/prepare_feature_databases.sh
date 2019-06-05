# Barthelemy Caron, Clinical BioInformatics Lab, IMAGINE 

folder='NCBoost_features'

### GWAVA - mean DAF, bed file, 0-based
gzip -d $folder/daf.bed.gz
bgzip $folder/daf.bed
tabix -p bed $folder/daf.bed.gz

echo 1/8
echo ---------------------------------------------

### GWAVA - mean HET, bed file, 0-based
gzip -d $folder/het_rates.bed.gz
bgzip $folder/het_rates.bed
tabix -p bed $folder/het_rates.bed.gz

echo 2/8
echo ---------------------------------------------

cd $folder/

### 1000GP FuLi's D* and F*, vcf, 1-based
## FuLisD
for data in CEU CHB YRI; do
  gzip -d FuLisD_$data.whole_genome.pvalues.gz
  cut -d" " -f2- FuLisD_$data.whole_genome.pvalues > FuLisD_$data.whole_genome.pvalues_tmp.vcf
  awk -v OFS="\t" '$1=$1' FuLisD_$data.whole_genome.pvalues_tmp.vcf > FuLisD_$data.whole_genome.pvalues.vcf
  bgzip FuLisD_$data.whole_genome.pvalues.vcf
  tabix -p vcf -S 1 -f FuLisD_$data.whole_genome.pvalues.vcf.gz
done

echo 3/8
echo ---------------------------------------------

## FuLisF
for data in CEU CHB YRI; do
  gzip -d FuLisF_$data.whole_genome.pvalues.gz
  cut -d" " -f2- FuLisF_$data.whole_genome.pvalues > FuLisF_$data.whole_genome.pvalues_tmp.vcf
  awk -v OFS="\t" '$1=$1' FuLisF_$data.whole_genome.pvalues_tmp.vcf > FuLisF_$data.whole_genome.pvalues.vcf
  bgzip FuLisF_$data.whole_genome.pvalues.vcf
  tabix -p vcf -S 1 -f FuLisF_$data.whole_genome.pvalues.vcf.gz
done

echo 4/8
echo ---------------------------------------------

## TajimasD
for data in CEU CHB YRI; do
  gzip -d TajimasD_$data.whole_genome.pvalues.gz
  cut -d" " -f2- TajimasD_$data.whole_genome.pvalues > TajimasD_$data.whole_genome.pvalues_tmp.vcf
  awk -v OFS="\t" '$1=$1' TajimasD_$data.whole_genome.pvalues_tmp.vcf > TajimasD_$data.whole_genome.pvalues.vcf
  bgzip TajimasD_$data.whole_genome.pvalues.vcf
  tabix -p vcf -S 1 -f TajimasD_$data.whole_genome.pvalues.vcf.gz
done

rm *pvalues
rm *tmp.vcf

cd ..

echo 5/8
echo ---------------------------------------------

### CDTS, bed, 0-based
gzip -d $folder/CDTS_diff_perc_coordsorted_gnomAD_N15496_hg19.bed.gz

echo 6/8
echo ---------------------------------------------

## recompressing as bgz
bgzip $folder/CDTS_diff_perc_coordsorted_gnomAD_N15496_hg19.bed

echo 7/8
echo ---------------------------------------------

## indexing
tabix -p bed $folder/CDTS_diff_perc_coordsorted_gnomAD_N15496_hg19.bed.gz

echo 8/8
echo ---------------------------------------------

