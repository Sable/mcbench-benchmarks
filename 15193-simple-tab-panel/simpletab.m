function varargout = simpletab(varargin)

%
% Usage: simpletab
%
% This script provides a template on how to create simple tab panels within a GUI. Each
% tab panel should be a different panel with different components and can be easily
% created with GUIDE. By using GUIDE, you can create as many different panels as you want
% and layout them in a comfortable way for building. When the script initiates, it places
% them one behind the other and handles their visibilities accordingly.
%
% The main idea behind simpletab is that you can create the tab labels by creating an
% equal number of static text uicontrols and layout them properly over an empty panel of
% proper defined size (see simpletab.fig in GUIDE). You can use then their positions to
% create axes objects (so that an edge line can be displayed around tabs without having to
% define the 'CData' property) and then create text objects (which are also more
% customizable than static text uicontrols) inside them. The control and highlighting of
% different tabs is performed through properly defined object callbacks (see code). The
% initial static text uicontrols are invisible in the final window. They are only used
% inside GUIDE for positioning purposes only.
%
% Make sure that the panel which is used for the proper placement of the static text
% uicontrols is the bigger one as the others will acquire its position. Ideally, the
% other panels should not be designed to be very different from the first one in terms of
% their dimensions because normally, in a multitab window all tabs should have the same
% size and the desired uicontrols should be fitted into them.
%
%
% Author: Panagiotis Moulos (pmoulos@eie.gr)
% Version: 1.0
% First created: June 4, 2007
% Last modified: June 8, 2007
%

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simpletab_OpeningFcn, ...
                   'gui_OutputFcn',  @simpletab_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before simpletab is made visible.
function simpletab_OpeningFcn(hObject, eventdata, handles, varargin)

% Set the colors indicating a selected/unselected tab
handles.unselectedTabColor=get(handles.tab1text,'BackgroundColor');
handles.selectedTabColor=handles.unselectedTabColor-0.1;

% Set units to normalize for easier handling
set(handles.tab1text,'Units','normalized')
set(handles.tab2text,'Units','normalized')
set(handles.tab3text,'Units','normalized')
set(handles.tab1Panel,'Units','normalized')
set(handles.tab2Panel,'Units','normalized')
set(handles.tab3Panel,'Units','normalized')

% Create tab labels (as many as you want according to following code template)

% Tab 1
pos1=get(handles.tab1text,'Position');
handles.a1=axes('Units','normalized',...
                'Box','on',...
                'XTick',[],...
                'YTick',[],...
                'Color',handles.selectedTabColor,...
                'Position',[pos1(1) pos1(2) pos1(3) pos1(4)+0.01],...
                'ButtonDownFcn','simpletab(''a1bd'',gcbo,[],guidata(gcbo))');
handles.t1=text('String','Tab 1',...
                'Units','normalized',...
                'Position',[(pos1(3)-pos1(1))/2,pos1(2)/2+pos1(4)],...
                'HorizontalAlignment','left',...
                'VerticalAlignment','middle',...
                'Margin',0.001,...
                'FontSize',8,...
                'Backgroundcolor',handles.selectedTabColor,...
                'ButtonDownFcn','simpletab(''t1bd'',gcbo,[],guidata(gcbo))');

% Tab 2
pos2=get(handles.tab2text,'Position');
pos2(1)=pos1(1)+pos1(3);
handles.a2=axes('Units','normalized',...
                'Box','on',...
                'XTick',[],...
                'YTick',[],...
                'Color',handles.unselectedTabColor,...
                'Position',[pos2(1) pos2(2) pos2(3) pos2(4)+0.01],...
                'ButtonDownFcn','simpletab(''a2bd'',gcbo,[],guidata(gcbo))');
handles.t2=text('String','Tab 2',...
                'Units','normalized',...
                'Position',[pos2(3)/2,pos2(2)/2+pos2(4)],...
                'HorizontalAlignment','left',...
                'VerticalAlignment','middle',...
                'Margin',0.001,...
                'FontSize',8,...
                'Backgroundcolor',handles.unselectedTabColor,...
                'ButtonDownFcn','simpletab(''t2bd'',gcbo,[],guidata(gcbo))');
           
% Tab 3 
pos3=get(handles.tab3text,'Position');
pos3(1)=pos2(1)+pos2(3);
handles.a3=axes('Units','normalized',...
                'Box','on',...
                'XTick',[],...
                'YTick',[],...
                'Color',handles.unselectedTabColor,...
                'Position',[pos3(1) pos3(2) pos3(3) pos3(4)+0.01],...
                'ButtonDownFcn','simpletab(''a3bd'',gcbo,[],guidata(gcbo))');
handles.t3=text('String','Tab 3',...
                'Units','normalized',...
                'Position',[pos3(3)/2,pos3(2)/2+pos3(4)],...
                'HorizontalAlignment','left',...
                'VerticalAlignment','middle',...
                'Margin',0.001,...
                'FontSize',8,...
                'Backgroundcolor',handles.unselectedTabColor,...
                'ButtonDownFcn','simpletab(''t3bd'',gcbo,[],guidata(gcbo))');
            
% Manage panels (place them in the correct position and manage visibilities)
pan1pos=get(handles.tab1Panel,'Position');
set(handles.tab2Panel,'Position',pan1pos)
set(handles.tab3Panel,'Position',pan1pos)
set(handles.tab2Panel,'Visible','off')
set(handles.tab3Panel,'Visible','off')

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes simpletab wait for user response (see UIRESUME)
% uiwait(handles.simpletabfig);


% --- Outputs from this function are returned to the command line.
function varargout = simpletab_OutputFcn(hObject, eventdata, handles) 


% Text object 1 callback (tab 1)
function t1bd(hObject,eventdata,handles)

set(hObject,'BackgroundColor',handles.selectedTabColor)
set(handles.t2,'BackgroundColor',handles.unselectedTabColor)
set(handles.t3,'BackgroundColor',handles.unselectedTabColor)
set(handles.a1,'Color',handles.selectedTabColor)
set(handles.a2,'Color',handles.unselectedTabColor)
set(handles.a3,'Color',handles.unselectedTabColor)
set(handles.tab1Panel,'Visible','on')
set(handles.tab2Panel,'Visible','off')
set(handles.tab3Panel,'Visible','off')


% Text object 2 callback (tab 2)
function t2bd(hObject,eventdata,handles)

set(hObject,'BackgroundColor',handles.selectedTabColor)
set(handles.t1,'BackgroundColor',handles.unselectedTabColor)
set(handles.t3,'BackgroundColor',handles.unselectedTabColor)
set(handles.a2,'Color',handles.selectedTabColor)
set(handles.a1,'Color',handles.unselectedTabColor)
set(handles.a3,'Color',handles.unselectedTabColor)
set(handles.tab2Panel,'Visible','on')
set(handles.tab1Panel,'Visible','off')
set(handles.tab3Panel,'Visible','off')


% Text object 3 callback (tab 3)
function t3bd(hObject,eventdata,handles)

set(hObject,'BackgroundColor',handles.selectedTabColor)
set(handles.t1,'BackgroundColor',handles.unselectedTabColor)
set(handles.t2,'BackgroundColor',handles.unselectedTabColor)
set(handles.a3,'Color',handles.selectedTabColor)
set(handles.a1,'Color',handles.unselectedTabColor)
set(handles.a2,'Color',handles.unselectedTabColor)
set(handles.tab3Panel,'Visible','on')
set(handles.tab1Panel,'Visible','off')
set(handles.tab2Panel,'Visible','off')


% Axes object 1 callback (tab 1)
function a1bd(hObject,eventdata,handles)

set(hObject,'Color',handles.selectedTabColor)
set(handles.a2,'Color',handles.unselectedTabColor)
set(handles.a3,'Color',handles.unselectedTabColor)
set(handles.t1,'BackgroundColor',handles.selectedTabColor)
set(handles.t2,'BackgroundColor',handles.unselectedTabColor)
set(handles.t3,'BackgroundColor',handles.unselectedTabColor)
set(handles.tab1Panel,'Visible','on')
set(handles.tab2Panel,'Visible','off')
set(handles.tab3Panel,'Visible','off')


% Axes object 2 callback (tab 2)
function a2bd(hObject,eventdata,handles)

set(hObject,'Color',handles.selectedTabColor)
set(handles.a1,'Color',handles.unselectedTabColor)
set(handles.a3,'Color',handles.unselectedTabColor)
set(handles.t2,'BackgroundColor',handles.selectedTabColor)
set(handles.t1,'BackgroundColor',handles.unselectedTabColor)
set(handles.t3,'BackgroundColor',handles.unselectedTabColor)
set(handles.tab2Panel,'Visible','on')
set(handles.tab1Panel,'Visible','off')
set(handles.tab3Panel,'Visible','off')


% Axes object 3 callback (tab 3)
function a3bd(hObject,eventdata,handles)

set(hObject,'Color',handles.selectedTabColor)
set(handles.a1,'Color',handles.unselectedTabColor)
set(handles.a2,'Color',handles.unselectedTabColor)
set(handles.t3,'BackgroundColor',handles.selectedTabColor)
set(handles.t1,'BackgroundColor',handles.unselectedTabColor)
set(handles.t2,'BackgroundColor',handles.unselectedTabColor)
set(handles.tab3Panel,'Visible','on')
set(handles.tab1Panel,'Visible','off')
set(handles.tab2Panel,'Visible','off')


% --- Executes on button press in tab1button.
function tab1button_Callback(hObject, eventdata, handles)

disp('Button from Tab 1 was pressed')


% --- Executes on button press in tab2button.
function tab2button_Callback(hObject, eventdata, handles)

disp('Button from Tab 2 was pressed')


% --- Executes on button press in tab3button.
function tab3button_Callback(hObject, eventdata, handles)

disp('Button from Tab 3 was pressed')
