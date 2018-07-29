function YW_out = YWoutput(cov,par)

%function YW_out = YWoutput(cov,par)
%
%
%See also: FILTERV.
%

s = kingsize(cov);
dim = s(1);
len = s(3);
I = eye(dim);

covneg = transposeLTI(cov);
covs = zeros(dim,dim,2*len-1);
covs(:,:,1:len-1) = covneg(:,:,1:len-1);
covs(:,:,len:end) = cov;
YW_out = armafilterv(covs,I,par);
YW_out = YW_out(:,:,len:end);
