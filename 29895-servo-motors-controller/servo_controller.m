function varargout = servo_controller(varargin)
% It's a servo controller for six servo motors. It can be used to control a
% antropomorphic arm with six motors. For a correct execution, it must select
% the motors following this table:
%       #servo_motor  ------------  char to use for the motor selection
%       1                           a
%       2                           b
%       3                           c
%       4                           d
%       5                           e
%       6                           f
%
% SERVO_CONTROLLER MATLAB code for servo_controller.fig
%      SERVO_CONTROLLER, by itself, creates a new SERVO_CONTROLLER or raises the existing
%      singleton*.
%
%      H = SERVO_CONTROLLER returns the handle to a new SERVO_CONTROLLER or the handle to
%      the existing singleton*.
%
%      SERVO_CONTROLLER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SERVO_CONTROLLER.M with the given input arguments.
%
%      SERVO_CONTROLLER('Property','Value',...) creates a new SERVO_CONTROLLER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before servo_controller_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to servo_controller_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help servo_controller

% Last Modified by GUIDE v2.5 01-Jan-2011 23:06:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @servo_controller_OpeningFcn, ...
                   'gui_OutputFcn',  @servo_controller_OutputFcn, ...
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


% --- Executes just before servo_controller is made visible.
function servo_controller_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to servo_controller (see VARARGIN)
serialInfo = instrhwinfo('serial');     % Finds available COM ports
for k=1:length(serialInfo.AvailableSerialPorts)
    s_port(k)=serialInfo.AvailableSerialPorts(k);   % Saves in a vector the available COM ports
end
set(handles.comPort,'String',s_port);   % Writes in a popupmenu the s_port elements
set(handles.servo1,'Enable','off');     % Disables the servos' controller
set(handles.servo2,'Enable','off');
set(handles.servo3,'Enable','off');
set(handles.servo4,'Enable','off');
set(handles.servo5,'Enable','off');
set(handles.servo6,'Enable','off');
set(handles.servo1,'Value',127);        % Sets the initial conditions for the controller
set(handles.servo2,'Value',127);
set(handles.servo3,'Value',127);
set(handles.servo4,'Value',127);
set(handles.servo5,'Value',127);
set(handles.servo6,'Value',127);
clc; disp('Program in execution.');

% Choose default command line output for servo_controller
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes servo_controller wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = servo_controller_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on slider movement.
function servo1_Callback(hObject, eventdata, handles)
% hObject    handle to servo1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.servo1,'Enable','inactive')     % Disables the slider during the operations
val1=round(get(handles.servo1,'Value'));    % val# is the slider's value
set(handles.pos1,'String',val1);            % Shows the slider's value in a Static Text
g1 = (val1 * (180/255) - 90);               % Calculates the motor's position in degrees
set(handles.deg1,'String',round(g1));       % Shows the position in a Static Text
fwrite(handles.s,'a');               % Sends on the Com port the char for the motor's selection
fwrite(handles.s,val1);               % Sends the value for the motor's position to the microcontroller
pause(0.5)              
set(handles.servo1,'Enable','on')           % Enables the slider after the operations

% --- Executes during object creation, after setting all properties.
function servo1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to servo1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function servo2_Callback(hObject, eventdata, handles)
% hObject    handle to servo2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.servo2,'Enable','inactive')     % Disables the slider during the operations
val2=round(get(hObject,'Value'));           % val# is the slider's value
set(handles.pos2,'String',val2);            % Shows the slider's value in a Static Text
g2 = (val2 * (180/255) - 90);               % Calculates the motor's position in degrees
set(handles.deg2,'String',round(g2));       % Shows the position in a Static Text
fwrite(handles.s,'b');      % Sends on the Com port the char for the motor's selection
fwrite(handles.s,val2);     % Sends the value for the motor's position to the microcontroller
pause(0.5)
set(handles.servo2,'Enable','on')           % Enables the slider after the operations


% --- Executes during object creation, after setting all properties.
function servo2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to servo2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function servo3_Callback(hObject, eventdata, handles)
% hObject    handle to servo3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.servo3,'Enable','inactive')     % Disables the slider during the operations
val3=round(get(hObject,'Value'));           % val# is the slider's value
set(handles.pos3,'String',val3);            % Shows the slider's value in a Static Text
g3 = (val3 * (180/255) - 90);               % Calculates the motor's position in degrees
set(handles.deg3,'String',round(g3));       % Shows the position in a Static Text
fwrite(handles.s,'c');                % Sends on the Com port the char for the motor's selection
fwrite(handles.s,val3);               % Sends the value for the motor's position to the microcontroller   
pause(0.5)
set(handles.servo3,'Enable','on')           % Enables the slider after the operations

% --- Executes during object creation, after setting all properties.
function servo3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to servo3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function servo4_Callback(hObject, eventdata, handles)
% hObject    handle to servo4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.servo4,'Enable','inactive')     % Disables the slider during the operations
val4=round(get(hObject,'Value'));           % val# is the slider's value
set(handles.pos4,'String',val4);            % Shows the slider's value in a Static Text           
g4 = (val4 * (180/255) - 90);               % Calculates the motor's position in degrees
set(handles.deg4,'String',round(g4));       % Shows the position in a Static Text
fwrite(handles.s,'d');                % Sends on the Com port the char for the motor's selection
fwrite(handles.s,val4);               % Sends the value for the motor's position to the microcontroller  
pause(0.5)
set(handles.servo4,'Enable','on')           % Enables the slider after the operations

% --- Executes during object creation, after setting all properties.
function servo4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to servo4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function servo5_Callback(hObject, eventdata, handles)
% hObject    handle to servo5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.servo5,'Enable','inactive')     % Disables the slider during the operations
val5=round(get(hObject,'Value'));           % val# is the slider's value
set(handles.pos5,'String',val5);            % Shows the slider's value in a Static Text  
g5 = (val5 * (180/255) - 90);               % Calculates the motor's position in degrees
set(handles.deg5,'String',round(g5));       % Shows the position in a Static Text
fwrite(handles.s,'e');                % Sends on the Com port the char for the motor's selection
fwrite(handles.s,val5);               % Sends the value for the motor's position to the microcontroller  
pause(0.5)
set(handles.servo5,'Enable','on')           % Enables the slider after the operations

% --- Executes during object creation, after setting all properties.
function servo5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to servo5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function servo6_Callback(hObject, eventdata, handles)
% hObject    handle to servo6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.servo6,'Enable','inactive')     % Disables the slider during the operations
val6=round(get(hObject,'Value'));           % val# is the slider's value
set(handles.pos6,'String',val6);            % Shows the slider's value in a Static Text  
g6 = (val6 * (180/255) - 90);               % Calculates the motor's position in degrees
set(handles.deg6,'String',round(g6));       % Shows the position in a Static Text
fwrite(handles.s,'f');                % Sends on the Com port the char for the motor's selection
fwrite(handles.s,val6);         % Sends the value for the motor's position to the microcontroller  
pause(0.5)
set(handles.servo6,'Enable','on')           % Enables the slider after the operations

% --- Executes during object creation, after setting all properties.
function servo6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to servo6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in comPort.
function comPort_Callback(hObject, eventdata, handles)
% hObject    handle to comPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns comPort contents as cell array
%        contents{get(hObject,'Value')} returns selected item from comPort


% --- Executes during object creation, after setting all properties.
function comPort_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton1,'Enable','off');     % Disables the 'Connect' button
set(handles.pushbutton2,'Enable','on');      % Actives the 'Disconnect' button
set(handles.servo1,'Enable','on');           % Enables the motor's sliders
set(handles.servo2,'Enable','on');
set(handles.servo3,'Enable','on');
set(handles.servo4,'Enable','on');
set(handles.servo5,'Enable','on');
set(handles.servo6,'Enable','on');
n_port=get(handles.comPort,'Value');        % Gets the selected COM port's name 
port=get(handles.comPort,'String');
handles.s=serial(port{n_port});             % Creates a COM port object
disp('The selected COM port is:')
disp(port{n_port})
set(handles.s,'BaudRate',115200);           % Sets the COM port's Baud Rate
set(handles.s,'DataBits',8);                % Sets the number of bits for the communication
set(handles.s,'Parity','none');             % Disables the parity bit
set(handles.s,'StopBits',1);                % Sets one stop-bit
set(handles.s,'FlowControl','none');        
fopen(handles.s);                           % Opens the COM port
guidata(hObject, handles);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton1.
function pushbutton1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton1,'Enable','on');     % Enables the 'Connect' button
set(handles.pushbutton2,'Enable','off');    % Disables the 'Disconnect' button
set(handles.servo1,'Enable','off');         % Disables the motor's sliders
set(handles.servo2,'Enable','off');
set(handles.servo3,'Enable','off');
set(handles.servo4,'Enable','off');
set(handles.servo5,'Enable','off');
set(handles.servo6,'Enable','off');
s_close=handles.s;
fclose(s_close);


% --------------------------------------------------------------------
function Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try    
    s_close=handles.s;     % Disconnects the COM port and closes the GUI
    delete(s_close);    
end
close servo_controller
disp('Program terminated')


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
