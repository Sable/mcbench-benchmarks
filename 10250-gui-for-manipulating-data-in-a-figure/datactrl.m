function datactrl(nfig)
% GUI to move a selected data point upward or downward by a user-defined amount 
% Input: nfig -- the number of the figure
% Use:  1. push the "Select" button
%       2. move the mouse unto the figure to select a data point to be
%           moved
%       3. push "Up" or "Down" button to move the data point
%       4. push "Undo" button to cancel the previous move
%       5. change the delty if needed
%
% Note: This function is not to be used against the rule "data is data"; rather, it is to help one
%       to plot data correctly, e.g. when plotting phase vs frequency in
%       spectrum analysis, one may need to move some phase data by 360,
%       2*pi, or 1 depending on the unit of the phase is degree, radian or
%       period.
%
% I beleive that these codes are also a good example of GUI development
%
%   by Hongxue Cai (h-cai@northwestern.edu)
%

% delete datactrl GUI figure, if any
delete(findobj('tag','h_fig'));
%
% %  GUI figgure (Hide the GUI as it is being constructed.)
h_fig   = figure('units', 'normalized', 'position', [0.3 0.25 0.26 0.2], 'color', [0.5 0.6 0.7], ...
            'resize', 'on', 'numbertitle', 'off', 'name', 'Data manipulating GUI', ...
            'menubar','none', 'tag', 'h_fig', 'Visible', 'off');
        
% %  Generate the structure of handles.
% %  This structure will be used to share data between callback functions of
% %  different graphical objets
handles = guihandles(h_fig);     

%% define default values here --------------->
handles.delty = 1;

if exist('nfig')
    handles.nfig = nfig;
else
    msgbox('Input must be the figure number!')
end

% %  Construct graphical components (objects) ======================>
% % push buttons
h_pbSelect  = uicontrol('Style', 'pushbutton', 'units', 'normalized', 'String', 'Select',...
                'Position', [0.25 0.65 0.2 0.15]);
set(h_pbSelect, 'fontweight', 'bold', 'fontsize', 11);
h_pbUndo    = uicontrol('Style', 'pushbutton', 'units', 'normalized', 'String', 'Undo',...
                'Position', [0.25 0.48 0.2 0.15]);
set(h_pbUndo, 'fontweight', 'bold', 'fontsize', 11);            
h_pbUp      = uicontrol('Style', 'pushbutton', 'units', 'normalized', 'String', 'Up',...
                'Position', [0.48 0.65 0.2 0.15]);
set(h_pbUp, 'fontweight', 'bold', 'fontsize', 11);
h_pbDown    = uicontrol('Style', 'pushbutton', 'units', 'normalized', 'String', 'Down',...
                'Position', [0.48 0.48 0.2 0.15]);
set(h_pbDown, 'fontweight', 'bold', 'fontsize', 11)

%static text
h_text      = uicontrol('Style', 'text', 'units', 'normalized', 'String', 'Delt_y:',...
                'Position', [0.25 0.16 0.2 0.15]);
set(h_text, 'backgroundcolor', [0.5 0.6 0.7], 'foregroundcolor', 'k')
set(h_text, 'fontweight', 'bold', 'fontsize', 11)

%editable text field
h_edit      = uicontrol('Style', 'edit', 'units', 'normalized', 'String', '1',...
    'Position', [0.48 0.2 0.2 0.15]);
set(h_edit, 'backgroundcolor', 'b', 'foregroundcolor', 'y')
set(h_edit, 'fontweight', 'bold', 'fontsize', 11)
% <=================================================================

%  Associate callbacks with components.
set(h_pbSelect, 'Callback', {@h_pbSelect_callback, handles});
set(h_pbUp, 'Callback', {@h_pbUp_callback, handles}); 
set(h_pbDown, 'Callback', {@h_pbDown_callback, handles}); 
set(h_edit, 'Callback', {@h_edit_callback, handles});
set(h_pbUndo, 'Callback', {@h_pbUndo_callback, handles});

% Make GUI visible, update handles
set(h_fig,  'visible', 'on'); 
guidata(h_fig, handles);

%  Callbacks for pusbutton "Select"   --------------------->
function h_pbSelect_callback(h_pbSelect, eventdata, handles)
% select point to be moved
handles = guidata(h_pbSelect);

figure(handles.nfig);
[handles.x, handles.y]  = ginput(1);

guidata(h_pbSelect, handles);
%<---------------------------------------------------------


%----------------------------------------------------------------------->
function h_pbUp_callback(hObject, eventdata, handles)
% callback function for pushbutton "Up," making selected point move upward
handles = guidata(gcbo);

% find the handles of data lines
h = findobj(handles.nfig, 'Type', 'line');

% get x, y of data lines, cell type
xcell = get(h, 'xdata');
ycell = get(h, 'ydata');
if length(h) == 1           % non cell
    xcell = mat2cell(xcell);
    ycell = mat2cell(ycell);
end
handles.yUndo = ycell;      %4 Undo

% finding the index of the point to be moved, the point who has the
% shortest distance to (handles.x, handles.y) just selected after pushing
% down the Select button
[m, n] = findp(xcell, ycell, handles.x, handles.y);
handles.mUndo = m;

%updating y data
ycell{m}(n) = ycell{m}(n) + handles.delty;
set(h(m), 'Ydata', ycell{m});

guidata(gcbo, handles);
% <------------------------------------------------------------------------


%----------------------------------------------------------------------->
function h_pbDown_callback(hObject, eventdata, handles)
%% callback function for pushbutton "Down"
handles = guidata(gcbo);

% find the handles of data lines
h = findobj(handles.nfig, 'Type', 'line');

% get x, y of data lines, cell type
xcell = get(h, 'xdata');
ycell = get(h, 'ydata');
if length(h) == 1           % non cell
    xcell = mat2cell(xcell);
    ycell = mat2cell(ycell);
end
handles.yUndo = ycell;

% finding the index of the point to be moved, the point who has the
% shortest distance to (handles.x, handles.y) just selected after pushing
% down the Select button
[m, n] = findp(xcell, ycell, handles.x, handles.y);
handles.mUndo = m;

%updating y data
ycell{m}(n) = ycell{m}(n) - handles.delty;
set(h(m), 'Ydata', ycell{m});

guidata(gcbo, handles);
% <------------------------------------------------------------------------

%----------------------------------------------------------------------->
function h_pbUndo_callback(h_pbUndo, eventdata, handles)
%% callback function for pushbutton "Down," cancel previous move
handles = guidata(h_pbUndo);

% find the handles of data lines
h = findobj(handles.nfig, 'Type', 'line');

% Undo
set(h(handles.mUndo), 'Ydata', handles.yUndo{handles.mUndo});

guidata(h_pbUndo, handles);
% <------------------------------------------------------------------------


% ------------------------------------------------------------>
function h_edit_callback(hObject, eventdata, handles)
% callback function for the editable text field, delty control
handles = guidata(gcbo);
handles.delty = str2num(get(hObject, 'String'));

guidata(gcbo, handles);
%< --------------------------------------------------------------


%------------------------------------------------------------------------->
function [m, n] = findp(xcell, ycell, x, y)
% finding the point among (xcell, ycell) who has the shortest distance to
% the point (x, y)
if ~iscell(xcell)
    xcell = mat2cell(xcell);
    ycell = mat2cell(ycell);
end

for k = 1:length(xcell)
    dist(k, 1:length(xcell{k})) = sqrt((xcell{k} - x).*(xcell{k} - x) + ...
            (ycell{k} - y).*(ycell{k} - y));
end 

[a ,b] = size(dist);
if a > 1
    dist(dist == 0) = max(max(dist));     % 4 different data length of lines
    [tem, m] = min(min(dist'));
    [tem, n] = min(min(dist));
else
    m = 1;
    [tem, n] = min(dist); 
end
% point found: (xcell{m}(n), ycell{m}(n))
% <----------------------------------------------------------------------------