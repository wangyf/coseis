% TPV3
  np       = [    1   1   2 ];
  np       = [    1   1  16 ];
  nn       = [  350 101 256 ];
  n1expand = [    0   0  40 ];
  n2expand = [    0   0  40 ];
  bc1      = [   10  10   0 ];
  bc2      = [   10   2   0 ];
  ihypo    = [    0  -2 128 ];
  fixhypo  =     -2;
  xhypo    = [   0.  0.  0. ];
  datadir = 'scec/data/c10';
  datadir = 'scec/data/k10';
  x1  = { 'read' 'zone' 1 1 1   -1 1 -1 };
  x3  = { 'read' 'zone' 1 1 1   -1 1 -1 };
  nt  = 1500;
  dx  = 100.;
  dt  = .008;

  rho = 2670.;
  vp  = 6000.;
  vs  = 3464.;
  gam = .2;
  gam = { .02 'zone'  26 -76 61   -26 -1 -61 };
  hourglass = [ 1. 2. ];

  faultnormal = 3;
  vrup = -1.;
  dc  = 0.4;
  mud = .525;
  mus = 10000.;
  mus = { .677 'zone'  26 -76 0   -26 -1 0 };
  tn  = -120e6;
  ts1 = 70e6;
  ts1 = { 81.6e6 'zone' 161 -16 0   -161 -1 0 };

  out = { 'x'     1   26 26 128  0   -26 -1 128  0 };
  out = { 'svm' 100   26 26   0  0   -26 -1   0 -1 };
  out = { 'tsm'  -1   26 26   0  0   -26 -1   0 -1 };
  out = { 'tn'    1   26 26   0 -1   -26 -1   0 -1 };
  out = { 'su'    1   26 26   0 -1   -26 -1   0 -1 };
  out = { 'psv'   1   26 26   0 -1   -26 -1   0 -1 };
  out = { 'trup'  1   26 26   0 -1   -26 -1   0 -1 };

  out = { 'tn'    1   26  0   0  0   -26  0   0 -1 };
  out = { 'tsm'   1   26  0   0  0   -26  0   0 -1 };
  out = { 'sam'   1   26  0   0  0   -26  0   0 -1 };
  out = { 'svm'   1   26  0   0  0   -26  0   0 -1 };
  out = { 'sl'    1   26  0   0  0   -26  0   0 -1 };

  out = { 'x'     1    1  1 128  0    -1 -1 128  0 };
  out = { 'pv2'   1    1  1 128 -1    -1 -1 128 -1 };
  out = { 'vm2' 100    1  1 128  0    -1 -1 128 -1 };
  out = { 'vm2'   1    1  0 128  0    -1  0 128 -1 };
  out = { 'vm2'   1    0  1 128  0     0 -1 128 -1 };
