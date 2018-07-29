% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%                  1         , -2<=t<=2
% 	Graph of f(t)= 0         , 2<t<5 
%                t*sin(4pi*t), 5<=t<=8 



t1=-2:.1:2;
t2=2.1:.1:4.9;
t3=5:.1:8;

f1=ones(size(t1));
f2=zeros(size(t2));
f3=t3.*sin(4*pi*t3);

t=[t1 t2 t3];
f=[f1 f2 f3];

plot(t,f)
title('Multi-part function f(t)')
