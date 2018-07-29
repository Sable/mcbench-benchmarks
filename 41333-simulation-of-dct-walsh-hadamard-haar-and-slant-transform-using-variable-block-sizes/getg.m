function [a0,a1,b0,b1,a0r,a1r,b0r,b1r] = getg(i)
%  getg      filter g(n).
%
%  called by: slantlt, islantlt, sislet, isislet, sltmtx.
%
%  g = [a0+a1*(0:m-1), b0+b1*(0:m-1)];
%  gr = [a0r+a1r*(0:m-1), b0r+b1r*(0:m-1)];

%  Ivan Selesnick, 1997

        
m  = 2^i;
s1 = 6*sqrt( m / ( (m^2-1)*(4*m^2-1))   );
t1 = 2*sqrt( 3/ (m*(m^2-1)));
s0 = -s1 *(m-1) / 2;
t0 = ( (m+1)* s1/3 - m* t1 ) *(m-1) /(2*m);
a0 = (s0 + t0)/2;
b0 = (s0 - t0)/2;
a1 = (s1 + t1)/2;
b1 = (s1 - t1)/2;

% time reversed version
a0r = b0+b1*(m-1);
a1r = -b1;
b0r = a0+a1*(m-1);
b1r = -a1;


