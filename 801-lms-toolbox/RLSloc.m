function loc=RLSloc(X)
%Syntax: loc=RLSloc(X)
%_____________________
%
% Calculates the Reweighterd Least Squares (RLS) location parameter 
% of the columns of a matrix X. If X is a vector, it returns the RLS
% location parameter of its components. If X is a scalar, it returns
% X.
%
% loc is the RLS estimated vector of locations.
% X is the matrix with the data sets.
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
   % If X is a row vector make it a column vector
   if size(X,1)==1
      X=X';
   end
   % n is the length of the data set
   n=size(X,1);
end

% For a single data point there is no need to proceed
if n==1
   loc=X;
else
   % Find the LMS location parameter
   l=LMSloc(X);
   % Find the LMS scale parameter
   s=LMSsca(X);
   
   % Calculate the location parameter for every column of X
   for i=1:size(X,2);
      r=X(:,i)-l(i);
      if s(i)==0
         w=1:n;
      else
         w=find(abs(r)/s(i)<=2.5);
      end
      loc(i)=mean(X(w,i));
   end
end
