function cov = spec2covv(h)

%function cov = spec2covv(h)
% Transforms a spectrum h into a covariance function cov 

%S. de Waele, March 2003.

s = kingsize(h);
nspec = s(3);
dim = s(1); I = eye(dim);
hs = zeros(dim,dim,2*nspec-1);
hs(:,:,1:nspec) = h; 
hs(:,:,nspec+1:end) = conj(fliptime(h(:,:,2:end)));
cov = real(ifftv(hs));
cov = cov(:,:,1:nspec);
