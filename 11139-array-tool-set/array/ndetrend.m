%
% y = ndetrend(x,dim,type,breaks)
%
% NDETREND removes a trend from an N-dimensional array <x> along a given
% dimension <dim>.
%
%       x: array to be detrended
%     dim: dimension along which to detrend, default is first nonsingleton
%    type: linear detrend (1) or demean (0), default is linear.
%  breaks: breakpoint indices for a piecewise linear trend
%
% See also DETREND, MEAN

%   Based on DETREND.M
%   Copyright 1984-2004 The MathWorks, Inc.
%   Modified by Bill Winter May 2006
function x = ndetrend(x,dim,o,b)
siz = size(x);                                      % array size
if nargin < 2, dim = find(siz > 1,1); end           % default: nonsingleton
N = siz(dim);                                       % dimension length
a = ones(N,1);                                      % constant
if nargin < 3 || o                                  % default: linear
    if nargin < 4, b = []; end                      % default: no breaks
    b = unique([1;b(:)]);                           % breaks unique
    b(b < 1 | b > N-1) = [];                        % breaks within array
    l = length(b);                                  % number linear pieces
    a = [zeros(N,l) a];                             % preallocate linear
    M = N - b;                                      % length of linear piece
    for k = 1:l, a(1+b(k):N,k) = (1:M(k))'/M(k); end% linear pieces
end
if length(siz) > 2
    if dim ~= 1                                     % permute 1 with dim
        per = 1:length(siz);
        per([1 dim]) = [dim 1];
        siz([1 dim]) = siz([dim 1]);
        x = builtin('permute',x,per);
    end
    for k = 1:prod(siz(3:end)), x(:,:,k) = x(:,:,k) - a*(a\x(:,:,k));end
    if dim ~= 1, x = builtin('permute',x,per);end   % depermute 1 with dim
elseif dim == 2, x = x - (x/a')*a';                 % right-regress
elseif dim == 1, x = x - a*(a\x);                   % left-regress
end