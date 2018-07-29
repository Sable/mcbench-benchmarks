function loc=LMSloc(X)
%Syntax: loc=LMSloc(X)
%_____________________
%
% Calculates the Least Median of Squares (LMS) location parameter 
% of the columns of a matrix X. If X is a vector, it returns the LMS
% location parameter of its components. If X is a scalar, it returns
% X.
%
% loc is the LMS estimated vector of locations.
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
   loc=X;
else
   % Sort the data set to ascending order
   X=sort(X);
      
   % P. 169: the length of the "half" of the data points
   h=floor(n/2)+1;
      
   % P. 169: determine the shortest half and compute its midpoint
   j=1:n-h+1;
   range=X(j+h-1,:)-X(j,:);
   
   % Calculate the location parameter for every column of X
   for i=1:size(X,2);
      f=find(range(:,i)==min(range(:,i)));
      loc(i)=median((X(f+h-1,i)+X(f,i))/2);
   end
end
