function fln=linear(f,Xo)
% Linearize the constraints

syms X1 X2 X3
X=[X1 X2 X3];

fo=subs(f,{X1,X2,X3},Xo);    % f(Xo)

df1=diff(f,X1); % derivative of f w.r.t X1
df2=diff(f,X2);
df3=diff(f,X3);

a1=subs(df1,{X1,X2,X3},Xo); 
a2=subs(df2,{X1,X2,X3},Xo);
a3=subs(df3,{X1,X2,X3},Xo);

fln=fo+a1*(X1-Xo(1))+a2*(X2-Xo(2))+a3*(X3-Xo(3)) ;

