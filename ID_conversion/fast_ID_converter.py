#!/usr/bin/env python3

# script to convert from ensembl to geneID (or the opposite) a list of genes (one ID per line)
# REMEMEBR to specify the input and outut IDs format

# fast is euphemism

import sys
import argparse
from collections import defaultdict
import mygene



def main():
    parser = argparse.ArgumentParser(description='My nice tool.')
    parser.add_argument('--input', metavar='INPUTFILE', default="/dev/stdin", help='The input file.')
    parser.add_argument('--out', metavar='OUTPUTFILE', default="/dev/stdout", help='The output file.')
    parser.add_argument('--inf', type=str ,help="Input format (ens or sym)")
    parser.add_argument('--outf', type=str ,help="output format (ens or sym)")

    args= parser.parse_args()
    mg = mygene.MyGeneInfo()

    if args.inf=="ens":
        input_form="ensembl"
    if args.inf=="sym":
        input_form="symbol"


    if args.outf=="ens":
        output_form="ensembl"
    if args.outf=="sym":
        output_form="symbol"

    if len(input_form)==0 or len(input_form)==0:
        sys.stderr.write("WARNING, input and/or output format ID NOT specified\n")


    genes = []

    with open (args.input, "r") as input_IDs:
        for line in input_IDs:
            genes.append(line.strip())

    if len(genes)!=len(set(genes)):
        sys.stderr.write("Duplicated IDs found, the output will cointain only one of them\n")

    with open (args.out, "w") as out_IDs:

        if input_form=="ensembl":
            with open (args.out, "w") as out_IDs:
                for gene in set(genes):
                    result = mg.query(gene, species="human", verbose=False)
                    input = gene

                    for hit in result["hits"]:
                        out_IDs.write("%s\t%s\n" % (input, hit[output_form]))

        if input_form=="symbol":
            with open (args.out, "w") as out_IDs:
                for gene in set(genes):
                    result = mg.query("symbol:"+gene, species="human", verbose=False, fields= "ensembl")
                    input = gene

                    for hit in result["hits"]:
                        # print (input)
                        if output_form in hit:
                            if type(hit[output_form])==list:
                                output = []
                                for ids in hit[output_form]:
                                    output.append(ids["gene"])
                                out_IDs.write("%s\t%s\n" % (input, ",".join(output)))

                            else:
                                temp_dict=hit[output_form]
                                out_IDs.write("%s\t%s\n" % (input, temp_dict["gene"]))

                        else:
                            out_IDs.write("%s\t%s\n" % (input, 'NA'))





if __name__ == "__main__":
  main()
