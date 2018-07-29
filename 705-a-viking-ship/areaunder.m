%
% AREAUNDER
%
% Räknar ut arean under den del av en bézierkurva som ligger mellan
% t=a och t=1. Som synes är det ingen söt lösning av integralen, men
% våran trogna arbetshäst maple gör så gärna sånt jobb.

function A=areaunder(p1,b,c,p2,a)

p1y=p1(2); p1z=p1(3);
p2y=p2(2); p2z=p2(3);
byy=b(2); bz=b(3);	
cy=c(2); cz=c(3);
tmp=21/2*p1z*byy*a^2+9/2*bz*p1y*a^2-9/2*bz*byy*a^2-3*p1z*byy*a;
A=3*p1z*p1y*a+10*p1z*p1y*a^3+3*p1z*p1y*a^5+33/5*p1z*cy*a^5-39/5*p1z*byy*a^5-1/2*p1z*p1y*a^6-1/2*p1z*p1y+3/10*p1z*byy+3/20*p1z*cy+1/20*p1z*p2y-3/10*bz*p1y+3/20*bz*cy+3/20*bz*p2y-3/20*cz*p1y-3/20*cz*byy+3/10*cz*p2y-1/20*p2z*p1y-3/20*p2z*byy-3/10*p2z*cy+1/2*p2z*p2y+3/2*p1z*byy*a^6-3/2*p1z*cy*a^6+1/2*p1z*p2y*a^6+3/2*bz*p1y*a^6-9/2*bz*byy*a^6+9/2*bz*cy*a^6-3/2*bz*p2y*a^6-3/2*cz*p1y*a^6+9/2*cz*byy*a^6-9/2*cz*cy*a^6+3/2*cz*p2y*a^6+1/2*p2z*p1y*a^6-3/2*p2z*byy*a^6+3/2*p2z*cy*a^6-1/2*p2z*p2y*a^6-9/5*p1z*p2y*a^5+27/5*cz*p1y*a^5-63/5*cz*byy*a^5+9*cz*cy*a^5-9/5*cz*p2y*a^5-36/5*bz*p1y*a^5+18*bz*byy*a^5-72/5*bz*cy*a^5+18/5*bz*p2y*a^5-6/5*p2z*p1y*a^5-6/5*p2z*cy*a^5+12/5*p2z*byy*a^5-15/2*p1z*p1y*a^4+33/2*p1z*byy*a^4-45/4*p1z*cy*a^4+9/4*p1z*p2y*a^4+27/2*bz*p1y*a^4-27*bz*byy*a^4+63/4*bz*cy*a^4-9/4*bz*p2y*a^4-27/4*cz*p1y*a^4+45/4*cz*byy*a^4-9/2*cz*cy*a^4+3/4*p2z*p1y*a^4-3/4*p2z*byy*a^4-18*p1z*byy*a^3+9*p1z*cy*a^3-p1z*p2y*a^3-12*bz*p1y*a^3-6*bz*cy*a^3+18*bz*byy*a^3+3*cz*p1y*a^3-3*cz*byy*a^3-15/2*p1z*p1y*a^2-3*p1z*cy*a^2+tmp;

