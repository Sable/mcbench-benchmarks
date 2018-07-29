function xyr = Xr(s,row,b0,b1)

if nargin == 1
    row = 2. ;
    b0 = 1. ;
    b1 = 2. ;
end

x = 0 ;

y = -(b0+(b1-b0)*s) ;

xyr = [x ; y] ;