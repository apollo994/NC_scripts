#!/usr/bin/env python3

# this script reads a result table from NCBoost and a recovery dict from prepare_INDELS_from_input.py
# and reformat the result table with the original INDELS information



import os
import subprocess
import sys
import argparse
from collections import defaultdict


def main():
    parser = argparse.ArgumentParser(description='My nice tool.')
    parser.add_argument('--NC_res', metavar='INPUTFILE_1', help='The output of NCboost')
    parser.add_argument('--PC_stat', metavar='RECDICT', default="recovery_dict_INDELS.txt", help='Dictionary with original indel')
    parser.add_argument('--NC_update', metavar='NCINDELS',default="recovered_INDELS_res.txt" ,help='NCBoost output reformatted with indels')
    args = parser.parse_args()

    PC_dic={}


    with open (args.NC_res, "r") as NC_res_tab, open (args.PC_stat, "r") as reass_stat, open (args.NC_update, "w") as output_file:

        for line in reass_stat:
            my_line=line.split("\t")
            PC_dic[my_line[0]]=my_line[2].strip("\n")


        output_file.write(NC_res_tab.readline().strip("\n")+"\t"+"PC_gene\n")

        for line in NC_res_tab:
            my_line=line.split("\t")
            chr=my_line[0]
            pos=my_line[1]
            ref=my_line[2]
            alt=my_line[3]
            var="chr"+chr+"_"+pos+"_"+ref+"_"+alt

            if var in PC_dic:
                output_file.write(line.strip("\n")+"\t"+PC_dic[var]+"\n")
            else:
                output_file.write(line.strip("\n")+"\t"+"0"+"\n")


if __name__ == "__main__":
  main()
