%  Figure 7.37      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
% script to generate Fig. 7.37 
clf;
num = 40.4*[ 1, 0.619];
j=sqrt(-1);
r=[-3.21+4.77*j, -3.21-4.77*j];
den = poly(r);
den = [den, 0, 0];
w = logspace(-1,2);
[mag, ph] = bode(num,den,w);
mag1=[mag, ones(size(mag))];
subplot(211), loglog(w,mag1);
xlabel('\omega (rad/sec)');
ylabel('Magnitude');
title(' Fig. 7.37 Bode plot for the combined control and estimator');
bodegrid;
ph1=[ph, -180*ones(size(ph))];
subplot(212) , semilogx(w,ph1);
xlabel('\omega (rad/sec)');
ylabel('Phase (deg)');
%Bode grid
bodegrid