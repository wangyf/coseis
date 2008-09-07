# TPV3
debug = 2
np    = (  2,  3,  2 )
nn    = (  8,  8,  9 )
ihypo = ( -1, -1, -2 )
bc1   = (  0,  0,  0 )
bc2   = ( -1,  1, -2 )
fixhypo = -1
nt = 10
dx = 100
dt = 0.008

hourglass = ( 1., 1. )

faultnormal = 3
vrup = -1.

io = [
  ( 's0', 'vp',  6000.  ),
  ( 's0', 'vs',  3464.  ),
  ( 's0', 'rho', 2670.  ),
  ( 's0', 'gam', 0.1    ),
  ( 's0', 'dc',  0.4    ),
  ( 's0', 'mud', 0.525  ),
  ( 's0', 'mus', 10000. ),
  ( 'sc', 'mus', -601.,-601.,-1.,   601.,601.,1.,   0.677 ),
  ( 's0', 'tn',  -120e6 ),
  ( 's0', 'ts1',  -70e6 ),
  ( 'sc', 'ts1', -401.,-401.,-1.,   401.,401.,1.,  -81.6e6 ),
  ( 'w0', 'x',      ),
  ( 'w0', 'rho',    ),
  ( 'w0', 'vp',     ),
  ( 'w0', 'vs',     ),
  ( 'w0', 'mu',     ),
  ( 'w0', 'lam',    ),
  ( 'w*', 'v',    1 ),
  ( 'w*', 'vm2',  1 ),
  ( 'w*', 'pv2',  1 ),
  ( 'w*', 'u',    1 ),
  ( 'w*', 'um2',  1 ),
  ( 'w*', 'w',    1 ),
  ( 'w*', 'wm2',  1 ),
  ( 'w*', 'a',    1 ),
  ( 'w*', 'am2',  1 ),
  ( 'w0', 'nhat'    ),
  ( 'w0', 'mus'     ),
  ( 'w0', 'mud'     ),
  ( 'w0', 'dc'      ),
  ( 'w0', 'co'      ),
  ( 'w*', 'ts',   1 ),
  ( 'w*', 'tsm',  1 ),
  ( 'w*', 'tn',   1 ),
  ( 'w*', 'sv',   1 ),
  ( 'w*', 'svm',  1 ),
  ( 'w*', 'psv',  1 ),
  ( 'w*', 'su',   1 ),
  ( 'w*', 'sum',  1 ),
  ( 'w*', 'sl',   1 ),
  ( 'w*', 'sa',   1 ),
  ( 'w*', 'sam',  1 ),
  ( 'w*', 'trup', 1 ),
  ( 'w*', 'tarr', 1 ),
  ( 'wx', 'v',  -200.,    0.,    0. ),
  ( 'wx', 'sv', -200.,    0.,    0. ),
  ( 'wx', 'v',     0.,    0.,    0. ),
  ( 'wx', 'v',  -801., -700., -700. ),
  ( 'wx', 'v',   101.,    0.,    0. ),
]
