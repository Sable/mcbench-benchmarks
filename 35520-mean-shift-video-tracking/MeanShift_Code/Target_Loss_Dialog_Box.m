%% Mean-Shift Video Tracking
% by Sylvain Bernhardt
% July 2008
%% Description
% Warning box that pops up when
% the target is lost by the tracking process.
% To run it, type 'Target_Loss_Dialog_Box' in the
% command line.

function varargout = Target_Loss_Dialog_Box(varargin)
% TARGET_LOSS_DIALOG_BOX M-file for Target_Loss_Dialog_Box.fig
%      TARGET_LOSS_DIALOG_BOX, by itself, creates a new TARGET_LOSS_DIALOG_BOX or raises the existing
%      singleton*.
%
%      H = TARGET_LOSS_DIALOG_BOX returns the handle to a new TARGET_LOSS_DIALOG_BOX or the handle to
%      the existing singleton*.
%
%      TARGET_LOSS_DIALOG_BOX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TARGET_LOSS_DIALOG_BOX.M with the given input arguments.
%
%      TARGET_LOSS_DIALOG_BOX('Property','Value',...) creates a new TARGET_LOSS_DIALOG_BOX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Target_Loss_Dialog_Box_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Target_Loss_Dialog_Box_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Target_Loss_Dialog_Box

% Last Modified by GUIDE v2.5 31-Jul-2008 22:29:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Target_Loss_Dialog_Box_OpeningFcn, ...
                   'gui_OutputFcn',  @Target_Loss_Dialog_Box_OutputFcn, ...
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


% --- Executes just before Target_Loss_Dialog_Box is made visible.
function Target_Loss_Dialog_Box_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Target_Loss_Dialog_Box (see VARARGIN)

% Choose default command line output for Target_Loss_Dialog_Box
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Set the dialog bow in the center of the screen
a = get(gcf,'Position');
width = a(3);
height = a(4);
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[scrsz(3)/2-width/2 scrsz(4)/2-height/2 width height]);
% Display the Warning icon
icon = imread('Files/Target_Loss.bmp');
axes(handles.Loss_pict)
imshow(icon);


% --- Outputs from this function are returned to the command line.
function varargout = Target_Loss_Dialog_Box_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% Close Dialog box by pushing OK
function Loss_OK_Callback(hObject, eventdata, handles)
delete(gcf);


