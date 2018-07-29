% sine wave fitting from noisy sine signal 
% phase fitting has to be considered 
% with a fixed omega! 
% Written by Dr Chen YangQuan <yqchen@ieee.org> 
% Last modified in 05-11-2000
% DESCRIPTIONS:
% s0: sampled series. 1xNp (note here) 
% omega: known freq. (2*pi*f) (rad/sec.) 
% Ts: sampling period (in Sec.) 
% t0: initial time (in Sec.) 
% Ahat: estimated amplitude 
% Theta: fitted theta_0 (in rad.) 
% RMS: root mean squares. 
% 
% See also "jomega"
function [Ahat,Theta,RMS]=sinefit2(s0,omega,t0,Ts) 
Np=size(s0); 
t=t0+[0:Np(2)-1]*Ts; 
A11= (sin(omega*t)*(sin(omega*t))'); 
A12= (sin(omega*t)*(cos(omega*t))'); 
A22= (cos(omega*t)*(cos(omega*t))'); 
b1=s0*(sin(omega*t))'; 
b2=s0*(cos(omega*t))'; 
A=[A11,A12;A12,A22]; 
Alpha=inv(A)*[b1,b2]'; 
% be careful here... 
Asintheta=Alpha(2);Acostheta=Alpha(1); 
Ahat=sqrt(Asintheta*Asintheta+Acostheta*Acostheta); 
Theta=atan2(Asintheta,Acostheta); 
RMS=sqrt((s0-Ahat*sin(omega*t+Theta))*... 
(s0-Ahat*sin(omega*t+Theta))'/(Np(2)-1.)); 
if (0)
figure;
plot(t,s0,'k:',t, Ahat*sin(omega*t+Theta),'-r'); 
legend(['measured (RMS=',num2str(RMS),', f=',... 
num2str(omega/2/pi),')'],['fitted: ',... 
' A.hat=',num2str(Ahat),' | theta.hat=',num2str(Theta*180/pi)]) 
end
return; 
