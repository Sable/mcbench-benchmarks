function zc = zerocross(x,wintype,winamp,winlen)
%ENERGY   Short-time energy computation.
%   y = ZEROCROSS(X,WINTYPE,WINAMP,WINLEN) computes the short-time enery of
%   the sequence X. 
%
%   WINTYPE defines the window type. RECTWIN, HAMMING, HANNING, and
%   BLACKAMN are the possible choices. WINAMP sets the amplitude of the
%   window and the length of the window is WINLEN.
%   
%   See also RECTWIN, HAMMING, HANNING, BARTLETT, BLACKMAN.
%
%   Author: Nabin Sharma
%   Date: 2009/03/15

error(nargchk(1,4,nargin,'struct'));

% generate x[n] and x[n-1]
x1 = x;
x2 = [0, x(1:end-1)];

% generate the first difference
firstDiff = sgn(x1)-sgn(x2);

% magnitude only
absFirstDiff = abs(firstDiff);

% lowpass filtering with window
zc = winconv(absFirstDiff,wintype,winamp,winlen);
