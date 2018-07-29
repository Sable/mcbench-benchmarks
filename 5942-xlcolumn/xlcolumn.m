function loc = xlcolumn(column)

%XLCOLUMN Converts Excel column name to column number and vise versa.
%
% xlcolumn(column)
%
%       column:     Can be either column name (characters) or column
%                   number (positive integers).
%
% NOTE: Excel sheet is limited to 256 columns.  Therefore, column number
%       should be between (1-256) and column name should be between
%       ('A' - 'IV').
% 
% Example:
%   xlcolumn('K')
%   xlcolumn('EQ')
%   xlcolumn(234)
%   xlcolumn(19)

%   Copyright 2004 Fahad Al Mahmood
%   Version: 1.0    $Date: 27-Feb-2004

if isnumeric(column)
    if column>256
        error('Excel is limited to 256 columns! Enter an integer number <257');
    end
    letters = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
    count = 0;
    if column-26<=0
        loc = char(letters(column));
    else
        ocolumn = column;
        while column-26>0
            count = count + 1;
            column = column - 26;
        end
        loc = [char(letters(count)) char(letters(column))];
    end
else
    letters = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
    if size(column,2)==1
        loc =findstr(column,letters);
    elseif size(column,2)==2
        loc1 =findstr(column(1),letters);
        loc2 =findstr(column(2),letters);
        loc = (26 + 26*loc1)-(26-loc2);
        if loc>256
            error('Excel is limited to 256 columns! Enter column number between A & IV');
        end
    end
end