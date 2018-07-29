% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 

% problem 4 - convolution of x(t) and h(t) 

t1=0:.01:2;
t2=2.01:.01:4;
t3=4.01:.01:5;
x1=zeros(size(t1));
x2=ones(size(t2));
x3=zeros(size(t3));
x=[x1 x2 x3];
h1=ones(size(t1));
h2=zeros(size( [t2 t3]));
h=[h1 h2];
y=conv(x,h)*0.01;
plot(0:0.01:10,y);
title('Result according to the four rules of convolution')



figure
t1=2:.01:4;
x=ones(size(t1));
t2=0:.01:2;
h=ones(size(t2));
y=conv(x,h)*0.01;
plot(2:.01:6,y)
title('Result according to the two principles of convolution' )
