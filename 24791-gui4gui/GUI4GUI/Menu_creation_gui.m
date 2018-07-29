function varargout = Menu_creation_gui(varargin)
% MENU_CREATION_GUI M-file for Menu_creation_gui.fig
%      MENU_CREATION_GUI, by itself, creates a new MENU_CREATION_GUI or raises the existing
%      singleton*.
%
%      H = MENU_CREATION_GUI returns the handle to a new MENU_CREATION_GUI or the handle to
%      the existing singleton*.
%
%      MENU_CREATION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MENU_CREATION_GUI.M with the given input arguments.
%
%      MENU_CREATION_GUI('Property','Value',...) creates a new MENU_CREATION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Menu_creation_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Menu_creation_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Menu_creation_gui

% Last Modified by GUIDE v2.5 24-Jun-2009 09:41:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Menu_creation_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @Menu_creation_gui_OutputFcn, ...
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


% --- Executes just before Menu_creation_gui is made visible.
function Menu_creation_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Menu_creation_gui (see VARARGIN)

% Choose default command line output for Menu_creation_gui
handles.output = hObject;
set(hObject,'Tag','L1data');  % change 'figure1' to 'L1data' so it won't get
                              % clobbered by subsequent GUIs (like Menu_level_two)
                              
handles.L1data = handles.figure1;   % makes L1data more easily accessible

% Update handles structure
guidata(hObject, handles);

set(0, 'HideUndocumented', 'Off');  % make available additional properties

data = getappdata(handles.L1data, 'menudata');

% This function follows MATLAB's property-pair input style
% so that varargin{1) is expected to be 'MenuType'
% and varargin{2} is the name of a menu, like 'File', 'Model', stc.
numvarargin = length(varargin);

% if numvarargin == 0        % can't use nargin because of hidden input args.
%     data.menu = 1;         % later, this will do all 8 menus
%     data.name = 'File';
% elseif numvarargin == 2 & varargin{1} == 'MenuType'
if numvarargin == 2 & varargin{1} == 'MenuType'
    MenuName = varargin{2};
    switch MenuName      % 'File', 'Model', 'Articles', . . . 'Help'
        case 'File'
           data.menu = 1;
           data.name = 'File';
        case 'Model'
           data.menu = 2;
           data.name = 'Model';
        case 'Articles'
           data.menu = 3;
           data.name = 'Articles';
        case 'Tutorial'
           data.menu = 4;
           data.name = 'Tutorial';
        case 'Examples'
           data.menu = 5;
           data.name = 'Examples';
        case 'Run'
           data.menu = 6;
           data.name =  'Run';
        case 'Code'
           data.menu = 7;
           data.name = 'Code';
        case 'Help'
           data.menu = 8;
           data.name =  'Help';
        otherwise
           disp('Not a valid selection.')
           return
    end
end

setappdata(handles.L1data,'menudata',data);

hmenu = axes('units','normalized','position',[0.54,0.55,0.45,0.4]);
uistack(hmenu,'top');
[Imenu, map] = imread(['Model_menu.jpg']);
imshow(Imenu,map)

axis off

TEXT = ['For menu task:  ' MenuName];
set(handles.text6,'String',TEXT)

hcns = axes('units','normalized','position',[0.0,0.85,0.2,0.1]);
uistack(hcns,'top');
Icns = gif2RGB('cns_techlab_logo.gif');
imshow(Icns)
axis off

% UIWAIT makes Menu_creation_gui wait for user response (see UIRESUME)
uiwait(handles.figure1);
%disp('I can resume now')


% --- Outputs from this function are returned to the command line.
function varargout = Menu_creation_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%varargout{1} = handles.output;
hg4g = findobj('tag','g4gdata');
if hg4g
  data = getappdata(hg4g, 'menudata');
  varargout{1} = data.task(data.menu);
else   % for now, running this GUI as a standalone does not return value
%  data = getappdata(handles.L1data,'menudata');
end


% --- Executes on selection change in inputmode.
function inputmode_Callback(hObject, eventdata, handles)
% hObject    handle to inputmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns inputmode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from inputmode
data = getappdata(handles.L1data, 'menudata');
inputMode = get(hObject, 'Value');
switch inputMode
case 1
  disp('Please make a valid selection.')
  return
case 2
  htable = findobj('tag','uitable1');
% mytable(1:100,1:4) = { '' };
% set(htable,'data',mytable);  % clear the table to give the user a clean slate
case 3
  htable = findobj('tag','uitable1');
  GID2 = main_inputfile;
  n = length(GID2.task(data.menu).string(:,1));
  if n > 0
    set(htable,'data', GID2.task(data.menu).string);
  else
    % for levels 2, 3, menu item starts from 2 instead of 1; a shift is required
    disp(['Nothing pre-defined for (' num2str(item1) ',' num2str(item2-1) ',:)'])
  end
end
setappdata(handles.L1data, 'menudata', data);


% --- Executes during object creation, after setting all properties.
function inputmode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveTableButton.
function saveTableButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveTableButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.L1data,'menudata');
htable = findobj('tag','uitable1');
mytable = get(htable,'Data');
n = sum(1-strcmp(mytable(:,1), ''));   % non-null elements of mytable
for item=1:n
  if ~isnumeric(mytable{item,1})
    a = str2double(mytable{item,1});
    mytable{item,1} = a;
  end
end
data.task(data.menu).name = data.name;
data.task(data.menu).string = mytable(1:n,1:4);
data.task(data.menu);
hg4g = findobj('Tag','g4gdata');
if hg4g
  setappdata(hg4g,'menudata',data);
else    % for now, running this GUI as a standalone does not return value
%  setappdata(handles.figure1, 'menudata', data);
%  the problem is that uiresume and close below will destroy the handle and
%  struct needed in OutputFcn. May be I should use assignin to save task
%  data (not a preferable solution though). Check waitfor.
end
uiresume(handles.figure1);  % resume from the wait issued in openingFcn
close(handles.L1data);      % close the GUI and returns to gui4gui


% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when entered data in editZZable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
% disp('Entered data')
% d = get(hObject,'Data')

% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ImageHere.
%function ImageHere_Callback(hObject, eventdata, handles)
% hObject    handle to ImageHere (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in clearTableButton.
function clearTableButton_Callback(hObject, eventdata, handles)
% hObject    handle to clearTableButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
htable = findobj('tag','uitable1');
mytable(1:100,1:4) = { '' };
set(htable,'data',mytable);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
