%  Figure 6.83      Feedback Control of Dynamic Systems, 6e
%                   Franklin, Powell, Emami
% 

clear all
%close all;
clf

w=logspace(-2,2,100);
ff=180/pi;
ii=1:78;
semilogx(w(ii),-w(ii)*ff);
xlabel('\omega (rad/sec)');
ylabel('phase (deg)');
title('Fig. 6.83 Phase lag due to pure time delay.');
bodegrid;