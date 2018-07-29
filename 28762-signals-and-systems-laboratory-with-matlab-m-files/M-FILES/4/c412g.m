% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 

% problem 7 - convolution of x[n] and h[n]

n=0:10;
u=ones(size(n));
n1=0:3;
u4_1=zeros(size(n1));
n2=4:10;
u4_2=ones(size(n2));
u4=[u4_1 u4_2];
x=u-u4;
h=0.7.^n;
y=conv(x,h);
stem(0:20,y);
xlim([-1 21]);
legend('y[n]')
