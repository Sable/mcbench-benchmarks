% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% z-Transform properties


%	Time reversal

syms z
x=[1 2 3 4];
n=[0 1 2 3];
X=sum(x.*(z.^-n));
Right=subs(X,z,z^-1)

nrev=[-3,-2,-1,0];
xrev=[4,3,2,1];
Left=sum(xrev.*(z.^-nrev))


