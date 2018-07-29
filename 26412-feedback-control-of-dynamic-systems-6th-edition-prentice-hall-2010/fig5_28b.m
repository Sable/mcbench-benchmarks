% Fig. 5.28  Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
% script for right side of Figure 5.28

clf
n=[1 2]; 
d=conv([1 1 0],[1 13]);
nc=[1 .05];
dc=[1 .01];
nol=conv([0 0 n],nc);
dol=conv(d,dc);
sysOL=tf(nol,dol);
K=0:.001:10;
rlocus(sysOL,K); 
 hold on
 title('Fig.5.28b Root locus for lead plus lag')
  axis([-.15 .05 -.1 .1])
 z=0:.1:.9;
 wn=2:2:19;
 sgrid(z, wn)
 dcl=91*nol+dol;
 r=roots(dcl) % shows that extra  root from Lag comp is almost right on the zero.
 plot(r,'*')  
 hold off