function [pcsel, R0, logres, cic, pc, psel, fsic] = ARselv(x,Lmax,M,settings)

%ARselv Parameter estimation and order selection for vector AR models.
%   [pcsel,R0] = ARselv(x,Lmax) does vector AR time series analysis on the signal
%   X. ARSELV contains three steps:
%   1) Subtraction of the estimated mean value
%   2) Paramater estimation
%   3) Order selection.
%
%   Parameter estimation is done with the Burg algorithm for vectors
%   (= Nuttall-Strand). Order selection is done using the Combined Information
%   Criterion CIC. The result is given in terms of the partial correlations
%   PCSEL and the covariance matrix of the signal R0.
%
%   [PCSEL,RO] = ARSELV(X,LMAX,M):  M contains the linear mapping of X
%   that is to be predicted accurately based on previous observations of x.
%   This only influences the order selection.
%
%   [pcsel, R0, logres, cic, pc, psel, fsic] = ARselv(x,Lmax,M,'NoMean') 
%   LOGRES : logarithm of residual for model orders 0,...,LMAX;
%   CIC    : CIC for model orders for model orders 0,...,LMAX;
%   PC     : All partial correlations;
%   PSEL   : selected model order;
%   FSIC   : Finite Sample Information Criterion.
%
%   'Nomean' : The mean is not subtracted if this option is added.
%
%   See also: VECTORS,SIG2MAT, BURGV, PC2COVV, PC2PARV, PC2SPECV.

%S.de Waele, May 2001.

%Process settings
nomean = 0;
if exist('settings'),
	if strcmp(lower(settings),'nomean')
	   nomean = 1;
	end
end

nobs = kingsize(x,3);
dim = kingsize(x,1);
if nargin<3 | isempty(M),
   M = eye(dim);
   if nargin<2
      Lmax = nobs/dim/2;
   end
end

if ~nomean,
   %Subtraction of the mean:
	xs = mat2sig(x);
	xs = xs-ones(nobs,1)*mean(xs);
	x = sig2mat(xs);
end
[pc R0] = burgv(x,Lmax);

dimY = size(M,1);
Pf = pc2resv(pc,R0);
PfM = zeros(dimY,dimY,Lmax+1);
for t = 1:Lmax+1
	PfM(:,:,t) = M*Pf(:,:,t)*M';
end
logres = log(dets(PfM)');

L = 0:Lmax;
v = 1./(nobs-dim*L+1); v(1) = 0;
prodvi= cumprod((1+dim*v)./(1-dim*v));
fsic = nobs*logres+nobs*dimY*(prodvi-1);
cic = fsic + L;

[cicmin i] = min(cic);
psel = i-1;

pcsel = pc(:,:,1:psel+1);