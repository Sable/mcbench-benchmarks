% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% z-Transform properties


%	Right shift of x[n]u[n] 

m=2
x=3^(n-m)*heaviside(n-m);

Left=ztrans(x,z);
Left=simplify(Left)

x=3^n*heaviside(n);
X=ztrans(x,z);

Right=(z^(-m))*X;
Right=simplify(Right)
