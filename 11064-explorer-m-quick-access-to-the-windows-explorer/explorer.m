function explorer(directory,root)
%EXPLORER - Opens the Windows Explorer
%
% explorer
% explorer(directory)
% explorer(directory,1)
%
% If no directory is specified, the Windows explorer is opened for the
% current MATLAB directory.  Otherwise, the Windows explorer is opened for
% the specified directory.  If a file name is specified instead of a
% directory, the Explorer window is opened showing the directory containing
% that file.
%
% An error is thrown if the specified directory (or file) is not found.
%
% The final parameter, if specified and non-zero, indicates that the
% "Explorer from here" option should be used, i.e. that the folder hierarchy
% should be shown with the root at the specified directory
%
% Examples:
%   explorer(pwd,1)
%   explorer peaks

% Copyright 2006-2009 The MathWorks, Inc.

if nargin<2
    root = 0;
    if nargin<1
        directory = pwd;
    end
end

if ~exist(directory,'dir')
    % Not a directory.  Call "which" to find out whether it is a file,
    % and to make sure that we have the full path.
    x = which(directory);
    if isempty(x)
        % Not a file either.
        error('Not found: %s',directory);
    end
    % Get just the directory part of the file name.
    directory = fileparts(x);
end

if root
    % Open the Explorer window with the Folders tree visible and 
    % with this directory as the root
    command = ['explorer.exe /e,/root,' directory];
else
    % Just open an Explorer window without the Folders tree
    command = ['explorer.exe ' directory];
end

[~,b] = dos(command);
if ~isempty(b)
    error('Error starting Windows Explorer: %s', b);
end
        
