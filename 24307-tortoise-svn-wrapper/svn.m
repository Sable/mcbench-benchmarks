function svn(varargin)
%svn Control TortoiseSVN from within matlab.
% Wrapper for TortoiseSVN. 
% Useage: SVN command dir/file(s)
% Supported commands: about, checkout*, import*, update*, commit*, add,
% revert*, cleanup*, resolve*, repocreate*, switch*, export*, mergeall*,
% settings, remove, rename, diff, conflicteditor, relocate, help,
% repostatus, repobrowser, ignore, blame, createpatch, revisiongraph, lock,
% unlock, properties.
%
% Commands with an * only take one directory as an argument.
% Other commands that take a path can accept more than one argument. If no
% directory is given, the current working directory is used.
%
% This function is not intended to completely replace SVN. It is a quick
% way to do commits, checkouts and adds to a directory while in Matlab.
%
% Examples:
%   svn checkout [Dialog]
%   edit newfile.m [Dialog]
%   svn add newfile.m [Dialog]
%   svn commit [Dialog]
%
% For a full description of what each command does, visit the tortoisesvn
% website: http://tortoisesvn.net/docs/nightly/TortoiseSVN_en/tsvn-automation.html
%
% See also: add, checkout, commit
if nargin<1
    error(sprintf('You must give at least one command\nSee: http://tortoisesvn.net/docs/nightly/TortoiseSVN_en/tsvn-automation.html'));
else
    command=varargin{1};
end
if nargin<2
    varargin{2}=pwd;
end
switch command
    case 'about'
    case 'checkout' % Check out one path at a time
        varargin=singleDirOnly(command,varargin);
    case 'import'% Import one path at a time
        varargin=singleDirOnly(command,varargin);
    case 'update'
        varargin=singleDirOnly(command,varargin);
    case 'commit' % Commit path at a time
        varargin=singleDirOnly(command,varargin);
    case 'add'
    case 'revert'
        varargin=singleDirOnly(command,varargin);
    case 'cleanup'
        varargin=singleDirOnly(command,varargin);
    case 'resolve'
        varargin=singleDirOnly(command,varargin);
    case 'repocreate'
        varargin=singleDirOnly(command,varargin);
    case 'switch'
        varargin=singleDirOnly(command,varargin);
    case 'export'
        varargin=singleDirOnly(command,varargin);
    case 'merge'
        error('Unsupported command.');
    case 'mergeall'
        varargin=singleDirOnly(command,varargin);
    case 'copy'
        error('Unsupported command.');
    case 'settings'
    case 'remove'
    case 'rename'
    case 'diff'
    case 'showcompare'
        error('Unsupported command.');
    case 'conflicteditor'
    case 'relocate'
    case 'help'
    case 'repostatus'
    case 'repobrowser'
    case 'ignore'
    case 'blame'
    case 'cat'
        error('Unsupported command.');
    case 'createpatch'
    case 'revisiongraph'
    case 'lock'
    case 'unlock'
    case 'properties'
    otherwise
        error(sprintf('Unknown TortoiseSVN command: %s\nSee: %s',command,'http://tortoisesvn.net/docs/nightly/TortoiseSVN_en/tsvn-automation.html'));
end
% Use double quotes if there is a space in the path.
% No UNC as this is called using the dos command
tsvn='"C:\Program Files\TortoiseSVN\bin\TortoiseProc.exe"';
for i=2:numel(varargin)
    cmd=sprintf('%s /command:%s /closeonend:1 /path:"%s"',tsvn,command,abspath(varargin{i}));
    dos(cmd);
end
end

% For functions which should only take a single directory
function in=singleDirOnly(cmd,in)
if (~isdir(abspath(in{2})))
    error('You can only commit directories');
end
if length(in)>2
    warning('SVN:DIRLIMIT',['You can only ' cmd ' one directory at a time. Only using first directory']);
    in(3:end)='';
end
end

function [absolutepath]=abspath(partialpath)
% Taken from xlswrite.
% parse partial path into path parts
[pathname filename ext] = fileparts(partialpath);
% no path qualification is present in partial path; assume parent is pwd, except
% when path string starts with '~' or is identical to '~'.
if isempty(pathname) && isempty(strmatch('~',partialpath))
    Directory = pwd;
elseif isempty(regexp(partialpath,'(.:|\\\\)','once')) && ...
        isempty(strmatch('/',partialpath)) && ...
        isempty(strmatch('~',partialpath));
    % path did not start with any of drive name, UNC path or '~'.
    Directory = [pwd,filesep,pathname];
else
    % path content present in partial path; assume relative to current directory,
    % or absolute.
    Directory = pathname;
end
% construct absulute filename
absolutepath = fullfile(Directory,[filename,ext]);
end
