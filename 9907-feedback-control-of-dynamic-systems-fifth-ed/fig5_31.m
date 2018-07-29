% Fig. 5.31  Feedback Control of Dynamic Systems, 5e 
%             Franklin, Powell, Emami
%script for Figure 5.31
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
ncl=[0 0 0 0 nol];
dcl=dol+ncl;
step(ncl,dcl); 
grid  
axis([0 1.8 0 1.5])
 title('Fig.5.31 Step response for,lead,lag, notch')
 