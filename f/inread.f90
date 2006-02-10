! Read input
module inread_m
implicit none
contains

subroutine inread( filename )
use globals_m
integer :: i, err
logical :: inzone
character(*), intent(in) :: filename
character(11) :: key1, key2

if ( master ) then
  open( 9, file='log', position='append' )
  write( 9, * ) 'Reading file: ', filename
  close( 9 )
end if

open( 9, file=filename, status='old' )

doline: do

! Read line
read( 9, '(a)', iostat=err ) str
if ( err /= 0 ) exit doline

! Strip comments and MATLAB characters
i = index( str, '%' )
if ( i > 0 ) str(i:) = ' '
if ( str == ' ' ) cycle doline

! Strip MATLAB characters
do
  i = scan( str, "{}=[]/';" )
  if ( i == 0 ) exit
  str(i:i) = ' '
end do

! Read tokens
read( str, * ) key1
inzone = .false.

! Select input key
select case( key1 )
case( 'return' );      exit doline
case( 'grid' );        read( str, * ) key1, grid
case( 'gridtrans' );   read( str, * ) key1, gridtrans
case( 'gridnoise' );   read( str, * ) key1, gridnoise
case( 'rfunc' );       read( str, * ) key1, rfunc
case( 'tfunc' );       read( str, * ) key1, tfunc
case( 'nn' );          read( str, * ) key1, nn
case( 'nt' );          read( str, * ) key1, nt
case( 'dx' );          read( str, * ) key1, dx
case( 'dt' );          read( str, * ) key1, dt
case( 'upvector' );    read( str, * ) key1, upvector
case( 'viscosity' );   read( str, * ) key1, viscosity
case( 'npml' );        read( str, * ) key1, npml
case( 'bc1' );         read( str, * ) key1, bc1
case( 'bc2' );         read( str, * ) key1, bc2
case( 'xhypo' );       read( str, * ) key1, xhypo
case( 'rsource' );     read( str, * ) key1, rsource
case( 'tsource' );     read( str, * ) key1, tsource
case( 'moment1' );     read( str, * ) key1, moment1
case( 'moment2' );     read( str, * ) key1, moment2
case( 'faultnormal' ); read( str, * ) key1, faultnormal
case( 'rexpand' );     read( str, * ) key1, rexpand
case( 'n1expand' );    read( str, * ) key1, n1expand
case( 'n2expand' );    read( str, * ) key1, n2expand
case( 'ihypo' );       read( str, * ) key1, ihypo
case( 'vrup' );        read( str, * ) key1, vrup
case( 'rcrit' );       read( str, * ) key1, rcrit
case( 'trelax' );      read( str, * ) key1, trelax
case( 'svtol' );       read( str, * ) key1, svtol
case( 'np' );          read( str, * ) key1, np
case( 'itcheck' );     read( str, * ) key1, itcheck
case( 'debug' );       read( str, * ) key1, debug
case( 'rho' );         inzone = .true.
case( 'vp' );          inzone = .true.
case( 'vs' );          inzone = .true.
case( 'mus' );         inzone = .true.
case( 'mud' );         inzone = .true.
case( 'dc' );          inzone = .true.
case( 'co' );          inzone = .true.
case( 'tn' );          inzone = .true.
case( 'th' );          inzone = .true.
case( 'td' );          inzone = .true.
case( 'sxx' );         inzone = .true.
case( 'syy' );         inzone = .true.
case( 'szz' );         inzone = .true.
case( 'syz' );         inzone = .true.
case( 'szx' );         inzone = .true.
case( 'sxy' );         inzone = .true.
case( 'out' );
  nout = nout + 1
  i = nout
  read( str, * ) key1, fieldout(i), ditout(i), i1out(i,:), i2out(i,:)
case( 'lock' );
  nlock = nlock + 1
  i = nlock
  read( str, * ) key1, ilock(i,:), i1lock(i,:), i2lock(i,:)
case default
  if ( master ) then
    open( 9, file='log', position='append' )
    write( 9, * ) 'Error: bad input: ', trim( str )
    close( 9 )
  end if
  stop 'bad input'
end select

! Input zone
if ( inzone ) then
  nin = nin + 1
  i = nin
  read( str, * ) key1, key2
  if ( key2 == 'read' ) then
    readfile(nin) = .true.
    i1in(i,:) = 1
    i2in(i,:) = -1
  else
    readfile(nin) = .false.
    read( str, *, iostat=err ) fieldin(i), inval(i), i1in(i,:), i2in(i,:)
    if ( err /= 0 ) then
      i1in(i,:) = 1
      i2in(i,:) = -1
      read( str, *, iostat=err ) fieldin(i), inval(i)
    end if
  end if
end if

end do doline

close( 9 )

end subroutine
end module

