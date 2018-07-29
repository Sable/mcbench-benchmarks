function [ PACF ] = PartialAutoCorrelationF( InputSeries,m,Lag )
% This Program is written by S.Adel Alavi Fazel, 2013/Aug/20
% The assuption is that series is second-order Stationary
% PACF is the Partial Autocorrealtion Coefficient
% Input Series is self-explanatory.  
% m is number of coefficient to be computed
% If intermidiate steps are not available (for multiple steps ahead
% forecasts, set Lag to that number. Most commonly it is set to '1'
PACF=zeros(m,1);
PACF(1)=CorrelationCoefficientCal(InputSeries(1:end-Lag),InputSeries(Lag+1:end));
for i=2:length(PACF) 
X1=InputSeries(1:end-i-Lag)';
X2=InputSeries(i+1+Lag:end)'; 
A=[]; 
for j=1+Lag:i+Lag
    A=[InputSeries(j:end-(i-j+Lag+1))' A]; 
end
 X=X1-A*(A\X1);
 Y=X2-A*(A\X2);

    PACF(i)=CorrelationCoefficientCal(X,Y);
end



end