% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% Problem 6
% Solve the difference equation 
% y[n]-y[n-1]=u[n]

% a)
syms n z Y
x=heaviside(n);
X=ztrans(x,z);
Y1=z^(-1)*Y;
G=Y-Y1-X;
SOL=solve(G,Y);
y=iztrans(SOL,n)

% b)
n1=0:50;
yn=subs(y,n,n1);
stem(n1,yn);
legend('Solution y[n]');

% c)
yntest=y;
yn_1test=subs(y,n,n-1);
test=yntest-yn_1test-x
