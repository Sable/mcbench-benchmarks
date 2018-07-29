function getlabel
global label

prompt= {'X label','Y label','Z label','Title'};
title= 'Axis Legends';
lines= 1;
resize= 'off';
tmp= inputdlg(prompt,title,lines,struct2cell(label));
fields= {'x','y','z','t'};
if size(tmp,1) > 0 
	label= cell2struct(tmp,fields,1); 
else
	label= cell2struct(prompt,fields,1);
end
xlabel(label.x);
ylabel(label.y);
zlabel(label.z);
return
