function [data,columns] = queryDatabase(db,query)
%QUERYDATABASE Query a database.
%   queryDatabase(DATABASE,QUERY) returns results of the query and the
%   column names as cell arrays.  Any errors will be thrown as
%   real errors.
%
%   Example:
%
%     db = database('foo','bar','baz');
%     query = 'select * from something';
%     [data,names] = queryDatabase(db,query)
%     s = cell2struct(data,names,2);
%     close(db);

% Matthew J. Simoneau
% Copyright 1984-2007 The MathWorks, Inc.

curs = exec(db,query);
error(curs.Message);
curs = fetch(curs);
error(curs.Message)
data = curs.Data;

cnames = columnnames(curs);
% This doesn't work if there are single quotes in the field names.
% eval(['columns = {' cnames(:) '};'])
% Use split instead.
columns = split(cnames(2:end-1),''',''');

close(curs)

if isequal(size(data),[1 1]) && isequal(data{1},'No Data')
    data = cell(0,length(columns));
end

function cellArray = split(str,delimiter)
%SPLIT divides a string into a cell array of strings based on a delimiter.
%   SPLIT(STR,DELIMITER) breaks STR into chunks sectioned by DELIMITER and
%   returns a cell array of these chunks.
%
%     >> split('fooMJSbarMJSbaz','MJS')
%     
%     ans = 
%     
%         'foo'
%         'bar'
%         'baz'

% Matthew J. Simoneau, April 2003

dLength = length(delimiter);
matches = strfind(str,delimiter);
if isempty(matches)
    cellArray{1} = str;
else
    cellArray{1} = str(1:matches(1)-1);
    for i = 1:length(matches)-1
        cellArray{end+1,1} = str(matches(i)+dLength:matches(i+1)-1);
    end
    cellArray{end+1,1} = str(matches(end)+dLength:end);
end
