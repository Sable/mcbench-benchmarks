%  Figure 10.11      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
%  fig10_11.m is a script to generate Fig. 10.11  
%  the frequency response of the notch network
clf;
nnotch=[1/.81 0  1] ;
dnotch=[1/625 2/25  1];
% define frequency range
w=logspace(-1,1);
w(36)=1;
subplot(211)
w=logspace(-1,1);
w(24)=0.89;
% compute Bode
[magn phn]=bode(nnotch,dnotch,w);
% phn=php-360*ones(phn);
magn1=[magn, ones(size(magn))];
subplot(211); loglog(w,magn1); grid;
xlabel('\omega (rad/sec)');
ylabel('Magnitude');
title('Fig. 10.11 Bode plot of a notch filter')
subplot(212); semilogx(w,phn); grid;
xlabel('\omega (rad/sec)');
ylabel('Phase (deg)');
%Bode grid
bodegrid