% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% Problem 7
% Solve the difference equation 
% y[n]-y[n-1]=x[n]+x[n-1] , x[n]=0.8^n u[n]


% a)
syms n z Y
x=0.8^n;
X=ztrans(x,z);
X1=z^(-1)*X;
Y1=z^(-1)*Y;
G=Y-Y1-X-X1;
SOL=solve(G,Y);
y=iztrans(SOL,n)

% b)
n_s=0:30;
y_s=subs(y,n,n_s);
stem(n_s,y_s);
legend('Solution y[n]');

% c)
xn=0.8^(n);
xn_1=.8^(n-1);
yn=10-9*(4/5)^n;
yn_1=10-9*(4/5)^(n-1);
test=yn-yn_1-xn-xn_1; 
simplify(test)

