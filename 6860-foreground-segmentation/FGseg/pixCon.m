% pixCon:  Return a matrix of pixel connections in an image or video
%
% Note:  The mex-file version runs much faster than the m-file.
%
% Usage:
%   function pc = pixCon(sz,mode)

function pc = pixCon(sz,mode)

npix = prod(sz);
ndim = length(sz);
rd = cumprod([1 sz(1:end-1)]);
d = [-rd rd];
%pc = spdiags(ones(npix,2*ndim),d,npix,npix);
nbr = zeros(npix,2*ndim);
dz = cumprod(sz(1:end-1));
for i = 1:ndim
    dnbr = ones(sz);
    [subs{1:ndim}] = deal(':');
    subs{i} = sz(i);
    subsasgn(dnbr,struct('type','()','subs',{subs}),0);
    nbr(:,i) = dnbr(:);
    dnbr = ones(sz);
    [subs{1:ndim}] = deal(':');
    subs{i} = 1;
    subsasgn(dnbr,struct('type','()','subs',{subs}),0);
    nbr(:,ndim+i) = dnbr(:);
end;
pc = spdiags(nbr,d,npix,npix);
