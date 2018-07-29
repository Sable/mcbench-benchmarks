% Fig. 5.30  Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%script for Figure 5.30
np=2500;
dp=conv([1 1 0],[1 1 2500]);
nc=240*conv([1 5.4],[1 .03]); 
dc=conv([1 .01] ,[1 40]);
nn=[1 .8 3600];
dn=[1 120 3600];
nol1=conv(np,nc);
dol1=conv(dp,dc);
nol=conv(nol1,nn);
dol=conv(dol1,dn);
sysol=tf(nol,dol);
rlocus( sysol) 
axis([-162 10 -64.5 64.5])
 hold on
 % rlocus( sysol,1)
 title('Fig.5.30 Root locus,lead,lag, notch')
  z=0:.1:.9;
 wn=10:10:160;
 sgrid(z, wn)
 hold off