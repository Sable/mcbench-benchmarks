function xsig = mat2sig(xmat);
% MAT2SIG From matrix representation to signal representation
%   XSIG = MAT2SIG(X) translates a MATRIX-denoted signal
%   into a SIGNAL-denoted signal.
%
%   The MATRIX-notation of a d-dimensional signal of
%   nobs observations is a dim x 1 x nobs (3-D) matrix.
%
%   The SIGNAL-notation of a dim-dimensional signal of
%   nobs observations is a nobs x dim matrix.
%
%   See also: SIG2MAT, ARSELV, BURGV, ARMAFILTERV.

nobs = size(xmat,3);
dim = size(xmat,1);
xsig=  reshape(xmat,[dim nobs])';