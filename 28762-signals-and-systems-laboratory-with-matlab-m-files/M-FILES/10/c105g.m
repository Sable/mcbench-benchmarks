% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% z-Transform properties


%	Differentiation in the z-domain


syms n z
x=0.9^n;
Left=ztrans(n*x,z)


X=ztrans(x,z)
d=diff(X,z);
Right=-z*d;
simplify(Right)
