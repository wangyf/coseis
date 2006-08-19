! Checkpointing
module m_checkpoint
use m_globals
use m_collective
implicit none
contains

! Look for checkpoint and read if found
subroutine readcheckpoint
integer :: i, ip
if ( itcheck < 1 ) itcheck = itcheck + nt + 1
ip = ip3(1) + np(1) * ( ip3(2) + np(2) * ip3(3) )
write( str, '(a,i6.6)' ) 'checkpoint/it', ip
open( 1, file=str, status='old', iostat=i )
if ( i == 0 ) then
  read( 1, * ) it
  close( 1 )
end if
call pimin( i, it )
it = i
if ( it == 0 ) return
if ( master ) write( 0, * ) 'Checkpoint found, starting from ', it
write( str, '(a,i6.6,a,i6.6)' ) 'checkpoint/cp', it, '-', ip
inquire( iolength=i ) &
  t, v, u, pv, z1, z2, sl, s2, psv, trup, tarr, efrac, p1, p2, p3, p4, p5, p6, g1, g2, g3, g4, g5, g6
open( 1, file=str, recl=i, form='unformatted', access='direct', status='old' )
read( 1, rec=1 ) &
  t, v, u, pv, z1, z2, sl, s2, psv, trup, tarr, efrac, p1, p2, p3, p4, p5, p6, g1, g2, g3, g4, g5, g6
close( 1 )
end subroutine

! Write checkpoint
subroutine writecheckpoint
integer :: i, ip
open( 1, file='itcheck', status='old', iostat=i )
if ( i == 0 ) then
  read( 1, * ) itcheck
  close( 1 )
end if
if ( itcheck < 1 ) itcheck = itcheck + nt + 1
if ( modulo( it, itcheck ) /= 0 ) return
ip = ip3(1) + np(1) * ( ip3(2) + np(2) * ip3(3) )
write( str, '(a,i6.6,a,i6.6)' ) 'checkpoint/cp', it, '-', ip
inquire( iolength=i ) &
  t, v, u, pv, z1, z2, sl, s2, psv, trup, tarr, efrac, p1, p2, p3, p4, p5, p6, g1, g2, g3, g4, g5, g6
open( 1, file=str, recl=i, form='unformatted', access='direct', status='replace' )
write( 1, rec=1 ) &
  t, v, u, pv, z1, z2, sl, s2, psv, trup, tarr, efrac, p1, p2, p3, p4, p5, p6, g1, g2, g3, g4, g5, g6
close( 1 )
write( str, '(a,i6.6)' ) 'checkpoint/it', ip
open( 1, file=str, status='replace' )
write( 1, * ) it
close( 1 )
end subroutine

end module

