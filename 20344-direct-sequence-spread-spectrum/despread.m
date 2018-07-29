function [bit_errs_ss,i_out,q_out]=despread(tiq,sumiq,cs_t,sn_t,seq1,seq2,data,N,fcarr)
%Bob Gess, June 2008, for EE473
%Portions copied and modified from QPSK_TX_IQ_RX by JC and posted on
%Mathworks Dec 2005

%This module multplies the carrier frequency by the prn sequence and then
%demodulates the incoming signal by the composite signal (prn and carrier)
%The data is also filtered to produce the I-channel, Q-channel.

%The program aso displays the number of bit errors and the bit error rate
%in the command window at the end of the simulation.

%fcarr=20e3;         % Carrier frequency(Hz)
%N=1e3;		        % Number of data bits(bit rate)
fs=8*10e3;		    % Sampling frequency
Fn=fs/2;            % Nyquist frequency
Ts=1/fs;	        % Sampling time = 1/fs
T=1/N;		        % Bit time
randn('state',0);   % Keeps PRBS from changing on reruns
td=[0:Ts:(N*T)-Ts]';% Time vector(data)(transpose)

%prn and carrier
si=cs_t.*seq1;
sq=sn_t.*seq2;

%demodulate and despread
ibit=sumiq.*si;

qbit=sumiq.*sq;

combined=ibit+qbit;

%simple low pass filter

rc1=1/N;                    %time constant
ht1=(1/rc1).*exp(-tiq/rc1);%impulse response
flt_ibit=filter(ibit,1,ht1)/fs;
f5=length(flt_ibit)     %Verifies progress of program


%filter for q channel
rc=1/N;                 %time constant
ht=(1/rc).*exp(-tiq/rc);%impulse response
flt_qbit=filter(qbit,1,ht)/fs;
f6=length(flt_qbit)     %Verifies progress of program


bit1=sign(flt_ibit);%+/-1
bit2=sign(flt_qbit);%+/-1

%Second filtering stage (optional, but does give slight improvement)
bit3=filter(bit1,1,ht1)/fs;
f7=length(bit3)         %Verifies progress of program
bit4=filter(bit2,1,ht)/fs;
f8=length(bit4)         %Verifies progress of program


bit5=sign(bit3);%+/-1
bit6=sign(bit4);%+/-1

shaped_ibit=bit5 >0;%0 and 1
shaped_qbit=bit6 >0;%0 and 1

i_out=[shaped_ibit]';%transpose
q_out=[shaped_qbit]';%transpose

%compare received data to transmitted data by sampling at end of time
%cycle for data bit.  This compensates for delay created by filtering (plus
%more accurately simulates how processor would capture the data).
x=1;
for i=(fs/N-2):(fs/N):39998
    
    serial(x)=(i_out(i)+i_out(i+1)+i_out(i+2))/3;
    x=x+1;
    serial(x)=(q_out(i)+q_out(i+1)+q_out(i+2))/3;  
    x=x+1;
end
data_1=data >0;
serial_1=serial >.5;
bit_errs_ss=xor(data_1,serial_1);
ss_bit_errors=sum(bit_errs_ss)
ss_ber=ss_bit_errors/N




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
f1=(0:NumUniquePts-1)*2*Fn/NFFY;

%========================================================================
%Take FFT of despread combined signal (for demo purposes)
%========================================================================
y=combined;
NFFY=2.^(ceil(log(length(y))/log(2)));
FFTY=fft(y,NFFY);%pad with zeros
NumUniquePts=ceil((NFFY+1)/2); 
FFTY=FFTY(1:NumUniquePts);
DY=abs(FFTY);
DY=DY*2;
DY(1)=DY(1)/2;
DY(length(DY))=DY(length(DY))/2;
DY=DY/length(y);
f1=(0:NumUniquePts-1)*2*Fn/NFFY;

%=====================================================================
%Plots
%======================================================================

figure(8)
subplot(4,1,1)
plot(tiq,ibit)
axis([0 20/N -2 2]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('I channel Output Waveform')

subplot(4,1,2)
plot(tiq,qbit)
axis([0 20/N -2 2]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('Q channel Output Waveform')

subplot(4,1,3)
plot(tiq,si)
axis([0 5/N -2 2]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('i demod sig Waveform')

subplot(4,1,4)
plot(tiq,sq)
axis([0 5/N -2 2]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('q demod sig Waveform')

figure(9)

subplot(2,1,1)
plot(tiq,i_out)
axis([0 20/N -2 2]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('SS I Channel Data')

subplot(2,1,2)
plot(tiq,q_out)
axis([0 20/N -2 2]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('SS Q Channel Data')

figure(12)
subplot(2,1,1); plot(f1,MY);xlabel('');ylabel('AMPLITUDE');
axis([0 40000 0 1]);%zoom in/out
title('Frequency domain received');
grid on

subplot(2,1,2); plot(f1,20*log10(abs(MY).^2));xlabel('FREQUENCY(Hz)');ylabel('DB');
axis([0 40000 -80 0]);%zoom in/out
grid on
title('Received QPSK spread signal')

figure(12)
subplot(2,1,1); plot(f1,MY);xlabel('');ylabel('AMPLITUDE');
axis([0 40000 0 1]);%zoom in/out
title('Frequency domain received');
grid on

subplot(2,1,2); plot(f1,20*log10(abs(MY).^2));xlabel('FREQUENCY(Hz)');ylabel('DB');
axis([0 40000 -80 0]);%zoom in/out
grid on
title('Received QPSK spread signal')

figure(14)
subplot(2,1,1); plot(f1,DY);xlabel('');ylabel('AMPLITUDE');
axis([0 4*N 0 1]);%zoom in/out
title('Frequency domain despread combined signal');
grid on

subplot(2,1,2); plot(f1,20*log10(abs(DY).^2));xlabel('FREQUENCY(Hz)');ylabel('DB');
axis([0 4*N -80 0]);%zoom in/out
grid on
title('Received despread combined signal')
end