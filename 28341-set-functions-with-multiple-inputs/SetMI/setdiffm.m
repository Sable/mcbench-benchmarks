function [z iz] = setdiffm(varargin)

% SETDIFFM Find set difference of several vectors
% 
%   Z = SETDIFFM(A, S1, S2...) returns the values in A that are not in S1 or S2... (not in unionm(S1,S2,...))
%                              Inputs can be numeric or character vectors or cell arrays of strings. Z is a 
%                              vector sorted in ascending order.
%
%   Z = SETDIFFM(A, S1, S2...,'rows') when A, S1, S2... are matrices with the same number of columns returns 
%                                     the rows from A that are not in S1 or S2... (not in
%                                     unionm(S1,S2,...,'rows'))
%
%   [Z, IZ] = SETDIFFM(...) also returns the column index vector IZ such that Z = A(IZ) (or Z = A(IZ,:)).
%
%
% EXAMPLES: 
%   - Retrieve Z the set difference of the elements in "a" that are not in "s1" or "s2" and the column index IA
% 
%       a  =  9:12  ;
%       s1 = (3:9).';
%       s2 = -1:4   ;
% 
%       [z, ia] = setdiffm(a, s1, s2)
%       z =
%           10    11    12
%       ia =
%           2
%           3
%           4
%
%   - Retrieve Z the set difference of the rows in "a" that are not in "s1" or "s2" and the column indexe IA
% 
%       a  = [ 1:5 ;11:15];
%       s1 =  11:15;
%       s2 = [16:20;11:15];
% 
%       [z, ia] = setdiffm(a, s1, s2, 'rows')
%       z =
%           1     2     3     4     5
%       ia =
%           1
%
% Additional features:
% - <a href="matlab: web('http://www.mathworks.com/matlabcentral/fileexchange/28341','-browser')">FEX set functions page</a>
%
% See also: SETDIFF, ISMEMBERM, INTERSECTM, SETXORM, UNIONM


% Author: Oleg Komarov (oleg.komarov@hotmail.it) 
% Tested on R14SP3 (7.1) and on R2009b
% 23 jul 2010 - Created
% 30 jul 2010 - Edited description and added link to fex

% # inputs
error(nargchk(2,nargin,nargin))

% # outputs 
error(nargoutchk(0,2,nargout))

% Check for 'rows' flag 
IDXflag = strcmp('rows',varargin);
if any(IDXflag)
    % Extract flag
    flag     = varargin{ IDXflag};
    varargin = varargin(~IDXflag);
    % Check that all inputs have the same number of columns
    if logical(diff(cellfun('size',varargin,2)))
        error('setdiffm:sameNumCols','A, S1, S2... must have the same number of columns.')
    end
else flag = [];
    % Check that all inputs are vectors
    if any(cellfun('prodofsize',varargin) ~= cellfun('length',varargin))
        error('setdiffm:allVectors','A, S1, S2... must be all vectors or ''rows'' must be specified.')
    end
end

% Check same class
if ~cellfun('isclass',varargin(2:end), class(varargin{1}))
    error('setdiffm:sameClass','A, S1, S2... should belong to the same class.')
end

% # of vars A should be tested against
if numel(varargin) == 1
    error('setdiffm:noSet','Insufficient inputs: must supply at least one set except A.')
end

% Find difference set with ismemberm
if isempty(flag)
    iz = ~any(ismemberm(varargin{1},varargin{2:end}     ),2);
    z  = varargin{1}(iz);
else
    iz = ~any(ismemberm(varargin{1},varargin{2:end},flag),2);
    z = varargin{1}(iz,:);
end

% Retrieve the column index vector
if nargout > 1
    iz = find(iz); 
end
end