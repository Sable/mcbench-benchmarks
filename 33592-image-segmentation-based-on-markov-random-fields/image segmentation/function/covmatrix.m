function [C,m]=covmatrix(X)
[K,n]=size(X);
X=double(X);
if K==1
    C=0;
    m=X;
else
    m=sum(X,1)/K;
    X=X-m(ones(K,1),:);
    C=(X'*X)/(K-1);
    m=m';
end
end