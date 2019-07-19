#!/usr/bin/env python3
# Fabio Zanarello, Sanger Institute, 2019

#this script use the following input:
# - input for NCBoost
# - a list of result file from NCBoost

#and generate a .txt file with name merged_result.txt (or the set one with --output)
#with a line for each input position and columns with:
# - default associated gene and relative NCBoost score
# - as many as PCICH associated gen and relative NCBoost scores
# - NAs if data is not present



# take the input coordinates and make a dictionary

def read_NC_input(pos,dic):
    with open (pos, "r") as NC_input_file:
        head=NC_input_file.readline()
        for line in NC_input_file:
            line=line.split("\t")
            chr="chr_"+str(line[0])
            pos="_"+str(line[1])
            ref="_"+str(line[3])
            alt="_"+str(line[4].strip("\n"))
            key=chr+pos+ref+alt
            dic[key]=[]
    return (dic)

# extract from def_res gene and NCscore and add to dictionary, else NAs

def add_gene_and_score(NCres,res_dic):
    #store number of elements already in the res dic
    starting_element=len(res_dic[list(res_dic)[0]])
    with open (NCres,  "r") as NC_res_tab:
        for line in NC_res_tab:
            line=line.split("\t")
            chr="chr_"+str(line[0])
            pos="_"+str(line[1])
            ref="_"+str(line[2])
            alt="_"+str(line[3])
            gene=str(line[5])
            score=str(line[len(line)-1].strip("\n"))
            key=chr+pos+ref+alt
            if key in res_dic:
                res_dic[key].append([gene,score])
    #add NAs to key not present in res
    for key in res_dic:
        if len(res_dic[key])==starting_element:
            res_dic[key].append(["NA","NA"])

    return (res_dic)


# generate the output table

def write_output(res_dic, out_file):

    result_element=len(res_dic[list(res_dic)[0]])
    col_names=[]
    for idx in list(range(1,result_element)):
        col_names.append("PC_gene_"+str(idx))
        col_names.append("NCsore_"+str(idx))

    header="VAR\tANNOVAR_gene\tNC_score\t"+"\t".join(col_names)+"\n"

    with open (out_file, "w") as result_file:
        result_file.write(header)
        for key in res_dic:
            result_file.write(key+"\t")
            for res in res_dic[key]:
                result_file.write("\t".join(res)+"\t")
            result_file.write("\n")

    return()


import os
import sys
import argparse
from collections import defaultdict


def main():
    parser = argparse.ArgumentParser(description='My nice tool.')
    parser.add_argument('--pos', metavar='position', help='Standard input for NCBoost')
    parser.add_argument('--NC_res', metavar="default_res", help='the default result table computed by NCboost')
    parser.add_argument('--PC_res', metavar="PC_res", nargs='+', help='the result table obtained using PCIHC data computed by NCboost (also multiple)')
    parser.add_argument('--out', metavar='OUTPUTFILE', default="merged_results.txt", help='The output file.')
    args = parser.parse_args()

    empty_dict={}

    position_dictionary=read_NC_input(args.pos, empty_dict)

    results_dictionary=add_gene_and_score(args.NC_res, position_dictionary)


    for res in args.PC_res:
        results_dictionary=add_gene_and_score(res, position_dictionary)

    write_output(results_dictionary, args.out)




if __name__ == "__main__":
  main()
