function [Out,rowHead,colHead, Settings] = Pivot(In,Fun,noHeaders,Pad)

% PIVOT Group a flat dataset (m by 3 matrix) into a pivot table
% 
%   PIVOT(IN) Other inputs by default
%       - In: single/double or cell (2 D). Size m by 3: two header columns and a value column.
%              -- 1st column --> Row headers of the pivot table.
%              -- 2nd column --> Column headers of the pivot table
%              -- 3rd column --> Values of the pivot table. Single/double scalars.
%         Headers can be a cell array of strings or scalars. 
%         NaNs and empty or nested cells are not admitted.
%
%   PIVOT(IN,FUN) Add function handle
%       - Fun: function handle which returns scalars from vector input. 
%              Applies only to values found on the same position. 
%              If empty see default (below).
%
%   PIVOT(IN,FUN,NOHEADERS) Return table without the headers
%       - noHeaders: can be logical or [0,1]. If empty see default (below).
%
%   PIVOT(...,PAD) Pad empty values
%       - Pad: numeric, NaN or char 1 by m.
%
%   [OUT,ROWHEAD,COLHEAD,SETTINGS] = ...
%       - Out: numeric or cell pivot table. If noHeader, Out is the matrix of values.
%                -- 1st row: unique values in asc order of the 1st column of In
%                -- 1st col: unique values in asc order of the 2nd column of In
%                -- values (2:end,2:end): values of the 3rd column of In positioned on the right 
%                                         itersection between the two headers.
%       - rowHead and colHead: unique values of the 1st and 2nd column of In.
%       - Settings: settings used to build the pivot table
%
%   DEFAULT SETTINGS:
%       - Fun = @sum 
%       - noHeader = false;
%       - Pad = NaN;
%
% Additional features:
% - <a href="matlab: web('http://www.mathworks.com/matlabcentral/fileexchange/26119-pivotunpivot','-browser')">FEX Pivot/unPivot page</a>
% - <a href="matlab: web('http://www.mathworks.com/matlabcentral/fileexchange/19730-cell2float','-browser')">FEX cell2float by Jos(10584)'s page</a>
%
% See also UNPIVOT, ACCUMARRAY

% Author: Oleg Komarov (oleg.komarov@hotmail.it)
% 16 dec 2009 - created
% 20 dec 2009 - Compatibility from 7.1; added link to the submission

% ------------------------------------------------------------------------
% CHECK
% ------------------------------------------------------------------------

% #Ninput & #Noutput
error(nargchk(1,4,nargin));
error(nargoutchk(0,4,nargout));

% In 
if size(In,2) == 3 
    Col1 = In(:,1); Col2 = In(:,2); Col3 = In(:,3);
    clear In
else error('Pivot:inFmt','IN must be a n by 3 matrix');    
end

% Col1
if iscell(Col1)
    numCol1 = false;
    if any(cellfun('isempty',Col1))
        error('Pivot:inFmt','Column 1, empty cell not allowed'); 
    elseif ~iscellstr(Col1)
        try Col1 = cell2floatmod(Col1); 
            if any(isnan(Col1)); error('Pivot:inFmt','Column 1, NaNs not allowed'); end
            numCol1 = true; 
        catch err
            if strcmp('Pivot:inFmt',err.identifier); error(err.message); 
            else error('Pivot:inFmt','IN can be numeric or a cell array of strings or numbers'); 
            end
        end 
    end
elseif isnumeric(Col1); numCol1 = true;
    if any(isnan(Col1)); error('Pivot:inFmt','Column 1, NaNs not allowed'); end
else error('Pivot:inFmt','IN can be numeric or a cell array of strings or numbers'); 
end

% Col2
if iscell(Col2) 
    numCol2 = false; 
    if any(cellfun('isempty',Col2))
        error('Pivot:inFmt','Column 2, empty cell not allowed'); 
    elseif ~iscellstr(Col2)
        try Col2 = cell2floatmod(Col2); 
            if any(isnan(Col2)); error('Pivot:inFmt','Column 1, NaNs not allowed'); end
            numCol2 = true; 
        catch err
            if strcmp('Pivot:inFmt',err.identifier); error(err.message); 
            else error('Pivot:inFmt','IN can be numeric or a cell array of strings or numbers'); 
            end
        end 
    end
elseif isnumeric(Col2); numCol2 = true;
    if any(isnan(Col2)); error('Pivot:inFmt','Column 2, NaNs not allowed'); end
else error('Pivot:inFmt','Headers can be numeric or a cell array of strings or numbers'); 
end

% Col3
if iscell(Col3)
    if ~iscellstr(Col3)
        try Col3 = cell2floatmod(Col3);
        catch %#ok
            error('Pivot:inFmt','Column 3 should be a cell array of scalars')
        end
    end
else 
end

% Fun
defFun = false;
if nargin == 1 || isempty(Fun)
    defFun = true;
    Fun = @sum;
elseif ~isa(Fun,'function_handle')
    error('Pivot:funFmt','FUN invalid format');
end

% noHeaders 
if nargin < 3 || isempty(noHeaders)
    noHeaders = false;
elseif  ~isscalar(noHeaders) || ~(islogical(noHeaders) || (noHeaders == 1 || noHeaders == 0))
    error('Pivot:noHeadersFmt','NOHEADERS invalid format');
end

% Pad
if nargin < 4 || isempty(Pad) 
    Pad = NaN;
elseif (ischar(Pad) && size(Pad,1) > 1) || (isnumeric(Pad) && ~isscalar(Pad))
    error('Pivot:padFmt','PAD invalid format');
end

% ------------------------------------------------------------------------
% ENGINE
% ------------------------------------------------------------------------

% Row header & Column header
rowHead = unique(Col1);
colHead = unique(Col2);

% Size Out
sz = [size(colHead,1) size(rowHead,1)];

% Index the output against the headers
[trash, colOut] = ismember(Col1, rowHead); %#ok
[trash, rowOut] = ismember(Col2, colHead); %#ok
IDX = sub2ind(sz, rowOut, colOut);

% [1] Grouping required
if any(accumarray(IDX,1) > 1)
    try Out = accumarray([rowOut colOut], Col3,[],Fun);
        if defFun
            warning('warnPivot:funGroup','%s is being used as grouping function', upper(func2str(Fun)));
        end
    catch %#ok
        error('Pivot:funFmt','%s is not supported for grouping operations.', upper(func2str(Fun)));
    end
% [1] Grouping NOT required    
else
    Out = zeros(sz,'double');
    Out(IDX) = Col3;
    Fun = 'not employed';
end % [1]

% Positions to Pad
toPad = 1:prod(sz);
toPad(IDX)=[];

% IF cell output
if ~(numCol1 && numCol2 && ~ischar(Pad)) && (~isempty(toPad) || ~noHeaders)
    Out = num2cell(Out); Pad = {Pad};
    if numCol1; rowHead = num2cell(rowHead); end
    if numCol2; colHead = num2cell(colHead); end
end

% Pad empty values
if ~isempty(toPad) && (iscell(Pad) || ischar(Pad) || Pad ~= 0);
    Out(toPad) = Pad; 
end

% Add headers
if ~noHeaders; Out = [[NaN; colHead] [reshape(rowHead,1,[]); Out]]; 
 
end

% Settings output
if nargout == 4
    Settings = struct('Aggregation_function', Fun,'With_headers',~noHeaders,'Padded_with', Pad);
end
end

% Short version of the Jos(10584)'s cell2float (faster than cell2mat)
function Out = cell2floatmod(In)
% first input should be cell array
if ~iscell(In), 
   error('cell2float:BadInput','First input should be a cell array') ; 
end
% Check if all of the same type
if nnz(~cellfun('isclass',In,class(In{1}))) > 0
    error('All contents of C must be of the same data type.')
end
% pre-allocate the matrix with NaN
Out = NaN(size(In));
% which cell elements are scalar doubles or singles?
Q = cellfun('prodofsize',In)==1 & ...
    (cellfun('isclass',In,'double') | cellfun('isclass',In,'single')) ;
% put these in Out in the corresponding locations
Out(Q) = [In{Q}];
end