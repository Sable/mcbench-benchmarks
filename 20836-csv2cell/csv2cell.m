function data = csv2cell(varargin)
% CSV2CELL - parses a Windows CSV file into an NxM cell array, where N is
% the number of lines in the CSV text and M is the number of fields in the
% longest line of the CSV file. Lines are delimited by carriage returns
% and/or newlines.
%
% A Windows CSV file format allows for commas (,) and double quotes (") to
% be contained within fields of the CSV file. Regular fields are just text
% separated by commas (e.g. foo,bar,hello world). Fields containing commas
% or double quotes are surrounded by double quotes (e.g.
% foo,bar,"item1,item2,item3",hello world). In the previous example,
% "item1,item2,item3" is one field in the CSV text. For double quotes to be
% represented, they are written in pairs in the file, and contained within
% a quoted field, (e.g. foo,"this field contains ""quotes""",bar). Spaces
% within fields (even leading and trailing) are preserved.
%
% All fields from the CSV file are returned as strings. If the CSV text
% contains lines with different numbers of fields, then the "missing"
% fields with appear as empty arrays, [], in the returned data. You can
% easily convert the data you expect to be numeric using str2num() and
% num2cell(). 
%
% Examples:
%  >> csv2cell('foo.csv','fromfile') % loads and parses entire file
%  >> csv2cell(',,,') % returns cell array {'','','',''}
%  >> csv2cell(',,,','text') % same as above, declaring text input
%  >> csv2cell(sprintf('%s\r\n%s',...
%     '"Ten Thousand",10000,,"10,000","""It''s ""10 Grand"", baby",10k',...
%     ',foo,bar,soo'))
%  ans = 
%    'Ten Thousand'    '10000'       ''    '10,000'    [1x22 char]    '10k'
%                ''    'foo'      'bar'    'soo'                []       []
%  >> % note the two empty [] cells, because the second line has two fewer
%  >> % fields than the first. The empty field '' at the beginning of the
%  >> % second line is due to the leading comma on that line, which is
%  >> % correct behavior. A trailing comma will do the same to the end of a
%  >> % line.
% 
% Limitations/Exceptions:
%   * This code is untested on large files. It may take a long time due to
%   variables growing inside loops (yes, poor practice, but easy coding).
%   * This code has been minimally tested to work with a variety of weird
%   Excel files that I have.
%   * Behavior with improperly formatted CSV files is untested.
%   * Technically, CSV files from Excel always separate lines with the pair
%   of characters \r\n. This parser will also separate lines that have only
%   \r or \n as line terminators. 
%   * Line separation is the first operation. I don't think the Excel CSV
%   format has any allowance for newlines or carriage returns within
%   fields. If it does, then this parser does not support it and would not
%   return bad output.
%
% Copyright 2008 Arthur Hebert

% Process arguments
if nargin == 1
    text = varargin{1};
elseif nargin == 2
    switch varargin{2}
        case 'fromfile'
            filename = varargin{1};
            fid = fopen(filename);
            text = char(fread(fid))';
            fclose(fid);
        case 'text'
            text = varargin{1};
        otherwise
            error('Invalid 2nd argument %s. Valid options are ''fromfile'' and ''text''',varargin{2})
    end
else
    error('CSV2CELL requires 1 or 2 arguments.')
end


% First split it into lines
lines = regexp(text,'(\r\n|[\r\n])','split'); % lines should now be a cell array of text split by newlines

% a character is either a delimiter or a field
inField = true;
inQuoteField = false;
% if inField && ~inQuoteField --> then we're in a raw field

skipNext = false;
data = {};
field = '';
for lineNumber = 1:length(lines)
    nChars = length(lines{lineNumber}); % number of characters in this line
    fieldNumber = 1;
    for charNumber = 1:nChars
        if skipNext
            skipNext = false;
            continue
        end
        thisChar = lines{lineNumber}(charNumber);
        if thisChar == ','
            if inField 
                if inQuoteField % this comma is part of the field
                    field(end+1) = thisChar;
                else % this comma is the delimiter marking the end of the field
                    data{lineNumber,fieldNumber} = field;
                    field = '';
                    fieldNumber = fieldNumber + 1;
                end
            else % we are not currently in a field -- this is the start of a new delimiter
                inField = true;
            end
            if charNumber == nChars % this is a hanging comma, indicating the last field is blank
                data{lineNumber,fieldNumber} = '';
                field = '';
                fieldNumber = fieldNumber + 1;
            end
        elseif thisChar == '"' 
            if inField
                if inQuoteField
                    if charNumber == nChars % it's the last character, so this must be the closing delimiter?
                        inField = false;
                        inQuoteField = false;
                        data{lineNumber,fieldNumber} = field;
                        field = '';
                        fieldNumber = fieldNumber + 1;
                    else 
                        if lines{lineNumber}(charNumber+1) == '"' % this is translated to be a double quote in the field
                            field(end+1) = '"';
                            skipNext = true;
                        else % this " is the delimiter ending this field
                            data{lineNumber,fieldNumber} = field;
                            field = '';
                            inField = false;
                            inQuoteField = false;
                            fieldNumber = fieldNumber + 1;
                        end
                    end
                else % this is a delimiter and we are in a new quote field
                    inQuoteField = true;
                end
            else % we are not in a field. This must be an opening quote for the first field?
                inField = true;
                inQuoteField = true;
            end
        else % any other character ought to be added to field
            field(end+1) = thisChar;
            if charNumber == nChars
                data{lineNumber,fieldNumber} = field;
                field = '';
                fieldNumber = fieldNumber + 1;
            elseif charNumber == 1 % we are starting a new raw field
                inField = true;
            end
        end
    end
end
            