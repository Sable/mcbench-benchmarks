%
% xh = nhilbert(x,n,dim)
%
% NHILBERT computes the <n>-point hilbert transform <xh> of a real,
%   N-dimensional array <x> along dimension <dim>.
%
%   x: array to be transformed
%   n: x is padded or truncated (see FFT) to have <n> points along dim.
% dim: dimension along which x is transformed, default first nonsingleton
%
% See also HILBERT, FFT, IFFT.

% Based on HILBERT.M
% Copyright 1988-2004 The MathWorks, Inc.
% Modified by Bill Winter December 2005
function x = nhilbert(x,n,dim)
siz = size(x);
if nargin < 3, dim = find(siz > 1,1); end
if nargin < 2 || isempty(n), n = siz(dim); end
in(1:length(siz)) = {':'};              % define index
x = fft(real(x),n,dim);                 % n-point fft along dim
in{dim} = 2:floor((n+1)/2);             %       DC < f < Nyquist: x2
x(in{:}) = 2*x(in{:});
in{dim} = ceil((n+1)/2)+1:n;            %            f > Nyquist: x0
% in{dim} = [1 ceil(n/2)+1:n];          % f == DC | f >= Nyquist: x0
x(in{:}) = 0;
x = ifft(x,[],dim);                     % n-point ifft along dim