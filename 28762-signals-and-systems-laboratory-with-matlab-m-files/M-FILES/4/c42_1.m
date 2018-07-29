% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 

% analytical computation of the convolution between  
% x(t)=1,0<t<2 and h(t)=1-t,0<t<1
 

 tx1=-2:.1:0;
 tx2=0:.1:2;
 tx3=2:.1:4;
 tx=[tx1 tx2 tx3];
 x1=zeros(size(tx1));
 x2=ones(size(tx2));
 x3=zeros(size(tx3));
 x=[x1 x2 x3];
 
 th1=-2:.1:0;
 th2=0:.1:1;
 th3=1:.1:4;
 th=[th1 th2 th3];
 h1=zeros(size(th1));
 h2=1-th2;
 h3=zeros(size(th3));
 h=[h1 h2 h3];
 
 plot(tx,x,th,h,':*')
 ylim([-.1 1.1])
 legend('x(\tau)','h(\tau)')
 grid

 
 
 
 %reflection
 figure
 plot(tx,x,-th,h,':*')
 legend('x(\tau)','h(-\tau)')
 ylim([-.1 1.1])

 %shifting
 figure
 t=-2;
 plot(tx,x,-th+t,h,':*')
 ylim([-.1 1.1])
 legend('x(\tau)','h(t-\tau)')

 %zero-overlap
 figure
 t=-2;
 plot(tx,x,-th+t,h,':*')
 ylim([-.1 1.1])
 legend('x(\tau)','h(t-\tau)')

 
 %partial-overlap
 figure
 t= 0.5;
 plot(tx,x,-th+t,h,':*')
 ylim([-.1 1.1])
 legend('x(\tau)','h(t-\tau)')
 
 T=1;
 r=0:.1:t;
 a=1/T*r+1-t/T;
 hold on; area(r,a);
 hold off; 

%complete-overlap
 figure
 t=1.6;
 plot(tx,x,-th+t,h,':*')
 ylim([-.1 1.1])
 legend('x(\tau)','h(t-\tau)')
 
 r=t-T:.1:t;
 a=1/T*r+1-t/T;
 hold on; area(r,a);
 hold off;
 
%partial-overlap
 figure
 t=2.4;
 plot(tx,x,-th+t,h,':*')
 ylim([-.1 1.1])
 legend('x(\tau)','h(t-\tau)')

 r=t-T:.1:2;
 a=1/T*r+1-t/T;
 hold on; area(r,a);
 hold off;

 %zero-overlap
 figure
 t=3.6;
 plot(tx,x,-th+t,h,':*')
 ylim([-.1 1.1])
 legend('x(\tau)','h(t-\tau)')

 
 
 
%convolution calculation
 syms t r
 f=1-t+r;
 y=int(f,r,0,t)
 
 y=int(f,r,t-1,t)
 simplify(y)

 y=int(f,r,t-1,2)
  
 t1=0:.1:1;
 t2=1:.1:2;
 t3=2:.1:3;
 y1=t1-(t1.^2)/2;
 y2=0.5*ones(size(t2));
 y3=0.5*((3-t3).^2);
 
 figure
 plot(t1,y1,t2,y2,'.',t3,y3,':')
 ylim([0 0.6])
 title('Output signal y(t)');




