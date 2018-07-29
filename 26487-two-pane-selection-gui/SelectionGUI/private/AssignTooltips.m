function AssignTooltips(handles)
% Assign the tooltips to the gui items

% Copyright 2010 The MathWorks, Inc.
%
% Auth/Revision:
%   The MathWorks Consulting Group
%   $Author: rjackey $
%   $Revision: 241 $  $Date: 2010-01-26 15:17:00 -0500 (Tue, 26 Jan 2010) $
% -------------------------------------------------------------------------

%% Set the tooltip strings
set(handles.ToRightPB, 'TooltipString','Move selected items to the right side.');
set(handles.ToRightAllPB, 'TooltipString','Move all items to the right side.');
set(handles.ToLeftPB, 'TooltipString','Remove selected items from the right side.');
set(handles.ToLeftAllPB, 'TooltipString','Remove all items from the right side.');

set(handles.ItemsLeftLB,'TooltipString','List of all available items.');
set(handles.ItemsRightLB,'TooltipString','List of all selected items.');

set(handles.SearchET, 'TooltipString','Enter search text.');
set(handles.SearchPB, 'TooltipString','Search for items that begin with the specified text.');

set(handles.OkPB, 'TooltipString','Confirm Item Selection.');
set(handles.CancelPB, 'TooltipString','Cancel Item Selection.');