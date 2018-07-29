function xmat = sig2mat(xsig);
% SIG2MAT From signal representation to matrix representation.
%   X = SIG2MAT(XSIG) translates a SIGNAL-denoted signal
%   into a MATRIX-denoted signal. The MATRIX notation
%   is used by the vector time series analysis toolbox.
%
%   The SIGNAL-notation of a dim-dimensional signal of
%   nobs observations is a nobs x dim matrix.
%
%   The MATRIX-notation of a d-dimensional signal of
%   nobs observations is a dim x 1 x nobs (3-D) matrix.
%
%   See also: MAT2SIG, ARSELV, BURGV, ARMAFILTERV.

%S. de Waele, june 2001.

nobs = size(xsig,1);
dim = size(xsig,2);
xmat = reshape(xsig',[dim 1 nobs]);
