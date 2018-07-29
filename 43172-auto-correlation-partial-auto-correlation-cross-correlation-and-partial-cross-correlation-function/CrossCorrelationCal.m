function [Crs] = CrossCorrelationCal(Cause,Effect,LagMax)
Cause=Cause(:);
Effect=Effect(:);

Crs=zeros(LagMax,1);

for i=1:LagMax
    a=Cause(1:end-i);
    b=Effect(1+i:end);
Crs(i)=CorrelationCoefficientCal(a,b);
end

end

