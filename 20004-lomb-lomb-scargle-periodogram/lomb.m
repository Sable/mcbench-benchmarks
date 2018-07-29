function [f,P,prob] = lomb(t,h,ofac,hifac)
% LOMB(T,H,OFAC,HIFAC) computes the Lomb normalized periodogram (spectral
% power as a function of frequency) of a sequence of N data points H,
% sampled at times T, which are not necessarily evenly spaced. T and H must
% be vectors of equal size. The routine will calculate the spectral power
% for an increasing sequence of frequencies (in reciprocal units of the
% time array T) up to HIFAC times the average Nyquist frequency, with an
% oversampling factor of OFAC (typically >= 4).
% 
% The returned values are arrays of frequencies considered (f), the
% associated spectral power (P) and estimated significance of the power
% values (prob).  Note: the significance returned is the false alarm
% probability of the null hypothesis, i.e. that the data is composed of
% independent gaussian random variables.  Low probability values indicate a
% high degree of significance in the associated periodic signal.
% 
% Although this implementation is based on that described in Press,
% Teukolsky, et al. Numerical Recipes  In C, section 13.8, rather than using
% trigonometric rercurrences, this takes advantage of MATALB's array
% operators to calculate the exact spectral power as defined in equation
% 13.8.4 on page 577.  This may cause memory issues for large data sets and
% frequency ranges.
% 
% Example    
%    [f,P,prob] = lomb(t,h,4,1);   
%    plot(f,P)
%    [Pmax,jmax] = max(P)
%    disp(['Most significant period is ',num2str(1/f(jmax)),...
%         ' with FAP of ',num2str(prob(jmax))])
% 
% Written by Dmitry Savransky 21 May 2008

%sample length and time span
N = length(h);
T = max(t) - min(t);

%mean and variance 
mu = mean(h);
s2 = var(h);

%calculate sampling frequencies
f = (1/(T*ofac):1/(T*ofac):hifac*N/(2*T)).';

%angular frequencies and constant offsets
w = 2*pi*f;
tau = atan2(sum(sin(2*w*t.'),2),sum(cos(2*w*t.'),2))./(2*w);

%spectral power
cterm = cos(w*t.' - repmat(w.*tau,1,length(t)));
sterm = sin(w*t.' - repmat(w.*tau,1,length(t)));
P = (sum(cterm*diag(h-mu),2).^2./sum(cterm.^2,2) + ...
     sum(sterm*diag(h-mu),2).^2./sum(sterm.^2,2))/(2*s2);

%estimate of the number of independent frequencies
M=2*length(f)/ofac;

%statistical significane of power
prob = M*exp(-P);
inds = prob > 0.01;
prob(inds) = 1-(1-exp(-P(inds))).^M;
