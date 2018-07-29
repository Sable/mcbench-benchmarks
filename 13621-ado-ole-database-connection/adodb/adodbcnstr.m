function s=adodbcnstr(type,sv,db,uid,pwd)
% s=adodbcnstr(type,[sv],[db],[uid],[pwd])
%
% Returns connection string for ADO OLEDB connection
%
% Inputs:
%   type,   connection type - currently supported: 'Access','SQL','Oracle'
%   sv,     name of server - not required for Access connection
%   db,     name of database - not required for Oracle connection
%   uid,    user id - added to connection string if provided
%   pwd,    password - added to connection string if provided
%
% Output:
%   s,      connection string
%
% Usage:
%   s=adodbcnstr('access',[],'test.mdb')
%   s=adodbcnstr('sql','servername','databasename','userid','password')
%
% This code basis on Tim Myers code (oledb*.m) and use ADO OLE DB instead
% of OWC - Office Web Component
%
% Martin Furlan
% martin.furlan@iskra-ae.com
% January 2007


if strcmpi('ACCESS',type)
    %Connect to Access database given by input db [added by Martin Furlan, ]
    s=['PROVIDER=Microsoft.Jet.OLEDB.4.0;'];
    s=[s 'Data Source=' db ';'];
  
elseif strcmpi('SQL',type)
    %Connect to SQL Database
    s=['Provider=SQLOLEDB;'];
    s=[s 'Data Source=' sv ';Initial Catalog=' db ';'];

elseif strcmpi('ORACLE',type)
    %Connect to Oracle Database
    s=['Provider=OraOLEDB.Oracle;'];
    s=[s 'Data Source=' db ';'];
else
    s='Unknown type';
end

%add uid and pwd if provided
if nargin>3 s=[s 'User Id=' uid ';']; end
if nargin>4 s=[s 'Password=' pwd ';']; end