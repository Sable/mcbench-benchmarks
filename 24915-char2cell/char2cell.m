function s = char2cell(s,delim,rowseparate,trim)
% Syntax: cellmat = char2cell(s,delim,rowseparate,trim);
%   cellmat = char2cell(s,delim,rowseparate);
%   cellmat = char2cell(s,delim);
%   cellmat = char2cell(s);
% CHARacter array 2(to) CELL array conversion.
%   "s" - Input character array or cell array of strings.
%   "delim" - Array or cell array of delimiters. 
%       If an array then each element is a single element delimeter.
%       If a cell array then each cell element is a delimeter or multi-element delimeter.
%       The following may be used for non-printing characters:
%       (as these characters require 2 elements, they must be specified in a cell array)
%           \b - backspace
%           \f - formfeed
%           \n - linefeed
%           \r - carriage return
%           \t - tab
%           \\ - backslash 
%           (a single \ suffices if it is a single or last element)
%           Use ' ' to specify a white space character.
%       Default delimiter is white space if "rowseparate" is empty and is empty 
%       if "rowseparate" is either "true" or "false".
%   "rowseparate" - "true" designates that each row should be separated or
%       "false" if each column should be separated. Only relevant if "s" is
%       multidimensional. Higher dimensions are wrapped into rows or columns
%       depending upon "rowseparate". If "empty", then all matrices are treated as 1D.
%       e.g. a KxMxN matrix is treated as a Kx(MxN) matrix if "false"
%           or as a Mx(KxN) if "true".
%       If a delimeter(s) is specified then both conditions are used.
%       "rowseparate" is ignored if "s" is a cell array.
%   "trim" - if "true" (default), leading and trailing spaces are deleted 
%   "cellmat" - Output (1D) cell array.   
%
%   See Also: cellstr, mat2cell, num2cell, cell2mat
%   Examples:
%       char2cell(['red? green33 blue++  '],['?3+']))
%       ans =     'red'; 'green'; 'blue'; ''
%       c=sprintf(['this is a test\nthis\tis the second line'])
%       char2cell(c,{'\n','\t'})
%       ans =       'this is a test'
%                   'this'
%                   'is the second line'

%   Copyright 2009 Mirtech, Inc.
%   Created by Mirko Hrovat     07/17/2009
%   Inspired by str2cell.m (File Exchange #4247) by us
%------------------------------------------------------------------------------------

ws = ' ';   % whitespace
bspc = 8;   % \b
ff = 12;    % \f
lf = 10;    % \n
cr = 13;    % \r
tb = 9;     % \t
bs = 92;    % \\
del = 127;  %#ok - currently not used, delete
spc = 32;   % space
bell = 8;   %#ok - currently not used, bell
def_delim   = ws;       % default delimiter
def_trim    = true;     % default trim value
switch nargin
    case 4
    case 3
        trim = [];
    case 2
        trim = [];      rowseparate = [];
    case 1
        trim = [];      rowseparate = [];       delim = [];
    otherwise
        error ('  Number of input arguments incorrect!')
end
if isempty(trim),       trim = def_trim;        end
if ~ischar(s)&&~iscellstr(s),
    error ('  Input array must be a character or cell string  array!')
end
if ~iscellstr(s),
    if isempty(rowseparate) || size(s,1)==1 || size(s,2)==1,
        s = shiftdim(s(:),-1);          % convert to row of characters
        rowseparate = [];
    else
        if ~rowseparate,
            s = permute(s,[2,1]);
        end
        s = s(:,:);                     % make s a 2D array
        s = cellstr(s);                 % now convert rows to cells
    end
    if isempty(rowseparate) && isempty(delim),
        delim = def_delim;
    end
else
    if isempty(delim),      delim = def_delim;      end
end
if ~isempty(delim),
    if ~iscell(delim),  delim = num2cell(delim);    end
    strtidx = [];
    stopidx = [];
    for n = 1:numel(delim),
        mpts = numel(delim{n});
        searchchar = char(ones(1,mpts)*spc);
        m = 0;
        nschars = 0;
        while m < mpts,
            m = m + 1;
            curchar = delim{n}(m);
            if curchar=='\'
                m = m + 1;
                if m <= mpts,
                    curchar = delim{n}(m);
                    switch curchar
                        case 'b'    % backspace
                            curchar = char(bspc);
                        case 'f'    % formfeed
                            curchar = char(ff);
                        case 'n'    % linefeed
                            curchar = char(lf);
                        case 'r'    % return
                            curchar = char(cr);
                        case 't'    % tab
                            curchar = char(tb);
                        case '\'    % backslash
                            curchar = char(bs);
                        otherwise
                            error('  Special character not recognized, e.g. \n !')
                    end
                else    % backslash is a single element or is last element
                    curchar = char(bs); % so intepret it as a backslash
                end
            end
            nschars = nschars + 1;
            searchchar(nschars) = curchar;
        end
        searchchar(nschars+1:end) = [];
        tmp = strfind(s,searchchar);        % find matching indices
        if iscell(tmp),
            stopidx = strcat(stopidx,tmp);      % combine results
            tmp2 = num2cell(ones(size(s))*nschars);
            % add delimiter length to get next starting indices
            tmp2 = cellfun(@plus,tmp,tmp2,'UniformOutput',false); 
            strtidx = strcat(strtidx,tmp2);     % combine results
        else
            stopidx = [stopidx,tmp];            %#ok combine results
            tmp2 = tmp + nschars;               % add delimiter length
            strtidx = [strtidx,tmp2];           %#ok 
        end
    end
        
    % now use strt and stop idx to create cells
    if iscell(s),
        ncells = sum(cellfun(@numel,strtidx));  % find total number of indices
        scells = size(s,1);
        tmp = cell(ncells,1);
        count = 0;
        for m = 1:scells,
            startpt = 1;
            strt = sort(strtidx{m});
            stop = sort(stopidx{m});
            for p=1:numel(strt),
                if stop(p)>startpt,
                    count = count + 1;
                    tmp{count} = s{m}(startpt:stop(p)-1);
                end
                startpt = strt(p);
            end
            if startpt <= numel(s{m}),      % need to extract the rest of the array
                count = count + 1;
                tmp{count} = s{m}(startpt:end);
            end
        end
    else            % s is not a cell array
        strt = sort(strtidx);
        stop = sort(stopidx );
        ncells = numel(strtidx);
        tmp = cell(ncells+1,1);
        startpt = 1;
        count = 0;
        for m = 1:ncells
            if stop(m) > startpt,
                count = count + 1;
                tmp{count}= s(startpt:stop(m)-1);   
            end
            startpt = strt(m); 
        end
        if startpt <= numel(s),     % need to extract the rest of the array
            count = count + 1;
            tmp{count} = s(startpt:end);
        end
    end
    s = tmp(1:count);
end
if trim,
    s = strtrim(s);
end