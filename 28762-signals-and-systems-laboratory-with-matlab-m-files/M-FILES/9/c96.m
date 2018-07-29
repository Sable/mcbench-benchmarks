% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% Partial fraction expansion of a rational function
%
% 



%        s^2+3s+1
% X(s)=----------------
%       s^3+5s^2+2s-8
 
A=[1 5 2 -8];
rt=roots(A)
syms s
X=(s^2+3*s+1)/(s^3+5*s^2+2*s-8);

c1=limit((s-rt(1))*X,s,rt(1))
c2=limit( (s-rt(2))*X,s,rt(2))
c3=limit( (s-rt(3))*X,s,rt(3))

X1=simplify( (s-rt(1))*X );
X2=simplify( (s-rt(2))*X );
X3=simplify( (s-rt(3))*X );
c1=subs(X1,s,rt(1))
c2=subs(X2,s,rt(2))
c3=subs(X3,s,rt(3))

%alternative conversion
num=[ 1 3 1];
den=[ 1 5 2 -8];
[R,P,K]=residue(num,den)
syms s
X=R(1)/(s-P(1))+R(2)/(s-P(2))+R(3)/(s-P(3))
pretty(X)





% 
%        s^2+3s+1
% X(s)=------------
%       s^3-3s+2


A=[1 0 -3 2];
rt=roots(A)
syms s
X=(s^2+3*s+1)/(s^3-3*s+2);

c1=limit((s-rt(1))*X,s,rt(1))

r=2;
i=1;
f= ((s-1)^r )*X;
d=diff(f,s,r-i);
fact=1/factorial(r-i);
c2=limit(fact*d,s,1)

i=2;
d=diff(f,s,r-i);
fact=1/factorial(r-i);
c3=limit(fact*d,s,1)

%alternative conversion
num=[ 1 3 1];
den=[1 0 -3 2];
[R,P,K]=residue(num,den)







% 
%        s^2-12s+11
% X(s)=------------
%        s^2+4s+3



num=[1 -12 11];
den=[ 1 4 3];
[k,g]=deconv(num,den)
rt=roots(den)

syms s
GA=(-16*s+8)/(s^2+4*s+3);
c1=limit((s-rt(1))*GA,s,rt(1))
c2=limit((s-rt(2))*GA,s,rt(2))

%alternative conversion
num=[ 1 -12 11];
den=[ 1 4 3];
[R,P,K]=residue(num,den)



