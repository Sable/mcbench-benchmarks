% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% 
% 
% problem 8- Use the Laplace Transform to solve the differential equation
%
% y'''(t)+y'(t)-2y(t)=dirac(t),  y(0)=2, y'(0)=3 , y''(0)=1


syms t s Y
y0=1;
yd0=3; 
y2d0=1;

x=dirac(t);
X=laplace(x,s);

Y1=s*Y-y0;
Y2=s*Y1-yd0;
Y3=s*Y2-y2d0;

G=Y3+Y1-2*Y-X;
Y=solve(G,Y);

y=ilaplace(Y,t);

ezplot(y,[0 5])
legend('Solution y(t)')
