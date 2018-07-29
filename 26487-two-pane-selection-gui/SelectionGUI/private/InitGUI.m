function InitGUI(handles)
% Initialization function for GUI (runs once only)

% Copyright 2010 The MathWorks, Inc.
%
% Auth/Revision:
%   The MathWorks Consulting Group
%   $Author: rjackey $
%   $Revision: 241 $  $Date: 2010-01-26 15:17:00 -0500 (Tue, 26 Jan 2010) $
% -------------------------------------------------------------------------

% Get the handle to the main GUI
hFigure = handles.MainFig;

% Get the main list of models
ItemsList = getappdata(hFigure, 'ItemsList'); 

% Get initial selection (same as initial output)
InitSelectionIndex = getappdata(hFigure, 'OutputList');

% Get the title of the GUI
guiTitle = getappdata(handles.MainFig, 'guiTitle'); 

% Set the GUI to normal/modal
% set(hFigure, 'WindowStyle', 'normal');
set(hFigure, 'WindowStyle', 'modal');

% Center the GUI on the screen
movegui(hFigure, 'center')

% Set the title for the application
set(hFigure, 'Name', guiTitle);


%**********************************
%% Get some initialization variables
%**********************************

% Assign initial right side selection
ItemsIdx_R = InitSelectionIndex;

% Assign left side to all items, then empty the selected ones
ItemsIdx_L = 1:length(ItemsList);
ItemsIdx_L(ItemsIdx_R) = [];


%******************************
%% Initialize some appdatas
%******************************

% Set the index of selected models
setappdata(hFigure, 'ItemsIdx_L', ItemsIdx_L); 
setappdata(hFigure, 'ItemsIdx_R', ItemsIdx_R); 


%******************************************
%% Finish the rest of the GUI initializations
%******************************************

% Assign the tooltips to the GUI items
AssignTooltips(handles);

% Refresh the GUI
RefreshGUI(handles);
