function cov = pc2covv(pc,R0,ncov)

%function cov = pc2covv(pc,R0,ncov)
%   Transforms partial correlations pc into a covariancefunction cov
%   ncov is the number of covariances
%   For a zero-mean process, the covariance function has been defined as
%   R(s)(.) = E{X[n+s]<X[n],.>},
%   or, in old-fashioned notation:
%   R(s) = E{X[n+s]X[n]'} where X[n] is a column vector.

%S. de Waele, March 2003.

if ~isstatv(pc), error('Partial correlations non-stationairy!'), end

s = kingsize(pc);
order = s(3)-1;
dim = s(1); I = eye(dim);

if nargin <  3, ncov = order; end

m = min(order,ncov);

par = zeros(dim,dim,m+1);
parb = zeros(dim,dim,m+1);
cov = zeros(dim,dim,ncov+1);

[rc,rcb,Pf,Pb] = pc2rcv(pc(:,:,1:m+1),R0);

cov(:,:,1) = R0; 
par(:,:,1) = I;  
parb(:,:,1)= I;  
if m,
	cov(:,:,2) = -rc(:,:,2)*R0;
	par(:,:,2) = rc(:,:,2);
	parb(:,:,2)= rcb(:,:,2);
	par_o  = par;
	parb_o = parb;
end

for p = 2:m,
   
   par(:,:,2:p) = par_o(:,:,2:p) +flipdim(timesv(rc(:,:,p+1),parb_o(:,:,2:p)),3);
   par(:,:,p+1) = rc(:,:,p+1);
   
   parb(:,:,2:p)= parb_o(:,:,2:p)+flipdim(timesv(rcb(:,:,p+1) ,par_o(:,:,2:p)),3);
   parb(:,:,p+1)= rcb(:,:,p+1);
   
   cov(:,:,p+1) = -prodsumv(par(:,:,2:p+1),cov(:,:,p:-1:1));
   
   par_o  = par;
   parb_o = parb;
end %for p = 2:m,
if ncov > order,
	cov(:,:,order+2:end) = armafilterv(zeros(dim,dim,ncov-order),par,I,cov(:,:,2:order+1));   
end
