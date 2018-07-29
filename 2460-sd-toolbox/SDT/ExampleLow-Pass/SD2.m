% ************************************************************************
% 2nd Order Sigma-Delta A/D Modulator
% by S. Brigati Ver.(0.1) 08/04/98
% The modulator structure is simulated using Simulink (sd2.mdl).
% Post-processing of the results is done with Matlab.
% 1. Plots the Power Spectral Density of the bit-stream
% 2. Calculates the SNR
% 3. Calculates histograms at the integrator outputs
% ************************************************************************
clear

t0=clock;

% ************************************************************************
% Variabili globali
% ************************************************************************
bw=22.05e3;				% Base-band
R=256;
Fs=R*2*bw;				% Oversampling frequency
Ts=1/Fs;
N=65536;				% Samples number
nper=12;
Fin=nper*Fs/N;			% Input signal frequency (Fin = nper*Fs/N)
Ampl=0.5-pi/256;		% Input signal amplitude [V]
Ntransient=0
%
% kT/C noise and op-amp non-idealities
%
echo on;
k=1.38e-23;				% Boltzmann Constant
Temp=300;				% Absolute Temperature in Kelvin
Cf=5e-12;				% Integrating Capacitance of the first integrator
alfa=(1e3-1)/1e3;		% A=Op-amp finite gain (alfa=(A-1)/A -> ideal op-amp alfa=1)
% alfa=1;
Amax=1.35;				% Op-amp saturation value [V]
sr=20e6;				% Op-amp slew rate [V/s]
GBW=150e6;				% Op-amp GBW [Hz]
noise1=10e-6;			% 1st int. output noise std. dev. [V/sqrt(Hz)]
% noise1=0;
delta=4e-9;				% Random Sampling jitter (std. dev.) [s] (Boser, Wooley JSSC Dec. 88)
% delta=0;
echo off;

% Modulator coefficients

echo on;
b=0.5;		% old b=0.38
b2=0.5;		% old c1=0.38
Vref=1;
echo off;

finrad=Fin*2*pi;		% Input signal frequency in radians


s0=sprintf('** Simulation Parameters **');
s1=sprintf('   Fs(Hz)=%1.0f',Fs);
s2=sprintf('   Ts(s)=%1.6e',Ts);
s3=sprintf('   Fin(Hz)=%1.4f',Fin);
s4=sprintf('   BW(Hz)=%1.0f',bw);
s5=sprintf('   OSR=%1.0f',R);
s6=sprintf('   Npoints=%1.0f',N);
s7=sprintf('   tsim(sec)=%1.3f',N/Fs);
s8=sprintf('   Nperiods=%1.3f',N*Fin/Fs);
disp(s0)
disp(s1)
disp(s2)
disp(s3)
disp(s4)
disp(s5)
disp(s6)
disp(s7)
disp(s8)
% ************************************************************************
% Open Simulink diagram first
% ************************************************************************

options=simset('InitialState', zeros(1,2), 'RelTol', 1e-3, 'MaxStep', 1/Fs);
sim('sd2', (N+Ntransient)/Fs, options);	% Starts Simulink simulation

% ************************************************************************
%   Calculates SNR and PSD of the bit-stream and of the signal
% ************************************************************************
w=hann(N);
echo on;
f=Fin/Fs			% Normalized signal frequency
fB=N*(bw/Fs)		% Base-band frequency bins
yy1=zeros(1,N);
yy1=yout(2+Ntransient:1+N+Ntransient)';

echo off;

ptot=zeros(1,N);
[snr,ptot]=calcSNR(yy1(1:N),f,fB,w,N,Vref);
Rbit=(snr-1.76)/6.02;	% Equivalent resolution in bits

% ************************************************************************
% Output Grafico
% ************************************************************************

figure(1);
clf;
plot(linspace(0,Fs/2,N/2), ptot(1:N/2), 'r');
grid on;
title('PSD of a 2nd-Order Sigma-Delta Modulator')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0 Fs/2 -200 0]);

figure(2);
clf;
semilogx(linspace(0,Fs/2,N/2), ptot(1:N/2), 'r');
grid on;
title('PSD of a 2nd-Order Sigma-Delta Modulator')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0 Fs/2 -200 0]);

figure(3);
clf;
plot(linspace(0,Fs/2,N/2), ptot(1:N/2), 'r');
hold on;
title('PSD of a 2nd-Order Sigma-Delta Modulator (detail)')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0 2*(Fs/R) -200 0]);
grid on;
hold off;
text_handle = text(floor(Fs/R),-40, sprintf('SNR = %4.1fdB @ OSR=%d\n',snr,R));
text_handle = text(floor(Fs/R),-60, sprintf('Rbit = %2.2f bits @ OSR=%d\n',Rbit,R));

s1=sprintf('   SNR(dB)=%1.3f',snr);
s2=sprintf('   Simulation time =%1.3f min',etime(clock,t0)/60);
disp(s1)
disp(s2)

% ************************************************************************
% Histograms of the integrator outputs
% ************************************************************************

figure(4)
nbins=200;
[bin1,xx1]=histo(y1, nbins);
[bin2,xx2]=histo(y2, nbins);
clf;
subplot(1,2,1), plot(xx1, bin1)
grid on;
title('First Integrator Output')
xlabel('Voltage [V]')
ylabel('Occurrences')
subplot(1,2,2), plot(xx2, bin2)
grid on;
title('Second Integrator Output')
xlabel('Voltage [V]')
ylabel('Occurrences')
