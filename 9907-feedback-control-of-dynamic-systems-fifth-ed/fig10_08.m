%  Figure 10.08      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% fig10_08.m is a script to generate Fig. 10.8  the         
% frequency response of the satellite with low-gain PD compensation

np =[0.0360    0.9100];

dp =[1.0000    0.0396    1.0010    0.0000    0.0000];

nc2=0.001*[30 1];

nol2=conv(nc2,np);
dol2=dp;

hold off ; clf
w=logspace(-2,.2);
w(46)=1;
[magol2, phol2]= bode(nol2,dol2,w);
subplot(211) ; loglog(w,magol2); grid; hold on;
xlabel('\omega (rad/sec)');
ylabel('Magnitude |D_2(s)G(s)|');
loglog(w,ones(size(magol2)),'g');
title('Fig. 10.8 Frequency response of low-gain satellite PD design')
phol2a=[phol2, -180*ones(size(phol2))];
subplot(212);  semilogx(w, phol2a); grid; hold on; 
xlabel('\omega (rad/sec)');
ylabel('Phase (deg)');

