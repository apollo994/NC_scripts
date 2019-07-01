#!/usr/bin/env python3

#STRONGLY ADVISED TO RUN WITH PYPY3

#this script use the following input:
# - input for NCBoost
# - table of raw data from PCHIC (es. PCHiC_peak_matrix_cutoff5.tsv)
# -

#and generate a .txt file named PCHIC_for_NC.txt (or the set one with --output)
#with a line for each input position that has correspondance in the PCHOIC raw table

def get_IDictionary(ID_table):
    dict={}
    with open (ID_table, "r") as IDs:
        for ID in IDs:
            line=ID.split("\t")
            ens=line[0]
            sym=line[1].strip("\n")
            dict[sym]=ens
    return (dict)


def get_var(NC_input):
    variants=[]
    with open (NC_input, "r") as SNVs:
        for line in SNVs:
            s_line=line.split("\t")
            chr=s_line[0]
            pos=s_line[1]
            ref=s_line[3]
            alt=s_line[4].strip("\n")
            long_name="chr"+chr+"_"+pos+"_"+ref+"_"+alt
            if len(ref)==1 and len(alt)==1:
                variants.append([chr,pos,long_name])
    return (variants)


import os
import sys
import argparse
from collections import defaultdict


def main():
    parser = argparse.ArgumentParser(description='My nice tool.')
    parser.add_argument('--pos', metavar='position', help='Standard input for NCBoost')
    parser.add_argument('--name', metavar="gene_name", help='ENSid and symbolID table')
    parser.add_argument('--raw', metavar="raw_PC", help='raw table of PCHIC data')
    parser.add_argument('--out', metavar='OUTPUTFILE', default="PCHIC_for_NC.txt", help='The output file.')
    args = parser.parse_args()

    IDictionary=get_IDictionary(args.name)

    var_list=get_var(args.pos)


    with open (args.raw, "r") as raw_PC, open (args.out, "w") as out_file:

        head=raw_PC.readline()
        out_file.write("var\tENS\tsym\tmax\n")
        c=0
        for line in raw_PC:
            c=c+1
            s_line=line.split("\t")
            genes=s_line[4].split(";")
            chr=s_line[5]
            start=s_line[6]
            end=s_line[7]
            scores=s_line[11:28]


            for var in var_list:
                if var[0]==chr:
                    if int(var[1])>=int(start):
                        if int(var[1])<=int(end):
                            for gene in genes:
                                if gene in IDictionary.keys():
                                    out_file.write(var[2]+"\t"+IDictionary[gene]+"\t"+gene+"\t"+max(scores)+"\n")


            print (c,"/728838")




if __name__ == "__main__":
  main()
