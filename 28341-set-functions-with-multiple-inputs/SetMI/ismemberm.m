function [tf, loc] = ismemberm(varargin)

% ISMEMBERM Test if array elements of A are members of sets S1, S2...
% 
%   TF = ISMEMBERM(A, S1, S2...) if A is a vector returns a "m by n" matrix where m = length(A) and "n" is the 
%                                number of sets A is tested against. Each column will contain logical 1 (true) 
%                                where the elements of A are in the "n-th" set, and logical 0 (false) elsewhere. 
%                                If A is a matrix returns a "1 by n" cell array each cell containig a TF matrix.
%                                Inputs A, S1, S2... can be numeric or character arrays or cell arrays of 
%                                strings.
%
%   TF = ISMEMBERM(A, S1, S2...,'rows') when A, S1, S2... are matrices with the same number of columns returns 
%                                       the same output as above testing the entire row instead of a single 
%                                       element.
%                                       You cannot use this syntax if A, S1, S2... are cell arrays of strings.
%
%   [TF, LOC] = ISMEMBERM(...) returns LOC with the highest indexes in S1, S2... for each element in A that is
%                              a member of S1, S2... . For those elements of A that do not occur in S1, S2... 
%                              returns 0.
%                              LOC shape depends on A and is the same as TF (see first syntax).
%
%
% EXAMPLES: 
%   - Retrieve TF and LOC index arrays for elements of "a" in sets "s1" and "s2"
%
%       a  =  1:5   ;
%       s1 = (3:9).';
%       s2 = -1:4   ;
%
%       [tf loc] = ismemberm(a, s1, s2)
%       tf =
%           0     1
%           0     1
%           1     1
%           1     1
%           1     0
%       loc = 
%           0     3
%           0     4
%           1     5
%           2     6
%           3     0
%   - Retrieve TF and LOC index arrays for rows of "a" in sets "s1" and "s2"   
%       
%       a  = [ 1:5 ;11:15];
%       s1 =   6:10;
%       s2 = [16:20;11:15];
% 
%       [tf loc] = ismemberm(a, s1, s2,'rows')
%       tf =
%           0     0
%           0     1
%       loc =
%           0     0
%           0     2
%     
% NOTE: the n-th column of TF/LOC referes to the n-th set as listed in the syntax.
%
% Additional features:
% - <a href="matlab: web('http://www.mathworks.com/matlabcentral/fileexchange/28341','-browser')">FEX set functions page</a>
%
% See also: ISMEMBER, INTERSECTM, SETDIFFM, SETXORM, UNIONM

% Author: Oleg Komarov (oleg.komarov@hotmail.it) 
% Tested on R14SP3 (7.1) and on R2009b
% 23 jul 2010 - Created
% 30 jul 2010 - Added link to fex

% # inputs
if nargin < 2 
    error('ismemberm:nargin','Not enough input arguments.')
end

% # outputs 
if nargout > 2 
    error('ismemberm:nargout','Too many output arguments.')
elseif nargout == 2
     alsoLoc = true;
else alsoLoc = false;
end

% Check for 'rows' flag
IDXflag = strcmp('rows',varargin);
if any(IDXflag)
    flag     = varargin{ IDXflag};
    varargin = varargin(~IDXflag);
    % Check that all inputs have the same number of columns
    if logical(diff(cellfun('size',varargin,2)))
        error('ismemberm:sameNumCols','A, S1, S2... must have the same number of columns.')
    end
else flag = [];
end

% Check same class
if ~cellfun('isclass',varargin(2:end), class(varargin{1}))
    error('ismemberm:sameClass','A, S1, S2... should belong to the same class.')
end

% # of vars A should be tested against
numSets = numel(varargin);
if numSets == 1
    error('ismemberm:noSet','Insufficient inputs: must supply at least one set except A.')
end

% Preallocate Out according to nargout and flag
szA = size(varargin{1});
if ~isempty(flag); szA(2) = 1; end
            Out(1,1:numSets-1) = {false(szA)};
if alsoLoc; Out(2,1:numSets-1) = {zeros(szA)}; end

% LOOP ismember
for col = 1:numSets-1
    [Out{:,col}] = ismember(varargin{1}, varargin{col+1}, flag);
end

% Assign output
if isvector(Out{1}) 
                    tf  = reshape([Out{1,:}], max(szA),[]);
    if alsoLoc;     loc = reshape([Out{2,:}], max(szA),[]); end
else
                    tf  = Out(1,:);
    if alsoLoc;     loc = Out(2,:);                         end
end
end