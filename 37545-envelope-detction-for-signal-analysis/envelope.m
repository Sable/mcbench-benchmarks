function y=envelope(signal,Fs)

%y=envelope(Signal,Fs) computes the Envelope of the input Signal with a
%Sampling Frequency 'Fs' and gives the envelope signal by hilbert transform
%method as the output y.
%The function computes the envelope of the signal by two different methods.
%
%First Method: By USing Low Pass Filter. THe Signal is Squared, Passed
%through LPF and then taken square root.
%Second Method: Using Hilbert Transform. Hilbert Transform is taken using
%the inbuilt function in Matlab
%
%The Function Displays the FFT of the original signal and also the FFT of
%the envelope signal by both the methods
%
%The function basically is for computing Envelope Signal for Condition 
%Monitoring of rotating equipments by vibration based bearing 
%fault diagnosis.
%
%Example:
%   load('s4.mat');
%   signal=s4;
%   Fs=12000;
%   envelope(signal,Fs);
%
%The File 's4.mat' is the vibration signal recorded from a OR faulty
%bearing with a sampling frequency of 12000Hz. The Fault frequency is 161Hz
%and is brought out in envelope signal which was hidden in the original
%FFT.
%
%Dont forget to rate or comment on the matlab central site
%http://www.mathworks.in/matlabcentral/fileexchange/authors/258518
%
%Author:Santhana Raj.A
%https://sites.google.com/site/santhanarajarunachalam/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clc;
close all;

%Normal FFT
y=signal;
figure();
N=2*2048;T=N/Fs;
sig_f=abs(fft(y(1:N)',N));
sig_n=sig_f/(norm(sig_f));
freq_s=(0:N-1)/T;
plot(freq_s(2:250),sig_n(2:250));title('FFT of Original Signal');


%Envelope Detection based on Low pass filter and then FFT
[a,b]=butter(2,0.1);%butterworth Filter of 2 poles and Wn=0.1
%sig_abs=abs(signal); % Can be used instead of squaring, then filtering and
%then taking square root
sig_sq=2*signal.*signal;% squaring for rectifing 
%gain of 2 for maintianing the same energy in the output
y_sq = filter(a,b,sig_sq); %applying LPF
y=sqrt(y_sq);%taking Square root
%advantages of taking square and then Square root rather than abs, brings
%out some hidden information more efficiently
figure();
N=2*2048;T=N/Fs;
sig_f=abs(fft(y(1:N)',N));
sig_n=sig_f/(norm(sig_f));
freq_s=(0:N-1)/T;
plot(freq_s(2:250),sig_n(2:250));title('Envelope Detection: LPF Method');



%Envelope Detection based on Hilbert Transform and then FFT
analy=hilbert(signal);
y=abs(analy);
figure();
N=2*2048;T=N/Fs;
sig_f=abs(fft(y(1:N)',N));
sig_n=sig_f/(norm(sig_f));
freq_s=(0:N-1)/T;
plot(freq_s(2:250),sig_n(2:250));title('Envelope Detection : Hilbert Transform')


