% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 

% problem 6 - convolution of x(t) and h(t) 


t1=0:.1:2;
t2=2.1:.1:4;
t3=4.1:.1:10;
x1=t1;
x2=4-t2;
x3=zeros(size(t3));
x=[x1 x2 x3];
t=0:.1:10;
h=t.*exp(-t);
y=conv(x,h)*0.1;
plot(0:.1:20,y);
title('System response y(t)')
