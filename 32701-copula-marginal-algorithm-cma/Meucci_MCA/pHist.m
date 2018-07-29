function [np,x]=pHist(X,p,nBins)

[n,x] = hist(X,nBins);
D=x(2)-x(1);
for s=1:length(x)
    Index= (X>=x(s)-D/2) & (X<=x(s)+D/2) ;
    np(s)=sum(p(Index));
end
