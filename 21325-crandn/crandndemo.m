function crandndemo
% Generate correlated Gaussian sequence by Fourier synthesis.
%
% S Bocquet 2 Sept 2008  Tested with MATLAB Version 7.6.0.324 (R2008a)
%
n = 1000; % number of samples
m = 500; % number of realisations
nplot = min([n 1000]); % number of samples to plot
nh = pow2(nextpow2(n/2)); % filter length - use smallest power of 2 >= n/2
n = 2*nh; % number of samples
T = 100; % correlation function maximum time lag to plot
nT = min([T+1,nh]); % correlation function plot length
t = 0:nh-1; % time scale
rgau = exp(-0.1*t).*cos(0.2*t); % input correlation function
tic % time the calculation
[cg, psg] = crandn(rgau,m); % correlated Gaussian process
fprintf(['To generate ' num2str(m) ' sequences of ' num2str(n) ' samples:\r'])
toc
% calculate power spectra and correlation functions from all m realisations
Y = fft(cg);
rgauP = Y.*conj(Y);
rgauP = sum(rgauP,2)/n/m; % power spectrum
rgau1 = ifft(rgauP); % output correlation function
% plot correlation functions
figure(1)
plot(t(1:nT),rgau(1:nT),'k',t(1:nT),rgau1(1:nT),'b')
legend('Input','Output')
title('Correlation functions')
% plot power spectra
f = (0:n-1)/n; % frequency scale
figure(2)
plot(f(1:nh),psg(1:nh),'k',f(1:nh),rgauP(1:nh),'b')
title('Gaussian process power spectrum')
% plot last example of time series
figure(3)
plot(cg(1:nplot,m))
title('Example of correlated Gaussian process')
% plot cumulative normal distribution
figure(4)
cg0 = @(xs) 0.5*erfc(-xs/sqrt(2.0));
plotcdfkuiper(cg,-3,3,cg0) % see MATLAB File Exchange id #21280
title('Cumulative normal distribution')
end