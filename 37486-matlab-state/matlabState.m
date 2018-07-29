function matlabState(proc, varargin)
% MATLABSTATE   
%   This script is designed to to save and restore the working state of
%   MATLAB.  This has only been tested on MATLAB version R2007a to R2011a,
%   and it uses some undocumented features of MATLAB and might not work
%   correctly for other versions.
%
%   matlabState('save') When this script is called with the 'save' flag, it
%   will ask for a location and file name to save the MATLAB state to.  It
%   will then proceed to save the current working directory, additional
%   paths that differ from MATLAB root, open editor files, debug break
%   points, open figures, base workspace variables, and command window
%   history (this is not the same as the command history).
%
%   matlabState('save', savePath, stateFilename) To avoid any user
%   interaction, the save location and file name can be passed in as
%   parameters.
%
%   matlabState('restore') When this script is called with the 'restore'
%   flag, it will open and GUI asking for the mState file to restore the
%   MATLAB state from.  All editor windows will then be closed, all debug
%   break points will be removed, the command window will be cleared, all
%   open figures will be closed, and all base workspace variables will be
%   deleted before restoring the state.  The script will then restore from
%   the mState file the current working directory, addition paths other
%   than MATLAB root, open editor windows, debug break points, open
%   figures, base workspace variables, and commend window text history.
%
%   matlabState('restore', mStateFile) To avoid a GUI from asking for
%   mState file location, the full path and file name can be passed in as a
%   parameter.
%
%
%
%
%   History: (Created by Troy Grossarth)
%       Troy Grossarth  2010/09/18  Initial Version
%       Troy Grossarth  2010/12/04  Added command window text save and
%                                   restore
%       Troy Grossarth  2011/09/20  Updated to work for 2011a and added the
%                                   ability to remember the curser position
%                                   in the editor.
%       Troy Grossarth  2013/06/24  Fixed error that was being caused by
%                                   the editor not being open when saving
%                                   the MATLAB state.
%

    if ~ispref(mfilename) || ~ispref(mfilename, 'savePath')
        setpref(mfilename, 'savePath', '/');
    end
    if ~ispref(mfilename) || ~ispref(mfilename, 'restorePath')
        setpref(mfilename, 'restorePath', '/');
    end
    if ~ispref(mfilename) || ~ispref(mfilename, 'prefix')
        setpref(mfilename, 'prefix', '');
    end
    
    
    v = ver('matlab');
    v = textscan(v.Version, '%s', 'delimiter', '.');
    this.version = str2double(v{1});
    %check to see if it is a newer version than 7.4.  There is no
    %"builtinGetActiveDocument" in 7.4 or earlier
    
    wb = waitbar(0, sprintf('This is the progress bar for saving/restoring the MATLAB state.\nPlease wait...'), 'name', 'MATLAB State Progress', 'visible', 'off');
    
    os = getenv('OS');
    if ~isempty(regexpi(os, 'win', 'once'))
        os = 'win';
    else
        os = 'unix';
    end
    
    if exist('proc', 'var')~=1
        proc = '';
    end
    
    switch lower(proc)
        case 'save'
            
            if nargin<2 || exist(varargin{1}, 'dir')~=7
                savePath = uigetdir(getpref(mfilename, 'savePath'), 'Choose the directory to save the MATLAB state in.');
                if savePath==0
                    return;
                end
                setpref(mfilename, 'savePath', savePath);
            else
                savePath = varargin{1};
            end
            
            if nargin<3
                statePrefix = '';
                while isempty(statePrefix) || ~isempty(regexp(statePrefix, '[\\\/\(\)\[\]\{\}]', 'once'))
                    statePrefix = inputdlg('Enter the prefix to the MATLAB state file.', 'Save MATLAB State', 1, {getpref(mfilename, 'prefix')});
                    if isempty(statePrefix)
                        return;
                    end
                    statePrefix = statePrefix{1};
                end
            else
                statePrefix = varargin{2};
            end
            
            waitbar(.1, wb, sprintf('Getting MATLAB workspace information.\nPlease wait...'));
            set(wb, 'visible', 'on');
            %get workspace information
            tmpPath = textscan(path, '%s', 'delimiter', pathsep);
            if ~isempty(tmpPath)
                tmpPath = tmpPath{1};
            end 
            myPath = {};
            pathCount = 0;
            for pathIdx=1:length(tmpPath)
                if isempty(strfind(tmpPath{pathIdx}, matlabroot))
                    pathCount = pathCount + 1;
                    myPath{pathCount} = tmpPath{pathIdx}; %#ok<AGROW>
                end
            end
            
            currentDirectory = pwd;
            editorDocuments = cell(0, 1);
            editorActiveDocument = '';
            if (this.version(1)==7 && this.version(2)>=12) || this.version(1)>7
                editor = com.mathworks.mlservices.MLEditorServices.getEditorApplication;
                activeEditor = editor.getActiveEditor;
                if ~isempty(activeEditor)
                    editorActiveDocument = char(activeEditor.getLongName);
                    editors = editor.getOpenEditors.toArray;
                    editorDocuments = cell(length(editors)*2, 1);
                    for editorIdx=1:length(editors)
                        editorDocuments{editorIdx*2-1} = char(editors(editorIdx).getLongName);
                        editorDocuments{editorIdx*2} = editors(editorIdx).getCaretPosition;
                    end
                end
            else
                editors = com.mathworks.mlservices.MLEditorServices.builtinGetOpenDocumentNames;
                editorDocuments = cell(length(editors), 1);
                for editorIdx=1:length(editors)
                    editorDocuments{editorIdx} = char(editors(editorIdx));
                end
                if (this.version(1)==7 && this.version(2)>=4)
                    editorActiveDocument = char(com.mathworks.mlservices.MLEditorServices.builtinGetActiveDocument);
                end
            end
            debugStatus = dbstatus;
            
            data = {myPath, currentDirectory, editorDocuments, editorActiveDocument, debugStatus, os, this.version}; %#ok<NASGU>
            
            savedStateFiles = {};
            
            waitbar(.2, wb, sprintf('Saving MATLAB base workspace variables.\nPlease wait...'));
            %check to make sure that there are actually some variables in the
            %base workspace
            v = evalin('base', 'who;');
            if ~isempty(v)
                savedStateFiles{length(savedStateFiles)+1, 1} = fullfile(savePath, 'matlabStateBaseVariables.mat');
                evalin('base', sprintf('save(''%s'', ''*'');', savedStateFiles{end}));
            end
            
            waitbar(.3, wb, sprintf('Saving open figure 0 of 0.\nPlease wait...'));
            %save figures
            figureHandles = setdiff(findall(0, 'type', 'figure'), findall(0, 'type', 'figure', '-regexp', 'tag', 'TMWWaitbar'));
            for fIdx=1:length(figureHandles)
                waitbar(.3+(.2/length(figureHandles)*fIdx), wb, sprintf('Saving open figure %d of %d.\nPlease wait...', fIdx, length(figureHandles)));
                
                %wraping figureHandles(fidx) with handle function to
                %supress a warning that JavaFrame property will be obsolete
                %in future release.
                figJavaFrame = get(handle(figureHandles(fIdx)), 'JavaFrame');
                figState = struct('isMaximized', figJavaFrame.isMaximized(), 'isMinimized', figJavaFrame.isMinimized());
                savedStateFiles{length(savedStateFiles)+1, 1} = fullfile(savePath, sprintf('FigureState%f_matlabStatFigure.mat', figureHandles(fIdx))); %#ok<AGROW>
                save(savedStateFiles{end}, 'figState');
                
                %set maximized and minimized to false for saving the figure
                drawnow();
                pause(.1);
                figJavaFrame.setMaximized(false);
                drawnow();
                pause(.1);
                figJavaFrame.setMinimized(false);
                drawnow();
                pause(.1);
                
                savedStateFiles{length(savedStateFiles)+1, 1} = fullfile(savePath, sprintf('Figure%f_matlabStateFigure.fig', figureHandles(fIdx))); %#ok<AGROW>
                saveas(figureHandles(fIdx), savedStateFiles{end});
                
                %restore fugure to maximized and minimized state
                drawnow();
                pause(.1);
                figJavaFrame.setMaximized(figState.isMaximized);
                drawnow();
                pause(.1);
                figJavaFrame.setMinimized(figState.isMinimized);
                drawnow();
                pause(.1);
            end
            
            waitbar(.5, wb, sprintf('Saving MATLAB workspace information.\nPlease wait...'));
            %save editor, path, and debug state
            savedStateFiles{length(savedStateFiles)+1, 1} = fullfile(savePath, 'matlabState.mat');
            save(savedStateFiles{end}, 'data');
            
            waitbar(.65, wb, sprintf('Saving MATLAB command window history.\nPlease wait...'));
            %get command window history
            cmdWinDoc = com.mathworks.mde.cmdwin.CmdWinDocument.getInstance;
            cmdWinText = char(cmdWinDoc.getText(str2double(cmdWinDoc.getStartPosition), str2double(cmdWinDoc.getEndPosition)));
            %save command window history
            savedStateFiles{length(savedStateFiles)+1, 1} = fullfile(savePath, 'matlabCommandWindow.txt');
            cmdWinFID = fopen(savedStateFiles{end}, 'w');
            fwrite(cmdWinFID, cmdWinText, 'uchar');
            fclose(cmdWinFID);
            
            waitbar(.75, wb, sprintf('Compressing MATLAB state information.\nPlease wait...'));
            %zip up saved state
            zip(fullfile(savePath, sprintf('%s.mState', statePrefix)), savedStateFiles);
            movefile(fullfile(savePath, sprintf('%s.mState.zip', statePrefix)), fullfile(savePath, sprintf('%s.mState', statePrefix)));
            
            waitbar(.95, wb, sprintf('Cleaning up.\nPlease wait...'));
            for fileIdx=1:length(savedStateFiles)
                delete(savedStateFiles{fileIdx});
            end
            
        case 'restore'

            if nargin<2 || exist(varargin{1}, 'file')~=2
                [restoreFile restorePath] = uigetfile(fullfile(getpref(mfilename, 'restorePath'), '*.mState'), 'Select the MATLAB state file to restore.');
                if restorePath==0
                    return;
                end
                setpref(mfilename, 'restorePath', restorePath);
                prefix = restoreFile(1:end-7);
                setpref(mfilename, 'prefix', prefix);
            else
                [restorePath restoreFile ext] = fileparts(varargin{1});
                prefix = restoreFile;
                restoreFile = strcat(restoreFile, ext);
            end
            
            fclose('all');
            fh = setdiff(findall(0, 'type', 'figure'), findall(0, 'type', 'figure', '-regexp', 'tag', 'TMWWaitbar'));
            close(fh);
            evalin('base', 'clear(''all'');')
            clc;
            
            %create NEW place to unzip the state files
            while exist(fullfile(restorePath, prefix), 'dir')==7
                prefix = sprintf('%s_tmpDir', prefix);
            end

            set(wb, 'visible', 'on');
            waitbar(.05, wb, sprintf('Decompressing MATLAB state information.\nPlease wait...'));            
            stateFiles = unzip(fullfile(restorePath, restoreFile), fullfile(restorePath, prefix)); %#ok<NASGU>
            
            waitbar(.35, wb, sprintf('Loading MATLAB workspace information.\nPlease wait...'));
            data = [];
            load(fullfile(restorePath, prefix, 'matlabState.mat'));
            
            if ~isempty(data)
                
                myPath = data{1};
                currentDirectory = data{2};
                editorDocuments = data{3};
                editorActiveDocument = data{4};
                debugStatus = data{5};
                if length(data)<6
                    restoreOS = 'win'; %#ok<NASGU>
                else
                    restoreOS = data{6}; %#ok<NASGU>
                end
                if length(data)<7
                    restoreVersion = [7 4];
                else
                    restoreVersion = data{7};
                end

                waitbar(.37, wb, sprintf('Restoring current directory.\nPlease wait...'));
                %restore current working directory
                cd(currentDirectory);
            
                waitbar(.39, wb, sprintf('Restoring MATLAB path.\nPlease wait...'));
                %restore path
                if ischar(myPath) %this is for backwards compatability purposes.
                    path(myPath)
                else
                    tmpPath = textscan(path, '%s', 'delimiter', pathsep);
                    if ~isempty(tmpPath)
                        tmpPath = tmpPath{1};
                    end 
                    for pathIdx=1:length(tmpPath)
                        if isempty(strfind(tmpPath{pathIdx}, matlabroot))
                            rmpath(tmpPath{pathIdx}); 
                        end
                    end
                    for pathIdx=length(myPath):-1:1
                        addpath(myPath{pathIdx});
                    end
                end
                
                waitbar(.41, wb, sprintf('Restoring open documents in Editor window.\nPlease wait...'));
                %restore documents open in the editor
                if (this.version(1)==7 && this.version(2)>=12) || this.version(1)>7
                    tmp = com.mathworks.mlservices.MLEditorServices.getEditorApplication;
                    tmp.close;
                else
                    com.mathworks.mlservices.MLEditorServices.closeAll;
                end
                for documentIdx=1:length(editorDocuments)
                    %if the restoreVersion is 7.12 or higher, then the
                    %caret position is stored in every other cell
                    if ((restoreVersion(1)==7 && restoreVersion(2)>=12) || restoreVersion(1)>7)...
                        && mod(documentIdx, 2)==0
                        editors = com.mathworks.mlservices.MLEditorServices.getEditorApplication;
                        editors = editors.getOpenEditors.toArray;
                        editors(end).setCaretPosition(editorDocuments{documentIdx});
                    else
                        if exist(editorDocuments{documentIdx}, 'file')==2
                            edit(editorDocuments{documentIdx});
                            pause(.2);
                        end
                    end
                end

                waitbar(.43, wb, sprintf('Restoring active document in Editor window.\nPlease wait...'));
                %restore which document in the editor was active.  This only works on
                %versions greater than 7.4
                if (this.version(1)==7 && this.version(2)>=4) || this.version(1)>7
                    if exist(editorActiveDocument, 'file')==2
                        edit(editorActiveDocument);
                    end
                end
                figure(wb);

                waitbar(.45, wb, sprintf('Restoring debug state and breakpoints.\nPlease wait...'));
                %restore debug settings and break points
                dbclear('all');
                cwd = pwd;
                for debugIdx=1:length(debugStatus)
                    try
                        if exist(debugStatus(debugIdx).file, 'file')==2
                            p = fileparts(debugStatus(debugIdx).file);
                            cd(p);
                            dbstop(debugStatus(debugIdx));
                        elseif isempty(debugStatus(debugIdx).file)
                            dbstop(debugStatus(debugIdx));
                        end
                    catch %#ok<CTCH>
                        warning('MATLAB:matlabState', 'Could not set break point for %s in file %s', debugStatus(debugIdx).name, debugStatus(debugIdx).file);
                    end
                end
                cd(cwd);
            end
            
            waitbar(.47, wb, sprintf('Restoring baseworkspace variables.\nPlease wait...'));
            %restore base workspace variables
            if exist(fullfile(restorePath, prefix, 'matlabStateBaseVariables.mat'), 'file')==2
                evalin('base', sprintf('load(''%s'');', fullfile(restorePath, prefix, 'matlabStateBaseVariables.mat')));
            end
            
            waitbar(.5, wb, sprintf('Restoring command window text.\nPlease wait...'));
            %restore the command window text
            if exist(fullfile(restorePath, prefix, 'matlabCommandWindow.txt'), 'file')==2
                cmdWinFID = fopen(fullfile(restorePath, prefix, 'matlabCommandWindow.txt'), 'r');
%                 txtLine = fgetl(cmdWinFID);
                txtLines = textscan(cmdWinFID, '%s', 'delimiter', '\n');
                txtLines = txtLines{1};
                lineIdx = 1;
                while lineIdx<=size(txtLines, 1)
                    txtLine = txtLines{lineIdx};
%                 while ischar(txtLine)
                    if ~isempty(regexp(txtLine, '^???', 'once')) || ~isempty(regexpi(txtLine, '^error', 'once'))
                        while ischar(txtLine) && isempty(regexp(txtLine, '^K*>>', 'once'))
%                             cprintf('error', '%s\n', txtLine);
                            fprintf(2, '%s\n', txtLine);
%                             txtLine = fgetl(cmdWinFID);
                            lineIdx = lineIdx+1;
                            txtLine = txtLines{lineIdx};
                        end
                        continue;
%                     elseif ~isempty(regexp(txtLine, '^%', 'once'))
%                         cprintf('comment', '%s\n', txtLine);
%                     elseif ~isempty(regexp(txtLine, '''\w*''', 'once'))
%                         [startIdx stopIdx] = regexp(txtLine, '''\w*''', 'start', 'end');
%                         cprintf('text', '%s', txtLine(1:(startIdx(1)-1)));
%                         for idx=1:length(startIdx)
%                             cprintf('string', '%s', txtLine(startIdx(idx):stopIdx(idx)));
%                             if idx<length(startIdx)
%                                 cprintf('text', '%s', txtLine((stopIdx(idx)+1):(startIdx(idx+1)-1)));
%                             end
%                         end
%                         if (stopIdx(idx)+1)<length(txtLine)
%                             cprintf('text', '%s', txtLine((stopIdx(idx)+1):end));
%                         end
%                         cprintf('text', '\n');
                    else
%                         cprintf('text', '%s\n', txtLine);
                        fprintf(1, '%s\n', txtLine);
                    end
                    
%                     txtLine = fgetl(cmdWinFID);
                    lineIdx = lineIdx+1;
                end
                fclose(cmdWinFID);
            end
            
            if this.version(1)>restoreVersion(1)...
                    || (this.version(1)==restoreVersion(1) && this.version(2)>=restoreVersion(2))
                waitbar(.6, wb, sprintf('Restoring open figures.\nRestoring figure 0 of 0'));
                %reopen the figures that were open
                figureFiles = dir(fullfile(restorePath, prefix, '*.fig'));
                for fIdx=1:length(figureFiles)
                    waitbar(.6+.3/length(figureFiles)*fIdx, wb, sprintf('Restoring open figures.\nRestoring figure %d of %d', fIdx, length(figureFiles)));
                    open(fullfile(restorePath, prefix, figureFiles(fIdx).name));
                    figHandle = gcf;
                    oldFigHandle = textscan(figureFiles(fIdx).name, 'Figure%f');
                    if exist(fullfile(restorePath, prefix, sprintf('FigureState%f_matlabStateFiguer.mat', oldFigHandle{1})), 'file')==2
                        figState = load(fullfile(restorePath, prefix, sprintf('FigureState%f_matlabStateFiguer.mat', oldFigHandle{1})));
                        figJavaFrame = get(handle(figHandle), 'JavaFrame');
                        drawnow();
                        pause(.1);
                        figJavaFrame.setMaximized(figState.figState.isMaximized);
                        drawnow();
                        pause(.1);
                        figJavaFrame.setMinimized(figState.figState.isMinimized);
                        drawnow();
                        pause(.1);
                    end
                end 
            end
            
            waitbar(.9, wb, sprintf('Cleaning up MATLAB state restore process.\nPlease wait...'));
            rmdir(fullfile(restorePath, prefix), 's');
        otherwise
            qAns = questdlg('Do you want to save or restore the MATLAB state?', 'MATLAB State save/restore', 'Save', 'Restore', 'Cancel', 'Cancel');
            switch lower(qAns)
                case 'save'
                    matlabState('save', varargin{:});
                case 'restore'
                    matlabState('restore', varargin{:});
                otherwise
                    fprintf(2, 'Usage:\n\tmatlabState(''save'');\n\tmatlabState(''restore'');\n');
            end
    end
    
    close(wb);
end