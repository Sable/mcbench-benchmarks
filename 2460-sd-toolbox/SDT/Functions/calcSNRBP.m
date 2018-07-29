function [snrdB,ptotdB,psigdB,pnoisedB] = calcSNRBP(vout,f,fBL,fBH,w,N,Vref)
% function [snrdB,ptotdB,psigdB,pnoisedB] = calcSNR(vout,f,fB,w,N,Vref) 25/09/99 FF Removed
% SNR calculation in the time domain (P. Malcovati, S. Brigati)
% Modified 25/09/99 (F. Francesconi) for BandPass Sigma-Delta Modulators
% vout: Sigma-Delta bit-stream taken at the modulator output
% f:    Normalized signal frequency (fs -> 1)
% fB:		Base-band frequency bins
% w:		windowing vector
% N:		samples number
% Vref:	feedback reference voltage
%
% snrdB: 	 	SNR in dB
% ptotdB:  	Bit-stream power spectral density (vector)
% psigdB:	 	Extracted signal power spectral density (vector)
% pnoisedB:	Noise power spectral density (vector)
%
% 25/09/99 FF - fB removed for fBL Lower Band Limit and fBH Higher Band Limit

% fB=ceil(fB); 25/09/99 FF Removed
fBL=ceil(fBL);
fBH=ceil(fBH);
signal=(N/sum(w))*sinusx(vout(1:N).*w,f,N);	% Extracts sinusoidal signal
noise=vout(1:N)-signal;			            % Extracts noise components
stot=((abs(fft((vout(1:N).*w)'))).^2);		% Bit-stream PSD
ssignal=(abs(fft((signal(1:N).*w)'))).^2;	% Signal PSD
snoise=(abs(fft((noise(1:N).*w)'))).^2;		% Noise PSD

% pwsignal=sum(ssignal(1:fB));	            % Signal power 25/09/99 FF Removed
% pwnoise=sum(snoise(1:fB));		            % Noise power 25/09/99 FF Removed
pwsignal=sum(ssignal(fBL:fBH));	            % Signal power
pwnoise=sum(snoise(fBL:fBH));		            % Noise power



snr=pwsignal/pwnoise;
snrdB=dbp(snr);
norm=sum(stot)/Vref^2;								% PSD normalization
if nargout > 1
	ptot=stot/norm; 
	ptotdB=dbp(ptot);
end

if nargout > 2
	psig=ssignal/norm;
	psigdB=dbp(psig);
end

if nargout > 3
	pnoise=snoise/norm;
	pnoisedB=dbp(pnoise);
end
