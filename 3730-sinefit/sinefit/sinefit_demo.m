% demo for SINEFIT program.
% % Written by Dr Chen YangQuan <yqchen@ieee.org> 
echo on

% test codes: 
A0=2;sigma=2; 
omega=2*pi*2; % f=2 Hz 
theta0=pi/2; 
t=0:.005:2; 
dn=sigma*randn(size(t)); 
s0=A0*sin(omega*t + theta0) + dn; 
t0=0;Ts=0.005; 

%Assume frequency f = 2.5 Hz which is 25% larger than the theoretical value of 2 Hz. 
% Calling [Ahat,Theta,Omega,RMS]=sinefit(s0,0.4,0,0.005) 
pause
[Ahat,Theta,Omega,RMS]=sinefit(s0,1/2.5,0,0.005);
%gives the filtering results shown in Fig. 4. 

pause

%Now, increase sigma from 1 to 2. The filtering 
%results are shown in Fig. 5 by calling  [Ahat,Theta,Omega,RMS]=sinefit(s0,1/1.5,0,0.005). 
[Ahat,Theta,Omega,RMS]=sinefit(s0,1/1.5,0,0.005); 
%Note that in this case, the frequency f = 1:5 Hz which is 25% lower than the theoretical value 
%of 2 Hz. It can be concluded that the optimal feature extraction can be used as a means of 
%filtering.  