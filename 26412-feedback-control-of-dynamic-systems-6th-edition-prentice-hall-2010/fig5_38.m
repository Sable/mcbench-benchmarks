% Fig. 5.38  Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%script to generate figure 5.38, Piper Dakota autopilot design

clf
numG = 160*conv ([1 2.5],[1 0.7]);
denG = conv([1 5 40],[1  .03  .06]);
sysG = tf(numG,denG);
sysD=tf([1   3],[1   20]);
sysDG=sysD*sysG;
figure(1)
rlocus(sysG)
axis([-30 2 -12 12])
hold on
pause;
rlocus(sysDG)
hold off
pause;
figure(2)
rlocus(sysG)
axis([-1.5 .1    -.6 .6])
hold on
pause;
rlocus(sysDG)
hold off
pause;
Kp = 0.3;
sysH=tf(1,1);
sysT = feedback (Kp*sysG,sysH);
Kc = 1.5;
sysTD=feedback(Kc*sysDG,sysH);
figure(3)
step(sysT)
hold on
step(sysTD)
nicegrid;
hold off
