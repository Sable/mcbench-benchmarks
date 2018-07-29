%% Calculate central finite differences second derivative on uniform grid
function [out_d] = Deriv(x, u)
 dx = x(2)-x(1);
 r2fdx = 1./(2.*dx);
 n = length(x); I = 2:(n-1);
 out_d(1) = r2fdx*( -3.0*u(1) + 4.0*u(2) - 1.0*u(3) ); 
 out_d(I) = r2fdx*( -1.0*u(I-1) + 1.0*u(I+1) );
 out_d(n) = r2fdx*( 1.0*u(n-2) - 4.0*u(n-1) + 3.0*u(n) );
