function newFunction(fxnname)
%CODETEMPLATE creates a new m-file with proper help layout
%
% SYNOPSIS: newFunction(fxnname)
%
% INPUT fxnname: name of the new function. CodeTemplate will check that the
%                function name has not been used yet, and it will ask for
%                additional input, such as H1-line via inputdlg
%
% OUTPUT None. The function creates a new m-file and opens it in the editor
%
% REMARKS
%
% created with MATLAB ver.: 7.10.0.499 (R2010a) on Microsoft Windows 7 Version 6.1 (Build 7600)
%
% created by: Jonas Dorn
% DATE: 31-Mar-2010
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%==============
%% DEFAULTS
%==============

% add common superclass for value and handle classes, respectively
%superclass = {'myClass','myHandle'};
superclass = {[],'handle'};


%===============
%% CHECK INPUT
%===============

% if no input argument, assign empty to functionname
if nargin < 1 || isempty(fxnname) || ~ischar(fxnname)
    fxnname = [];
end

% check whether function already exists - only if given as input
if ~isempty(fxnname)
    fxnCheck = which(fxnname);
    if ~isempty(fxnCheck)
        error('%s already exists: %s',fxnname,fxnCheck)
    end
end

%==============


%================
%% GATHER DATA
%================

% data-gathering stage begins below
% getenv() and version are used to derive environmental variables

% find username. This will return empty on Linux, but we have a line for
% the username in the input dialogue, anyway.
username = getenv('username');

try %#ok<TRYNC>
    % try to resolve user name - I use a function I called username2name to
    % change e.g.  'jdorn' into 'Jonas Dorn'
    username = username2name(username);
end

% get version, OS, date
vers    = version;
datetoday = date;

% getenv('OS') does not work on Mac. Query the OS like ver.m
% find platform OS
if ispc
    platform = [system_dependent('getos'),' ',system_dependent('getwinsys')];
elseif ismac
    [fail, input] = unix('sw_vers');
    if ~fail
        platform = strrep(input, 'ProductName:', '');
        platform = strrep(platform, sprintf('\t'), '');
        platform = strrep(platform, sprintf('\n'), ' ');
        platform = strrep(platform, 'ProductVersion:', ' Version: ');
        platform = strrep(platform, 'BuildVersion:', 'Build: ');
    else
        platform = system_dependent('getos');
    end
else
    platform = system_dependent('getos');
end
os = platform;

% ask for the rest of the input with inputdlg

% set up inputdlg
inPrompt = {'Username',...
    'Function name',...
    'Description: ''FUNCTIONNAME does ...'' (captitalized function name)',...
    'Synopsis: ''[output1, output2] = functionname(input1, input2)',...
    'Description of input arguments (use \n for additional line breaks)',...
    'Description of output arguments (use \n for additional line breaks)',...
    'Function: 1, Value Class: 2, Handle Class: 3, Subclass: superclass-name'};
inTitle = 'Please describe your function';
numLines = repmat([1,100],7,1);
numLines([5,6],1) = 5;
% assign defaultAnswer
[defaultAnswer{1:7}] = deal('');
% assign username in default answers
defaultAnswer{1} = username;
defaultAnswer{7} = '1';
% if we have a function name already, all will be simpler
if ~isempty(fxnname)
    defaultAnswer{2} = fxnname;
    defaultAnswer{3} = sprintf('%s ...', upper(fxnname));
end

% loop till description is ok
ok = false;

while ~ok
    
    % get input
    description = inputdlg(inPrompt, inTitle, numLines, defaultAnswer);
    
    % check for user abort
    if isempty(description)
        error('description cancelled by user');
    else
        ok = true; % hope for the best
    end
    
    % read description. Functionname, description and synopsis are required
    fxnname = description{2};
    if isempty(fxnname) || isempty(description{2})...
            || isempty(description{3}) || isempty(description{4}) ||...
            any(findstr(description{3},'...')) || isempty(regexpi(description{4},fxnname))
        h = errordlg('Username, function name, description and synopsis are required inputs!');
        uiwait(h);
        ok = false;
    end
    
    % check whether function already exists (again)
    fxnCheck = which(fxnname);
    if ~isempty(fxnCheck)
        h = errordlg('%s already exists: %s',fxnname,fxnCheck);
        uiwait(h);
        ok = false;
    end
    
    % check for ok and update defaultAnswer with description if necessary
    if ~ok
        defaultAnswer = description;
    end
    
end % while

% read other input
username = description{1};
desc = description{3};
synopsis = description{4};
% if there are line breaks in inputtext and outputtext: make sure that
% these lines will still be commented!
inputtext = description{5};
% add line breaks if necessary, turn into single line of text
if size(inputtext,1) > 1
    inputtext = [inputtext,repmat('\n',size(inputtext,1),1)];
    inputtext(end,end-1:end) = ' ';
    inputtext = inputtext';
    inputtext = inputtext(:)';
    % kill some white space
    inputtext = regexprep(inputtext,'(\s*)\\n','\\n');
end
if strfind(inputtext,'\n')
    inputtext = regexprep(inputtext,'\\n','\\n%%\\t\\t');
end
outputtext = description{6};
if size(outputtext,1) > 1
    outputtext = [outputtext,repmat('\n',size(outputtext,1),1)];
    outputtext(end,end-1:end) = ' ';
    outputtext = outputtext';
    outputtext = outputtext(:)';
    outputtext = regexprep(outputtext,'(\s*)\\n','\\n');
end
if strfind(outputtext,'\n')
    outputtext = regexprep(outputtext,'\\n','\\n%%\\t\\t\\t');
end

% ask for directory to save the function
dirName = uigetdir(pwd,'select save directory');
if dirName == 0
    error('directory selection cancelled by user')
end
% end of data-gathering stage

%=================

%=================
%% WRITE FUNCTION
%=================

% create the filename based on the function name
fsuffix = '.m';
filename = fullfile(dirName,[fxnname fsuffix]);
% end filename creation

% check for function vs. class and add default superclasses if necessary
d7 = str2double(description{7});
if isnan(d7)
    superclass = description{7};
    isClass = true;
elseif d7 == 2 || d7 == 3
    isClass = true;
    superclass = superclass{d7-1};
else
    isClass = false;
end

if ~isClass % it's a function
    % beginning of file-printing stage
    fid = fopen(filename,'wt');
    fprintf(fid,'function %s\n',synopsis);
    fprintf(fid,'%%%s\n',desc);
    fprintf(fid,'%%\n');
    fprintf(fid,'%% SYNOPSIS: %s\n',synopsis);
    fprintf(fid,'%%\n');
    fprintf(fid,['%% INPUT ',inputtext,'\n']);
    fprintf(fid,'%%\n');
    fprintf(fid,['%% OUTPUT ',outputtext,'\n']);
    fprintf(fid,'%%\n');
    fprintf(fid,'%% REMARKS\n');
    fprintf(fid,'%%\n');
    fprintf(fid,'%% created with MATLAB ver.: %s on %s\n',vers,os);
    fprintf(fid,'%%\n');
    fprintf(fid,'%% created by: %s\n',username);
    fprintf(fid,'%% DATE: %s\n',datetoday);
    fprintf(fid,'%%\n');
    fprintf(fid,'%s\n',repmat('%',1,75));
    fclose(fid);
    % end of file-printing stage
else % it's a class
    fid = fopen(filename,'wt');
    fprintf(fid,'%%%s\n',desc);
    fprintf(fid,'%%\n');
    fprintf(fid,'%% CONSTRUCTOR: %s\n',synopsis);
    fprintf(fid,['%%   IN : ',inputtext,'\n']);
    fprintf(fid,['%%   OUT: ',outputtext,'\n']);
    fprintf(fid,'%%\n');
    fprintf(fid,'%% PROPERTIES\n');
    fprintf(fid,'%%   #property1:\n');
    fprintf(fid,'%%\n');
    fprintf(fid,'%% METHODS\n');
    fprintf(fid,'%%   #method1: short description\n');
    fprintf(fid,'%%        out = method1(obj,in)\n');
    fprintf(fid,'%%        Description of input and output\n');
    fprintf(fid,'%%\n');
    fprintf(fid,'%% REMARKS\n');
    fprintf(fid,'%%\n');
    fprintf(fid,'%% created with MATLAB ver.: %s on %s\n',vers,os);
    fprintf(fid,'%%\n');
    fprintf(fid,'%% created by: %s\n',username);
    fprintf(fid,'%% DATE: %s\n',datetoday);
    fprintf(fid,'%%\n');
    fprintf(fid,'%s\n',repmat('%',1,75));
    % subclass myClass or myHandle by default
    if ~isempty(superclass)
        fprintf(fid,'\nclassdef %s < %s\n\nend',fxnname,superclass); %#ok<PFCEL>
    else
        fprintf(fid,'\nclassdef %s\n\nend',fxnname);
    end
    fclose(fid);
end

% pop up the newly generated file
edit(filename);