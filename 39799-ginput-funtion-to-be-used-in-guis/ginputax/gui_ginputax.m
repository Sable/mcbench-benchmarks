function varargout = gui_ginputax(varargin)
% GUI_GINPUTAX MATLAB code for gui_ginputax.fig
%      GUI_GINPUTAX, by itself, creates a new GUI_GINPUTAX or raises the existing
%      singleton*.
%
%      H = GUI_GINPUTAX returns the handle to a new GUI_GINPUTAX or the handle to
%      the existing singleton*.
%
%      GUI_GINPUTAX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_GINPUTAX.M with the given input arguments.
%
%      GUI_GINPUTAX('Property','Value',...) creates a new GUI_GINPUTAX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_ginputax_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_ginputax_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_ginputax

% Last Modified by GUIDE v2.5 10-Jan-2013 20:23:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_ginputax_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_ginputax_OutputFcn, ...
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


% --- Executes just before gui_ginputax is made visible.
function gui_ginputax_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_ginputax (see VARARGIN)

% Choose default command line output for gui_ginputax
handles.output = hObject;

x = -1:0.01:1;

axes(handles.axes1);
plot(x,sin(x));

axes(handles.axes2);
plot(x,cos(x));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_ginputax wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_ginputax_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_axes1.
function pb_axes1_Callback(hObject, eventdata, handles)
% hObject    handle to pb_axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[x,y,button,ax]=ginputax(handles.axes1,1);

if ax==1
    axes(handles.axes1);
    hold on
    plot(x,y,'ro');plot(x,sin(x))
end


% --- Executes on button press in pb_axes2.
function pb_axes2_Callback(hObject, eventdata, handles)
% hObject    handle to pb_axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[x,y,button,ax]=ginputax(handles.axes2,1);

if ax==1
    axes(handles.axes2);
    hold on
    plot(x,y,'ro');plot(x,cos(x))
end
% --- Executes on button press in pb_both.
function pb_both_Callback(hObject, eventdata, handles)
% hObject    handle to pb_both (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[x,y,button,ax]=ginputax([handles.axes1 handles.axes2],1);

if ax==1
    axes(handles.axes1);
    hold on
    plot(x,y,'ro');plot(x,sin(x))
elseif ax==2
    axes(handles.axes2);
    hold on
    plot(x,y,'ro');plot(x,cos(x))
end
