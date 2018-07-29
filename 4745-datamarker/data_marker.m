function h =data_marker(x,in1,DoneFcn)

% This code implements horizontal movement of vertical line.
%
% Syntax:
% h = data_marker places a vertical line at the midpoint of the axes
% h = data_marker(X) places vertical lines at locations specified in x. 
%
% h = data_marker(X,IN1) 
% IN1 determines the line style, color and marker of the line. If more
% than one line specified IN1 should be a cell aray of strings.
%
% h = data_marker(X,IN1,DONEFCN) allows a function handle or a string 
% to be passed. This is used to specify an external function to be 
% executed. This function is run as part of a callback for the context 
% menu of the axes. 
%
% In all cases a text object is initially placed on the line to display 
% the line's x-value. This function outputs a vector of handles to the 
% lines.
% 
% DATA_MARKER always acts on the current axes. If called more than once 
% for the same axes then additional lines are added to the current axes.
%
% Examples:
% t=0:.01:2*pi;
% y = sin(t);
% plot(t,y)
% h = data_marker(1); 
% h = data_marker(1:2,{'b','r:'}); 
% h = data_marker(1:3,{'b','r:'}); 
%
% h = data_marker(1,'b',@myfunc) or h=data_marker(1,'b','myfunc') executes 
% the function DoneFcn when selected from the context menu of the axes. 
%
% Interaction:
% Left Click and hold on the lines to move them horizontally
% Left Click on text to drag anywhere on the figure window
% Right Click on Line and you will get two options:
% 
% 1. Delete - Deletes line and associated text object
% 2. Turn Off Text turns text object's Visible property to Off so you can hide
% the text. Right Click on line and select Turn On Text to view the text object
%
% Right Click on Text Object and select Snap To Line to make the text
% object reattach to it's associated line at the current vertical level.
% NOTE: Text will snap to line when the line is next moved.
% Portions of code used were from the MATLAB Central Files VLINE.M
% submitted by Brandon Kuczenski for Kensington Labs and DATALABEL.M
% submitted by Scott Hirsch.

% Parse input arguments to set up the vertical line plots

% zero arguments use default of one line at current axis midpoint

if nargin==0
    x_lim = get(gca,'XLim');
    x = mean(x_lim);
end

% Create labels for initial text
for i=1:length(x)
    label_str{i} = num2str(x(i));
end

% If no line type specified use blue solid as default. Otherwise use the
% user input to data_marker

if nargin < 2
    hv = vline(x,'b',label_str);
else 
    hv = vline(x,in1,label_str);
end

% If no function handle or string specified set the DoneFcn to empty
if nargin<3, 
    DoneFcn=[]; 
end

set(gcf,'Nextplot','Replace')
set(gcf,'DoubleBuffer','on')

handle = hv;
h_ax=get(handle,'parent');

if nargout
    h=hv;
end
if iscell(h_ax)
    h_ax = h_ax{1};
end

h_fig=get(h_ax,'parent');
cmenu_ax = uicontextmenu;
item1 = uimenu(cmenu_ax,'Label','Execute Done Function','Callback',@AxesDoneFcn);
set(h_ax,'Uicontextmenu',cmenu_ax)

setappdata(h_fig,'h_vline',handle) % set's line handles to figure appdata
setappdata(h_ax,'DoneFcn',DoneFcn) % set's the function handle or string to axes appdata
set(handle,'ButtonDownFcn',@DownFcn) %set the line ButtonDownFcn to use the DownFcn subfunction as callback

function h = vline(x,in1,in2)

% function h=vline(x, linetype, label)
% 
% Draws a vertical line on the current axes at the location specified by
% 'x'. 
% 
% Original code was submitted by:
% By Brandon Kuczenski for Kensington Labs.
% 
% 8 November 2001

% Downloaded 8/7/03 from MATLAB Central
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=1039&objectType=file
%
% This code has been modified from it's original version to support this
% file

for i=1:length(x)
    
    % Create Context Menu for the Line
    cmenu_line = uicontextmenu;
    item1 = uimenu(cmenu_line, 'Label', 'Delete', 'Callback', @DeleteFcn);
    item2 = uimenu(cmenu_line,'Label','Turn off text','Callback',@TextFcn);
    
    % Create Context Menu for the text
    cmenu_text = uicontextmenu;
    item1 = uimenu(cmenu_text, 'Label', 'Snap Text To Line', 'Callback', @SnapFcn);
    item2 = uimenu(cmenu_text,'Label','Justify Text');
    
    % Create a Sun Context Menu
    item_sub1 = uimenu(item2,'Label','Left','Callback',@JustifyFcn,'Checked','On');
    item_sub2 = uimenu(item2,'Label','Right','Callback',@JustifyFcn);
    item_sub3 = uimenu(item2,'Label','Center','Callback',@JustifyFcn);
    
    set(item_sub1,'UserData',[item_sub2 item_sub3]);
    set(item_sub2,'UserData',[item_sub1 item_sub3]);
    set(item_sub3,'UserData',[item_sub1 item_sub2]);
    % Create the lines with appropriate properties
    if ~iscell(in1)
        linetype = in1;  
    elseif i>length(in1)
        linetype=in1{end};
    else
        linetype=in1{i};
    end
    
    label = in2{i};
    g=ishold(gca);
    hold on
    xpos = x(i);
    y=get(gca,'ylim');
    h(i)=plot([xpos xpos],y,linetype,'UIContextMenu',cmenu_line);
    
    xx=get(gca,'xlim');
    xrange=xx(2)-xx(1);
    
    % Set text location to the middle of line
    ymid = mean(y);
    
    
    h_text(i) = text(xpos,ymid,label,'color',get(h(i),'color'),'UIContextMenu',cmenu_text,...
        'UserData',1,'HorizontalAlignment','Left');
    set(h_text(i),'ButtonDownFcn',@DownFcn)
    set(h_text(i),'EraseMode','xor')
    set(h(i),'UserData',h_text(i))
    
    
    if g==0
        hold off
    end    
end


function DownFcn(hObject,eventdata,varargin)
% Callbcak for Left mouse click on object
set(gcf,'WindowButtonMotionFcn',@MoveFcn) 
set(gcf,'WindowButtonUpFcn',@UpFcn)


function UpFcn(hObject,eventdata,varargin)
% Callback for mouse button release
set(gcf,'WindowButtonMotionFcn',[])


function SnapFcn(hObject,eventdata,varargin)
% Callback to snap text to line
h_text = gco;
set(h_text,'UserData',1)

function DeleteFcn(hObject,eventdata,varargin)
% Callback to delete line and text objects
h_vline = gco;
h_text = get(h_vline,'UserData');
delete(h_vline,h_text)
drawnow


function TextFcn(hObject,eventdata,varargin)
% Callback to turn text on or off
h_vline = gco;
h_text = get(h_vline,'UserData');

str = get(hObject,'Label');
if strcmp(str,'Turn off text')
    set(h_text,'Visible','off')
    set(hObject,'Label','Turn on text')
else
    set(hObject,'Label','Turn off text')
    set(h_text,'Visible','on')
end

function AxesDoneFcn(hObject,eventData,varargin)

% Check for function handle or string argument for third argument and
% evaluate once button is released
DoneFcn=getappdata(gca,'DoneFcn');
if isstr(DoneFcn)
    evalin('base',DoneFcn)
elseif isa(DoneFcn,'function_handle')
    feval(DoneFcn)
end

function JustifyFcn(hObject,eventdata,varargin)
str = get(hObject,'Label');
set(hObject,'Checked','On')
menu_handles = get(hObject,'UserData');
set(menu_handles,'Checked','Off')
set(gco,'HorizontalAlignment',str)

function MoveFcn(hObject,eventdata,varargin)
% Callback for left click and drag when over an object (line or text)


current_obj = gco;
current_obj_type = get(current_obj,'Type'); % Is it a Line or Text Object

% If it's a line object
if strcmp(current_obj_type,'line')
    h_vline = gco;
    h_ax=get(h_vline,'parent');
    
    if iscell(h_ax)
        h_ax = h_ax{1};
    end
    
    % get the current mouse point
    cp = get(h_ax,'CurrentPoint');
    xpos = cp(1);
    x_range=get(h_ax,'xlim');
    if xpos<x_range(1), xpos=x_range(1); end
    if xpos>x_range(2), xpos=x_range(2); end
    
    % get the current state of the text object. Is it snapped to line ro
    % free
    h_text = get(h_vline,'UserData');
    isSnapped = get(h_text,'UserData');
    
    % get the XData of the line and the position and string of the text
    % object
    XData = get(h_vline,'XData');
    str = get(h_text,'String');
    pos = get(h_text(1),'position');
    XData(:)=xpos;
    
    % Change location of line to the current point
    set(h_vline,'xdata',XData)
    
    % Check to see if text object is snapped to the line
    if isSnapped
        % if so change the position so it moves with line
        set(h_text,'Position',[XData(1),pos(2),0],'String',sprintf('%0.4g',XData(1)))
    else
        % If not then just change the string of the text object
        set(h_text,'String',sprintf('%0.4g',XData(1)))
    end
    
elseif strcmp(current_obj_type,'text')
    % Checks If you are clicking on a text object and just moves it to the
    % current mouse point
    
    h_text = gco;
    isSnapped = get(h_text,'UserData');
    cp = get(gca,'CurrentPoint');
    h_text = gco;
    pt = cp(1,[1 2]);
    x = cp(1,1);       %first xy values
    y = cp(1,2);    
    set(h_text,'Position', [x y 0],'UserData',0)
    
end

