% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% 
% 
% Using the Laplace Transform to solve differential equations


% The differential equation is 
% y''(t)+3y'(t)+2y(t)=exp(-t) ,  y(0)=2, y'(0)=3 


syms t s Y
X=laplace(exp(-t),s)
y0=2; 
yd0=3;
Y1=s*Y-y0;
Y2=s*Y1-yd0;
%Õ2=(s^2)*Y-s*y0- yd0; 
G=Y2+3*Y1+2*Y-X;
SOL=solve(G,Y)
y_t=ilaplace(SOL,t)
ezplot(y_t, [0 7])


%confirmation
test=diff(y_t,2)+3*diff(y_t)+2*y_t-exp(-t)

t=0; 
y0=eval(y_t)
yd0=eval(diff(y_t))
% y0=subs(y_t,0)
% yd0=subs(diff(y_t),0)


