% Fig. 9.17   Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%script for Figure 5.59
sysG=tf([1],[1 0.2 1 0]);
sysH=tf(123*[1 .18 .81],[1 20 100]);
sysL=sysG*sysH;
rlocus(sysL)
Title('Figure 9.17  Root locus for the system of Figure 9.18')
axis([-3 1 -1.5 1.5])
hold on
sysCL=feedback(sysG,sysH);
r=eig(sysCL);
plot(r,'*')
 z=0:.1:.9;
wn= .5:.5:3;
 sgrid(z, wn)
 hold off
