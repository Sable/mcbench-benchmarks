%
% DFZ
%
% En bézierkurvas z-derivata vid tiden t.

function f=dfz(p1,b,c,p2,t)

p1z=p1(3);
p2z=p2(3);
bz=b(3);	
cz=c(3);	
f=-3*(1-t)^2*p1z-6*(1-t)*t*bz+3*(1-t)^2*bz-3*t^2*cz+6*(1-t)*t*cz+3*t^2*p2z;
