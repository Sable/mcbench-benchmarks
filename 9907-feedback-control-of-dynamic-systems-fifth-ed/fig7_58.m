%  Figure 7.58      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% script for Fig. 7.58             
%  
clf;
f=-3;
h=1;
g=1;
j=0;
ko=7;
k1=25;
l=7;
acl=[f,-ko,-k1;l,f-g*ko-l*h,-k1;1,0,0];
bcl=[0;0;-1];
ccl=[h, 0, 0];
dcl=[0];
t=0:.01:5;
syscl=ss(acl,bcl,ccl,dcl);
y1=step(syscl,t);
cclu=[0, -ko,-k1];
sysclu=ss(acl,bcl,cclu,dcl);
yu1=step(sysclu,t);
bclw=[1;1;0];
dclw=1;
sysclw=ss(acl,bclw,ccl,dcl);
syscluw=ss(acl,bclw,cclu,dclw);
y2=step(sysclw,t);
yu2=step(syscluw,t);
plot(t,y1,t,y2);
text(0.75,.85,'y_1');
text(0.75,.05,'y_2');
title('Figure 7.58 (a): Step response')
xlabel('Time (sec)');
ylabel('y(t)');
grid on;
pause;
plot(t,yu1,t,yu2);
text(0.25,2.4,'u_1');
text(0.25,.25,'u_2');
title('Figure 7.58 (b): Control effort')
xlabel('Time (sec)');
ylabel('u(t)');
grid on;

