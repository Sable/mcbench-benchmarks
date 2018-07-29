% Fig. 5.22   Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
% script to generate Fig. 5.22 

clf
n=1;
d=[1 1 0];
n1=[1 2 ];
sys1=tf(n1,d); 
rlocus(sys1,':' )
hold on
sys2=tf(n,d);
rlocus( sys2)
axis([-6 2 -3 3])
title('Root loci with P and PD compensation')
z=0:.1:.9;
 wn=1:1:6;
 sgrid(z, wn)
 hold off