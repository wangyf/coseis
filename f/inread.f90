!------------------------------------------------------------------------------!
! Read input

module inread_m
use globals_m
contains
subroutine inread( filename )

implicit none
character(*), intent(in) :: filename
character(16) :: key1, key2
integer :: i, err
logical :: inzone

if ( master ) print '(2a)', 'Reading file: ', filename

open( 9, file=filename, status='old' )

doline: do

! Read line
read( 9, '(a)', iostat=err ) str
if ( err /= 0 ) exit doline

! Strip comments and MATLAB characters
i = index( str, '%' )
if ( i > 0 ) str(i:) = ' '
if ( str == ' ' ) cycle doline

!if ( master ) print '(a)', trim( str )

! Strip MATLAB characters
do
  i = scan( str, "{}=[]';" )
  if ( i == 0 ) exit
  str(i:i) = ' '
end do

! Read tokens
read( str, * ) key1, key2
inzone = .false.

! Select input key
selectkey: select case( key1 )
case( 'return' );      exit doline
case( 'model' );       model = key2
case( 'grid' );        grid  = key2
case( 'rfunc' );       rfunc = key2
case( 'tfunc' );       tfunc = key2
case( 'nn' );          read( str, * ) key1, nn
case( 'nt' );          read( str, * ) key1, nt
case( 'dx' );          read( str, * ) key1, dx
case( 'dt' );          read( str, * ) key1, dt
case( 'upvector' );    read( str, * ) key1, upvector
case( 'viscosity' );   read( str, * ) key1, viscosity
case( 'npml' );        read( str, * ) key1, npml
case( 'bc' );          read( str, * ) key1, bc1, bc2
case( 'xhypo' );       read( str, * ) key1, xhypo
case( 'rsource' );     read( str, * ) key1, rsource
case( 'tsource' );     read( str, * ) key1, tsource
case( 'moment' );      read( str, * ) key1, moment1, moment2
case( 'faultnormal' ); read( str, * ) key1, faultnormal
case( 'ihypo' );       read( str, * ) key1, ihypo
case( 'vrup' );        read( str, * ) key1, vrup
case( 'rcrit' );       read( str, * ) key1, rcrit
case( 'trelax' );      read( str, * ) key1, trelax
case( 'np' );          read( str, * ) key1, np
case( 'itcheck' );     read( str, * ) key1, itcheck
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
  read( str, * ) key1, lock(i,:), i1lock(i,:), i2lock(i,:)
case default; print '(2a)', 'Bad input: ', trim( str ); stop
end select selectkey

! Input zone
if ( inzone ) then
  nin = nin + 1
  i = nin
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
