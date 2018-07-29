function xyb = Xb(s,row,b0,b1)

if nargin == 1
    row = 2. ;
    b0 = 1. ;
    b1 = 2. ;
end

x = row*b0*cos(pi/2*(1-2*s)) ;

y = b0*sin(pi/2*(1-2*s)) ;

xyb = [x ; y] ;