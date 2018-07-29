function sca=LMSsca(X,loc,p)
%Syntax: sca=LMSsca(X,loc,p)
%___________________________
%
% Calculates the Least Median of Squares (LMS) scale parameter 
% of the columns of a matrix X.
%
% sca is the LMS estimated vector of scales.
% X is the matrix with the data sets.
% loc is the location vector. Its default value is the LMS location.
% p is the number of parameters. Its default value is 1.
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

if nargin<1 | isempty(X)==1
   error('Not enough input arguments.');
else
   % X must be 2-dimensional
   if ndims(X)>2
      error('Invalid data set.');
   end
   % If X is a row vector make it a column vector
   if size(X,1)==1
      X=X';
   end
   
   % n is the length of the data set
   n=size(X,1);
end

% For a single data point there is no need to proceed
if n==1
   sca=0;
else
   
   % Check loc
   if nargin<2 | isempty(loc)==1
      % If you don't give loc, it is supposed the LMS location
      loc=LMSloc(X);
   else
      % loc must be a scalar/vector
      if min(size(loc))>1
         error('loc must be a scalar/vector.');
      end
      % loc must have the length of the columns of X
      if length(loc)~=size(X,2);
         error('loc must have the length of the columns of X.');
      end
   end

   % Check p
   if nargin<3 | isempty(p)==1
      % If p is omitted give it the value of 1
      p=1;
   else
      % p must be a scalar
      if sum(size(p))>2
         error('p must be a scalar.');
      end   
      % p must be an integrer greater than 1
      if round(p)-p~=0 | p<1
         error('p must be an integrer greater than or equal to 1.');
      end
   end
   
   % Calculate the scale parameter for every column
   for i=1:size(X,2)
      
      % The squared differences from the location
      r2=(X(:,i)-loc(i)).^2;
      
      % Chapter 5, eq. 1.3
      sca(i)=1.486*(1+5/(n-p))*sqrt(median(r2));
   end
end







