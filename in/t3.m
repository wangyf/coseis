% TPV3
  faultnormal = 3;
  vrup = -1.;
  out = { 'x'    1      1 1 1   -1 -1 -1 };
  out = { 'v'    10     1 1 1   -1 -1 -1 };
  out = { 'sv'   1      1 1 1   -1 -1 -1 };
  out = { 'sl'   1      1 1 1   -1 -1 -1 };
  out = { 'trup' 100    1 1 1   -1 -1 -1 };
  vp  = 6000.;
  vs  = 3464.;
  rho = 2670.;
  dc  = 0.4;
  mud = .525;
  mus = 10000.;
  mus = { .677    'cube' -15001. -7501. -1.  15001. 7501. 1. };
  tn  = -120e6;
  td  = 0.;
  th  = -70e6;
  th  = { -81.6e6 'cube'  -1501. -1501. -1.   1501. 1501. 1. };
  viscosity = [ .1 .7 ];
  origin = 0;
  dx  = 100;
  dt  = .008;
  nt  = 900;

% no strain
  gridtrans = [ 1. 0. 0.; 0. 1. 0.; 0. 0. 1. ] / 1.;
  nn    = [ 176 101 61 ];
  bc1   = [  1  1  1 ];
  bc2   = [ -3  3 -2 ];
  ihypo = [ -1 -1 -1 ];

% shear 3
  gridtrans = [ 1. 1. 0.; 0. 1. 0.; 0. 0. 1. ] / 1.;
  nn    = [ 401 201 61 ];
  bc1   = [  0  1  1 ];
  bc2   = [  0  1 -3 ];
  ihypo = [  0  0 -1 ];

% shear 2
  gridtrans = [ 1. 0. 1.; 0. 1. 0.; 0. 0. 1. ] / 1.;
  nn    = [ 351 101 122 ];
  bc1   = [  0  1  1 ];
  bc2   = [  0  3  1 ];
  ihypo = [  0 -1  0 ];

% shear 1
  gridtrans = [ 1. 0. 0.; 0. 1. 1.; 0. 0. 1. ] / 1.;
  nn    = [ 176 201 122 ];
  bc1   = [  1  0  1 ];
  bc2   = [ -3  0  1 ];
  ihypo = [ -1  0  0 ];

% shear 2 symmetric
  gridtrans = [ 1. 0. 1.; 0. 1. 0.; 0. 0. 1. ] / 1.;
  nn    = [ 351 101 61 ];
  bc1   = [  0  1  1 ];
  bc2   = [  0  3 -3 ];
  ihypo = [  0 -1 -1 ];

% shear 3 symmetric
  gridtrans = [ 1. 1. 0.; 0. 1. 0.; 0. 0. 1. ] / 1.;
  nn    = [ 401 101 61 ];
  bc1   = [  0  0  1 ];
  bc2   = [  0  3 -3 ];
  ihypo = [  0 -1 -1 ];

% shear 1 symmetric
  gridtrans = [ 1. 0. 0.; 0. 1. 1.; 0. 0. 1. ] / 1.;
  nn    = [ 176 201 61 ];
  bc1   = [  1  0  0 ];
  bc2   = [ -3  0 -3 ];
  ihypo = [ -1  0 -1 ];
  n1expand = [ 0 0 0 ];
  n2expand = [ 0 0 0 ];

