function s=semblance(t,y1,y2,nscales)

% SEMBLANCE(t,y1,y2,nscales)
% Produces a cross-correlation plot between two timeseries as a function of
% both time and wavelength
% *** Requires Matlab wavelet toolbox
% Type semblance; for demo with synthetic data
% Inputs;
% t         Time axis 
% y1,y2     Datasets to be compared
% nscales   No. of scales/wavelengths to use - not more than length(t)...
% Outputs;
% s     : Semblance; a matrix of values between -1 (anticorrelated), 
%         zero (uncorrelated), and +1 correlated

% *******************************************************
% *** Wavelet-Based semblance analysis
% *** GRJ Cooper 2005
% *** School of Geosciences, University of the Witwatersrand
% *** Johannesburg, South Africa
% *** cooperg@geosciences.wits.ac.za, grcooper@iafrica.com
% *** www.wits.ac.za/science/geophysics/gc.htm
% *******************************************************
% If you use this program please reference this paper;
% Cooper, G.R.J., and Cowan, D.R., 2008. 
% Comparing Time Series using Wavelet Based Semblance Analysis
% Computers & Geosciences v.34(2) p.95-102.
%
% E-mail me for the pdf if you're interested
% ******************************************************

if nargin==0;                        % demo analysis
 t=1:512;
 y1=sin(t*0.05)+sin(t*0.15);
 y2(1:170)=-sin(t(1:170)*0.05)+sin(t(1:170)*0.15);
 y2(171:340)=sin(t(171:340)*0.05)+cos(t(171:340)*0.15);
 y2(341:512)=cos(t(341:512)*0.05)-sin(t(341:512)*0.15);
 nscales=150;
end;

y1(isnan(y1))=0; y2(isnan(y2))=0;
m1=mean(y1(:)); m2=mean(y2(:)); y1=y1-m1; y2=y2-m2; 
nscales=round(abs(nscales));
c1=cwt(y1,1:nscales,'cmor1-1'); 
c2=cwt(y2,1:nscales,'cmor1-1'); 
ctc=c1.*conj(c2);                  % Cross wavelet transform amplitude
spt=atan2(imag(ctc),real(ctc));
s=cos(spt);                        % Semblance

% Display results

figure(1); clf;
currfig=get(0,'CurrentFigure'); set(currfig,'numbertitle','off');
set(currfig,'name','Wavelet Semblance Analysis'); 
y1=y1+m1; y2=y2+m2;
subplot(5,1,1); plot(t,y1); axis tight; title('Data 1'); 
subplot(5,1,2); imagesc(real(c1)); axis xy; axis tight; title('CWT'); ylabel('Wavelength');
subplot(5,1,3); plot(t,y2); axis tight; title('Data 2'); 
subplot(5,1,4); imagesc(real(c2)); axis xy; axis tight; title('CWT'); ylabel('Wavelength');
subplot(5,1,5); imagesc(s,[-1 1]); axis xy; axis tight; title('Semblance'); ylabel('Wavelength'); 
colormap(jet(256));






