function [cg, psg] = crandn(rgau,m)
% Generate correlated Gaussian sequences by Fourier synthesis.
%
% Input parameters:
% rgau = correlation function - length n/2
% m    = number of realisations
%
% Output:
% cg   = m x n matrix containing m sequences of n correlated variates from
%        a zero mean, unit variance normal distribution
% psg  = input power spectrum (Fourier transform of correlation function)
%
% Note: Since this uses the fast Fourier transform, it will be fastest if
% n is a power of 2.
%
% S Bocquet 12 August 2008  Tested with MATLAB Version 7.6.0.324 (R2008a)
%
if ~isvector(rgau)
  error('crandn:vector','Correlation function must be a vector')
end
if ((rgau(1) ~= 1) || (max(abs(rgau)) > 1))
  error('crandn:cfnorm','Correlation function not properly normalised');
end
if abs(rgau(end)) > 0.01
  warning('crandn:cfdecay','Correlation function does not go to zero')
end
n = 2*length(rgau);
rgau2 = [rgau(1:end),0,rgau(end:-1:2)]; % two sided correlation function
psg = abs(fft(rgau2)); % Fourier transform of correlation function
nrm = mean(psg)/n; % normalisation
h = sqrt(psg/nrm); % normalised filter function
cg = zeros(n,m);
for i=1:m
  if mod(i,2)==1
    g = complex(randn(1,n),randn(1,n));
    cg2 = ifft(g.*h); % correlated Gaussian process
    cg(:,i) = real(cg2);
  else
    cg(:,i) = imag(cg2);
  end
end
end