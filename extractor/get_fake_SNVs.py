#!/usr/bin/env python3

# This script take genomic coordinates and generate a NCBoost input linke table

import sys
import argparse
from collections import defaultdict
#import numpy as np
#import pandas as pd
import subprocess

# def retrive_ref(ref,chr,pos):
#     all_bases=["A","T","C","G"]
#
#     coordinates=str(chr)+":"+str(pos)+"-"+str(pos)
#     out=str(subprocess.check_output(["samtools","faidx",ref,coordinates]))
#
#     print (out)
#     out=out.split("\\n")
#
#
#     if out[1] in all_bases:
#         return (out[1])
#     else:
#         sys.stderr.write(str(chr)+":"+str(pos)+"-"+str(pos)+" not found in the reference\n")
#         return ("Not_found")

def retrive_win(ref,chr,start,end):

    coordinates=str(chr)+":"+str(start)+"-"+str(end)
    out=str(subprocess.check_output(["samtools","faidx",ref,coordinates]))
    out=out.split("\\n",1)

    if len(out[1])!=0:
        return (out[1])
    else:
        sys.stderr.write(str(chr)+":"+str(pos)+"-"+str(end)+" not found in the reference\n")
        return ("NA")


def get_var(ext_coo):
    global chr
    global start
    global end
    bho=ext_coo.split(":")
    chr=bho[0]
    pos=bho[1].split("-")
    start=pos[0]
    end=pos[1].strip("\n")


def generate_table(seq,window,out_file):
    get_var(window)


    with open (out_file, "w") as my_output:
        my_output.write("chr\tstart\tend\tref\talt\n")

        counter=0
        all_bases=["A","T","C","G"]

        for base in seq:

            coo=str(int(start)+counter)
            if base=="A":
                alt="T"
                my_output.write(str(chr)+"\t"+coo+"\t"+coo+"\t"+base+"\t"+alt+"\n")
                counter=counter+1
            if base=="T":
                alt="A"
                my_output.write(str(chr)+"\t"+coo+"\t"+coo+"\t"+base+"\t"+alt+"\n")
                counter=counter+1
            if base=="C":
                alt="G"
                my_output.write(str(chr)+"\t"+coo+"\t"+coo+"\t"+base+"\t"+alt+"\n")
                counter=counter+1
            if base=="G":
                alt="C"
                my_output.write(str(chr)+"\t"+coo+"\t"+coo+"\t"+base+"\t"+alt+"\n")
                counter=counter+1
            if base=="N":
                alt="NA"
                my_output.write(str(chr)+"\t"+coo+"\t"+coo+"\t"+base+"\t"+alt+"\n")
                counter=counter+1





def main():
    parser = argparse.ArgumentParser(description='My nice tool.')
    parser.add_argument('--input', metavar='INPUTFILE', default="/dev/stdin", help='Genomic region in the format= chr:start-end')
    parser.add_argument('--ref', metavar='REF', help='Reference fasta genome')
    parser.add_argument('--out', metavar='OUTPUTFILE', default="/dev/stdout", help='NCBoost input like table')
    args = parser.parse_args()

    # bho=args.input.split(":")
    # chr=bho[0]
    # pos=bho[1].split("-")
    # start=pos[0]
    # end=pos[1].strip("\n")

    get_var(args.input)

    ref_out=retrive_win(args.ref,chr,start,end)
    #print (ref_out)
    generate_table(ref_out,args.input,args.out)



if __name__ == "__main__":
  main()
