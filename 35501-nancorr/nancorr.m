function C = nancorr( X,Y )
% NANCORR calculates the sample correlation coefficient
%    for the series with NaNs expected.
%    X is the one series, Y is another.
X=X(:);
Y=Y(:);
L1=length(X);
L2=length(Y);

if L1 ~= L2
    error('The samples must be of the same length')
end

for i=1:L1,
    if isnan(X(i)),
        Y(i)=nan;
    end
    if isnan(Y(i)),
        X(i)=nan;
    end
end
        
Xm=nanmean(X);
Ym=nanmean(Y);
C=nansum((X-Xm).*(Y-Ym))/sqrt((nansum((X-Xm).^2))*(nansum((Y-Ym).^2)));
end