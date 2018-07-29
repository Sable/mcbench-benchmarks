function varargout = Bedienpult(varargin)
%BEDIENPULT M-file for Bedienpult.fig
%      BEDIENPULT, by itself, creates a new BEDIENPULT or raises the existing
%      singleton*.
%
%      H = BEDIENPULT returns the handle to a new BEDIENPULT or the handle to
%      the existing singleton*.
%
%      BEDIENPULT('Property','Value',...) creates a new BEDIENPULT using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to Bedienpult_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      BEDIENPULT('CALLBACK') and BEDIENPULT('CALLBACK',hObject,...) call the
%      local function named CALLBACK in BEDIENPULT.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Bedienpult

% Last Modified by GUIDE v2.5 18-Apr-2011 17:03:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Bedienpult_OpeningFcn, ...
                   'gui_OutputFcn',  @Bedienpult_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before Bedienpult is made visible.
function Bedienpult_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

  % ------------------------------------------------------------
  % If Cruise.mdl is not open: open it and bring GUI to front
  % Also set model parameters to match GUI settings
  % ------------------------------------------------------------

  model_open(handles)

% Choose default command line output for Bedienpult
handles.output = hObject;

% Set the sliders value to correspond the initial value
set(handles.AltitudeSlider,'Value',...
    str2double(get(handles.AltitudeCurrentValue,'String')))
set(handles.BearingSlider,'Value',...
    str2double(get(handles.BearingCurrentValue,'String')))
set(handles.CameraSlider,'Value',...
    str2double(get(handles.CameraCurrentValue,'String')))
set(handles.VelocitySlider,'Value',...
    str2double(get(handles.VelocityCurrentValue,'String')))

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Bedienpult wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Bedienpult_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%endfunction Bedienpult_OutputFcn

% ------------------------------------------------------------
% Ensure that the Simulink model is open
% ------------------------------------------------------------

function model_open(handles)
% Make sure the diagram is still open
if isempty(find_system('Name','Cruise')),
  % Open the model file 'EEG_BERT_FACE.mdl'
  open_system('Cruise');

  set_param('Cruise/Altitude','Value',...
      get(handles.AltitudeCurrentValue,'String'))
  set_param('Cruise/Azimuth', 'Value',...
      get(handles.CameraCurrentValue,'String'))
   set_param('Cruise/Bearing', 'Value',...
      get(handles.BearingCurrentValue,'String'))
   set_param('Cruise/Velocity', 'Value',...
      get(handles.VelocityCurrentValue,'String'))
  
end
%endfunction model_open

function AltitudeCurrentValue_Callback(hObject, eventdata, handles)
% hObject    handle to AltitudeCurrentValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AltitudeCurrentValue as text
%        str2double(get(hObject,'String')) returns contents of AltitudeCurrentValue as a double

% Ensure model is open
  model_open(handles)

% Get the new value for the Altitude value
  NewStrVal = get(hObject,'String');
  NewVal = str2double(NewStrVal);

% Check that the entered value falls within the allowable range
  if  isempty(NewVal) || (NewVal< 0),
    % Revert to last value, as indicated by AltitudeSlider
    OldVal = get(handles.AltitudeSlider,'Value');
    set(hObject,'String',OldVal)
  else
    % Set the value of the AltitudeSlider to the new value
    set(handles.AltitudeSlider,'Value',NewVal)
  
    % Set the Value parameter of the Altitude Constant Block to the 
    % new value
    set_param('Cruise/Altitude','Value',NewStrVal)
  end

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function AltitudeCurrentValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AltitudeCurrentValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on slider movement.
function AltitudeSlider_Callback(hObject, eventdata, handles)
% hObject    handle to AltitudeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% Ensure model is open
model_open(handles)

% Get the new value for the Altitude value from the slider
NewVal = get(hObject,'Value');

% Set the value of the AltitudeCurrentValue to the new value set by the
% slider
set(handles.AltitudeCurrentValue,'String',NewVal)

% Set the value of the Altitude Constant Block to the new value
set_param('Cruise/Altitude','Value',num2str(NewVal))

% --- Executes during object creation, after setting all properties.
function AltitudeSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AltitudeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in StartButton.
function StartButton_Callback(hObject, eventdata, handles)
% hObject    handle to StartButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Start Simulation
set_param('Cruise','SimulationCommand','start');




% --- Executes on button press in StopButton.
function StopButton_Callback(hObject, eventdata, handles)
% hObject    handle to StopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set_param('Cruise','SimulationCommand','stop');



function CameraCurrentValue_Callback(hObject, eventdata, handles)
% hObject    handle to CameraCurrentValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CameraCurrentValue as text
%        str2double(get(hObject,'String')) returns contents of CameraCurrentValue as a double
% Ensure model is open
  model_open(handles)

% Get the new value for the Altitude value
  NewStrVal = get(hObject,'String');
  NewVal = str2double(NewStrVal);

% Check that the entered value falls within the allowable range
  if  isempty(NewVal) || (NewVal< 0),
    % Revert to last value, as indicated by AltitudeSlider
    OldVal = get(handles.CameraSlider,'Value');
    set(hObject,'String',OldVal)
  else
    % Set the value of the AltitudeSlider to the new value
    set(handles.CameraSlider,'Value',NewVal)
  
    % Set the Value parameter of the Altitude Constant Block to the 
    % new value
    set_param('Cruise/Azimuth','Value',NewStrVal)
  end

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function CameraCurrentValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CameraCurrentValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function CameraSlider_Callback(hObject, eventdata, handles)
% hObject    handle to CameraSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Ensure model is open
model_open(handles)

% Get the new value for the Altitude value from the slider
NewVal = get(hObject,'Value');

% Set the value of the AltitudeCurrentValue to the new value set by the
% slider
set(handles.CameraCurrentValue,'String',NewVal)

% Set the value of the Altitude Constant Block to the new value
set_param('Cruise/Azimuth','Value',num2str(NewVal))


% --- Executes during object creation, after setting all properties.
function CameraSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CameraSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function BearingCurrentValue_Callback(hObject, eventdata, handles)
% hObject    handle to BearingCurrentValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BearingCurrentValue as text
%        str2double(get(hObject,'String')) returns contents of BearingCurrentValue as a double

% Ensure model is open
  model_open(handles)

% Get the new value for the Altitude value
  NewStrVal = get(hObject,'String');
  NewVal = str2double(NewStrVal);

% Check that the entered value falls within the allowable range
  if  isempty(NewVal) || (NewVal< 0) || (NewVal>360),
    % Revert to last value, as indicated by AltitudeSlider
    OldVal = get(handles.BearingSlider,'Value');
    set(hObject,'String',OldVal)
  else
    % Set the value of the AltitudeSlider to the new value
    set(handles.BearingSlider,'Value',NewVal)
  
    % Set the Value parameter of the Altitude Constant Block to the 
    % new value
    set_param('Cruise/Bearing','Value',NewStrVal)
    
    % Set the value for Camera to the same value as Bearing
    set_param('Cruise/Azimuth','Value',NewStrVal)
    set(handles.CameraCurrentValue,'String',NewStrVal)
  end

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function BearingCurrentValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BearingCurrentValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function BearingSlider_Callback(hObject, eventdata, handles)
% hObject    handle to BearingSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
model_open(handles)

% Get the new value for the Altitude value from the slider
NewVal = get(hObject,'Value');

% Set the value of the AltitudeCurrentValue to the new value set by the
% slider
set(handles.BearingCurrentValue,'String',NewVal)

% Set the value of the Altitude Constant Block to the new value
set_param('Cruise/Bearing','Value',num2str(NewVal))
set_param('Cruise/Azimuth','Value',num2str(NewVal))
set(handles.CameraCurrentValue,'String',num2str(NewVal))
set(handles.CameraSlider,'Value',NewVal)

% --- Executes during object creation, after setting all properties.
function BearingSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BearingSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function VelocityCurrentValue_Callback(hObject, eventdata, handles)
% hObject    handle to VelocityCurrentValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VelocityCurrentValue as text
%        str2double(get(hObject,'String')) returns contents of VelocityCurrentValue as a double
% Ensure model is open
  model_open(handles)

% Get the new value for the Altitude value
  NewStrVal = get(hObject,'String');
  NewVal = str2double(NewStrVal);

% Check that the entered value falls within the allowable range
  if  isempty(NewVal) || (NewVal< 0) || (NewVal>360),
    % Revert to last value, as indicated by AltitudeSlider
    OldVal = get(handles.VelocitySlider,'Value');
    set(hObject,'String',OldVal)
  else
    % Set the value of the AltitudeSlider to the new value
    set(handles.VelocitySlider,'Value',NewVal)
  
    % Set the Value parameter of the Altitude Constant Block to the 
    % new value
    set_param('Cruise/Velocity','Value',NewStrVal)
    
    % Set the value for Camera to the same value as Bearing
    set_param('Cruise/Velocity','Value',NewStrVal)
    set(handles.VelocityCurrentValue,'String',NewStrVal)
  end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function VelocityCurrentValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VelocityCurrentValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function VelocitySlider_Callback(hObject, eventdata, handles)
% hObject    handle to VelocitySlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
model_open(handles)

% Get the new value for the Altitude value from the slider
NewVal = get(hObject,'Value');

% Set the value of the AltitudeCurrentValue to the new value set by the
% slider
set(handles.VelocityCurrentValue,'String',NewVal)

% Set the value of the Altitude Constant Block to the new value
set_param('Cruise/Velocity','Value',num2str(NewVal))
set(handles.VelocitySlider,'Value',NewVal)

% --- Executes during object creation, after setting all properties.
function VelocitySlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VelocitySlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in ResetCameraToBearing.
function ResetCameraToBearing_Callback(hObject, eventdata, handles)
% hObject    handle to ResetCameraToBearing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get the value from Bearing
    NewStrVal = get(handles.BearingCurrentValue,'String');

 % Set the value for Camera to the same value as Bearing
    set_param('Cruise/Azimuth','Value',NewStrVal)
    set(handles.CameraCurrentValue,'String',NewStrVal)



function TiltCurrentValue_Callback(hObject, eventdata, handles)
% hObject    handle to TiltCurrentValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TiltCurrentValue as text
%        str2double(get(hObject,'String')) returns contents of TiltCurrentValue as a double
  model_open(handles)

% Get the new value for the Altitude value
  NewStrVal = get(hObject,'String');
  NewVal = str2double(NewStrVal);

% Check that the entered value falls within the allowable range
  if  isempty(NewVal) || (NewVal< 0) || (NewVal>360),
    % Revert to last value, as indicated by AltitudeSlider
    OldVal = get(handles.TiltSlider,'Value');
    set(hObject,'String',OldVal)
  else
    % Set the value of the AltitudeSlider to the new value
    set(handles.TiltSlider,'Value',NewVal)
  
    % Set the Value parameter of the Altitude Constant Block to the 
    % new value
    set_param('Cruise/Tilt','Value',NewStrVal)
    
    set(handles.TiltCurrentValue,'String',NewStrVal)
  end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function TiltCurrentValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TiltCurrentValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function TiltSlider_Callback(hObject, eventdata, handles)
% hObject    handle to TiltSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
model_open(handles)

% Get the new value for the Altitude value from the slider
NewVal = get(hObject,'Value');

% Set the value of the AltitudeCurrentValue to the new value set by the
% slider
set(handles.TiltCurrentValue,'String',NewVal)

% Set the value of the Altitude Constant Block to the new value
set_param('Cruise/Tilt','Value',num2str(NewVal))
set(handles.TiltSlider,'Value',NewVal)

% --- Executes during object creation, after setting all properties.
function TiltSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TiltSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
