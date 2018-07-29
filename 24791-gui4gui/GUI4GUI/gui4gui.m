function varargout = gui4gui(varargin)
% GUI4GUI M-file for gui4gui.fig
%      GUI4GUI, by itself, creates a new GUI4GUI or raises the existing
%      singleton*.
%
%      H = GUI4GUI returns the handle to a new GUI4GUI or the handle to
%      the existing singleton*.
%
%      GUI4GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI4GUI.M with the given input arguments.
%
%      GUI4GUI('Property','Value',...) creates a new GUI4GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui4gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui4gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui4gui

% Last Modified by GUIDE v2.5 25-Jun-2009 08:53:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui4gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui4gui_OutputFcn, ...
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


% --- Executes just before gui4gui is made visible.
function gui4gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui4gui (see VARARGIN)

% Choose default command line output for gui4gui
handles.output = hObject;

set(hObject,'Tag','g4gdata');  % change 'figure1' to 'g4gdata' to distincguish
                               % it from Menu_creation_gui's 'figure1'

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui4gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);    % keep the for-loop from advancing

set(0, 'HideUndocumented', 'Off');  % make available additional properties
set(handles.pushbutton2,'Enable','off')

% --- Outputs from this function are returned to the command line.
function varargout = gui4gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on selection change in makeMenus.
function makeMenus_Callback(hObject, eventdata, handles)
% hObject    handle to makeMenus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns makeMenus contents as cell array
%        contents{get(hObject,'Value')} returns selected item from makeMenus

% Initialize struct "Task"; this is especially important for structs

Nmenus = 8;   % total number of menus; don't change
MENUS = {'File' 'Model' 'Articles' 'Tutorial' 'Examples' 'Run' 'Code' 'Help'};

for menu=1:Nmenus
  Task(menu).name = '';   % name of menu task, like 'File', 'Model', etc.
  Task(menu).string(1:400) = { '' };  % <= 100 items each with 4 fields
% GID.task(menu).name = { '' };
% GID.task(menu).string(1:100,2:4) = { '' };
end

guiName = get(handles.edit2,'string');
frontImage = get(handles.edit3,'string');
GID.guiName = guiName;
GID.Nmenus = Nmenus;
GID.frontImage = frontImage;
GID.bgcolor = 'white';
GID.fontsize = 10;
GID.fontweight = 'bold';
GID.position = [0.1 0.1 0.6 0.6];
GID.resize = 'off';

% user is prompted for what menus to generate (individual menu or all 8 menus)
selected_item_number = get(hObject,'Value');
string_list = get(hObject,'String');
selected = string_list{selected_item_number};

% Collect the "Task" data 
switch selected
case 'File'
    Task(1) = Menu_creation_gui('MenuType', 'File');
    if exist([pwd filesep 'tempout.mat'],'file')
      load tempout
    end
    GID.task(1) = Task(1);
    save tempout GID
case 'Model'
    Task(2) = Menu_creation_gui('MenuType','Model');
    if exist([pwd filesep 'tempout.mat'],'file')
      load tempout
    end
    GID.task(2) = Task(2);
    save tempout GID
case 'Articles'
    Task(3) = Menu_creation_gui('MenuType','Articles');
    if exist([pwd filesep 'tempout.mat'],'file')
      load tempout
    end
    GID.task(3) = Task(3);
    save tempout GID
case 'Tutorial'
    Task(4) = Menu_creation_gui('MenuType','Tutorial');
    if exist([pwd filesep 'tempout.mat'],'file')
      load tempout
    end
    GID.task(4) = Task(4);
    save tempout GID
case 'Examples'
    Task(5) = Menu_creation_gui('MenuType','Examples');
    if exist([pwd filesep 'tempout.mat'],'file')
      load tempout
    end    
    GID.task(5) = Task(5);
    save tempout GID
case 'Run'
    Task(6) = Menu_creation_gui('MenuType','Run');
    if exist([pwd filesep 'tempout.mat'],'file')
      load tempout
    end
    GID.task(6) = Task(6);
    save tempout GID
case 'Code'
    Task(7) = Menu_creation_gui('MenuType','Code');
    if exist([pwd filesep 'tempout.mat'],'file')
      load tempout
    end
    GID.task(7) = Task(7);
    save tempout GID
case 'Help'
    Task(8) = Menu_creation_gui('MenuType','Help');
    if exist([pwd filesep 'tempout.mat'],'file')
      load tempout
    end
    GID.task(8) = Task(8);
    save tempout GID
case 'All'
    for menu = 1:Nmenus
        Task(menu) = Menu_creation_gui('MenuType', MENUS{menu});
    end
    GID.task = Task;
    save tempout GID   % saves GID to mat-file
otherwise
    disp('Please select a valid menu task.')
    return
end  % switch

nm = 0;
menu_defined = cell(1,Nmenus);
for menu=1:length(GID.task)
    if GID.task(menu).name   
      nm = nm + 1;
      menu_defined(nm) = {GID.task(menu).name};
    end
end
a = [];
for menu=1:nm
  a = [a menu_defined{menu} ' '];
end
disp([num2str(nm) ' menu tasks defined:  ' a])

if nm < Nmenus
  b = myComplement(MENUS,menu_defined);
  c = [];
  for menu=1:Nmenus-nm
    c = [c b{menu} ' '];
  end
  disp([num2str(Nmenus-nm) ' menu tasks need be defined: ' c])
elseif nm == Nmenus
% The buildMainGUI builder needs fields label, type and ops
% The addLabel function will extract them from GID's string field
  GID = addLabel(GID);
  save main_inputfile GID;    % save completed menu data to main_inputfile.mat 
  create_main_inputfile(GID); % create main_inputfile.m
  disp(['All ' num2str(Nmenus) ' menu tasks have been completed'])
  disp('The GUI is now ready to be built . . . Press the "Build" button.')
  set(handles.pushbutton2,'Enable','On')
  delete tempout.mat
end

% --- Executes during object creation, after setting all properties.
function makeMenus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to makeMenus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function File_menu_Callback(hObject, eventdata, handles)
% hObject    handle to File_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_menu_item_Callback(hObject, eventdata, handles)
% hObject    handle to Save_menu_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_as_menu_item_Callback(hObject, eventdata, handles)
% hObject    handle to Save_as_menu_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Exit_menu_item_Callback(hObject, eventdata, handles)
% hObject    handle to Exit_menu_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function text1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GID = main_inputfile;  % bring in the newly defined menu data
buildMainGUI(GID)      % build main GUI
close all              % close this GUI window
