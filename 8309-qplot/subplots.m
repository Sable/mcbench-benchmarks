function subplots
global subpl

prompt= {'# ROWS','# COLUMNS','Selected SubPlot'};
title= 'Subplots';
lines= 1;
resize= 'off';
default= {num2str(subpl(1)),num2str(subpl(2)),num2str(subpl(3))};
tmp= inputdlg(prompt,title,lines,default);
if size(tmp,1) > 0
	subpl= [str2num(cell2mat(tmp))];
end
