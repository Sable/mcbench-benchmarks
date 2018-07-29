function [imf,imf_fft]=imf_bearing(y,Fs,l)

%[imf,imf_fft]=imf_bearing(y,Fs,l) does the Empirical Mode Decomposition of the signal
%'y' of sampling frequency 'Fs'. 'l' mentions the lth imf, whose fft plot
%will be plotted. The function returns the imfs and the ffts of all the
%imfs
% For this, the Author has used the already available function Hilbert 
% Huang transform from Alan Tan in Matlab Central
%http://www.mathworks.com/matlabcentral/fileexchange/19681-hilbert-huang-transform
%
%The function basically is for Condition Monitoring of rotating equipments
%by vibration based bearing fault diagnosis.
%The function plots all the imf in one single plot and also plots the FFTs
%of the imf mentioned by l. 
%
%Example:
%       [y,Fs] = wavread('Hum.wav');
%       l=2;
%       imf_bearing(y(1:10000),Fs,l);
%
% Dont forget to rate or comment on the matlab central site
%http://www.mathworks.in/matlabcentral/fileexchange/authors/258518
%
%https://sites.google.com/site/santhanarajarunachalam/
%Author:Santhana Raj.A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imf = emd(y); %Calculates EMD. Uses EMD from Alan Tan.

% plot IMFs
M = length(imf);
N = length(y);
Ts=1/Fs;
c = linspace(0,(N-2)*Ts,N);
for k1 = 0:9:M-1   % modify this 9, to control the no of plots per figure
   figure
   for k2 = 1:min(9,M-k1), subplot(9,1,k2), plot(c,imf{k1+k2}); %here too
       set(gca,'FontSize',12,'XLim',[0 c(end)]);
   end
   xlabel('Time');
end

%plot FFTs of lth IMFs
   N=8192;T=N/Fs;
   figure();
   Y=abs(fft(imf{l},N)); 
   freq=(0:N-1)/T;
   plot(freq,Y);xlabel('Frequency');
  
end

