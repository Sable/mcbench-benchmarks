%The phase locked loop(PLL),adjusts the phase of a local oscillator 
%w.r.t the incoming modulated signal.In this way,the phase of the 
%incoming signal is locked and the signal is demodulated.This scheme
%is used in PM and FM as well.
%We will implement it by using a closed loop system.Control systems
%techniques are applied here.
%**************************************************************


%STEP RESPONSE OF THE FIRST ORDER CLOSED LOOP TRANSMITTANCE OF PLL
%H(S) = 1;
%SYSTEM TYPE NUMBER = 1;
%THETAo/THETAi (output phase/input phase)


close all
kv = 1;
kd = 1;
dt = 0.01
t = 0:dt:2
u = ones(1,length(t))
g11 = [tf([2*pi*kv*kd],[1 2*pi*kv*kd])]  %its the transfer function given in the handout
[y11 t] = lsim(g11,u,t)
figure
plot(t,y11)
xlabel('TIME IN SECONDS')
ylabel('AMPLITUDE')
title('STEP RESPONSE OF 1st ORDER CLOSED LOOP TRANSMITTANCE')
%***************************************************************


%STEP RESPONSE OF THE FIRST ORDER CLOSED LOOP ERROR TRANSMITTANCE OF PLL
%ALL THE OTHER FACTORS H(S) etc ARE SAME HERE
%THETAe/THETAi (same interp. as above)

g12 = [tf([1 0],[1 2*pi*kv*kd])]   %error transmittance given in the handout
[y12 t] = lsim(g12,u,t)
figure
plot(t,y12)
xlabel('TIME IN SECONDS')
ylabel('AMPLITUDE')
title('STEP RESPONSE OF 1st ORDER CLOSED LOOP ERROR TRANSMITTANCE')
%****************************************************************

%STEP RESPONSE OF THE FIRST ORDER CLOSED LOOP TRANSMITTANCE OF PLL
%BETWEEN VCO AND INPUT SIGNAL PHASE
%H(S) = 1;
%SYSTEM TYPE NUMBER = 1;
%V2/THETAi
Kd =1;
g13 = [tf([Kd 0],[1 2*pi*kv*kd])]   %vco voltage and input signal transmittance
[y13 t] = lsim(g13,u,t)
figure
plot(t,y13)
xlabel('TIME IN SECONDS')
ylabel('AMPLITUDE')
title('STEP RESPONSE OF 1st ORDER CLOSED LOOP TRANSMITTANCE B/W VCO AND INPUT PHASE')
%********************************************************************

%STEP RESPONSE OF THE SECOND ORDER CLOSED LOOP TRANSMITTANCE OF PLL
%SYSTEM TYPE NUMBER = 2;
%THETAo/THETAi

a = 3.15
zeta = sqrt((pi*kv*kd)/(2*a))
omegan = sqrt(2*pi*kv*kd*a)
g21 = [tf([2*zeta*omegan omegan^2],[1 2*zeta*omegan omegan^2])]   
[y21 t] = lsim(g21,u,t)
figure
plot(t,y21)
xlabel('TIME IN SECONDS')
ylabel('AMPLITUDE')
title('STEP RESPONSE OF SECOND ORDER CLOSED LOOP TRANSMITTANCE OF PLL')
%*********************************************************************

%STEP RESPONSE OF THE SECOND ORDER CLOSED LOOP ERROR TRANSMITTANCE OF PLL
%SYSTEM TYPE NUMBER = 2;
%THETAe/THETAi

g22 = [tf([1 0 0],[1 2*zeta*omegan omegan^2])]   
[y22 t] = lsim(g22,u,t)
figure
plot(t,y22)
xlabel('TIME IN SECONDS')
ylabel('AMPLITUDE')
title('STEP RESPONSE OF SECOND ORDER CLOSED LOOP ERROR TRANSMITTANCE OF PLL')
%*********************************************************************

%STEP RESPONSE OF THE SECOND ORDER CLOSED LOOP TRANSMITTANCE OF PLL
%BETWEEN VCO AND INPUT SIGNAL PHASE
%SYSTEM TYPE NUMBER = 2;
%V2/THETAi

g23 = [tf([kd kd*a 0],[1 2*pi*kv*kd 2*pi*kv*kd*a])]   
[y23 t] = lsim(g23,u,t)
figure
plot(t,y23)
xlabel('TIME IN SECONDS')
ylabel('AMPLITUDE')
title('STEP RESPONSE OF SECOND ORDER CLOSED LOOP TRANSMITTANCE B/W VCO AND INPUT PHASE')
%**************************************************************************











