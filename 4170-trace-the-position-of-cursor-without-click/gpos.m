function [x,y]=gpos(h_axes)
%GPOS Get current position of cusor and return its coordinates in axes with handle h_axes
% h_axes - handle of specified axes
% [x,y]  - cursor coordinates in axes h_aexs
%
% -------------------------------------------------------------------------
% Note:
%  1. This function should be called in the figure callback WindowButtonMotionFcn.
%  2. It works like GINPUT provided by Matlab,but it traces the position
%       of cursor without click and is designed for 2-D axes.
%  3. It can also work even the units of figure and axes are inconsistent,
%       or the direction of axes is reversed.
% -------------------------------------------------------------------------

% Written by Kang Zhao,DLUT,Dalian,CHINA. 2003-11-19
% E-mail:kangzhao@student.dlut.edu.cn

h_figure=gcf;

units_figure = get(h_figure,'units');
units_axes   = get(h_axes,'units');

if_units_consistent = 1;

if ~strcmp(units_figure,units_axes)
    if_units_consistent=0;
    set(h_axes,'units',units_figure); % To be sure that units of figure and axes are consistent
end

% Position of origin in figure [left bottom]
pos_axes_unitfig    = get(h_axes,'position');
width_axes_unitfig  = pos_axes_unitfig(3);
height_axes_unitfig = pos_axes_unitfig(4);

xDir_axes=get(h_axes,'XDir');
yDir_axes=get(h_axes,'YDir');

% Cursor position in figure
pos_cursor_unitfig = get( h_figure, 'currentpoint'); % [left bottom]

if strcmp(xDir_axes,'normal')
    left_origin_unitfig = pos_axes_unitfig(1);
    x_cursor2origin_unitfig = pos_cursor_unitfig(1) - left_origin_unitfig;
else
    left_origin_unitfig = pos_axes_unitfig(1) + width_axes_unitfig;
    x_cursor2origin_unitfig = -( pos_cursor_unitfig(1) - left_origin_unitfig );
end

if strcmp(yDir_axes,'normal')
    bottom_origin_unitfig     = pos_axes_unitfig(2);
    y_cursor2origin_unitfig = pos_cursor_unitfig(2) - bottom_origin_unitfig;
else
    bottom_origin_unitfig = pos_axes_unitfig(2) + height_axes_unitfig;
    y_cursor2origin_unitfig = -( pos_cursor_unitfig(2) - bottom_origin_unitfig );
end

xlim_axes=get(h_axes,'XLim');
width_axes_unitaxes=xlim_axes(2)-xlim_axes(1);

ylim_axes=get(h_axes,'YLim');
height_axes_unitaxes=ylim_axes(2)-ylim_axes(1);

x = xlim_axes(1) + x_cursor2origin_unitfig / width_axes_unitfig * width_axes_unitaxes;
y = ylim_axes(1) + y_cursor2origin_unitfig / height_axes_unitfig * height_axes_unitaxes;

% Recover units of axes,if original units of figure and axes are not consistent.
if ~if_units_consistent
    set(h_axes,'units',units_axes); 
end