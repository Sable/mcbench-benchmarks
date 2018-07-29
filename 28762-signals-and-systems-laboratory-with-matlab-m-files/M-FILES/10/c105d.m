% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% z-Transform properties


%	Left shift in time


x0=0.8^0;
x1=0.8^1;

syms n z;
xn1=0.8^(n+1);
Left=ztrans(xn1,z) ; 
simplify(Left)

x=0.8^n;
X=ztrans(x,z);
Right=z*X - x0*z;
simplify(Right)


xn2=0.8^(n+2);
Left=ztrans(xn2,z) ; 
simplify(Left)

Right=z^2*X-x0*z^2-x1*z;
simplify(Right)
