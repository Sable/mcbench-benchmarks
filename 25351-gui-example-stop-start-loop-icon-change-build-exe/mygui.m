function varargout = mygui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mygui_OpeningFcn, ...
                   'gui_OutputFcn',  @mygui_OutputFcn, ...
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


function mygui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
% changeIcon
jFrame=get(handles.figure1,'javaframe');
jIcon=javax.swing.ImageIcon('icon.gif');
jFrame.setFigureIcon(jIcon);
% changeUserData
set(handles.pushbutton_run,'UserData',0);



function varargout = mygui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function pushbutton_run_Callback(hObject, eventdata, handles)
if get(handles.pushbutton_run,'UserData')==1, return; end
set(handles.pushbutton_run,'UserData',1);
for n=1:40
    if get(handles.pushbutton_run,'UserData')==0, break; end
    cla; text(0.5,0.5,num2str(n)); pause(0.25);
end


function pushbutton_stop_Callback(hObject, eventdata, handles)
set(handles.pushbutton_run,'UserData',0);


