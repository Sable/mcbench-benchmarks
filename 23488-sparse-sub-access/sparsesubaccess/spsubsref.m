function [v valnz] = spsubsref(S, r, c, MexFlag)
% function v = spsubsref(S, r, c)
% function v = spsubsref(S, r, c, MexFlag)
%
% PURPOSE: return v(:) = S(r(:), c(:)) for sparse matrix
%
% Note: This function is useful for sparse because sometime a straight
% forward linear-indexing might not work for large indexes (overflow)
% 
% Author Bruno Luong <brunoluong@yahoo.com>
% Last update: 05-April-2009
%              13-Nov-2010 expand scalar row and column

persistent MEXFLAG

if ~issparse(S) || ~isnumeric(r) || ~isnumeric(r)
    error('S must be sparse matrix and r and c must be valid subindexes');
end

if any(r(:)<1) || any(r(:)>size(S,1))
    error('Row subscript out of range')
end

if any(c(:)<1) || any(c(:)>size(S,2))
    error('Column subscript out of range')
end

if ndims(r) ~= ndims(c)
    error('r and c must have a same dimension')
else
    % expand row to match size of column
    if isscalar(r)
        r = repmat(r,size(c));
    elseif isscalar(c)
        % expand column to match size of row
        c = repmat(c,size(r));
    elseif isvector(r) && isvector(c) && (size(r,1)>1 || size(c,1)>1)
        % If one of them is row vector, reshape it column vector
        % for compatible
        r = reshape(r, [], 1);
        c = reshape(c, [], 1);
    elseif ~all(size(r)==size(c))
        error('r and c must have a same dimension')
    end
end

% Check if mex-file getspvalmex exists
if nargin>=4
    MEXFLAG = MexFlag;
end

if isempty(MEXFLAG)
    MEXFLAG = ~isempty(strfind(which('getspvalmex'),mexext));
    if ~MEXFLAG
        warning('Mex has not built. Recommendation > mex -v -O getspvalmex.c');
    end
end

% Allocate memory
if islogical(S)
    v = false(size(r));
else
    v = zeros(size(r));
    if ~isreal(S) % complex array
        v = complex(v);
    end
end
if MEXFLAG
    % Call mex engine
    [v(:) valnz] = getspvalmex(S, r(:), c(:));
else
    sz = size(S);
    ind = sub2ind(sz,r,c);
    overflowed = ind > maxlinind(size(S));
    
    % Direct linear indexing
    v(~overflowed) = S(ind(~overflowed));
    % Elements that are not possible to linear-index directly
    overflowed = find(overflowed);
    v(overflowed) = spref(S, r(overflowed), c(overflowed));
    % Check if all elements are different zero
    if nargout>=2
        valnz = sum(v(:)==0);
    end
end

end % spsubsref

% Get values for few overflowed indexes
function v = spref(S, r, c)

tref = spcalib();
if tref.factory
    warning('Calibration not yet performed. Recommendation > spcalib(''auto'')');
end

nz = nnz(S);
% For loop strategy for small number of references
if numel(r)*tref.treadfor < tref.tfind*nz + tref.tismember*(nz+numel(r))
    v = zeros(size(r));
    for k=1:numel(v)
        v(k) = S(r(k),c(k));
    end
else
    % Is member strategy
    [I J s]=find(S);
    [tf loc]= ismember([r(:) c(:)], [I J], 'rows');
    v = zeros(size(tf));
    v(tf) = s(loc(tf));
end

end % spref
