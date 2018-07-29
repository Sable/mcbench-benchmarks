%  Figure 7.71     Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% script for Fig. 7.71(b)             
%  
clf;
f=-3;
h=1;
g=1;
j=0;
k=2;
l1=225;
l2=27;
acl=[f,-k,-1;l2,f-k-l2,0;l1,-l1,0];
bcl=[0 1;-l2 0;-l1 0];
ccl=eye(3);
dcl=0*ones(3,2);
t=0:.01:2;
uu=ones(size(t));
uu=[uu;uu];
uu(2,1:51)=0*ones(1,51);
syscl=ss(acl,bcl,ccl,dcl);
y=lsim(syscl,uu,t);
plot(t,y);
text(0.5,1.3,'y');
text(0.5,-.5,'xhat');
text(0.5,-3.5,'\rhohat');
title('Figure 7.71 (b): Command step response and disturbance step response')
xlabel('Time (sec)');
ylabel('y,xhat,\rhohat');
grid on;

