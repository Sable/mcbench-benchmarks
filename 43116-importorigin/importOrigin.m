function data = importOrigin(filepath, importDlg, appName)
%IMPORTORIGIN. Import (x,y) data from Origin project (OriginLab Corp.).
%
%  importOrigin, by itself, opens a file selection dialog for specifying
%  the Origin project file to be imported. The function identifies x-y
%  pairs of column data in the specified Origin project and opens a modal
%  data selection dialog for selecting a subset of data sets to import. If
%  no output arguments are specified the imported data will be sent to the
%  MATLAB workspace as new variables.
%
%  DATA = importOrigin; returns DATA, a structure with fields:
%    name  - an ID data string 'Book[...]: Sheet[...]: Col(...): Name(...)'
%    xy    - an (mx2) array containing the column data [x y].
%
%  length(DATA) equals the number of imported data sets.
%
%  data = importOrigin( FILEPATH ) attempts to load the Origin project
%  located at FILEPATH. If FILEPATH does not exist, or is empty, a file
%  selection dialog will be opened. Default = [].
%
%  data  = importOrigin(filepath, IMPORTDLG), where IMPORTDLG is a binary
%  parameter (0/1) determining whether to open a modal data selection
%  dialog for specifying a subset of data sets to import. The dialog
%  presents a data listbox with multi-selection enabled. If IMPORTDLG = 0
%  all data will be imported. Default: 1.
%
%  data = importOrigin(filepath, importDlg, APPNAME), where APPNAME is a
%  string specifying the title of each of the dialogs opened. Default:
%  'importOrigin'
%
%
%  Examples:
%    % 1) Open a file selection dialog and a data selection dialog.
%    % Return the selected data sets to the MATLAB workspace:
%         importOrigin
%
%    % 2) Open a file selection dialog and return all (x,y) data sets in
%    % the file to a structure called data:
%         data = importOrigin([],0);
%
%  Notes:
%    - importOrigin imports only numeric (x,y) worksheet column data.
%    - Connecting to Origin may take a while the first time.
%    - Be aware of dialogs opened by Origin in a second window that
%    requires action (e.g. license issues).
%    - Tested in MATLAB R2010b, R2012a, R2012b with Origin Pro 8
%
%  Requirements:
%    - Origin must be installed on the target computer.
%
%  Updates:
%    - 27/8-2013: Fixed importing worksheets containing NaN and empty
%    columns
%    - 13/9-2013: 
%      - Possible to import data into the MATLAB workspace (base).
%      - Implemented MATLAB's own listdlg for the data selection,
%        instead of using inputsdlg from the File Exchange.
%      - New default for opening a data selection dialog.
%
%
%  See also ACTXSERVER, INVOKE
%
%  Copyright 2013 Søren Preus: <a href="www.fluortools.com">FluorTools.com</a>

%% Default input arguments
if nargin<1 || ~ischar(filepath) || ~exist(filepath,'file')
    filepath = []; % Default is to open a file selection dialog
end
if nargin<2 || (importDlg~=0 && importDlg~=1)
    importDlg = 1; % Default is to open a data selection dialog
end
if nargin<3 || ~ischar(appName)
    appName = 'importOrigin'; % Default app-name is importOrigin
end

% Initialize data structure
tempdata = struct('name',[],'xy',[]);
tempdata(1) = [];

% Initialize output structure
if nargout>0
    data = tempdata;
end

%% Display warning dialog
choice = questdlg(sprintf('%s\n\n%s%s\n',...
    'Any currently open Origin Projects will be saved and closed in order to continue.',...
    'If an open Origin project does not have a filepath specified already the project will be saved ',...
    'to a new file in your Origin User Files directory, entitled ''UNTITLED.opj'''),...
    'Warning!',...
    'OK','Cancel','OK');

if strcmpi(choice,'Cancel') % If user pressed Cancel, return
    if nargout>0
        data = []; % Reset data structure
    end
    return
end

% Open waitbar, opening Origin takes a while
hWaitbar = waitbar(0,'Opening Origin. Please wait...','Name',appName);

%% Obtain Origin COM Server object. This will connect to an existing
% instance of Origin, or create a new one if none exist
try originObj = actxserver('Origin.ApplicationSI');
    
catch err
    if strcmpi(err.identifier,'MATLAB:COM:InvalidProgid') % If an Origin server object was not found on the computer
        msgbox('Sorry, OriginPro must be installed on your computer.',appName)
    end
    if nargout>0
        data = []; % Reset data
    end
    try delete(hWaitbar), end  % Delete waitbar
    return
end

% Select Origin file
if isempty(filepath)
    [FileName,PathName,chose] = uigetfile('*.opj','Open Existing Origin Project','OriginProject.opj');
    
    if chose == 0 % If user pressed Cancel
        if nargout>0
            data = []; % Reset data
        end
        try delete(hWaitbar), end  % Delete waitbar
        return
    else
        filepath = fullfile(PathName,FileName); % Full file path
    end
end

%% Identify paired xy column-data in the specified Origin Project
try
    % Save and close existing projects
    invoke(originObj, 'Execute', 'Save');
    invoke(originObj, 'IsModified', 'false');
    
    % Load the specified project
    invoke(originObj, 'Load', strcat(filepath));
    
    % Update waitbar
    waitbar(0,hWaitbar,'Importing from Origin. Please wait...')
    
    % Identify workbooks
    workbooksHandle = invoke(originObj,'WorksheetPages'); % Handle to the workbooks
    nbooks = get(workbooksHandle,'Count'); % Number of workbooks in project
    for b = 0:nbooks-1 % Loop all workbooks
        workbookHandle = get(workbooksHandle,'Item',b); % Handle to workbook b
        workbookName = get(workbookHandle,'Name'); % Short name of workbook b
        workbookLongName = get(workbookHandle,'LongName'); % Long name of workbook b
        
        % Identify worksheets
        worksheetsHandle = get(workbookHandle,'layers'); % Handle to worksheets of workbook b
        nsheets = get(worksheetsHandle,'Count'); % Number of sheets in workbook b
        for s = 0:nsheets-1 % Loop all worksheets
            worksheetHandle = get(worksheetsHandle,'Item',s); % Handle to sheet s
            worksheetName = get(worksheetHandle,'Name'); % Short name of sheet s
            worksheetLongName = get(worksheetHandle,'LongName'); % Long name of sheet s
            worksheetData = invoke(originObj,'GetWorksheet',sprintf('[%s]%s',workbookName,worksheetName)); % Get worksheet data
            fh = @(x) all(isnan(x(:)));
            worksheetData(cellfun(fh, worksheetData)) = {[]}; % Remove all NaN from cell array
            fh = @(x) all(ischar(x(:)));
            worksheetData(cellfun(fh, worksheetData)) = {[]}; % Remove all strings from cell array
            
            if ~iscell(worksheetData) || isempty(worksheetData)
                % If there is no worksheet data found, continue to next
                continue
            end
            
            % Identify columns
            columnsHandle = get(worksheetHandle,'Columns'); % Handle to columns of worksheet s
            ncolumns = get(columnsHandle,'Count'); % Number of columns in sheet s
            x = [];
            y = [];
            for c = 0:ncolumns-1 % Loop all columns
                columnHandle = get(columnsHandle,'Item',c); % Handle to column c
                columnName = get(columnHandle,'Name'); % Name of column c
                columnType = get(columnHandle,'Type'); % Column type: 0 (Y), 3 (X) or 5 (Z)
                columnLongName = get(columnHandle,'LongName'); % Long name of column c
                columnsUnits = get(columnHandle,'Units'); % Units specified in column c (not actually used here)
                columnComment = get(columnHandle,'Comments'); % Comments specified in column c (not actually used here)
                
                % Store column data
                if columnType==3 % If x-vector
                    x = [worksheetData{:,c+1}]';
                    x(isnan(x)) = []; % Remove NaN
                elseif columnType==0 % If y-vector
                    y = [worksheetData{:,c+1}]';
                    y(isnan(y)) = []; % Remove NaN
                    
                    % Check x,y data
                    if ~isnumeric(x) || ~isnumeric(y) || ismember(1,isnan(x)) || ismember(1,isnan(y)) || isempty(x) || isempty(y) % || length(x)<5 || length(y)<5
                        % If x and y are not actual data, skip to next
                        continue
                    end
                    
                    % Put (x,y) pair into tempdata structure
                    tempdata(end+1).name = sprintf('Book[%s]: Sheet[%s]: Col(%s): Name(%s)',workbookLongName,worksheetName,columnName,columnLongName);
                    if length(x)>length(y)
                        tempdata(end).xy = [x(1:length(y)) y]; % Cut x
                    elseif length(x)<length(y)
                        tempdata(end).xy = [x y(1:length(x))]; % Cut y
                    else
                        tempdata(end).xy = [x y]; % Equal sizes of x and y
                    end
                    
                    
                else
                    % If z-vector, skip
                    continue
                end
                
            end
        end
        
        % Update waitbar
        waitbar((single(b)+1)/single(nbooks),hWaitbar)
    end
    
    % Delete waitbar
    try delete(hWaitbar), end
    
    if isempty(tempdata) % If there is no data found
        msgbox('No data sets found in specified Origin project',appName) % Show message box
        if nargout>0
            data = []; % Reset data
        end
        
        return
    end
    
catch err % If MATLAB through an error during Origin connection
    msgbox(sprintf('Error loading Origin Project: %s',err.message),appName) % Show message box
    if nargout>0
        data = []; % Reset data
    end
    
    % Delete waitbar and return
    try delete(hWaitbar), end
    return
end

if ~importDlg % If importing all data, the work is done here
    if nargout>0 % Return data structure
        data = tempdata;
    else% Send data to workspace
        sendToWorkspace(tempdata)
    end
    
    return
end


%% Data selection dialog
[dlganswer,ok] = listdlg(...
    'Name', appName,... % Name of dialog
    'ListString', {tempdata(:).name}',... % String in listbox
    'PromptString', 'Select data sets to import: ',... % String next to listbox
    'ListSize', [600 500],... % Size of listbox
    'SelectionMode', 'multiple'); % Allow multi-selection

% If user pressed Cancel or didn't make a selection
if ok == 0 || isempty(dlganswer)
    if nargout>0
        data = []; % Reset data
    end
    
    return
end


%% Selected data
tempdata = tempdata(dlganswer);
if nargout>0
    data = tempdata; % Return data structure
else % Send data to workspace
    sendToWorkspace(tempdata)
end
end


function sendToWorkSpace(tempdata)
% Sends the data in the tempdata structure to the MATLAB workspace (base)
OKoverride = 0; % Parameter determining whether it's OK to override existing variables
OKdlg = 1; % Parameter determining whether to open an override-dialog

for i = 1:length(tempdata) % Loop all data sets
    % Variable name
    name = tempdata(i).name;
    
    % Remove special signs
    name(name=='[' | ...
        name==']' | ...
        name=='(' | ...
        name==')' | ...
        name=='+' | ...
        name=='-' | ...
        name=='/' | ...
        name=='\' | ...
        name=='*') = '';
    
    % Set an underscore instead of colons
    name(name==':') = '_';
    
    % Make a valid variable name
    name = genvarname(name);
    
    % Check if variable already exists
    ws_base = evalin('base','who()'); % Get variables in the workspace
    if ismember(name,ws_base) % If variable i already exists
        if OKdlg  % Prompt dialog
            choice = questdlg('Override existing variables?','Variable exists',...
                ' Yes ',' No ',' No ');
            
            % If override
            if strcmpi(choice,' Yes ')
                OKoverride = 1;
            end
            
            OKdlg = 0; % Don't show this dialog again
        end
        
        % If don't override, continue to next variable
        if ~OKoverride
            continue
        end
    end
    
    % Send data set to workspace variable
    assignin('base', name, tempdata(i).xy);
end
end