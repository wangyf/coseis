#!/usr/bin/env python
"""
Launch SORD code from YAML or JSON parameter file
"""

if __name__ != '__main__':
    raise Exception('Not a module')

import sys, yaml
import cst

prm = open(sys.argv[1])
prm = yaml.load(prm)
del(sys.argv[1])
cst.sord.run(prm)

