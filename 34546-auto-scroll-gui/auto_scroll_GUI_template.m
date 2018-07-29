function varargout = auto_scroll_GUI_template(varargin)

%% Copyright (C) Marino Bajèiæ 2012 , marino.bajcic@gmail.com
%% This template can be always used as an template to create new GUI.
%% Size of window and panel in edit mode can be changed. 

% AUTO_SCROLL_GUI_TEMPLATE MATLAB code for auto_scroll_GUI_template.fig
%      AUTO_SCROLL_GUI_TEMPLATE, by itself, creates a new AUTO_SCROLL_GUI_TEMPLATE or raises the existing
%      singleton*.
%
%      H = AUTO_SCROLL_GUI_TEMPLATE returns the handle to a new AUTO_SCROLL_GUI_TEMPLATE or the handle to
%      the existing singleton*.
%
%      AUTO_SCROLL_GUI_TEMPLATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AUTO_SCROLL_GUI_TEMPLATE.M with the given input arguments.
%
%      AUTO_SCROLL_GUI_TEMPLATE('Property','Value',...) creates a new AUTO_SCROLL_GUI_TEMPLATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before auto_scroll_GUI_template_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to auto_scroll_GUI_template_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help auto_scroll_GUI_template

% Last Modified by GUIDE v2.5 18-Jan-2012 13:24:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @auto_scroll_GUI_template_OpeningFcn, ...
                   'gui_OutputFcn',  @auto_scroll_GUI_template_OutputFcn, ...
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


% --- Executes just before auto_scroll_GUI_template is made visible.
function auto_scroll_GUI_template_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to auto_scroll_GUI_template (see VARARGIN)

% Choose default command line output for auto_scroll_GUI_template
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes auto_scroll_GUI_template wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%This command do resize routine on opening
figure1_ResizeFcn(hObject, eventdata, handles);


% --- Outputs from this function are returned to the command line.
function varargout = auto_scroll_GUI_template_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function slider_y_Callback(hObject, eventdata, handles)
slider_y=get(handles.slider_y,'Value');
panel=get(handles.panel,'Position');
panel(1,1)=0;%x slider coordinate
panel(1,2)=-slider_y;%y slider coordinate
set(handles.panel,'Position',panel);

function slider_y_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider_x_Callback(hObject, eventdata, handles)
slider_x=get(handles.slider_x,'Value');
panel=get(handles.panel,'Position');
panel(1,1)=-slider_x;%x slider coordinate
set(handles.panel,'Position',panel);

function slider_x_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function figure1_ResizeFcn(hObject, eventdata, handles)
%% Intro 
slider_lower_side=0.42301166666666673;
%
base=get(gcf,'Position');
%
slider_y=get(handles.slider_y,'Position');
slider_y(1,1)=base(1,3)-slider_lower_side;%x slider coordinate
slider_y(1,2)=slider_lower_side;%y slider coordinate
slider_y(1,4)=base(1,4)-slider_lower_side;
if slider_y(1,4)>0 %to exclude error for minimum size
set(handles.slider_y,'Position',slider_y);
end
%
slider_x=[0 0 base(1,3)-slider_lower_side slider_lower_side];
%X slider
set(handles.slider_x,'Position',slider_x);
%% Small rectangular between sliders

set(handles.rectangle,'Position',...
    [base(1,3)-slider_lower_side  0 ...
    slider_lower_side   slider_lower_side])
%% Panel properties
panel=get(handles.panel,'Position');
% panel(1,3) - x panel size
% panel(1,4) - y panel size
panel(1,1)=0;
panel(1,2)=base(1,4)-panel(1,4);
set(handles.panel,'Position',panel);
%
%% seting scroll x min max position and slider x step size
new_slider_x_min=0;
new_slider_x_max=-base(1,3)+panel(1,3)+slider_lower_side;
%
set(handles.slider_x,'Min',new_slider_x_min);
set(handles.slider_x,'Max',new_slider_x_max);
set(handles.slider_x,'Value',new_slider_x_min);
%    
set(handles.slider_x,'SliderStep',[0.01*base(1,3)/panel(1,3)...
    2*base(1,3)/panel(1,3)]);
%% seting scroll y min max position and slider y step size
%
new_slider_y_min=-slider_lower_side;
new_slider_y_max=-base(1,4)+panel(1,4);
%
set(handles.slider_y,'Min',new_slider_y_min);
set(handles.slider_y,'Max',new_slider_y_max);
set(handles.slider_y,'Value',new_slider_y_max);
%    
set(handles.slider_y,'SliderStep',[0.01*base(1,4)/panel(1,4)...
    2*base(1,4)/panel(1,4)]);
%
% 
%% if is window size larger then panel deactivate scroll in that direction
%
if panel(1,3)<base(1,3)
    set(handles.slider_x,'Visible','off');
    set(handles.slider_y,'Position',[base(1,3)-slider_lower_side...
        0 slider_lower_side  base(1,4)]);
else
    set(handles.slider_x,'Visible','on');
end
%
if panel(1,4)<base(1,4)
   set(handles.slider_y,'Visible','off');
   set(handles.slider_x,'Position',[0 0 base(1,3) slider_lower_side]);
else
    set(handles.slider_y,'Visible','on');    
end
%% Rectangle show requirements
if panel(1,3)>base(1,3)&&panel(1,4)>base(1,4)
    set(handles.rectangle,'Visible','on');
else
    set(handles.rectangle,'Visible','off');
end
