function tah = addtxaxis(ah,transform,ticks,txlabel,ticklabels);
% ADDTXAXIS Adds a transformed X-axis to top of axes
%   This function adds a second X-axis on the top of the specified axes,
%   with ticks and tick labels following a user-defined transformation of
%   the main X-Axis.
%
%   Syntax:     tah = addtxaxis(ah,transform,ticks,txlabel,ticklabels);
%
%   "ah" is the handle to the main axes, while tah is the returned handle to
%   the transformed axes. 
%
%   "transform" is a string containing the variable 'x' and describing the 
%   transform to be applied to the new x-axis in order to retrieve the
%   original axis. The provided transform is thus an inverse transform.
%   For example, '10.^x' would generate a log-scaled axis, while '1./x' 
%   would result in a reciprocal-scale axis. 'x' must be treated as a vector, 
%   and thus, dot-operators should be used when element-wise operations are 
%   used. "transform" is evaluated in the base workspace, thus using
%   variables which are defined in the base workspace should pose no
%   problem. If a variable in the base workspace is named 'x', it is saved
%   before the evaluation of "transform" and restored afterwards, so that
%   it should not be modified by addtxaxis.
%
%   "ticks" is a vector containing the position of the ticks to be drawn.
%   Tick positions cannot be auto-determined (for now).
%
%   "txlabel" is an optional string label for the transformed axis.
%
%   "ticklabels" is an optional vector or cell array of strings which replace
%   the values in "ticks" as tick labels. "labels" should be of the same
%   size as "ticks".
%
%   The syntax: addtxaxis(tah,'clear') deletes the transformed axis and
%   returns the axes to their original state.
%
%   Note 1: The second x-axis is not really transformed, in the sense that
%           if the main x-axis has a linear scale, the second x-axis still
%           has a linear scale. Only the ticks and tick labels show the
%           transformed scale. Thus, the second x-axis cannot be used to
%           create plot with the transformed scale.
%
%   Note 2: The second x-axis is actually put into the background, so that
%           when a mouse click occurs on the axes, the main x-axis is used.
%           In order to see the second x-axis correctly, the main x-axis
%           must have no color (i.e. its 'Color' property is set to
%           'none'). The background color is thus the second axes' color.
%           Perform set(tah,'Color',...) to change the background
%           color after setting up the transformed axes.

% (C) 2003
% Francois Bouffard
% fbouffar@gel.ulaval.ca

% Change log:
%   2003-10-03  First submission to MatlabCentral
%   2003-10-22  Fix of a bug found by Jackob van Bethlehem: now the
%               transfomation 'transform' is evaluated in the base
%               workspace, so that variables defined there can be used
%               in the expression. In case variable 'x' already exists,
%               the original 'x' is saved before the evaluation of 
%               'transform' and restored afterwards. Documentation modified
%               accordingly.
%	2004-10-09	Fixes suggested by Lars Kappei: 'Box' is now 'off'. and
%				correct units are now used for transformed axis.

% Arguments management
if nargin<5
    ticklabels = '';
end;
if nargin<4
    txlabel = '';
end;
if nargin<3 & ~strcmp(transform,'clear')
    error('Not enough input arguments');
end;
if strcmp(transform,'clear');
    clear_axes(ah);
    tah = [];
else
    tah = set_transformed_axes(ah,transform,ticks,txlabel,ticklabels);
end;

% Setting up transformed axes
function tah = set_transformed_axes(ah,transform,ticks,txlabel,ticklabels);

% Creating and setting up second axis
original.pos = get(ah,'Position');
original.color = get(ah,'Color');
original.units = get(ah,'units');
ahpos = original.pos;
if ~isempty(txlabel)
    ahpos(4) = ahpos(4)*0.95;
    set(ah,'Position',ahpos);
end;
tah = axes('units',original.units,'Position',ahpos,'Box','off');
switch_objects_depth(gcf,ah,tah);
set(ah,'Tag',['main_' num2str(tah)],...
    'UserData',original);
set(ah,'Color','none','Box','off');
set(tah,'XAxisLocation','Top',...
    'YAxisLocation','Right',...
    'YTick',[],...
    'XLim',get(ah,'XLim'),...
    'XScale',get(ah,'XScale'),...
    'XDir',get(ah,'Xdir'));
set(get(tah,'XLabel'),'String',txlabel);

% Applying transform
x = ticks;
if strcmp(transform(end),';');
    transform = transform(1:end-1);
end;
    %Last version: was simple 'eval'
    %eval(['tx = ' transform ';']);
    %New version: use of 'evalin' in base workspace
    %and preserves variable 'x' defined in base worksapce
evalin('base','if exist(''x''); org_x = x; end');
assignin('base','x',ticks);
tx = evalin('base',transform,transform);
evalin('base','if exist(''org_x''); x = org_x; clear org_x; end');

% Displaying ticks and tick labels
% (sorting is necessary when transform
% reverses the axis)
[sorted_tx,sorted_idx] = sort(tx);
if isempty(ticklabels)
    ticklabels = x(sorted_idx);
else
    ticklabels = ticklabels(sorted_idx);
end;
set(tah,'XTick',sorted_tx,'XTickLabel',ticklabels);
axes(ah);

% Removing transformed axes and reverting
% to original state
function clear_axes(tah);
ah = findobj('Tag',['main_' num2str(tah)]);
delete(tah);
original = get(ah,'UserData');
set(ah,'Position',original.pos);
set(ah,'Color',original.color);

% This function is used to bring the original axes
% on the foreground and the transformed axis to the background
function switch_objects_depth(parenthandle,obj1,obj2);
children = get(parenthandle,'Children');
obj1pos = find(children==obj1);
obj2pos = find(children==obj2);
children(obj1pos) = obj2;
children(obj2pos) = obj1;
set(parenthandle,'Children',children);
