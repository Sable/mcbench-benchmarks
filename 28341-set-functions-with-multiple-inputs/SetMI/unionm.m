function [z varargout] = unionm(varargin)

% UNIONM Find set union of several vectors
% 
%   Z = UNIONM(A, B, C...) returns the combined values from A, B, C... but with no repetitions. Inputs can be 
%                          numeric or character vectors or cell arrays of strings. Z is a vector sorted in
%                          ascending order.
%
%   Z = UNIONM(A, B, C...,'rows') when A, B, C... are matrices with the same number of columns returns the 
%                                 combined rows from the sets supplied with no repetitions.
%
%   [Z, IA, IB, IC...] = UNIONM(...) also returns column index vectors IA, IB, IC... such that 
%                                    Z = A(IA) U B(IB) U C(IC)... (or Z = A(IA,:) U B(IB,:) U C(IC,:)...). 
%                                    If a value appears in several sets, UNIONM indexes its occurrence in the 
%                                    last set supplied. If a value appears more than once in a set, UNIONM 
%                                    indexes the last occurrence of the value.
%
%
% EXAMPLES: 
%   - Retrieve Z the set union of the elements in "a", "b" and "c" and the column indexes IA, IB and IC
% 
%       a =  1:2   ;
%       b = (3:4).';
%       c = -1:2   ;
% 
%       [z, ia, ib, ic] = unionm(a, b, c)
%       z =
%           -1
%           0
%           1
%           2
%           3
%           4
%       ia =
%           Empty matrix: 0-by-1
%       ib =
%           1
%           2
%       ic =
%           1
%           2
%           3
%           4
%
%   - Retrieve Z the set union of the rows "a", "b" and "c" and the indexes IA, IB and IC
% 
%       a = [ 1:5 ;11:15];
%       b =  11:15;
%       c = [16:20;11:15];
% 
%       [z, ia, ib, ic] = unionm(a, b, c, 'rows')
%       z =
%           1     2     3     4     5
%           11    12    13    14    15
%           16    17    18    19    20
%       ia =
%           1
%       ib =
%           Empty matrix: 0-by-1
%       ic =
%           2
%           1

% NOTE: If a value appears in several sets, UNIONM indexes its occurrence in the last set supplied. If a value
%       appears more than once in a set, UNIONM indexes the last occurrence of the value.
%
% Additional features:
% - <a href="matlab: web('http://www.mathworks.com/matlabcentral/fileexchange/28341','-browser')">FEX set functions page</a>
%
% See also: UNION, SETXORM, INTERSECTM, ISMEMBERM, SETDIFFM

% Author: Oleg Komarov (oleg.komarov@hotmail.it) 
% Tested on R14SP3 (7.1) and on R2009b
% 23 jul 2010 - Created
% 30 jul 2010 - Added link to fex

% # inputs
error(nargchk(2,nargin,nargin))

% Check for 'rows' flag 
IDXflag = strcmp('rows',varargin);
if any(IDXflag)
    % Extract flag
    flag     = varargin{ IDXflag};
    varargin = varargin(~IDXflag);
    % Check that all inputs have the same number of columns
    if logical(diff(cellfun('size',varargin,2)))
        error('unionm:sameNumCols','A, B, C... must have the same number of columns.')
    end
else flag = [];
    % Check that all inputs are vectors
    if any(cellfun('prodofsize',varargin) ~= cellfun('length',varargin))
        error('unionm:allVectors','A, B, C... must be all vectors or ''rows'' must be specified.')
    end
end

% Check same class
if ~cellfun('isclass',varargin(2:end), class(varargin{1}))
    error('unionm:sameClass','A, B, C... should belong to the same class.')
end

% # of sets to join
numSets = numel(varargin);
if numSets == 1
    error('unionm:noSet','Insufficient inputs: must supply at least two sets.')
end

% # outputs 
error(nargoutchk(0,numSets+1,nargout))

% Join with simple concatenation and unique elements/rows
if isempty(flag)
    varargin = cellfun(@(x) x(:), varargin,'un',0);
    z        = cat(1,varargin{:});
    [z iz]   = unique(z);
else
    z        = cat(1,varargin{:});
    [z iz]   = unique(z, flag);
end

% Retrieve column index vectors 
if nargout > 1
    if isempty(flag)
        edges = [0 cumsum(cellfun('length',varargin  ))];
    else
        edges = [0 cumsum(cellfun('size'  ,varargin,1))];
    end
    [n, bin] = histc(iz, [edges(1) edges(2:end)+1]);
    varargout = arrayfun(@(x) iz(bin == x)-edges(x), 1:nargout-1,'un',0);
end
end