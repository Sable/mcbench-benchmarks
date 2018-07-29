%
% FZ
%
% En bézierkurvas z-värde vid tiden t.

function f=fz(p1,b,c,p2,t)

p1z=p1(3);
p2z=p2(3);
bz=b(3);	
cz=c(3);	
f=(1-t)^3*p1z+3*(1-t)^2*t*bz+3*(1-t)*t^2*cz+t^3*p2z;

