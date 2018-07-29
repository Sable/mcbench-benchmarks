function fileLine = getLineFromFile(fileName,lineNumber)

%GETLINEFROMFILE Returns a specified line from a file
%   FILELINE = GETLINEFROMFILE(FILENAME,LINENUMBER) returns a string 
%   containing the file contents of FILENAME for a given line number 
%   specified by LINENUMBER.
%  
%   See also fgetl, textscan, textread, strread, fscanf.
%
%   Reference page in Help browser
%      <a href="matlab:doc getLineFromFile">doc getLineFromFile</a>

%   Written by Chris J Cannell
%   Contact ccannell@gmail.com for questions or comments.
%   02/13/2007

% input argument checking for fileName
if ~ischar(fileName) || ~exist(fileName, 'file')
    error(['File "' fileName '" is not a valid file']);
end

% input argument checking for lineNumber
if  ~isnumeric(lineNumber)
    error('Line number is non numeric');
end

% ensure that lineNumber is an integer
lineNumber = floor(lineNumber);

% set default output string to an empty string
fileLine = '';

% open file
fid = fopen(fileName);

% file openned properly begin reading file
if fid ~= -1
    % loop through file line by line until the desired line or end of file
    % is reached
    for i = 1:lineNumber
        tline = fgetl(fid);
        % if end of line is reached break out of the loop
        if ~ischar(tline)
            tline = ''; % set to an empty string to avoid returning a -1
            break
        end   % end of file is reached
    end
    % if the loop reached the desired line then return the string from that
    % line
    if i == lineNumber
        fileLine = strtrim(tline);
    end
    fclose(fid);    % close file
end

