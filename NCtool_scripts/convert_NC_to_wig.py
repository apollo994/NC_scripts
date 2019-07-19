#!/usr/bin/env python3
#Fabio Zanarello, Sanger Institute, 2019

import sys
import argparse
from collections import defaultdict



def main():
    parser = argparse.ArgumentParser(description='My nice tool.')
    parser.add_argument('--input', metavar='INPUTFILE', default="/dev/stdin", help='The input file.')
    parser.add_argument('--reg', metavar='chr:start-end', help='genomic window')
    parser.add_argument('--sam', metavar='my_sample', help='Sample name')
    parser.add_argument('--out', metavar='OUTPUTFILE', default="/dev/stdout", help='The output file.')
    args = parser.parse_args()

    with open (args.input, "r") as my_NC_res, open (args.out, "w") as out_file:
        head=my_NC_res.readline()
        line1=my_NC_res.readline()

        chr=line1.split("\t")[0]
        pos=line1.split("\t")[1]
        score=line1.split("\t")[-1]
        out_file.write("browser position chr"+str(args.reg)+"\n")
        out_file.write("track type=wiggle_0 name=\""+str(args.sam)+"\" color=50,150,255 yLineMark=0.3 yLineOnOff=on\n")
        out_file.write("variableStep chrom=chr"+chr+"\n")
        out_file.write(pos+"\t"+score)

        for line in my_NC_res:
            pos=line.split("\t")[1]
            score=line.split("\t")[-1]
            if score!="NA\n":
                out_file.write(pos+"\t"+score)


if __name__ == "__main__":
  main()
