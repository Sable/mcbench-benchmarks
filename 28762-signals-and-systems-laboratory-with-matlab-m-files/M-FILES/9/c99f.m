% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% 
% 
% problem 8- Use the Laplace Transform to solve the differential equation
%
% y''(t)+3y'(t)+2y(t)=f(t),  y(0)=2, y'(0)=3 

syms t 
f1=1;
f2=t-2;
f3=2;
t1=3;
t2=6;
f=f1+(f2-f1).*heaviside(t-t1) +(f3-f2).*heaviside(t-t2);
ezplot(f,[0 10])
legend('f(t)')



figure;
syms s Y
y0=1; yd0=3;
F=laplace(f,s);
Y1=s*Y-y0;
Y2=s*Y1-yd0;
G=Y2+3*Y1+2*Y-F;
Y=solve(G,Y);
y=ilaplace(Y,t);
ezplot(y,[0,10]);
legend('Solution y(t)')

