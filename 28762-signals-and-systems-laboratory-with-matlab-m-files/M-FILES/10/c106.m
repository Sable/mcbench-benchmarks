% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% z-Transform properties


% Partial fraction expansion 


% 
%          z^2+3z+1
% X(z)=--------------
%       z^3+5z^2+2z-8
%      

A=[1 5 2 -8];
ro=roots(A)
syms z
X=(z^2+3*z+1)/(z^3+5*z^2+2*z-8);
c1=limit((z-ro(1))*X,z,ro(1))
c2=limit( (z-ro(2))*X,z,ro(2))
c3=limit( (z-ro(3))*X,z,ro(3))




% 
%       z^2+3z+1
% X(z)=-----------
%       z^3-3z+2

A=[1 0 -3 2];
rt=roots(A)
syms z
X=(z^2+3*z+1)/(z^3-3*z+2);
c1=limit((z-rt(1))*X,z,rt(1))
r = 2;
f= ((z-1)^r )*X;
di=diff(f,z,r-1);

fact=1/factorial(r-1);
c2=limit(fact*di,z,1)
di=diff(f,z,r-2);
fact=1/factorial(r-2);
c3=limit(fact*di,z,1)

%alternative computation
num=[ 1 3 1];
den=[ 1 0 -3 2]
[R,P,K]=residue(num,den)






% 
%       3z^3+8z+4
% X(z)=-----------
%       z^2+5z-4


n= [ 3 8 0 4]
d=[ 1 5 4];
[R,P,K]=residue(n,d)

%confirmation
R=[ 20 3];
P=[-4 -1];
K=[ 3 -7];
[B,A]=residue(R,P,K)






% 
%       1-8z^-1+17z^-2+2z^-3-24z^-4
% X(z)=-----------------------------
%              1+z^-1-2z^-2

n=[ 1 -8 17  2 -24];
d= [1 1 -2];
[R,P,K]=residuez(n,d)

