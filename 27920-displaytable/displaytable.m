function displaytable(data,headings,labels,cellsize,decimalsize,permutation,cellindices,cellcolors)
%
% Prints out a condensed, legible N-dimensional data table with dimension
% headings and variable cell width and precision. 
%
% Entries can be highlighted with color using the cprintf function available 
% on Matlab Central.
%
% data is an n-dimensional array
% headings {'Row' 'Column'} is a cell array containing the name of each dimension.
% labels {{1 2 3} {4 5 6}} is a cell array containing lists of values for each dimension.
%   each element of labels can be either: 
%     cell array of strings; 
%     cell array of numbers; 
%     array of numbers.
% 
% cellsize (optional, default 6) is the width of each displayed cell
% decimalsize (optional, default 2) is the number of decimal places
%   displayed in each cell
%
% permutation [3 4 1 2] describes the ordering of dimensions in the final
%   displayed table. Data, headings, and labels are all permuted accordingly
%
% cellindices [m x ndim]: m n-dimensional tuplets containing the indices of
%   entries to be highlighted
% cellcolors [m x 3]: [R,G,B] color tuplets for entries to be highlighted
%
% Matt Caywood
%
%   Versions:
% 0.1:  2010.06.16 Initial version
% 0.2:  2010.06.29 Fixed degenerate tables with dimension values = 1
% 0.3:  2010.07.15 Added convenient table permutations
% 0.31: 2010.07.16 Fixed dimension error checking
% 0.4:  2010.07.20 Added color highlighting of entries using cprintf
% 0.41: 2010.07.21 Fixed header spacing
% 0.42: 2011.03.08 Worked around -0 issue in printf

% displaytable(rand(5,5),{'1' '2'},{{'C1' 'C2' 'C3' 'I1' 'I2'},{'C1' 'C2' 'C3' 'I1' 'I2'}})

global cellwidth decimalplaces cellformat myprintf;

%% check input valid
if ~isnumeric(data), error('displaytable:NotNumeric','Data must be numeric.'); end
if ~isreal(data), error('displaytable:NotReal','Data must contain only real elements.'); end

% use headings as canonical length, because matlab ignores singleton trailing dimensions in data
nd = length(headings);
dims = size(data);

if any(dims == 0), fprintf('[]\n'); return; end % some dimension is zero
if ndims(data) > nd, error('displaytable:headings','Not enough headings for data.'); end
if length(labels) ~= nd, error('displaytable:headings','Headings and labels are different lengths.'); end
for i = 1:nd
    % accept singleton trailing dimensions
    if ~( (i > length(dims) && 1 == length(labels{i})) || (dims(i) == length(labels{i})) )
       error('displaytable:labels','Label list #%d (%s) is wrong length for data.',i,headings{i}); 
    end
end    

%% create cell format string
if ~exist('cellsize','var'), cellwidth = 6; else cellwidth = cellsize; end
if ~exist('decimalsize', 'var'), decimalplaces = 2; else decimalplaces = decimalsize; end

assert(cellwidth > decimalplaces+1);
cellformat = ['%' int2str(cellwidth-(decimalplaces+1)) '.' int2str(decimalplaces) 'f'];

%% normalize labels to cell array of strings
for i = 1:nd
    if ~iscell(labels{i}), labels{i} = num2cell(labels{i}); end
    for j = 1:length(labels{i})
        if isnumeric(labels{i}{j}), labels{i}{j} = num2str(labels{i}{j}); end
    end
end

%% Use cprintf if available and cellindices specified, otherwise builtin fprintf
myprintf = @(col,fmt,varargin) fprintf(fmt,varargin{:});

if ~exist('cellindices','var')
    cellindices = [];
    cellcolors = [];
else
    assert(size(cellindices,2) == nd,'Cellindices have wrong dimensions.');
    if ~exist('cprintf','file')
        fprintf('WARNING: cprintf not found, colors will not be shown!\nPlease download cprintf from Matlab Central:\nhttp://www.mathworks.com/matlabcentral/fileexchange/24093\n');
    else
        myprintf = @cprintf;
        if ~exist('cellcolors','var')
            cellcolors = repmat([1 0 0],[size(cellindices,1) 1]); % default red
        else
            assert(size(cellcolors,2) == 3,'Colors must be RGB triplets');
            assert(size(cellcolors,1) == size(cellindices,1),'Colors must be equal length to indices');
        end
    end
end

%% permute table
if exist('permutation','var') && ~isempty(permutation)
    assert(length(permutation) == nd,'Wrong permutation length.');
    data = permute(data,permutation);
    headings = {headings{permutation}};
    labels = {labels{permutation}};
    
    if ~isempty(cellindices)
        for m = 1:size(cellindices,1)
            cellindices(m,:) = cellindices(m,permutation);
        end
    end
end

% recurse to print out all tables
displaytable_helper(data,headings,labels,cellindices,cellcolors);

end

%% recursion helper
function displaytable_helper(data,headings,labels,cellindices,cellcolors)

global myprintf;

nd = ndims(data); % nd always >= 2

if (nd == 2) % 1D row or column vector, or 2D matrix
    display2dtable(data,headings,labels,cellindices,cellcolors);
    
else % nd > 2
    title = headings{1};
    sublabels = labels{1};
    labelchars = maxchars(sublabels);

    nidx = size(data,1);
    remainingdims = size(data); remainingdims = remainingdims(2:nd);
    for subscr = 1:nidx
        
        whichidx = cell(1,nd);
        whichidx{1} = subscr; 
        for i = 2:nd; whichidx{i} = ':'; end
        subs.type = '()';
        subs.subs = whichidx;
        subtab = subsref(data,subs);
        subtab = reshape(subtab,remainingdims);

        myprintf('text','%s = %s\t\n',title,truncpadstring(sublabels{subscr},labelchars));
        if isempty(cellindices), passindices = [];
        else passindices = (cellindices(:,1) == subscr); 
        end
        displaytable_helper(subtab,headings(2:end),labels(2:end),cellindices(passindices,2:end),cellcolors(passindices,:));
    end
end
end

%% base case
function display2dtable(data,headings,labels,cellindices,cellcolors)

assert(~isempty(headings));
assert(nargin >= 3,'Need row, column labels');
assert(nargin == ndims(data) + 3,'Wrong # arguments');

[nrow,ncol] = size(data);

global cellformat cellwidth decimalplaces myprintf;

if length(headings) == 1
    % handle degenerate 1 x n, n x 1 cases
    if (ncol == 1)
        colheading = '';
        collabels = cell(size(data));
        rowheading = headings{1};
        rowlabels = labels{1};
    elseif (nrow == 1)
        colheading = headings{1};
        collabels = labels{1};
        rowheading = '';
        rowlabels = cell(size(data));
    end
else
    rowheading = headings{1};
    rowlabels = labels{1};
    colheading = headings{2};
    collabels = labels{2};
end

rowchars = max(3,maxchars(rowlabels));

% squeeze dimension label into row label space
dimchars = max(1,floor(rowchars/2));
dim = [truncpadstring(rowheading,dimchars) '/' truncpadstring(colheading,dimchars)];

% display header
myprintf('text',dim);
for i = 1:ncol
    myprintf('text',' %s',truncpadstring(collabels{i},cellwidth));
end
myprintf('text','\n');

% display rows
for j = 1:nrow
    myprintf('text',truncpadstring(rowlabels{j},rowchars));
    for i = 1:ncol
        
        if isempty(cellindices)
            idx = [];
        else
            idx = find(cellindices(:,1) == j & cellindices(:,2) == i);
            if ~isempty(idx), idx = idx(1); end % use first only
        end

        % clean up the rounding a bit so "-0.00" never appears, only "0.00"
        roundeddata = fround(data(j,i),decimalplaces);
        if (roundeddata == 0), roundeddata = 0; end % this gets rid of floating point -0

        if isempty(idx)
            myprintf('text',' %s',truncpadstring(sprintf(cellformat,roundeddata),cellwidth));
        else
            myprintf(cellcolors(idx,:),' %s',truncpadstring(sprintf(cellformat,roundeddata),cellwidth));
        end
    end
    myprintf('text','\n');
end

end

%% -----------------
function n = maxchars(c)
% find maximum length in characters of strings in cell array

n = 0;
for i = 1:length(c)
    n = max(n,length(c{i})); 
end

end

%% -----------------
function ps = truncpadstring(s,n)
% fit string s into n characters

if length(s) > n
    ps = s(1:n);
else
    ps = sprintf(['%' num2str(n) 's'],s);
end

end

%% -----------------
function b = fround(a,n)
% fix-round

if ~exist('n','var'), n = 0; end

b = round(a*10^n)/10^n;

end
