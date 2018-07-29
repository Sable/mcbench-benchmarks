function B = findfirst(A, dim, count, firstlast)
% B = FINDFIRST(A)
%
% Look for the row-indices of a first non-zero element(s) for all columns
% in the array. It is equivalent to doing:
%
%       B=zeros(1,size(A,1));
%       for j=1:size(A,2)
%           Bj = find(A(:,j), 1, 'first');
%           if ~isempty(Bj); B(j)=Bj; end
%       end
%
% B = FINDFIRST(A, DIM): operate along the dimension DIM
% B = FINDFIRST(A, DIM, COUNT): look for the most COUNT non-zeros elements
%                               (by default COUNT is 1)
% B = FINDFIRST(A, DIM, COUNT, 'LAST'): returns most last non-zero indices
%
% INPUTS:
%       A: array of dimension (N1 x N2 x ...x Nd x ... Nn)
%          A can be any numerical class
% OUTPUT:
%       B: same dimension than A, but only Nd is contracted to COUNT
%          where d is the dimension specified by the second input (DIM)
%          and COUNT is specified by the third input
%       B dimension is (N1 x N2 x ... x COUNT x ... Nn)
%       B contains indices non-zero elements of A along DIM
%       B is filled when it's possible, the rest is filles with zeros if A
%         contains less than COUNT non-zero elements.
%
% NOTES: - Sparse matrix is not suuported
%        - Inplace engine, i.e., no duplicated temporary array is created
%
% USAGE EXAMPLES:
%
%    A = [ 0  1  1
%          1  0  1
%          0  0  0
%          0  0  1
%          1  1  1 ]
%
% OPERATE ALONG COLUMNS: > B = FINDFIRST(A) % returns [2 1 1]
%
% OPERATE ALONG ROWS: > B=FINDFIRST(A,2) % returns [2 1 0 3 1]'
%
% > B=FINDFIRST(A,1,2) % returns two indexes for each column [2 1 1
%                                                             5 5 2]
%
% > B=FINDFIRST(A,1,2, 'last') % returns two last indexes [5 5 5
%                                                          2 1 4]
%
% See also: find, nonzeros
%
% AUTHOR: Bruno Luong <brunoluong@yahoo.com>
% HISTORY
%   Original: 05-Jul-2009
%

% Default working dimension
if nargin<2 || isempty(dim)
    dim = 1;
end
% Check if it's correct
if ~isscalar(dim)
    error('FINDFIRST: dim must be a scalar');
end
dim = round(dim);
if dim<=0
    error('FINDFIRST: dim must be positive number');
end

% Default count
if nargin<3 || isempty(count)
    count = 1;
end
% Check if it's correct
if ~isscalar(count)
    error('FINDFIRST: count must be a scalar');
end
count = round(double(count));

% Default 'first' 'last flag
if nargin<4 || isempty(firstlast)
    firstlast = 'first';
end
if ~ischar(firstlast) || isempty(strmatch(firstlast,{'first' 'last'}))
    error('FINDFIRST: Fourth argument must be ''first'' or ''last''');
end

if issparse(A)
    error('FINDFIRST: A must be full matrix')
end

% Extend trailing singleton dimension if needed
szA = size(A);
szA(end+1:dim) = 1;

% Reshape A in 3D arrays, working dimension is the middle
% That is the form the FIND1DMEX
k = prod(szA(1:dim-1)); % return 1 if empty
m = szA(dim);
n = prod(szA(dim+1:end)); % return 1 if empty
A = reshape(A,[k m n]);

% Call mex engine
if strcmpi(firstlast, 'first')
    B = find1dmex(A, count);
else
    B = find1dmex(A, -count);
end

% Dimension of the output
szB = szA;
szB(dim) = count;
B = reshape(B,szB);

end
