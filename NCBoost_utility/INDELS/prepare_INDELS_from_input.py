#!/usr/bin/env python3

# this script reads a input table for NCBoost
# es:
# chr	start	end	ref	alt
# 12	48208368	48208368	T	C

# and produce another file with the same format but
# reformatting the INDELS in order to make them executable
# by NCBoost

# example are:
# INSERTION
# Chr 	start	end	ref	alt
# 10	1303157	1303157	T	TACAC
# Chr 	start	end	ref	alt
# 10	1303157	1303157	T	N

# DELITION_1 note the start end change
# Chr 	start	end	ref	alt
# 10	101254508	101254508	CTCTTCTT	C
# Chr 	start	end	ref	alt
# 10	 101254509 	 101254509 	ref_allele	N

# DELITION_2
# Chr 	start	end	ref	alt
# 10	101254508	101254508	CTCTTCTT	-
# Chr 	start	end	ref	alt
# 10	 101254508 	 101254508 	C	N


# def retrive_ref(ref,chr,pos):
#     samtools faidx ref chr:pos-pos


import os
import sys
import argparse
from collections import defaultdict


def main():
    parser = argparse.ArgumentParser(description='My nice tool.')
    parser.add_argument('--NC_input', metavar='INPUTFILE_1', help='The input of NCboost')
    parser.add_argument('--output', metavar='OUTPUTFILE', default="adapted_INDELS.txt", help='The output file.')
    args = parser.parse_args()

    deletion_symbol=["-","*"]

    with open (args.NC_input) as NC_input_pos,open (args.output, "w") as output_file:

        for line in NC_input_pos:
            my_line=line.split("\t")
            ref=my_line[3]
            alt=my_line[4].strip("\n")

            if ref!="ref":

                # INSERTION
                if len(ref)<len(alt):
                    print("INSERTION")
                    print (line.strip("\n"))
                    print (len(ref), len(alt))
                    print()

####make the two delition type distiguishable

                # DELETION_1
                if len(ref)>len(alt) and alt is not deletion_symbol:
                    print("DELETION_1")
                    print (line.strip("\n"))
                    print (len(ref), len(alt))
                    print()

                # DELETION_2
                if alt in deletion_symbol:
                    print("DELETION_2")
                    print (line.strip("\n"))
                    print (len(ref), len(alt))
                    print()





if __name__ == "__main__":
  main()
