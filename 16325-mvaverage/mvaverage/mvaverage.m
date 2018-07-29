function y=mvaverage(x,N)

%MVAVERAGE   signal smoothing through the moving average method.
%   Y = MVAVERAGE(X,N) Quickly smooths the signal X via averaging each 
%   sampling with the previous N samples.
%
%   Example:
%      t = 2*pi*linspace(-1,1); 
%      xn = cos(x) + 0.25 - 0.5*rand(size(x)); 
%      xs = mvaverage(xn,8);
%      plot(t,xn,t(5:end-4),xs(9:end)), legend('noisy','smooth'), axis tight
%
%   See also MVAVERAGE2 and MVAVERAGEC

%   by Yi Cao
%   Cranfield University
%   11-09-2007
%   y.cao@cranfield.ac.uk
%

y=filter(ones(1,N)/N,1,x);