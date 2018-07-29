function cn=adodbcn(cnstr,cto)
% cn = adodbcn(cnstr,[cto])
%
% Connects to ADO OLEDB using the Microsoft ActiveX Data Source Control
%
% Inputs:
%   cnstr,  str containing information for connecting to data source
%   cto,    CommandTimeout in seconds (default=60 seconds if unspecified)
%
% Output:
%   cn,     connection
%
% Notes: Refer to adodb_demo.m and adodbcnstr.m for example connection 
% strings for Oracle, SQL, and MS Access databases
%
% This code basis on Tim Myers code (oledb*.m) and use ADO OLE DB instead
% of OWC - Office Web Component
%
% Martin Furlan
% martin.furlan@iskra-ae.com
% January 2007


%create activeX control
cn = actxserver('ADODB.Connection'); 
set(cn,'CursorLocation',3);

%Open connection
invoke(cn,'Open', cnstr);

%Specify connection timeout if provided
if nargin>1 
    set(cn,'CommandTimeout',cto); 
else
    set(cn,'CommandTimeout',60);    %default
end



