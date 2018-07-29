function linemenu( handles )
%LINEMENU adds a context menu to change line properties
%   LINEMENU(hline) creates a context menu for the line with handle hline
%   that allows line properties to be easily changed.
%   LINEMENU, without any input arguments, will create this context menu
%   for all lines that are found in the current figure.
%   This allows users to easily change line properties, and is especially
%   useful for compiled programs, as users do not have access to MATLAB's
%   property editor.
%
%   Example
%   ----------
%   x = -pi:.1:pi;
%   y1 = sin(x);
%   y2 = cos(x);
%   plot(x,y1,x,y2)
%   linemenu

if nargin == 0
    handles = findobj(gcf, 'type', 'line');
end

cmenu = uicontextmenu;
% Define the context menu items
stylemenu = uimenu(cmenu, 'Label', 'Line style');
colormenu = uimenu(cmenu, 'Label', 'Line color');
linewidthmenu = uimenu(cmenu, 'Label', 'Line width');
markermenu = uimenu(cmenu, 'Label', 'Marker type');
markersizemenu = uimenu(cmenu, 'Label', 'Marker size');
markercolormenu = uimenu(cmenu, 'Label', 'Marker edge color');
markerfacecolormenu = uimenu(cmenu, 'Label', 'Marker face color');


% Type of line
uimenu(stylemenu, 'Label', 'Solid', 'Callback', 'set(gco, ''LineStyle'', ''-'')');
uimenu(stylemenu, 'Label', 'Dashed', 'Callback', 'set(gco, ''LineStyle'', ''--'')');
uimenu(stylemenu, 'Label', 'Dotted', 'Callback', 'set(gco, ''LineStyle'', '':'')');
uimenu(stylemenu, 'Label', 'Dashed and dotted', 'Callback', 'set(gco, ''LineStyle'', ''-.'')');

% Color of line
uimenu(colormenu, 'Label', 'Red', 'Callback', 'set(gco, ''Color'', ''r'')');
uimenu(colormenu, 'Label', 'Blue', 'Callback', 'set(gco, ''Color'', ''b'')');
uimenu(colormenu, 'Label', 'Black', 'Callback', 'set(gco, ''Color'', ''k'')');
uimenu(colormenu, 'Label', 'Cyan', 'Callback', 'set(gco, ''Color'', ''c'')');
uimenu(colormenu, 'Label', 'Magneta', 'Callback', 'set(gco, ''Color'', ''m'')');
uimenu(colormenu, 'Label', 'Yellow', 'Callback', 'set(gco, ''Color'', ''y'')');
uimenu(colormenu, 'Label', 'Green', 'Callback', 'set(gco, ''Color'', ''g'')');

% Type of marker
uimenu(markermenu, 'Label', 'None', 'Callback', 'set(gco, ''Marker'', ''none'')');
uimenu(markermenu, 'Label', 'Point', 'Callback', 'set(gco, ''Marker'', ''.'')');
uimenu(markermenu, 'Label', 'Circle', 'Callback', 'set(gco, ''Marker'', ''o'')');
uimenu(markermenu, 'Label', 'X-mark', 'Callback', 'set(gco, ''Marker'', ''x'')');
uimenu(markermenu, 'Label', 'Plus', 'Callback', 'set(gco, ''Marker'', ''+'')');
uimenu(markermenu, 'Label', 'Star', 'Callback', 'set(gco, ''Marker'', ''*'')');
uimenu(markermenu, 'Label', 'Square', 'Callback', 'set(gco, ''Marker'', ''s'')');
uimenu(markermenu, 'Label', 'Diamond', 'Callback', 'set(gco, ''Marker'', ''d'')');
uimenu(markermenu, 'Label', 'Pentagram', 'Callback', 'set(gco, ''Marker'', ''p'')');
uimenu(markermenu, 'Label', 'Hexagram', 'Callback', 'set(gco, ''Marker'', ''h'')');
                               
% Marker size
uimenu(markersizemenu, 'Label', '2', 'Callback', 'set(gco, ''MarkerSize'', 2)');
uimenu(markersizemenu, 'Label', '4', 'Callback', 'set(gco, ''MarkerSize'', 4)');
uimenu(markersizemenu, 'Label', '6', 'Callback', 'set(gco, ''MarkerSize'', 6)');
uimenu(markersizemenu, 'Label', '8', 'Callback', 'set(gco, ''MarkerSize'', 8)');
uimenu(markersizemenu, 'Label', '10', 'Callback', 'set(gco, ''MarkerSize'', 10)');
uimenu(markersizemenu, 'Label', '15', 'Callback', 'set(gco, ''MarkerSize'', 15)');
uimenu(markersizemenu, 'Label', '20', 'Callback', 'set(gco, ''MarkerSize'', 20)');


% Marker edge color
uimenu(markercolormenu, 'Label', 'Red', 'Callback', 'set(gco, ''MarkerEdgeColor'', ''r'')');
uimenu(markercolormenu, 'Label', 'Blue', 'Callback', 'set(gco, ''MarkerEdgeColor'', ''b'')');
uimenu(markercolormenu, 'Label', 'Black', 'Callback', 'set(gco, ''MarkerEdgeColor'', ''k'')');
uimenu(markercolormenu, 'Label', 'Cyan', 'Callback', 'set(gco, ''MarkerEdgeColor'', ''c'')');
uimenu(markercolormenu, 'Label', 'Magneta', 'Callback', 'set(gco, ''MarkerEdgeColor'', ''m'')');
uimenu(markercolormenu, 'Label', 'Yellow', 'Callback', 'set(gco, ''MarkerEdgeColor'', ''y'')');
uimenu(markercolormenu, 'Label', 'Green', 'Callback', 'set(gco, ''MarkerEdgeColor'', ''g'')');

% Marker face color
uimenu(markerfacecolormenu, 'Label', 'Red', 'Callback', 'set(gco, ''MarkerFaceColor'', ''r'')');
uimenu(markerfacecolormenu, 'Label', 'Blue', 'Callback', 'set(gco, ''MarkerFaceColor'', ''b'')');
uimenu(markerfacecolormenu, 'Label', 'Black', 'Callback', 'set(gco, ''MarkerFaceColor'', ''k'')');
uimenu(markerfacecolormenu, 'Label', 'Cyan', 'Callback', 'set(gco, ''MarkerFaceColor'', ''c'')');
uimenu(markerfacecolormenu, 'Label', 'Magneta', 'Callback', 'set(gco, ''MarkerFaceColor'', ''m'')');
uimenu(markerfacecolormenu, 'Label', 'Yellow', 'Callback', 'set(gco, ''MarkerFaceColor'', ''y'')');
uimenu(markerfacecolormenu, 'Label', 'Green', 'Callback', 'set(gco, ''MarkerFaceColor'', ''g'')');

% Line Width
uimenu(linewidthmenu, 'Label', '0.25', 'Callback', 'set(gco, ''LineWidth'', 0.25)');
uimenu(linewidthmenu, 'Label', '0.5', 'Callback', 'set(gco, ''LineWidth'', 0.5)');
uimenu(linewidthmenu, 'Label', '0.75', 'Callback', 'set(gco, ''LineWidth'', 0.75)');
uimenu(linewidthmenu, 'Label', '1', 'Callback', 'set(gco, ''LineWidth'', 1)');
uimenu(linewidthmenu, 'Label', '2', 'Callback', 'set(gco, ''LineWidth'', 2)');

% Set UIcontextmenu
set(handles, 'UIContextMenu', cmenu);