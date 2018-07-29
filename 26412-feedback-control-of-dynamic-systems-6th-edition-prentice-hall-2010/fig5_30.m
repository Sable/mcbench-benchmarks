% Fig. 5.30  Feedback Control of Dynamic Systems, 6e 
%             Franklin, Powell, Emami
%
np=2500;
dp=conv([1 1 0],[1 1 2500]);
nc=91*conv([1 2],[1 .05]); 
dc=conv([1 13] ,[1 .01]);
nn=[1 .8 3600];
dn=[1 120 3600];
nol1=conv(np,nc);
dol1=conv(dp,dc);
nol=conv(nol1,nn);
dol=conv(dol1,dn);
ncl=[0 0 0 0 nol];
dcl=dol+ncl;
step(ncl,dcl); 
axis([0 2 0 1.4])
title('Fig.5.30 Step response for,lead,lag, notch')
nicegrid;
 