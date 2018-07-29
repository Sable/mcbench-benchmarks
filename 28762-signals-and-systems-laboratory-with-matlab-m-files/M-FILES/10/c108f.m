% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% Problem 8
% Solve the difference equation 
% y[n]+1.5y[n-1]+0.5y[n-2]=x[n]+x[n-1] , x[n]=0.8^n u[n]



syms n z Y
x=0.8^n;
X=ztrans(x,z);
X1=z^(-1)*X;
Y1=z^(-1)*Y;
Y2=z^(-2)*Y;
G=Y+1.5*Y1+0.5*Y2-X-X1;
SOL=solve(G,Y);
y=iztrans(SOL,n)

% a)
n_s=0:20;
y_s=subs(y,n,n_s);
stem(n_s,y_s);
legend('Solution y[n]')
xlim([-.5 20.5])
ylim([0 1.1])

% b)
xn=x;
xn_1=0.8^(n-1);
yn=y;
yn_1=subs(y,n,n-1);
yn_2=subs(y,n,n-2);
test=yn+1.5*yn_1+0.5*yn_2-xn-xn_1
simplify(test)
