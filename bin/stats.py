#!/usr/bin/env python
"""
Print binary file statistics. Default data type is 4 byte floating point.

TODO: move into a lib funtion
"""

if __name__ != '__main__':
    raise Exception('Not a module')

import os, sys, json
import numpy as np
from numpy.lib.npyio import format as npy

# options
block = 64 * 1024 * 1024
arg_dtype = None
args = []
for a in sys.argv[1:]:
    if a[0] == '-':
        arg_dtype = a[1:].replace('l', '<').replace('b', '>')
    else:
        args += [a]

# init
print('         Min          Max         Mean  Shape')

# loop over files
for filename in args:
  
    # NumPy file
    if filename.endswith('npy'):
        fh = open(filename, 'rb')
        version = npy.read_magic(fh)
        shape, fcont, dtype = npy._read_array_header(fh, version)
        n = np.prod(shape)

    # raw binary with metadata (if present)
    else:
        shape = None
        dtype = 'f'
        f = os.path.split(filename)
        for i in range(1, len(f)):
            path = os.sep.join(f[:-i])
            tail = os.sep.join(f[i:])
            meta = os.path.join(path, 'meta.json')
            if os.path.exists(meta):
                meta = json.load(open(meta))
                if 'dtype' in meta:
                    dtype = meta['dtype']
                if 'shapes' in meta:
                    if tail in meta['shapes']:
                        shape = meta['shapes'][tail]
                elif 'shape' in meta:
                    shape = meta['shape']
                break
        if arg_dtype:
            dtype = arg_dtype
        if shape:
            n = np.prod(shape)
        else:
            nb = np.dtype(dtype).itemsize
            n = os.path.getsize(filename)
            if n == 0 or n % nb != 0:
                continue
            n //= nb
            shape = [int(n)]
        fh = open(filename, 'rb')

    # compute stats
    if n == 0:
        rmin = float('nan')
        rmax = float('nan')
        rmean = float('nan')
    else:
        rmin =  np.inf
        rmax = -np.inf
        rsum = 0.0
        i = 0
        m = 0
        while i < n:
            b = min(n - i, block)
            r = np.fromfile(fh, dtype=dtype, count=b)
            j = ~np.isnan(r)
            rmin = min(rmin, r[j].min().copy())
            rmax = max(rmax, r[j].max().copy())
            rsum += r[j].astype('d').sum()
            i += b
            m += j.sum()
        rmean = rsum / m
    print('%12g %12g %12g  %s  %s' % (rmin, rmax, rmean, list(shape), filename))

