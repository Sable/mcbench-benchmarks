% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 

%  convolution between  and x(t)=h(t)=1,1<t<2

 %1st  way
 t1=0:.01:1-0.01;
 t2=1:.01:2;
 t3=2.01:.01:10;
 t=[t1 t2 t3];
 x1=zeros(size(t1));
 x2=ones(size(t2));
 x3=zeros(size(t3));
 x=[x1 x2 x3];
 
 h=x;
 
 y=conv(x,h)*.01;
 
 plot(0:.01:20,y);
 axis([0 6 -.1 1.1])
 legend('y(t)')
 
 
%the two signals
 figure
 plot(t,x,0-t,h,':')
 legend('x(t)','h(t-\tau)=h(0-\tau)')
 ylim([-.1 1.1])
 figure
 plot(t,x,2-t,h,':')
 ylim([-.1 1.1])
 legend('x(t)','h(t-\tau)=h(2-\tau)')


 
 %2nd  way
 figure
 t=1:.01:2;
 
 x=ones(size(t));
 h=ones(size(t));
 
 y=conv(x,h)*.01;
 
 plot(2:.01:4,y)
 legend('y(t)')
