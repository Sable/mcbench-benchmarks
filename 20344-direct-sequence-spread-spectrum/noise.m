function [rnd_noise,nb_noise]=noise(sumiq,tiq,N,noise_offset)
%Bob Gess, June 2008 for EE 473
%Variable section (and probably some other sections) were copied and
%modified from QPSK_TX_IQ_RX by JC and posted on Mathworks Dec 2005.

%Generates both random noise and a jamming signal.  Amplitude of random
%noise is set by changing value of variable "var" and amplitude of jamming
%signal is set by changing value of "a"
%Amplitude of both is set relative to strength of transmitted signal (which is
%set to 1).  For example, a value of 2 for "a" means the power of the
%jamming signal is twice as strong as the desired transmitted signal AT THE
%RECEIVER (If the UAV is closer to the jammer, then jammer signal is
%stronger than the transmitted signal even if both were the same power when
%they left their source.)

%Jamming signal uses BPSK modulation.  That seemed like a fairly effective
%modulation scheme for a jamming signal since PSK modulation is very common
%for digital communications.  One could create more variety in the types of
%interference signals generated, modifying the master program (testing) to
%include the desired jamming signal.

var=.5;  %make .1 to 1 to increase random noise level
a=4;    %make .1 to 8 to increase relative strength of jamming signal


%=============================================================
%Random Noise
rnd_noise=sqrt(var)*randn(size(sumiq));
%============================================================

ncarr=20e3+noise_offset;         % Carrier frequency(Hz) + offset
%N=1e3;		        % Number of data bits(bit rate)
fs=8*10e3;		    % Sampling frequency
Fn=fs/2;            % Nyquist frequency
Ts=1/fs;	        % Sampling time = 1/fs
T=1/N;		        % Bit time
%randn('state',0);   % Keeps PRBS from changing on reruns
td=[0:Ts:(N*T)-Ts]';% Time vector(data)(transpose)

%============================================================
%Jamming signal
%============================================================
data=sign(randn(N,1))';%transpose
data1=ones(T/Ts,1)*data;
data2=data1(:);
%length(data2)

%display input data bits in command window
data_2=data2';
data_2=data_2 >0;
x=0;
noise_data_bits=data_2(1:(fs+x)/N:end);

bs1=data(1:2:length(data));%odd
symbols=ones(T/Ts,1)*bs1;
noise_bits=symbols(:);%I_waveform
%length(noise_bits);


%generate carrier waves
%cosine and sine wave
%2 pi fc t is written as below
twopi_fc_t=(1:fs/2)*2*pi*ncarr/fs;
%phi=45*pi/180
phi=0;%phase error
cs_t = a * cos(twopi_fc_t + phi);


nb_noise=cs_t.*noise_bits'+rnd_noise;

%========================================================================
%Take FFT of modulated unspread carrier
%========================================================================
y=nb_noise;
NFFY=2.^(ceil(log(length(y))/log(2)));
FFTY=fft(y,NFFY);%pad with zeros
NumUniquePts=ceil((NFFY+1)/2); 
FFTY=FFTY(1:NumUniquePts);
NY=abs(FFTY);
NY=NY*2;
NY(1)=NY(1)/2;
NY(length(NY))=NY(length(NY))/2;
NY=NY/length(y);
f1=(0:NumUniquePts-1)*2*Fn/NFFY;


%=====================================================================
%Plots
%======================================================================

figure(13)
subplot(2,1,1)
plot(f1,NY)
axis([0 40000 0 .1]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('Noise')

subplot(2,1,2); plot(f1,20*log10(abs(NY).^2));xlabel('FREQUENCY(Hz)');ylabel('DB');
axis([0 40000 -80 -20]);%zoom in/out
grid on
title('Noise signal')

end
