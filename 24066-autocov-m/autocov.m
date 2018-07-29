function acv= autocov(x,maxlag)
%
% autocov computes the sample autocovariance of a time series x for lags
% from 0 to maxlag, returning a column vector of length maxlag+1.  x must
% be a column vector having length m not less than maxlag+1.  If no value
% is supplied for maxlag, the default is the minimum of m-1 and 100.
%
% Dr. Phillip M. Feldman
% Last update 21 June 2008
%
% Based on equations on p. 19 of "Introduction to Time Series and
% Forecasting" 2nd Edition by Brockwell and Davis.


% Section 1: Check input arguments and supply default value for maxlag
% if needed.

if nargin < 1, error('Missing input vector.'); end

[m n]= size(x);
if (n ~= 1)
   error('x must be a column vector.')
end
if (m <= maxlag)
   error('The length of the input vector x must be at least maxlag+1.');
end

if nargin < 2, maxlag= min(m-1,100); end


% Section 2: Compute autocovariance.

% Remove mean from x:
x= x - mean(x);

% For faster running time, we pre-allocate the output array:
acv= zeros(maxlag+1,1);

% Compute autocovariance:
for h= 0 : maxlag
   % Take matrix product of row vector and column vector to obtain a
   % scalar.  The row vector contains the first n-h elements of x; the
   % column vector contains the last n-h elements of x.
   acv(h+1)= x(1:m-h)' * x(1+h:m);
end

acv= acv / m;
