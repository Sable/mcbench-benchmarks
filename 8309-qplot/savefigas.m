function savefigas

[fname,pname] = uiputfile('*.fig','Select File');
dbfile= strcat(pname,fname);
if length(dbfile) == 0 return; end

saveas(gcf,dbfile,'fig')
return
