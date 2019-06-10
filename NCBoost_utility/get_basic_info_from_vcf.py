#!/usr/bin/env python3

#this script uses vcf input file (--input) with the following fasion (tab spaced)
# VAR	rs	chr	pos	ref	alt
# chr10_101252385_A_G	rs12261266	chr10	101252385	A	G
# chr10_101254508_CTCTTCTT_C	rs113608714	chr10	101254508	CTCTTCTT	C
# chr10_101271982_C_A	rs11190127	chr10	101271982	C	A

# and read it line by line in order to extract
# some basic information such as:
# total_position=0
# SNV=0
# insertion=0
# deletion=0


import os
import sys
import argparse
from collections import defaultdict


def main():
    parser = argparse.ArgumentParser(description='My nice tool.')
    parser.add_argument('--input', metavar='INPUTFILE', help='The input vcf file.')
    parser.add_argument('--head', metavar="head", default="t",help='specify if the header is present, (t or f, def=t)')
    #parser.add_argument('--out', metavar='OUTPUTFILE', default="my_coordinates_for_NCBoost.txt", help='The output file.')
    args = parser.parse_args()


    #list in which store the coordinates before to be written in the output
    my_coordinates=list()

    total_position=0
    SNV=0
    insertion=0
    deletion=0

    with open (args.input) as my_vcf:
        #jump to the second line if there is the header
        if args.head=="t":
            head=my_vcf.readline()
        #read line by line and extract the chromosome and the position

        for line in my_vcf:
            my_line=line.split("\t")
            coordinates=my_line[0].split("_")
            ch=coordinates[0][3:len(coordinates[0])]
            pos=int(coordinates[1])
            ref=coordinates[2]
            alt=coordinates[3]

            #annotate results
            total_position=total_position+1

            if len(ref)==1 and len(alt)==1:
                SNV=SNV+1
            if len(ref)==1 and len(alt)!=1:
                insertion=insertion+1
            if len(ref)!=1 and len(alt)==1:
                deletion=deletion+1

    #output
    print("Summary of the input vcf:")
    print("\t-Total number of position= "+str(total_position))
    print("\t-Total number of SNP= "+str(SNV))
    print("\t-Total number of insertion= "+str(insertion))
    print("\t-Total number of deletion= "+str(deletion))







if __name__ == "__main__":
  main()
