function Y = fillzero(X, DIM)
% FILLZERO - replaces zeros of an array with preceeding non-zero values
%   Y = FILLZERO(X), when X is a vector, returns a vector Y in which
%   each zero in X is changed into the last non-zero value of X
%   that preceeds it. In other words, the sequence ".. A 0 .. 0 B .." is
%   converted into the sequence ".. A A .. A B .." 
%
%   For matrices, FILLZERO(X) operates on the first non-singleton dimension
%   of X. FILLZERO(X,DIM) operates on the dimension DIM.
%
%   Examples:
%     X =       [0 1 0 0 4 0 2 3 0 0 0 8 0] ;
%     Y = fillzero(X) 
%     % --> Y = [0 1 1 1 4 4 2 3 3 3 3 8 8] ;
%
%     X = [1 2 3 0 ; 0 0 4 8; 0 5 0 0 ; 2 0 -2 0 ; 0 1 0 0]
%     fillzero(X)  % ... equals fillzero(X, 1)   
%     % -->
%     %  1     2     3     0
%     %  1     2     4     8
%     %  1     5     4     8
%     %  2     5    -2     8
%     %  2     1    -2     8
%
%     fillzero(X, 2)  
%     % -->
%     %  1     2     3     3
%     %  0     0     4     8
%     %  0     5     5     5
%     %  2     2    -2    -2
%     %  0     1     1     1
%
%   FILLZERO can handle NaNs, and Infs. Example:
%     fillzero([1 0 NaN 0 3 0 Inf 0 -Inf 0 6 0]) 
%     % -> 1  1  NaN  NaN  3  3 Inf Inf -Inf -Inf  6   6
%
%   See also FIND, CUMSUM

% for Matlab R13+
% version 2.1 (jun 2008)
% (c) Jos van der Geest
% email: jos@jasen.nl

% History:
% 1.0 (may 2008) : Creation, inspired by problem posted on CSSM:
%     http://www.mathworks.com/matlabcentral/newsreader/view_thread/169145
%     Fast Vector Filling, by Richard Brown
% 1.1 (may 2008) : fixed error when all elements were NaN or Inf
% 2.0 (jun 2008) : fixed  bugs with higher dimensions, when X contained
%                  no zeros at all. 
% 2.1 (jun 2008) : fixed bug introduced with non-zero columns

if nargin==1,    
    DIM = min(find(size(X)>1)) ;    
elseif (numel(DIM) ~= 1) || (fix(DIM) ~= DIM) || (DIM < 1),
    error('FillZero:DimensionError','Dimension argument must be a positive integer scalar.') ;
end

if numel(X)<2 || DIM > ndims(X) || size(X,DIM) < 2 || all(X(:)),  
    % in some cases, do nothing
    Y = X ;
else
    % Treat NaNs and Infs
    qinf = isinf(X) ;
    qnan = isnan(X) ;
    qnaninf = qinf | qnan ;
    
    if any(qnaninf(:)),
        if all(qnaninf(:)),
            Y = X ;
            return ;
        end
        % recode Infs and Nans
        M = max(X(~qnaninf)) ;  % maximum       
        X(qnan) = M + 1 ;        
        X(qinf) = M + 2 + (X(qinf) > 0) ;        
    end
       
    % put the dimension of interest first
    [X, Nshift] = shiftdim(X,DIM-1) ;
    SX = size(X) ;
    % reshape it into a 2D matrix
    X = reshape(X,SX(1),[]) ;    
    
    
    
    % only operate on mixed zero and nonzero columns
    NonZeroCols = find(any(~~X) & any(~X)) ;
    [ri,ci] = find(X) ;
    
    Y = X ;
    Y(:,NonZeroCols) = 0 ;    
    for i = NonZeroCols,
        % positions of column that contain nonzero values
        ind = ri(ci==i) ;                         
        Y(ind(2:end),i) = diff(X(ind,i)) ;
        % cumsum(diff(...)) will almost returns the original array.      
        % we just have to add the offest
        Y(:,i) = cumsum(Y(:,i)) + X(ind(1),i) ;
        Y(1:ind(1)-1,i) = 0 ; % set leading zeros to zero
    end
    
    % reshape in proper format
    Y = reshape(Y,SX) ;
    % and re-shift dimensions
    Y = shiftdim(Y,ndims(Y) - Nshift) ;
    if any(qnaninf(:)),
        Y(Y==M+1) = NaN ;
        Y(Y==M+2) = -Inf ;
        Y(Y==M+3) = Inf ;
    end
end
