function x=adodbquery(cn,sql)
% [x]=adodbquery(cn,sql)
%
% adoledbquery    Executes the sql statement against the connection cn
%
% Inputs:
%   cn,     open connection to ADO OLEDB ActiveX Data Source Control
%   sql,    SQL statement to be executed
%
% Output
%   x,      cell array of query results
%
% Notes: Convert cells to strings using char. Convert cells to numeric
% data using cell2mat() for ints or double(cell2mat()) for floats
%
% This code basis on Tim Myers code (oledb*.m) and use ADO OLE DB instead
% of OWC - Office Web Component
%
% Martin Furlan
% martin.furlan@iskra-ae.com
% January 2007


%open recordset and run query 

invoke(cn,'BeginTrans');
try 
  r = invoke(cn,'Execute',sql); 
  invoke(cn,'CommitTrans'); 
  sclSuccess = 1; 
catch 
  invoke(cn,'RollbackTrans'); 
  sclSuccess = 0; 
end  

%retrieve data from recordset
if r.recordcount>0
    x=invoke(r,'getrows');
    x=x';
else
    x=[];
end

%release recordset
invoke(r,'release');