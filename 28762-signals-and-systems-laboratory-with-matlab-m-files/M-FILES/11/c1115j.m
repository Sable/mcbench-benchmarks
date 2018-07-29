% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% 	Problem 10 - discrete time Frequency Response


%Frequency Response graph
num=[.1 .1 .18 .18 .09 .09];
den=[1 -1.5 2.2 -1.5 0.8 -0.18];
freqz(num,den)



% Impulse response
delta=[1 zeros(1,39)];
h=filter(num,den,delta);

stem(0:39,h)
legend('Impulse response ')

% second way
figure
h2=dimpulse(num,den,40)

stem(0:39,h2)
legend('Impulse response ')



% Impulse response
figure
u=ones(1,40);
s=filter(num,den,u);

stem(0:39,s)
legend('Step response')

% second way
figure
s2=dstep(num,den,40);

stem(0:39,s2);
legend(' Step response ')

