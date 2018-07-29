% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
% 

% solution of differential equation 
%y'(t)+y(t)=exp(-t)u(t) , y(0)=0



f='Dy+y-exp(-t)*heaviside(t)'
y=dsolve(f,'y(0)=0')
ezplot(y,[0 10])
title('y(t) from differential equation')


figure
t=0:0.001:5;
x=exp(-t);
h=exp(-t);
y=conv(x,h)*0.001;
plot(0:.001:10,y);
title('y(t) from convolution')
