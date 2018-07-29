function  [fy,f]=FFT(y,Fs)

%==========================================================================
%  (Updated Version 03/09/2013)
%  Usage :  
%  Function  [fy]=FFT(y,Fs)
%
%  1)computes the Power spectral density and Amplitude spectrum (P(f),F(f))
%  of 1d signal y(t) with sample rate  Fs (Nyquist rate) which is known
%  apriori. The results are plotted in 3 figures which correspond to simple
%  PSD,logarithmic PSD (dB) and  Amplitude Specturm respectively.
%                             _______________
%  such that  Ampitude(f) = \/    PSD(f)
%  
%  2)The usefulness of this function is the adjustment of the frequency axis
%
%  3)The fast Fourier transform is computed with Matlab built-in function
%  fft, but for signals whose lengths <1000 points, one can use the nested
%  function   y=Fast_Fourier_Transform(X,N) .
%
%  Demo :
%
%                 Fs=800; 
%                 Tf=2;
%                 t=0:1/Fs:Tf;
%                 f=[40 75];
%                 Amp=[4.5 9.22];
%                 sigma=1.33;
%                 y=Amp(1)*exp(j*2*pi*t*f(1))+Amp(2)*exp(j*2*pi*t*f(2));
%                 N=(sigma/sqrt(2))*(randn(size(t))+j*randn(size(t)));
%                 y=y+N;
%                 figure, plot(t,y),xlabel('time (s)'),ylabel('Voltage (v)'),
%                 title(strcat('Signal corrupted with AWGN, \sigma=',num2str(sigma))),
%                 fy=FFT(y,Fs); 
%
% (c) KHMOU Youssef , Signal Processing 2013
%==========================================================================



if nargin<2
    error(' Sampling frequency is required to sompute (PSD,F(y)) ! ');
end

% In case that the input vector is matrix :  Maping with vect{} .
y=y(:).';
L=length(y);

%  (2^N) :Number of points for computing the FFT 
N=ceil(log2(length(y)));

% FFT 
fy=fft(y,2^N)/(L/2);
%------------------------------------------------
% for length<1000 one can replace fft with function :
% fy=Fast_Fourier_Transform(y,2^N)/(L/2); (line 84)
%------------------------------------------------

% Amplitude adjustment by checking for complex input y 
if isreal(y)==0
    fy=fy/2;
end

% PSD
Power=fy.*conj(fy);
%Phase Angle
phy=angle(fy);

%  Frequency axis
f=(Fs/2^N)*(0:2^(N-1)-1);

%if nargin==4
    
% Figures------------------------------------------------------------------
ff1=figure;
plot(f,Power(1:2^(N-1)),'r'),  xlabel('  Frequency (Hz)'), ylabel(' Magnitude (w)'),
title('  Power Spectral Density'), grid on;
set(ff1,'Name','PSD');

ff2=figure;
plot(f,10*log10(Power(1:2^(N-1))),'r'),  xlabel('  Frequency (Hz)'), ylabel(' Magnitude  (dB)'),
title('  Power Spectral Density, logarithmic scale '), grid on;
set(ff2,'Name','10*log10(PSD)');

ff3=figure;
plot(f,sqrt(Power(1:2^(N-1))),'r'),  xlabel('  Frequency (Hz)'), ylabel('|F(Y)|'),
title('  Amplitude Spectrum'), grid on;
set(ff3,'Name','|F(y)|');


ff4=figure;
plot(f,phy(1:2^(N-1)),'b'), xlabel(' Frequency (Hz)'), ylabel(' arg(F(Y))'),
title(' Phase spectrum'), grid on;
set(ff4,'Name','arg(F(Y))');
%end
%==========================================================================
% function z=Fast_Fourier_Transform(x,nfft)
%
% N=length(x);
% z=zeros(1,nfft);
% Sum=0;
% for k=1:nfft
%     for jj=1:N
%         Sum=Sum+x(jj)*exp(-2*pi*j*(jj-1)*(k-1)/nfft);
%     end
% z(k)=Sum;
% Sum=0;% Reset
% end
% return
%=========================================================================


% Additional plot :  PDF
%M=max(real(y));
%M=2*M;
%x_range=-M:M/20:M;
%ff4=figure;
%hist(real(y),x_range),xlabel('Signal values'), ylabel('PDF');
%title('  Probability density function of the input signal'), grid minor;
%set(ff4,'Name','PDF');
%clear M x_range 
