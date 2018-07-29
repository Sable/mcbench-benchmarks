%% rangeframe
%
%  James Houghton
%  James.P.Houghton@gmail.com
%  December 8 2009
%
% A range frame lets you include information in what would otherwise
% be dumb ink on your plot, such as mean, median, quartiles, or standard deviation.
% 
% This code based upon:
%  
%  Edward Tufte: Visual Display of Quantitative Information 
%  Second Edition
%  Graphics Press
%  pg 132
%
%% ToDo:
%
% # Clean up tick/number positioning
% # Find a better way to name data pulled out of the get return array
%
%% Function Definition
% Inputs:
%
% * *main_axis* - handle to the axis we intend to modify 
% * *x_frame*   - a five element vector showing horizontal range frame limits, described below
% * *y_frame*   - a five element vector showing vertical range frame limits, described below
%
% Outputs:
%
% * *main_axis* - handle to the modified axis
%
function [main_axis] = rangeframe(main_axis, x_frame, y_frame)
%% get current axis properties
dims = get(main_axis, 'Position');
    left   = dims(1);           % break these out for clarity
    bottom = dims(2);           % (I wish I knew a better way...)
    width  = dims(3);
    height = dims(4);
x_axis_lims = get(main_axis, 'XLim');
    x_axis_min = x_axis_lims(1);
    x_axis_max = x_axis_lims(2);
y_axis_lims = get(main_axis, 'YLim');
    y_axis_min = y_axis_lims(1);
    y_axis_max = y_axis_lims(2);    
    
%% draw range frame

% set tick length for middle value
l_tick = .01;

% map x_frame array to normalized figure coordinates
x_frame_mapped = (x_frame-x_axis_min)/(x_axis_max-x_axis_min) * width + left;

% map y_frame array to normalized figure coordinates
y_frame_mapped = (y_frame-y_axis_min)/(y_axis_max-y_axis_min) * height + bottom;

% draw horizontal axis range frame
annotation('line', [x_frame_mapped(1),x_frame_mapped(2)], [bottom, bottom]);
annotation('line', [x_frame_mapped(3),x_frame_mapped(3)], [bottom-l_tick, bottom+l_tick], 'Linewidth', 2); 
annotation('line', [x_frame_mapped(4),x_frame_mapped(5)], [bottom, bottom]);

% draw vertical axis range frame
annotation('line', [left, left], [y_frame_mapped(1),y_frame_mapped(2)]);
annotation('line', [left-l_tick, left+l_tick], [y_frame_mapped(3),y_frame_mapped(3)], 'Linewidth', 2); 
annotation('line', [left, left], [y_frame_mapped(4),y_frame_mapped(5)]);

%% Modify the existing axes to improve the visibility of the range frame

% modify the normal axis
set(main_axis, ...
    'color', 'none', ...    % make sure the background is clear (white would also work)
    'xgrid', 'off', ...     % make sure there is no background grid
    'ygrid','off', ...
    'box', 'off', ...       % get rid of upper and right hand axis frame
    'TickDir', 'out', ...   % set the tick marks to point towards numbers to distringuish from center tick
    'TickLength', [l_tick/2,0]);    % make ths ticks short for the same reason

% cover the axis with a mask to hide the lines
mask_axis = copyobj(main_axis, gcf); 
set(mask_axis, ...
    'xcolor', 'w', ...      % maxe the axis lines white
    'ycolor','w', ...
    'Xtick',[], ...         % dont print any ticks or numbers
    'Ytick',[]);


