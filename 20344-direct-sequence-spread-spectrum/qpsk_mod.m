function [msumiq,sumiq,cs_t,sn_t,tiq]=qpsk_mod(sig1,sig2,Isymbols,Qsymbols,N,fcarr)
%Bob Gess, June 2008, for EE473
%Portions copied and modified from QPSK_TX_IQ_RX written by JC and posted to Mathworks
%Dec 2005.

%The carrier frequency is modulated by the spread data
%The carrier frequency is also modulated by unspread data for comparison
%purposes.

%fcarr=20e3;         % Carrier frequency(Hz)
%N=2e3;		        % Number of data bits(bit rate)
fs=8*10e3;		    % Sampling frequency
Fn=fs/2;            % Nyquist frequency
Ts=1/fs;	        % Sampling time = 1/fs
T=1/N;		        % Bit time
randn('state',0);   % Keeps PRBS from changing on reruns
td=[0:Ts:(N*T)-Ts]';% Time vector(data)(transpose)

tiq = [0:Ts*2:(N*T)-Ts]';% Time vector for I and Q symbols(transpose)


%generate carrier waves
%cosine and sine wave
%2 pi fc t is written as below
twopi_fc_t=(1:fs/2)*2*pi*fcarr/fs;
a=1;
%phi=45*pi/180
phi=0;%phase error
cs_t = a * cos(twopi_fc_t + phi);
sn_t = a * sin(twopi_fc_t + phi);

%Generating spread signal
%cs_t=cs_t'%transpose
%sn_t=sn_t'%transpose
si=cs_t.*sig1;
sq=sn_t.*sig2;
sumiq=si+sq;
sumiq=.7*sumiq;%reduce gain to keep output at +/- one

%Generating unspread signal (for comparison purposes)
mi=cs_t.*Isymbols;
mq=sn_t.*Qsymbols;
msumiq=mi+mq;
msumiq=.7*msumiq;  %reduce gain to keep output at +/- one

%========================================================================
%Take FFT of unmodulated carrier
%========================================================================
y=cs_t;
NFFY=2.^(ceil(log(length(y))/log(2)));
FFTY=fft(y,NFFY);%pad with zeros
NumUniquePts=ceil((NFFY+1)/2); 
FFTY=FFTY(1:NumUniquePts);
UY=abs(FFTY);
UY=UY*2;
UY(1)=UY(1)/2;
UY(length(UY))=UY(length(UY))/2;
UY=UY/length(y);
f1=(0:NumUniquePts-1)*2*Fn/NFFY;

%========================================================================
%Take FFT of modulated spread carrier
%========================================================================
y=sumiq;
NFFY=2.^(ceil(log(length(y))/log(2)));
FFTY=fft(y,NFFY);%pad with zeros
NumUniquePts=ceil((NFFY+1)/2); 
FFTY=FFTY(1:NumUniquePts);
MY=abs(FFTY);
MY=MY*2;
MY(1)=MY(1)/2;
MY(length(MY))=MY(length(MY))/2;
MY=MY/length(y);
%f1=(0:NumUniquePts-1)*2*Fn/NFFY;

%========================================================================
%Take FFT of modulated unspread carrier
%========================================================================
y=msumiq;
NFFY=2.^(ceil(log(length(y))/log(2)));
FFTY=fft(y,NFFY);%pad with zeros
NumUniquePts=ceil((NFFY+1)/2); 
FFTY=FFTY(1:NumUniquePts);
CY=abs(FFTY);
CY=CY*2;
CY(1)=CY(1)/2;
CY(length(CY))=CY(length(CY))/2;
CY=CY/length(y);
%f1=(0:NumUniquePts-1)*2*Fn/NFFY;

%========================================================================
%Plots
%========================================================================
figure(3)

subplot(3,1,1)
plot(tiq,sig1)
axis([0 5/N -2 2]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('I Output Waveform')

subplot(3,1,2)
plot(tiq,sig2)
axis([0 5/N -2 2]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('Q Output Waveform')

subplot(3,1,3)
plot(tiq,sumiq)
axis([0 5/N -2 2]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('QPSK Output Waveform')

figure(4)
subplot(3,1,1)
plot(f1,CY)
axis([0 40000 0 .1]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('Unspread')

subplot(3,1,2); plot(f1,MY);xlabel('');ylabel('AMPLITUDE');
axis([0 40000 0 .1]);%zoom in/out
title('Frequency domain spread');
grid on

subplot(3,1,3)
plot(f1,UY)
axis([0 40000 0 .1]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('carrier')

figure(5)
subplot(3,1,1); plot(f1,20*log10(abs(CY).^2));xlabel('FREQUENCY(Hz)');ylabel('DB');
axis([0 40000 -80 -20]);%zoom in/out
grid on
title('Modulated QPSK unspread signal')

subplot(3,1,2); plot(f1,20*log10(abs(MY).^2));xlabel('FREQUENCY(Hz)');ylabel('DB');
axis([0 40000 -80 -20]);%zoom in/out
grid on
title('Modulated QPSK spread signal')

subplot(3,1,3); plot(f1,20*log10(abs(UY).^2));xlabel('FREQUENCY(Hz)');ylabel('DB');
axis([0 40000 -80 0]);%zoom in/out
grid on
title('Carrier')

figure(6)
subplot(4,1,1)
plot(tiq,si)
axis([0 5/N -2 2]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('I channel spread Output Waveform')

subplot(4,1,2)
plot(tiq,sq)
axis([0 5/N -2 2]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('Q channel spread Output Waveform')

subplot(4,1,3)
plot(tiq,mi)
axis([0 5/N -2 2]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('I channel Output Waveform')

subplot(4,1,4)
plot(tiq,mq)
axis([0 5/N -2 2]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('Q channel Output Waveform')

end
