%------------------------------------------------------------------------------%
% SORD Defaults
% **zones accumulate when specified multiple times

% Wave model parameters
  model		= 'defaults'			;% model identifier
  nn		= [ 41 41 42 ]			;% nx ny nz double nodes counted
  nt		= 40				;% time steps
  dx		= 100.				;% spatial step size
  dt		= .007				;% time step size
% grid		= 'slant'			;% skewed mesh
% grid		= 'read'			;% read files: x1 x2 x3
  grid		= 'constant'			;% regular mesh
% upvector	= [ 0 0 1 ];			;% positive z up
  upvector	= [ 0 -1 0 ];			;% negative y up
  rho		= [ 2670.     1 1 1  -1 -1 -1 ]	;% **density
  vp		= [ 6000.     1 1 1  -1 -1 -1 ]	;% **P-wave speed
  vs		= [ 3464.1016 1 1 1  -1 -1 -1 ]	;% **S-wave speed
% vp		= [ 600.      1 1 1  10 -1 -1 ]	;% **low velocity surface layer
% vs		= [ 346.      1 1 1  10 -1 -1 ]	;% **low velocity surface layer
% lock		= [ 1 1 0     1 1 1  -1 -1 -1 ]	;% **lock v1 & v2, v3 is free
  viscosity	= [ .0 .3 ]			;% stress (1) & hourglass (2)
% npml		= 0				;% no PML absorbing boundary
  npml		= 10				;% 10 PML nodes
% bc		= [ 1 1 1   1 1 1 ]		;% absorbing on all sides
% bc		= [ 1 1 1   1 1 0 ]		;% free surface at l=nz
  bc		= [ 1 0 1   1 1 1 ]		;% free surface at k=1
  ihypo		= [ 0 0 0 ]			;% 0=default center mesh node
  xhypo		= [ -1. -1. -1. ]		;% <0=defualt x(ihypo)

% Moment source parameters
% rfunc		= 'box'				;% uniform spatial weighting
  rfunc		= 'tent'			;% tapered spatial weighting
% tfunc		= 'delta'			;% impulse time function
% tfunc		= 'sbrune'			;% smooth Brune time fn
  tfunc		= 'brune'			;% Brune time fn
% rsource	= 150.				;% 1.5*dt = 8 nodes
  rsource	= -1.				;% no moment source
  tsource	= .056				;% dominant period of 8*dt
  moment	= [ 1e16 1e16 1e16  0. 0. 0. ]	;% explosion

% Fault parameters
% faultnormal	= 0				;% no fault
% faultnormal	= 2				;% constant k fault plane
  faultnormal	= 3				;% constant l fault plane
  mus		= [ .6        1 1 1  -1 -1 -1 ]	;% **coef of static friction
  mud		= [ .5        1 1 1  -1 -1 -1 ]	;% **coef of static friction
  dc		= [ .25       1 1 1  -1 -1 -1 ]	;% **slip-weakening distance
  co		= [ 0.        1 1 1  -1 -1 -1 ]	;% **cohesion
  tn		= [ -70e6     1 1 1  -1 -1 -1 ]	;% **pretraction on near side
  th		= [ -120e6    1 1 1  -1 -1 -1 ]	;% **pretraction on near side
  td		= [ 0.        1 1 1  -1 -1 -1 ]	;% **pretraction on near side
% sxx		= [ 0.        1 1 1  -1 -1 -1 ]	;% **prestress
% syy		= [ 0.        1 1 1  -1 -1 -1 ]	;% **prestress
% szz		= [ 0.        1 1 1  -1 -1 -1 ]	;% **prestress
% syz		= [ 0.        1 1 1  -1 -1 -1 ]	;% **prestress
% szx		= [ 0.        1 1 1  -1 -1 -1 ]	;% **prestress
% sxy		= [ 0.        1 1 1  -1 -1 -1 ]	;% **prestress
  vrup		= 3117.6914			;% nucleation rupture velocity
  rcrit		= 1000.				;% nucleation critical radius
  trelax	= .07				;% nucleation relaxation time

% Code execution and output parameters
% np		= [ 2 1 3 ]			;% 6 total processors
  np		= [ 1 1 1 ]			;% no parallelization
% itcheck	= 0				;% no checkpointing
% itcheck	= 100				;% checkpoint every 100 steps
  itcheck	= -1				;% checkpoint before finishing
% out		= { 'v'  10   1 1 1  -1 -1 -1 }	;% **write v every 10 steps
% out		= { 'sl' -1   1 1 1  -1 -1 -1 }	;% **write final slip length

