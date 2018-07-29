function [klx, set_klx]= KLDiscrepancyv(varargin)

%KLDiscrepancyv Kullback-Leibner discrepancy and index
%   KLD = KLDiscrepancyv(PCHAT,R0HAT,PC,R0,NOBS) is the exact Kullback-Leibler discrepancy
%   between two vector autoregressive time series models for NOBS observations.
%   The esimated proces PCHAT, R0HAT and the true process PC, R0 are assumed
%   to be normally distributed.
%
%   To calculate the Kullback-Leibler discrepancy or index for processes other than
%   autoregressive processes, calculate the covariance function of your estimate
%   up to shift NOBS-1. Then calculate the first NOBS-1 partial correlations. Use
%   these PC's in KULLBLEIB.
%
%   KLI = KULLBLEIB(PC,R0,NOBS) is the Kullback-Leibler index of the model PC,R0
%   with respect to itself. This option can be used to obtain a residual that can
%   be used in order selection.
%
%   [KLX,SET_KLX] = KULLBLEIB(...) yields a set of KL indices or discrepancies for 
%   increasing model order. This is useful for order selection.
%
%   See also MODERRARV.

if nargin == 3,
 	%Calculate the Kullback-Leibler index of PC,R0 with respect to itself
   pc    = varargin{1};
   R0    = varargin{2};
   nobs  = varargin{3};
end
if nargin == 5,
 	%Calculate the Kullback-Leibler discrepancy of PCHAT,R0 with respect PC,R0
   pchat = varargin{1};
   R0hat = varargin{2};
   pc    = varargin{3};
   R0    = varargin{4};
   nobs  = varargin{5};
end

dim = size(pc,1); I = eye(dim);
p = size(pc,3)-1;
   
if p>nobs-1,
   pc = pc(:,:,1:nobs); %remove spurious pc's in pc
	p = nobs-1;   
end
Pf = pc2resv(pc,R0);

%The KL index kli(f,f) of the a process with respect itself
%for model orders 0:(order AR-model).
%The factor nobs*dim*ln(2*PI) is disregarded
ds = log(dets(Pf));
dsum = cumsum(ds);
for L = 0:p,
	kli_ff(1+L) = dsum(1+L)+(nobs-L-1)*ds(1+L)+nobs*dim;
end
   
if ~exist('pchat')
   klx = kli_ff(end);
   set_klx = kli_ff;
   return
end

%The KL index d(fhat,f) of the estimated process with respect to the true process
%The factor nobs*dim*ln(2*PI) is disregarded
kli_ff = kli_ff(end);

phat = size(pchat,3)-1;
if phat>nobs-1,
   pchat = pchat(:,:,1:nobs); %remove spurious pc's in pchat
   phat = nobs-1;   
end

Pfhat = pc2resv(pchat,R0hat);

%Determinants
ds = log(dets(Pfhat));
dsum = cumsum(ds);

%Traces
trsum = 0;
set_arhat = pc2arset(pchat,R0hat,0:phat);

cov = pc2covv(pc,R0,phat);
covsm = zeros(dim,dim,2*phat+1);
covsm(:,:,1:phat)     = transposeLTI(cov(:,:,2:end));
covsm(:,:,phat+1:end) = cov;
for L=0:phat;
   parhat = set_arhat{1+L};
   covs = covsm(:,:,1+(phat-L):end-(phat-L));
   covresf = convv(parhat,convv(covs,transposeLTI(parhat)));
   Petaf = covresf(:,:,2*L+1);
   trc = trace(Petaf*inv(Pfhat(:,:,1+L)));
	trsum = trsum + trc;
	kli_fhatf(1+L) = dsum(1+L)+trsum+(nobs-L-1)*(ds(1+L)+trc);
end
set_kld = kli_fhatf-kli_ff; %Kullback-Leibler Discrepancy

klx = set_kld(end);
set_klx = set_kld;