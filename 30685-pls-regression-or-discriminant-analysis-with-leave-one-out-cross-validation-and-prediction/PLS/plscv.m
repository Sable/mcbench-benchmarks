function pls_cv = plscv(x,y,vl,da)
%
% Leave-one-out cross-validation for PLS regression or discriminant analysis
%
% pls_cv = plscv(x,y,vl,'da')
%
% input:
% x (samples x descriptors)	for cross-validation
% y (samples x variables)	for regression or
%   (samples x classes)     for discriminant analysis. Classes numbers must be >0.
% vl (1 x 1)                number of latent variables to compute in cross-validation
% 'da' (char)               to indicate PLS-discriminant analysis (in PLS regression it is no used)
%
% output:
% pls_cv struct with:
%   Ypcv (samples x variables x vl)	predicted variables or
%        (samples x classes x vl)	predicted classes for cross-validation
%   Tcv (samples x vl)              x-scores for cross-validation samples
%
%   For PLS-R:
%   RMSEcv (variables x vl)         Root Mean Square Error for cross-validation
%   R2cv (variables x vl)           Correlation Coefficient for cross-validation
%
%   For PLS-DA:
%   Succv (1 x vl)                  Success (%) of classification for cross-validation

% See also pls, plspred
%
% By Cleiton A. Nunes
% UFLA,MG,Brazil

yo=y;

if nargin==4
    
    if size(da,2)~=2
    error('%s is no valid',da)
    elseif sum(da~='da')>0
    error('%s is no valid',da)
    elseif size(y,2)~=1
    error('y class is no valid')

    else
    u=unique(y);
    t=size(u,1);
    sc=size(y,1);
    yc=zeros(sc,t);
        for i=1:sc
            for j=1:t
                if y(i)==u(j)
                yc(i,j)=1;
                end
            end
        end
y=yc;

    end

end
%---------------------------

[l,c]=size(x);
[l,v]=size(y);

ypcv=zeros(l,v,vl);
wcv=zeros(l,vl,vl);

vl=1:vl;
nam=1:l;
nv=1:v;

for ivl=1:length(vl)
    for inam=1:length(nam)
        xc=x;
        xv=x(inam,:);
        xc(inam,:)=[];
        
        yc=y;
        xv=x(inam,:);
        yc(inam,:)=[];
        
        [T,P,U,Q,W,B,var_LV]=plsr(xc,yc,ivl);
        ypcv(inam,:,ivl)=[ones(size(xv,1),1) xv]*B;
        
        if nargin==4
        [d,nc]=min(abs(ypcv-1),[],2);
        nnc=nc;
            for i=1:sc
                for j=1:t
                    if nc(i)==j
                    nnc(i)=u(j);
                    end
                end
            end
        ypcv2=nnc;
        
        end
wcv(inam,1:ivl,ivl)=xv*W;
    
    end
    
        
nvyo=size(yo,2);        
    for inv=1:nvyo
        if nargin==4
        rmsecv(inv,ivl)=sqrt(sum((ypcv2(:,inv,ivl)-yo(:,inv)).^2)/size(yo(:,inv),1));
        Rcv(inv,ivl)=abs(nonzeros(diag((corrcoef(ypcv2(:,inv,ivl),yo(:,inv))),1)));
        suc(inv,ivl)=(size(yo(:,inv),1)-size(nonzeros(yo(:,inv)-ypcv2(:,inv,ivl)),1))/size(yo(:,inv),1)*100;
        else
        rmsecv(inv,ivl)=sqrt(sum((ypcv(:,inv,ivl)-yo(:,inv)).^2)/size(yo(:,inv),1));
        Rcv(inv,ivl)=abs(nonzeros(diag((corrcoef(ypcv(:,inv,ivl),yo(:,inv))),1)));
        end
        if isnan(Rcv(inv,ivl))==1
            Rcv(inv,ivl)=0;
        end
    end
end 

if nargin==4
pls_cv.Ycv=permute(ypcv2,[1 3 2]);
pls_cv.Succv=suc;
else
pls_cv.Ycv=permute(ypcv,[1 3 2]);
pls_cv.RMSEcv=rmsecv;
pls_cv.R2cv=Rcv.^2;
end
pls_cv.Tcv=wcv(:,:,max(vl));


%---plsr---
function [T,P,U,Q,W,B,var_LV] = plsr(x,y,lv)

[n,m]=size(x);
[l,k]=size(y);
P=zeros(m,lv);
Q=zeros(k,lv);
T=zeros(n,lv);
U=zeros(n,lv);
W=zeros(m,lv);
V=zeros(m,lv);
cv=x'*y;

for i=1:lv
    [ai,bi,ci]=svd(cv,'econ');
    ai=ai(:,1);
    ci=ci(:,1);
    bi=bi(1);
    ti=x*ai;
    normti=norm(ti);
    ti=ti./normti;
    P(:,i)=x'*ti;
    qi=bi*ci/normti;
    Q(:,i)=qi;
    T(:,i)=ti;
    U(:,i)=y*qi;
    W(:,i)=ai./normti;
    vi=P(:,i);
    
    for repeat=1:2
        for j=1:i-1
            vj=V(:,j);
            vi=vi-(vi'*vj)*vj;
        end
    end
    
    vi=vi./norm(vi);
    V(:,i)=vi;
    cv=cv-vi*(vi'*cv);
    Vi=V(:,1:i);
    cv=cv-Vi*(Vi'*cv);
end

for i=1:lv
    ui=U(:,i);
    for repeat=1:2
        for j=1:i-1
           tj=T(:,j);
           ui=ui-(ui'*tj)*tj;
        end
    end
    U(:,i)=ui;
end

B=W*Q';
B=[(mean(y,1))-(mean(x,1))*B;B];
    
var_LV=[sum(P.^2,1)./sum(sum(x.^2,1));sum(Q.^2,1)./sum(sum(y.^2,1))];
var_LV=cumsum(((var_LV*100)'),1);
