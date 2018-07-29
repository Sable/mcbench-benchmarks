function [PACF] = PartialCrossCorrelationCal(Cause,Effect,Lag,LagMax)
Cause=Cause(:)';
Effect=Effect(:)';
PACF=zeros(LagMax,1);
PACF(1)=CorrelationCoefficientCal(Cause(1:end-Lag),Effect);

for i=2:LagMax
    
X1=Cause(1:end-i-Lag)';
X2=Effect(i+1+Lag:end)'; 
A=[];  
for j=2+Lag:i+Lag 
    A=[Cause(j:end-(i-j+Lag+1))' A]; 
end
 X=X1-A*(A\X1);
 Y=X2-A*(A\X2);
    PACF(i)=CorrelationCoefficientCal(Y,X);

end

end

