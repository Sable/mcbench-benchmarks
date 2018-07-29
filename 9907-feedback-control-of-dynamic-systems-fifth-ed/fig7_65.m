%  Figure 7.65      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% Robust Servo Example 
%% Example 7.36; Figure 7.65
clf;
F=[0 1; 0 -1];
G=[0;1];
H=[1 0];
J=[0];
omega=1;
a=[0 1 0 0;-omega*omega 0 1 0;0 0 0 1;0 0 0 -1];
b=[0;0;G];
% desired closed-loop poles
pc=[-1+sqrt(3)*j;-1-sqrt(3)*j;-sqrt(3)+j;-sqrt(3)-j];
k=place(a,b,pc);
% form controller matrices
k1=k(:,1:2);
ko=k(:,3:4);
ac=[0 1;-omega*omega 0];
bc=-[k(2);k(1)];;
cc=[1 0];
dc=[0];
% controller frequency response
%grid;
%sys=ss(ac,bc,cc,dc);
%bode(sys);
%title('Fig. 7.61: Controller frequency response');
%pause;
% closed-loop system
acl=[F-G*ko G*cc;bc*H ac];
bcl=[0;0;-bc];
ccl=[H 0 0];
dcl=[0];
syscl=ss(acl,bcl,ccl,dcl);
pole(syscl)
tzero(syscl)
% blocking zeros
dcle=-1;
syse=ss(acl,bcl,ccl,dcle);
tzero(syse)
% Closed-loop response
t=0:.01:25;
r=sin(t);
y=lsim(syscl,r,t);
%plot(t,y,t,r);
%grid;
%text(0.5,0.8,'r');
%text(1.5,.4,'y');
%xlabel('Time (sec)');
%ylabel('Reference, output');
%title('Fig. 7.64: Tracking response');
%pause;
% Frequency response from r to e
%syscle=ss(acl,bcl,ccl,dcle);
%bode(syscle);
%title('Fig. 7.62: Frequency response: r to e');
%pause;
% blocking zeros from w to y
G1=[0;1;0;0];
sysclw=ss(acl,G1,ccl,dcl);
tzero(sysclw)
% Closed-loop response from w to y
w=sin(t);
y=lsim(sysclw,w,t);
plot(t,y,t,w);
grid;
text(0.5,0.9,'w');
text(1.5,0.1,'y');
xlabel('Time (sec)');
ylabel('Disturbance, output');
title('Fig. 7.65: Disturbance response');
%pause;
%bode(syscl);
%grid;
%title('Fig. 7.66: Closed-loop frequency response');






