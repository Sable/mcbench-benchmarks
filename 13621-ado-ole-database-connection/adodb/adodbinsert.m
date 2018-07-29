function x=adodbinsert(cn,sql)
% [x]=oledbinsert(cn,sql)
%
% adodbinsert   Executes the sql statement against the connection cn
%
% Inputs:
%   cn,     open connection to ADO OLEDB ActiveX Data Source Control
%   sql,    SQL statement to be executed
%
% Output
%   x,      return: 1 - successful or 0 - unsuccessful
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


% Execute insert into database
invoke(cn,'BeginTrans'); 
try 
  invoke(cn,'Execute',sql); 
  invoke(cn,'CommitTrans'); 
  sqlSuccess = 1; 
catch 
  invoke(cn,'RollbackTrans'); 
  sqlSuccess = 0; 
end 

x =  sqlSuccess;