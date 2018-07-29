function [z varargout] = intersectm(varargin)

% INTERSECTM Find set intersection of several vectors
% 
%   Z = INTERSECTM(A, B, C...) returns the values common to A, B, C... which can be numeric or character 
%                              vectors or cell arrays of strings. Z is a vector sorted in ascending order.
%
%   Z = INTERSECTM(A, B, C...,'rows') when A, B, C... are matrices with the same number of columns returns 
%                                     the rows common to the sets supplied.
%
%   [Z, IA, IB, IC...] = INTERSECTM(...) also returns column index vectors IA, IB, IC... such that Z = A(IA), 
%                                        Z = B(IB), Z = C(IC)... (or Z = A(IA,:), Z = B(IB,:), Z = C(IC,:)...).
%
%
% EXAMPLES: 
%   - Retrieve Z the set intersection of the elements in "a", "b" and "c" and the indexes IA, IB and IC
% 
%       a =  1:5   ;
%       b = (3:9).';
%       c = -1:4   ;
% 
%       [z, ia, ib, ic] = intersectm(a, b, c)
%       z =
%           3     4
%       ia =
%           3
%           4
%       ib =
%           1
%           2     
%       ic =
%           5
%           6 
%
% NOTE: IA, IB and IC have the same size as their corresponding inputs A, B and C while Z 
%       has the size of A.
%
%   - Retrieve Z the set intersection of the rows "a", "b" and "c" and the indexes IA, IB and IC
% 
%       a = [ 1:5 ;11:15];
%       b =  11:15;
%       c = [16:20;11:15];
% 
%       [z, ia, ib, ic] = intersectm(a, b, c, 'rows')
%       z =
%           11    12    13    14    15
%       ia =
%           2
%       ib =
%           1
%       ic =
%           2
%
% Additional features:
% - <a href="matlab: web('http://www.mathworks.com/matlabcentral/fileexchange/28341','-browser')">FEX set functions page</a>
%
% See also: INTERSECT, ISMEMBERM, SETDIFFM, SETXORM, UNIONM

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
        error('intersectm:sameNumCols','A, B, C... must have the same number of columns.')
    end
else flag = [];
    % Check that all inputs are vectors
    if any(cellfun('prodofsize',varargin) ~= cellfun('length',varargin))
        error('intersectm:allVectors','A, B, C... must be all vectors or ''rows'' must be specified.')
    end
end

% Check same class
if ~cellfun('isclass',varargin(2:end), class(varargin{1}))
    error('intersectm:sameClass','A, B, C... should belong to the same class.')
end

% # of sets to intersect
numSets = numel(varargin);
if numSets == 1
    error('intersectm:noSet','Insufficient inputs: must supply at least two sets.')
end

% # outputs 
error(nargoutchk(0,numSets+1,nargout))

% Find intersection set with ismemberm
if isempty(flag)
    z = varargin{1}(all(ismemberm(varargin{:}     ),2)  );
else
    z = varargin{1}(all(ismemberm(varargin{:},flag),2),:);
end

% Retrieve column index vectors 
if nargout > 1
    varargout = cellfun(@(x) reshape(find(ismember(x,z,flag)),[],1),varargin(1:nargout-1),'un',0);
end
end