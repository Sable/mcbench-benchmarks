function y=mvaveragec(x,N)

%MVAVERAGEC   signal smoothing through the moving average method.
%   Y = MVAVERAGEC(X,N) Quickly smooths the signal X via averaging each 
%   sampling with the previous and afterwards N samples.
%
%   Example:
%      t = 2*pi*linspace(-1,1); 
%      xn = cos(x) + 0.25 - 0.5*rand(size(x)); 
%      xs = mvaveragec(xn,4);
%      plot(t,xn,t,xs), legend('noisy','smooth'), axis tight
%
%   See also MVAVERAGE2 and MVAVERAGEC

%   by Yi Cao
%   Cranfield University
%   11-09-2007
%   y.cao@cranfield.ac.uk
%

y0=filter(ones(1,2*N+1)/(2*N+1),1,x);
y=x;
y(N+1:end-N)=y0(2*N+1:end);