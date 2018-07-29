function varargout = tut_buttondownfcn_hittest2(varargin)

% This is a GUIDE generated GUI.
% The GUI executes a callback function when a mouse is clicked over 
% a figure.
%
% Author: Narupon Chattrapiban
% Institution: University of Maryland
%
% Inspired by the reference below:
% [ref] http://www.mathworks.com/matlabcentral/newsreader/view_thread/160626

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tut_buttondownfcn_hittest2_OpeningFcn, ...
                   'gui_OutputFcn',  @tut_buttondownfcn_hittest2_OutputFcn, ...
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

% --- Executes just before tut_buttondownfcn_hittest2 is made visible.
function tut_buttondownfcn_hittest2_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
% set(handles.axes2,'hittest','off');
set(handles.axes1,'hittest','off');
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = tut_buttondownfcn_hittest2_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
handles.xy1 = round(get(handles.axes1,'Currentpoint'));
x1 = handles.xy1(1,1);
y1 = handles.xy1(1,2);
fprintf('Apbt: [x,y] = [%d,%d] \n',x1,y1);
% handles.xy2 = round(get(handles.axes2,'Currentpoint'));
% x2 = handles.xy2(1,1);
% y2 = handles.xy2(1,2);
% fprintf('Apbt: [x,y] = [%d,%d] \n',x2,y2);
axes(handles.axes1); a = imagesc(rand(10,10));
axes(handles.axes2); b = imagesc(rand(100,100));
set(handles.axes1,'hittest','off');
% set(handles.axes2,'hittest','off');
set(a,'hittest','off');
% set(b,'hittest','off');
guidata(hObject, handles);
