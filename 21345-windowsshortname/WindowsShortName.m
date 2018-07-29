function [sname] = WindowsShortName(lname)
%
% Under Windows, gets the short name (8.3) of file or folder lname. Creates a command script
% with lname as parameter and uses the modifier %~s1 to get the short name of lname.
%
%  Example : >> WindowsShortName('C:\Documents and Settings\lulu\Bureau\Inno Setup Compiler.lnk')
%
%         returns 'C:\DOCUME~1\lulu\Bureau\INNOSE~1.LNK'
%
%  Luc Masset (2008)

%initialisation
sname=[];

%file or folder exists ?
iexist=exist(lname);
if ~ismember(iexist,[2 7]),
 return
end

%creating command scipt
sfile=[tempname '.cmd'];
ofile=[tempname '.txt'];
fid=fopen(sfile,'w');
if fid < 0,
 return
end
fprintf(fid,'@echo off\r\n');
fprintf(fid,'echo %%~s1> "%s"\r\n',ofile);
fclose(fid);

%run script
st=sprintf('"%s" "%s"',sfile,lname);
ie=dos(st);
delete1(sfile);
if ie,
 delete1(ofile);
 return
end

%output file
fid=fopen(ofile,'r');
if fid < 0,
 delete1(ofile);
 return
end
st=fgetl(fid);
fclose(fid);
delete1(ofile);

%result
st=deblank(st);
if isempty(st),
 return
end
if exist(st) ~= iexist,
 return
end
sname=st;

return

%------------------------------------------------------------------------------
function [] = delete1(file)
%
% Delete file if file exists.
%

if exist(file) ~= 2,
 return
end
st=sprintf('del /F/Q "%s"',file);
status=dos(st);

return