#!/usr/bin/env python3

# this script reads a variants table with the following format (tab sep):

# VAR	rs	chr	pos	ref	alt
# chr10_101252385_A_G	rs12261266	chr10	101252385	A	G
# chr10_101254508_CTCTTCTT_C	rs113608714	chr10	101254508	CTCTTCTT	C
# chr10_101271982_C_A	rs11190127	chr10	101271982	C	A

# and the results file of NCBoost annotation
# and add a new column with the ANNOVAR annotation, closest gene name, NCBoost score
# if position is not present in the results the script adds NA

import os
import sys
import argparse
from collections import defaultdict


def main():
    parser = argparse.ArgumentParser(description='My nice tool.')
    parser.add_argument('--vcf', metavar='INPUTFILE_1', help='The input vcf file.')
    parser.add_argument('--head', metavar="head", default="t",help='specify if the header is present in vcf, (t or f, def=t)')
    parser.add_argument('--NC_res', metavar='INPUTFILE_2', help='The result of NCBoost annotation')
    parser.add_argument('--output', metavar='OUTPUTFILE', default="my_vcf_updated.txt", help='The output file.')
    args = parser.parse_args()


    #list in which store the vcf lines before to be written in the output
    NCBoost_result_dic={}

    # read line by line and add to dictionaty with key = coordinates
    # and value = the rest of the line

    with open (args.NC_res) as my_inter_res:
        for line in my_inter_res:
            my_line=line.split("\t")
            coord="chr"+my_line[0]+"_"+my_line[1]+"_"+my_line[2]+"_"+my_line[3]
            NCBoost_result_dic[coord]="\t"+my_line[4]+"\t"+my_line[5]+"\t"+my_line[53]

    # read line by line the vcf file and if the coordinates are present in the dictionary
    # add new columns with values, if not add NAs
    NAs="\tNA\tNA\tNA\n"
    uploaded_lines_list=[]

    with open (args.vcf) as my_vcf:
        #jump to the second line if there is the header
        if args.head=="t":
            head=my_vcf.readline().strip("\n")
            new_head=head+"\t"+"region"+"\t"+"closest_gene_name"+"\t"+"ncboost_score"+"\n"

        for line in my_vcf:
            #print (line)
            my_line=line.split("\t")
            ncol=len(my_line)-1
            my_line[ncol]=my_line[ncol].strip("\n")
            coord_to_test=my_line[0]
            #print (coord_to_test)
            #print ()

            if coord_to_test in NCBoost_result_dic:
                old_line="\t".join([str(x) for x in my_line])
                uploaded_line=old_line+NCBoost_result_dic[coord_to_test]
                uploaded_lines_list.append(uploaded_line)
                #print (uploaded_line)

            else:
                old_line="\t".join([str(x) for x in my_line])
                uploaded_line=old_line+NAs
                uploaded_lines_list.append(uploaded_line)
                #print (uploaded_line)

    #output file in which
    with open (args.output, "w") as output_file:
        output_file.write(new_head)
        for line in uploaded_lines_list:
            output_file.write(line)


if __name__ == "__main__":
  main()
