#!/usr/bin/env python3

# this script reads PCHIC table in order to extract info


import os
import sys
import argparse
from collections import defaultdict
import numpy as np
import pandas as pd


def main():
    parser = argparse.ArgumentParser(description='My nice tool.')
    parser.add_argument('--PCtab', metavar='PCtab', help='PCICH data table')
    parser.add_argument('--test', metavar='test', help='position to be tested')
    args = parser.parse_args()

    PCdata=pd.read_csv(args.PCtab, sep='\t', delimiter=None, header=0, index_col=32)

    if args.test in PCdata.index:
        print (PCdata.loc[args.test,:])
    else:
        print ("not present")






if __name__ == "__main__":
  main()
