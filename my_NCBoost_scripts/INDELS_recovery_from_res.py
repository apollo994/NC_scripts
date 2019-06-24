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
    parser.add_argument('--rec', metavar='RECDICT', default="recovery_dict_INDELS.txt", help='Dictionary with original indel')
    parser.add_argument('--NC_indels', metavar='NCINDELS',default="recovered_INDELS_res.txt" ,help='NCBoost output reformatted with indels')
    args = parser.parse_args()

    indels_dic={}


    with open (args.NC_res, "r") as NC_res_tab, open (args.rec, "r") as rec_dict, open (args.NC_indels, "w") as output_file:

        for line in rec_dict:
            my_line=line.split("\t")
            indels_dic[my_line[1].strip("\n")]=my_line[0]


        output_file.write(NC_res_tab.readline())

        for line in NC_res_tab:
            my_line=line.split("\t")
            chr=my_line[0]
            pos=my_line[1]
            ref=my_line[2]
            alt=my_line[3]

            real_INDELS=indels_dic["_".join([str(chr),str(pos),str(pos),ref,alt])]
            real_INDELS=real_INDELS.split("_")
            real_INDELS=real_INDELS[0]+"\t"+real_INDELS[1]+"\t"+real_INDELS[3]+"\t"+real_INDELS[4]

            values="\t".join(my_line[4:])

            output_file.write(real_INDELS+"\t"+values)


if __name__ == "__main__":
  main()
