function start_slWorkshop_IDF(varargin)
% start_satconst is the entry point for the Satellite Constellation demo
%
%   By default, the arguments should be passed to the copyDemoFiles
%   utility function.  However, people can write their demos however they
%   see fit.
%
%   From the copyDemoFile help:
%
%   start_satconst('copy')   or  start_satconst(1)  copies the files
%
%   start_satconst('nocopy') or  start_satconst(0)  does not copy the files
%
%
%   start_satconst('author') changes to source directory
%
%   Remove any paths from root demo path downwards

close all;
clear all;
bdclose all;
clc;

workDir = pwd;
cleanPath;
%   Call standard function for copying files
if nargin > 0
    copyDemoFiles(varargin{1});
else
    copyDemoFiles;
end

% Open Presentation:
winopen([workDir '\Presentation' '\SL_workshop.pdf']);

%% BEGIN DEMO SPECIFIC STARTUP COMMANDS %%
% Modify the following commands to carry out whatever initialization you
% would like for your particular demo

% Add any necessary paths
disp('Temporarily modifying the MATLAB path...')
% addpath([pwd '\html']);

publish('Simulink_Workshop_Script');
uiopen('html\Simulink_Workshop_Script.html',1);
%%% END DEMO SPECIFIC STARTUP COMMANDS %%%
% Open Presentation:
% Display final location
clear workDir;
disp(['Finished in - ' pwd '...']);

%% HELPER FUNCTIONS
function copyDemoFiles(varargin)
%   COPYDEMOFILES is a common utility for people to use in their start_demo
%   function
%
%   copyDemoFiles('copy')   or  copyDemoFiles(1)  copies the files
%
%   copyDemoFiles('nocopy') or  copyDemoFiles(0)  does not copy the files
%
%   If given the 'author' flag, the script will change directories to the
%   'source' directory.
%
%   copyDemoFiles('author') changes to source directory

copyFlag = false;
if nargin ==1 && strcmp(varargin{1}, 'author')
    cd('source')
else
    if nargin < 1
        if exist(fullfile(pwd,'work'),'dir')
            if checkChanges(fullfile(pwd,'source'),fullfile(pwd,'work'))
                reply = input('Do you want to overwrite your working directory? y/n [n]: ', 's');
                if ~isempty(reply) && strncmpi(reply,'y',1)
                    copyFlag = true;
                end
            end
        else
            copyFlag = true;
        end
    else
        if all(varargin{1} == 1) || strcmpi(varargin{1},'copy')
            copyFlag = true;
        end
    end
    if copyFlag
        disp('Copying files...');
        %copyfile([pwd '\source'], [pwd '\work'] , 'f')
        copyfile(fullfile(pwd,'source'),fullfile(pwd,'work'), 'f')
        warning off MATLAB:FILEATTRIB:SyntaxWarning
        %fileattrib([pwd '\work'],'+w','a','s');
        fileattrib(fullfile(pwd,'work'),'+w','a','s')
        warning on MATLAB:FILEATTRIB:SyntaxWarning
    end
    %cd([pwd '\work']);  % Change directories
    cd(fullfile(pwd,'work')); % Change directories
end

%% CHECKCHANGES %%
% The following function is used to recursively check all the files in the
% source directory to look for any changes in either the source or the
% working directory.
% Accepts a full path to a Source directory and Working directory
function changes = checkChanges(sourceDir,workingDir)

changes = false;
sourceFiles = dir(sourceDir);
% set logical vector for subdirectory entries in d
isdir = logical(cat(1,sourceFiles.isdir));
dirs = sourceFiles(isdir); % select only directory entries from the current listing
files = sourceFiles(~isdir); % select only the files
for i = 1:length(files)
    sourceDate = files(i).datenum;
    workingFile = dir(fullfile(workingDir,files(i).name));
    if isempty(workingFile)
        disp(['File ',files(i).name,' has been deleted in the working directory.']);
        changes = true;
    else
        workingDate = workingFile(1).datenum;
        if workingDate > sourceDate
            disp(['File ',files(i).name,' has been modified in the working directory.']);
            changes = true;
        elseif sourceDate > workingDate
            disp(['File ',files(i).name,' has been modified in the source directory.']);
            changes = true;
        end
    end
end

for i=1:length(dirs)
    dirname = dirs(i).name;
    if ~strcmp(dirname,'.') && ~strcmp(dirname,'..')
        changes = changes | ...
            checkChanges(fullfile(sourceDir,dirname),fullfile(workingDir,dirname));
    end
end

%% CLEANPATH %%
function cleanPath
% Function to remove demo paths from MATLAB path

result = textscan(matlabpath,'%s','delimiter',pathsep);
pathEl = result{1};
bybye=strmatch(pwd,pathEl);
if ~isempty(bybye)
    disp('Clearing the MATLAB path of all directories from demo root downwards...')
    rmpath(pathEl{bybye});
    disp([num2str(length(bybye)),' entries removed from the path.'])
end