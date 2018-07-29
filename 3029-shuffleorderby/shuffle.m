function [s,myorder]=shuffle(x,varargin)
%SHUFFLE    Shuffles vectors or matrices.
%   SHUFFLE(X) shuffles the elements of a vector or matrix X.
%
%   SHUFFLE(X,DIM) shuffles along the dimension DIM.
% 
%   [Y,I] = SHUFFLE(X) also returns an index matrix I. If X is
%   a vector, then Y = X(I). If X is an m-by-n matrix, then
%       for j = 1:n, Y(:,j) = X(I(:,j),j); end
%
%   Input arguments:
%      X - the vector or matrix to shuffle (array)
%      DIM - the dimension along which to shuffle (integer)
%   Output arguments:
%      Y - the vector or matrix with the elements shuffled (array)
%      I - the index matrix with the shuffle order (array)
%
%   Examples:
%      X = [10 25 30 40]
%      [Y,I] = SHUFFLE(X)
%      Y = 30    25    10    40
%      I =  3     2     1     4
%
%      X = [10 25 ; 3.2 4.1 ; 102 600]
%      [Y,I] = SHUFFLE(X)
%      Y =   3.2000  600.0000
%           10.0000   25.0000
%          102.0000    4.1000
%      I =  2     3
%           1     1
%           3     2
%
%      X = [10 25 50 ; 3.2 4.1 5.5 ; 102 600 455 ; 0.03 0.34 0.01]
%      DIM = 1
%      [Y,I] = SHUFFLE(X,DIM)
%      Y =  10.0000   25.0000   50.0000
%            0.0300    0.3400    0.0100
%          102.0000  600.0000  455.0000
%            3.2000    4.1000    5.5000
%      I =  1     4     3     2
%
%      X = [10 25 50 ; 3.2 4.1 5.5 ; 102 600 455 ; 0.03 0.34 0.01]
%      DIM = 2
%      [Y,I] = SHUFFLE(X,DIM)
%      Y =  10.0000   50.0000   25.0000
%            3.2000    5.5000    4.1000
%          102.0000  455.0000  600.0000
%            0.0300    0.0100    0.3400
%      I =  1     3     2
%
%   See also ORDERBY
%
%   Created: Sara Silva (sara@itqb.unl.pt) - 2002.11.02

rand('state',sum(100*clock)); % (see help RAND)

switch nargin
case 1
   if size(x,1)==1 | size(x,2)==1
      [ans,myorder]=sort(rand(1,length(x)));
      s=x(myorder);
   else
      [ans,myorder]=sort(rand(size(x,1),size(x,2)));
   	for c=1:size(x,2)
      	s(:,c)=x(myorder(:,c),c);
      end
   end
case 2
   d=varargin{1};
   switch d
   case 1
      [ans,myorder]=sort(rand(1,size(x,1)));
		s=x(myorder,:);
   case 2
      [ans,myorder]=sort(rand(1,size(x,2)));
      s=x(:,myorder);
   otherwise
      error('SHUFFLE: Unknown command option.')
   end
end
