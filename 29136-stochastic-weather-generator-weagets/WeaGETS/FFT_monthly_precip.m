function FFT_monthly_precip(monthly_observed_P)
% this program is to calculate the monthly precip which keeps the 
% low-frequency variability for each month using Fast Fourier Transforms
% (FFT)

% ***********
% January
% ***********

load(monthly_observed_P)
load('years_ratio')
years=size(monthly_observed_P,1);
save('years','years')
Pnew=zeros(1,years*nn);
save('Pnew1','Pnew');
for m=1:years:years*nn
%--------------------------------------
%
% step 1: read the Jan precip series (time domain)
%
%--------------------------------------
    load('Pnew1')
    load('years')
    load('years_ratio')
    load('monthly_observed_P')
    n=size(monthly_observed_P,1);
    P1=monthly_observed_P(:,1)';
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
    Y1new = spec.* exp(i*phase);  % express in complex form
    Y1new(1)=0; Y1new(n/2+1)=0; Y1new((n/2+2):n)=fliplr(Y1new(2:(n/2)));  % make sure it is symmetrical
    P1new=ifft(Y1new,'symmetric')*n+mean(P1);
    Pnew(1,m:m+years-1)=P1new(1,1:years);
    save('Pnew1','Pnew');
    clear
end

% ***********
% February
% ***********
clear
load('years')
load('years_ratio')
Pnew=zeros(1,years*nn);
save('Pnew2','Pnew');
for m=1:years:years*nn
%--------------------------------------
%
% step 1: read the Feb precip series(time domain)
%
%--------------------------------------
    load('Pnew2')
    load('years')
    load('years_ratio')
    load('monthly_observed_P')
    n=size(monthly_observed_P,1);
    P1=monthly_observed_P(:,2)';
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
    Y1new = spec.* exp(i*phase);  % express in complex form
    Y1new(1)=0; Y1new(n/2+1)=0; Y1new((n/2+2):n)=fliplr(Y1new(2:(n/2)));  % make sure it is symmetrical
    P1new=ifft(Y1new,'symmetric')*n+mean(P1);
    Pnew(1,m:m+years-1)=P1new(1,1:years);
    save('Pnew2','Pnew');
    clear
end

% ***********
% March
% ***********
clear
load('years')
load('years_ratio')
Pnew=zeros(1,years*nn);
save('Pnew3','Pnew');
for m=1:years:years*nn
%--------------------------------------
%
% step 1: read the Mar precip series (time domain)
%
%--------------------------------------
    load('Pnew3')
    load('years')
    load('years_ratio')
    load('monthly_observed_P')
    n=size(monthly_observed_P,1);
    P1=monthly_observed_P(:,3)';
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
    Y1new = spec.* exp(i*phase);  % express in complex form
    Y1new(1)=0; Y1new(n/2+1)=0; Y1new((n/2+2):n)=fliplr(Y1new(2:(n/2)));  % make sure it is symmetrical
    P1new=ifft(Y1new,'symmetric')*n+mean(P1);
    Pnew(1,m:m+years-1)=P1new(1,1:years);
    save('Pnew3','Pnew');
    clear
end
   
% ***********
% April
% ***********
clear
load('years')
load('years_ratio')
Pnew=zeros(1,years*nn);
save('Pnew4','Pnew');
for m=1:years:years*nn
%--------------------------------------
%
% step 1: read the Apr precip series (time domain)
%
%--------------------------------------
    load('Pnew4')
    load('years')
    load('years_ratio')
    load('monthly_observed_P')
    n=size(monthly_observed_P,1);
    P1=monthly_observed_P(:,4)';
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
    Y1new = spec.* exp(i*phase);  % express in complex form
    Y1new(1)=0; Y1new(n/2+1)=0; Y1new((n/2+2):n)=fliplr(Y1new(2:(n/2)));  % make sure it is symmetrical
    P1new=ifft(Y1new,'symmetric')*n+mean(P1);
    Pnew(1,m:m+years-1)=P1new(1,1:years);
    save('Pnew4','Pnew');
    clear
end

% ***********
% May
% ***********
clear
load('years')
load('years_ratio')
Pnew=zeros(1,years*nn);
save('Pnew5','Pnew');
for m=1:years:years*nn
%--------------------------------------
%
% step 1: read the May precip series(time domain)
%
%--------------------------------------
    load('Pnew5')
    load('years')
    load('years_ratio')
    load('monthly_observed_P')
    n=size(monthly_observed_P,1);
    P1=monthly_observed_P(:,5)';
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
    Y1new = spec.* exp(i*phase);  % express in complex form
    Y1new(1)=0; Y1new(n/2+1)=0; Y1new((n/2+2):n)=fliplr(Y1new(2:(n/2)));  % make sure it is symmetrical
    P1new=ifft(Y1new,'symmetric')*n+mean(P1);
    Pnew(1,m:m+years-1)=P1new(1,1:years);
    save('Pnew5','Pnew');
    clear
end

% ***********
% June
% ***********
clear
load('years')
load('years_ratio')
Pnew=zeros(1,years*nn);
save('Pnew6','Pnew');
for m=1:years:years*nn
%--------------------------------------
%
% step 1: read the Jun precip series (time domain)
%
%--------------------------------------
    load('Pnew6')
    load('years')
    load('years_ratio')
    load('monthly_observed_P')
    n=size(monthly_observed_P,1);
    P1=monthly_observed_P(:,6)';
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
    Y1new = spec.* exp(i*phase);  % express in complex form
    Y1new(1)=0; Y1new(n/2+1)=0; Y1new((n/2+2):n)=fliplr(Y1new(2:(n/2)));  % make sure it is symmetrical
    P1new=ifft(Y1new,'symmetric')*n+mean(P1);
    Pnew(1,m:m+years-1)=P1new(1,1:years);
    save('Pnew6','Pnew');
    clear
end

% ***********
% July
% ***********
clear
load('years')
load('years_ratio')
Pnew=zeros(1,years*nn);
save('Pnew7','Pnew');
for m=1:years:years*nn
%--------------------------------------
%
% step 1: read the Jul precip series(time domain)
%
%--------------------------------------
    load('Pnew7')
    load('years')
    load('years_ratio')
    load('monthly_observed_P')
    n=size(monthly_observed_P,1);
    P1=monthly_observed_P(:,7)';
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
    Y1new = spec.* exp(i*phase);  % express in complex form
    Y1new(1)=0; Y1new(n/2+1)=0; Y1new((n/2+2):n)=fliplr(Y1new(2:(n/2)));  % make sure it is symmetrical
    P1new=ifft(Y1new,'symmetric')*n+mean(P1);
    Pnew(1,m:m+years-1)=P1new(1,1:years);
    save('Pnew7','Pnew');
    clear
end

% ***********
% August
% ***********
clear
load('years')
load('years_ratio')
Pnew=zeros(1,years*nn);
save('Pnew8','Pnew');
for m=1:years:years*nn
%--------------------------------------
%
% step 1: read the Aug precip series (time domain)
%
%--------------------------------------
    load('Pnew8')
    load('years')
    load('years_ratio')
    load('monthly_observed_P')
    n=size(monthly_observed_P,1);
    P1=monthly_observed_P(:,8)';
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
    Y1new = spec.* exp(i*phase);  % express in complex form
    Y1new(1)=0; Y1new(n/2+1)=0; Y1new((n/2+2):n)=fliplr(Y1new(2:(n/2)));  % make sure it is symmetrical
    P1new=ifft(Y1new,'symmetric')*n+mean(P1);
    Pnew(1,m:m+years-1)=P1new(1,1:years);
    save('Pnew8','Pnew');
    clear
end

% ***********
% September
% ***********
clear
load('years')
load('years_ratio')
Pnew=zeros(1,years*nn);
save('Pnew9','Pnew');
for m=1:years:years*nn
%--------------------------------------
%
% step 1: read the Sep precip series (time domain)
%
%--------------------------------------
    load('Pnew9')
    load('years')
    load('years_ratio')
    load('monthly_observed_P')
    n=size(monthly_observed_P,1);
    P1=monthly_observed_P(:,9)';
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
    Y1new = spec.* exp(i*phase);  % express in complex form
    Y1new(1)=0; Y1new(n/2+1)=0; Y1new((n/2+2):n)=fliplr(Y1new(2:(n/2)));  % make sure it is symmetrical
    P1new=ifft(Y1new,'symmetric')*n+mean(P1);
    Pnew(1,m:m+years-1)=P1new(1,1:years);
    save('Pnew9','Pnew');
    clear
end

% ***********
% October
% ***********
clear
load('years')
load('years_ratio')
Pnew=zeros(1,years*nn);
save('Pnew10','Pnew');
for m=1:years:years*nn
%--------------------------------------
%
% step 1: read the Oct precip series (time domain)
%
%--------------------------------------
    load('Pnew10')
    load('years')
    load('years_ratio')
    load('monthly_observed_P')
    n=size(monthly_observed_P,1);
    P1=monthly_observed_P(:,10)';
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
    Y1new = spec.* exp(i*phase);  % express in complex form
    Y1new(1)=0; Y1new(n/2+1)=0; Y1new((n/2+2):n)=fliplr(Y1new(2:(n/2)));  % make sure it is symmetrical
    P1new=ifft(Y1new,'symmetric')*n+mean(P1);
    Pnew(1,m:m+years-1)=P1new(1,1:years);
    save('Pnew10','Pnew');
    clear
end

% ***********
% November
% ***********
clear
load('years')
load('years_ratio')
Pnew=zeros(1,years*nn);
save('Pnew11','Pnew');
for m=1:years:years*nn
%--------------------------------------
%
% step 1: read the Nov precip series (time domain)
%
%--------------------------------------
    load('Pnew11')
    load('years')
    load('years_ratio')
    load('monthly_observed_P')
    n=size(monthly_observed_P,1);
    P1=monthly_observed_P(:,11)';
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
    Y1new = spec.* exp(i*phase);  % express in complex form
    Y1new(1)=0; Y1new(n/2+1)=0; Y1new((n/2+2):n)=fliplr(Y1new(2:(n/2)));  % make sure it is symmetrical
    P1new=ifft(Y1new,'symmetric')*n+mean(P1);
    Pnew(1,m:m+years-1)=P1new(1,1:years);
    save('Pnew11','Pnew');
    clear
end

% ***********
% December
% ***********
clear
load('years')
load('years_ratio')
Pnew=zeros(1,years*nn);
save('Pnew12','Pnew');
for m=1:years:years*nn
%--------------------------------------
%
% step 1: read the Dec precip series(time domain)
%
%--------------------------------------
    load('Pnew12')
    load('years')
    load('years_ratio')
    load('monthly_observed_P')
    n=size(monthly_observed_P,1);
    P1=monthly_observed_P(:,12)';
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
    Y1new = spec.* exp(i*phase);  % express in complex form
    Y1new(1)=0; Y1new(n/2+1)=0; Y1new((n/2+2):n)=fliplr(Y1new(2:(n/2)));  % make sure it is symmetrical
    P1new=ifft(Y1new,'symmetric')*n+mean(P1);
    Pnew(1,m:m+years-1)=P1new(1,1:years);
    save('Pnew12','Pnew');
    clear
end