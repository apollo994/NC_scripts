#!/usr/bin/env python3
#Fabio Zanarello, Sanger Institute, 2019

# this script reads a input table for NCBoost
# es:
# chr	start	end	ref	alt
# 12	48208368	48208368	T	C

# and produce another file with the same format but
# reformatting the INDELS in order to make them executable
# by NCBoost

# example are: note the start end ref change
# INSERTION
# Chr 	start	end	ref	alt
# 10	1303157	1303157	T	TACAC
# Chr 	start	end	ref	alt
# 10	1303158	1303158	ref_allele	N

# DELITION_1 note the start end ref change
# Chr 	start	end	ref	alt
# 10	101254508	101254508	CTCTTCTT	C
# Chr 	start	end	ref	alt
# 10	 101254509 	 101254509 	ref_allele	N

# DELITION_2
# Chr 	start	end	ref	alt
# 10	101254508	101254508	CTCTTCTT	-
# Chr 	start	end	ref	alt
# 10	 101254508 	 101254508 	C	N


def retrive_ref(ref,chr,pos):
    all_bases=["A","T","C","G"]

    coordinates=str(chr)+":"+str(pos)+"-"+str(pos)
    out=str(subprocess.check_output(["samtools","faidx",ref,coordinates]))
    out=out.split("\\n")

    if out[1] in all_bases:
        return (out[1])
    else:
        sys.stderr.write(str(chr)+":"+str(pos)+"-"+str(pos)+" not found in the reference\n")
        return ("Not_found")


import os
import subprocess
import sys
import argparse
from collections import defaultdict


def main():
    parser = argparse.ArgumentParser(description='My nice tool.')
    parser.add_argument('--NC_input', metavar='INPUTFILE_1', help='The input of NCboost')
    parser.add_argument('--ref', metavar='REF', help='Reference genome')
    parser.add_argument('--output', metavar='OUTPUTFILE', default="adapted_INDELS.txt", help='The output file.')
    parser.add_argument('--rec', metavar='RECDICT', default="recovery_dict_INDELS.txt", help='Dictionary to get original indel')
    args = parser.parse_args()

    deletion_symbol=["-","*"]
    all_bases=["A","T","C","G"]

    alt_dict={"A": "T", "T": "A","C": "G","G": "C",}

    with open (args.NC_input) as NC_input_pos,open (args.output, "w") as output_file, open (args.rec, "w") as rec_dict:

        output_file.write("chr\tstart\tend\tref\talt\n")

        for line in NC_input_pos:
            my_line=line.split("\t")
            chr=my_line[0]
            pos=my_line[1]
            ref=my_line[3]
            alt=my_line[4].strip("\n")

            if ref!="ref":

                # INSERTION
                if len(ref)<len(alt):
                    pos=int(pos)+1
                    new_ref=retrive_ref(args.ref,chr,pos)
                    if new_ref in all_bases:
                        new_alt=alt_dict[new_ref]
                        output_file.write("\t".join([str(chr),str(pos),str(pos),new_ref,new_alt])+"\n")
                        rec_dict.write(line.strip("\n").replace("\t","_")+"\t"+"_".join([str(chr),str(pos),str(pos),new_ref,new_alt])+"\n")

                # DELETION_1
                if len(ref)>len(alt) and alt in all_bases:
                    pos=int(pos)+1
                    new_ref=retrive_ref(args.ref,chr,pos)
                    if new_ref in all_bases:
                        new_alt=alt_dict[new_ref]
                        output_file.write("\t".join([str(chr),str(pos),str(pos),new_ref,new_alt])+"\n")
                        rec_dict.write(line.strip("\n").replace("\t","_")+"\t"+"_".join([str(chr),str(pos),str(pos),new_ref,new_alt])+"\n")

                # DELETION_2
                if alt in deletion_symbol:
                    new_ref=retrive_ref(args.ref,chr,pos)
                    if new_ref in all_bases:
                        new_alt=alt_dict[new_ref]
                        output_file.write("\t".join([str(chr),str(pos),str(pos),new_ref,new_alt])+"\n")
                        rec_dict.write(line.strip("\n").replace("\t","_")+"\t"+"_".join([str(chr),str(pos),str(pos),new_ref,new_alt])+"\n")






if __name__ == "__main__":
  main()
