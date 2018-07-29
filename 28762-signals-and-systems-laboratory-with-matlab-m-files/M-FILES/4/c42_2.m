% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 

%  convolution between x(t)=1,0<t<2 and h(t)=1-t,0<t<1

 step=0.01;
 t=0:step:2;
 x=ones(size(t));
 
 t1=0:step:1;
 t2=1+step:step:2;
 h1=1-t1;
 h2=zeros(size(t2));
 h=[h1 h2];
 
 y=conv(x,h)*step;
 
 ty=0:step:4;
 plot(ty,y);

