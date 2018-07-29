function goto(filename)
% GOTO             Jump to the directory containing a specified file
%
% GOTO filename changes MATLAB current directory to the one containing
% filename.  filename must be on the MATLAB path.  goto uses the first
% instance of filename that it finds (a la WHICH).
%
% SEE ALSO:  WHICH, GOBACK
%

% Scott Hirsch
% shirsch@mathworks.com

file = which(filename);
if isempty(file)
    error(['File ''' filename ''' not found.']);
end;

%Store current directory.  This will allow us to return easily with goback
setappdata(0,'LastDirectory',pwd);

pathstr = fileparts(file);
cd(pathstr);
