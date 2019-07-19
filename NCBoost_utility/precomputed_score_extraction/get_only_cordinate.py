#!/usr/bin/env python3
# Fabio Zanarello, Sanger Institute, 2019

#this script uses vcf input file (--input) with the following fasion (tab spaced)
# VAR	rs	chr	pos	ref	alt
# chr10_101252385_A_G	rs12261266	chr10	101252385	A	G
# chr10_101254508_CTCTTCTT_C	rs113608714	chr10	101254508	CTCTTCTT	C
# chr10_101271982_C_A	rs11190127	chr10	101271982	C	A
#the script read it line by line in order to extract
#and generate a .txt file with name my_vcf_cordinates.txt (or the set one with --output)
#with the cordinates in the followiing format:
#ch:pos-pos+1
#es:
#1:1223-1224


import os
import sys
import argparse
from collections import defaultdict


def main():
    parser = argparse.ArgumentParser(description='My nice tool.')
    parser.add_argument('--input', metavar='INPUTFILE', help='The input vcf file.')
    parser.add_argument('--head', metavar="head", default="t",help='specify if the header is present, (t or f, def=t)')
    parser.add_argument('--output', metavar='OUTPUTFILE', default="my_vcf_coordinates.txt", help='The output file.')
    args = parser.parse_args()

#    my_vcf_file_name=os.path.filename(args.input)

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
            coordinates=my_line[0].split("_")
            ch=coordinates[0][3:len(coordinates[0])]
            pos1=int(coordinates[1])
            pos2=pos1+1
            my_coordinates.append(ch+":"+str(pos1)+"-"+str(pos2))
        #output file in which
        with open (args.output, "w") as output_file:
            for coorddinate in my_coordinates:
                output_file.write(coorddinate+"\n")



if __name__ == "__main__":
  main()
