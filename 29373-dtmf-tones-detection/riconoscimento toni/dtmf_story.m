function varargout = dtmf_story(varargin)
% DTMF_STORY M-file for dtmf_story.fig
%      DTMF_STORY, by itself, creates a new DTMF_STORY or raises the existing
%      singleton*.
%
%      H = DTMF_STORY returns the handle to a new DTMF_STORY or the handle to
%      the existing singleton*.
%
%      DTMF_STORY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DTMF_STORY.M with the given input arguments.
%
%      DTMF_STORY('Property','Value',...) creates a new DTMF_STORY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dtmf_story_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dtmf_story_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dtmf_story

% Last Modified by GUIDE v2.5 16-Jul-2010 19:25:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dtmf_story_OpeningFcn, ...
                   'gui_OutputFcn',  @dtmf_story_OutputFcn, ...
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


% --- Executes just before dtmf_story is made visible.
function dtmf_story_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dtmf_story (see VARARGIN)

% Choose default command line output for dtmf_story
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dtmf_story wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dtmf_story_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axess_CreateFcn(hObject, eventdata, handles)
imshow(imread('toni.jpg'))
% hObject    handle to axess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axess


