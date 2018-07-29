function varargout = LeCroy_MATLAB_GUI_example(varargin)
% LECROY_MATLAB_GUI_EXAMPLE M-file for LeCroy_MATLAB_GUI_example.fig
%      LECROY_MATLAB_GUI_EXAMPLE, by itself, creates a new LECROY_MATLAB_GUI_EXAMPLE or raises the existing
%      singleton*.
%
%      H = LECROY_MATLAB_GUI_EXAMPLE returns the handle to a new LECROY_MATLAB_GUI_EXAMPLE or the handle to
%      the existing singleton*.
%
%      LECROY_MATLAB_GUI_EXAMPLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LECROY_MATLAB_GUI_EXAMPLE.M with the given input arguments.
%
%      LECROY_MATLAB_GUI_EXAMPLE('Property','Value',...) creates a new LECROY_MATLAB_GUI_EXAMPLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LeCroy_MATLAB_GUI_example_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LeCroy_MATLAB_GUI_example_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LeCroy_MATLAB_GUI_example

% Copyright 2009 - 2010 The MathWorks, Inc.
% Last Modified by GUIDE v2.5 15-Jan-2009 17:11:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LeCroy_MATLAB_GUI_example_OpeningFcn, ...
                   'gui_OutputFcn',  @LeCroy_MATLAB_GUI_example_OutputFcn, ...
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


% --- Executes just before LeCroy_MATLAB_GUI_example is made visible.
function LeCroy_MATLAB_GUI_example_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LeCroy_MATLAB_GUI_example (see VARARGIN)

% Choose default command line output for LeCroy_MATLAB_GUI_example
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LeCroy_MATLAB_GUI_example wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LeCroy_MATLAB_GUI_example_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
acquire_LeCroy_scope_data % call MATLAB script to acquire LeCroy scope data
plot(handles.axes1, T, Y) % Plot voltage vs. time data
xlabel('Time [s]')
ylabel('Voltage [V]')
