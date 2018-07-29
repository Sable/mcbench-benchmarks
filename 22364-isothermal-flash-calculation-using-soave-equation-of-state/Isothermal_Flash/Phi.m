% Fugacity coeficient calculation using Soave equation of state 
% Author: Arnulfo Rosales-Quintero
% Email: arnol122@gmail.com 
% This function calculates either liquid or vapor fugacity coeficients
%-------------------------------------------------------------------------%
function [Phi,Vmix]=Phi(P,T,xy,a,b,phase01)
%-------------------------------------------------------------------------%
    global delta1 delta2 R
    global Kij
%-----------------------------------------------------------------------%
nc = length(xy);
%Mixture rule
amix=0.;	bmix=0.;
for i=1:nc
    dda=0.;
    for j=1:nc
        aij(i,j)= sqrt(a(i)*a(j))*(1.0-Kij(i,j));
        dda     = 2.0 * xy(j) * aij(i,j) + dda;
        amix    = xy(i)*xy(j) * aij(i,j) + amix;	%"a" mixture constant
    end
    dna(i) = dda;						%First derivative   d(an)/dni
    dnb(i) = b(i);						%First derivative   d(bn)/dni
    bmix   = xy(i)*b(i) + bmix;         %"b" mixture constant
end
%-------------------------------------------------------------------------%
%Mixture Volume
    Bb = (P*bmix*(delta1+delta2-1.0) - R*T)/P;
    Cc = (amix - (P*bmix^2+R*T*bmix)*(delta1+delta2) + P*bmix^2*delta1*delta2)/P;
    Dd = (-amix*bmix - (P*bmix^3 + R*T*bmix^2)*delta1*delta2)/P;
    
switch phase01    
    case ('vapor')
        Vmix = max(roots([1 Bb Cc Dd]));
    case ('liquid')
        Vmix = min(roots([1 Bb Cc Dd]));
end
%-------------------------------------------------------------------------%
%Fugacity calculation
for i=1:nc
	Phi(i) = dnb(i)/bmix*(P*Vmix/R/T-1.) - log(P*(Vmix-bmix)/R/T);
    Phi(i) = Phi(i) - amix/bmix*(dna(i)/amix-dnb(i)/bmix)/R/T*log((Vmix+delta1*bmix)/(Vmix+delta2*bmix))/(delta1-delta2);
end
	Phi = exp(Phi);
%-------------------------------------------------------------------------%
