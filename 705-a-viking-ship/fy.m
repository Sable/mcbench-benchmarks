%
% FY
%
% En bézierkurvas y kordinat vid tiden t

function f=fy(p1,b,c,p2,t)

p1y=p1(2);
p2y=p2(2);
by=b(2);	
cy=c(2);	
f=(1-t)^3*p1y+3*(1-t)^2*t*by+3*(1-t)*t^2*cy+t^3*p2y;

