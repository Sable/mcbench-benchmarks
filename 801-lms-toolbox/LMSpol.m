function [LMSout,blms,Rsq]=LMSpol(y,p,x)
%Syntax: [LMSout,blms,Rsq]=LMSpol(y,p,x)
%_______________________________________
%
% Calculates the Least Median of Squares (LMS) polynomial regression
% parameters and output. It searches all the possible combinations
% of points and makes the intercept adjustment for every combination.
%
% LMSout is the LMS estimated values vector.
% blms is the LMS [intercept slopes] vector.
% Rsq is the R-squared.
% y is the vector of the dependent variable.
% p is the order of the polynomial.
% x is the vector of the independent variable.
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

if nargin<1 | isempty(y)==1
   error('Not enough input arguments.');
else
   % y must be a column vector
   y=y(:);
   % n is the length of the data set
   n=length(y);
end

if nargin<2 | isempty(p)==1
   % If p is omitted give it the value of 1
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

if nargin<3 | isempty(x)==1
   % If x is omitted give it the values 1:n
   x=(1:n)';
else
   % x must be a column vector
   x=x(:);
   % x and y must have the same length
   if n~=size(x,1)
      error('x and y must have the same length.');
   end
end

if n<=p
   error('The ploynomial order is too large for the data set.');
end

% Prepare the matrix X for regression.
for i=1:p
   X(:,i)=x.^i;
end

% Perform the LMS regression
[LMSout, blms, Rsq]=LMSreg(y,X);
