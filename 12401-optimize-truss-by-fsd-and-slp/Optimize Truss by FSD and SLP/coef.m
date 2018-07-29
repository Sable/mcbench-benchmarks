function C=coef(f)
% Coefficient matrix of constraint and linear objective functions

syms X1 X2 X3 real

C(4)=-double(subs(f,{X1,X2,X3},{0,0,0}));
C(1)=double(subs(f,{X1,X2,X3},{1,0,0}))+C(4);
C(2)=double(subs(f,{X1,X2,X3},{0,1,0}))+C(4);
C(3)=double(subs(f,{X1,X2,X3},{0,0,1}))+C(4);