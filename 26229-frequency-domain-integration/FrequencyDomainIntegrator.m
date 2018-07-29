function phase_meas=FrequencyDomainIntegrator(fDop_meas,tt)
%USAGE:  phase_meas=FrequencyDomainIntegrator(fDop_meas,tt)
% Integrate frequency to obtain phase
% Frequency domain method   f' <=> -i*fhat/(omega)
% Doppler extension is used to minimize aliasing errors
% 
% INPUT:
%  fDop_meas   =  frequency             (Hz)
%  tt          =  time                  (sec)
% OUTPUT:
%  phase       =  integral of frequency (rad)
%

%Written by Chuck Rino
%Rino Consulting
%crino@mindspring.com
%Jan 2, 2010
%
nrecs=length(fDop_meas);
dt_rec=diff(tt(1:2));

%Extended data set with gaussian taper to zero
frac=0.1;  %10% extension at each end
nrecs_e=ceil(2*nrecs*(1+2*frac))/2;  
tte=[-nrecs_e/2:nrecs_e/2-1]*dt_rec;
[~,n1]=min(abs(tte-tt(1)));
[~,n2]=min(abs(tte-tt(end)));
n2s=nrecs_e-n2;
fDop_e=zeros(1,nrecs_e);
fDop_e(1:n1-1)      =fDop_meas(1)*exp(-[-n1+2:0].^2/(100*n1));
fDop_e(n2+1:nrecs_e)=fDop_meas(nrecs)*exp(-[0:n2s-1].^2/(100*n2s));
fDop_e(n1:n2)=fDop_meas;

nfft=nicefftnum(nrecs_e);
fDop_mean=mean(fDop_e);                            %Remove mean
fDop_hat=fft(fDop_e-fDop_mean,nfft);      
arg=2*pi*fftshift([-nfft/2:nfft/2-1]);
fDop_hat=-1i*fDop_hat./arg;
fDop_hat(1)=0;                            
%                                                  %Reinsert phase contribution from mean
phase_meas=(2*pi*nfft*dt_rec)*real(ifft(fDop_hat))+2*pi*fDop_mean*[-nfft/2:nfft/2-1]*dt_rec;
phase_meas=phase_meas(n1:n2);

return
