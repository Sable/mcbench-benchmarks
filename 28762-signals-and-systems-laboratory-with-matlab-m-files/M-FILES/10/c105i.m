% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% z-Transform properties


%	Convolution in the time domain


n=0:50;
x1=0.9.^n;
x2=0.8.^n;
y=conv(x1,x2);
stem(0:100,y)
legend('convolution ');

figure
syms n z
x1=0.9.^n;
x2=0.8.^n;
X1=ztrans(x1,z);
X2=ztrans(x2,z);
Right=iztrans(X1*X2);
n=0:100;
Right=subs(Right,n);
stem(0:100, Right)
legend('Z^-^1[X_1(z) X_2(z)]');
