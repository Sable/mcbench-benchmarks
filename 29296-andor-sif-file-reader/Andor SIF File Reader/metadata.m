function varargout = metadata(varargin)
% METADATA M-file for metadata.fig
%      METADATA, by itself, creates a new METADATA or raises the existing
%      singleton*.
%
%      H = METADATA returns the handle to a new METADATA or the handle to
%      the existing singleton*.
%
%      METADATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in METADATA.M with the given input arguments.
%
%      METADATA('Property','Value',...) creates a new METADATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before metadata_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to metadata_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help metadata

% Author:  Sathish Kumar Ramakrishnan
% E- mail: sathishkrishna12@gmail.com

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @metadata_OpeningFcn, ...
                   'gui_OutputFcn',  @metadata_OutputFcn, ...
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


% --- Executes just before metadata is made visible.
function metadata_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to metadata (see VARARGIN)

% Choose default command line output for metadata
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes metadata wait for user response (see UIRESUME)
% uiwait(handles.figure1);
clear;


% --- Outputs from this function are returned to the command line.
function varargout = metadata_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

sif = getappdata(0,'sif');
date = getappdata(sif, 'date');
set(handles.date,'string',date);
temp     = getappdata(sif,'temp');
set(handles.temp,'string',temp);
exptime  = getappdata(sif,'exptime');
set(handles.exptime,'string',exptime);
cyctime  = getappdata(sif,'cyctime');
set(handles.cyctime,'string',cyctime);
accyclc  = getappdata(sif,'accyclc');
set(handles.accyclc,'string',accyclc);
acyctim  = getappdata(sif,'acyctim');
set(handles.acyctim,'string',acyctim);
% stcyctim = getappdata(sif,'stcyctim');
% set(handles.stcyctim,'string',stcyctim);
pxrtime  = getappdata(sif,'pxrtime');
set(handles.pxrtime,'string',pxrtime);
gain     = getappdata(sif,'gain');
set(handles.gain,'string',gain);
% Sno      = getappdata(sif,'Sno');
% set(handles.Sno ,'string',Sno );
SoftVno  = getappdata(sif,'SoftVno');
set(handles.SoftVno,'string',SoftVno);
dettype  = getappdata(sif,'dettype');
set(handles.dettype,'string',dettype);
detsize  = getappdata(sif,'detsize');
set(handles.detsize,'string',detsize);
file     = getappdata(sif,'file');
set(handles.file,'string',file);
shtime   = getappdata(sif,'shtime');
set(handles.shtime,'string',shtime);
% fraxis   = getappdata(sif,'fraaxis');
% set(handles.fraxis ,'string',fraxis );
datatype = getappdata(sif,'datatype');
set(handles.datatype,'string',datatype);
% imageinf = getappdata(sif,'imageinf');
% set(handles.imageinf,'string',imageinf);
