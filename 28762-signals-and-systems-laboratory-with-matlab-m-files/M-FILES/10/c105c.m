% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% z-Transform properties


%	Right shift of x[n]

n=-3:3;
x=0.8.^n;

xminus3=x(1)
xminus2=x(2)
xminus1=x(3)

syms n z
xn1=0.8^(n-1);
Left=ztrans(xn1,z) ; 
simplify(Left)

x=0.8^n;
X=ztrans(x,z);
Right=z^-1*X +xminus1;
simplify(Right)



xn2=0.8^(n-2);
Left=ztrans(xn2,z) ; 
simplify(Left)

Right=z^-2*X+xminus2+z^-1 *xminus1;
simplify(Right)
