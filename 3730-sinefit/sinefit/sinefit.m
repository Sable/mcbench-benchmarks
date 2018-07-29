% sine wave fitting from noisy sinusoidal signal 
% phase fitting has to be considered as well as frequency 
% Written by Dr Chen YangQuan <yqchen@ieee.org> 
% Last modified 05-11-2000
% s0: sampled series. 1xNp 
% Testim: estimated period (sec.) (may not be accurate) 
% Ts: sampling period (in Sec.) 
% t0: initial time (in Sec.) 
% Ahat: estimated amplitude 
% Theta: fitted theta_0 (in rad.) 
% Omega: 2pi*freq 
% RMS: root mean squares.
%
% See also: sinefit2
function [Ahat,Theta,Omega,RMS]=sinefit(s0,Testim,t0,Ts) 
% 
Omega=fmin('jomega',(2*pi/Testim)*.5,... 
(2*pi/Testim)*2.0, [0,1.0e-30 ], s0,t0,Ts) 
[Ahat,Theta,RMS]=sinefit2(s0,Omega,t0,Ts); 

disp(['f=',num2str(Omega/2/pi),... 
' | RMS=',num2str(RMS),' A ^ =', num2str(Ahat),... 
' | Theta ^ =',num2str(Theta*180/pi)]) 
Np=size(s0); 
t=t0+[0:Np(2)-1]*Ts; 
figure;
plot(t,s0,'k:',t, Ahat*sin(Omega*t+Theta),'-r'); 
legend(['measured (RMS=',num2str(RMS),')'],... 
['fitted: f=',num2str(Omega/2/pi),... 
' A.hat =',num2str(Ahat),... 
' |  theta.hat =',num2str(Theta*180/pi)]) 
return 