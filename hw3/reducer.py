#!/usr/bin/env python3

import sys
from collections import Counter

dict_counter = Counter()

for line in sys.stdin:
    if not line: continue
    tag, count, year = line.strip().split("\t")
    dict_counter[year+"\x01"+tag] += int(count)

for key, count in dict_counter.items():
    year, tag = key.split("\x01")
    if count > 10 and (year == '2010' or year == '2016'):
        print(tag, count, year, sep="\t")