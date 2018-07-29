function file_datenum = filedatenum(fname)
% <cpp> Purpose: Returns the modification date (datenum) of a file 
% Usage: file_datenum = filedatenum('myfile.dat')
% Author: Charles Plum, Varolii Corp, 21 August 2009 
%*********************************************************************

% Extract the file path from the argument fname
dir_name = fname(1:max(strfind (fname,'\')));

%If a path was given, then extract the file name from the fname arg
if (dir_name)
    file_name = fname(max(strfind (fname,'\'))+1:end);
else % assume the local directory is the path
    dir_name = pwd;
    file_name = fname;
end

% Not elegant but it works ... 
d = dir(dir_name);
for ifile=1:length(d)
    if (strcmp(file_name,char(d(ifile).name)))
      file_datenum = d(ifile).datenum;
      return;
    end
end
file_datenum = 0; % Return zero if no file found
return
