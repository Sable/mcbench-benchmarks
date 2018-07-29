function git(varargin)
% GIT - use GIT from matlab, using standard GIT commands
%
%   Examples:
%       % initialize a repository
%       >> git init; 
%
%       % add a file to the repository
%       >> git add myFile.m % begin tracking my_function.m
%
%       % commit changes to the repository
%       >> git commit myFile.m -m 'initial checkin of myFile.m'
%
%       % push to another repository
%       >> git push origin master
%
%
%   Commands that require additionall input (such as commits without -m flags)
%   will generally fail unless the environment variable EDITOR is defined. However,
%   a preferred text editor can be specified within Matlab using the global
%   variable GIT_EDITOR (Pro-tip: include this code in your startup.m file)
%   For Example:
%       
%       Declare the global variable
%       >> global GIT_EDITOR;
%       
%       For linux:
%       >> GIT_EDITOR = '/path/to/editor'; % provide the complete path  
%
%       For Mac OSX:
%       >> GIT_EDITOR = 'TextEdit'; % Simply provide the application name
%
%   The most up to date version of this code can be found at:
%   https://github.com/slayton/matlab-git
%
% Copyright(c) 2012, Stuart P. Layton <stuart.layton@gmail.com> MIT
% http://stuartlayton.com

% Revision History
%   2012/12/04 - Initial Release


% define EDIT_ARG based upon the OS and if GIT_EDITOR is set
global GIT_EDITOR;
if isempty(GIT_EDITOR) 
    EDIT_ARG = ' ';
else
    if ismac
        EDIT_ARG = ['export EDITOR="open -a ', GIT_EDITOR, '";'];

    elseif isunix
        EDIT_ARG = ['export EDITOR="', GIT_EDITOR, '";'];

    %not yet supported
    elseif ispc
       error('Windows computers are not currently supported.');
    end
end


GIT_BINARY = 'git';

args = convertToString(varargin{:});

% create the command to execute
% cat is included so that calls to diff don't get messed up in the command window
cmd = sprintf('%s %s %s | cat', EDIT_ARG, GIT_BINARY, args);

[~,  result] = system(cmd);

fprintf('%s', result);
   
% Parse result and determine what happend
% Check to see if git is installed
if strfind(result, 'command not found')
    error('%s is not installed', GIT_BINARY);

%Check to see if an invalid editor was specified
elseif strfind(result, 'error: There was a problem with the editor')
    warning('%s is not a valid editor\n', GIT_EDITOR);

%Check to see if a commit message was missing
elseif strfind(result, 'Please supply the message using either -m or -F option.')
    
    %if GIT_EDITOR isn't defined, inform the user, otherwise do nothing as
    %they probably left the message empty intentionally
    if empty(GIT_EDITOR)
        fprintf('\nConsider creating a global matlab variable named GIT_EDITOR\n')
        fprintf('and pointing it to the binary of your preferred graphical text editor\n');
        fprintf('For more information run: help git\n');
    end
    
end    
         

end


function argList = convertToString(varargin)

    argList = cell2mat( cellfun( @(x)[ char(x), ' '] , varargin, 'UniformOutput', false ) );

end