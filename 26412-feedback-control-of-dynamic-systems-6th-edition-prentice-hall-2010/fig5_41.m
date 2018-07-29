% Figure 5.41 Feedback Control of Dynamic Systems, 6e 
%                   Franklin, Powell, Emami
%                   
% attitude hold auto pilot for Dakota
% root locus with integral control

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

% lead compensation

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

axis('square')
subplot(121)
axis([-30 0 -15 15])
plot(polesI,'x'),grid
hold on
plot(zeroD,0,'o')
plot(zeroG(1),0,'o',zeroG(2),0,'o') 

ki0=.01:.05:.51;
ki1=1:.5:10;
ki2=12:5:102;
ki3=120:20:1000;
ki=[ki0 ki1 ki2 ki3 5000];
[R]=rlocus(K*num,denI,ki);
plot(R,'-')
axis([-25 2 -15 15]);
title ('Fig. 5.40 Root Locus vs. K_I for autopilot')
xlabel('Re(s)')
ylabel('Im(s)')

KI=.15;
[R1]=rlocus(K*num,denI,KI);
damp(R1');
plot(R1,'*')
hold off

% now zoom in to origin

subplot(122)
plot(polesI,'x'),grid
axis([-4 0 -2 2])
hold on
xlabel('Re(s)')
ylabel('Im(s)')
plot(zeroD,0,'o')
plot(zeroG(1),0,'o',zeroG(2),0,'o') 
plot(R,'-')
plot(R1,'*')

hold off
axis('normal')

subplot(111)
