#!/usr/bin/env python
"""
Bimaterial problem
"""

import sord

np3 = 1, 1, 1
np3 = 1, 2, 1
dx = 0.06
dt = 0.01
nn = 401, 402, 2
nt = 200
ihypo = nn[0]/2, nn[1]/2, 1
fixhypo = -1
xhypo = 0.0, 0.0, -0.5*dx
trelax = 0.1
vrup = 0.5
rcrit = 1.5
faultnormal = 2	
hourglass = 1.0, 2.0
bc1 = 10, 10, 1
bc2 = 10, 10, 1
itio = 1
itstats = 1
debug = 0

_k = ihypo[1]
fieldio = [
    ( '=', 'rho', [], 1.0   ),
    ( '=', 'vp',  [], 1.732 ),
    ( '=', 'vs',  [], 1.0   ),
#   ( '=', 'rho', [0,(1,_k),0,0],  1.0       ),
#   ( '=', 'vp',  [0,(1,_k),0,0],  1.732     ),
#   ( '=', 'vs',  [0,(1,_k),0,0],  1.0       ),
#   ( '=', 'rho', [0,(_k+1,-1),0,0], 1.0/1.2   ),
#   ( '=', 'vp',  [0,(_k+1,-1),0,0], 1.732/1.2 ),
#   ( '=', 'vs',  [0,(_k+1,-1),0,0], 1.0/1.2   ),
    ( '=', 'gam', [], 0.0  ),
    ( '=', 'dc',  [], 1e8  ),
    ( '=', 'mus', [], 0.75 ),
    ( '=', 'mud', [], 0.5 ),
    ( '=', 'tn',  [], -1.0 ),
    ( '=', 'ts',  [],  0.7 ),
    ( '=w', 'sl', [0,201,1,0], 'slip' ),
]

sord.run( locals() )

