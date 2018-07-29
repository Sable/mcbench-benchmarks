function [me, me_set, Peta_set, Peta_b_set] = moderrv(pchat,R0hat,pc,R0,nobs,M)

%moderrv Vector Model Error for AR models.
%   ME = moderrv(PCHAT,ROHAT,PC,R0,NOBS) calculates the model error ME for
%   vector AR models with respect to vector AR processes. The model error is
%   given by:
%
%   ME = nobs*.5*(trace((Peta-Peps)*inv(Peps))+trace((Peta_b-Peps_b)*inv(Peps_b))
%
%   where Peta is the prediction error matrix of the model and Peps is the 
%   minimal prediction error matrix calculated from the process paramaters.
%   Peta_b and Peps_b are the matrices for backward prediction.
%
%   ME = moderrv(PCHAT,ROHAT,PC,R0,NOBS,M) calculates the model error where
%   y=M*x is predicted instead of x.
%
%   [ME, ME_SET] = moderrv(PCHAT,ROHAT,PC,R0,NOBS) also calculates the model
%   error for the best AR(1),...,AR(p) models of the AR model PCHAT,R0. This call
%   also allows the use of the matrix M, as above. Similarly, a set of prediction
%   error covariance matrices can be obtained with
%   [ME, ME_SET, PETA_SET, PETA_B_SET] = moderrv(PCHAT,ROHAT,PC,R0,NOBS).
%   
%   See also MODERR, KULLBLEIB.

%S. de Waele, April 2001.

if ~isstatv(pc), error('Partial correlations non-stationairy!'), end
if ~isstatv(pchat), error('Estimated partial correlations non-stationairy!'), end
s = kingsize(pc);
order = s(3)-1;
dim = s(1); I = eye(dim);
orderhat = kingsize(pchat,3)-1;

if ~exist('M'), M=I; end
dimY = size(M,1);

if nargout > 1,
   req_order = 0:orderhat;
else
   req_order = orderhat;
end
[parhat_set parbhat_set] = pc2arset(pchat,R0hat,req_order);
max_p = max(req_order);

%Calculate minimal PE and true covariance function
[Pf,Pb] = pc2resv(pc,R0);
Peps  = M*Pf(:,:,end)*M';
Peps_b= M*Pb(:,:,end)*M';

cov = pc2covv(pc,R0,max_p);
covsm = zeros(dim,dim,2*max_p+1);
covsm(:,:,1:max_p)     = transposeLTI(cov(:,:,2:end));
covsm(:,:,max_p+1:end) = cov;

%npchat = length(re); %max_p;
no = length(req_order);
me_set =zeros(1,no);
Peta_set   = zeros(dimY,dimY,no);
Peta_b_set = zeros(dimY,dimY,no);

for count = 1:no
    parhat = parhat_set{count};
    parbhat= parbhat_set{count};
    orderhat = kingsize(parhat,3)-1;
    covs = covsm(:,:,1+(max_p-orderhat):end-(max_p-orderhat));
    
    %Forward prediction
    covresf = convv(parhat,convv(covs,transposeLTI(parhat)));
    Pf = covresf(:,:,2*orderhat+1);
    Peta = M*Pf*M';
    Peta_set(:,:,count) = Peta;
    
    %Backward prediction
    covsb = flipdim(covs,3);
    covresb = convv(parbhat,convv(covsb,transposeLTI(parbhat)));
    Pb = covresb(:,:,2*orderhat+1);
    Peta_b = M*Pb*M';
    Peta_b_set(:,:,count) = Peta_b;
    
    me_set(count) = nobs*.5*(trace((Peta-Peps)*inv(Peps))+trace((Peta_b-Peps_b)*inv(Peps_b)));
    
end
me = me_set(end);
if ~nargout,
    clear me_set Peta_set Peta_b_set
end
