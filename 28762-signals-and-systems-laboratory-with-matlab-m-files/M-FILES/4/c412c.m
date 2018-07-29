% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 

% problem 3 -convolution of x(t) and h(t) 

t1=-2:.1:3;
 x1=ones(size(t1));
 t2=3.1:.1:10;
 x2=zeros(size(t2));
 x=[x1 x2]; 
 t1=-2:.1:0;
 h1=zeros(size(t1));
 t2=0.1:.1:10;
 h2=exp(-3*t2);
 h=[ h1 h2];
 y=conv(x,h)*.1;
 plot(-4:.1:20,y)
 legend('y(t)');
