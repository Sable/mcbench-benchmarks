% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% 	Problem 9- system described by difference equation


%Transfer function
num=[.01 0.03 0.15];
den=[1 -1.6  0.8];
printsys(num,den,'z')


% a)Impulse Response
num=[.01 0.03 0.15];
den=[1 -1.6  0.8];
k=0:60;

y1=dimpulse(num,den,k);

stairs(k,y1)
title('Impulse Response')


% b)Step Response
figure

y2=dstep(num,den,k);

stairs(k,y2)
title('Step Response')


% c)System response to r(t)
figure

ramp=k;

y31=filter(num,den,ramp);

stairs(k,y31);
title('Ramp Response');

%second way
figure
y32=dlsim(num,den,ramp);
stairs(k,y32);
title('Ramp Response');
