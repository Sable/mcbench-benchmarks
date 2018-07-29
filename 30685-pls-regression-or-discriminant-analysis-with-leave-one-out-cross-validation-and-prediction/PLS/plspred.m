function pls_pred = plspred(x,model,y)
%
% Variables or classes prediction using PLS model
%
% pls_pred = plspred(x,model,y)
%
% input:
% x (samples x descriptors)	new samples for prediction
% model (struct)            with PLS calibration parameters
% y (samples x variables)   for regression or
%   (samples x classes)     for discriminant analysis. Classes numbers must be >0. (optional for model test)
%
% output:
% pls_pred struct with:
%   Yp (samples x variables)	predicted variables or 
%      (samples x classes)      predicted classes for new samples
%   Tp (samples x vl)           x-scores for new samples
%
%   For PLS-R:
%   RMSEp (1 x variavles)       Root Mean Square Error for prediction (only if 'y' is supplied)
%   R2p (1 x variavles)         Correlation Coefficient for prediction (only if 'y' is supplied)
%
%   For PLS-DA:
%   Sucp (1 x 1)                Success (%) of classification for prediction (only if 'y' is supplied)
%
% See also pls, plscv
%
% By Cleiton A. Nunes
% UFLA,MG,Brazil



B=[model.B0;model.B];
W=model.W;

yp=[ones(size(x,1),1) x]*B;

if  model.Data.PLStype=='da';
    [d,nc]=min(abs(yp-1),[],2);
    nnc=nc;
    sc=size(yp,1);
    u=model.Data.class;
    t=size(u,1);
    for i=1:sc
        for j=1:t
            if nc(i)==j
            nnc(i)=u(j);
            end
        end
    end
yp=nnc;
end

Tp=x*W;

pls_pred.Yp=yp;
pls_pred.Tp=Tp;

if nargin==3
yo=y;
[s,v]=size(yp);
rmsep=zeros(1,v);
Rc=zeros(1,v);
nv=1:v;
    for inv=1:length(nv)
        if model.Data.PLStype=='da';
        suc(1,inv)=(size(yo(:,inv),1)-size(nonzeros(yo(:,inv)-yp(:,inv)),1))/size(yo(:,inv),1)*100;
        else
        rmsep(1,inv)=sqrt(sum((yp(:,inv)-yo(:,inv)).^2)/size(yo(:,inv),1));
        Rp(1,inv)=abs(nonzeros(diag((corrcoef(yp(:,inv),yo(:,inv))),1)));
        end
    end
    
if model.Data.PLStype=='da';
pls_pred.Sucp=suc;
else
pls_pred.RMSEp=rmsep;
pls_pred.R2p=Rp.^2;
end
end