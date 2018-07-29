function [cost]=costf2(x)
global impvol; global strike; global T; global F0; global r;

for i=1:length(T)
%mok(i)=max(blsimpv(F0, strike(i), r,T(i),HestonCall(F0,strike(i),r,T(i),x(1),x(2),x(3),x(4),x(5),0), 3),0);
%cost(i)=impvol(i)-mok(i);
cost(i)=blsprice(F0,strike(i),r,T(i),impvol(i))-HestonCall(F0,strike(i),r,T(i),x(1),x(2),x(3),x(4),x(5),0);
end
