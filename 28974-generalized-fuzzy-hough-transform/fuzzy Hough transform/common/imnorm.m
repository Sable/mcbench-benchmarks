function nI = imnorm(I, dr)
%
% IMNORM normalizes the input image in the range [odr(1) odr(2)]

mn = min(I(:));
mx = max(I(:));
idr = double(mx - mn);          % input dynamic range
odr = double(dr(2) - dr(1));	% output dynamic range
nIu = double(I - mn)./idr;
nI = odr * nIu + dr(1);

