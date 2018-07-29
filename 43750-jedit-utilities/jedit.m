function [] = jedit(filename)

% jedit - Opens jEdit from the MATLAB command window. Only supports opening one
% file at a time. If the filename argument is empty, a new plain view is opened.
% If the filename includes a path, that exact file is opened. Uses 'which'
% command to support wildcards in filename.
%
% [] = jedit(filename)
% filename = file to be opened

if nargin == 0 % no filename input
  filename = '';
elseif strfind(filename, filesep) % path specified
  filename = ['"' which(filename) '"']; % put in quotes in case there are spaces in path
elseif strfind(filename, '*') % wildcard
  filestruct = dir(filename);
  filename = filestruct(1).name; % selects first match
else % path nor wildcard specified, may be a new file
  if ~isempty(which(filename))
    filename = ['"' which(filename) '"']; % put in quotes in case there are spaces in path
  end
end

% Value can be found by typing jedit at the command prompt (at least for Windows).
jedit_bin = '"C:\Program Files (x86)\Java\jre6\bin\javaw.exe" -jar "C:\Program Files (x86)\jEdit\jedit.jar" -reuseview';
if isempty(filename) % no file name given
  system([jedit_bin ' &']);
else % file name given
  system([jedit_bin ' ' filename ' &']);
end
