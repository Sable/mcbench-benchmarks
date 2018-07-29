function showDOETable(Table,colheads)
%SHOWDOETABLE Display a DOE Table.
%   SHOWDOETABLE displays a DOE Table in the Figure Window.
%
%   SHOWDOETABLE(Table,colheads) displays a table with column names in cell
%   array COLHEADS.
%
% See also statdisptable

% Create cell array version of table
atab = num2cell(Table);
for i=1:size(atab,1)
   for j=1:size(atab,2)
      if (isinf(atab{i,j}))
         atab{i,j} = [];
      end
   end
end
rowheads = repmat({''},[size(Table,1),1]);
atab = [rowheads, atab];
atab = [{ '',colheads{1:end} }; atab];
statdisptable(atab,'Design of Experiments','DOE Test Matrix','')