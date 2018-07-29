% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% Problem 4
% Inverse z-Transform computation of X(z)=(2z+3)/(z^2+5z+6)


% a)in rational form
syms n z
X=(2*z+3)/(z^2+5*z+6);
iztrans(X,n)


% b) in partial fraction form 
num=[ 2 3]
den= [ 1 5 6];
[R,P,K]=residue(num,den)

X=3/(z+3)-1/(z+2)
iztrans(X,n) 
