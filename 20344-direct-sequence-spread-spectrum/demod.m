function [bit_errs_qpsk,bitout1,bitout2,ycfo1,ycfo2]=demod(msumiq,cs_t,sn_t,tiq,data,N,fcarr)
%Bob Gess, June 2008, for EE473
%Portions copied and modified from QPSK_TX_IQ_RX by JC and posted on
%Mathworks, Dec 2005

%Demodulates unspread signal for comparison to spread spectrum signal.
%The number of bit errors and the bit error rate are output to the command
%window at the end of the program

%fcarr=20e3;         % Carrier frequency(Hz)
%N=1e3;		        % Number of data bits(bit rate)
fs=8*10e3;		    % Sampling frequency
Fn=fs/2;            % Nyquist frequency
Ts=1/fs;	        % Sampling time = 1/fs
T=1/N;		        % Bit time
randn('state',0);   % Keeps PRBS from changing on reruns
td=[0:Ts:(N*T)-Ts]';% Time vector(data)(transpose)



sig_rx1=msumiq.*cs_t;%cosine
%simple low pass filter

rc1=1/N;%time constant
ht1=(1/rc1).*exp(-tiq/rc1);%impulse response
ycfo1=filter(sig_rx1,1,ht1)/fs;
f1=length(ycfo1)        %Verifies program running


sig_rx2=msumiq.*sn_t;%sine

%simple low pass filter
rc=1/N;%time constant
ht=(1/rc).*exp(-tiq/rc);%impulse response
ycfo2=filter(sig_rx2,1,ht)/fs;
f2=length(ycfo2)        %Verifies program running


bit1=sign(ycfo1);%+/-1
bit2=sign(ycfo2);%+/-1

%Second filter stage (optional, but gives slight improvement)
bit3=filter(bit1,1,ht)/fs;
f3=length(bit3)         %Verifies program running
bit4=filter(bit2,1,ht)/fs;
f4=length(bit4)         %Verifies program running

bit5=sign(bit3);%+/-1
bit6=sign(bit4);%+/-1

shaped_ibit=bit5 >0;%0 and 1
shaped_qbit=bit6 >0;%0 and 1

bitout1=shaped_ibit';%transpose
bitout2=shaped_qbit';%transpose

%compare received data to transmitted data by sampling at end of time
%cycle for data bit.  Sampling at end of sequence compensates for delay
%caused by filtering and better simulates how data would actually be
%captured by processor
x=1;
for i=(fs/N-2):(fs/N):39998
    
    serial(x)=(bitout1(i)+bitout1(i+1)+bitout1(i+2))/3;
    x=x+1;
    serial(x)=(bitout2(i)+bitout2(i+1)+bitout2(i+2))/3;  
    x=x+1;
end
data_1=data >0;
serial1=serial >.5;
bit_errs_qpsk=xor(data_1,serial1);
qpsk_bit_errs=sum(bit_errs_qpsk)
qpsk_ber=qpsk_bit_errs/N





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
f1=(0:NumUniquePts-1)*2*Fn/NFFY;



%=====================================================================
%Plots
%======================================================================

figure(10)
subplot(3,2,1)
plot(tiq,sig_rx1)
axis([0 20/N -2 2]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('I channel Output Waveform')

subplot(3,2,2)
plot(tiq,sig_rx2)
axis([0 20/N -2 2]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('Q channel Output Waveform')

subplot(3,2,3)
plot(tiq,ycfo1)
axis([0 20/N -2 2]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('I channel Output Waveform')

subplot(3,2,4)
plot(tiq,ycfo2)
axis([0 20/N -2 2]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('Q channel Output Waveform')

subplot(3,2,5)
plot(tiq,bitout1)
axis([0 20/N -2 2]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('I channel Unspread Output Waveform')

subplot(3,2,6)
plot(tiq,bitout2)
axis([0 20/N -2 2]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('Q channel Unspread Output Waveform')

figure(11)
subplot(2,1,1)
plot(f1,CY)
axis([0 40000 0 1]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('Unspread')

subplot(2,1,2); plot(f1,20*log10(abs(CY).^2));xlabel('FREQUENCY(Hz)');ylabel('DB');
axis([0 40000 -80 0]);%zoom in/out
grid on
title('Received unspread signal')

end