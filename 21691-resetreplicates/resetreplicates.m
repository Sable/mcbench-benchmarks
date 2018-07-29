function X = resetreplicates(X,DIM,VAL) ;
% RESETREPLICATES - change the value of replicated elements in a matrix
%
%   For vectors, R = RESETREPLICATES(X) returns a vector R in which the
%   re-ocurrences (replicates) of the values in X are set to NaN, except
%   for their first occurrence. For 2-D matrices, RESETREPLICATES(X) looks
%   for replicates in each column of X separately. For N-D arrays the
%   function operates along the first non-singleton dimension of X.
%
%   R = RESETREPLICATES(X,DIM) operates along the dimension DIM. When DIM
%   is empty, the function operates along the first non-singleton
%   dimension.
%
%   R = RESETREPLICATES(X,DIM,V) sets all replicates to the value V instead
%   of NaN. V must be a scalar. NaNs in X are ignored.
%
%   Examples:
%      resetreplicates([1 2 2 1 0 3 4 5 3 2])
%        % -> [1 2 NaN NaN 0 3 4 5 NaN NaN]
%
%      A = [1 0 0 1 ; 1 2 3 4 ; 2 2 5 1 ; 3 0 0 3]
%      resetreplicates(A) % = resetreplicates(A,1)
%        %      1     0     0     1
%        %    NaN     2     3     4
%        %      2   NaN     5   NaN
%        %      3   NaN   NaN     3
%
%      resetreplicates(A,2)
%        %      1     0   NaN   NaN
%        %      1     2     3     4
%        %      2   NaN     5     1
%        %      3     0   NaN   NaN
% 
%      resetreplicates(A,1,0) % = resetreplicates(A,[],0)
%        %      1     0     0     1
%        %      0     2     3     4
%        %      2     0     5     0
%        %      3     0     0     3
%
%  See also UNIQUE, ISMEMBER
%           FILLZERO, REPLACE (on the File Exchange)
%
%  Version 1.1 (oct 2008)

% for Matlab R13+
% version 1.1 (oct 2008)
% (c) Jos van der Geest
% email: jos@jasen.nl

% History:
% 1.0 (oct 2008) : created, inspired by problem posted on CSSM.
% Revisions:
% 1.1 (oct 2008) : consistent naming to RESETREPLICATES

% check for common errors
error(nargchk(1,3,nargin)) ;

if nargin==1 || isempty(DIM), 
    % default to first non-singleton dimension
    DIM = min(find(size(X)>1)) ;
elseif (numel(DIM) ~= 1) || (fix(DIM) ~= DIM) || (DIM < 1),
    error([mfilename ':DimensionError'],...
        'Dimension argument must be a positive integer scalar.') ;
end

if nargin<3
    % default filler value
    VAL = NaN ;
elseif (numel(VAL)~=1 || ~isnumeric(VAL)),
        error([mfilename ':InvalidValue'], ...
            'Replacement value should be a numeric scalar.') ;
end

if size(X,DIM)==1,
    % no replicates in the required dimension
    return ;
end

% put the dimension of interest first
[X, Ndim] = shiftdim(X,DIM-1) ;
SX = size(X) ;
% reshape it into a 2D matrix
X = reshape(X,SX(1),[]) ; 
% unique has no 'columns' option, so transpose
X = X.' ;

% select the non-fillers in X
if isnan(VAL),
    q = ~isnan(X) ;
else
    q = X ~= VAL ;
end

% find all elements
v = X(q) ; 
% and get the row an column indices
[r,c] = find(q) ;
% replicated elements have the same value within the same row; in other
% words, look for the unique ones among the pairs [rowindex, value]
% We want to retain the first occurrence in the row, so apply flipud
[rv,si] = unique(flipud([r(:) v(:)]),'rows') ;
% we need to flip the column indices as well
c = flipud(c(:)) ;
% translate into linear indices
ind = sub2ind(size(X),rv(:,1),c(si)) ;
% reset the whole matrix
X(:) = VAL ;
% and put back the values to retain
X(ind) = rv(:,2) ;

% Almost done! Just transpose, reshape and re-shift dimensions
X = shiftdim(reshape(X.',SX),Ndim) ;