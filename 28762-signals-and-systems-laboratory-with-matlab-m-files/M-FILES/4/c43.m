% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
%   convolution properties   


%commutative
 t=0:.01:5;
 h1=ones(size(t));
 h2=2*exp(-2*t);
 y=conv(h1,h2)*0.01;
 plot(0:.01:10,y);
 title('h_1(t)*h_2(t)')
 
 figure
 z=conv(h2,h1)*0.01;
 plot(0:.01:10,z);
 title('h_2(t)*h_1(t)')

 
 % associative 
 figure
 t=0:.01:5;
 x=ones(size(t));
 h1=1/pi*t;
 y1=conv(h1,x)*.01;
 h2=2*exp(-2*t);
 th2=5.01:.01:10;
 hh2=zeros(size(th2));
 h2=[h2 hh2];
 y=conv(h2,y1)*0.01;
 plot(0:.01:20,y);
 title('h_2(t)*(h_1(t)*x(t))')

figure
t=0:.01:5;
h1=1/pi*t;
h2=2*exp(-2*t);
z1=conv(h1,h2)*0.01;
x=ones(size(t));
tx=5.01:.01:10;
xx=zeros(size(tx));
x=[x xx];
z=conv(z1,x)*0.01;
plot(0:.01:20,z);
title('(h_2(t)*h_1(t))*x(t)')



% distributive 
figure
 t=0:.01:5;
 x=ones(size(t));
 h1=cos(pi*t);
 h2=2*exp(-2*t);
 h=h1+h2;
 y=conv(h,x)*0.01;
 plot(0:.01:10,y);
 title('[h_1(t)+h_2(t)]*x(t)')
 
 figure
  t=0:.01:5;
 x=ones(size(t));
 h1=cos(pi*t);
 h2=2*exp(-2*t);
 z1=conv(h1,x)*0.01;
 z2=conv(h2,x)*0.01;
 z=z1+z2;
 plot(0:0.01:10,z);
title('h_1(t)*x(t)+h_2(t)*x(t)')


