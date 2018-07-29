function varargout = dctool(varargin)
% DCTOOL Graphical interface for displaying the status of a distributed
% computing network.
%
%      DCTOOL, by itself, creates a new DCTOOL or raises the existing
%      singleton.
%
%      H = DCTOOL returns the handle to a new DCTOOL or the handle to
%      the existing singleton.
%
%  Tim Farajian 7/11/2005

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @dctool_OpeningFcn, ...
    'gui_OutputFcn',  @dctool_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% End initialization code - DO NOT EDIT

%----------------------------------------------%
%----------------------------------------------%

% GUI Output function
function varargout = dctool_OutputFcn(ignore, ignore2, handles)
varargout{1} = handles.output;

%----------------------------------------------%

function Figure_CloseRequestFcn(hObject, ignore, handles)
if strcmp(get(handles.updatetimer,'Running'),'on')
    stop(handles.updatetimer)
end
delete([handles.updatetimer handles.starttimer])
delete(hObject);

%----------------------------------------------%

function dctool_OpeningFcn(hObject, ignore, handles)
% Choose default command line output for dctool
handles.output = hObject;
% Initialize distributed computing network info
handles.jm = [];handles.Workers = [];handles.Jobs = [];handles.Tasks = [];
handles.cjm = [];handles.cWorker = [];handles.cJob = [];handles.cTask = [];
%%% Create update timer %%%
% Specify timer period
SecPerUpdate =  get(handles.RateSlider,'Value');
set(handles.RateText,'String',sprintf('%0.1f',SecPerUpdate))
oldwarn = warning('off','MATLAB:TIMER:RATEPRECISION');
handles.updatetimer = timer('busymode','queue',...
    'ExecutionMode','fixedSpacing',...
    'Period',SecPerUpdate,'startdelay',0,...
    'TimerFcn',@(a,b)Update(a,b,hObject),...
    'TasksToExecute',1e6);
% Create timer to start populating listboxes after figure is shown
handles.starttimer = timer('startdelay',0.1,...
    'TimerFcn',@PopulateJobManagers,'UserData',handles.Figure);

warning(oldwarn); % Reset warning state
guidata(hObject, handles); % Save handles
start(handles.starttimer); % Start timer to initiate populating listboxes

%----------------------------------------------%
%----------------------------------------------%

%%%%%%%%%%%%%%%%%%%%%
% Listbox Callbacks %
%%%%%%%%%%%%%%%%%%%%%

%%% Job manager changed by user %%%
function jmbox_Callback(hObject, ignore, handles)
if isempty(handles.jm)
    % Currently no job manager in listbox
    return
end
jm = handles.jm(get(handles.jmbox,'Value')); % Get currently selected manager
if ~isequal(handles.cjm,jm)
    % Job manager has changed
    handles.cjm = jm; % Reassign current job manager
    % Stop update timer
    if strcmp(handles.updatetimer.Running,'on')
        stop(handles.updatetimer)
    end
    % Clear list boxes
    h = [handles.workerbox handles.jobbox handles.taskbox];
    set(h,'String',{})
    % Reset current worker, job, and task
    handles.cWorker = [];  handles.cJob = [];  handles.cTask = [];
    handles.Workers = [];  handles.Jobs = [];  handles.Tasks = [];
    guidata(hObject,handles);
    % Populate list boxes
    Populate([],[],hObject);
    % Restart the update timer
    if strcmp(handles.updatetimer.Running,'off')
        start(handles.updatetimer)
    end
end

%----------------------------------------------%

%%% Job changed by user %%%
function jobbox_Callback(hObject, ignore, handles)
if isempty(handles.Jobs)
    % Currently no jobs in listbox
    return
end
job = handles.Jobs(get(handles.jobbox,'Value')); % Selected job
if ~isequal(handles.cJob,job)
    % Job changed
    handles.cJob = job; % Reassign current job
    set(handles.taskbox,'String',{}) % Clear task listbox
    handles.cTask = []; % Reset current task
    guidata(hObject,handles);
    PopulateTasks([],[],hObject);
end
% Submit menu item is disabled if current job is not pending
state = job.state;
if strcmp(state,'pending')
    set(handles.MenuSubmit,'Enable','on');
else
    set(handles.MenuSubmit,'Enable','off')
end
% JobReport menu item is disabled if current job is pending or queued
if strcmp(state,'pending') || strcmp(state,'queued')
    set(handles.MenuReport,'Enable','off');
else
    set(handles.MenuReport,'Enable','on')
end

%----------------------------------------------%

%%% Task changed by user %%%
function taskbox_Callback(hObject, ignore, handles)
if isempty(handles.Tasks)
    % Currently no tasks in listbox
    return
end
% Reassign current task
handles.cTask = handles.Tasks(get(handles.taskbox,'Value')); % Selected task
guidata(hObject,handles);


% Worker changed by user
function workerbox_Callback(hObject, ignore, handles)
if isempty(handles.Workers)
    % Currently no workers in listbox
    return
end
% Reassign current worker
handles.cWorker = handles.Workers(get(handles.workerbox,'Value'));
guidata(hObject,handles);

%----------------------------------------------%
%----------------------------------------------%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Context Menu Item Callbacks %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Job Manager menu callbacks %%%

%%% Export manager to base workspace
function MenuExportJm_Callback(ignore, ignore2, handles)
jm = inputdlg('Export handle to job manager as name:','Export Job Manager');
assignin('base',jm{1},handles.cjm);
disp('Variables created in the workspace.');

%----------------------------------------------%

%%% Remove manager from manager list
function MenuRemove_Callback(hObject, ignore, handles)
cval = get(handles.jmbox, 'Value'); % Index of selected manager
handles.jm(cval) = []; % Remove handle from list
fv = get(handles.jmbox,'String'); % Get string
fv(cval) = []; % Remove string from list
if isempty(handles.jm)
    % No more managers
    handles.cjm = []; % Indicate no selected manager
    stop(handles.updatetimer); % Stop the update timer
    % Disable manager menu items
    hMenu = get(get(handles.jmbox,'uiContextMenu'),'Children');
    set(hMenu,'Enable','off');
elseif cval > length(handles.jm)
    % Current manager index now greater than number of managers -> reduce
    cval = length(handles.jm);
    handles.cjm = handles.jm(cval);
else
    % Indicate current manager is now the next one
    handles.cjm = handles.jm(cval);
end
guidata(hObject,handles);
% Update manager listbox
set(handles.jmbox,{'Value','String'},{cval,fv});
% Populate remaining listboxes
Populate([],[],hObject);

%----------------------------------------------%

% Display property inspector
function MenuPropsJM_Callback(ignore, ignore2, handles)
inspect(handles.jm(get(handles.jmbox,'Value')))

%----------------------------------------------%

function MenuBench_Callback(hObject, eventdata, handles)
distcomp_bench_dist(length(handles.Workers), get(handles.cjm,'Name'));

%----------------------------------------------%

%%% Worker menu callbacks %%%

% Export handle to worker to base workspace
function MenuExportWorker_Callback(ignore, ignore2, handles)
name = inputdlg('Export handle to worker as name:','Export Worker');
assignin('base',name{1},handles.cWorker);
disp('Variables created in the workspace.');

%----------------------------------------------%

% VNC into current worker
function MenuVNC_Callback(ignore, ignore2, handles)
VncDir = 'D:\Applications\TightVnc\vncviewer.exe ';
str = [VncDir handles.cWorker.Hostname];
system(str);

%----------------------------------------------%

function MenuPropsWorker_Callback(ignore, ignore2, handles)
inspect(handles.Workers(get(handles.workerbox,'Value')))

%----------------------------------------------%

%%% Job menu callbacks %%%

% Export current job to base workspace
function MenuExportJob_Callback(ignore, ignore2, handles)
name = inputdlg('Export handle to job as name:','Export Job');
if isempty(name)
    return
end
assignin('base',name{1},handles.cJob);
disp('Variables created in the workspace.');

%----------------------------------------------%

% Submit current job
function MenuSubmit_Callback(ignore, ignore2, handles)
job = handles.Jobs(get(handles.jobbox,'Value'));
submit(job)

%----------------------------------------------%

% Destroy current job
function MenuDestroy_Callback(ignore, ignore2, handles)
job = handles.Jobs(get(handles.jobbox,'Value'));
if ishandle(job)
    destroy(job)
end

%----------------------------------------------%

function MenuReport_Callback(ignore, ignore2, handles)
JobReport(handles.cJob)

%----------------------------------------------%

function MenuPropsJob_Callback(ignore, ignore2, handles)
inspect(handles.Jobs(get(handles.jobbox,'Value')))

%----------------------------------------------%

%%% Task menu callbacks %%%

% Export current task to workspace
function MenuExportTask_Callback(ignore, ignore2, handles)
name = inputdlg('Export handle to task as name:','Export Task');
assignin('base',name{1},handles.cTask);
disp('Variables created in the workspace.');

%----------------------------------------------%

% Cancel current task
function MenuCancel_Callback(ignore, ignore2, handles)
if ishandle(handles.cTask)
    cancel(handles.cTask)
end

%----------------------------------------------%

% Destroy current task
function MenuDestroyTask_Callback(ignore, ignore2, handles)
if ishandle(handles.cTask)
    destroy(handles.cTask)
end

%----------------------------------------------%

function MenuPropsTask_Callback(ignore, ignore2, handles)
inspect(handles.Tasks(get(handles.taskbox,'Value')))

%----------------------------------------------%
%----------------------------------------------%

%%%%%%%%%%%%%%%%%%%%%%
% Menu Bar Callbacks %
%%%%%%%%%%%%%%%%%%%%%%

function MenuClose_Callback(ignore, ignore2, handles)
close(handles.Figure)

%----------------------------------------------%

function DemoCallback(hObject,ignore)
data = get(hObject,'UserData');
handles = guidata(data{1});
fcn = data{2};
fcn(handles.cjm);


%----------------------------------------------%
%----------------------------------------------%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions to populate list boxes %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For performance reasons, certain operations are performed when the
% listboxes are first populated.  Then, Update* performs fewer operations to
% keep them updated.

% Populates all listboxes for the first time (Update keeps t
function Populate(tmr,data,hObject)
if ~ishandle(hObject)
    % Figure has been closed -> Stop the timer
    stop(tmr);
    delete(tmr);
    return
end
PopulateWorkers(tmr,data,hObject);
PopulateJobs(tmr,data,hObject);
PopulateTasks(tmr,data,hObject);

%----------------------------------------------%

% Populate manager list with all managers on network
function PopulateJobManagers(tmr, ignore)
hObject = get(tmr,'Userdata');
handles = guidata(hObject);
set(handles.JmUpdateText,'Visible','on'); % Turn on "updating" text
% Clear list boxes
h = [handles.jmbox handles.workerbox handles.jobbox handles.taskbox];
set(h,'String',{})
drawnow
% Reset current worker, job, and task
handles.cWorker = [];  handles.cJob = [];  handles.cTask = [];
handles.Jobs = [];  handles.Tasks = [];
% Get all job managers
handles.jm = findResource('jobmanager');
jmstr = get(handles.jm,{'Name'}); % Get names
set(handles.jmbox,{'value','String'},{1,jmstr}); % Fill manager listbox

% Get handles to manager menu items
hMenu = get(get(handles.jmbox,'uiContextMenu'),'Children');
if isempty(handles.jm)    
    handles.cjm = []; % Indicate there is no current job manager
    set(hMenu,'Enable','off');
else
    set(hMenu,'Enable','on');
    handles.cjm = handles.jm(1); % Set current job manager
end
guidata(hObject,handles)
set(handles.JmUpdateText,'Visible','off'); % Turn off "update" text
% Populate the list boxes
PopulateWorkers([],[],hObject);
PopulateJobs([],[],hObject);
PopulateTasks([],[],hObject);
% If update timer is not already started -> start it
if strcmp(get(handles.updatetimer,'Running'),'off')
    start(handles.updatetimer)
end

%----------------------------------------------%

% Populate worker list box
function PopulateWorkers(ignore, ignore2, hObject)
if ~ishandle(hObject)
    % Figure already closed
    return
end
handles = guidata(hObject);
set(handles.WorkerUpdateText,'Visible','on'); % Turn on "updating" text
drawnow
% Things may have changed from the drawnow
if ~ishandle(hObject)
    return
end
handles = guidata(hObject);

workerstr = {}; workerloc = 1; % Initialize variables
% Get handles to all workers
handles.Workers = [get(handles.cjm,'IdleWorkers');get(handles.cjm,'BusyWorkers')];
% Get handles to all worker menu items
hMenu = get(get(handles.workerbox,'uiContextMenu'),'Children');
if isempty(handles.Workers)
    % No workers -> disable menu
    handles.cWorker = [];
    set(hMenu,'Enable','off');
else
    set(hMenu,'Enable','on');
    handles.cWorker = handles.Workers(workerloc);
end
handles.WorkerData = get(handles.Workers,{'Name'});
data = get(handles.Workers,{'CurrentTask'});
guidata(hObject,handles)
for n = 1:length(handles.Workers)
    if isempty(data) || isempty(data{n})
        str = 'Idle';
    else
        str = 'Busy';
    end
    workerstr{n} = sprintf('%s - %s',handles.WorkerData{n},str);
end
set(handles.workerbox,{'value','String'},{workerloc,workerstr});
set(handles.WorkerUpdateText,'Visible','off');

%----------------------------------------------%

% Populate job list
function PopulateJobs(ignore, ignore2,hObject)
if ~ishandle(hObject)
    % Figure already closed
    return
end
handles = guidata(hObject);
set(handles.JobUpdateText,'Visible','on'); % Turn on "updating" text
drawnow
% Things may have changed from the drawnow
if ~ishandle(hObject)
    % Figure already closed
    return
end
handles = guidata(hObject);

jobstr = {};jobloc = 1; % Initialize variables
handles.Jobs = get(handles.cjm,'Jobs'); % Get handles to all jobs
% Get handles to all job menu items
hMenu = get(get(handles.jobbox,'uiContextMenu'),'Children');
if isempty(handles.Jobs)
    % No jobs -> disable menu
    handles.cJob = [];
    set(hMenu,'Enable','off');
else
    set(hMenu,'Enable','on');
    handles.cJob = handles.Jobs(jobloc);
end
handles.JobData = get(handles.Jobs,{'Name','UserName'});
state = get(handles.Jobs,{'State'});

guidata(hObject,handles)
if ~ishandle(hObject),return,end % In case figure was closed by now
for n = 1:length(handles.Jobs)
    jobstr{n} = sprintf('%s - %s - %s',handles.JobData{n,:},state{n});
end
set(handles.jobbox,{'Value','String'},{jobloc,jobstr});
if isempty(state) || ~strcmp(state{jobloc},'pending')
    set(handles.MenuSubmit,'Enable','on');
else
    set(handles.MenuSubmit,'Enable','off');
end
set(handles.JobUpdateText,'Visible','off');

%----------------------------------------------%

%%% Populate task list box %%%
function PopulateTasks(ignore, ignore2,hObject)
if ~ishandle(hObject)
    % Figure already closed
    return
end
handles = guidata(hObject);
set(handles.TaskUpdateText,'Visible','on');
drawnow
% Things may have changed from the drawnow
if ~ishandle(hObject)
    % Figure already closed
    return
end
handles = guidata(hObject);

taskstr = {};taskloc = 1; % Initialize variables
handles.Tasks = get(handles.cJob,'Tasks'); % Get handles to all tasks
% Get handles to all task menu items
hMenu = get(get(handles.taskbox,'uiContextMenu'),'Children');
if isempty(handles.Tasks)
    % No tasks -> disable menu
    handles.cTask = [];
    set(hMenu,'Enable','off');
else
    set(hMenu,'Enable','on');
    handles.cTask = handles.Tasks(taskloc); % Specify current task
end
handles.TaskData = get(handles.Tasks,{'ID'});
state = get(handles.Tasks,{'State'});
guidata(hObject,handles)
for n = 1:length(handles.Tasks)
    taskstr{n} = sprintf('Task%d - %s',handles.TaskData{n,:},state{n});
end
set(handles.taskbox,{'value','String'},{taskloc,taskstr});
set(handles.TaskUpdateText,'Visible','off');

%----------------------------------------------%
%----------------------------------------------%

%%%%%%%%%%%%%%%%%%%%
% Update listboxes %
%%%%%%%%%%%%%%%%%%%%
% These keep the listboxes updated.  Different operations are performed to
% initially populate the listboxes using the Populate* functions.

function Update(ignore,ignore2,hObject)
% Timer callback - Updates all listboxes with current info from job manager
% Each function is similar.  Each is organized to minimize the number of
% times the job manager is queried for information, which is expensive.
UpdateWorkers(hObject);
UpdateJobs(hObject);
UpdateTasks(hObject);

%----------------------------------------------%

function UpdateWorkers(hObject)
handles = guidata(hObject);
% Check if update checkbox is off
if ~get(handles.MasterUpdate,'Value') || ~get(handles.WorkerUpdate,'Value') 
    return
end
set(handles.WorkerUpdateText,'Visible','on'); % Turn on "Updating" text
drawnow % Allow text to be shown - Other callbacks may occur
if ~ishandle(hObject)
    return % Figure has been closed
end
handles = guidata(hObject); % Handles may have changed

% Find manager's associated workers
workers = [get(handles.cjm,'IdleWorkers'); get(handles.cjm,'BusyWorkers')];

% Remove workers that are no longer there
stillthere = ismember(handles.Workers, workers);
handles.Workers(~stillthere) = [];
handles.WorkerData(~stillthere) = [];
if size(handles.Workers,2)==0 % Ensure empty is 0-by-n rather than n-by-0
    handles.Workers = handles.Workers.';
    handles.WorkerData = handles.WorkerData.';
end
% Add new workers
notnew = ismember(workers, handles.Workers);
handles.Workers = [handles.Workers(:); workers(~notnew)];

tname = get(workers(~notnew),{'Name'}); % Get new worker's names
handles.WorkerData = [handles.WorkerData; tname]; % Add name to data list
if length(handles.Workers) == 1 && ~iscell(handles.WorkerData)
    % Happens when only one worker
    handles.WorkerData = {handles.WorkerData};
end

% Read the current task of all workers
ctask = get(handles.Workers,{'CurrentTask'});

nWorkers = length(handles.Workers); workerstr = {}; % Initialize variables
for n = 1:nWorkers
    if isempty(ctask{n})
        str = 'Idle';
    else
        str = 'Busy';
    end
    workerstr{n} = sprintf('%s - %s',handles.WorkerData{n},str);
end

hMenu = get(get(handles.workerbox,'uiContextMenu'),'Children');
if nWorkers == 0
    % No workers in list
    workerloc = 1; % Listbox value
    handles.cWorker = []; % Assign current worker
    set(hMenu,'Enable','off');  % Disable context menu items
else
    workerloc = min(nWorkers,get(handles.workerbox,'Value')); % Listbox value
    handles.cWorker = handles.Workers(workerloc); % Assign current worker
    set(hMenu,'Enable','on'); % Enable context menu items
end
guidata(hObject,handles)
set(handles.workerbox,{'value','String'},{workerloc,workerstr});
set(handles.WorkerUpdateText,'Visible','off');

%----------------------------------------------%

%%% Updates current job info from the job manager
function UpdateJobs(hObject)
if ~ishandle(hObject) % Check if figure has closed    
    return
end
handles = guidata(hObject);
% Check if update checkbox is off
if ~get(handles.MasterUpdate,'Value') || ~get(handles.JobUpdate,'Value') 
    return
end
set(handles.JobUpdateText,'Visible','on'); % Show "Updating" text
drawnow % Allow text to be shown - Other callbacks may occur
if ~ishandle(hObject) % Check if figure has closed    
    return
end
handles = guidata(hObject); % Handles may have changed

jobs = get(handles.cjm,'Jobs'); % Read all jobs in current job manager
% Remove jobs that are no longer there
stillthere = ismember(handles.Jobs, jobs);
handles.Jobs(~stillthere) = [];
handles.JobData(~stillthere,:) = [];
if size(handles.Jobs,2)==0 % Ensure empty is 0-by-n rather than n-by-0
    handles.Jobs = handles.Jobs.';
end
if size(handles.JobData,2)==0 % Ensure empty is 0-by-n rather than n-by-0
    handles.JobData = handles.JobData.';
end
% Add new jobs
notnew = ismember(jobs, handles.Jobs);
handles.Jobs = [handles.Jobs; jobs(~notnew)];

% Get data about new jobs
r = get(jobs(~notnew),{'Name','UserName'}); % Only need to obtain when new
state = get(handles.Jobs,{'State'}); % Need to obtain every time
handles.JobData = [handles.JobData; r]; % Include new data in list

nJobs = length(handles.Jobs);
jobstr = cell(nJobs,1);
for n = 1:nJobs
    jobstr{n} = sprintf('%s - %s - %s',handles.JobData{n,:},state{n});
end
% Get handles to all context menu items
hMenu = get(get(handles.jobbox,'uiContextMenu'),'Children');
if nJobs == 0
    % No jobs in list
    jobloc = 1; % Listbox value
    handles.cJob = []; % Assign current job
    set(hMenu,'Enable','off');  % Disable context menu items
else
    jobloc = min(nJobs,get(handles.jobbox,'Value')); % Listbox value
    handles.cJob = handles.Jobs(jobloc); % Assign current job
    set(hMenu,'Enable','on'); % Enable context menu items
end
set(handles.jobbox,{'Value','String'},{jobloc,jobstr});
% Disable Submit menu item if job is not pending
if isempty(state) || ~strcmp(state{jobloc},'pending')
    set(handles.MenuSubmit,'Enable','off');
else
    set(handles.MenuSubmit,'Enable','on');
end
guidata(hObject,handles)
set(handles.JobUpdateText,'Visible','off');
drawnow

%----------------------------------------------%

function UpdateTasks(hObject)

if ~ishandle(hObject) % Check if figure has closed    
    return
end
handles = guidata(hObject);
% Check if update checkbox is off
if ~get(handles.MasterUpdate,'Value') || ~get(handles.TaskUpdate,'Value') 
    return
end
set(handles.TaskUpdateText,'Visible','on'); % Show "Updating" text
drawnow % Allow text to be shown - Other callbacks may occur
if ~ishandle(hObject) % Check if figure has closed    
    return
end
handles = guidata(hObject); % Handles may have changed

% Find all tasks associated with current job
tasks = get(handles.cJob,'Tasks');

% Remove tasks from list that are no longer there
stillthere = ismember(handles.Tasks, tasks);
handles.Tasks(~stillthere) = [];
handles.TaskData(~stillthere) = [];
if size(handles.Tasks,2)==0 % Ensure empty is 0-by-n rather than n-by-0
    handles.Tasks = handles.Tasks.';
    handles.TaskData = handles.TaskData.';
end
% Add new tasks to list
notnew = ismember(tasks, handles.Tasks);
handles.Tasks = [handles.Tasks; tasks(~notnew)];

ID = get(tasks(~notnew),{'ID'}); % Only need to obtain when new
state = get(handles.Tasks,{'State'}); % Need to obtain every time
handles.TaskData = [handles.TaskData; ID];
if length(handles.TaskData) == 1
    if ~iscell(handles.TaskData)
        handles.TaskData = {handles.TaskData};
    end
end
nTasks = length(handles.Tasks);
taskstr = {};
for n = 1:length(handles.Tasks)
    taskstr{n} = sprintf('Task%d - %s',handles.TaskData{n},state{n});
end
hMenu = get(get(handles.taskbox,'uiContextMenu'),'Children');
if nTasks == 0
    % No tasks in list
    taskloc = 1; % Listbox value
    handles.cTask = []; % Assign current task
    set(hMenu,'Enable','off');  % Disable context menu items
else
    taskloc = min(nTasks,get(handles.taskbox,'Value')); % Listbox value
    handles.cTask = handles.Tasks(taskloc); % Assign current task
    set(hMenu,'Enable','on'); % Enable context menu items
end
set(handles.taskbox,{'value','String'},{taskloc,taskstr});
set(handles.TaskUpdateText,'Visible','off');
guidata(hObject,handles)

%----------------------------------------------%
%----------------------------------------------%


%%%%%%%%%%%%%%%%%%%%%%%
% Uicontrol Callbacks %
%%%%%%%%%%%%%%%%%%%%%%%

function MasterUpdate_Callback(hObject, ignore, handles)
h = [handles.WorkerUpdate handles.JobUpdate handles.TaskUpdate];
v = get(hObject,'Value');
if v
    set(h,'Enable','on')
else
    set(h,'Enable','off')
end

%----------------------------------------------%

% Change the rate at which the interface is refreshed
function RateSlider_Callback(hObject, ignore, handles)
% Stop timer if running
state = strcmp(handles.updatetimer.Running,'on');
if state
    stop(handles.updatetimer)
end
% Change timer period - Want smaller values on right of slider
SecPerUpdate =  get(hObject,'Value');
set(handles.RateText,'String',sprintf('%0.1f',SecPerUpdate))
oldwarn = warning('off','MATLAB:TIMER:RATEPRECISION');
set(handles.updatetimer,'Period', SecPerUpdate);
warning(oldwarn);
%drawnow
if state
    start(handles.updatetimer)
end


%----------------------------------------------%
%----------------------------------------------%

%%%%%%%%%%%%%%
% Job Report %
%%%%%%%%%%%%%%

function varargout = JobReport(varargin)
% JOBREPORT generates a graphical representation of the progress of the
% tasks of a specified job.
%
%   JOBREPORT(JOB) generates a plot where the horizontal axis indicates the
%   different workers used throughout the job JOB, and the vertical axis
%   indicates the starting and finishing times of each task
%
%   JOBREPORT(AX,...) plots into the axes with handle AX.
%
%   H = JOBREPORT(...) returns a handle to the patch objects.
%
%   5/2005 Tim Farajian

if nargin==1
    % Only 1 input
    job = varargin{1};
    f = figure;
    AX = gca;
    hold(AX,'on'); % Set hold state
    ylabel('Time')
    title(['Job report for ' get(job,'Name')],'interpreter','none');
    datetick('y');
else
    % Axis was specified
    [AX job] = deal(varargin{1:2});
    if ~ishandle(AX) || ~strcmp(get(AX,'type'),'axes')
        error('AX must be a handle to a valid axis object')
    end
    f = get(AX,'Parent');
end
set(f,'Pointer','watch')
drawnow

if ~ishandle(job) || ~isa(job,'distcomp.job')
    error('JOB must be a handle to a valid job object')
else
    jobstate = get(job,'State');
    if ismember(jobstate,{'pending','queued'})
        error('Job has not yet started.')
    end
end

tasks = job.Tasks; % Get handles to all tasks in job
if isempty(tasks)
    error(['No tasks in ' get(job,'Name')],'Job Report Error');
end

taskstates = get(tasks,'State'); % Get state of all tasks
if length(tasks)==1 && ~iscell(taskstates)
    % Ensure its a cell array
    taskstates = {taskstates};
end
unavailable = strcmp(taskstates,'unavailable'); % Check if unavailable
tasks(unavailable) = []; % Remove unavailable tasks
taskstates(unavailable) = []; % Remove unavailable taskstates

IDs = get(tasks,'ID'); % Get IDs of all tasks
if length(tasks)==1 && ~iscell(IDs)
    % Ensure its a cell array
    IDs = {IDs};
end

workers = get(tasks,'Worker'); % Get handle to all workers used by tasks
if iscell(workers)
    % Ensure its not a cell array
    workers = [workers{:}];
end
% Find the unique workers
[workers ignore wkrnums] = unique(workers);
wkrnames = get(workers,'Name'); % Get names of all workers
if length(workers)==1 && ~iscell(wkrnames)
    % Ensure its a cell array
    wkrnames = {wkrnames};
end


ax(1:2) = [0 1+length(workers)]; % Set x-axis limits 

% Get job start time
JobStart = TaskTime(job,'StartTime');
plot(ax, [JobStart JobStart],'k--')

% Get job finish time and set axes limits
if strcmp(jobstate,{'finished'})
    JobFinish = TaskTime(job,'FinishTime');
    if JobFinish == JobStart,
        JobFinish = JobFinish + 5e-6;
    end
    dy = max(7e-5,0.6*(JobFinish-JobStart));
    my = (JobStart + JobFinish)/2;
    plot(ax, [JobFinish JobFinish],'k--')        
    ax(3:4) =  my + dy*[-1 1];   
else
    JobFinish = now;
    jobdiff = max(2e-4,1.1*(JobFinish-JobStart));
    ax(3:4) =  JobFinish + [-jobdiff 0];
end

% Set figure and axis
axis(ax)
datetick('y')
set(gca,'Xtick',1:length(workers));
set(gca,'XtickLabel',wkrnames);

nTasks = length(tasks);
TaskStart = zeros(nTasks,1);
TaskFinish = zeros(nTasks,1);
h = zeros(nTasks,1); % Preallocate
set(f,'Pointer','arrow')
drawnow
for n = 1:nTasks
    task = tasks(n);
    switch taskstates{n}
        case {'pending'}
            continue
        case {'running'}
            TaskStart(n) = TaskTime(task,'StartTime');
            TaskFinish(n) = JobFinish+1e-6;
            colr = 'c';
        case {'finished'}
            TaskStart(n) = TaskTime(task,'StartTime');
            TaskFinish(n) = TaskTime(task,'FinishTime');
            if isempty(task.ErrorMessage)
                colr = 'b';
            else 
                colr = 'r';
            end
    end

    timediff = TaskFinish(n)-TaskStart(n); % Time difference
    if timediff<=0
        % Ensure time difference is positive
        timediff = 5e-6;
        TaskFinish(n)=TaskStart(n) + timediff;
    end
    px = wkrnums(n) - 0.5+[0 0 1 1]; % x-coords of patch
    py = TaskStart(n)+timediff*[0 1 1 0]; % y-coords of patch
    h(n) = patch(px,py, colr); % Create patch
    % Create task text label
    text(mean(px),mean(py),...
        sprintf('Task%d',IDs{n}),'horizontal','center');
    axis(ax)
    drawnow
end
if nargout>0
    varargout = h;
end

%----------------------------------------------%

function time = TaskTime(obj, prop)
% Subfunction for use with JobReport
timestr = get(obj,prop);
timestr = timestr(5:end);timestr(17:20)=[];
time = datenum(timestr);


function MenuBarHelp_Callback(hObject, eventdata, handles)
fid = fopen('dctool_help.txt');
str = fread(fid,inf,'*char').';
fclose(fid);
f = figure('menubar','none','NumberTitle','off','Name','About DCTOOL');
h=uicontrol('style','edit','parent',f,'min',0,'max',2,'enable','inactive'...
    ,'units','normalized','position',[0 0 1 1],'string',str,...
    'horizontalalignment','left','fontsize',10);
drawnow

%%% Workaround for g271589 %%%
found = false;
jf = get(f, 'javaframe');
ac = jf.getAxisComponent;
cc = ac.getParent.getComponent(0);
if ~isa(cc, 'com.mathworks.hg.peer.FigureComponentContainer')
    cc = ac.getParent.getComponent(1);
end
for i=1:cc.getComponentCount
    if isa(cc.getComponent(i-1).getComponent(0), 'com.mathworks.hg.peer.utils.UIScrollPane')
        s = cc.getComponent(i-1).getComponent(0);
        found = true;
    end
end
if (found)
    e = s.getViewport.getView;
    awtinvoke(e, 'scrollRectToVisible(Ljava.awt.Rectangle;)V', ...
        java.awt.Rectangle(0, 0, 1, 1));
end




