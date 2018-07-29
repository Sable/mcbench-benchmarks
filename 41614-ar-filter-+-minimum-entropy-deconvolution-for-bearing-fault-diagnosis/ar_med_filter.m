function y=ar_med_filter(signal,Fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function AR_MED_FILTER takes input SIGNAL with Sampling Frequency, %
% Fs, and applies the Yule Walker method based AR filter. The order iof the
% filter is found by Maximum kurtosis. After the application od AR filter,
% the signal is passed through Minimum Entropy Deconvolution. This combined
% AR+MED method brings out the Bearing faults hidden in Noise.
% 
% The function plots two figures for AR alone and another for AR+MED 
%
% Example:
%   load('s4.mat');
%   signal=s4;
%   Fs=12000;
%   ar_med_filter(signal,Fs);

% The File 's4.mat' is the vibration signal recorded from a OR faulty
% bearing with a sampling frequency of 12000Hz. The Fault frequency is 161
% Hz and is brought out.
%
% This program isa based on the paper:
% Sawalhi N, Randall RB and Endo H (2007) The enhancement of fault detection
% and diagnosis in rolling element bearings using minimum entropy 
% deconvolution combined with spectral kurtosis. Mechanical Systems and 
% Signal Processing. 21:2616-2633
%
% This function is basically written for Bearing fault diagnosis from
% Vibration signal.
%
%Dont forget to rate or comment on the matlab central site
%http://www.mathworks.in/matlabcentral/fileexchange/authors/258518
%
%Author:Santhana Raj.A
%https://sites.google.com/site/santhanarajarunachalam/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



sig=signal;

clear y y_e A

for order= 1:100


[A,E]=aryule(sig,order);
y(:,order)=filter(1,A,sig);
kurt(:, order)=kurtosis(y(:,order));
 

end

[~,index]=sort(kurt,1,'descend');
output=y(:,index(1));


figure();
N=4*2048;T=N/Fs;sig_f=abs(fft(output(1:N),N));
sig_n=sig_f/(norm(sig_f));freq_s=(0:N-1)/T;
plot(freq_s(3:350),sig_n(3:350)); title('AR alone');


%MED
[ar_med f_armed kurt_armed] = med2d(output,30,[],0.01,0);

figure();
N=4*2048;T=N/Fs;sig_f=abs(fft(ar_med(1:N),N));
sig_n=sig_f/(norm(sig_f));freq_s=(0:N-1)/T;
plot(freq_s(3:350),sig_n(3:350)); title('AR +MED');

y=ar_med;

end


