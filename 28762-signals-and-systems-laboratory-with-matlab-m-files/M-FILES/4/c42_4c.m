% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
%  convolution between  h(t)=cos(2ðt),0<t<4  and x(t)=2t ,  0<t<1
%                                                    =4-2t, 1<t<2


 t1=0:.01:1;
 t2=1.01:.01:2;
 t3=2.01:.01:4;
 
 x1=2*t1;
 x2=4-2*t2;
 x3=zeros(size(t3));
 x=[x1 x2 x3];
 
 t=[t1 t2 t3];
 h=cos(2*pi*t);
 
 y=conv(x,h)*.01;
 
 plot(0:.01:8,y)
