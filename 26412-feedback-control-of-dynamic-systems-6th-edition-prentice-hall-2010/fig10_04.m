%  Figure 10.04      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
%  fig10_04.m is a script to generate Fig. 10.4    
%  the frequency responses of the open-loop
%  satellite position control, non-colocated case

clf;
% satellite system matrices
f =[0    1.0000         0         0;
   -0.9100   -0.0360    0.9100    0.0360;
         0         0         0    1.0000 ;
    0.0910    0.0036   -0.0910   -0.0036];
g =[0;
     0;
     0;
     1];

h =[1     0     0     0];

j =[0];

% convert to transfer function form
[np dp]=ss2tf(f,g,h,j,1);
% remove leading zero coefficients
np=np(4:5);
hold off; clf
% define frequency range
w=logspace(-1,.5);
w(34)=1;
% Bode response
[magp php]=bode(np,dp,w);
php=php-360*ones(size(php));
subplot(211); 
loglog(w,magp); grid;hold on;
xlabel('\omega (rad/sec)');
ylabel('Magnitude, |KG(s)|');
title(' Fig. 10.4 Frequency response of the satellite')
loglog(w,ones(size(magp)),'g'); hold off;
subplot(212); 
php1 = [php, -180*ones(size(php))];
semilogx(w,php1); grid; hold on;
xlabel('\omega (rad/sec)');
ylabel('Phase (deg)');
%Bode grid
bodegrid;


