% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 


% problem 2 - stability of y(t)=exp(x(t))

t=-5:0.01:10;
y=exp(cos(pi*t));
plot(t,y);

syms t 
x=cos(t);
y=exp(x);
limit(y,t,inf)


limit(y,t,-inf)


