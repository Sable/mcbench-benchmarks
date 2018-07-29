% Figure 5.42 Feedback Control of Dynamic Systems, 6e 
%                   Franklin, Powell, Emami
%                   
% attitude hold auto pilot for Dakota
% time response with integral control

clf
Wsp=6.3;  % short period
Zsp=.4;
Wph=.24;  % phugoid mode
Zph=.06;
Kg=160;    % gain so that 1" of control input produces 5 deg 

NUMsp=[1 Zsp*Wsp];
NUMph=[1 3*Wph];
DENsp=[1 2*Zsp*Wsp Wsp^2];
DENph=[1 2*Zph*Wph Wph^2];

numG=Kg*conv(NUMsp,NUMph);
denG=conv(DENsp,DENph);
zeroG=roots(numG);

% now add lead compensation

numD=[1 3];
denD=[1 20];

num=conv(numG,numD);
den=conv(denG,denD);
zeroD=roots(numD);
 
K=1.5;
[r2]=rlocus(num,den,K);

% now add integral control

polesI=[r2';0];  % add integral control pole
denI=poly(polesI);

KI=.15;
[R1]=rlocus(K*num,denI,KI);
damp(R1');

numDI=K*conv(numD,[1 KI]);
denDI=[denD 0];

[numCL,denCL]=feedback(conv(numDI,numG),conv(denDI,denG),1,1);
[numCLe,denCLe]=feedback(K*numD,denD,conv(numG,[1 KI]),[denG 0]);
t=0:.01:30;
t2=0:.01:30;
sysCL=tf(numCL,denCL);
y=step(sysCL,t);
sysCLe=tf(numCLe,denCLe);
de=step(sysCLe,t2);
subplot(211),plot(t,5*y),nicegrid;
axis([0 30 0 6]);
title('Fig. 5.42(a)  Step response of theta to 5 Deg. \theta command')
xlabel('Time  (sec)')
ylabel('\theta  (Deg)')
subplot(212),plot(t2,5*de),nicegrid;
axis([0 30 -.2 .2]);
title('Fig. 5.42(b) Response of elevator to 5 Deg. \theta command')
xlabel('Time  (sec)')
ylabel('\delta_e (Deg)')
subplot(111)




