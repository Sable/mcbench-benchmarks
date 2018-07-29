% Fig. 5.38  Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
clf
numG = 160*conv ([1 2.5],[1 0.7]);
denG = conv([1 5 40],[1  .03  .06]);
sysG = tf(numG,denG);
sysD=tf([1   3],[1   20]);
sysDG=sysD*sysG;
K = 0.3;
sysH=tf(1,1);
sysT = feedback (K*sysG,sysH);
sysTD=feedback(sysDG,sysH);
step(sysT)
hold on
step(sysTD)
grid on
title('Step responses of auto-pilot with P and lead control')
hold off
