#!/usr/bin/env python3
# Fabio Zanarello, Sanger Institute, 2019

#this script uses NCBoost output file as input in order to
#generate a .txt file with name my_coordinates_for_NCBoost.txt (or the set one with --output)
#with the cordinates in the format used by NCBoost to annotate new variants:
#chr start   end   ref  alt
#1   12589   12589   G   A


import os
import sys
import argparse
from collections import defaultdict


def main():
    parser = argparse.ArgumentParser(description='My nice tool.')
    parser.add_argument('--input', metavar='INPUTFILE', help='The input vcf file.')
    parser.add_argument('--head', metavar="head", default="t",help='specify if the header is present, (t or f, def=t)')
    parser.add_argument('--out', metavar='OUTPUTFILE', default="my_coordinates_for_NCBoost.txt", help='The output file.')
    args = parser.parse_args()


    #list in which store the coordinates before to be written in the output
    my_coordinates=list()


    with open (args.input) as my_vcf:
        #jump to the second line if there is the header
        if args.head=="t":
            head=my_vcf.readline()
        #read line by line and extract the chromosome and the position
        #then append to the list of coordinates a new element corresponding
        #to the coordinates already formatted
        for line in my_vcf:
            my_line=line.split("\t")
            ch=my_line[0]
            start=my_line[1]
            end=my_line[1]
            ref=my_line[2]
            alt=my_line[3]
            my_coordinates.append(ch+"\t"+str(start)+"\t"+str(end)+"\t"+ref+"\t"+alt)
    #output file
    with open (args.out, "w") as output_file:
        output_file.write("chr"+"\t"+"start"+"\t"+"end"+"\t"+"ref"+"\t"+"alt"+"\n")
        for coorddinate in my_coordinates:
            output_file.write(coorddinate+"\n")



if __name__ == "__main__":
  main()
