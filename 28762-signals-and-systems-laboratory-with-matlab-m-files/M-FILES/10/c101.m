% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% z-Transform and inverse z-Transform



% z-Transform

% x[n]=[3,5,4,3],n=0,1,2,3
syms z
x0=3; 
x1=5;
x2=4;
x3=3;
Xz=x0*(z^0)+x1*(z^-1)+x2*(z^2)+x3*(z^-3);
pretty(Xz)

% alternative computation 
syms z
x=[3 5 4 3];
n=[0 1 2 3];
X=sum(x.*(z.^-n));
pretty(X)



% x[n]=0.9^n u[n]
syms n z
x=0.9^n;
X=symsum(x.*(z.^-n),n,0,inf)


% x[n]=2^n u[n]
syms n z
f= 2^n ; 
ztrans(f)
simplify(ans)


% x[n]=1
syms n z
f=1;
ztrans(f,z)

% x[n]=n^2 u[n]

f=n^2

ztrans(f)

syms w
ztrans(f,w)



% Inverse z-Transform


% F(z)=z/(z-2)
syms n z 
F=z/(z-2); 
iztrans(F)

% F(z)=z/(z-3)
syms n z t  
F= z/(z-3);
f= iztrans(F,t)



%Common mistakes
syms n z
f=1;
ztrans(f)

F=1
iztrans(F)






