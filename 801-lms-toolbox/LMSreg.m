function [LMSout,blms,Rsq]=LMSreg(y,X)
%Syntax: [LMSout,blms,Rsq]=LMSreg(y,X)
%_____________________________________
%
% Calculates the Least Median of Squares (LMS) simple/multiple
% regression parameters and output. It searches all the possible
% combinations of points and makes the intercept adjustment for
% every combination.
%
% LMSout is the LMS estimated values vector.
% blms is the LMS [intercept slopes] vector.
% Rsq is the R-squared.
% y is the column vector of the dependent variable.
% X is the matrix of the independent variable.
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
   
if nargin<2 | isempty(X)==1
   % if X is omitted give it the values 1:n
   X=(1:n)';
else
   % X must be a 2-dimensional matrix
   if ndims(X)>2
      error('Invalid data set X.');
   end
   if n~=size(X,1)
      error('The rows of X and y must have the same length');
   end
end

% p is the number of parameters to be estimated
p=size(X,2)+1;

% The "half" of the data points
h=floor(n/2)+floor((p+1)/2);

%All the possible combinations of p m-dimensional points
C=combnk(1:n,p);

rmin=Inf;
for i=1:size(C,1)
   for j=1:p
      A(j,:)=[1 X(C(i,j),:)];
      b(j,1)=y(C(i,j));
   end
   if rank(A')==p
      % Calculate the coefficients and keep the slopes
      c=inv(A'*A)*A'*b;
      
      % Make the intercept adjustment
      est1=[ones(n,1) X]*c;
      c1=LMSloc(y-est1);
      c(1)=c(1)+c1;
      
      est=[ones(n,1) X]*c;
      r=y-est;
      r2=r.^2;
      r2=sort(r2);
      rlms=r2(h);
      if rlms<rmin
         rmin=rlms;
         blms=c;
         LMSout=est;
         % Chapter 2, eq. 3.11
         Rsq=1-(median(abs(r))/median(abs(y-median(y))))^2;
      end
   end
end
