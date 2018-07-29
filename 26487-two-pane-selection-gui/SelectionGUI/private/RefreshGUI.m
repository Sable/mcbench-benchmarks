function RefreshGUI(handles)
% Refresh function that sets GUI to a clean state (can run multiple time)

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

% Get the index of selected models
ItemsIdx_L = getappdata(hFigure, 'ItemsIdx_L'); 
ItemsIdx_R = getappdata(hFigure, 'ItemsIdx_R'); 

% Null the search string
SearchString = '';

% Get the selected value of each listbox
Value_L = get(handles.ItemsLeftLB,'Value');
Value_R = get(handles.ItemsRightLB,'Value');


%***************************************
%% Get the list of models to display on each pane
%***************************************

% Take only the unique indices and sort
ItemsIdx_L = sort(unique(ItemsIdx_L));
ItemsIdx_R = sort(unique(ItemsIdx_R));

% Create a cellstr array of selected models for each pane
ItemsList_L = ItemsList(ItemsIdx_L);
ItemsList_R = ItemsList(ItemsIdx_R);


%***************************************
%% Ensure the selected items are in bounds
%***************************************

% Reset the selection if multiple selections were made
if length(Value_L) > 1
    Value_L = 1;
end
if length(Value_R) > 1
    Value_R = 1;
end

% Ensure that the selections are in bounds
if Value_L > length(ItemsIdx_L)
    Value_L = length(ItemsIdx_L);
    if Value_L < 1
        Value_L = [];
    end
end
if Value_R > length(ItemsIdx_R)
    Value_R = length(ItemsIdx_R);
    if Value_R < 1
        Value_R = [];
    end
end


%***************************
%% Save GUI State information
%***************************

% Set the index of selected models
setappdata(hFigure, 'ItemsIdx_L', ItemsIdx_L);
setappdata(hFigure, 'ItemsIdx_R', ItemsIdx_R);


%***********************************************
%% Draw items in the GUI and finish the GUI chain
%***********************************************

% Set the selection of each listbox
set(handles.ItemsLeftLB,'Value',Value_L);
set(handles.ItemsRightLB,'Value',Value_R);

% Set the model names on each pane
set(handles.ItemsLeftLB,'String',ItemsList_L);
set(handles.ItemsRightLB,'String',ItemsList_R);

% Set the search box text
set(handles.SearchET,'String',SearchString);
