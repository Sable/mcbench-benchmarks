function varargout = guibg(varargin)
%
%    GENERAL
%
%      varargout = guibg(varargin)
%
%    INPUT/S
%
%      -varargin:
%          currently no use.
%           
%    OUTPUT/S
%
%      -
%
%    PENDING WORK
%
%      -
%
%    KNOWN BUG/S
%
%      -
%
%    COMMENT/S
%
%      -
%
%    RELATED FUNCTION/S
%
%      
%
%    ABOUT
%
%      -Created:     February 12th, 2004
%      -Last update: 
%      -Revision:    0.0.9
%      -Author:      R. S. Schestowitz, University of Manchester
% ==============================================================

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @guibg_OpeningFcn, ...
    'gui_OutputFcn',  @guibg_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% End initialization code - DO NOT EDIT

function guibg_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);

if strcmp(get(hObject,'Visible'),'off')
    initialize_gui(hObject, handles);
end

function varargout = guibg_OutputFcn(hObject, eventdata, handles)


varargout{1} = handles.output;

function initialize_gui(fig_handle, handles)

background = imread('background.jpg');

axes(handles.background);
axis off;
imshow(background,[0,255]);

function ok_botton_Callback(hObject, eventdata, handles)

% save all data here

close;

function cancel_button_Callback(hObject, eventdata, handles)

close;

function apply_button_Callback(hObject, eventdata, handles)

% save all data here
