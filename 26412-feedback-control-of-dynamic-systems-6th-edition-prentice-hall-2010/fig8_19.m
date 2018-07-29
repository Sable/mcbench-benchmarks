% Fig. 8.19   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%

clear all;
%close all;
clf

numGs=1;
denGs=[1 0 0];  % s^2

numDs=.81*[1 .2];
denDs=[1 2];

numC=conv(numGs,numDs);
denC=conv(denGs,denDs);

[numCL,denCL]=feedback(numC,denC,1,1);
damp(denCL)

tf=30;
t=0:.2:tf;
y=step(numCL,denCL,t);

axis([0 30 0 1.5])
plot(t,y),
nicegrid;
hold on

% discrete designs

T=1;
[numGz,denGz]=c2dm(numGs,denGs,T,'zoh');

numDz1=[.389 -.319];
denDz1=[1 -.135];

numDz2=.374*[1 -.85];
denDz2=[1 0];

numz1=conv(numGz,numDz1);
denz1=conv(denGz,denDz1);

numz2=conv(numGz,numDz2);
denz2=conv(denGz,denDz2);

[numCLz1,denCLz1]=feedback(numz1,denz1,1,1);
[numCLz2,denCLz2]=feedback(numz2,denz2,1,1);

ddamp(denCLz1,T)
ddamp(denCLz2,T)

N=tf/T+1;
td=0:1:tf;
yd1=dstep(numCLz1,denCLz1,N);
yd2=dstep(numCLz2,denCLz2,N);
plot(td,yd1,'-',td,yd1,'*')
plot(td,yd2,'-',td,yd2,'o')
text(10,.55,'----------- continuous design')
text(10,.75,'*----*----* discrete equivalent design')
text(10,.65,'o----o----o discrete design')
title('Fig. 8.19  Step responses of the various design methods')
xlabel('Time (sec)')
ylabel('Plant output')
hold off
