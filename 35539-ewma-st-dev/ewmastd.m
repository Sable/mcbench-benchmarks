
function Y=EWMASTD(X,d)


%   Y=EWMASTD(X,d) returns the EWMA (Exponentially Weighted Moving Average)
%   standard deviation using the historical returns in vector X and a decay
%   factor, d.
% % ======================================================================
%
%   Author: Lorenzo Brancali
%   E-mail: lbrancali@gmail.com
%   Date:   20th Febryary 2012
%
% % ======================================================================




t=length(X);

for i=1:length(X)-1
   
    F(i,:)=((d^(i-1))*(X(t-i,:)-mean(X))^2);
    
    
end
   

Y=sqrt((1-d)*sum(F));
 


