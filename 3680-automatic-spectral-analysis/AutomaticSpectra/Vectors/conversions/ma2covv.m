function cov = ma2covv(ma,Peps,ncov)

%function cov = ma2covv(ma,Peps,ncov)
%   Transforms Moving Average parameters MA into a covariancefunction cov
%   ncov is the number of covariances
%   For a zero-mean process, the covariance function has been defined as
%   R(s)(.) = E{X[n+s]<X[n],.>},
%   or, in old-fashioned notation:
%   R(s) = E{X[n+s]X[n]'} where X[n] is a column vector.

%S. de Waele, March 2003.


s = kingsize(ma);
order = s(3)-1;
dim = s(1); I = eye(dim);

if nargin <  3, ncov = order; end
Peps_mapl = timesv(Peps,transposeLTI(ma)); % = Peps*MA'
cov = convv(ma,Peps_mapl);                 % = MA*Peps*MA'
cov = cov(:,:,1+order:end);
%Create covariance function with proper length
if ncov>order
   cov = cat(3,cov,zeros(dim,dim,ncov-order));
end
if ncov<order
	cov = cov(:,:,1+order);   
end