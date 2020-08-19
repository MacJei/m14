#!/usr/bin/env python3

import sys
import re
from datetime import datetime

for line in sys.stdin:
    tags = re.findall(r"<row\s.*CreationDate=\"([^\"]+)\"\s.*Tags=\"([^\"]+)", line, flags=re.UNICODE)
    if len(tags) == 0:
        continue
    tags = tags[0]

    createDate = datetime.strptime(tags[0].split(".")[0], '%Y-%m-%dT%H:%M:%S')
    tags = tags[1].replace("&gt;&lt;", ","). \
        replace("&lt;", "").replace("&gt;", "").lower().split(",")
    for tag in tags:
        print(tag, 1, createDate.year, sep="\t")