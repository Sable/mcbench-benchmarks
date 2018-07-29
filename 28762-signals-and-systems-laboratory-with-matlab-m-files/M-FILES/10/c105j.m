% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% z-Transform properties


%	Complex Conjugation

syms n z
x=(2+3*i)^n;

xc=conj(x);
Left=ztrans(xc);

x=(2+3*i)^n;
X=ztrans(x,z);
Xc=conj(X) ;
Right=subs(Xc,z,conj(z)); 

simplify(Right-Left)
