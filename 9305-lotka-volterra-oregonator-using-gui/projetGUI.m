function varargout = projet_fig(varargin)
% PROJETGUI M-file for projetGUI.fig
%      PROJETGUI, by itself, creates a new PROJETGUI or raises the existing
%      singleton*.
%
%      H = PROJETGUI returns the handle to a new PROJETGUI or the handle to
%      the existing singleton*.
%
%      PROJETGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJETGUI.M with the given input arguments.
%
%      PROJETGUI('Property','Value',...) creates a new PROJETGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before projetGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to projetGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help projetGUI

% Last Modified by GUIDE v2.5 02-Dec-2005 20:56:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @projetGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @projetGUI_OutputFcn, ...
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


% --- Executes just before projetGUI is made visible.
function projetGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to projetGUI (see VARARGIN)

% Choose default command line output for projetGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes projetGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = projetGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in lot.
function lot_Callback(hObject, eventdata, handles)
% hObject    handle to lot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Lotka_VolterraGUI;


% --- Executes on button press in ore.
function ore_Callback(hObject, eventdata, handles)
% hObject    handle to ore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OregonatorGUI;
