#!/usr/bin/env python
"""
Step 2: SORD simulation
"""
import numpy as np
import os, sys, pyproj
import sord

# parameters
dx_ = 100.0;  nproc3 = 1, 48, 320
dx_ = 200.0;  nproc3 = 1, 12, 160
dx_ = 500.0;  nproc3 = 1, 4, 64
dx_ = 1000.0; nproc3 = 1, 1, 2
dx_ = 8000.0; nproc3 = 1, 1, 1

# path
rundir = os.path.join( 'run', 'sim', '%04.f' % dx_ )

# mesh metadata
mesh_ = '%04.0f' % dx_
mesh_ = os.path.join( 'run', 'mesh', mesh_ ) + os.sep
meta = sord.util.load( mesh_ + 'meta.py' )
dtype = meta.dtype
delta = meta.delta
shape = meta.shape
hypo_ = meta.origin
npml = meta.npml

# translate projection to lower left origin
x, y = meta.bounds[:2]
proj = pyproj.Proj( **meta.projection )
proj = sord.coord.Transform( proj, translate=(-x[0], -y[0]) )

# dimensions
dt_ = dx_ / 16000.0
nt_ = int( 120.0 / dt_ + 1.00001 )
delta += (dt_,)
shape += (nt_,)

# hypocenter location at x/y center
x, y, z = hypo_
x, y = proj( x, y )
j = abs( x / delta[0] ) + 1.0
k = abs( y / delta[1] ) + 1.0
l = abs( z / delta[2] ) + 1.0
ihypo = j, k, l

# moment tensor source
source = 'moment'
timefunction = 'brune'
period = 0.1
source1 = -1417e14,  585e14, 832e14
source1 =  -739e14, -190e14, 490e14

# boundary conditions
bc1 = 10, 10, 0
bc2 = 10, 10, 10

# material
hourglass = 1.0, 1.0
vp1 = 1500.0
vs1 = 500.0
vdamp = 400.0
gam2 = 0.8 
fieldio = [
    ( '=r', 'x3',  [], 'z3'  ),
    ( '=r', 'rho', [], 'rho' ),
    ( '=r', 'vp',  [], 'vp'  ),
    ( '=r', 'vs',  [], 'vs'  ),
]

# sites
for x, y, s in [
    (-115.6517,  32.4681,  'Mexicali'),
    (-115.5125,  32.6694,  'Calexico'),
    (-117.04,    34.91,    'Barstow'),
    (-117.29,    34.53,    'Victorville'),
    (-118.13,    34.71,    'Lancaster'),
    (-119.8,     36.7333,  'Fresno'),
    (-119.3,     35.4167,  'Bakersfield'),
    (-120.4124,  35.8666,  'Parkfield'),
    (-120.69,    35.63,    'Paso Robles'),
    (-120.7167,  35.3333,  'San Luis Obispo'),
    (-120.45,    34.9,     'Santa Maria'),
    (-119.8333,  34.4333,  'Santa Barbara'),
    (-119.1833,  34.2,     'Oxnard'),
    (-118.55829, 34.22869, 'Northridge'),
    (-118.308,   34.185,   'Burbank'),
    (-118.315,   34.062,   'Los Angeles'),
    (-118.17113, 34.14844, 'Pasadena'),
    (-118.1668,  33.9235,  'Downey'),
    (-118.0844,  33.7568,  'Seal Beach'),
    (-117.91,    33.64,    'Newport Beach'),
    (-117.81,    33.68,    'Irvine'),
    (-117.16,    32.718,   'San Diego'),
    (-117.2284,  34.1065,  'San Bernardino'),
    (-117.6,     34.05,    'Ontario'),
]:
    s = s.replace( ' ', '-' )
    x, y = proj( x, y )
    j = x / delta[0] + 1.0
    k = y / delta[1] + 1.0
    fieldio += [
        ('=wi', 'v1', [j,k,1,()], s + '-v1'),
        ('=wi', 'v2', [j,k,1,()], s + '-v2'),
        ('=wi', 'v3', [j,k,1,()], s + '-v3'),
    ]

# surface output
n = max( 1, max( shape[:3] ) / 1024 )
m = max( 1, int( 0.025 / dt_ + 0.5 ) )
fieldio += [
    ( '=w', 'v1',  [(1,-1,n), (1,-1,n), 1, (1,-1,m)], 'full-v1' ),
    ( '=w', 'v2',  [(1,-1,n), (1,-1,n), 1, (1,-1,m)], 'full-v2' ),
    ( '=w', 'v3',  [(1,-1,n), (1,-1,n), 1, (1,-1,m)], 'full-v3' ),
]

# stage job
job = sord.stage( locals(), post='bash clean.sh -f' )
if not job.prepare:
    sys.exit()

# save metadata
path_ = job.rundir + os.sep
s = '\n'.join( (
    open( mesh_ + 'meta.py' ).read(),
    open( path_ + 'meta.py' ).read(),
) )
open( path_ + 'meta.py', 'w' ).write( s )
os.link( mesh_ + 'box.txt', path_ + 'box.txt' )

# save decimated mesh
nn = shape[:2]
for f in 'lon', 'lat', 'topo':
    s = np.fromfile( mesh_ + f, dtype ).reshape( nn[::-1] )
    s[::n,::n].tofile( path_ + f )

# copy input files
path_ += 'in' + os.sep
for f in 'z3', 'rho', 'vp', 'vs':
    os.link( mesh_ + f, path_ + f )

# launch job
sord.run( job )
