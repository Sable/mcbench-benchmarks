% Fig. 8.12   Feedback Control of Dynamic Systems, 6e 
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

tf=30;
t=0:.2:tf;
y=step(numCL,denCL,t);

axis([0 30 0 1.5])
plot(t,y),
nicegrid
hold on

% discrete design

T=1;
[numGz,denGz]=c2dm(numGs,denGs,T,'zoh');

numDz2=.389*[1 -.82];
denDz2=[1 -.135];

numz2=conv(numGz,numDz2);
denz2=conv(denGz,denDz2);

[numCLz2,denCLz2]=feedback(numz2,denz2,1,1);
N=tf/T+1;
td=0:1:tf;
yd2=dstep(numCLz2,denCLz2,N);

T2=0.5;
[numGz,denGz]=c2dm(numGs,denGs,T2,'zoh');

a=.2;
b=2;
Kc=0.81;
alpha=exp(-a*T2);
beta=exp(-b*T2);
Kd=Kc*a/b*(1-beta)/(1-alpha);
numDz3=Kd*[1 -alpha];
denDz3=[1 -beta];

numz3=conv(numGz,numDz3);
denz3=conv(denGz,denDz3);

[numCLz3,denCLz3]=feedback(numz3,denz3,1,1);
N3=61;
td2=0:T2:tf;
yd3=dstep(numCLz3,denCLz3,N3);
plot(td,yd2,'-',td,yd2,'*',td2,yd3,'o',td2,yd3,'-')
title('Fig. 8.12, Step responses of ghe continuous and digital implentations')
text(10,.6,'----------- Continuous design')
text(10,.4,'*----*----* Discrete equivalent design, T = 1 sec')
text(10,.2,'o----o----o Discrete equivalent design, T = 0.5 sec')
xlabel('Time (sec)')
ylabel('Plant output')
hold off


