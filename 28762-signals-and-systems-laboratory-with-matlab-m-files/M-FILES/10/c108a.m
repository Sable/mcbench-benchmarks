% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% z-Transform computation



% Sequence of finite duration

% problem 1
% a)
f=[-3,5,6,7,8];
n=-2:2;
syms z
F=sum(f.*(z.^-n))
pretty(F)

% b)
n=0:4;
F=sum(f.*(z.^-n));
pretty(F)


%Sequence of infinite duration

% problem 2 - x[n]=2^nu[n]
% a)
syms n z
x=n^2*heaviside(n);
X=ztrans(x,z)
% b)confirmation
iztrans(X,n)



% problem 3 - x[n]=cos(2*pi*n)u[n]

% a)
syms n z
x=cos(2*pi*n);
X=ztrans(x,z)
% b)confirmation
iztrans(X,n)



