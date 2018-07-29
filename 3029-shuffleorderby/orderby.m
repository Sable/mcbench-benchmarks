function ox=orderby(x,i,varargin)
%ORDERBY    Orders vectors and matrices according to a predefined order.
%   ORDERBY(X,I) orders the elements of a vector or matrix X
%   according to the index matrix I.
%
%   ORDERBY(X,I,DIM) orders along the dimension DIM.
%
%   If X is a vector, then Y = X(I). If X is an m-by-n matrix, then
%       for j = 1:n, Y(:,j) = X(I(:,j),j); end
%
%   Input arguments:
%      X - the vector or matrix to order (array)
%      I - the index matrix with the ordering to apply (array)
%      DIM - the dimension along which to order (integer)
%   Output arguments:
%      Y - the ordered vector or matrix (array)
%
%   Examples:
%      X = [10 25 30 40]
%      I = [3 2 1 4]
%      Y = ORDERBY(X,I)
%      Y = 30    25    10    40
%
%      X = [10 25 ; 3.2 4.1 ; 102 600]
%      I = [2 3 ; 1 1 ; 3 2]
%      Y = ORDERBY(X,I)
%      Y =   3.2000  600.0000
%           10.0000   25.0000
%          102.0000    4.1000
%
%      X = [10 25 50 ; 3.2 4.1 5.5 ; 102 600 455 ; 0.03 0.34 0.01]
%      I = [1 4 3 2]
%      DIM = 1
%      Y = ORDERBY(X,I,DIM)
%      Y =  10.0000   25.0000   50.0000
%            0.0300    0.3400    0.0100
%          102.0000  600.0000  455.0000
%            3.2000    4.1000    5.5000
%
%      X = [10 25 50 ; 3.2 4.1 5.5 ; 102 600 455 ; 0.03 0.34 0.01]
%      I = [1 3 2]
%      DIM = 2
%      Y = ORDERBY(X,I,DIM)
%      Y =  10.0000   50.0000   25.0000
%            3.2000    5.5000    4.1000
%          102.0000  455.0000  600.0000
%            0.0300    0.0100    0.3400
%
%   See also SHUFFLE
%
%   Created: Sara Silva (sara@itqb.unl.pt) - 2002.11.02

if size(x,1)==1 | size(x,2)==1
   % if its a vector, we don't even care about the eventual 3rd argument (dim)
	ox=x(i);
else
   % if its a matrix, lets check if the ordering is along one dimension
   switch nargin
   case 2
      % each column is ordered separately
   	for c=1:size(x,2)
      	ox(:,c)=x(i(:,c),c);
      end
   case 3
      % let's see if we're ordering entire rows or cols
   	d=varargin{1};
   	switch d
      case 1
         % rows
         ox=x(i,:);
      case 2
         % cols
         ox=x(:,i);
   	otherwise
      	error('ORDERBY: Unknown command option.')
      end
   end
end
