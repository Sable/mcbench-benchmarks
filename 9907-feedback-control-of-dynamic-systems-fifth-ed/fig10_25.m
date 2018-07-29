%  Figure 10.25      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
%  fig10_25.m is a script to generate Fig. 10.25, the           
%  frequency response of the collocated
%  design for the satellite with PD compensation
clf;
m=[1, .1]; k0=[0, .091] ; d0=[0, .0036]; k1=[0, .4];
[f,g,h,j]=twomass(m,k0,d0); [f1,g,h,j] = twomass(m,k1,d0);
h1=[0, 0, 1, 0];

nc1=0.25*[2, 1];
dc1=[1/40, 1];

[ac,bc,cc,dc]=tf2ss(nc1, dc1);
[aol,bol,col,dol]= series(ac, bc,cc,dc,f,g,h1,j);
[acl]=aol-bol*col;
ccl2=[0*cc, h]
[aol1,bol1,col1,dol1] = series(ac,bc,cc,dc,f1,g,h1,j);
acl1=aol1-bol1*col1;
w=logspace(-1,1);w(26)=1;
[magcl1, phcl1]= bode(aol,bol,col,dol,1,w);
subplot(211)
loglog(w,[magcl1, ones(size(magcl1))]); grid;
xlabel('\omega (rad/sec)');
ylabel('Magnitude, |D_5(s)G_{co}(s)|');
title('Fig. 10.25 Frequency response for D_5(s)G_{co}(s).')
subplot(212);  
semilogx(w, [phcl1,  -180*ones(size(phcl1))]); grid
xlabel('\omega (rad/sec)');
ylabel('Phase (deg)');
