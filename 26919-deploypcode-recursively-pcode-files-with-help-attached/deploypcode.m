function deploypcode(source_dir, target_dir, varargin)
% DEPLOYPCODE recursively creates p-code versions of m-files in a given folder
%
% DEPLOYPCODE(SOURCE, TARGET) will recursively search the SOURCE folder for all .m files and
% deploy them as P-files to the TARGET folder using default options below.
%
% DEPLOYPCODE(..., 'PropertyName',VALUE,'PropertyName',VALUE,...) uses the following options
% when deploying p-code:
%
%   'recurse'           - When true (default) will recursively deploy p-code from SOURCE folder.
%
%   'ignoreStrings'     - String or cell array of strings of filenames to ignore. Regular expression
%                         syntax is used.
%
%   'ignoreSVN'         - Additional true/false option to ignore ".svn" directories. Equivalent to
%                         adding {'^\.svn$'} to "ignoreStrings". Defaults to TRUE for convenience.
%
%   'includeHelp'       - MATLAB's pcode() removes all comments including the help section from
%                         files when run. Setting this option to true (default) will export an
%                         additional .m file containing only the help contents of the file being
%                         deployed. This means that myFunction.m will be deployed to myFunction.p,
%                         but calling "help myFunction" will still return help text.
%
%   'updateOnly'        - When true, destination p-files will only be created if they don't yet
%                         exist or are older than the m-file being encoded. Defaults to false.
%
%   'copyDirectStrings' - String or cell array of strings of filenames to copy directly to TARGET 
%                         folder without encryption. Regular expression syntax is used.
%
%   'copyFigFiles'      - Additional true/false option to copy ".fig" files directly. Equivalent to
%                         adding {'\.fig$'} to "copyDirectStrings". Defaults TRUE for convenience.
%   'copyDllFiles'      - Additional true/false option to copy ".dll" files directly. Equivalent to
%                         adding {'\.dll$'} to "copyDirectStrings". Defaults TRUE for convenience.
%   'copyMexFiles'      - Additional true/false option to copy mex files directly. Defaults TRUE 
%                         for convenience.
%
%   'flattenFileTree'   - When true (default), regular m-files are deployed as p-files only to the  
%                         TARGET folder initially provided (rather than under any subdirectories).
%                         When this option is set to FALSE, the file structure under the SOURCE 
%                         directory will be replicated at the TARGET.
%
%
% Example:
% deploypcode('C:\sven\ASSEMBLA_sahm\matlab\sahm\','U:\SAHM\matlab\_includes\sahm','updateOnly',true)
%
%
% written by Sven Holcombe Oct 2011

%% Find folders under search_dir

% MATLAB only writes pcode to pwd, so we *need* fully qualified paths
source_dir = getFullPathStr(source_dir);
target_dir = getFullPathStr(target_dir);
assert(exist(source_dir,'dir')==7,'Source directory %s does not exist',source_dir)
assert(exist(target_dir,'dir')==7,'Target directory %s does not exist',target_dir)

% Gather options from user inputs
options = processInputs(varargin{:});

% Start p-coding recursively. If options.recurse is false, it will exit after the source_dir
originalDir = pwd; % Pcode only exports only to pwd. We need to remember our starting directory.
CUobject = onCleanup(@()cd(originalDir)); % Ensure we return to the caller's directory, even on error
deployPcodeRecurse(source_dir, target_dir, options)

end

function deployPcodeRecurse(sourceDir,destDir,options)
	% Recursively search sourceDir for any files or folders under it.
    if ~isequal(pwd,destDir)
        if ~options.flattenFileTree && ~exist(destDir,'dir')
            warning('deploypcode:missingDir','Directory "%s" did not exist so will be created',destDir)
            mkdir(destDir)
        end
        cd(destDir);
    end

	% Search the sourceDir, excluding any requested entries.
	files = dir(sourceDir);
    files(~cellfun(@isempty,regexp({files.name}, options.excludeRegexpString ,'once'))) = [];
    if isempty(files)
        return;
    end
    
    % Get masks into M-FILES and STRAIGHT-COPY-FILES
    dirMask = [files.isdir];
    mfileMask = ~dirMask & ~cellfun(@isempty,regexp({files.name},'\.m$'));
    copyFileMask = ~dirMask & ~cellfun(@isempty,regexp({files.name},options.copyDirectString));
    fprintf('Analysing "%s":\n(%d .Ms, %d COPYs, %d sub-dirs)\n',sourceDir, nnz(mfileMask), nnz(copyFileMask), nnz(dirMask))
    
    % M-FILES: Create P-Code for all non-ignored .m files in this directory
    [~, sourceImplicitDirs] = helpUtils.separateImplicitDirs(sourceDir);
    destNonImlicitDir = helpUtils.separateImplicitDirs(destDir);
    writeDir = fullfile(destNonImlicitDir,sourceImplicitDirs);
    % Sneakily force the @class constructor to be p-coded first (avoids an annoying MATLAB warning)
    mFileInds = find(mfileMask);
    [~,sortInds] = sort(strcmp([sourceImplicitDirs(2:end) '.m'],{files(mFileInds).name}),'descend');
    for i=mFileInds(sortInds)
        fprintf('P-coding FILE:  %s ... ', files(i).name)
        readFromMFileStr = fullfile(sourceDir, files(i).name);
        writeToMFileStr = fullfile(writeDir,files(i).name);
        writeToPFileStr = [writeToMFileStr(1:end-1) 'p'];
        if options.updateOnly
            pFile = dir(writeToPFileStr);
            if ~isempty(pFile) && pFile.datenum > files(i).datenum
                fprintf('is already up to date.\n')
                continue;
            end
        end
        
        % Wrap the p-code call in a try-catch statement in case the m-file
        % in question has errors in it.
        try
            pcode(readFromMFileStr)
        catch ME
            warning('deploypcode:touch', ['Cannot create p-code for file ' files(i).name ' in ' sourceDir])
            disp(ME)
            continue
        end
            
        pcode(readFromMFileStr)
        helpDebugStr = '';
        if options.includeHelp
            % Output a shadow filename.m file with the helptext from the original filename.m
            txt = writeHelpMfile(fullfile(writeDir,files(i).name), readFromMFileStr);          
            if isempty(txt)
                helpDebugStr = sprintf(' No help found for %s',readFromMFileStr);
            else
                % Avoid MATLAB's pfile-older-than-mfile warning: re-touch .p file if older than .m
                pFile = dir(writeToPFileStr);
                mFile = dir(fullfile(writeDir,files(i).name));
                if pFile.datenum < mFile.datenum
                    touchFile(writeToPFileStr)
                    fprintf('\n%s\t (%f)\n', files(i).name,  pFile.datenum-mFile.datenum)
                    pFile = dir(writeToPFileStr);
                    if pFile.datenum < mFile.datenum
                        % Wow, it's STILL older. Last try: delete, then re-pcode it
                        delete(writeToPFileStr)
                        pcode(readFromMFileStr)
                        fprintf('\n%s\t (%f)\n', files(i).name,  pFile.datenum-mFile.datenum)
                        pFile = dir(writeToPFileStr);
                    end
                end
                helpDebugStr = sprintf(' %d chars written to help file',numel(txt));
                fprintf('\n%s\t (%f)\n', files(i).name,  pFile.datenum-mFile.datenum)
            end
        end
        fprintf('done. %s\n',helpDebugStr)
    end
    
    % FIG-FILES: Copy over any .fig files in this directory
    if ~isempty(options.copyDirectStrings)
        for i=find(copyFileMask)
            fprintf('Copying:  %s ... ', files(i).name)
            copyfile(fullfile(sourceDir, files(i).name), destDir)
            fprintf('done.\n')
        end
    end

    % SUB-DIRECTORIES: Recursively follow any subdirectories if options.recurse is set.
    if options.recurse
        dirs = files(dirMask);
        for i=1:length(dirs)
            if options.flattenFileTree
                nextDestDir = destDir;
            else
                nextDestDir = fullfile(destDir, dirs(i).name);
            end
            deployPcodeRecurse(fullfile(sourceDir, dirs(i).name),nextDestDir,options)
        end
    end
end % deployPcodeRecurse

%% Utility routines

function inPath = getFullPathStr(inPath)
    % Tricky little function that returns the fully qualified path by looking for filesep
    inPath = fullfile(inPath);
    if ~any(regexp(inPath,['^(\w:)?\' filesep]))
        inPath = fullfile(pwd, inPath);
    end
end

function txt = writeHelpMfile(filename, fun)
% Extract help text from "FUN", write it to FILENAME if help text found
txt = help(fun);
if isempty(txt), return; end
txtLineByLine = strcat('%',regexp(txt,'\n','split')');
fid = fopen(filename,'w');
if (fid == -1)
    error('Unable to write to %s', filename);
end
fprintf(fid, '%s\n',txtLineByLine{:});
fclose(fid);
end

function touchFile(fname)
compType = computer;
switch compType(1:3)
    case 'PCW',         cmd = sprintf('copy /b "%s" +,,',fname);
    case {'GLN','MAC'}, cmd = sprintf('touch "%s"',fname);
end
[okZero,msg] = system(cmd);
if okZero~=0
    warning('deploypcode:touch', msg)
end
end

function options = processInputs(varargin)
IP = inputParser;
IP.addParamValue('recurse',true,@(x)sum(x==[0 1]))
IP.addParamValue('ignoreStrings',{},@(x)iscellstr(x) || ischar(x))
IP.addParamValue('ignoreSVN',true,@(x)sum(x==[0 1]))
IP.addParamValue('includeHelp',true,@(x)sum(x==[0 1]))
IP.addParamValue('flattenFileTree',true,@(x)sum(x==[0 1]))
IP.addParamValue('copyFigFiles',true,@(x)sum(x==[0 1]))
IP.addParamValue('copyMexFiles',true,@(x)sum(x==[0 1]))
IP.addParamValue('copyDllFiles',true,@(x)sum(x==[0 1]))
IP.addParamValue('copyDirectStrings',{},@(x)iscellstr(x) || ischar(x))
IP.addParamValue('updateOnly',false,@(x)sum(x==[0 1]))
IP.parse(varargin{:})
options = IP.Results;

% Generate a nice single "excludeRegexpString" from "ignoreStrings" and "ignoreSVN"
if ischar(options.ignoreStrings)
    options.ignoreStrings = {options.ignoreStrings};
end
% Exclude '.svn' directories if requested.
if options.ignoreSVN
    options.ignoreStrings{end+1} = '^\.svn$';
end
% Exclude '.' and '..' explicitly, along with all other requested exclusions
mustIgnoreList = {'^\.$','^\.\.$',[mfilename '.m']}; % Must ignore THIS file. Deploying this file causes inconsistencies in MATLAB's paths
options.excludeRegexpString = sprintf('|%s', mustIgnoreList{:}, options.ignoreStrings{:});

% Generate a nice single "copyDirectString" regexp from copyDirectStrings and copyFigFiles
if ischar(options.copyDirectStrings)
    options.copyDirectStrings = {options.copyDirectStrings};
end

if options.copyFigFiles, options.copyDirectStrings{end+1} = '\.fig$'; end
if options.copyDllFiles, options.copyDirectStrings{end+1} = '\.dll$'; end
if options.copyMexFiles
    mexExts = mexext('all');
    for i = 1:numel(mexExts)
        options.copyDirectStrings{end+1} = ['\.' mexExts(i).ext '$'];
    end
end

options.copyDirectString = sprintf('|%s', options.copyDirectStrings{:});
end