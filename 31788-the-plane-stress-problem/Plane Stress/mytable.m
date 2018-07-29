function [UX,UY] = mytable(nnode,displacement,sdof)
UX = displacement(1:2:sdof) ;
UY = displacement(2:2:sdof) ;
% Set Table
f2 = figure('Position',[300 300 350 350]);
set(f2,'name','Table','numbertitle','off','color', 'w','menubar','none') ;
axis off ;
hTable = uitable(f2);
columnHeaders = {'node', 'UX', 'UY'};
for n=1:nnode
	tableData(n,1) = n ;
	tableData(n,2) = UX(n);
	tableData(n,3) = UY(n);
end
% Display the table of values.
set(hTable, 'ColumnName', columnHeaders);
set(hTable, 'data', tableData);
hold off ;