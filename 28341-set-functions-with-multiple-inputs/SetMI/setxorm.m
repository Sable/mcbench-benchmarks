function [z varargout] = setxorm(varargin)

% SETXORM Find set exclusive OR of several vectors
% 
%   Z = SETXORM(A, B, C...) returns the values that are not in the intersection of A, B, C... which can be 
%                           numeric or character vectors or cell arrays of strings. Z is a vector sorted in
%                           ascending order.
%
%   Z = SETXORM(A, B, C...,'rows') when A, B, C... are matrices with the same number of columns returns the 
%                                  rows that are not in the intersection of the sets supplied.
%
%   [Z, IA, IB, IC...] = SETXORM(...) also returns column index vectors IA, IB, IC... such that Z = A(IA), 
%                                     Z = B(IB), Z = C(IC)... (or Z = A(IA,:), Z = B(IB,:), Z = C(IC,:)...).
%
%
% EXAMPLES: 
%   - Retrieve Z the set exclusive OR of the elements in "a", "b" and "c" (elements that are not in the set
%     intersection of "a", "b" and "c") and the column indexes IA, IB and IC
% 
%       a =  1:2   ;
%       b = (1:4).';
%       c = -1:2   ;
% 
%       [z, ia, ib, ic] = setxorm(a, b, c)
%       z =
%           -1
%           0
%           3
%           4
%       ia =
%           Empty matrix: 0-by-1
%       ib =
%           3
%           4
%       ic =
%           1
%           2
%
%       Retrieve Z the set exclusive OR of the rows in "a", "b" and "c" (rows that are not in the set
%       intersection of "a", "b" and "c") and the column indexes IA, IB and IC
%
%       a = [11:15;13:17];
%       b =  11:15;
%       c = [16:20;11:15];
% 
%       [z, ia, ib, ic] = setxorm(a, b, c, 'rows')
%       z =
%           13    14    15    16    17
%           16    17    18    19    20
%       ia =
%           2
%       ib =
%           Empty matrix: 0-by-1
%       ic =
%           1
%
% Additional features:
% - <a href="matlab: web('http://www.mathworks.com/matlabcentral/fileexchange/28341','-browser')">FEX set functions page</a>
%
% See also: SETXOR, INTERSECTM, ISMEMBERM, SETDIFFM, UNIONM

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
        error('setxorm:sameNumCols','A, B, C... must have the same number of columns.')
    end
else flag = [];
    % Check that all inputs are vectors
    if any(cellfun('prodofsize',varargin) ~= cellfun('length',varargin))
        error('setxorm:allVectors','A, B, C... must be all vectors or ''rows'' must be specified.')
    end
end

% Check same class
if ~cellfun('isclass',varargin(2:end), class(varargin{1}))
    error('setxorm:sameClass','A, B, C... should belong to the same class.')
end

% # of sets to intersect
numSets = numel(varargin);
if numSets == 1
    error('setxorm:noSet','Insufficient inputs: must supply at least two sets.')
end

% # outputs 
error(nargoutchk(0,numSets+1,nargout))

% Build pivot set with unionm
varargin = {unionm(varargin{:}, flag), varargin{:}};

% Find set exclusice OR with ismemberm
if isempty(flag)
    z = varargin{1}(~all(ismemberm(varargin{:}     ),2)  );
else
    z = varargin{1}(~all(ismemberm(varargin{:},flag),2),:);
end

% Retrieve column index vectors 
if nargout > 1
    varargout = cellfun(@(x) reshape(find(ismember(x,z,flag)),[],1),varargin(2:nargout),'un',0);
end
end