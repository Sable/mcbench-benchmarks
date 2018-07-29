function varargout = ascii(varargin)
% ASCII M-file for ascii.fig
%      ASCII, by itself, creates a new ASCII or raises the existing
%      singleton*.
%
%      H = ASCII returns the handle to a new ASCII or the handle to
%      the existing singleton*.
%
%      ASCII('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASCII.M with the given input arguments.
%
%      ASCII('Property','Value',...) creates a new ASCII or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ascii_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ascii_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ascii

% Last Modified by GUIDE v2.5 29-Jun-2010 21:17:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ascii_OpeningFcn, ...
                   'gui_OutputFcn',  @ascii_OutputFcn, ...
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


% --- Executes just before ascii is made visible.
function ascii_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ascii (see VARARGIN)

% Choose default command line output for ascii
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
img=imread('ascii.png');    %Leggo la tabella ascii da disco
axes(handles.axes2)         %Fisso l'axes per il plot
imshow(img)                 %Mostro la tabella ascii
% UIWAIT makes ascii wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ascii_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


