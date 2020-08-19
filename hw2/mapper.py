#!/usr/bin/python

import sys
import re

for line in sys.stdin:    
    # remove leading and trailing whitespace
    line = line.strip()
    # make lowercase
    words = re.sub(r'[^\w\s]','',line.lower())
    # remove punctuations
    words = re.split("\W*\s+\W*", words)
    # split into bigrams
    bigram_list = [' '.join(words[i:i+2]) for i in range(len(words)-2+1)]
    
    # increase counter
    for bigram in bigram_list:
        print('%s\t%s' %(bigram, 1))