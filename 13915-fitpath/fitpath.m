%FITPATH Fit a long path string inside a uicontrol by shortening with '...'
%
% FITPATH(hndl, str)
%
%    hndl is a handle to a uicontrol text object.
%    str  is a string containing a long path.
%
% If you wanted to display a path string into a uicontrol of limited size, then
% this function will shorten it gracefully by replacing directories with a '...'
% starting from the root.
%
% Example:
% The path
% c:\dir1\dir2\dir3\dir4\dir5\dir6\finally_a_file.txt
%
% May get shortened (depending on the size of the uicontrol) to:
% c:\...\dir4\dir5\dir6\finally_a_file.txt
%
% The function will also work with unix style paths of the form:
% /user/bin/dir1/dir2/dir3/dir4/dir5/dir6/finally_a_file.txt
% Shortens to:
% /user/.../dir4/dir5/dir6/finally_a_file.txt

%==================================================================================
%
%        AUTHOR: Erik Newton (Newtek Software Ltd)
%
%           WEB: www.newteksoftware.co.uk
%
%         ISSUE: 2 (13-Feb-2007)
%
%	Copyright Newtek Software Ltd 2006-2007
%
% This function is free for all use, but please leave in my credit.
% Check out more tutorials & functions at our website.
%
%==================================================================================

function fitpath(hndl, str)

if isempty(hndl)
   error('Handle passed in is empty.');
end

set(hndl , 'String', str) % Try the full string initially in the label
set(hndl , 'ToolTipString', str) % Tooltip will contain path in full

ext = get(hndl, 'extent'); % Contains the screen width of the text string
pos = get(hndl, 'position'); % Contains the width of the label

% Find all the directory separator characters in the path
% If on Unix we want to keep the first /dir/ so I've excluded the
% 1st char from the search and replaced it with a gash '-' char
ind = findstr(['-' str(2:end)], filesep);
%ind = 1 + findstr(str(2:end), filesep);

i = 2; % Leave the first part of the path intact hence start at 2

% Loop and gradually knock out directories from the string
while ext(3) > pos(3) && i <= length(ind)
   set(hndl, 'string', [str(1:ind(1)) '...' str(ind(i):end)])
   ext = get(hndl, 'extent');
   i = i + 1;
end
