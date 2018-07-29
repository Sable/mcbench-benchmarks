%CELLWRITE Write a cell array to a comma separated value file.
%   CELLWRITE(FILENAME, C) writes cell array C into FILENAME as comma
%   separated values.
%
%   NOTE: This function is not completely compatible with CSVWRITE.
%   Offsets are not supported and 0 values are not omitted.
%
%   See also CSVWRITE, CSVREAD, DLMREAD, DLMWRITE, WK1READ, WK1WRITE.
function cellwrite(filename, cellarray)
% The cell array is traversed, the contents of each cell are converted
% to a string, and a CSV file is written using low level fprintf
% statements.
[rows, cols] = size(cellarray);
fid = fopen(filename, 'w');
for i_row = 1:rows
    file_line = '';
    for i_col = 1:cols
        contents = cellarray{i_row,i_col};
        if isnumeric(contents)
            contents = num2str(contents);
        elseif isempty(contents)
            contents = '';
        end
        if i_col<cols
            file_line = [file_line, contents, ','];
        else
            file_line = [file_line, contents];
        end
    end
    count = fprintf(fid,'%s\n',file_line);
end
st = fclose(fid);
if st == -1
    error('Bad file write')
end