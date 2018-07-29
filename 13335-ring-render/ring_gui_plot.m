function varargout = ring_gui_plot(varargin)
% RING_GUI_PLOT M-file for ring_gui_plot.fig
%      RING_GUI_PLOT, by itself, creates a new RING_GUI_PLOT or raises the existing
%      singleton*.
%
%      H = RING_GUI_PLOT returns the handle to a new RING_GUI_PLOT or the handle to
%      the existing singleton*.
%
%      RING_GUI_PLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RING_GUI_PLOT.M with the given input arguments.
%
%      RING_GUI_PLOT('Property','Value',...) creates a new RING_GUI_PLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ring_gui_plot_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ring_gui_plot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ring_gui_plot

% Last Modified by GUIDE v2.5 08-Dec-2006 16:31:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ring_gui_plot_OpeningFcn, ...
    'gui_OutputFcn',  @ring_gui_plot_OutputFcn, ...
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


% --- Executes just before ring_gui_plot is made visible.
function ring_gui_plot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ring_gui_plot (see VARARGIN)

% Choose default command line output for ring_gui_plot
handles.output = hObject;
set(handles.figure1,'Name','Step 2: Draw Ring Cross-section')

handles.ring_param=varargin{1};

% Update handles structure
guidata(hObject, handles);
axes(handles.axes1);
set(gca,'XtickLabel',[],'YtickLabel',[])
text_disp={'Place render nodes to the right of the vertical line.  When finished, place a final node to the left of the vertical line'};
set(handles.instruct,'String',text_disp,'FontSize',12,'FontName','Arial','HorizontalAlignment','Left','FontWeight','bold')
get_ring_coords(hObject, eventdata, handles);
% UIWAIT makes ring_gui_plot wait for user response (see UIRESUME)
uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = ring_gui_plot_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if strcmp(handles.output,'Ok')
    ring_param=handles.ring_param;
    x_list=handles.x_list;
    y_list=handles.y_list;
    delete(handles.figure1);
    ring_render(ring_param,x_list,y_list);
end

% --- Executes on button press in done_flag.
function done_flag_Callback(hObject, eventdata, handles)
% hObject    handle to done_flag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);

function get_ring_coords(hObject, eventdata, handles);

param_temp=handles.ring_param;
H=param_temp{4};
ring_color=param_temp{5}/255;

x=[0 0];
y=[0 H];
handles.x_list=x;
handles.y_list=y;
guidata(hObject, handles);

axes(handles.axes1);
axis([-2 2*H -H 2*H])
set(gca,'Xtick',[0:.5:2*H],'Ytick',[-H:.5:2*H],'XtickLabel',[],'YtickLabel',[])
grid on
hold on
plot(x,y,'bo-','LineWidth',2,'Color',ring_color,'MarkerFaceColor',ring_color,'MarkerEdgeColor','k')
[xtemp,ytemp]=ginput(1);

x=[x round(2*xtemp)/2];
y=[y round(2*ytemp)/2];

handles.x_list=x;
handles.y_list=y;
guidata(hObject, handles);

axes(handles.axes1);
axis([-2 2*H -H 2*H])
set(gca,'Xtick',[0:.5:2*H],'Ytick',[-H:.5:2*H],'XtickLabel',[],'YtickLabel',[])
grid on
plot(x,y,'bo-','LineWidth',2,'Color',ring_color,'MarkerFaceColor',ring_color,'MarkerEdgeColor','k','MarkerSize',6)

while xtemp>=0 
    axes(handles.axes1);
    axis([-2 2*H -H 2*H])
    set(gca,'Xtick',[0:.5:2*H],'Ytick',[-H:.5:2*H],'XtickLabel',[],'YtickLabel',[])
    grid on
    plot(x,y,'bo-','LineWidth',2,'Color',ring_color,'MarkerFaceColor',ring_color,'MarkerEdgeColor','k','MarkerSize',6)

    [xtemp,ytemp]=ginput(1);

    x=[x round(2*xtemp)/2];
    y=[y round(2*ytemp)/2];
    handles.x_list=x;
    handles.y_list=y;
    guidata(hObject, handles);
end

text_disp={'Press the ''Ok'' button to the right to render'};
set(handles.instruct,'String',text_disp,'FontSize',12,'FontName','Arial','HorizontalAlignment','Left','FontWeight','bold')
