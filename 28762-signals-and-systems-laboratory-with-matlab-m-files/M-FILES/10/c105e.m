% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% z-Transform properties


%	Scaling in the z-domain

syms n z

x=4^n;
X=ztrans(x,z);
X=simplify(X);

syms a
Right=subs(X,z,a*z)

L=a^(-n)*x;
Left=ztrans(L,z);
simplify(Left)




Right=subs(X,z,z/a);
simplify(Right)

L=a^n*x;
Left=ztrans(L,z);
simplify(Left)



syms w0 
Right=subs(X,z,exp(-j*w0)*z);

L=exp(j*w0*n)*x;
Left=ztrans(L,z);

simplify(Left- Right)
