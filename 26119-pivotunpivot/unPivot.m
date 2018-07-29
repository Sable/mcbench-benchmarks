function Out = unPivot(In,dim,rmPad)

% UNPIVOT Ungroup a pivot table into a flat dataset (n m by 3 matrix).
% 
%   UNPIVOT(IN) Else by default
%       - In: cell or numeric pivot table (2-D).
%               -- In(1) must be NaN
%               -- Nested cells are not allowed
%   
%   UNPIVOT(IN, DIM) How to sort output
%       - Dim: scalar, 1 or 2. Respectively sort output by column header or by row header.
%
%   UNPIVOT(IN, DIM, RMPAD) Remove padded values
%       - rmPad: specify which values are considered as padded. 
%                NaN, scalars or char 1 by m.
%
%   OUT = ...
%       - Numeric or cell m by 3 matrix. First two columns, header values. 
%         Sorted by the first column (ex-colHead) if DIM == 1 or by the 
%         second column (ex-rowHead) if DIM == 2.
%
% Additional features:
% - <a href="matlab: web('http://www.mathworks.com/matlabcentral/fileexchange/26119-pivotunpivot','-browser')">FEX Pivot/unPivot page</a>
%
% See also PIVOT

% Author: Oleg Komarov (oleg.komarov@hotmail.it)
% 16 dec 2009 - Created
% 20 dec 2009 - Compatibility from 7.1; added link to the submission
% 22 jan 2010 - Fixed column position in Out (the first was switched with the second) 

% ------------------------------------------------------------------------
% CHECK
% ------------------------------------------------------------------------

% #Ninput
error(nargchk(1,3,nargin));

% In 
if isscalar(In) || isvector(In)
    error('unPivot:inFmt','IN is not a pivot table')
elseif iscell(In)
    if ~isnan(In{1}); error('unPivot:inFmt','IN first element must be NaN'); end
    cellIn = true;
    if any(any(cellfun('isclass', In, 'cell')))
        error('unPivot:inFmt','IN nested cells not admitted')
    end
elseif isnumeric(In); cellIn = false;
    if ~isnan(In(1)); error('unPivot:inFmt','IN first element must be NaN'); end
else error('unPivot:inFmt','IN invalid format')
end

% Dim
if nargin == 1 || isempty(dim); dim = 1;
elseif isnumeric(dim)
    if ~(dim == 1 || dim == 2)
        error('unPivot:dimFmt','DIM must be 1 or 2')
    end
else error('unPivot:dimFmt','DIM invalid format')
end

% rmPad
if nargin < 3 || isempty(rmPad) 
    rmPad = NaN;
elseif ~((isnumeric(rmPad) && isscalar(rmPad)) || (ischar(rmPad) && size(rmPad,1) == 1))
    error('unPivot:dimFmt','RMPAD invalid format')
end

% ------------------------------------------------------------------------
% ENGINE
% ------------------------------------------------------------------------

% Extract main parts
rowHead = In(1,2:end); colHead = In(2:end,1); values = In(2:end,2:end); clear In
sz = size(values);

% Index values to unpivot
IDX = 1:numel(values);

% Flip if sorting by rowHeader
if dim == 2
    IDX = reshape(IDX,sz)';  
    values = values';
end

% Row and column indexes
[row, col] = ind2sub(sz,IDX(:));

% Output
Out = [reshape(rowHead(col),[],1), reshape(colHead(row),[],1),values(:)];
clear rowHead colHead values

% Unpad
if cellIn
    Out(cellfun('isempty', Out(:,end)),:) = [];
    IDXc = find(cellfun('isclass', Out(:,end),'char'));   
    if ~isempty(IDXc)
        Chars = Out(IDXc,end); Out(IDXc,end) = {NaN};
    else Chars = [];
    end
    IDXp = false;
    if ischar(rmPad)
        IDXc(strcmp(rmPad,Chars)) = [];
        Chars = Chars(IDXc);
    elseif ~isnan(rmPad)
        IDXp = cellfun(@(x) rmPad == x, Out(:,end));
    end
        IDXnan = cellfun(@isnan, Out(:,end));
        IDXnan(IDXc) = false;
        if ~isempty(IDXc); Out(IDXc,end) = Chars;end
        Out(IDXnan | IDXp,:) = [];
    else
    if ~ischar(rmPad)
        if ~isnan(rmPad); Out(Out(:,end) == rmPad,:) = []; end
        Out(isnan(Out(:,end)),:) = [];
    end
end
end

