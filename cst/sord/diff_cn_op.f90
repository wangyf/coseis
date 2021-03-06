! difference operator, cell to node
module diff_cn_op
implicit none
contains

subroutine diff_cn(df, f, i, a, i1, i2, diffop, bb, x, dx1, dx2, dx3, dx)
real, intent(out) :: df(:,:,:)
real, intent(in) :: f(:,:,:,:), bb(:,:,:,:,:), x(:,:,:,:), &
    dx1(:), dx2(:), dx3(:), dx(3)
integer, intent(in) :: i, a, i1(3), i2(3)
character(4), intent(in) :: diffop
real :: h, b1, b2, b3, b4, b5, b6, b7, b8
integer :: j, k, l, b, c

if (any(i1 > i2)) return

select case (diffop)

! saved b matrix, flops: 8* 7+
case ('save')
!$omp parallel do schedule(static) private(j, k, l)
do l = i1(3), i2(3)
do k = i1(2), i2(2)
do j = i1(1), i2(1)
    df(j,k,l) = &
    - bb(j-1,k-1,l-1,1,a) * f(j-1,k-1,l-1,i) &
    - bb(j,  k-1,l-1,6,a) * f(j,  k-1,l-1,i) &
    - bb(j-1,k,l-1,7,a) * f(j-1,k,l-1,i) &
    - bb(j,  k,l-1,4,a) * f(j,  k,l-1,i)
end do
do j = i1(1), i2(1)
    df(j,k,l) = df(j,k,l) &
    - bb(j-1,k-1,l,8,a) * f(j-1,k-1,l,i) &
    - bb(j,  k-1,l,3,a) * f(j,  k-1,l,i) &
    - bb(j-1,k,l,2,a) * f(j-1,k,l,i) &
    - bb(j,  k,l,5,a) * f(j,  k,l,i)
end do
end do
end do
!$omp end parallel do

! constant grid, flops: 1* 7+
case ('cons')
select case (a)
case (1)
    h = sign(0.25 * dx(2) * dx(3), dx(1))
    !$omp parallel do schedule(static) private(j, k, l)
    do l = i1(3), i2(3)
    do k = i1(2), i2(2)
    do j = i1(1), i2(1)
        df(j,k,l) = h * &
        ( f(j,k,l,i) - f(j-1,k-1,l-1,i) &
        + f(j,k-1,l-1,i) - f(j-1,k,l,i) &
        - f(j-1,k,l-1,i) + f(j,k-1,l,i) &
        - f(j-1,k-1,l,i) + f(j,k,l-1,i) )
    end do
    end do
    end do
    !$omp end parallel do
case (2)
    h = sign(0.25 * dx(3) * dx(1), dx(2))
    !$omp parallel do schedule(static) private(j, k, l)
    do l = i1(3), i2(3)
    do k = i1(2), i2(2)
    do j = i1(1), i2(1)
        df(j,k,l) = h * &
        ( f(j,k,l,i) - f(j-1,k-1,l-1,i) &
        - f(j,k-1,l-1,i) + f(j-1,k,l,i) &
        + f(j-1,k,l-1,i) - f(j,k-1,l,i) &
        - f(j-1,k-1,l,i) + f(j,k,l-1,i) )
    end do
    end do
    end do
    !$omp end parallel do
case (3)
    h = sign(0.25 * dx(1) * dx(2), dx(3))
    !$omp parallel do schedule(static) private(j, k, l)
    do l = i1(3), i2(3)
    do k = i1(2), i2(2)
    do j = i1(1), i2(1)
        df(j,k,l) = h * &
        ( f(j,k,l,i) - f(j-1,k-1,l-1,i) &
        - f(j,k-1,l-1,i) + f(j-1,k,l,i) &
        - f(j-1,k,l-1,i) + f(j,k-1,l,i) &
        + f(j-1,k-1,l,i) - f(j,k,l-1,i) )
    end do
    end do
    end do
    !$omp end parallel do
end select

! rectangular grid, flops: 6* 7+
case ('rect')
h = sign(0.25, product(dx))
select case (a)
case (1)
    !$omp parallel do schedule(static) private(j, k, l)
    do l = i1(3), i2(3)
    do k = i1(2), i2(2)
    do j = i1(1), i2(1)
    df(j,k,l) = h * ( &
    dx3(l)   * (dx2(k) * (f(j,k,l,i)   - f(j-1,k,l,i))   + dx2(k-1) * (f(j,k-1,l,i)   - f(j-1,k-1,l,i))) + &
    dx3(l-1) * (dx2(k) * (f(j,k,l-1,i) - f(j-1,k,l-1,i)) + dx2(k-1) * (f(j,k-1,l-1,i) - f(j-1,k-1,l-1,i))) )
    end do
    end do
    end do
    !$omp end parallel do
case (2)
    !$omp parallel do schedule(static) private(j, k, l)
    do l = i1(3), i2(3)
    do k = i1(2), i2(2)
    do j = i1(1), i2(1)
    df(j,k,l) = h * ( &
    dx1(j)   * (dx3(l) * (f(j,k,l,i)   - f(j,k-1,l,i))   + dx3(l-1) * (f(j,k,l-1,i)   - f(j,k-1,l-1,i))) + &
    dx1(j-1) * (dx3(l) * (f(j-1,k,l,i) - f(j-1,k-1,l,i)) + dx3(l-1) * (f(j-1,k,l-1,i) - f(j-1,k-1,l-1,i))) )
    end do
    end do
    end do
    !$omp end parallel do
case (3)
    !$omp parallel do schedule(static) private(j, k, l)
    do l = i1(3), i2(3)
    do k = i1(2), i2(2)
    do j = i1(1), i2(1)
    df(j,k,l) = h * ( &
    dx2(k)   * (dx1(j) * (f(j,k,l,i)   - f(j,k,l-1,i))   + dx1(j-1) * (f(j-1,k,l,i)   - f(j-1,k,l-1,i))) + &
    dx2(k-1) * (dx1(j) * (f(j,k-1,l,i) - f(j,k-1,l-1,i)) + dx1(j-1) * (f(j-1,k-1,l,i) - f(j-1,k-1,l-1,i))) )
    end do
    end do
    end do
    !$omp end parallel do
end select

! parallelepiped grid, flops: 33* 47+
case ('para')
h = sign(0.25, product(dx))
b = modulo(a, 3) + 1
c = modulo(a + 1, 3) + 1
!$omp parallel do schedule(static) private(j, k, l)
do l = i1(3), i2(3)
do k = i1(2), i2(2)
do j = i1(1), i2(1)
    b1 = &
    ( x(j+1,k,l,b) * (x(j,k+1,l,c) - x(j,k,l+1,c)) &
    + x(j,k+1,l,b) * (x(j,k,l+1,c) - x(j+1,k,l,c)) &
    + x(j,k,l+1,b) * (x(j+1,k,l,c) - x(j,k+1,l,c)) )
    b2 = &
    ( x(j+1,k,l,b) * (x(j,k-1,l,c) - x(j,k,l-1,c)) &
    + x(j,k-1,l,b) * (x(j,k,l-1,c) - x(j+1,k,l,c)) &
    + x(j,k,l-1,b) * (x(j+1,k,l,c) - x(j,k-1,l,c)) )
    b3 = &
    ( x(j,k+1,l,b) * (x(j,k,l-1,c) - x(j-1,k,l,c)) &
    + x(j,k,l-1,b) * (x(j-1,k,l,c) - x(j,k+1,l,c)) &
    + x(j-1,k,l,b) * (x(j,k+1,l,c) - x(j,k,l-1,c)) )
    b4 = &
    ( x(j,k,l+1,b) * (x(j-1,k,l,c) - x(j,k-1,l,c)) &
    + x(j-1,k,l,b) * (x(j,k-1,l,c) - x(j,k,l+1,c)) &
    + x(j,k-1,l,b) * (x(j,k,l+1,c) - x(j-1,k,l,c)) )
    b5 = &
    ( x(j-1,k,l,b) * (x(j,k,l-1,c) - x(j,k-1,l,c)) &
    + x(j,k-1,l,b) * (x(j-1,k,l,c) - x(j,k,l-1,c)) &
    + x(j,k,l-1,b) * (x(j,k-1,l,c) - x(j-1,k,l,c)) )
    b6 = &
    ( x(j-1,k,l,b) * (x(j,k,l+1,c) - x(j,k+1,l,c)) &
    + x(j,k+1,l,b) * (x(j-1,k,l,c) - x(j,k,l+1,c)) &
    + x(j,k,l+1,b) * (x(j,k+1,l,c) - x(j-1,k,l,c)) )
    b7 = &
    ( x(j,k-1,l,b) * (x(j+1,k,l,c) - x(j,k,l+1,c)) &
    + x(j,k,l+1,b) * (x(j,k-1,l,c) - x(j+1,k,l,c)) &
    + x(j+1,k,l,b) * (x(j,k,l+1,c) - x(j,k-1,l,c)) )
    b8 = &
    ( x(j,k,l-1,b) * (x(j,k+1,l,c) - x(j+1,k,l,c)) &
    + x(j+1,k,l,b) * (x(j,k,l-1,c) - x(j,k+1,l,c)) &
    + x(j,k+1,l,b) * (x(j+1,k,l,c) - x(j,k,l-1,c)) )
    df(j,k,l) = h * &
    ( b1 * f(j,k,l,i) + f(j-1,k-1,l-1,i) * b5 &
    + b2 * f(j,k-1,l-1,i) + f(j-1,k,l,i) * b6 &
    + b3 * f(j-1,k,l-1,i) + f(j,k-1,l,i) * b7 &
    + b4 * f(j-1,k-1,l,i) + f(j,k,l-1,i) * b8 )
end do
end do
end do
!$omp end parallel do

! general grid one-point quadrature, flops: 33* 119+
case ('quad')
h = sign(0.0625, product(dx))
b = modulo(a, 3) + 1
c = modulo(a + 1, 3) + 1
!$omp parallel do schedule(static) private(j, k, l)
do l = i1(3), i2(3)
do k = i1(2), i2(2)
do j = i1(1), i2(1)
b1 = &
( (x(j+1,k,l,b) - x(j,k+1,l+1,b)) * (x(j,k+1,l,c) - x(j+1,k,l+1,c) - x(j,k,l+1,c) + x(j+1,k+1,l,c)) &
+ (x(j,k+1,l,b) - x(j+1,k,l+1,b)) * (x(j,k,l+1,c) - x(j+1,k+1,l,c) - x(j+1,k,l,c) + x(j,k+1,l+1,c)) &
+ (x(j,k,l+1,b) - x(j+1,k+1,l,b)) * (x(j+1,k,l,c) - x(j,k+1,l+1,c) - x(j,k+1,l,c) + x(j+1,k,l+1,c)) )
b2 = &
( (x(j+1,k,l,b) - x(j,k-1,l-1,b)) * (x(j,k-1,l,c) - x(j+1,k,l-1,c) - x(j,k,l-1,c) + x(j+1,k-1,l,c)) &
+ (x(j,k-1,l,b) - x(j+1,k,l-1,b)) * (x(j,k,l-1,c) - x(j+1,k-1,l,c) - x(j+1,k,l,c) + x(j,k-1,l-1,c)) &
+ (x(j,k,l-1,b) - x(j+1,k-1,l,b)) * (x(j+1,k,l,c) - x(j,k-1,l-1,c) - x(j,k-1,l,c) + x(j+1,k,l-1,c)) )
b3 = &
( (x(j,k+1,l,b) - x(j-1,k,l-1,b)) * (x(j,k,l-1,c) - x(j-1,k+1,l,c) - x(j-1,k,l,c) + x(j,k+1,l-1,c)) &
+ (x(j,k,l-1,b) - x(j-1,k+1,l,b)) * (x(j-1,k,l,c) - x(j,k+1,l-1,c) - x(j,k+1,l,c) + x(j-1,k,l-1,c)) &
+ (x(j-1,k,l,b) - x(j,k+1,l-1,b)) * (x(j,k+1,l,c) - x(j-1,k,l-1,c) - x(j,k,l-1,c) + x(j-1,k+1,l,c)) )
b4 = &
( (x(j,k,l+1,b) - x(j-1,k-1,l,b)) * (x(j-1,k,l,c) - x(j,k-1,l+1,c) - x(j,k-1,l,c) + x(j-1,k,l+1,c)) &
+ (x(j-1,k,l,b) - x(j,k-1,l+1,b)) * (x(j,k-1,l,c) - x(j-1,k,l+1,c) - x(j,k,l+1,c) + x(j-1,k-1,l,c)) &
+ (x(j,k-1,l,b) - x(j-1,k,l+1,b)) * (x(j,k,l+1,c) - x(j-1,k-1,l,c) - x(j-1,k,l,c) + x(j,k-1,l+1,c)) )
b5 = &
( (x(j-1,k,l,b) - x(j,k-1,l-1,b)) * (x(j-1,k,l-1,c) - x(j,k-1,l,c) - x(j-1,k-1,l,c) + x(j,k,l-1,c)) &
+ (x(j,k-1,l,b) - x(j-1,k,l-1,b)) * (x(j-1,k-1,l,c) - x(j,k,l-1,c) - x(j,k-1,l-1,c) + x(j-1,k,l,c)) &
+ (x(j,k,l-1,b) - x(j-1,k-1,l,b)) * (x(j,k-1,l-1,c) - x(j-1,k,l,c) - x(j-1,k,l-1,c) + x(j,k-1,l,c)) )
b6 = &
( (x(j-1,k,l,b) - x(j,k+1,l+1,b)) * (x(j-1,k,l+1,c) - x(j,k+1,l,c) - x(j-1,k+1,l,c) + x(j,k,l+1,c)) &
+ (x(j,k+1,l,b) - x(j-1,k,l+1,b)) * (x(j-1,k+1,l,c) - x(j,k,l+1,c) - x(j,k+1,l+1,c) + x(j-1,k,l,c)) &
+ (x(j,k,l+1,b) - x(j-1,k+1,l,b)) * (x(j,k+1,l+1,c) - x(j-1,k,l,c) - x(j-1,k,l+1,c) + x(j,k+1,l,c)) )
b7 = &
( (x(j,k-1,l,b) - x(j+1,k,l+1,b)) * (x(j+1,k-1,l,c) - x(j,k,l+1,c) - x(j,k-1,l+1,c) + x(j+1,k,l,c)) &
+ (x(j,k,l+1,b) - x(j+1,k-1,l,b)) * (x(j,k-1,l+1,c) - x(j+1,k,l,c) - x(j+1,k,l+1,c) + x(j,k-1,l,c)) &
+ (x(j+1,k,l,b) - x(j,k-1,l+1,b)) * (x(j+1,k,l+1,c) - x(j,k-1,l,c) - x(j+1,k-1,l,c) + x(j,k,l+1,c)) )
b8 = &
( (x(j,k,l-1,b) - x(j+1,k+1,l,b)) * (x(j,k+1,l-1,c) - x(j+1,k,l,c) - x(j+1,k,l-1,c) + x(j,k+1,l,c)) &
+ (x(j+1,k,l,b) - x(j,k+1,l-1,b)) * (x(j+1,k,l-1,c) - x(j,k+1,l,c) - x(j+1,k+1,l,c) + x(j,k,l-1,c)) &
+ (x(j,k+1,l,b) - x(j+1,k,l-1,b)) * (x(j+1,k+1,l,c) - x(j,k,l-1,c) - x(j,k+1,l-1,c) + x(j+1,k,l,c)) )
df(j,k,l) = h * &
( b1 * f(j,k,l,i) + f(j-1,k-1,l-1,i) * b5 &
+ b2 * f(j,k-1,l-1,i) + f(j-1,k,l,i) * b6 &
+ b3 * f(j-1,k,l-1,i) + f(j,k-1,l,i) * b7 &
+ b4 * f(j-1,k-1,l,i) + f(j,k,l-1,i) * b8 )
end do
end do
end do
!$omp end parallel do

! general grid exact, flops: 57* 119+
case ('exac')
h = sign(1.0 / 12.0, product(dx))
b = modulo(a, 3) + 1
c = modulo(a + 1, 3) + 1
!$omp parallel do schedule(static) private(j, k, l)
do l = i1(3), i2(3)
do k = i1(2), i2(2)
do j = i1(1), i2(1)
b5 = &
( (x(j-1,k,l,b) - x(j,k-1,l-1,b)) * (x(j,k,l-1,c) - x(j,k-1,l,c)) + x(j-1,k,l,b) * (x(j-1,k,l-1,c) - x(j-1,k-1,l,c)) &
+ (x(j,k-1,l,b) - x(j-1,k,l-1,b)) * (x(j-1,k,l,c) - x(j,k,l-1,c)) + x(j,k-1,l,b) * (x(j-1,k-1,l,c) - x(j,k-1,l-1,c)) &
+ (x(j,k,l-1,b) - x(j-1,k-1,l,b)) * (x(j,k-1,l,c) - x(j-1,k,l,c)) + x(j,k,l-1,b) * (x(j,k-1,l-1,c) - x(j-1,k,l-1,c)) )
b2 = &
( (x(j+1,k,l,b) - x(j,k-1,l-1,b)) * (x(j,k-1,l,c) - x(j,k,l-1,c)) + x(j+1,k,l,b) * (x(j+1,k-1,l,c) - x(j+1,k,l-1,c)) &
+ (x(j,k-1,l,b) - x(j+1,k,l-1,b)) * (x(j,k,l-1,c) - x(j+1,k,l,c)) + x(j,k-1,l,b) * (x(j,k-1,l-1,c) - x(j+1,k-1,l,c)) &
+ (x(j,k,l-1,b) - x(j+1,k-1,l,b)) * (x(j+1,k,l,c) - x(j,k-1,l,c)) + x(j,k,l-1,b) * (x(j+1,k,l-1,c) - x(j,k-1,l-1,c)) )
df(j,k,l) = h * &
( b5 * f(j-1,k-1,l-1,i) &
+ b2 * f(j,  k-1,l-1,i) )
end do
do j = i1(1), i2(1)
b4 = &
( (x(j,k,l+1,b) - x(j-1,k-1,l,b)) * (x(j-1,k,l,c) - x(j,k-1,l,c)) + x(j,k,l+1,b) * (x(j-1,k,l+1,c) - x(j,k-1,l+1,c)) &
+ (x(j-1,k,l,b) - x(j,k-1,l+1,b)) * (x(j,k-1,l,c) - x(j,k,l+1,c)) + x(j-1,k,l,b) * (x(j-1,k-1,l,c) - x(j-1,k,l+1,c)) &
+ (x(j,k-1,l,b) - x(j-1,k,l+1,b)) * (x(j,k,l+1,c) - x(j-1,k,l,c)) + x(j,k-1,l,b) * (x(j,k-1,l+1,c) - x(j-1,k-1,l,c)) )
b7 = &
( (x(j,k-1,l,b) - x(j+1,k,l+1,b)) * (x(j+1,k,l,c) - x(j,k,l+1,c)) + x(j,k-1,l,b) * (x(j+1,k-1,l,c) - x(j,k-1,l+1,c)) &
+ (x(j,k,l+1,b) - x(j+1,k-1,l,b)) * (x(j,k-1,l,c) - x(j+1,k,l,c)) + x(j,k,l+1,b) * (x(j,k-1,l+1,c) - x(j+1,k,l+1,c)) &
+ (x(j+1,k,l,b) - x(j,k-1,l+1,b)) * (x(j,k,l+1,c) - x(j,k-1,l,c)) + x(j+1,k,l,b) * (x(j+1,k,l+1,c) - x(j+1,k-1,l,c)) )
df(j,k,l) = df(j,k,l) + h * &
( b4 * f(j-1,k-1,l,i) &
+ b7 * f(j,  k-1,l,i) )
end do
do j = i1(1), i2(1)
b3 = &
( (x(j,k+1,l,b) - x(j-1,k,l-1,b)) * (x(j,k,l-1,c) - x(j-1,k,l,c)) + x(j,k+1,l,b) * (x(j,k+1,l-1,c) - x(j-1,k+1,l,c)) &
+ (x(j,k,l-1,b) - x(j-1,k+1,l,b)) * (x(j-1,k,l,c) - x(j,k+1,l,c)) + x(j,k,l-1,b) * (x(j-1,k,l-1,c) - x(j,k+1,l-1,c)) &
+ (x(j-1,k,l,b) - x(j,k+1,l-1,b)) * (x(j,k+1,l,c) - x(j,k,l-1,c)) + x(j-1,k,l,b) * (x(j-1,k+1,l,c) - x(j-1,k,l-1,c)) )
b8 = &
( (x(j,k,l-1,b) - x(j+1,k+1,l,b)) * (x(j,k+1,l,c) - x(j+1,k,l,c)) + x(j,k,l-1,b) * (x(j,k+1,l-1,c) - x(j+1,k,l-1,c)) &
+ (x(j+1,k,l,b) - x(j,k+1,l-1,b)) * (x(j,k,l-1,c) - x(j,k+1,l,c)) + x(j+1,k,l,b) * (x(j+1,k,l-1,c) - x(j+1,k+1,l,c)) &
+ (x(j,k+1,l,b) - x(j+1,k,l-1,b)) * (x(j+1,k,l,c) - x(j,k,l-1,c)) + x(j,k+1,l,b) * (x(j+1,k+1,l,c) - x(j,k+1,l-1,c)) )
df(j,k,l) = df(j,k,l) + h * &
( b3 * f(j-1,k,l-1,i) &
+ b8 * f(j,  k,l-1,i) )
end do
do j = i1(1), i2(1)
b6 = &
( (x(j-1,k,l,b) - x(j,k+1,l+1,b)) * (x(j,k,l+1,c) - x(j,k+1,l,c)) + x(j-1,k,l,b) * (x(j-1,k,l+1,c) - x(j-1,k+1,l,c)) &
+ (x(j,k+1,l,b) - x(j-1,k,l+1,b)) * (x(j-1,k,l,c) - x(j,k,l+1,c)) + x(j,k+1,l,b) * (x(j-1,k+1,l,c) - x(j,k+1,l+1,c)) &
+ (x(j,k,l+1,b) - x(j-1,k+1,l,b)) * (x(j,k+1,l,c) - x(j-1,k,l,c)) + x(j,k,l+1,b) * (x(j,k+1,l+1,c) - x(j-1,k,l+1,c)) )
b1 = &
( (x(j+1,k,l,b) - x(j,k+1,l+1,b)) * (x(j,k+1,l,c) - x(j,k,l+1,c)) + x(j+1,k,l,b) * (x(j+1,k+1,l,c) - x(j+1,k,l+1,c)) &
+ (x(j,k+1,l,b) - x(j+1,k,l+1,b)) * (x(j,k,l+1,c) - x(j+1,k,l,c)) + x(j,k+1,l,b) * (x(j,k+1,l+1,c) - x(j+1,k+1,l,c)) &
+ (x(j,k,l+1,b) - x(j+1,k+1,l,b)) * (x(j+1,k,l,c) - x(j,k+1,l,c)) + x(j,k,l+1,b) * (x(j+1,k,l+1,c) - x(j,k+1,l+1,c)) )
df(j,k,l) = df(j,k,l) + h * &
( b6 * f(j-1,k,l,i) &
+ b1 * f(j,  k,l,i) )
end do
end do
end do
!$omp end parallel do

case default
stop 'illegal operator'

end select

end subroutine

end module

