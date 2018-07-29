function [groupTable,out_no_group] = arrangerules(system,intTable)
%   Arranges the rules into groups function
%
%   
%
%   Neelamugilan Gobalakrishnan
%   2006
%   $Revision:1.0 $ $Date: 15/03/2006 $

if size(system.output, 2) == 1
    out_no_group = 1;
else
    out_no_group = input('Enter the output number which is used to group the integer table : ');
end

row = 1;
for i=1:size(system.output(out_no_group).mf, 2)
    for j=1:size(intTable, 1)
        if intTable(j,size(system.input, 2)+out_no_group) == i
            grouped_intTable(row,1:size(system.input, 2))=intTable(j,1:size(system.input, 2));
            grouped_intTable(row,size(system.input, 2)+1)=intTable(j,size(system.input, 2)+out_no_group);
            row = row + 1;
        end
    end
end

%===========================================================
%   Display grouped integer tables with choosen output number.
%===========================================================

fprintf('\n');
disp('-------------------------------------------------------------');
fprintf(' ');
disp('                    Grouped integer table                    ');
fprintf(' ');
disp('-------------------------------------------------------------');

fprintf('\n');
disp('-------------------------------------------------------------');
fprintf(' ');

for i=1:size(system.input, 2)
    fprintf('Input%d ', i);
end

fprintf('Output%d ', out_no_group);

fprintf('\n');
disp('-------------------------------------------------------------');
fprintf('\n');
disp(grouped_intTable);
disp('-------------------------------------------------------------');

fprintf('\n\n');

groupTable = grouped_intTable;
