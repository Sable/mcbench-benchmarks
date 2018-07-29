% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% Transfer Function 


%from impulse response
syms t s
u=heaviside(t);
h=t*exp(-t)*u;
H=laplace(h,s)


%from differential equation 
syms t s Y X
Y1=s*Y;
Y2=s*Y1;
X1=s*X;
X2=s*X1;
G=Y2+3*Y1-2*Y-X2+X1+6*X;
Y=solve(G,Y);
H=Y/X


%differential equation from Transfer Function 
syms x x1 x2 y y1 y2
B=[1 -1 -6];
A=[1 3 -2];
g=A(1)*y2+A(2)*y1+A(3)*y-B(1)*x2-B(2)*x1-B(3)*x
