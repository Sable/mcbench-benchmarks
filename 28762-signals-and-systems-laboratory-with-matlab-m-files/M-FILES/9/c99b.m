% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% 
% 
% problem 2- Evaluate the Laplace Transform of  y''(t) and then replace y(t) by sin(t)u(t)  

sym 'y(t)' ; 
syms t s
z=laplace( diff('y(t)',2),s)

z=subs(z,'y(t)',sin(t))

z=subs(z,'y(0)',0)
z=subs(z,'D(y)(0)',1)
simplify(z)

%verification
x=sin(t);
x2=diff(x,2,t)
laplace(x2,s)
