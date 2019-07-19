#!/usr/bin/env python3
# Fabio Zanarello, Sanger Institute, 2019

# This script that as input:
# - NCBoost input
# - PCIHIC table
# - ENSEMBL and symbol ID correspondances as from biomart
# and produce a table to be use during gene reassignment whit
# the following format (tab delimited):
# variant ENSEMBL_id symbol_ID max_PCHIC_score
# chr10_104845443_T_A ENSG00000120049	KCNIP2 24.37359914

import os
import sys
import argparse
from collections import defaultdict


def main():
    parser = argparse.ArgumentParser(description='My nice tool.')
    parser.add_argument('--var', metavar='VAR', help='variants')
    parser.add_argument('--pc', metavar='PC', help='PCHIC table')
    parser.add_argument('--id', metavar='ID', help='Ids correspondance table')
    parser.add_argument('--out', metavar='OUTPUTFILE', help='The output file.')
    args = parser.parse_args()

    IDs_dict={}

    with open (args.id , "r") as IDs_file:
        for line in IDs_file:
            ENS_sym=line.split("\t")
            IDs_dict[ENS_sym[0]]=ENS_sym[1].strip("\n")

    out_line=[]

    with open (args.pc) as pc_tab:
        head=pc_tab.readline()
        for line in pc_tab:
            sline=line.split("\t")
            var=sline[len(sline)-2]
            ENS=sline[5]
            max=sline[len(sline)-1].strip("\n")
            if ENS in IDs_dict:
                sym=IDs_dict[ENS]
                out_line.append(var+"\t"+ENS+"\t"+sym+"\t"+max+"\n")

    with open (args.out, "w") as out_file:
        out_file.write("var"+"\t"+"ENS"+"\t"+"sym"+"\t"+"max"+"\n")
        for line in out_line:
            out_file.write(line)



if __name__ == "__main__":
  main()
