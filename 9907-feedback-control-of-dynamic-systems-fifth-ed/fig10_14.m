%  Figure 10.14      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
%  fig10_14.m is a script to generate Fig. 10.14, the transient 
%  response of the PD plus notch compensator of the 
%  satellite position control, non-colocated case

% satellite system matrices
f =[0    1.0000         0         0;
   -0.9100   -0.0360    0.9100    0.0360;
         0         0         0    1.0000 ;
    0.0910    0.0036   -0.0910   -0.0036];
g =[0;
     0;
     0;
     1];

h =[1     0     0     0];

j =[0];
no3=conv(.25*[2 1],[1/.81 0 1]);
do3=conv([1/20 1],[1/625 2/25 1]);
sys3=tf(no3,do3);
sysG=ss(f,g,h,j);
[sysol]=series(sys3,sysG);
[Aol,Bol,Col,Dol]=ssdata(sysol);
Acl=Aol-Bol*Col;
hold off; clf
t=[0:0.1:40];
syscl=ss(Acl,Bol,Col,Dol)
[y,t]=step(syscl,t);
plot(t,y);
grid on;
xlabel('Time (sec)');
ylabel('Amplitude');
title('Closed-loop step response of KD_3(s)G(s)')


