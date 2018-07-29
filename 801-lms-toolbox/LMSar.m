function [LMSout,blms,Rsq]=LMSar(x,p)
%Syntax: [LMSout,blms,Rsq]=LMSar(x,p)
%_____________________________________
%
% Calculates the Least Median of Squares (LMS) autoregressive model
% of order p. 
%
% LMSout is the LMS estimated values vector.
% blms is the AR LMS [intercept slopes] vector.
% Rsq is the R-squared.
% x is the time series.
% p is the odrer of AR.
%
% Reference:
% Rousseeuw PJ, Leroy AM (1987): Robust regression and outlier detection. Wiley.
%
%
% Alexandros Leontitsis
% Institute of Mathematics and Statistics
% University of Kent at Canterbury
% Canterbury
% Kent, CT2 7NF
% U.K.
%
% University e-mail: al10@ukc.ac.uk (until December 2002)
% Lifetime e-mail: leoaleq@yahoo.com
% Homepage: http://www.geocities.com/CapeCanaveral/Lab/1421
%
% Sep 3, 2001.

if nargin<1 | isempty(x)==1
   error('Not enough input arguments.');
else
   % x must be a vector
   if min(size(x))>1
      error('Invalid time series x.');
   end
end

if nargin<2 | isempty(p)
   % If p is omitted give it takes the value of 1
   p=1;
else
   % p must be a scalar
   if sum(size(p))>2
      error('p must be a scalar.');
   end
   % p must be a non-negative integrer
   if round(p)-p~=0 | p<0
      error('p must be a non-negative integrer');
   end
end

n=length(x);
if n<=2*p
   error('The time series length is too small for the given p.');
end

% Prepare the time series for LMS regression
for i=1:n-p
   X(i,:)=x(i:i+p-1)';
   y(i)=x(i+p);
end

% Perform the LMS regression
[LMSout,blms,Rsq]=LMSreg(y,X);
