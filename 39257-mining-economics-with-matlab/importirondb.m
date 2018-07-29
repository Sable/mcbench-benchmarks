%Set preferences with setdbprefs.
setdbprefs('DataReturnFormat', 'structure');
setdbprefs('NullNumberRead', 'NaN');
setdbprefs('NullStringRead', 'null');


%Make connection to database.  Note that the password has been omitted.
%Using ODBC driver.
conn = database('IronOre', '', '');

%Read data from database.
curs = exec(conn, ['SELECT 	ironore.Month'...
    ' ,	ironore.Price'...
    ' ,	ironore.Change'...
    ' FROM 	ironore ']);

curs = fetch(curs);
close(curs);

%Assign data to output variable
data = curs.Data;

%Close database connection.
close(conn);

%Clear variables
clear curs conn