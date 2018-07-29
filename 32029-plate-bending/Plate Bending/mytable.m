function [w,titax,titay] = mytable(nnode,displacement,sdof)
%--------------------------------------------------------------------------
% Purpose:
%         Print displacements in tabular form
% Synopsis :
%         [w,titax,titay] = mytable(nnode,displacement,sdof)
% Variable Description:
%           nnode - total number of nodes
%           displacement - solution obtained on solving Kx = F
%           sdof - total number of degree's of freedom
%--------------------------------------------------------------------------
w = displacement(1:3:sdof) ;
titax = displacement(2:3:sdof) ;
titay = displacement(3:3:sdof) ;
% Set Table
f2 = figure('position',[200 200 350 350]) ;
set(f2,'name','Table','numbertitle','off','Color','w') ;
hTable = uitable(f2);
%set(hTable,'Width',[0 0 100 100]) ;
columnHeaders = {'node', 'w', 'thetax','thetay'};
tableData(:,1) = 1:nnode  ;
tableData(:,2) = w ;
tableData(:,3) = titax ;
tableData(:,4) = titay ;
% Display the table of values.
set(hTable, 'ColumnName', columnHeaders);
set(hTable, 'data', tableData);