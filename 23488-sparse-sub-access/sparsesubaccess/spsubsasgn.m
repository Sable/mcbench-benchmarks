function S = spsubsasgn(varargin)
% function S = SPSUBSASGN(S, r, c, v)
%
% PURPOSE: a new sparse matrix after assigning S(r(:), c(:)) = v(:)
%
% SPSUBSASGN(..., fun)
%   where fun is a function handle: apply two-variates FUN before assign
%       the values S(k) = fun(S(k),v(k)), (k is corresponding linear-index)
%    Reverse order of input variables SPSUBSASGN(r, c, v, S, fun) to
%    apply function in other way around: S(k) = fun(v(k),S(k))
%
% FUN can either be a function handle in mfile or following functions:
%
%     @asgn           Assign value
%     @plus           Plus
%     @minus          Minus
%     @times          Array multiply
%     @rdivide        Right array divide
%     @ldivide        Left array divide
%     @power          Array power
%     @max            Binary maximum
%     @min            Binary minimum
%     @rem            Remainder after division
%     @mod            Modulus after division
%     @atan2	        Four-quadrant inverse tangent
%     @hypot	        Square root of sum of squares
%     @eq             Equal
%     @ne             Not equal
%     @lt             Less than
%     @le             Less than or equal
%     @gt             Greater than
%     @ge             Greater than or equal
%     @and            Element-wise logical AND
%     @or             Element-wise logical OR
%     @xor            Logical EXCLUSIVE OR
%
% Note: This function is useful for sparse because sometime a straight
% forward linear-indexing might not work for large indexes (overflow)
%
% Author Bruno Luong <brunoluong@yahoo.com>
% Last update: 15/April/2009
%   18/August/2009 tolerate setting UINT8/INT8 to Logical sparse
%   13-Nov-2010 expand scalar row and column

persistent MEXFLAG

if nargin<4
    error('SPSUBSASGN requires at least four inputs');
else
    if issparse(varargin{4})
        swapops = true;
        [r c v S] = deal(varargin{1:4});
    else
        swapops = false;
        [S r c v] = deal(varargin{1:4});
    end
end

if nargin>=5
    fun=varargin{5};
else
    fun=[];
end

assignflag = (isempty(fun) || isasgn(fun));

if ~issparse(S) || ~isnumeric(r) || ~isnumeric(r)
    error('S must be sparse matrix and r and c must be valid subindexes');
end

if any(r(:)<1) || (any(r(:)>size(S,1)) && ~assignflag)
    error('Row subscript out of range')
end

if any(c(:)<1) || (any(c(:)>size(S,2)) && ~assignflag)
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

if isscalar(v)
    v = repmat(v,size(r));
end

% Check if mex-file getspvalmex exists
if nargin>=6
    MEXFLAG = varargin{6};
end

if isempty(MEXFLAG)
    MEXFLAG = ~isempty(strfind(which('setspvalmex'),mexext));
    if ~MEXFLAG
        warning('Mex has not built. Recommendation > mex -v -O setspvalmex.c');
    end
end

% Basic assign value
if assignflag
    tref = spcalib();
    if tref.factory
        warning('Calibration not yet performed. Recommendation > spcalib(''auto'')');
    end
    tmex = tref.tsetval*numel(v)*max(log2(nnz(S)),7);
    tadd = tref.tgetval*(numel(v)*max(log2(nnz(S)),7))+tref.tadd*(nnz(S)+numel(v));
    if MEXFLAG && (tmex<tadd)
        % Cast to the same class
        if ~strcmp(class(v),class(S))
            if islogical(S) && ~any(strcmp(class(v),{'uint8' 'int8'}))
                v = feval(class(S),v);
            end
        end
        S = setspvalmex(S, r(:), c(:), v(:));
    else % This is now slower
        sk = spsubsref(S, r(:), c(:));
        v(:) = v(:) - sk;
        S = S + sparse(r(:), c(:), v(:), size(S,1), size(S,2));
    end
else
    % Addition
    if isequal(fun,@plus)
        S = S + sparse(r(:), c(:), v(:), size(S,1), size(S,2));
    elseif isequal(fun,@minus) && ~swapops % Substraction in something to S
        S = S - sparse(r(:), c(:), v(:), size(S,1), size(S,2));
    else % Other cases
        sk = spsubsref(S, r(:), c(:));
        if swapops
            [arg1 arg2] = deal(v(:), sk);
        else
            [arg1 arg2] = deal(sk, v(:));
        end
        v(:) = feval(fun, arg1, arg2);
        S = setspvalmex(S, r(:), c(:), v(:));
    end
end

end % spsubsasgn

% Make sure the function handle is the right local @asgn
function b = isasgn(fun)
if isequal(fun,@asgn)
    info=functions(fun);
    funpath=fileparts(info.file);
    thispath=fileparts(mfilename('fullpath'));
    b=strcmp(funpath,thispath);
else
    b = false;
end
end

