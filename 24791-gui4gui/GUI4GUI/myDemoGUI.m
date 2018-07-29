function myDemoGUI(varargin)
% function myDemoGUI(varargin)
%
% This Graphical User Interface is generated with user-supplied menu definition data
% buildMainGUI.m version 1.0 has been used to generate this GUI
%
fh = figure('Visible','off', ...
            'NumberTitle','off', ...  % turns off MATLAB GUI window heading
            'Name','myDemoGUI', ...    % now, define my own
            'Units','normalized', ...
            'Units','normalized', ...
            'Position',[1.000000e-001 1.000000e-001 6.000000e-001 6.000000e-001], ...
            'Color','white', ...   % match bg of MODE_new.jpg
            'Resize','off');
set(fh,'MenuBar','none'); % removes MATLAB default menu bar
% create custom menu bar items as defined by GID loaded above:
% "File", "Model", "Articles", "Tutorials", "Examples", "Run", "Code", "Help"
%
% The menu item handles used here are all local, the naming convention is
% mh_ijk where i, j, and k represent the menu item and sub menu items
% First, set up all the menu bars (but without any callbacks . . .
% The menu bars are: File, Model, Articles, Tutorial, Examples, Run, Code, Help
% For menu bar item: 'File'
mh1 = uimenu(fh,'Label', 'File');
mh(1,1,1,1) = uimenu(mh1,'Label', 'Exit');


% For menu bar item: 'Model'
mh2 = uimenu(fh,'Label', 'Model');
mh(2,1,1,1) = uimenu(mh2,'Label', 'first');
mh(2,2,1,1) = uimenu(mh2,'Label', 'second');


% For menu bar item: 'Articles'
mh3 = uimenu(fh,'Label', 'Articles');
mh(3,1,1,1) = uimenu(mh3,'Label', 'first');
mh(3,2,1,1) = uimenu(mh3,'Label', 'second');


% For menu bar item: 'Tutorial'
mh4 = uimenu(fh,'Label', 'Tutorial');
mh(4,1,1,1) = uimenu(mh4,'Label', 'Abstract');
mh(4,2,1,1) = uimenu(mh4,'Label', 'Tutorial');


% For menu bar item: 'Examples'
mh5 = uimenu(fh,'Label', 'Examples');
mh(5,1,1,1) = uimenu(mh5,'Label', 'Low coherence (0%)');
mh(5,1,2,1) = uimenu(mh(5,1,1,1),'Label', 'Input');
mh(5,1,3,1) = uimenu(mh(5,1,1,1),'Label', 'Non-directional transient cells');
mh(5,1,4,1) = uimenu(mh(5,1,1,1),'Label', 'Directional transient cells');
mh(5,1,5,1) = uimenu(mh(5,1,1,1),'Label', 'Directional short range filters');
mh(5,1,6,1) = uimenu(mh(5,1,1,1),'Label', 'Directional long-range filters');
mh(5,1,7,1) = uimenu(mh(5,1,1,1),'Label', 'Directional grouping network');
mh(5,1,8,1) = uimenu(mh(5,1,1,1),'Label', 'Decision cells and decision gating');
mh(5,1,8,2) = uimenu(mh(5,1,8,1),'Label', 'Reaction time task');
mh(5,1,8,3) = uimenu(mh(5,1,8,1),'Label', 'Fixed duration task');
mh(5,2,1,1) = uimenu(mh5,'Label', 'Medium coherence (6.4%)');
mh(5,2,2,1) = uimenu(mh(5,2,1,1),'Label', 'Input');
mh(5,2,3,1) = uimenu(mh(5,2,1,1),'Label', 'Non-directional transient cells');
mh(5,2,4,1) = uimenu(mh(5,2,1,1),'Label', 'Directional transient cells');
mh(5,2,5,1) = uimenu(mh(5,2,1,1),'Label', 'Directional short range filters');
mh(5,2,6,1) = uimenu(mh(5,2,1,1),'Label', 'Directional long-range filters');
mh(5,2,7,1) = uimenu(mh(5,2,1,1),'Label', 'Directional grouping network');
mh(5,2,8,1) = uimenu(mh(5,2,1,1),'Label', 'Decision cells and decision gating');
mh(5,2,8,2) = uimenu(mh(5,2,8,1),'Label', 'Reaction time task');
mh(5,2,8,3) = uimenu(mh(5,2,8,1),'Label', 'Fixed duration task');
mh(5,3,1,1) = uimenu(mh5,'Label', 'High coherence (51.2%)');
mh(5,3,2,1) = uimenu(mh(5,3,1,1),'Label', 'Input');
mh(5,3,3,1) = uimenu(mh(5,3,1,1),'Label', 'Non-directional transient cells');
mh(5,3,4,1) = uimenu(mh(5,3,1,1),'Label', 'Directional transient cells');
mh(5,3,5,1) = uimenu(mh(5,3,1,1),'Label', 'Directional short range filters');
mh(5,3,6,1) = uimenu(mh(5,3,1,1),'Label', 'Directional long-range filters');
mh(5,3,7,1) = uimenu(mh(5,3,1,1),'Label', 'Directional grouping network');
mh(5,3,8,1) = uimenu(mh(5,3,1,1),'Label', 'Decision cells and decision gating');
mh(5,3,8,2) = uimenu(mh(5,3,8,1),'Label', 'Reaction time task');
mh(5,3,8,3) = uimenu(mh(5,3,8,1),'Label', 'Fixed duration task');


% For menu bar item: 'Run'
mh6 = uimenu(fh,'Label', 'Run');
mh(6,1,1,1) = uimenu(mh6,'Label', 'Reaction time task');
mh(6,1,2,1) = uimenu(mh(6,1,1,1),'Label', 'Description');
mh(6,1,3,1) = uimenu(mh(6,1,1,1),'Label', 'Replication test');
mh(6,1,3,2) = uimenu(mh(6,1,3,1),'Label', 'Description');
mh(6,1,3,3) = uimenu(mh(6,1,3,1),'Label', 'Run');
mh(6,1,4,1) = uimenu(mh(6,1,1,1),'Label', 'Advanced run');
mh(6,1,4,2) = uimenu(mh(6,1,4,1),'Label', 'Description');
mh(6,1,4,3) = uimenu(mh(6,1,4,1),'Label', 'Run');
mh(6,2,1,1) = uimenu(mh6,'Label', 'Fixed duration task');
mh(6,2,2,1) = uimenu(mh(6,2,1,1),'Label', 'Description');
mh(6,2,3,1) = uimenu(mh(6,2,1,1),'Label', 'Replication test');
mh(6,2,3,2) = uimenu(mh(6,2,3,1),'Label', 'Description');
mh(6,2,3,3) = uimenu(mh(6,2,3,1),'Label', 'Run');
mh(6,2,4,1) = uimenu(mh(6,2,1,1),'Label', 'Advanced run');
mh(6,2,4,2) = uimenu(mh(6,2,4,1),'Label', 'Description');
mh(6,2,4,3) = uimenu(mh(6,2,4,1),'Label', 'Run');


% For menu bar item: 'Code'
mh7 = uimenu(fh,'Label', 'Code');
mh(7,1,1,1) = uimenu(mh7,'Label', 'code 1');
mh(7,2,1,1) = uimenu(mh7,'Label', 'code 2');


% For menu bar item: 'Help'
mh8 = uimenu(fh,'Label', 'Help');
mh(8,1,1,1) = uimenu(mh8,'Label', 'Contact');
mh(8,2,1,1) = uimenu(mh8,'Label', 'Credit');
mh(8,3,1,1) = uimenu(mh8,'Label', 'License');




% Next, setup the callbacks for all relevant menus

set(mh(1,1,1,1),'callback', {@exit_Callback});
set(mh(2,1,1,1),'callback', {@opendoc1_Callback 'first.html'});
set(mh(2,2,1,1),'callback', {@opendoc1_Callback 'second.pdf'});
set(mh(3,1,1,1),'callback', {@opendoc1_Callback 'first.html'});
set(mh(3,2,1,1),'callback', {@opendoc1_Callback 'second.pdf'});
set(mh(4,1,1,1),'callback', {@opendoc1_Callback 'Abstract.pdf'});
set(mh(4,2,1,1),'callback', {@opendoc1_Callback 'Tutorial.ppt'});
set(mh(5,1,2,1),'callback', {@opendoc1_Callback 'lowCoh_input.html'});
set(mh(5,1,3,1),'callback', {@opendoc1_Callback 'lowCoh_non-directional_transient_cells.html'});
set(mh(5,1,4,1),'callback', {@opendoc1_Callback 'lowCoh_directional_transient_cells.html'});
set(mh(5,1,5,1),'callback', {@opendoc1_Callback 'lowCoh_directional_short_range_filters.html'});
set(mh(5,1,6,1),'callback', {@opendoc1_Callback 'lowCoh_directional_long-range_filters.html'});
set(mh(5,1,7,1),'callback', {@opendoc1_Callback 'lowCoh_directional_grouping_network.html'});
set(mh(5,1,8,2),'callback', {@opendoc1_Callback 'lowCoh_RT_task.html'});
set(mh(5,1,8,3),'callback', {@opendoc1_Callback 'lowCoh_FD_task.html'});
set(mh(5,2,2,1),'callback', {@opendoc1_Callback 'medCoh_input.html'});
set(mh(5,2,3,1),'callback', {@opendoc1_Callback 'medCoh_non-directional_transient_cells.html'});
set(mh(5,2,4,1),'callback', {@opendoc1_Callback 'medCoh_directional_transient_cells.html'});
set(mh(5,2,5,1),'callback', {@opendoc1_Callback 'medCoh_directional_short_range_filters.html'});
set(mh(5,2,6,1),'callback', {@opendoc1_Callback 'medCoh_directional_long-range_filters.html'});
set(mh(5,2,7,1),'callback', {@opendoc1_Callback 'medCoh_directional_grouping_network.html'});
set(mh(5,2,8,2),'callback', {@opendoc1_Callback 'medCoh_RT_task.html'});
set(mh(5,2,8,3),'callback', {@opendoc1_Callback 'medCoh_FD_task.html'});
set(mh(5,3,2,1),'callback', {@opendoc1_Callback 'highCoh_input.html'});
set(mh(5,3,3,1),'callback', {@opendoc1_Callback 'highCoh_non-directional_transient_cells.html'});
set(mh(5,3,4,1),'callback', {@opendoc1_Callback 'highCoh_directional_transient_cells.html'});
set(mh(5,3,5,1),'callback', {@opendoc1_Callback 'highCoh_directional_short_range_filters.html'});
set(mh(5,3,6,1),'callback', {@opendoc1_Callback 'highCoh_directional_long-range_filters.html'});
set(mh(5,3,7,1),'callback', {@opendoc1_Callback 'highCoh_directional_grouping_network.html'});
set(mh(5,3,8,2),'callback', {@opendoc1_Callback 'highCoh_RT_task.html'});
set(mh(5,3,8,3),'callback', {@opendoc1_Callback 'highCoh_FD_task.html'});
set(mh(6,1,2,1),'callback', {@opendoc1_Callback 'RTtask_description.pdf'});
set(mh(6,1,3,2),'callback', {@opendoc1_Callback 'RTtask_description.pdf'});
set(mh(6,1,3,3),'callback', {@run1_Callback 'RTtasknew(1,1,5,5,5,55);'});
set(mh(6,1,4,2),'callback', {@opendoc1_Callback 'RTtask_description.pdf'});
set(mh(6,1,4,3),'callback', {@run1_Callback 'Reaction_time_task_GUI'});
set(mh(6,2,2,1),'callback', {@opendoc1_Callback 'FDtask_description.pdf'});
set(mh(6,2,3,2),'callback', {@opendoc1_Callback 'FDtask_description.pdf'});
set(mh(6,2,3,3),'callback', {@run1_Callback 'FDtasknew(4.5,2,5,5,5,9);'});
set(mh(6,2,4,2),'callback', {@opendoc1_Callback 'FDtask_description.pdf'});
set(mh(6,2,4,3),'callback', {@run1_Callback 'Fixed_duration_task_GUI'});
set(mh(7,1,1,1),'callback', {@opendoc1_Callback 'code_1.pdf'});
set(mh(7,2,1,1),'callback', {@opendoc1_Callback 'code_2.html'});
set(mh(8,1,1,1),'callback', {@opendoc1_Callback 'Contact.html'});
set(mh(8,2,1,1),'callback', {@opendoc1_Callback 'Credit.html'});
set(mh(8,3,1,1),'callback', {@opendoc1_Callback 'License.html'});
% Displays a user-provided image on this GUI
[X,map] = imread('MODE_new.jpg');
imshow(X,map); % display image on front page


set(fh,'Visible','on');



% Functions needed by the output GUI will be generated in the following . . .


% generate callback function of the "opendoc1" type operation
function opendoc1_Callback(hObject,eventdata,varargin)
% hObject    handle to exit_callback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
open(varargin{1})



function exit_Callback(hObject, eventdata)
% hObject    handle to exit_Callback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
close all



% generate "run1" type callback function
function run1_Callback(hObject, eventdata, varargin)
% hObject    handle to RT_advanced_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
eval(varargin{1})



