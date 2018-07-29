function y = winconv(x,varargin)
%WINCONV   Discrere time convolution of a sequence with a window.
%   y = WINCONV(X) convolves the sequence X with a rectangular window. The
%   length of the window is same as that of X.
%
%   y = WINCONV(X,WINTYPE) convolves the sequence X with the window
%   specified by WINTYPE. WINTYPE can be either 'rect', or 'hamming', or
%   'hanning', or 'bartlett', or 'blackman'. The length of the window is 
%   same as that of X.
%
%   y = WINCONV(X,WINTYPE,WINAMP) convolves the sequence X with the window
%   specified by WINTYPE. The amplitude of the window is set by WINAMP. So
%   WINAMP must be a real number/vector. The length of the window is same 
%   as that of X. WINAMP could be a real constant or a vector with WINLEN 
%   elements.
%   
%   y = WINCONV(X,WINTYPE,WINAMP,WINLEN) convolves the sequence X with the
%   window specified by WINTYPE having amplitude WINAMP and length WINLEN.
%
%   See also CONV, FFT, RECTWIN, HAMMING, HANNING, BARTLETT, BLACKMAN.
%
%   Author: Nabin Sharma
%   Date: 2009/03/15

error(nargchk(1,4,nargin,'struct'));

len = length(varargin);
switch len
    case 0
        wintype = 'rectwin';
        A = 1;
        L = length(x);
    case 1
        if ischar(varargin{1})
            wintype = lower(varargin{1});
            A = 1;
            L = length(x);
        end
    case 2
        if ischar(varargin{1}) && isreal(varargin{2})
            wintype = lower(varargin{1});
            A = varargin{2};
            L = length(x);
        end
    case 3
        if ischar(varargin{1}) && isreal(varargin{2}) &&...
                isreal(varargin{3})
            wintype = lower(varargin{1});
            A = varargin{2};
            L = varargin{3};
        end
end

% generate the window
w1 = (window(str2func(wintype),L)).'; A = A(:).';
w = A.*w1;

% perform the convolution using FFT
NFFT = 2^(nextpow2(length(x)+L));
X = fft(x,NFFT); W = fft(w,NFFT);
Y = X.*W;
y = ifft(Y,NFFT);
    