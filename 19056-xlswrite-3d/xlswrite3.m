function xlswrite3(filename,data,sheet,first,option)
% XLSWRITE3 is a modified version of the XLSWRITE function that allows you
% to write 3-dimensional arrays to a Microsoft Excel file.
%
%   XLSWRITE3(FILE,ARRAY,SHEET,FIRST,OPTION) works similarly to the built-in
%   function XLSWRITE.  It writes ARRAY to the Excel workbook, FILE, into the
%   area beginning with cell, FIRST, in the worksheet specified in
%   SHEET.  The new paramter OPTION determines how n > 2 dimensions of the
%   array will be handled, as follows:
%
%      option = 1 --> array(:,:,n) will be placed underneath array(:,:,n-1),
%                     with a blank row in between the two
%      option = 2 --> array(:,:,n) will be placed to the right of array(:,:,n-1),
%                     with a blank column in between the two
%      option = 3 --> array(:,:,n) will be placed in a separate worksheet
%                     from array(:,:,n-1), named 'SHEETn'
%
% eg. xlswrite3('C:\Documents and Settings\Jeremy\Desktop\testingexcel.xls',A,'1Sheet','B2',1);
%
% **Use of this function requires that you have the Matlab function XLSWRITE.


warning off MATLAB:xlswrite:AddSheet

% --Check for input errors
if nargin < 5
    error('This function requires that all five (5) parameters be defined.  See help for more info.')
end
if ~ischar(filename)
    error('MATLAB:xlswrite:InputClass','Filename must be a string');
end
[Directory,file,ext]=fileparts(filename);
if isempty(ext)
    ext = '.xls';
end
if isempty(data)
    error('MATLAB:xlswrite:EmptyInput','Input array is empty.');
end
if ndims(data) < 3
    disp(' ')
    disp(cat(2,'Your array is only ',num2str(ndims(data)),'-dimensional.  You could also use XLSWRITE.'))
    disp(' ')
end
if ~(iscell(data) || isnumeric(data) || ischar(data)) && ~islogical(data)
    error('MATLAB:xlswrite:InputClass',...
        'Input data must be a numeric, cell, or logical array.');
end
if (~isnumeric(option) || option < 1 || option > 3)
    error('Invalid selection for parameter OPTION.  Select either 1, 2 or 3.')
end
% --End error check

if option == 1  %--------------------array(:,:,n) will be placed underneath array(:,:,n-1) with a blank row in between the two
    spacing = size(data,1) + 1;
    number = 0;
    y = 0;
    while number == 0
        y = y + 1;
        num = ~isletter(first(y));
        if num == 1
            number = 1;
        end
    end
    row = str2double(first(y:end));
    for t = 1:size(data,3)
        range = cat(2,first(1:y-1),num2str(row));
        xlswrite(filename,data(:,:,t),sheet,range);
        row = row + spacing;
    end

elseif option == 2  %----------------array(:,:,n) will be placed to the right of array(:,:,n-1) with a blank column in between the two
    spacing = size(data,2) + 1;
    alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    letter = 1;
    y = 0;
    while letter == 1
        y = y + 1;
        let = isletter(first(y));
        if let == 0
            letter = 0;
        end
    end
    col = first(1:y-1);
    if length(col) == 1  %---------Turn string portion of FIRST into a number to determine which column
        for z = 1:length(alphabet)
            if col == alphabet(z)
                column = z;
            end
        end
    elseif length(col) == 2
        for z = 1:length(alphabet)
            if col(1) == alphabet(z)
                column1 = z * length(alphabet);
            end
            if col(2) == alphabet(z)
                column2 = z;
            end
        end
        column = column1 + column2;
    end
    for t = 1:size(data,3)
        if column/length(alphabet) < 1  %---------Convert column number back into a string
            columnstr = alphabet(column);
        else
            temp = num2str(column/length(alphabet));
            columnstr(1) = num2str(alphabet(str2double(temp(1))));
            columnstr(2) = num2str(alphabet(column-str2double(temp(1))*length(alphabet)));
        end
        range = cat(2,columnstr,num2str(first(y:end)));
        xlswrite(filename,data(:,:,t),sheet,range);
        column = column + spacing;
    end

elseif option == 3  %----------------array(:,:,n) will be placed in a separate worksheet from array(:,:,n-1), named 'SHEETn'
    for t = 1:size(data,3)
        xlswrite(filename,data(:,:,t),cat(2,sheet,num2str(t)),first);
    end
end

