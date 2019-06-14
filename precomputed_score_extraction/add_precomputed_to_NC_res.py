#!/usr/bin/env python3

# this script reads a table of precomputed score (space delimited, no header):
# 2 103060300 intronic IL18RAP 0.03276616 0.3697275149820258
# and a results table from NCBoost and produce an output in which the NCBoost results
# have four new columns to corresponding to:
# precomp_region
# precomp_closest_gene_name
# precomp_NCBoost_Score
# precomp_NCboost_chr_rank_perc
# NA if the variant is not precomputed

import os
import sys
import argparse
from collections import defaultdict


def main():
    parser = argparse.ArgumentParser(description='My nice tool.')
    parser.add_argument('--NC_res', metavar='INPUTFILE_1', help='The input vcf file.')
    parser.add_argument('--precomp', metavar='INPUTFILE_2', help='The result of the intersection.')
    parser.add_argument('--output', metavar='OUTPUTFILE', default="my_vcf_updated.txt", help='The output file.')
    args = parser.parse_args()


    #list in which store the precomputed result
    precomp_dic={}

    # read line by line and add to dictionaty with key = coordinates (chr3_12223445)
    # and value = the rest of the line

    with open (args.precomp) as precomp_res:
        for line in precomp_res:
            my_line=line.split(" ")
            coord="chr"+my_line[0]+"_"+my_line[1]

            precomp_dic[coord]="\t"+my_line[2]+"\t"+my_line[3]+"\t"+my_line[4]+"\t"+my_line[5]

    # read line by line the result file and if the coordinate is present in the dictionary
    # add new columns with values, if not add NAs
    NAs="\tNA\tNA\tNA\tNA\n"

    uploaded_lines_list=[]

    with open (args.NC_res) as NC_res_table, open (args.output, "w") as output_file:
        head=NC_res_table.readline().strip("\n")
        output_file.write(head+"\t"+"precom_region"+"\t"+"precom_closest_gene_name"+"\t"+"precom_NCBoost_Score"+"\t"+"precom_NCboost_chr_rank_perc"+"\n")

        for line in NC_res_table:
            my_line=line.split("\t")
            key_to_check="chr"+my_line[0]+"_"+my_line[1]

            if key_to_check in precomp_dic:
                output_file.write(line.strip("\n")+precomp_dic[key_to_check])
            else:
                output_file.write(line.strip("\n")+NAs)




if __name__ == "__main__":
  main()
