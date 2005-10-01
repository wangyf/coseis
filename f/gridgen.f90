!------------------------------------------------------------------------------!
! Grid generation

module gridgen_m
use globals_m
use collective_m
use collectiveio_m
use optimize_m
use zone_m
contains
subroutine gridgen

implicit none
real :: theta, scl
integer :: i, j, k, l, i1(3), j1, k1, l1, i2(3), j2, k2, l2, up, n(3), &
  noff(3), idoublenode
real :: lj, lk, ll

if ( master ) print '(a)', 'Grid generation'

! Indices
i1 = i1cell
i2 = i2cell + 1
j1 = i1(1); j2 = i2(1)
k1 = i1(2); k2 = i2(2)
l1 = i1(3); l2 = i2(3)

! Single node indexing
n = nn
noff = nnoff
if ( ifn /= 0 ) then
  n(ifn) = n(ifn) - 1
  if ( ihypo(ifn) < 1 ) then
    noff = noff + 1
  else if ( ihypo(ifn) <= i2cell(ifn) ) then
    idoublenode = ifn
  end if
end if

! Dimensions
lj = dx * ( n(1) - 1 )
lk = dx * ( n(2) - 1 )
ll = dx * ( n(3) - 1 )

! Coordinate system
print *, 999999, maxloc( abs( upvector ) )
!l = maxloc( abs( upvector ) )
l = 1
up = sign( 1., upvector(l) )
if ( ifn == 0 .or. ifn == l ) then
  k = modulo( l + 1, 3 ) + 1
else
  k = ifn
end if
j = 6 - k - l

! Read grid files or create basic rectangular mesh
x = 0.
if ( grid == 'read' ) then
  call iovector( 'r', 'data/x1', x, 1, i1, i2, n, noff, 0 )
  call iovector( 'r', 'data/x2', x, 2, i1, i2, n, noff, 0 )
  call iovector( 'r', 'data/x3', x, 3, i1, i2, n, noff, 0 )
else
  forall( i=j1:j2 ) x(i,:,:,1) = dx * ( i - 1 - noff(1) )
  forall( i=k1:k2 ) x(:,i,:,2) = dx * ( i - 1 - noff(2) )
  forall( i=l1:l2 ) x(:,:,i,3) = dx * ( i - 1 - noff(3) )
end if

! Mesh type
select case( grid )
case( 'read' )
  oper = 'o'
case( 'constant' )
  oper = 'h'
case( 'stretch' )
  oper = 'r'
  x(:,:,:,l) = 2. * x(:,:,:,l)
case( 'slant' )
  oper = 'g'
  theta = 20. * pi / 180.
  scl = sqrt( cos( theta ) ** 2. + ( 1. - sin( theta ) ) ** 2. )
  scl = sqrt( 2. ) / scl
  x(:,:,:,j) = x(:,:,:,j) - x(:,:,:,l) * sin( theta );
  x(:,:,:,l) = x(:,:,:,l) * cos( theta );
  x(:,:,:,j) = x(:,:,:,j) * scl;
  x(:,:,:,l) = x(:,:,:,l) * scl;
case( 'rand' )
  ! note: does not work for domain decomposition
  ! would have to swap edge values
  oper = 'g'
  call random_number( w1 )
  w1 = .2 * ( w1 - .5 )
  w1(j1,:,:,1) = 0.; w1(j2,:,:,1) = 0.
  w1(:,k1,:,2) = 0.; w1(:,k2,:,2) = 0.
  w1(:,:,l1,3) = 0.; w1(:,:,l2,3) = 0.
  j = ihypo(1)
  k = ihypo(2)
  l = ihypo(3)
  select case( ifn )
  case( 1 ); w1(j,:,:,1) = 0.; w1(j+1,:,:,1) = 0.
  case( 2 ); w1(:,k,:,2) = 0.; w1(:,k+1,:,2) = 0.
  case( 3 ); w1(:,:,k,3) = 0.; w1(:,:,k+1,3) = 0.
  end select
  x = x + w1
case( 'spherical' )
case default; stop 'grid'
end select

! Duplicate edge nodes into halo, but not for decomp edges
if( ip3(1) == 0         ) x(j1-1,:,:,:) = x(j1,:,:,:)
if( ip3(1) == np(1) - 1 ) x(j2+1,:,:,:) = x(j2,:,:,:)
if( ip3(2) == 0         ) x(:,j1-1,:,:) = x(:,j1,:,:)
if( ip3(2) == np(2) - 1 ) x(:,k2+1,:,:) = x(:,k2,:,:)
if( ip3(3) == 0         ) x(:,:,j1-1,:) = x(:,:,j1,:)
if( ip3(3) == np(3) - 1 ) x(:,:,l2+1,:) = x(:,:,l2,:)

! Create fault double nodes
if ( ifn /= 0 ) i = ihypo(ifn)
select case( idoublenode )
case( 1 ); x(i+1:j2,:,:,:) = x(i:j2-1,:,:,:)
case( 2 ); x(:,i+1:k2,:,:) = x(:,i:k2-1,:,:)
case( 3 ); x(:,:,i+1:l2,:) = x(:,:,i:l2-1,:)
end select

! Assign fast operators to rectangular mesh portions
noper = 1
i1oper(1,:) = i1
i2oper(1,:) = i2
if ( oper(1) == 'o' ) call optimize

! Hypocenter location
if ( all( xhypo < 0. ) ) then
  if ( master ) then
    j = ihypo(1)
    k = ihypo(2)
    l = ihypo(3)
    xhypo = x(j,k,l,:)
  end if
  call broadcast( xhypo )
end if

end subroutine
end module
