%  Figure 10.28      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
% fig10_28.m is a script to generate Fig. 10.28,
% the step response of the collocated
% design for the satellite with PD compensation
% response at theta-2
clf;
m=[1, 0.1]; k0=[0, 0.091] ; d0=[0, 0.0036]; k1=[0, 0.4];
[f,g,h,j]=twomass(m,k0,d0); [f1,g,h,j] = twomass(m,k1,d0);
h1=[0, 0, 1, 0];

nc1=0.25*[2, 1];
dc1=[1/40, 1];

[ac,bc,cc,dc]=tf2ss(nc1, dc1);
[aol,bol,col,dol]= series(ac, bc,cc,dc,f,g,h1,j);
[acl]=aol-bol*col;
ccl2=[h,0*cc]
[aol1,bol1,col1,dol1] = series(ac,bc,cc,dc,f1,g,h1,j);
acl1=aol1-bol1*col1;     
t=0:0.5:100;
sys=ss(acl,bol,ccl2,dol);
[y,t]=step(sys,t);
plot(t,y);
xlabel('Time (sec)');
ylabel('Amplitude');
title('Fig. 10.28: Response at \theta_2 of the collocated design')
%grid
nicegrid
