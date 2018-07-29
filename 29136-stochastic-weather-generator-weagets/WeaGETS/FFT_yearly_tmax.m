function FFT_yearly_tmax(yearly_observed_tmax)

% this program is designed to calculate the yearly Tmax which keep the 
% low-frequency variability using Fast Fourier Transforms (FFT)

load('years')
load('years_ratio')
Pnew_tmax=zeros(1,years*nn);
save('Pnew_tmax','Pnew_tmax');
phase_tmax=zeros(1,years*nn);
save('phase_tmax','phase_tmax')
for m=1:years:years*nn
%--------------------------------------
%
% step 1: read the yearly averaged Tmax series (time domain)
%
%--------------------------------------
    load('Pnew_tmax')
    load('phase_tmax')
    load('years')
    load('years_ratio')
    load('yearly_observed_tmax')
    P1=yearly_observed_tmax;
    n=size(P1,2);
    t=1:n;
%--------------------------------------
%
% step 2: produce Power spectrum through FFT (frequency domain)
%
%--------------------------------------
    P1n=P1-mean(P1);  % normalize to zero mean

    f = 0.5*linspace(0,n,n/2);  % frequencies in years

    Y1=fft(P1n)/n;    
%--------------------------------------
%
% step 3: produce new time series with identical frequency spectrum (new time domain)
%
%--------------------------------------
    spec=abs(Y1);
    phase=rand(1,n)*2.*pi;  % choose random phase
    phase_tmax(1,m:m+years-1)=phase(1,1:years); % save the random phase 
    save('phase_tmax','phase_tmax')
    Y1new = spec.* exp(i*phase);  % express in complex form
    Y1new(1)=0; Y1new(n/2+1)=0; Y1new((n/2+2):n)=fliplr(Y1new(2:(n/2)));  % make sure it is symmetrical
    P1new=ifft(Y1new,'symmetric')*n+mean(P1);
    Pnew_tmax(1,m:m+years-1)=P1new(1,1:years);
    save('Pnew_tmax','Pnew_tmax');
    clear
end


   