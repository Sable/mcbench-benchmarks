function [depFiles] = lexdepfun(rootFunction,varargin)
%
% lexdepfun.m--Recursively searches for file dependencies for the specified
% mfile. If the mfile name specified by the user does not include any path
% information, which.m will be used to acquire it.
%
% Only user-defined mfiles are returned as dependencies.
%
% If optional, second argument is '-quiet', then progress is not displayed
% as search happens.
%
% Syntax: depFiles = lexdepfun(rootFunction,<quietFlag>)
%
% e.g.,   depFiles = lexdepfun('myplot')

% Developed in Matlab 7.6.0.324 (R2008a) on GLNX86.
% Kevin Bartlett (kpb@uvic.ca), 2008-06-25 13:45
%-------------------------------------------------------------------------

% Development note. Rewritten largely from scratch in June 2008 to work
% with class-definition directories ("@-directories").

isQuiet = false;

if nargin > 1
    if strcmpi(varargin{1},'-quiet')
        isQuiet = true;
    end % if
end % if

recursionLevel = 0;
alreadySearched = {};

% Get list of paths to search and make first recursive call.
[pathName,rootBaseName,ext] = fileparts(rootFunction);

if isempty(pathName)
    % If no path information, use which.m to get path to root function.
    rootFunction = whichfile(rootFunction);

    if isempty(rootFunction)
        error([mfilename '.m--rootFunction must be on Matlab''s path.']);
    end % if

end % if

% Get list of directories to search.
pathStr = path;

if isunix
    pathCell = textscan(pathStr,'%s','delimiter',':');
else
    pathCell = textscan(pathStr,'%s','delimiter',';');
end % if

pathCell = pathCell{1};

% Exlude the current directory and parent directory indicators ('.' and
% '..', respectively) from the list of directories to search.
matchIndex = strmatch('.',pathCell);
pathCell(matchIndex) = [];
matchIndex = strmatch('..',pathCell);
pathCell(matchIndex) = [];

% Only interested in user-defined functions, so exclude Mathworks
% mfiles.
matPath = matlabroot;
matchIndex = strmatch(matPath,pathCell);
pathCell(matchIndex) = [];

% Get list of base names of all mfiles on path. Only the base names are
% collected because these are what are searched for lexically in the
% file whose dependencies are being determined.
onPathBaseNames = {};

for iPath = 1:length(pathCell)

    thisDir = pathCell{iPath};
    dirOut = dir(fullfile(thisDir,'*.m'));
    numFiles = length(dirOut);
    thisPathBaseNames = cell(1,numFiles);

    for iFile = 1:numFiles
        [dummy,thisBaseName] = fileparts(dirOut(iFile).name);
        thisPathBaseNames{iFile} = thisBaseName;
    end % for

    onPathBaseNames = union(onPathBaseNames,thisPathBaseNames);

    % If there are any "@-directories" (class-definition directories) in
    % this directory, then the class-definition files they contain are also
    % on Matlab's search path, although they do not appear in the output
    % from path.m. For example, if a sub-directory named "@dial" exists in
    % this directory, then the file ".../@dial/dial.m" should be included
    % in onPathBaseNames.
    dirOut = dir(fullfile(thisDir,'@*'));
    numFiles = length(dirOut);
    atDirNames = cell(1,numFiles);

    for iFile = 1:numFiles
        [dummy,thisBaseName] = fileparts(dirOut(iFile).name);
        thisBaseName = strrep(thisBaseName,'@','');
        atDirNames{iFile} = thisBaseName;
    end % for

    onPathBaseNames = union(onPathBaseNames,atDirNames);

end % for

% Make recursive call to search routine and return results.
if isQuiet == false
    progressStr = ['RecursionLevel ' num2str(recursionLevel) ' (' rootBaseName ') '];
    fprintf(1,'%s',progressStr);
end % if

[depFiles,recursionLevel] = recursive_search(rootFunction,recursionLevel,onPathBaseNames,alreadySearched,isQuiet);

if isQuiet == false
    fprintf(1,'\n');
end % if

%-------------------------------------------------------------------------
function [depFiles,recursionLevel,alreadySearched] = recursive_search(rootFunction,recursionLevel,onPathBaseNames,alreadySearched,isQuiet)
%
% recursive_search.m--Recursively searches the specified function
% (fully-qualified filename) for dependencies.
%
% Syntax: [depFiles,recursionLevel,alreadySearched] = recursive_search(rootFunction,recursionLevel,onPathBaseNames,alreadySearched,isQuiet)

%-------------------------------------------------------------------------

depFiles = {rootFunction};
candidates = onPathBaseNames;

% If there is a "private" directory under the root function's directory,
% then the mfiles it contains will need to be considered as possible
% dependencies (private directories don't appear in Matlab's path).
[pathName,rootBaseName,ext] = fileparts(rootFunction);
privDirName = fullfile(pathName,'private');
privDirBaseNames = {};

if exist(privDirName,'dir')

    dirOut = dir(fullfile(privDirName,'*.m'));

    numPrivFiles = length(dirOut);
    privDirBaseNames = cell(1,numPrivFiles);

    for iFile = 1:numPrivFiles
        [dummy,thisBaseName] = fileparts(dirOut(iFile).name);
        privDirBaseNames{iFile} = thisBaseName;
    end % for

    candidates = union(candidates,privDirBaseNames);

end % if

% If the root function lives in an "@-directory" (a class-definition
% directory), then any other files in that directory should be considered
% as possible dependencies, just like the contents of a "private" directory
% (parent directories of @-directories appear in Matlab's path, but the
% @-directories themselves do not).
[dummy,parentDirName] = fileparts(pathName);
classDefBaseNames = {};

if strncmp(parentDirName,'@',1)

    dirOut = dir(fullfile(pathName,'*.m'));

    numClassDefFiles = length(dirOut);
    classDefBaseNames = cell(1,numClassDefFiles);

    for iFile = 1:numClassDefFiles
        [dummy,thisBaseName] = fileparts(dirOut(iFile).name);
        classDefBaseNames{iFile} = thisBaseName;
    end % for

    classDefBaseNames = setdiff(classDefBaseNames,rootBaseName);
    candidates = union(candidates,classDefBaseNames);

end % if

% Look in the mfile being searched for strings that match the candidate
% dependencies.
lexicalMatches = lexical_search(rootFunction,candidates);

% Each of the lexical matches is a possible dependency that itself must be
% searched for dependencies.
numMatches = length(lexicalMatches);

if isQuiet == false
    if numMatches == 0
        progressStr = 'no lexical matches found.';
        fprintf(1,'%s',progressStr);
    end % if
end % if

for iMatch = 1:numMatches

    % Show progress.
    if isQuiet == false
        progressStr = ['lexical match ' num2str(iMatch) ' of ' num2str(numMatches) '.'];
        fprintf(1,'%s',progressStr);
    end % if

    thisMatch = lexicalMatches{iMatch};
    recursiveRootFunction = '';

    if ismember(thisMatch,privDirBaseNames)
        recursiveRootFunction = fullfile(privDirName,[thisMatch '.m']);
    elseif ismember(thisMatch,classDefBaseNames)
        recursiveRootFunction = fullfile(pathName,[thisMatch '.m']);
    elseif ismember(thisMatch,onPathBaseNames)
        % Dependency is on Matlab's path, so can use which.m to find it.
        recursiveRootFunction = whichfile(thisMatch);
    end % if

    if ~isempty(recursiveRootFunction)

        if ~ismember(recursiveRootFunction,alreadySearched)

            recursionLevel = recursionLevel + 1;
            
            if recursionLevel > 0
                progressStr = ['RecursionLevel ' num2str(recursionLevel) ' (' thisMatch ') '];
                leadingBlank = repmat('.',1,recursionLevel*6);
                progressStr = sprintf('%s%s',leadingBlank,progressStr);
            else
                progressStr = ['RecursionLevel ' num2str(recursionLevel) ' (' thisMatch ') '];
                progressStr = sprintf('\n%s',progressStr);                
            end % if
            
            if isQuiet == false
                fprintf(1,'\n%s',progressStr);
            end % if

            alreadySearched = union(alreadySearched,recursiveRootFunction);

            [newDepFiles,recursionLevel,alreadySearched] = ...
                recursive_search(recursiveRootFunction,recursionLevel,candidates,alreadySearched,isQuiet);

            recursionLevel = recursionLevel - 1;

            if recursionLevel > 0
                progressStr = ['RecursionLevel ' num2str(recursionLevel) ' (' thisMatch ') '];
                leadingBlank = repmat('.',1,recursionLevel*6);
                progressStr = sprintf('%s%s',leadingBlank,progressStr);
            else
                progressStr = ['RecursionLevel ' num2str(recursionLevel) ' (' thisMatch ') '];
                progressStr = sprintf('\n%s',progressStr);                
            end % if
            
            if isQuiet == false
                fprintf(1,'\n%s',progressStr);
            end % if

            depFiles = union(depFiles,newDepFiles);

        end % if

    end % if

end % for

%-------------------------------------------------------------------------
function [lexicalMatches] = lexical_search(filename,candidates)
%
% lexical_search.m--Searches the specified function (fully-qualified
% filename) for strings that match candidates for dependencies. The
% basename of the function itself is not returned in the list of lexical
% matches.
%
% Syntax: lexicalMatches = lexical_search(filename,candidates)

%-------------------------------------------------------------------------

% Get list of characters that are not permitted in an mfilename.

% ...The list of permitted characters includes a whitespace. This is so
% that the whitespace separating words in a line of the mfile are not
% removed along with the '(', '}', etc.
goodChars = [ ['a':'z'] ['A':'Z'] ['0':'9'] '_' ' ' ];
badChars = setdiff(char(1:127),goodChars);
tokens = {};

% Read in the mfile and extract string tokens from it. "Tokens" are
% space-delimited strings that conform to our expectations of what an mfile
% basename should look like (no special characters or leading numeric
% characters, etc.)
fullRootMfile = whichfile(filename);

if ~isempty(fullRootMfile)

    fid = fopen(fullRootMfile);

    if fid < 1
        error([mfilename '.m--Could not open mfile ' fullRootMfile '.']);
    end % if

    textLines = textscan(fid,'%s','commentstyle','%','delimiter','\n','whitespace','');
    fclose(fid);
    textLines = strtrim(textLines{1});
    numLines = length(textLines);

    % The 'commentstyle' parameter for textscan isn't smart enough to
    % detect comment lines when preceded by spaces. Now that textLines has
    % been deblanked, seek out comment lines and delete them.
    for lineCount = 1:numLines

        thisLine = textLines{lineCount};

        if ~isempty(thisLine)
            if strcmp(thisLine(1),'%')
                textLines{lineCount} = '';
            end % if
        end % if

    end % for

    % Cycle through the lines and extract the strings from them.
    for lineCount = 1:numLines

        thisLine = textLines{lineCount};

        % Replace any characters that aren't allowed in mfilenames with
        % whitespaces.
        thisLine(ismember(thisLine,badChars)) = ' ';

        if isempty(thisLine)
            thisLineStrs = '';
        else
            thisLineStrs = textscan(thisLine,'%s');
            thisLineStrs = thisLineStrs{1};
        end % if

        % Ignore line if it is empty.
        if ~isempty(thisLineStrs)

            % Ignore line if it starts with 'function'.
            if strcmp(thisLineStrs{1},'function')==0
                [tokens{length(tokens)+1: ...
                    length(tokens)+length(thisLineStrs)}] = ...
                    deal(thisLineStrs{:});
            end % if

        end % if

    end % for

end % if

% Remove duplicate tokens.
tokens = unique(tokens);
numTokens = length(tokens);

% Remove tokens that have leading numeric characters (illegal for
% variable names or mfile names in Matlab). Perform the removal by
% replacing individual elements with blanks (simplifies indexing).
for iToken = 1:numTokens

    thisToken = tokens{iToken};

    if ismember(thisToken(1),'0123456789')
        tokens{iToken} = '';
    end % if

end % for

% Remove known Matlab keywords.
for iToken = 1:numTokens

    thisToken = tokens{iToken};

    if iskeyword(thisToken)
        tokens{iToken} = '';
    end % if

end % for

% Get rid of the blanks introduced by the removal of unwanted elements.
isGoodToken = true(1,numTokens);

for iToken = 1:numTokens

    thisToken = tokens{iToken};

    if isempty(thisToken)
        isGoodToken(iToken) = false;
    end % if

end % for

numTokens = length(isGoodToken(isGoodToken==true));
[tmp{1:numTokens}] = deal(tokens{isGoodToken});
tokens = tmp;

% Match the tokens with the candidate mfile basenames.
lexicalMatches = intersect(tokens,candidates);

% Remove the filename itself from its list of candidate dependencies.
[dummy,baseName] = fileparts(filename);
lexicalMatches = setdiff(lexicalMatches,baseName);

%-------------------------------------------------------------------------
function [whichFile] = whichfile(UNLIKELYFILENAME)
%
% whichfile.m--Like Matlab's which.m, but ignores variable names matching
% the input string.
%
% Matlab's which.m returns the string 'variable' when given an input string
% that matches the name of a variable on the workspace, even if the string
% also matches an m-file on the path. For example, 
%   name = which('jump')
% where an m-file named jump.m exists on the Matlab path AND 'jump' is the
% name of a variable results in the variable "name" being assigned the
% value 'variable'. 
%
% whichfile.m avoids this counter-intuitive behaviour by ignoring variables
% that match the input string.
%
% Syntax: whichFile = whichfile(fileName)
%
% e.g.,  ls = 99;
%        badOutput = which('ls') % (returns the string 'variable')
%        whichFile = whichfile('ls') 

% Developed in Matlab 7.2.0.232 (R2006a) on PCWIN.
% Kevin Bartlett (kpb@uvic.ca), 2008-02-12 23:38
%-------------------------------------------------------------------------

% This program makes use of a variable named "UNLIKELYFILENAME", under the
% assumption that it is extremely unlikely for a user to want to trace a
% file named "UNLIKELYFILENAME.m". Just in case, check to make sure that
% the variable UNLIKELYFILENAME does not contain the string
% 'UNLIKELYFILENAME'.
if strcmp(UNLIKELYFILENAME,'UNLIKELYFILENAME')
    error([mfilename '.m--The string ''UNLIKELYFILENAME'' is the ONLY string that is not allowed! Buy a lottery ticket!']);
end % if

% Because UNLIKELYFILENAME is the only variable in this workspace, can now
% use Matlab's which.m without inadvertently returning the string
% 'variable'.
whichFile = which(UNLIKELYFILENAME);
