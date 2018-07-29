function [data,data2,Isymbols,Qsymbols]=serial_to_parallel(N)
%Bob Gess, June 2008 for EE 473
%Extracted and modified from original code (QPSK_TX_IQ_RX) written by JC and posted on
%Mathworks 12-23-2005.

%This module generates the data and splits it into the I channel and Q
%channel
%N=1e3;		        % Number of data bits(bit rate)
fs=40*2e3;		    % Sampling frequency
Fn=fs/2;            % Nyquist frequency
Ts=1/fs;	        % Sampling time = 1/fs
T=1/N;		        % Bit time
randn('state',0);   % Keeps PRBS from changing on reruns
td=[0:Ts:(N*T)-Ts]';% Time vector(data)(transpose)
%===================================================================
% Input data
%===================================================================
data=sign(randn(N,1))';%transpose
data1=ones(T/Ts,1)*data;
data2=data1(:);
%length(data2)

%display input data bits in command window
data_2=data2';
data_2=data_2 >0;
x=0;
transmitted_data_bits=data_2(1:(fs+x)/N:end);

%Serial to parallel (alternating)
tiq = [0:Ts*2:(N*T)-Ts]';% Time vector for I and Q symbols(transpose)

bs1=data(1:2:length(data));%odd
symbols=ones(T/Ts,1)*bs1;
Isymbols=symbols(:);%I_waveform
%LI=length(Isymbols)

bs2=data(2:2:length(data));%even
symbols1=ones(T/Ts,1)*bs2;
Qsymbols=symbols1(:);%Q_waveform
%LQ=length(Qsymbols)

%=====================================================================
%Plots
%======================================================================
figure(1)
subplot(3,1,1)
plot(td,data2)
axis([0 20/N -2 2]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('Input Data')

subplot(3,1,2)
plot(tiq,Isymbols)
axis([0 20/N -2 2]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('I Channel(one bit/symbol(phase)) Data')

subplot(3,1,3)
plot(tiq,Qsymbols)
axis([0 20/N -2 2]);
grid on
xlabel('                                                          Time')
ylabel('Amplitude')
title('Q Channel(one bit/symbol(phase)) Data')
