% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% Bode diagrams

num=[1 2];
den=[1 3 1];
H=tf(num,den);

w=0:.1:100;
bode(H,w)


%second way
figure
H=freqs(num,den,w);

subplot(211);
semilogx(w,20*log10(abs(H)))
title('Bode plot')
legend('Magnitude in dB')
subplot(212);
semilogx(w,angle(H)*180/pi)
legend('Phase in degrees')
xlabel('Frequency in rad/s')



