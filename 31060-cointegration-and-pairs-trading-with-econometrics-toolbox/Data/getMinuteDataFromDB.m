function out = getMinuteDataFromDB(tableName)

% Copyright 2011, The MathWorks, Inc.
% All rights reserved.

% Set preferences with setdbprefs.
s.DataReturnFormat = 'numeric';
s.ErrorHandling = 'store';
s.NullNumberRead = 'NaN';
s.NullNumberWrite = 'NaN';
s.NullStringRead = 'null';
s.NullStringWrite = 'null';
s.JDBCDataSourceFile = '';
s.UseRegistryForSources = 'yes';
s.TempDirForRegistryOutput = 'C:\Temp';
s.DefaultRowPreFetch = '10000';
setdbprefs(s)

% Make connection to database.  Note that the password has been omitted.
% Using ODBC driver.
conn = database('Minute Bars','','password');

% Read data from database.
e = exec(conn,['SELECT ALL Dates,High,Low,Close FROM ' tableName]);
e = fetch(e);
close(e)

% Assign data to output variable.
out = e.Data;

% Close database connection.
close(conn)