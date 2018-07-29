% MCMCSUMM - Summary Statistics 
% Copyright (c) 1998, Harvard University. Full copyright in the file Copyright
%
%   [S] = mcmcsumm(A) 
%
% A = r x c x s array of s samples of an r x c matrix of parameters
%
% S = structure containing returned values (mean, median, etc.)
%   select components with S.mean, S.median, etc.
%
% Note: all summary statistics are marginal, there are no multivariate
%   summaries at this time.
%
% These routines use the last dimension of an array as the
% sample index.  So an array with dimension (nr,nc,ns) 
% will be a collection of ns samples of an nr by nc matrix of 
% parameters.  An array with dimension (nr,nc) will
% be nc samples of an nr-vector of parameters.
% When the summary statistics are calculated, the last dimension
% is dropped.  
% 
% See also: MCMCTRACE, MCMCLT
%

function [S] = mcmcsumm(A) 

if isnan(A),
 S.mean = NaN;
 S.min = NaN;
 S.max = NaN;
 S.std = NaN;
 S.sorted = NaN;
 S.median = NaN;
 S.meanvec = NaN;
 S.cov = NaN;
 S.acf= NaN;
 S.acf10max = NaN;
 S.acf10med = NaN;
 S.gr2 = NaN ;
 S.gr2max = NaN ;
else

dd = size(A) ;
ll = length(dd) ;
if (ll==2),
  aa = reshape(A, [dd(1),1,dd(2)]) ;
else
  aa = A ;
end

[nr,nc,ns] = size(aa) ;

maxlag = min(100,ns-1) ;

Z = zeros(nr,nc,ns) ;
S = struct('mean',Z) ;

S.mean = mean(aa,3) ;
S.min = min(aa,[],3) ;
S.max = max(aa,[],3) ;
S.std = std(aa,0,3) ;
S.sorted = NaN*zeros(nr,nc,ns) ;
S.median = NaN*zeros(nr,nc) ;

tmpvec = reshape(S.mean, nr*nc, 1) ;
sel = ~isnan(tmpvec) ;
S.meanvec = tmpvec(sel,:) ;

aavec = reshape(aa, nr*nc, ns) ;
aavec = aavec(sel,:) ;

if nr>0 & nc>0 & ns>0,  
% then there's something to work with

S.cov = cov(aavec') ;

for ir = 1:nr,
for ic = 1:nc,
  xx = reshape(aa(ir,ic,:),1,ns) ;
  S.sorted(ir,ic,:) = sort(xx) ;
  S.median(ir,ic) = median(xx) ;
  xx0 = xx - mean(xx) ;
  if S.max(ir,ic)-S.min(ir,ic) < .0000000001,
    xc = NaN * zeros(1,2*maxlag+1) ;
  else
    xc = xcorr(xx0,xx0,maxlag,'coeff'); 
  end 
  S.acf(ir,ic,:) = [xc(maxlag+(1:(maxlag+1)))] ;
  S.acf1 = S.acf(:,:,2) ;
end 
end 

if ns>10,
  S.acf10 = S.acf(:,:,11) ;
  tmpacf = reshape(S.acf10,1,nr*nc) ;
  if any(~isnan(tmpacf)),
    tmpacf = tmpacf(~isnan(tmpacf)) ;
    S.acf10max = max(max( tmpacf )) ;
    S.acf10med = median(median( tmpacf )) ;
  else
    S.acf10max = NaN ;
    S.acf10med = NaN ;
  end
else
  S.acf10 = NaN*S.acf(:,:,1) ;
  S.acf10max = NaN ;
  S.acf10med = NaN ;
end

else 
  % one of nr nc ns == 0
  S.sorted(:,:,:) = A ;
  S.median = A(:,:,1) ;
  S.acf10max = NaN ;
  S.acf10med = NaN ;
  S.acf = NaN * zeros(nr,nc,maxlag+1) ;
  S.acf1 = S.acf(:,:,2) ;
  S.acf10 = S.acf(:,:,11) ;
  S.cov = A(:,:,1) ;
end

S.gr2 = mcmcgr(A,2) ;
S.gr2max = max(max(S.gr2)) ;

end
% end of NaN branch
