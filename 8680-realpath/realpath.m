function output = realpath(thePath)
%REALPATH   Absolute pathname
%   Resolves relative paths and extra filesep characters in the input
%   path.
%
%   Syntax:
%      OUTPUT = REALPATH(THEPATH)
%
%   Input:
%      THEPATH   Path to a file or folder, which should exist
%
%   Output:
%      OUTPUT   The absolute pathname or [] if THEPATH does not exist
%
%   Example:
%      realpath('../myfile.txt'); % returns /home/user/whatever/myfile.txt
%
%   MMA 18-09-2005, martinho@fis.ua.pt
%
%   See also DIRNAME, BASENAME

%   Department of Physics
%   University of Aveiro, Portugal

output = [];
isfile = 0;
if exist(thePath,'file') == 2 & isempty(which(thePath))
  [path,name,ext]=fileparts(thePath);
  thePath =  path;
  isfile = 1;
end

current = cd;
if exist(thePath,'dir') == 7 & ~isempty(dir(thePath))
  cd(thePath);
  output = cd;
  cd(current);

  if isempty(output)
    if isunix, new = filesep; end
    if ispc,   new='C:\';     end
  end
end

if isfile
  output = [output,filesep,name,ext];
end
