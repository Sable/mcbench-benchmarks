%  Figure 10.78      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
% fig10_78.m is a script for the LQR(LQG) design for the disk  
% drive case study

clf;
wm= 5*pi;
z=.05;
GM = 4;
a=0.1;
numG= [1/(50*pi) 1];
denG=[1/(25*pi^2) 1/(50*pi) 1  0 0];
sysG=tf(numG,denG);
% form the system with y + a*ydot output
numGv=[0 numG]+.09*[numG 0];
sysGv=tf(numGv,denG);
% convert the design system to state form
[f,g,h,j]=ssdata(sysGv);
sysGvs=ss(f,g,h,j);
K=lqry(sysGvs,10000,1)
% form the state feedback
fc=f-g*K;
sysR=ss(fc,g,h,j);
[num,den]=tfdata(sysR,'v');
% remove the zero used to weight ydot
sysCLR=tf(numG,den);
[ac,b,c,d]=ssdata(sysCLR);
% normalize the gain for unity dc
k=c*inv(-ac)*b
b1=b/k;
sysCLR=ss(ac,b1,c,d);
t=0:.01:1.5;
[y,t]=step(sysCLR,t);
plot(t,y);
xlabel('Time (msec)');
ylabel('Amplitude');
grid;
title('Fig. 10.61 Step response of the LQR design for the disk');
%pause;
pc=eig(sysCLR);
pe=10*pc;
[f,g,h,j]=ssdata(sysG);
L=place(f',h',pe)';
nbar=1
a=[f-g*K-L*h];
b=[L -L];
c=-K;
d=[0 0];
sysF=ss(a,b,c,d);
sysOL=sysF*sysG;
sysH=tf(1,1);
sysCL=feedback(sysOL,sysH,2,1);
%
%grid
nicegrid
