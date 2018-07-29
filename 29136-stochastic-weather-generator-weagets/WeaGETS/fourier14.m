function [phi] = fourier14(ap,t,T)
%
% this function calculates Fourier series parameters of 14-d average
% climatological parameters (p00 and p10, alambda) (Woolhiser and Pegram, 1979)
% Richardson(1981). The technique employed is a least square minimisation. 
% Up to 4 harmonics are included in the analysis
%
X=[ones(size(t)) sin(t/T)  cos(t/T) sin(2*t/T) cos(2*t/T) sin(3*t/T) cos(3*t/T) sin(4*t/T) cos(4*t/T)];
coefp=X\ap';
C0=coefp(1);
D(1)=atan(coefp(3)/coefp(2));
D(2)=atan(coefp(5)/coefp(4));
D(3)=atan(coefp(7)/coefp(6));
D(4)=atan(coefp(9)/coefp(8));
C(1)=coefp(2)/cos(D(1));
C(2)=coefp(4)/cos(D(2));
C(3)=coefp(6)/cos(D(3));
C(4)=coefp(8)/cos(D(4));
%
% store the parameter estimates in a vector phi
% phi=[C00 C0(1) D0(1) ... C0(4) D0(4); C10 C1(1) D1(1)... C1(4) D1(4)]
%
phi=[C0 C(1) D(1) C(2) D(2) C(3) D(3) C(4) D(4)];
