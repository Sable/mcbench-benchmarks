function insertMask = upsert(conn,tableName,fieldNames,keyFields,data, varargin)
% UPSERT inserts new and updates old data to a database table
%
% UPSERT(CONNECT,TABLENAME,FIELDNAMES,KEYFIELDS,DATA).
%   CONNECT is a database connection object. TABLENAME is the database
%   table. FIELDNAMES is a string array of database column names. KEYFIELDS
%   is the list of primary key fields that must be matched to perform an
%   UPDATE rather than an INSERT. It may be given as a logical (or 0s, 1s)
%   array the same length as FIELDNAMES, or a string or cell array of
%   strings of key column names (in which case KEYFIELDS must be a subset
%   of FIELDNAMES). DATA is a MATLAB cell array.
%
% INSERTEDMASK = UPSERT(...) returns a logical vector with one element for
% each row of DATA, indicating whether the "upsert" operation meant that
% corresponding row of DATA was inserted (TRUE) or merely updated (FALSE).
%
% UPSERT(...,'dateFields',DATEFIELDS) allows a DATE type field to be used
% as one of the primary key fields. DATEFIELDS is specified equivalently to
% KEYFIELDS. Each primary key DATE type field's data MUST be given as an
% ANSI string literal (i.e., '1998-12-25'), rather than a MATLAB datenum
% number or a differently formatted date string.
% (see http://docs.oracle.com/cd/E11882_01/server.112/e26088/sql_elements003.htm#SQLRF51062)
%
% UPSERT(...,'updateFcn',FUNCTION_HANDLE)
% UPSERT(...,'insertFcn',FUNCTION_HANDLE) optionally allows replacement
% functions for the default use of MATLAB's "update" and "fastinsert".
%
% UPSERT(...,'debug',true) prints out diagnostic information.
%
% Example:
%
% Imagine a database table "PHONE_NOS" with data like:
%     PERSONID |  TYPE  | NUMBER
%     1           'HOME'  1234567
%     1           'MOB'   1222222
%     2           'HOME'  9888888
%
% Then the MATLAB commands:
%     newNos = {1 'MOB' 4444444
%               2 'MOB' 5555555};
%     INS = upsert(conn, 'PHONE_NOS', {'PERSONID','TYPE','NUMBER'}, [1 1 0], newNos)
%
% Would result in the table having contents:
%     PERSONID |  TYPE  | NUMBER
%     1           'HOME'  1234567
%     1           'MOB'   4444444
%     2           'HOME'  9888888
%     2           'MOB'   5555555
%
% The returned variable (INS) would be [0; 1], meaning the second row was
% updated, the first row was inserted.

%   Author: Sven Holcombe, 2012-09-25

% Firstly, handle large data sets. Later we will use an IN clause with a
% comma-separated list to check key fields. Oracle has a limit of 1000
% items in a list, so let's process 1000 at a time at most. Not an optimal
% solution but best solutions will differ by database flavour so this is
% adequate for the moment.
numRows = size(data,1);
if numRows>1000
    insertMask = true(numRows,1);
    chunks = unique([1:999:numRows numRows+1]);
    for i = 1:length(chunks)-1
        dataInds = chunks(i):chunks(i+1)-1;
        insertMask(dataInds) = ...
            upsert(conn,tableName,fieldNames,keyFields,data(dataInds,:), varargin{:});
    end
    return;
end

% Handle user configuration input
IP = inputParser;
IP.addParamValue('updateFcn', @update,     @(x)isa(x,'function_handle'));
IP.addParamValue('insertFcn', @fastinsert, @(x)isa(x,'function_handle'));
IP.addParamValue('dateFields', []);
IP.addParamValue('debug', false);
IP.parse(varargin{:});
doPrint = IP.Results.debug;
updateFcn = IP.Results.updateFcn;
insertFcn = IP.Results.insertFcn;

% keyFields may be input as:
%  - A string: 'id'
%  - A cellstr: {'id','groupNo'}
%  - A logical mask the same size as fieldNames (true where field is a key)
%  - Indices into fieldNames of the key fields
% keyFields will be transformed to the indices representation below
keyFields = convertSubsetOfFieldsToIndices(keyFields, fieldNames);
% Get a numeric array of which fields are DATE types for comparison
dateFields = convertSubsetOfFieldsToIndices(IP.Results.dateFields, fieldNames);

% Currently it's easier (if perhaps slightly slower) to treat data as a
% cell regardless of what format it was provided as.
if isnumeric(data)
    data = num2cell(data);
end

% Which fields are keyFields? Build lists of them for an SQL fetch
keyFieldsCell = fieldNames(keyFields);
keyFieldsIsnumeric = cellfun(@(x)isnumeric(x)||islogical(x), data(1,keyFields));
keyFieldsIsdatestr = ismember(keyFields, dateFields);
keyFieldsListStr = sprintf('%s,',keyFieldsCell{:});

% We don't want to gather the whole table. Only the rows matching the
% primary key fields. This is most generalised by building IN () lists from
% a single database query, rather than sending/recieving one query for
% every row of "data" being upserted.
inClauses = cell(length(keyFields),1);
for i=1:length(keyFields)
    if keyFieldsIsnumeric(i)
        inSet = unique([data{:,keyFields(i)}]);
        inStr = sprintf('%g,',inSet);
    elseif ischar(data{1,keyFields(i)})
        inSet = unique(data(:,keyFields(i)));
        if keyFieldsIsdatestr(i)
            inStr = sprintf('date ''%s'',',inSet{:});
        else
            inStr = sprintf('''%s'',',inSet{:});
        end
    else
        error('upsert:badKey', 'Primary key field cannot contain %s data',class(data{1,keyFields(i)}))
    end
    if length(inSet)>1
        inClauses{i} = sprintf('%s IN (%s)', keyFieldsCell{i}, inStr(1:end-1));
    else
        inClauses{i} = sprintf('%s = %s', keyFieldsCell{i}, inStr(1:end-1));
    end
end

% Fetch all table rows potentially matching the data we want to upsert
fetchWhereClause = sprintf(' %s AND', inClauses{:});
fetchSqlStr = sprintf('SELECT %s FROM %s WHERE %s', keyFieldsListStr(1:end-1), tableName, fetchWhereClause(1:end-3));
if doPrint, fprintf('Fetching %s data in %s matching given data...', keyFieldsListStr(1:end-1), tableName), end
fetchedData = fetch(conn, fetchSqlStr);
if doPrint, fprintf(' done. (%d potential matches found)\n', size(fetchedData,1)), end

% Build a map of which rows to be upserted already exist in the table.
insertMask = true(size(data,1),1); % One
if ~isempty(fetchedData)
    eqMap = false(size(data,1), size(fetchedData,1), length(keyFields));
    for i = 1:length(keyFields)
        if keyFieldsIsnumeric(i)
            thisUpsertData = cell2mat(data(:,keyFields(i)));
            thisFetchedData = cast(cell2mat(fetchedData(:,i)), class(thisUpsertData));
            eqMap(:,:,i) = bsxfun(@eq, thisUpsertData, thisFetchedData');
        elseif keyFieldsIsdatestr(i)
            thisUpsertData = datenum(data(:,keyFields(i)));
            thisFetchedData = datenum(fetchedData(:,i));
            eqMap(:,:,i) = bsxfun(@eq, thisUpsertData, thisFetchedData');
        else
            thisUpsertData = data(:,keyFields(i));
            thisFetchedData = fetchedData(:,i)';
            eqCell = cellfun(@(x)strcmp(x, thisFetchedData), thisUpsertData, 'Un',0);
            eqMap(:,:,i) = cat(1, eqCell{:});
        end
    end
    pkeysMatchMap = all(eqMap,3);
    insertMask = ~any(pkeysMatchMap,2);
end

% First find any data rows that do NOT yet exist in table. Insert them.
if any(insertMask)
    if doPrint, fprintf('Inserting %d data rows not currently in %s...', nnz(insertMask), tableName), end
    insertFcn(conn,tableName,fieldNames,data(insertMask,:));
    if doPrint, fprintf(' done.\n'), end
end

% Next, update ALL rows to the values given in data. First build WHERE.
whereEqClauses = cell(numRows, length(keyFields));
for i=1:length(keyFields)
    if keyFieldsIsnumeric(i)
        whereEqClauses(:,i) = cellfun(@(dat)sprintf('%s = %g', keyFieldsCell{i}, dat), data(:,keyFields(i)),'Un',0);
    elseif keyFieldsIsdatestr(i)
        whereEqClauses(:,i) = cellfun(@(dat)sprintf('%s = date ''%s''', keyFieldsCell{i}, dat), data(:,keyFields(i)),'Un',0);
    else
        whereEqClauses(:,i) = cellfun(@(dat)sprintf('%s = ''%s''', keyFieldsCell{i}, dat), data(:,keyFields(i)),'Un',0);
    end
end
dataWhereClauses = cellfun(@(strs)sprintf(' %s AND',strs{:}), num2cell(whereEqClauses,2),'Un',0);
dataWhereClauses = cellfun(@(str)['WHERE ' str(1:end-3)], dataWhereClauses, 'Un',0);

% Next, run the update on all the NON-keyField fields (since the key fields
% themselves are being matched, so won't change). Note that the "update"
% function can be replaced by a user's modified update function.
otherFields = setdiff(1:length(fieldNames), keyFields);
if doPrint, fprintf('Updating %d data rows (%d new, %d old) in %s...', length(insertMask), nnz(insertMask), nnz(~insertMask), tableName), end
updateFcn(conn,tableName,fieldNames(otherFields),data(~insertMask,otherFields), dataWhereClauses(~insertMask))
if doPrint, fprintf(' done.\n'); end


function subFields = convertSubsetOfFieldsToIndices(subFields, allFields)
% convert subFields from various classes to a numeric index of allFields
% may be input as:
%  - A string: 'id'
%  - A cellstr: {'id','groupNo'}
%  - A logical (or 0,1) mask the same size as fieldNames
%  - Indices into fieldNames of the key fields
% keyFields will be transformed to the indices representation below
if ischar(subFields) || iscellstr(subFields)
    subFields = ismember(upper(allFields), upper(subFields));
end
if isnumeric(subFields) && (any(subFields==0) || nnz(subFields==1)>1)
    subFields = logical(subFields);
end
if islogical(subFields)
    subFields = find(subFields);
end