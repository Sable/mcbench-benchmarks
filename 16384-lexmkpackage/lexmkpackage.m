function [] = lexmkpackage(fileSpec,varargin)
%
% lexmkpackage.m--Makes a software package by lexically checking the
% dependencies of the specified m-file(s). Uses the lexdepfun.m function,
% rather than Mathwork's depfun.m program, so can be used for assembling
% packages for GUI applications (Matlab's depfun.m does not detect callback
% dependencies).
%
% The package created by lexmkpackage.m is placed in a directory named
% "mkpackageDir" under the current working directory.
%
% The user specifies the m-files whose dependencies are to be searched
% using the input argument "fileSpec". fileSpec can be the fully-qualified
% filename of an m-file. Alternatively, if the m-file is on Matlab's search
% path, then just the name of the m-file (without path information) can be
% provided instead. 
%
% Multiple filenames can be specified either as a cell array of strings or
% using the '*' wildcard character.
%
% lexdepfun.m detects only user-defined m-files.
%
% lexdepfun.m cannot detect dependant functions whose m-file names are
% generated dynamically at runtime with, for example, eval.m. 
%
% Options:
%
%    LEXMKPACKAGE(fileSpec,...,'-quiet') suppresses progress output.
%
%    LEXMKPACKAGE(fileSpec,...,'-preserve') preserves the directory
%    structure of the dependent m-files when creating the package. This,
%    the default behaviour, is necessary to avoid namespace collisions when
%    multiple m-files with the same name are encountered or when "private"
%    directories contain special, modified versions of standard Matlab
%    routines. An additional m-file, package_path.m is created. Running
%    package_path.m will add the paths of the package sub-directories to
%    Matlab's search path.
%
%    LEXMKPACKAGE(fileSpec,...,'-consolidate') puts all dependent m-files
%    into the same directory. This method gives more convenient results
%    than the '-preserve' method, but will fail if multiple m-files with
%    the same name are encountered.
%
%    LEXMKPACKAGE(fileSpec,...,'-file') puts the code from all dependent
%    m-files into a single m-file. This method will only work if the
%    fileSpec input argument refers to a single "root" m-file. Note that
%    this method should not be used for GUI packages, as GUI callback
%    routines must be visible from the root workspace. The '-file' method
%    will not produce a useable file when any of the dependent m-files are
%    scripts, rather than functions.
%
% N.B., the package created by lexmkpackage.m will frequently contain extra
% files in addition to the ones actually needed. This is an unavoidable
% side-effect of the lexical dependency search algorithm.
%
% Syntax: lexmkpackage(fileSpec,<'-file'>,<'-preserve'>,<'-consolidate'>,<'-quiet'>,)
%
% e.g.,   lexmkpackage('/home/bartlett/matlab/units/*.m')
% e.g.,   lexmkpackage('date2yearday','-file','-quiet')
% e.g.,   lexmkpackage('acquire_vmp')
% e.g.,   lexmkpackage({'lsm' 'newfig'},'-consolidate')
% e.g.,   lexmkpackage({'/home/bartlett/matlab/FileOps/lsm.m' '/home/bartlett/matlab/plotting/newfig.m'})

% Developed in Matlab 7.3.0.298 (R2006b) on GLNX86.
% Kevin Bartlett (kpb@uvic.ca), 2007-04-27
%-------------------------------------------------------------------------

% Handle input arguments.
makeSingleFileSpecified = 0;
preserveSpecified = 0;
consolidateSpecified = 0;
isQuiet = 0;

if nargin > 1

    for arg = varargin

        arg = lower(arg);

        if strcmp(arg,'-file') == 1
            %doMakeSingleFile = 1;
            makeSingleFileSpecified = 1;
        elseif strcmp(arg,'-preserve') == 1
            preserveSpecified = 1;
        elseif strcmp(arg,'-consolidate') == 1
            consolidateSpecified = 1;
        elseif strcmp(arg,'-quiet') == 1
            isQuiet = 1;
        else
            error([mfilename '.m--Unrecognised input argument ''' varargin{1}  '''.'])
        end % if

    end % for

end % if

% Determine whether directory structure is to be preserved or whether
% dependent mfiles will be consolidated in a single directory or m-file.
% Preservation, consolidation and single-file output are mutually
% exclusive.
doPreserve = 1;
doMakeSingleFile = 0;
doConsolidate = 0;

if consolidateSpecified == 1
    doPreserve = 0;
    doMakeSingleFile = 0;
    doConsolidate = 1;
end % if

if makeSingleFileSpecified == 1
    doPreserve = 0;
    doMakeSingleFile = 1;
    doConsolidate = 0;
end % if

% Make the new directory to contain the package.
mkpackageDirName = 'mkpackageDir';
mkpackageDir = fullfile(pwd,mkpackageDirName);

if exist(mkpackageDir,'dir')==7

    %disp([mfilename '.m--Directory ' mkpackageDir ' already exists.']);
    disp([mfilename '.m--Directory already exists:']);
    disp(mkpackageDir);
    resp = input('Delete it and start over? Y/N:   ','s');

    if ~isempty(strmatch(lower(resp),'yes'))

        [rmdir_success,rmdir_mssg,rmdir_mssgID] = rmdir(mkpackageDir,'s');

        if rmdir_success == 0
            error([mfilename '.m--Failed to remove existing directory: ' mkpackageDir '.']);
        end % if

    else
        disp([mfilename '.m--Execution halted; package not created.']);
        return;
    end % if

end % if

% List the files specified by the user.

% % ...If fileSpec was entered as a cell array, assume it consists of m-file
% % names.
% if iscell(fileSpec)
%     rootFileList = fileSpec;
% else
%     % Otherwise, treat fileSpec as a string indicating the location of an
%     % m-file or files (either a filename or a wildcard-containing file
%     % specifier).
%     rootFileList = list_root_files(fileSpec);
% end % if
% 

% Convert fileSpec to a cell array if necessary.
if ~iscell(fileSpec)
    fileSpec = {fileSpec};
end % if

% Assemble list of "root" files to search.
rootFileList = {};

for iFile = 1:length(fileSpec)
    
    thisFileSpec = fileSpec{iFile};
    
    % Treat this file specifier string as a sort of regular expression, and
    % look for files that match it.
    thisRootFileList = list_root_files(thisFileSpec);
    
    % If no file was found to match the file specifier as a regular
    % expression, assume that the user has entered the basename of an
    % m-file and look for it on the Matlab search path.
    if isempty(thisRootFileList)
        thisRootFileList = {which(thisFileSpec)};
    end % if
    
    % Append any mfiles found with this file specifier to the list of root
    % files.
    if ~isempty(thisRootFileList)        
        %rootFileList{end+1} = thisRootFileList;
        [rootFileList{length(rootFileList)+1:length(rootFileList)+length(thisRootFileList)}] = deal(thisRootFileList{:});
    end % if
        
end % for

if isempty(rootFileList)
    %error([mfilename '.m--Must specify m-file(s) on Matlab''s search path.'])
    error([mfilename '.m--fileSpec argument matched no m-file or any function on Matlab''s search path. Package not created.'])
end % if

% Creating a package inside an m-file is only allowed when a single m-file
% has been specified by the user. This is because if multiple m-files are
% consolidated into a single m-file, only one of the functions is
% accessible from the root workspace, making it pointless to include
% multiple files unless they are dependents of the main function.
if doMakeSingleFile == 1 & length(rootFileList)>1
    error([mfilename '.m--Cannot create a single-file package for multiple m-files.'])
end % if

numFiles = length(rootFileList);

% Find the dependencies for the specified m-files.
depList = {};

for iFile = 1:numFiles

    if ~isQuiet
        disp([mfilename '.m--Finding dependencies of m-file ' num2str(iFile) ' of ' num2str(numFiles)]);
    end % if
    
    thisFile = rootFileList{iFile};
        
    [dummy,thisBaseName] = fileparts(thisFile);

    % Find the dependents of this m-file.
    if isQuiet
        thisDepList = lexdepfun(thisFile,'-quiet');
    else
        thisDepList = lexdepfun(thisFile);
    end % if

    % Combine with previous dependencies. It is okay to use union.m here
    % because the dependency list contains fully-qualified mfile names, so
    % the only duplicates that will be removed are TRUE duplicates (not
    % just mfiles with the same basenames).
    depList = union(depList,thisDepList);

end % for

% Test for duplicate mfile basenames. Duplicate names are not necessarily a
% problem if the directory structure is being preserved. If all the m-files
% are going to be consolidated in a single directory or in a single, large
% m-file, on the other hand, duplicate mfilenames will have unpredictable
% results.
[dummy,depBaseNames] = mfileparts(depList);
duplicatesExist = length(unique(depBaseNames)) ~= length((depBaseNames));

if duplicatesExist & (doMakeSingleFile == 1 | doPreserve == 0)
    error([mfilename '.m--Cannot consolidate all dependent m-files in a single directory or single m-file because there are duplicate m-file names.'])
end % if

% Create directory to contain package.

% Mkdir uses only 2 output arguments on linux version of matlab.
%[mkdir_success,mkdir_mssg,mkdir_mssgID] = mkdir(pwd,mkpackageDirName);
[mkdir_success,mkdir_mssg] = mkdir(pwd,mkpackageDirName);

if mkdir_success ~= 1
    error([mfilename '.m--Error creating directory: ' mkdir_mssg]);
end % if

% The list of dependencies contains the name(s) of the root file(s), but
% they may be mixed up with the dependent files. Create a new file list
% containing both the root file(s) and the dependent files, but with the
% root file(s) at the start of the list.
depList = setdiff(depList,rootFileList);
numSourceFiles = length(rootFileList) + length(depList);
[sourceFiles{1:numSourceFiles}] = deal(rootFileList{:},depList{:});
[sourceDirs,sourceBaseNames,sourceExts] = mfileparts(sourceFiles);

% Output the package.
if doMakeSingleFile == 1

    % Output package in the form of a single m-file containing (possibly)
    % multiple functions.

    % There is only one root file allowed when putting all the dependent
    % functions in a single mfile.
    rootFile = rootFileList{1};

    [dummy,rootBaseName,rootExt,dummy] = fileparts(rootFile);
    rootFileName = [rootBaseName rootExt];
    outFile = fullfile(mkpackageDir,rootFileName);
    outFid = fopen(outFile,'at');

    if outFid < 0
        error([mfilename '.m--Failed to open output file for writing.']);
    end % if

    % Output the code from the source files into the output m-file.
    for iSource = 1:length(sourceFiles)

        thisSource = sourceFiles{iSource};

        sourceFid = fopen(thisSource,'rt');

        if thisSource < 0
            error([mfilename '.m--Failed to open mfile for reading.']);
        end % if

        % Specify empty character for whitespace parameter when calling
        % textscan.m, or leading whitespace is discarded.
        %sourceCode = textscan(sourceFid,'%s','delimiter','\n');
        sourceCode = textscan(sourceFid,'%s','delimiter','\n','whitespace','');
        sourceCode = sourceCode{1};

        for iLine = 1:length(sourceCode)
            fprintf(outFid,'%s\n',sourceCode{iLine});
        end % for

        fclose(sourceFid);

        % Print out a divider line to separate functions.
        if iSource < length(sourceFiles)
            fprintf(outFid,'%s\n\n','%-------------------------------------------------------------------------');
        end % if

    end % for each dependent file

    fclose(outFid);

elseif doPreserve == 1
    
    % Separate the root path from the subdirectory for all the
    % directories to be copied (if all the files are in, say,
    % /home/bartlett/matlab/oceanography/mapping/, can copy them all to
    % a directory named "mapping"; there is no need to preserve the
    % /home/bartlett/matlab/oceanography/ part).

    %for i = 1:144, if strfind(sourceFiles{i},'private'),disp(sourceFiles{i}),end,end
    %[depDirs,depBaseNames,depExts] = mfileparts(sourceFiles);
    [parentPath,sourceSubDirs] = find_parent_path(sourceDirs);

    for iSource = 1:length(sourceFiles)

        thisSource = sourceFiles{iSource};
        thisSubDir = sourceSubDirs{iSource};
        thisBaseName = sourceBaseNames{iSource};
        thisExt = sourceExts{iSource};
        thisTargDir = fullfile(mkpackageDir,thisSubDir);

        if exist(thisTargDir,'dir') == 0

            mkdirSuccess = mkdir(thisTargDir);

            if mkdirSuccess ~= 1
                error([mfilename '.m--Failed to make directory ' thisTargDir '.']);
            end % if

        end % if

        thisTarget = fullfile(thisTargDir,[thisBaseName thisExt]);
        copySuccess = copyfile(thisSource,thisTarget);

        if copySuccess ~= 1
            error([mfilename '.m--Failed to copy file ' thisTarget '.']);
        end % if

    end % for each dependent file

    % Create m-file, package_path.m, to contain code for adding the package
    % contents to Matlab's path.
    pathFileFid = fopen(fullfile(mkpackageDir,'package_path.m'),'wt');
    
    if pathFileFid < 0
        error([mfilename '.m--Failed to open ''package_path.m'' file for writing.']);
    end % if

    fprintf(pathFileFid,'%s\n','function [] = package_path()');
    fprintf(pathFileFid,'%s\n','%');
    fprintf(pathFileFid,'%s\n','% package_path.m--Adds the package to the Matlab path.');
    fprintf(pathFileFid,'%s\n','%');
    fprintf(pathFileFid,'%s\n',['% Created automatically by ' mfilename '.m, ' datestr(now,31)]);
    fprintf(pathFileFid,'%s\n','%');
    fprintf(pathFileFid,'%s\n','%-------------------------------------------------------------------------');
    fprintf(pathFileFid,'%s\n','');
    fprintf(pathFileFid,'%s\n','% Get absolute path to package_path.m.');
    fprintf(pathFileFid,'%s\n','thisMFile = mfilename(''fullpath'');');    
    fprintf(pathFileFid,'%s\n','thisDir = fileparts(thisMFile);');
    fprintf(pathFileFid,'%s\n','');
    fprintf(pathFileFid,'%s\n','% Add the paths of the mfiles in the package to the Matlab path.');

    pathsToAdd = unique(sourceSubDirs);
    
    for iPath = 1:length(pathsToAdd)

        thisPartialPath = pathsToAdd{iPath};
       
        % "Private" directories are not allowed in Matlab's search path.
        [dummy,bottomDirName] = fileparts(thisPartialPath);
        
        if strcmp(bottomDirName,'private') == 0
            thisFullPathStr = ['[thisDir ''' filesep thisPartialPath ''']'];
            addPathStr = ['addpath(' thisFullPathStr ');'];
            fprintf(pathFileFid,'%s\n',addPathStr);
        end % if

    end % for

    fclose(pathFileFid);
    
elseif doConsolidate == 1

    % Consolidate all mfiles in one directory.
    for iSource = 1:length(sourceFiles)

        thisSource = sourceFiles{iSource};
        thisBaseName = sourceBaseNames{iSource};
        thisExt = sourceExts{iSource};

        thisTarget = fullfile(mkpackageDirName,[thisBaseName thisExt]);
        copySuccess = copyfile(thisSource,thisTarget);

        if copySuccess ~= 1
            error([mfilename '.m--Failed to copy file ' thisTarget '.']);
        end % if

    end % for each dependent file

end % if making single file package

if isQuiet == 0
    disp([mfilename '.m--Package created.']);
end % if

%------------------------------------------------------------------------------
function fileList = list_root_files(fileSpec)
%
% list_root_files.m--Makes a list of the "root" files from the
% file-specifier string provided by the user and returns it as a CELL
% array.
%
% LIST_ROOT_FILES(fileSpec) returns a list of files according to the string
% found in fileSpec. fileSpec may include the wildcard character "*" and/or
% path information.
%
% Syntax: fileList = list_root_files(fileSpec);
%
% e.g., fileList = list_root_files('D:\MATLAB\toolbox\matlab\graph2d\plot*.m')

% Developed in Matlab 6.5.0.180913a (R13) on SUN OS 5.8.
% Kevin Bartlett(kpb@hawaii.edu), 2003/12/18, 11:04
%------------------------------------------------------------------------------

% If path not specified, default to current directory.
[filePath,name,extension,ver] = fileparts(fileSpec);

if isempty(filePath),
    filePath = pwd;
    fileSpec = fullfile(filePath,[name,extension,ver]);
end % if

% If fileSpec represents an existing directory with no file name or wild
% cards appended to it, then return an empty list.
if exist(fileSpec,'dir') == 7
    fileList = {};
else

    % Get list of files conforming to file specifier string.
    eval(['dirStruct = dir(''' fileSpec ''');'])
    fileList = char(dirStruct.name);

    % Exit if no files.
    if isempty(fileList)
        fileList = {};
        return;
    end % if

    % Discard directories from the list.
    isDir = {};
    [isDir{1:length(dirStruct),1}] = deal(dirStruct.isdir);
    isDir = cat(1,isDir{:});
    fileList = fileList(isDir == 0,:);

    % Convert to cell array.
    if isempty(fileList)
        fileList = {};
    else
        fileList = cellstr(fileList);
    end % if

    % Prepend path information to the list.
    numFiles = length(fileList);

    newFileList = cell(numFiles,1);

    for iFile = 1:numFiles
        newFileList{iFile} = fullfile(filePath,fileList{iFile});
    end % for

    fileList = newFileList;
    clear newFileList;

    % Sort the file list to get consistent file order.
    fileList = sort(fileList);

end % if

%-------------------------------------------------------------------------
function [pathStr,baseName,ext,versn] = mfileparts(fileList)
%
% mfileparts.m--Runs Mathworks' fileparts.m function on multiple filenames
% (fileparts.m only works on one file at a time). Result is returned in the
% form of cell arrays.
%
% If input argument is a single filename in the form of a string, rather
% than a cell array, mfileparts.m acts just like fileparts.m and
% returns strings rather than cell arrays.
%
% Syntax: [pathStr,baseName,ext,versn] = mfileparts(fileList)
%
% e.g.,   fileList = {'/home/bartlett/matlab/FileOps/where.m',...
%                     '/home/bartlett/matlab/bearings/count_rots.m',...
%                     '/home/bartlett/matlab/bearings/plot_rots.m',...
%                     '/home/bartlett/matlab/colours/getcolours.m',...
%                     '/home/bartlett/matlab/filters/decimate_me.m'};
%         [pathStr,baseName,ext,versn] = mfileparts(fileList)
%
% e.g.,   [pathStr,baseName,ext,versn] = mfileparts('/home/bartlett/matlab/FileOps/where.m')

% Developed in Matlab 7.3.0.298 (R2006b) on GLNX86.
% Kevin Bartlett (kpb@uvic.ca), 2007-04-27 16:08
%-------------------------------------------------------------------------

if iscell(fileList)
    isCellInput = 1;
elseif isstr(fileList)
    isCellInput = 0;
    fileList = cellstr(fileList);
else
    error([mfilename '.m--Input must be a cell array of strings or a single string.']);
end % if

nFiles = length(fileList);

[pathStr{1:nFiles}] = deal('');
baseName = pathStr;
ext = pathStr;
versn = pathStr;

for iFile = 1:nFiles    
    thisFile = fileList{iFile};
    [thisPathStr,thisBaseName,thisExt,thisVersn] = fileparts(thisFile);
    pathStr{iFile} = thisPathStr;
    baseName{iFile} = thisBaseName;
    ext{iFile} = thisExt;
    versn{iFile} = thisVersn;        
end % for

% If input was a string, make output just like fileparts.m.
if ~isCellInput
    pathStr = pathStr{1};
    baseName = baseName{1};
    ext = ext{1};
    versn = versn{1};
end % if

%-------------------------------------------------------------------------
function [parentPath,relativePaths] = find_parent_path(fileList)
%
% find_parent_path.m--Given a list of files (or directories),
% find_parent_path.m returns their shared parent path and their individual,
% relative paths.
%
% This program was developed on a Unix machine, but could presumably be
% adapted to Windows fairly easily.
%
% Syntax: [parentPath,relativePaths] = find_parent_path(fileList)
%
% e.g.,   fileList = {'/home/bartlett/matlab/FileOps/where.m',...
%                     '/home/bartlett/matlab/bearings/count_rots.m',...
%                     '/home/bartlett/matlab/bearings/plot_rots.m',...
%                     '/home/bartlett/matlab/colours/getcolours.m',...
%                     '/home/bartlett/matlab/colours/modcolours/redshift.m',...
%                     '/home/bartlett/matlab/filters/decimate_me.m'};
%         [parentPath,relativePaths] = find_parent_path(fileList)
%
% e.g., (Windows):
%        fileList = {'C:\Documents and Settings\bartlett\filesFileOps\where.m',...
%                    'C:\Documents and Settings\bartlett\bearings\count_rots.m',...
%                    'C:\Documents and Settings\bartlett\bearings\plot_rots.m',...
%                    'C:\Documents and Settings\bartlett\colours\getcolours.m',...
%                    'C:\Documents and Settings\bartlett\colours\redshift.m',...
%                    'C:\Documents and Settings\bartlett\filters\decimate_me.m'}
%         [parentPath,relativePaths] = find_parent_path(fileList)

% Developed in Matlab 7.3.0.298 (R2006b) on GLNX86.
% Kevin Bartlett (kpb@uvic.ca), 2007-04-27 16:32
%-------------------------------------------------------------------------

fileSep = filesep;

if strcmp(fileSep,'\')
   textscan_fileSep = '\\';
else
   textscan_fileSep = fileSep;
end % if

parentPathComponents = {};
nFiles = length(fileList);

% If any of the filenames is an empty string, then there is no shared
% parent directory.
for iFile = 1:nFiles
    
    thisFile = fileList{iFile};
    
    if isempty(thisFile)
        parentPath = '';
        relativePaths = fileList;
        return;
    end % if
    
end % for

% Make a cell array, with each cell containing the path components of one
% member of the file list.
%[pathComponents{1:nFiles}] = deal('');
pathComponents = cell(nFiles,1);

for iFile = 1:nFiles
    thisFile = fileList{iFile};
    pathComponents(iFile) = textscan(thisFile,'%s','delimiter',textscan_fileSep);
end % for

% Find the common parent directories.
commonParentExists = 1;

while commonParentExists

    [currTopLevelDir{1:nFiles}] = deal('');

    for iFile = 1:nFiles

        thisFilePathComponents = pathComponents{iFile};

        if length(thisFilePathComponents) > 0
            currTopLevelDir{iFile} = thisFilePathComponents{1};
        end % if

    end % for

    % If all the directories share a leading directory name, strip it
    % off each of the filenames.
    if length(unique(currTopLevelDir)) == 1

        for iFile = 1:nFiles            

            thisFilePathComponents = pathComponents{iFile};

            if length(thisFilePathComponents) == 1
                thisFilePathComponents = {};
                pathComponents{iFile} = thisFilePathComponents;
            elseif length(thisFilePathComponents) > 1
                thisFilePathComponents = thisFilePathComponents(2:end);
                pathComponents{iFile} = thisFilePathComponents;
            end % if

            % If there are no remaining path components for this filename,
            % then it cannot share a common parent with the other
            % filenames.
            if isempty(thisFilePathComponents)
                commonParentExists = 0;
            end % if
            
        end % for

        % If the string giving the current top level is not empty, add it
        % to the components of the parent path (in unix file systems, the
        % first element returned by textscan.m is an empty string).
        if ~isempty(currTopLevelDir{1})
            parentPathComponents{end+1} = currTopLevelDir{1};
        end % if

    else
        commonParentExists = 0;
    end % if

end % while

% Assemble the components of the shared parent path into a single string.
if length(parentPathComponents) == 0
    parentPath = '';
elseif length(parentPathComponents) == 1    
    %parentPath = [filesep parentPathComponents{1}];
    parentPath = [parentPathComponents{1}];    
else
    %parentPath = [filesep fullfile(parentPathComponents{:})];
    parentPath = [fullfile(parentPathComponents{:})];
end % if

if isunix
    parentPath = [filesep parentPath];
end % if

% Assemble the components of each relative path into a single string.
relativePaths = cell(nFiles,1);

for iFile = 1:nFiles

    thisFilePathComponents = pathComponents{iFile};

    if length(thisFilePathComponents) == 0
        relativePaths{iFile} = '';
    elseif length(thisFilePathComponents) == 1
        relativePaths{iFile} = thisFilePathComponents{:};
    else
        relativePaths{iFile} = fullfile(thisFilePathComponents{:});
    end % if

end % for

