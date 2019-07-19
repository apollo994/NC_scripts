#!/usr/bin/env python3
# Fabio Zanarello, Sanger Institute, 2019

# this script reads a input table for NCBoost,
# the results file of NCBoost annotation and a precomputed score table.

# Geneartes a table with the variants, the NCBoost featire and results, and precomputed values as
# ANNOVAR annotation, closest gene name, NCBoost score
# if position is not present the script adds NA

import os
import sys
import argparse
from collections import defaultdict


def main():
    parser = argparse.ArgumentParser(description='My nice tool.')
    parser.add_argument('--NC_input', metavar='INPUTFILE_1', help='The input of NCboost')
    parser.add_argument('--head', metavar="head", default="t",help='specify if the header is present in vcf, (t or f, def=t)')
    parser.add_argument('--NC_res', metavar='INPUTFILE_2', help='The result of NCBoost annotation')
    parser.add_argument('--precomp', metavar='INPUTFILE_3', help='The result of the intersection with precomp.')
    parser.add_argument('--output', metavar='OUTPUTFILE', default="my_result_updated.txt", help='The output file.')
    args = parser.parse_args()


    #dict in which store the precomputed result
    precomp_dic={}

    # read line by line and add to dictionaty with key = coordinates (chr3_12223445)
    # and value = the rest of the line (NO rank)

    with open (args.precomp) as precomp_res:
        for line in precomp_res:
            my_line=line.split(" ")
            coord="chr"+my_line[0]+"_"+my_line[1]

            precomp_dic[coord]="\t"+my_line[2]+"\t"+my_line[3]+"\t"+my_line[4]


    #dict in which store the vcf lines before to be written in the output
    NCBoost_result_dic={}

    # read line by line and add to dictionaty with key = coordinates
    # and value = all the line

    with open (args.NC_res) as my_inter_res:
        NC_red_head=my_inter_res.readline()

        for line in my_inter_res:
            my_line=line.split("\t")
            coord="chr"+my_line[0]+"_"+my_line[1]
            NCBoost_result_dic[coord]=line.strip("\n")



    # read line by line the NC input file and if the coordinates are present in the dictionary
    # add new columns with values, if not add NAs
    # then print on output the variant (chr_pos_ref_alt)

    with open (args.NC_input) as NC_input_pos,open (args.output, "w") as output_file:

        output_file.write("VAR"+"\t"+NC_red_head.strip("\n")+"\t"+"precomp_region"+"\t"+"precomp_closest_gene_name"+"\t"+"precomp_NCBoost_score"+"\n")

        for line in NC_input_pos:
            my_line=line.split("\t")
            if my_line[0]!="chr":  #just to avoid the header (usually but not always at the bottom)
                key_to_search="chr"+my_line[0]+"_"+my_line[1]
                var_to_print="chr"+my_line[0]+"_"+my_line[1]+"_"+my_line[3]+"_"+my_line[4].strip("\n")

                if key_to_search in precomp_dic:
                    precomp_line=precomp_dic[key_to_search].strip("\t")
                else:
                    precomp_line="\t".join(3*["NA"])

                if key_to_search in NCBoost_result_dic:
                    res_line=NCBoost_result_dic[key_to_search]
                else:
                    res_line="\t".join(54*["NA"])

                output_file.write(var_to_print+"\t"+res_line+"\t"+precomp_line+"\n")



if __name__ == "__main__":
  main()
