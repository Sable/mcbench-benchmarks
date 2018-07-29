% Fig. 5.23  Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
% script to generate Fig. 5.23 
n=1;
d=[1 1 0];
n1=[1 2 ];
d1=conv(d,[1 20]);
d2=conv(d,[1 10]);
 sys1=tf(n1,d);
rlocus(sys1)
hold on
sys2=tf(n1,d1);
rlocus(sys2,':')
sys3=tf(n1,d2);
rlocus(sys3,'--')
axis([-6 2 -3 3])
title('Fig. 5.23 Root locus with PD or lead compensation')
z=0:.1:.9;
 wn=1:1:6;
 sgrid(z, wn)
 hold off