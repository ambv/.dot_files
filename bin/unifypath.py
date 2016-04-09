#!/usr/bin/env python3

import os
import sys

if sys.version_info[:2] < (3, 3):
    print("Python 3.3+ required.")
    sys.exit(1)

from collections import OrderedDict

path_env = OrderedDict()
for element in os.environ['PATH'].split(':'):
    path_env[element] = 1

print(':'.join(path_env.keys()))
