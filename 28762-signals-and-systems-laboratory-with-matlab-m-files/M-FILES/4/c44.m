% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 

% interconnections of systems

%cascade
 t=0:0.01:3;
 x=ones(size(t));
 h1=t.*exp(-3*t);
 y1=conv(x,h1)*0.01;
 t1=0:0.01:3;
 h2a=t1.*cos(2*pi*t1);
 t2=3.01:.01:6;
 h2b=zeros(size(t2));
 h2=[h2a h2b];
 y=conv(y1,h2)*0.01;
 plot(0:.01:12,y)
 legend('y(t)')

 figure
 t=0:0.01:3;
 h1=t.*exp(-3*t);
 h2=t.*cos(2*pi*t);
 h=conv(h1,h2)*0.01;
 plot(0:.01:6,h)
 legend('h(t)')
 t1=0:0.01:3;
 t2=3.01:.01:6;
 x1=ones(size(t1));
 x2=zeros(size(t2));
 x=[x1 x2];
 y=conv(x,h)*0.01;
 plot(0:.01:12,y)
 legend('y(t)')


%	Parallel 
figure
t=0:0.01:3;
h1=t.*exp(-3*t);
h2=t.*cos(2*pi*t);
x=ones(size(t));
y1=conv(h1,x)*.01
y2=conv(h2,x)*.01;
y=y1+y2;
plot(0:.01:6,y)
legend('y(t)')

 figure
 t=0:0.01:3;
 h1=t.*exp(-3*t);
 h2=t.*cos(2*pi*t);
 h=h1+h2;
 plot(0:.01:3,h)
legend('h(t)')

 figure
 x=ones(size(t));
 y=conv(x,h)*0.01;
 plot(0:.01:6,y)
 legend('y(t)')

