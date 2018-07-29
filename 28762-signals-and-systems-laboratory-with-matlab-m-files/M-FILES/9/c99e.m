% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% 
% 
% problem 7- Use the Laplace Transform to solve the differential equation
%
% y''(t)+2y'(t)=u(t)-y(t),  y(0)=1, y'(0)=3 


syms t s Y
x=heaviside(t);
X=laplace(x,s);

y0=1; 
yd0=3;
Y1=s*Y-y0;
Y2=s*Y1-yd0;

G=Y2+2*Y1+Y-X;
Y=solve(G,Y); 

y=ilaplace(Y,t);

ezplot(y,[0 10]);
