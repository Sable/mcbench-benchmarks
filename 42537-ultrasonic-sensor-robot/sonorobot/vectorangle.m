function ang = vectorangle(a,b,unclk)
if nargin<3
    unclk = false;
end
if ~unclk
%returns angle between vector a and b (a->b, angle ranges from -pi to pi)
ang = atan2(b(:,2),b(:,1))-atan2(a(:,2),a(:,1));
if abs(ang)>pi
    ang = ang-2*pi*((ang>0)-(ang<0));
end
else
%returns angle between vector a and b (a->b, unclockwise, from 0 to 2*pi)
angb = atan2(b(:,2),b(:,1));
anga = atan2(a(:,2),a(:,1));
ang = (angb+2*pi*(angb<0))-(anga+2*pi*(anga<0));
ang = ang+2*pi*(ang<0);
end
