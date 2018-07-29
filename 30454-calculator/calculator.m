function varargout = calculator(varargin)
% CALCULATOR M-file for calculator.fig
%      CALCULATOR, by itself, creates a new CALCULATOR or raises the existing
%      singleton*.
%
%      H = CALCULATOR returns the handle to a new CALCULATOR or the handle to
%      the existing singleton*.
%
%      CALCULATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALCULATOR.M with the given input arguments.
%
%      CALCULATOR('Property','Value',...) creates a new CALCULATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before calculator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to calculator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help calculator

% Last Modified by GUIDE v2.5 18-Feb-2011 17:46:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @calculator_OpeningFcn, ...
                   'gui_OutputFcn',  @calculator_OutputFcn, ...
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


% --- Executes just before calculator is made visible.
function calculator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to calculator (see VARARGIN)

% Choose default command line output for calculator
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

date1 = date;
set(handles.date1, 'String', date);
initialize_gui(hObject, handles, false);

% UIWAIT makes calculator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = calculator_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function numbera_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numbera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numbera_Callback(hObject, eventdata, handles)
% hObject    handle to numbera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numbera as text
%        str2double(get(hObject,'String')) returns contents of numbera as a double

numbera = str2double(get(hObject, 'String'));
if isnan(numbera)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new density value
handles.metricdata.numbera = numbera;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function numberb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numberb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function numberb_Callback(hObject, eventdata, handles)
% hObject    handle to numberb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numberb as text
%        str2double(get(hObject,'String')) returns contents of numberb as a double

numberb = str2double(get(hObject, 'String'));
if isnan(numberb)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new density value
handles.metricdata.numberb = numberb;
guidata(hObject,handles)


% --- Executes on button press in add.
function add_Callback(hObject, eventdata, handles)
% hObject    handle to add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

result = handles.metricdata.numbera + handles.metricdata.numberb;
set(handles.result, 'String', result)


% --- Executes on button press in substract.
function substract_Callback(hObject, eventdata, handles)
% hObject    handle to substract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

result = handles.metricdata.numbera - handles.metricdata.numberb;
set(handles.result, 'String', result)


% --- Executes on button press in divide.
function divide_Callback(hObject, eventdata, handles)
% hObject    handle to divide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

result = handles.metricdata.numbera / handles.metricdata.numberb;
set(handles.result, 'String', result)


% --- Executes on button press in multiply.
function multiply_Callback(hObject, eventdata, handles)
% hObject    handle to multiply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

result = handles.metricdata.numbera * handles.metricdata.numberb;
set(handles.result, 'String', result)


% --- Executes on button press in natlog.
function natlog_Callback(hObject, eventdata, handles)
% hObject    handle to natlog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

result = (log(handles.metricdata.numbera));
set(handles.result, 'String', result)


% --- Executes on button press in inverse.
function inverse_Callback(hObject, eventdata, handles)
% hObject    handle to inverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

result = (1 / handles.metricdata.numbera);
set(handles.result, 'String', result)


% --- Executes on button press in cube.
function cube_Callback(hObject, eventdata, handles)
% hObject    handle to cube (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

result = (handles.metricdata.numbera)^3;
set(handles.result, 'String', result)

% --- Executes on button press in powerb.
function powerb_Callback(hObject, eventdata, handles)
% hObject    handle to powerb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

result = (handles.metricdata.numbera)^(handles.metricdata.numberb);
set(handles.result, 'String', result)


% --- Executes on button press in sqrt.
function sqrt_Callback(hObject, eventdata, handles)
% hObject    handle to sqrt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

result = (sqrt(handles.metricdata.numbera));
set(handles.result, 'String', result)


% --- Executes on button press in logarithm.
function logarithm_Callback(hObject, eventdata, handles)
% hObject    handle to logarithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

result = log10(handles.metricdata.numbera);
set(handles.result, 'String', result)

% --- Executes on button press in broot.
function broot_Callback(hObject, eventdata, handles)
% hObject    handle to broot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

result = (handles.metricdata.numbera)^(1 /handles.metricdata.numberb);
set(handles.result, 'String', result)


% --- Executes on button press in factorial.
function factorial_Callback(hObject, eventdata, handles)
% hObject    handle to factorial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

N = 1;
for n = 1:1:handles.metricdata.numbera
    N = N.*n;
end
result = N;
set(handles.result, 'String', result)



% --- Executes on button press in square.
function square_Callback(hObject, eventdata, handles)
% hObject    handle to square (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

result = (handles.metricdata.numbera)^(2);
set(handles.result, 'String', result)


% --- Executes on button press in pushbutton30.
function pushbutton30_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initialize_gui(gcbf, handles, true);


function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end

handles.metricdata.numbera = 0;
handles.metricdata.numberb  = 0;

set(handles.numbera, 'String', handles.metricdata.numbera);
set(handles.numberb,  'String', handles.metricdata.numberb);
set(handles.result, 'String', 0);
set(handles.date1, 'String', date);

% Update handles structure
guidata(handles.figure1, handles);



function result_Callback(hObject, eventdata, handles)
% hObject    handle to result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of result as text
%        str2double(get(hObject,'String')) returns contents of result as a double


% --- Executes during object creation, after setting all properties.
function result_CreateFcn(hObject, eventdata, handles)
% hObject    handle to result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
