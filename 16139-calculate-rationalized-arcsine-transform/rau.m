function rau_score = rau(p, n)
% RAU Compute rationalized arcsine transform
%
%  Doing linear tests (like ANOVA or t-tests) on proportional data 
%  (values between 0 and 1) is difficult since the distributions of 
%  these values are not strictly Gaussian, especially when the 
%  proportions are near 0 or 1. The Rationalized Arcsine Transform 
%  linearizes the proportions and converts them to "rational arcsine 
%  units". The linear tests can then be performed on the RAU units. 
%  (p=0.5 roughly corresponds to a rau of 50).
%
%  RAU(p) computes the rationalized arcsine transform for a proportion
%  value p (0 <= p <= 1). p can also be a vector of proportion values.
% 
%  RAU(p,n) computes the rau-value assuming that the proportion p
%  was calculated using n values. A small n tends to flatten the 
%  RAU values.
%  
%  Based on: 
%    Studebaker, G. A. (1985). A 'rationalized' arcsine transform. 
%    J. Speech Hearing Res. 28, 455-462.
%
% Example 1:
%   p = 0:0.1:1; plot(100*p, rau(p), 'o-');
%   
% Example 2 (which reproduces Fig 1 in Studebaker, 1985):
%   p = 0:0.01:1; plot(100*p,rau(p)-(100*p));
%
% Gautam Vallabha, Aug-27-2007, Gautam.Vallabha@mathworks.com

if exist('n','var')
   p = p.*n; % convert to frequency count
   t = asin(sqrt(p/(n+1))) + asin(sqrt((p+1)/(n+1)));
else
   t = 2 * asin(sqrt(p));
end

if any(p < 0 | p > 1)
   error('p should be between 0 and 1');
end

% Eq. (7) in Studebaker, 1985
% the advantage of this scaling is that RAU is roughly 
% equal to the percentage score from about 20% to 80%
% and only gets scaled beyond that.

rau_score = (46.47324337*t) - 23;

