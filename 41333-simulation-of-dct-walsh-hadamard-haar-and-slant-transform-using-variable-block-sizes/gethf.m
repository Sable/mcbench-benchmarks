function [a0,a1,b0,b1,c0,c1,d0,d1] = gethf(l)
%  gethf     filters h(n) and f(n).
%
%  called by: slantlt, islantlt, sislet, isislet, sltmtx.
%
%  [a0,a1,b0,b1,c0,c1,d0,d1] = gethf(l);
%  m = 2^l;
%  h = [a0+a1*(0:m-1), b0+b1*(0:m-1)];
%  f = [c0+c1*(0:m-1), d0+d1*(0:m-1)];

%  Ivan Selesnick, 1997

m = 2^l;
u  = 1/sqrt(m);
v  = sqrt((2* m^2+1)/3);
a0 = u*(v+1)/(2*m) ;
b0 = u*(2*m-v-1)/(2*m) ;
a1 = u/m ;
b1 = -a1 ;

r = -sqrt((3*m-sqrt(6*m^2+3))/(3*m+sqrt(6*m^2+3)));
c0 = r*a0;
c1 = r*a1;
d0 = -b0/r;
d1 = -b1/r;

% h = [a0+a1*(0:m-1), b0+b1*(0:m-1)];
% f = [c0+c1*(0:m-1), d0+d1*(0:m-1)];


% old way:
% q  = sqrt(3/(m*(m^2-1)))/m ;
% c1 = -q * (m-v) ;
% d1 = -q * (m+v);
% d0 = d1* (v+1-2*m)/2 ;
% c0 = c1* (v+1)/2;


