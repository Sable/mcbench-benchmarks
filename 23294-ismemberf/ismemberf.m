function varargout = ismemberf(A, S, varargin)
% function tf = ismemberf(A, S)
% [tf loc] = ismemberf(A, S)
%
% Purpose: Floating-point set member (i.e., with round-off tolerance)
%
% ISMEMBERF(A,S) for array A returns a logical array of the same size than
% A, contains TRUE for elements membership of set S.
% 
% As opposed to Matlab buit-in function ISMEMBER (without trailing "F")
% which uses strict exact comparison between floats, ISMEMBERF allows some
% small tolerance while comparing elements of A and S.
%
% [TF,LOC] = ISMEMBERF(...) also returns an array LOC containing the
% index in S for each element in A which is a member of S and 0
% if there exists no such index.
% NOTE: The index corresponds to largest element of S within the tolerance.
%       In case of drawing, the largest index is returned.
%
%   ISMEMBERF(A, S, 'row') operates on rows of A and S (2D arrays)
%      and returns true (1) if they match, false (0) otherwise.
%   ISMEMBERF(..., 'tol', tol) select a suitable the tolerance
%        - tol can be scalar or vector (using with 'row')
%        - When tol is vector, each element is applied to a specific 
%          column of A and S
%        - If not provided, or NaN, tol is 1e-10 relative to variations
%          and amplitude of S values (separated for each column of S;
%          assuming both entries are double)
%        - If one of the entry is single, the default tol is lowered to
%          1e-5 (relative)
%        - When tol is provided as zero, ISMEMBERF calls Matlab ISMEMBER()
%        - x is member of S if there is an element S(loc) such that
%               S(loc)-tol <= x < S(loc)+tol
%
% Examples:
%
% [tf, loc]=ismemberf(0.3, 0:0.1:1) % <- This returns 0 by ISMEMBER
%
% [X Y]=meshgrid(0:0.1:10,0:0.1:10);
%  S=[3 1;
%     3 3;
%     5 6;
%     5.2 5.5;
%     3 3];
% A = [X(:) Y(:)];
% [tf loc]=ismemberf(A, S, 'row', 'tol', 0.5);
% imagesc(reshape(loc,size(X)));
%
% See also: ismember
%
% Author: Bruno Luong <brunoluong@yahoo.com>
%   Original: 15/March/2009
%   16/Mar, extend ISMEMBERF to complex arrays
%   19/Mar: Rework on the engine with 'row' option
%           Change default tol parameter
%   10/Oct: Correct bug incorrect result for ismember([0 1],0) (line #271)
%   13/Oct: change H1 line, correct a minor Bug
%   23/Oct/2010: change H1 line
%                replace soon-deprecated "strmatch" with "strncmpi"

% Call the native Matlab ismember for strings
if ~isnumeric(A) || ~isnumeric(S)
    out = cell(1,max(nargout,1));
    [out{:}] = ismember(A, S, varargin{:});
    varargout = out;
    return
end

% Preprocess the optional inputs (for parsing later on)
vin = varargin;
for k=1:length(vin)
    if ischar(vin{k})
        vin{k} = strtrim(lower(vin{k}));
    else
        vin{k}='';
    end
end

% parsing the varargin to set tol
tol = NaN; % <- automatic tolerancce, see ismember1 bellow
tolloc = strncmpi('tol', vin, 3);
if any(tolloc)
    tolloc = find(tolloc,1,'last');
    if length(vin)>=tolloc+1
        tol = varargin{tolloc+1};
        if ~isnumeric(tol)
            error('tolerance must be a number');
        end
    else
        error('tolerance value is not provided');
    end
end

% No tolerance, call Matlab ismember for array
if all(tol==0)
    out = cell(1,max(nargout,1));
    % Remove tolerance parameters, not supported by Matlab
    v=varargin;
    v(tolloc:tolloc+1)=[];
    [out{:}] = ismember(A, S, v{:});
    varargout = out;
    return    
end

% Check if linear is member or with row option (multi dimensional)
is1Dmember = ~any( strncmpi('row', vin, 3)); % 'rows' also work

% Complex ismemberf
if ~isreal(A) || ~isreal(S)
    out = cell(1,max(nargout,1));
    if is1Dmember
        sizeA = size(A);
        A = A(:);
        S = S(:);
        argin = [varargin {'row'}];
    else
        argin = varargin;
    end
    % Same tolerances for real and imag
    if length(tol)>1
        tol = repmat(reshape(tol,1,[]),1,2); % duplicate
        argin = [argin {'tol' tol}]; % append to the end (upper priority)
    end
    % Call recursively ismemberf with doubling dimensions
    % from real and imag parts of input arrays
    [out{:}] = ismemberf([real(A) imag(A)], [real(S) imag(S)], argin{:});
    if is1Dmember % Reshape all the results same size as A
        out = cellfun(@(x) reshape(x, sizeA), out, 'UniformOutput', false);
    end
    varargout = out;
    return % break
end

% Work on real array from here

% one dimensional ismember
if is1Dmember
    
    [tf loc] = ismember1(A, S, tol);
    
else % 'row' option
    % Check fo compatible dimension
    if ndims(A) ~= 2 || ndims(S) ~= 2 % Thank you Jan for reporting the bug
        error('A and S must be 2-dimensional arrays');
    end
    if size(A,2) ~= size(S,2)
        error('A and S must have the same number of columns');
    end
    if isempty(S) % Few exception cases
        tf = false(size(A,1),1);
        loc = zeros(size(tf));
        if size(S,2)==0 % Hah, compare a 0-dimensional set is always true
            tf(:) = true;
            loc(:) = 1;
        end
    else % S must not be empty
        % duplicate tol if necessary
        if isempty(tol)
            tol = nan(size(A,2),1);
        elseif isscalar(tol)
            tol(1:size(A,2)) = tol;
        end
        
        % Loop over column (dimension)
        for j=1:size(A,2)            
            if j==1 % first iteration
                % Get the binary matrix
                [iA iS] = ismember1(A(:,j), S(:,j), tol(j), 1);
            else % sucessive iterations   
                
                % Work on subset of A and S only
                [subA locA] = sunique(iA, true); % iA, locA is sorted
                [subS locS] = sunique(iS, false); % iS is not
                
                [iAj iSj] = ismember1(A(subA,j), S(subS,j), tol(j), 1);
                
                % Get points that are not in the braket in j-dimension
                n = numel(subS);
                % locS+locA*n = sub2ind([n somevalue], locS, locA+1) 
                izero = ssetdiff(locS+locA*n, iSj+iAj*n);
                % Remove those points
                iA(izero) = [];
                iS(izero) = [];
            end % j==1
        end % for-loop
        
        tf = false(size(A,1),1);
        tf(iA) = true;
        if isempty(iS)
            loc = zeros(size(tf));
        else
            % iA is sorted
            jump = find(diff([0; iA(:)]));
            last = [jump(2:end)-1; length(iA)];
            loc = zeros(size(tf));
            loc(iA(last))=iS(last);
        end % if isempty(iS)
    end % if empty(S)
end % 'row' option

% Process output
[out{1:2}] = deal(tf, loc);
nout = min(max(nargout,1), length(out));
varargout(1:nout) = out(1:nout);

end % ismemberf

%%%%%%%%%%%%%% private subfunctions

function [sub loc] = sunique(S, Ssorted)
% Doing unique, but optimized when S is sorted
%   sub is unique set representation if S
%   and loc such that: S = sub(loc)

if ~Ssorted
    %[sub dummy loc] = unique(S);
    %return
    [S is]= sort(S(:));
else
    S = S(:);
end

% 
I = find(diff([0; S(:)]));
sub = S(I);
loc = zeros(size(S));
loc(I) = 1;
loc=cumsum(loc);

if ~Ssorted
    loc(is)=loc;
end
end % sunique

function izero = ssetdiff(I, Ij)
% setdiff or two sorted sets of indices
% return boolean flag 'izero' only
if isempty(Ij);
    izero=true(size(I));
else
    Ij = sort(Ij);
    [dummy bin] = histc(I, Ij); %#ok
    I(bin==0) = 0; % set to value not belong to Ij, 0 is OK
    bin(bin==0) = 1; % to avoid indice error for the comparison (next line)
    izero = (Ij(bin) ~= I);
end
end % ssetdiff

function tol = defaulttol(A, S)
if strcmp(class(A),'single') || strcmp(class(S),'single')
    tol = single(1e-5);
else
    tol = 1e-10;
end
end % defaulttol


% Nested function, working linearly  
function varargout = ismember1(A, S, tol, extended) %#ok
%
% [tf loc] = ismember1(A, S, tol)
% [iA iS] = ismember1(A, S, tol, 1)
%

    % Work only on subset of S, Su is sorted
    [Su I J] = unique(S(:),'last');
    
    % Set the tolerance automatically
    if isempty(tol) || isnan(tol)
        if isempty(Su)
            tol = 0;
        else
            maxS = max(Su);
            minS = min(Su);
            if maxS == minS
                % Bug corrected, was dS = 0, thank you David
                dS = realmin(class(S));
            else
                dS = (maxS - minS);                
            end
            Samp = max(abs([minS maxS]));
            tol = max(dS,Samp)*defaulttol(A, S);
        end
    else
        tol=tol(1);
    end
    
    % Take a braket [-tol,tol] round each element
    xlo = Su - abs(tol);
    xhi = Su + abs(tol);
    % Look where points in A are located
    [dummy ilo] = histc(A, [xlo; Inf]); %#ok
    [dummy ihi] = histc(A, [-Inf; xhi]); %#ok
    % Test if they belong to the bracket
    tf = ilo & ihi & (ilo >= ihi);
     
    %
    % Building a logical matrix of boolean B of size (m x n)
    % where m = numel(S), n = numel(A),
    % B(i,j) is TRUE if two elements in S(i) and A(j) are "identical"
    %
    if nargin<4
        % ilo is the last indice
        loc = zeros(size(tf));
        loc(tf) = I(ilo(tf));
        varargout = {tf loc};
    else % extended
        
        if isempty(A)
            iS = [];
            iA = [];
            varargout = {iA iS};
            return
        end
        % index in S
        % Group all the index of S when they map to the same Su
        left = ihi(tf);
        right = ilo(tf);
        
        % Find the index in S, duplicated by number of elements in A
        % belong to it
        [iS nele] = getiS(left(:), right(:), J);
        
        % index in A
        % This is a trick to generate the same vector long as iS
        % with a ids (1, 2, 3...) repeated for each cell elements (of
        % length nele)
        iA = cumsum(accumarray(cumsum([1; nele]),1));
        inonly = find(tf);
        iA = inonly(iA(1:end-1));  % iA is already sorted
        
        varargout = {iA(:) iS(:)};
    end % if nargout>=3
    
end % ismember1

function [Jcat subsetlengths] = Jsubset(J)
% J is an array coming from the third argument of UNIQUE (mapping index)
% JSUBSET groups the mapping J by subset (concatenated in Jcat), each set
%    Sk has the length stored in subsetlengths(k), k=1,2,....
%    The subsets will be sorted by k.
% In other word, perform equivalent to the following:
%   (but optimized for speed)
%     JJ = accumarray(J(:), (1:numel(J)).', [max(J) 1], @(x) {x});
%     Jcat = cat(1,JJ{:});
%     subsetlengths = cellfun(@length, JJ)

% Sorting then some clever diff and cumsum!!
[Js Jcat] = sort(J(:));
jump = find(diff([0; Js(:)]));
last = zeros(Js(end),1);
last(Js(jump)) = diff([jump; length(J)+1]);
subsetlengths = diff([0; cumsum(last)]);

end % Jsubset

function [v csl] = catbraket(l, r)
% Concatenate I1:=(l(1):r(1))', I2=(l(2):r(2)', etc ... 
%             in v = [I1; I2; ... ]
% Note: at the entrance r(i) must be l(i)-1 for empty braket

    if isempty(l)
        v = [];
        csl = 1;
        return
    end
    
    l=l(:);
    r=r(:);
    csl=cumsum([0; r-l]+1);

    v = accumarray(csl(1:end-1), (l-[0; r(1:end-1)]-1));
    % Adjust the size of v
    sv = csl(end)-1; % wanted length
    if size(v,1)>sv
        v(sv+1:end)=[];
    elseif size(v,1)<sv % pad zeros
        v(sv)=0;
    end
    v = cumsum(v+1);
    %[l r v]
end % catbraket

function [iS nele] = getiS(left, right, J)
% Do this (but avoid using cell to improve speed)
% iS = arrayfun(@(l,r) cat(1,JJ{l:r}).', left, right, ...
%                       'UniformOutput', false);
%        nele = cellfun(@length, iS);
%        iS = [iS{:}]; % concatenate in a long row vector
% This is awfully hard to read, because of the optimization
    
    [Jcat subsetlengths] = Jsubset(J);
    % Do the following
    % is1 = arrayfun(@(l,r) (l:r).', left, right, ...
    %                       'UniformOutput', false);
    % is1 = cat(1,is1{:});
    [is1 csl] = catbraket(left, right);  
    
    % Compute the length of each subset in iS
    % nele(k) will be length of cat(1,JJ{left(k):right(k)})
    csJJis = cumsum([0; subsetlengths(is1)]);
    nele = csJJis(csl(2:end))-csJJis(csl(1:end-1));
    
    % Build the left/right brakets when JJ cells will be expanded
    ss=cumsum([0; subsetlengths])+1;
    l=ss(is1);
    r=ss(is1+1)-1;  
    
    % Last step, concatenate JJ and retrieve data in the braket
    % 
    iS = Jcat(catbraket(l, r));

end % getiS
