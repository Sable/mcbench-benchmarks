% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% z-Transform properties


%	Summation

syms n z
x=n^2;

s=symsum(x,n,0,n);
Left=ztrans(s,z);
Left=simplify(Left)

X=ztrans(x,z);
Right=(z/(z-1))*X
