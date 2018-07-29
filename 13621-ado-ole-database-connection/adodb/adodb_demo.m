% adodb_demo
% Demonstrates the ADO OLEDB connection functions
%
% Requires these files:
%   adodbcnstr.m
%   adodbcn.m
%   adodbquery.m
%   adodbinsert.m
%   test.mdb
%
% Usage:
% Only 4 lines to connect, query/insert, and disconnect:
% 
% s=adodbcnstr(type,[sv],[db],[uid],[pwd]);
% cn = adodbcn(cnstr,[cto],[rst]);
% [x]=adodbquery(cn,sql);
% invoke(cn,'release')
%
% This code basis on Tim Myers code (oledb*.m) and use ADO OLE DB instead
% of OWC - Office Web Component
%
% Martin Furlan
% martin.furlan@iskra-ae.com
% January 2007 

disp('Make sure adotest.mdb is in the current directory')
%Build connection string
s=adodbcnstr('Access',[],[cd '\adotest.mdb']);
%Open connection
cn=adodbcn(s);
%Sample query to execute
sql='select * from TestTable order by lastname, firstname';
%Run query and return results
x=adodbquery(cn,sql)
%Parse result set
lastname=char(x(:,1))
firstname=char(x(:,2))
profession=char(x(:,3))
office=double(cell2mat(x(:,4)))
%Close connection
invoke(cn,'release')

disp('Make sure adotest.mdb is in the current directory')
%Build connection string
s=adodbcnstr('Access',[],[cd '\adotest.mdb']);
%Open connection
cn=adodbcn(s);
%Sample query to execute
sql='INSERT INTO TestTable (LASTNAME, FIRSTNAME, PROFESSION, OFFICE) VALUES (''Rogerio'', ''Dias'', ''Dottore animali'', 11)';
%Run insert and return results
adodbinsert(cn,sql);
%Close connection
invoke(cn,'release')



