 clear all;clc;%close all;
tic;
%% inputs
options=odeset('RelTol',1e-9,'AbsTol',1e-9);
x=0:0.1:1;
y(:,1)=x.^0;
y(:,2)=x.^0;
y(:,4)=-10*x.^0;
y(:,3)=-4.5*x.^2+8.91*x+1;
y(:,5)=-4.5*x.^2+9*x+0.91;

solinit = bvpinit(x,y);
[T,Y]=bvpMSM('bvpme',solinit,@bcsme,@dbcsme,options);
figure(2);plot(T,Y);axis tight
toc