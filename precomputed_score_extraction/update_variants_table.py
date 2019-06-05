#!/usr/bin/env python3

# this script readz a variants table and the results file of NCBoost scores/variants
# intersection (precomputed) from my_vcf_vs_NCBoost_precomp_tabix.sh temp file
# and add a new column with the NCBoost score if present or NA if not

import os
import sys
import argparse
from collections import defaultdict


def main():
    parser = argparse.ArgumentParser(description='My nice tool.')
    parser.add_argument('--vcf', metavar='INPUTFILE_1', help='The input vcf file.')
    parser.add_argument('--head', metavar="head", default="t",help='specify if the header is present in vcf, (t or f, def=t)')
    parser.add_argument('--inter_res', metavar='INPUTFILE_2', help='The result of the intersection.')
    parser.add_argument('--output', metavar='OUTPUTFILE', default="my_vcf_updated.txt", help='The output file.')
    args = parser.parse_args()


    #list in which store the vcf lines before to be written in the output
    intersection_result_dic={}

    # read line by line and add to dictionaty with key = coordinates
    # and value = the rest of the line

    with open (args.inter_res) as my_inter_res:
        for line in my_inter_res:
            my_line=line.split(" ")
            coord="chr"+my_line[0]+"_"+my_line[1]
            intersection_result_dic[coord]="\t"+my_line[2]+"\t"+my_line[3]+"\t"+my_line[4]+"\t"+my_line[5]

    # read line by line the vcf file and if the coordinates are present in the dictionary
    # add new columns with values, if not add NAs
    NAs="\tNA\tNA\tNA\tNA\n"
    uploaded_lines_list=[]

    with open (args.vcf) as my_vcf:
        #jump to the second line if there is the header
        if args.head=="t":
            head=my_vcf.readline().strip("\n")
            new_head=head+"\t"+"region"+"\t"+"closest_gene_name"+"\t"+"NCBoost_Score"+"\t"+"NCboost_chr_rank_perc"+"\n"

        for line in my_vcf:
            my_line=line.split("\t")
            my_line[13]=my_line[13].strip("\n")
            coord=my_line[0].split("_")
            coord_to_test=coord[0]+"_"+coord[1]

            if coord_to_test in intersection_result_dic:
                old_line="\t".join([str(x) for x in my_line])
                uploaded_line=old_line+intersection_result_dic[coord_to_test]
                uploaded_lines_list.append(uploaded_line)

            else:
                old_line="\t".join([str(x) for x in my_line])
                uploaded_line=old_line+NAs
                uploaded_lines_list.append(uploaded_line)

    #output file in which
    with open (args.output, "w") as output_file:
        output_file.write(new_head)
        for line in uploaded_lines_list:
            output_file.write(line)


if __name__ == "__main__":
  main()
