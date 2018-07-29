function scores = kse_test(x)
% Compute the outlier score for each p-dimensional data point
% The highest scores are possible outliers, scores between [0,1]
% Original scoring algorithm by Michael S Kim (mikeskim@gmail.com)
% Version 1.00 (12/22/2012) for Matlab ported from R
% not fully tested on Matlab, tested on GNU Octave and R
warning('off','all');
[nrows, dcols] = size(x);
scores = zeros(nrows,1);
nsample = ceil( nrows*0.95);
 if (nsample > 300)
  nsample = 300;
 end

for i = 1:nrows
 %#sample points to build dpop
 tmp1 = randperm(nrows); tmp1 = tmp1(1:nsample); dpop = x(tmp1, : );
 distSample0 = zeros(nsample,1);
 
 for j = 1:nsample %#build distances from point i to sampled points
  distSample0(j,1) = sqrt(sum((dpop(j,:) - x(i,:)).^2)); 
 end

 tmp2 = randperm(nrows); tmp2 = tmp2(1:nsample); bpop = x(tmp2, : ); 
 for k = 1:nsample  %#build distances from bpop k to sampled points dpop
  distSampleTemp = zeros(nsample,1); 
   for j = 1:nsample
    distSampleTemp(j,1) = sqrt(sum(( dpop(j,:) -  bpop(k,:)).^2));
   end
  [pval, ks, d] = kstest2(distSample0,distSampleTemp);
  scores(i,1) = scores(i,1) + d/nsample;
 end
 
end
warning('on','all');
end %#endfunction
