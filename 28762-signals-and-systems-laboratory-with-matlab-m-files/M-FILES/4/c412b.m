% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
% problem 2 -convolution of x(t) and h(t)

 t1=0:.1:.9;
 t2=1:.1:10;
 h1=zeros(size(t1));
 h2=exp(-2*t2);
 h=[h1 h2];
 t1=0:.1:2;
 t2=2.1:.1:10;
 x1=ones(size(t1));
 x2=zeros(size(t2));
 x=[x1 x2];
 y=conv(x,h)*0.1;
 plot(0:.1:20,y);
 legend('y(t)');