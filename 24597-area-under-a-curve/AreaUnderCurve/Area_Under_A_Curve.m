function varargout = Area_Under_A_Curve(varargin)
% AREA_UNDER_A_CURVE M-file for Area_Under_A_Curve.fig
%      AREA_UNDER_A_CURVE, by itself, creates a new AREA_UNDER_A_CURVE or raises the existing
%      singleton*.
%
%      H = AREA_UNDER_A_CURVE returns the handle to a new AREA_UNDER_A_CURVE or the handle to
%      the existing singleton*.
%
%      AREA_UNDER_A_CURVE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AREA_UNDER_A_CURVE.M with the given input arguments.
%
%      AREA_UNDER_A_CURVE('Property','Value',...) creates a new AREA_UNDER_A_CURVE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Area_Under_A_Curve_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Area_Under_A_Curve_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Area_Under_A_Curve

% Last Modified by GUIDE v2.5 14-Aug-2008 18:23:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Area_Under_A_Curve_OpeningFcn, ...
                   'gui_OutputFcn',  @Area_Under_A_Curve_OutputFcn, ...
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


% --- Executes just before Area_Under_A_Curve is made visible.
function Area_Under_A_Curve_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Area_Under_A_Curve (see VARARGIN)

% Choose default commansd line output for Area_Under_A_Curve
handles.output = hObject;

% Initialize the GUI
InitGUI(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Area_Under_A_Curve wait for user response (see UIRESUME)
% uiwait(handles.MainFigure);


% --- Outputs from this function are returned to the command line.
function varargout = Area_Under_A_Curve_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function lowerLimitEdit_Callback(hObject, eventdata, handles)
% hObject    handle to lowerLimitEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lowerLimitEdit as text
%        str2double(get(hObject,'String')) returns contents of lowerLimitEdit as a double
hFigure = handles.MainFigure;

% Get some appdata
integLimits = getappdata(hFigure, 'IntegrationLimits');    % [xmin xmax]
deltaX = getappdata(hFigure, 'DeltaX');

% Get the lower limit of integration
xminStr = get(hObject,'String');

% Check whether the entered value is a number or not 
if isempty(str2num(xminStr)), 

    % Refresh the GUI
    RefreshGUI(handles);
    
    % Highlight the current edit box
    uicontrol(hObject) % set the focus on hObject
    
    % And display a warning
    warndlg('Lower limit of integration should be numeric. Please enter a number.');    
else

    % Check whether the Upper limit is greater than lower limit or 
    if str2num(xminStr) >= integLimits(2)
        % Refresh the GUI
        RefreshGUI(handles);

        % Highlight the current edit box
        uicontrol(hObject) % set the focus on hObject

        % And display a warning
        warndlg('Lower limit of integration should be < Upper limit of integration.');    
    else
        integLimits(1) = str2num(xminStr);
        if (integLimits(2) == 0)
            if (deltaX >= abs(integLimits(2)-integLimits(1))/10)
                deltaX = abs(integLimits(2)-integLimits(1))/10;
            end
        else
            if (deltaX >= abs(integLimits(2)/10))
                deltaX = abs(integLimits(2)/10);
            end
        end
        
        % Set some appdatas 
        setappdata(hFigure, 'IntegrationLimits', integLimits);   % [xmin xmax]
        setappdata(hFigure, 'DeltaX', deltaX);
        
        % Update the GUI
        UpdateGUI(handles);
    end
end


% --- Executes during object creation, after setting all properties.
function lowerLimitEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lowerLimitEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function upperLimitEdit_Callback(hObject, eventdata, handles)
% hObject    handle to upperLimitEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of upperLimitEdit as text
%        str2double(get(hObject,'String')) returns contents of upperLimitEdit as a double
hFigure = handles.MainFigure;

% Get some appdata
integLimits = getappdata(hFigure, 'IntegrationLimits');    % [xmin xmax]
deltaX = getappdata(hFigure, 'DeltaX');

% Get the upper limit of integration
xmaxStr = get(hObject,'String');

% Check whether the entered value is a number or not 
if isempty(str2num(xmaxStr)), 

    % Refresh the GUI
    RefreshGUI(handles);
    
    % Highlight the current edit box
    uicontrol(hObject) % set the focus on hObject

    % And display a warning
    warndlg('Upper limit of integration should be numeric. Please enter a number.');    
else

    % Check whether the Upper limit is greater than lower limit or 
    if str2num(xmaxStr) <= integLimits(1)-1
        % Refresh the GUI
        RefreshGUI(handles);

        % Highlight the current edit box
        uicontrol(hObject) % set the focus on hObject
        
        % And display a warning
        warndlg('Upper limit of integration should be > Lower limit of integration.');    
    else
        integLimits(2) = str2num(xmaxStr);
        if (integLimits(2) == 0)
            if (deltaX >= abs(integLimits(2)-integLimits(1))/10)
                deltaX = abs(integLimits(2)-integLimits(1))/10;
            end
        else
            if (deltaX >= abs(integLimits(2)/10))
                deltaX = abs(integLimits(2)/10);
            end
        end

        % Set some appdatas
        setappdata(hFigure, 'IntegrationLimits', integLimits);   % [xmin xmax]
        setappdata(hFigure, 'DeltaX', deltaX);
        
        % Update the GUI
        UpdateGUI(handles);
    end
end


% --- Executes during object creation, after setting all properties.
function upperLimitEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upperLimitEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in degreeOfPolyPopupmenu.
function degreeOfPolyPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to degreeOfPolyPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns degreeOfPolyPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from degreeOfPolyPopupmenu
%Get the handle to the main GUI
hFigure = handles.MainFigure;

% Get the Selected Port
SelectedDOP = get(hObject,'value');

% Set some appdatas
setappdata(hFigure, 'SelectedDegreeOfPoly', SelectedDOP);

% Refresh the GUI
RefreshGUI(handles);


% --- Executes during object creation, after setting all properties.
function degreeOfPolyPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to degreeOfPolyPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a0Edit_Callback(hObject, eventdata, handles)
% hObject    handle to a0Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a0Edit as text
%        str2double(get(hObject,'String')) returns contents of a0Edit as a double
%Get the handle to the main GUI
hFigure = handles.MainFigure;

% Get some appdata
Coefficients = getappdata(hFigure, 'CoefficientsArray');  % [a0 a1 a2 a3 a4 a5]

% Get the a0 coefficeint string
a0Str = get(hObject,'String');

% Check whether the entered value is a number or not
if isempty(str2num(a0Str)), 

    % Refresh the GUI
    RefreshGUI(handles);
    
    % Highlight the current edit box
    uicontrol(hObject) % set the focus on hObject

    % And display a warning
    warndlg('Coefficent a0 should be numeric. Please enter a number between -10 and 10.'); 
    
elseif (str2num(a0Str) < -10 || str2num(a0Str) > 10) 
    % Refresh the GUI
    RefreshGUI(handles);
    
    % Highlight the current edit box
    uicontrol(hObject) % set the focus on hObject

    % And display a warning
    warndlg('Coefficent a0 should lie between -10 and 10.'); 
    
else
    Coefficients(1) = str2num(a0Str);

    % Set some appdatas 
    setappdata(hFigure, 'CoefficientsArray', Coefficients);   % [a0 a1 a2 a3 a4 a5]

    % Update the GUI
    UpdateGUI(handles);
end


% --- Executes during object creation, after setting all properties.
function a0Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a0Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a1Edit_Callback(hObject, eventdata, handles)
% hObject    handle to a1Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a1Edit as text
%        str2double(get(hObject,'String')) returns contents of a1Edit as a double
%Get the handle to the main GUI
hFigure = handles.MainFigure;

% Get some appdata
Coefficients = getappdata(hFigure, 'CoefficientsArray');  % [a0 a1 a2 a3 a4 a5]

% Get the a1 coefficient string
a1Str = get(hObject,'String');

% Check whether the entered value is a number or not
if isempty(str2num(a1Str)), 

    % Refresh the GUI
    RefreshGUI(handles);
    
    % Highlight the current edit box
    uicontrol(hObject) % set the focus on hObject

    % And display a warning
    warndlg('Coefficent a1 should be numeric. Please enter a number.');  

elseif (str2num(a1Str) < -10 || str2num(a1Str) > 10) 
    % Refresh the GUI
    RefreshGUI(handles);
    
    % Highlight the current edit box
    uicontrol(hObject) % set the focus on hObject

    % And display a warning
    warndlg('Coefficent a1 should lie between -10 and 10.'); 

else

    Coefficients(2) = str2num(a1Str);

    % Set some appdatas 
    setappdata(hFigure, 'CoefficientsArray', Coefficients);   % [a0 a1 a2 a3 a4 a5]

    % Update the GUI
    UpdateGUI(handles);
end


% --- Executes during object creation, after setting all properties.
function a1Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a1Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a2Edit_Callback(hObject, eventdata, handles)
% hObject    handle to a2Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a2Edit as text
%        str2double(get(hObject,'String')) returns contents of a2Edit as a double
%Get the handle to the main GUI
hFigure = handles.MainFigure;

% Get some appdata
Coefficients = getappdata(hFigure, 'CoefficientsArray');  % [a0 a1 a2 a3 a4 a5]

% Get the a2 coefficient string
a2Str = get(hObject,'String');

% Check whether the entered value is a number or not
if isempty(str2num(a2Str)), 

    % Refresh the GUI
    RefreshGUI(handles);
    
    % Highlight the current edit box
    uicontrol(hObject) % set the focus on hObject

    % And display a warning
    warndlg('Coefficent a2 should be numeric. Please enter a number.'); 

elseif (str2num(a2Str) < -10 || str2num(a2Str) > 10) 
    % Refresh the GUI
    RefreshGUI(handles);
    
    % Highlight the current edit box
    uicontrol(hObject) % set the focus on hObject

    % And display a warning
    warndlg('Coefficent a2 should lie between -10 and 10.'); 
    
else

    Coefficients(3) = str2num(a2Str);

    % Set some appdatas 
    setappdata(hFigure, 'CoefficientsArray', Coefficients);   % [a0 a1 a2 a3 a4 a5]

    % Update the GUI
    UpdateGUI(handles);
end


% --- Executes during object creation, after setting all properties.
function a2Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a2Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a3Edit_Callback(hObject, eventdata, handles)
% hObject    handle to a3Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a3Edit as text
%        str2double(get(hObject,'String')) returns contents of a3Edit as a double
%Get the handle to the main GUI
hFigure = handles.MainFigure;

% Get some appdata
Coefficients = getappdata(hFigure, 'CoefficientsArray');  % [a0 a1 a2 a3 a4 a5]

% Get the a3 coefficient string
a3Str = get(hObject,'String');

% Check whether the entered value is a number or not
if isempty(str2num(a3Str)), 

    % Refresh the GUI
    RefreshGUI(handles);
    
    % Highlight the current edit box
    uicontrol(hObject) % set the focus on hObject
    
    % And display a warning
    warndlg('Coefficent a3 should be numeric. Please enter a number.'); 

elseif (str2num(a3Str) < -10 || str2num(a3Str) > 10) 
    % Refresh the GUI
    RefreshGUI(handles);
    
    % Highlight the current edit box
    uicontrol(hObject) % set the focus on hObject

    % And display a warning
    warndlg('Coefficent a3 should lie between -10 and 10.'); 
    
else
    Coefficients(4) = str2num(a3Str);

    % Set some appdatas 
    setappdata(hFigure, 'CoefficientsArray', Coefficients);   % [a0 a1 a2 a3 a4 a5]

    % Update the GUI
    UpdateGUI(handles);
end


% --- Executes during object creation, after setting all properties.
function a3Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a3Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a4Edit_Callback(hObject, eventdata, handles)
% hObject    handle to a4Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a4Edit as text
%        str2double(get(hObject,'String')) returns contents of a4Edit as a double
%Get the handle to the main GUI
hFigure = handles.MainFigure;

% Get some appdata
Coefficients = getappdata(hFigure, 'CoefficientsArray');  % [a0 a1 a2 a3 a4 a5]

% Get the a4 coefficient string
a4Str = get(hObject,'String');

% Check whether the entered value is a number or not
if isempty(str2num(a4Str)), 

    % Refresh the GUI
    RefreshGUI(handles);
    
    % Highlight the current edit box
    uicontrol(hObject) % set the focus on hObject
    
    % And display a warning
    warndlg('Coefficent a4 should be numeric. Please enter a number.'); 
    
elseif (str2num(a4Str) < -10 || str2num(a4Str) > 10) 
    % Refresh the GUI
    RefreshGUI(handles);
    
    % Highlight the current edit box
    uicontrol(hObject) % set the focus on hObject

    % And display a warning
    warndlg('Coefficent a4 should lie between -10 and 10.'); 
    
else

    Coefficients(5) = str2num(a4Str);

    % Set some appdatas 
    setappdata(hFigure, 'CoefficientsArray', Coefficients);   % [a0 a1 a2 a3 a4 a5]

    % Update the GUI
    UpdateGUI(handles);
end


% --- Executes during object creation, after setting all properties.
function a4Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a4Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a5Edit_Callback(hObject, eventdata, handles)
% hObject    handle to a5Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a5Edit as text
%        str2double(get(hObject,'String')) returns contents of a5Edit as a double
%Get the handle to the main GUI
hFigure = handles.MainFigure;

% Get some appdata
Coefficients = getappdata(hFigure, 'CoefficientsArray');  % [a0 a1 a2 a3 a4 a5]

% Get the a5 coefficient string
a5Str = get(hObject,'String');

% Check whether the entered value is a number or not
if isempty(str2num(a5Str)), 

    % Refresh the GUI
    RefreshGUI(handles);

    % Highlight the current edit box
    uicontrol(hObject) % set the focus on hObject

    % And display a warning
    warndlg('Coefficent a5 should be numeric. Please enter a number.');   

elseif (str2num(a5Str) < -10 || str2num(a5Str) > 10) 
    % Refresh the GUI
    RefreshGUI(handles);
    
    % Highlight the current edit box
    uicontrol(hObject) % set the focus on hObject

    % And display a warning
    warndlg('Coefficent a5 should lie between -10 and 10.');     
    
else

    Coefficients(6) = str2num(a5Str);

    % Set some appdatas 
    setappdata(hFigure, 'CoefficientsArray', Coefficients);   % [a0 a1 a2 a3 a4 a5]

    % Update the GUI
    UpdateGUI(handles);
end


% --- Executes during object creation, after setting all properties.
function a5Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a5Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in helpPushbutton.
function helpPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to helpPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

eval_str=['if exist(which(''AreaUnderACurve_Help.html'')),',... 
' web([''file:///'' which(''AreaUnderACurve_Help.html'')]),',... 
' else errordlg(''Cannot find Help document. Make sure the directory', ...
' containing the Help file AreaUnderACurve_Help.html is' ...
' part of your MATLAB path.'',''Error''), end'];
eval(eval_str);


% --- Executes on slider movement.
function deltaXSlider_Callback(hObject, eventdata, handles)
% hObject    handle to deltaXSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%Get the handle to the main GUI
hFigure = handles.MainFigure;

% Get the deltaX
deltaX = get(hObject,'Value');

% Set some appdatas 
setappdata(hFigure, 'DeltaX', deltaX);

% Update the GUI
UpdateGUI(handles);
        
% --- Executes during object creation, after setting all properties.
function deltaXSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltaXSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in showCodePushbutton.
function showCodePushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to showCodePushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Files in ...\VPx2008\matlab\src\playbacktool
areaUnderACurve_mfiles = {...
    'InitGUI'
    'RefreshGUI'
    'plotApproxAreaUnderACurve'
    'plotAreaUnderACurve'
    'UpdateGUI'
    'Area_Under_A_Curve'};
cellfun(@edit,areaUnderACurve_mfiles,'UniformOutput',false);


% --- Executes on button press in closePushbutton.
function closePushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to closePushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hFigure = handles.MainFigure;
close(hFigure);

% --- Executes on button press in exampleRadiobutton.
function exampleRadiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to exampleRadiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of exampleRadiobutton
%Get the handle to the main GUI
hFigure = handles.MainFigure;

% Get the Selected Port
exampleRadioBtnVal = get(hObject,'value');

% Set some appdatas
if exampleRadioBtnVal == 1
    setappdata(hFigure, 'SelectedTypeofCurve', 'Example');
else
    setappdata(hFigure, 'SelectedTypeofCurve', 'Custom');
end

% Refresh the GUI
RefreshGUI(handles);


% --- Executes on button press in customRadiobutton.
function customRadiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to customRadiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of customRadiobutton
%Get the handle to the main GUI
hFigure = handles.MainFigure;

% Get the Selected Port
customRadioBtnVal = get(hObject,'value');

% Set some appdatas
if customRadioBtnVal == 1
    setappdata(hFigure, 'SelectedTypeofCurve', 'Custom');
else
    setappdata(hFigure, 'SelectedTypeofCurve', 'Example');
end

% Refresh the GUI
RefreshGUI(handles);



function deltaXEdit_Callback(hObject, eventdata, handles)
% hObject    handle to deltaXEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltaXEdit as text
%        str2double(get(hObject,'String')) returns contents of deltaXEdit as a double
hFigure = handles.MainFigure;

% Get some appdata
integLimits = getappdata(hFigure, 'IntegrationLimits');    % [xmin xmax]

% Get delta X
deltaXStr = get(hObject,'String');

% Check whether the entered value is a number or not 
if isempty(str2num(deltaXStr)), 

    % Refresh the GUI
    RefreshGUI(handles);
    
    % And display a warning
    warndlg('Width of rectangle should be numeric. Please enter a number.');    
    
elseif (str2num(deltaXStr) > (integLimits(2)/10) || ...
        str2num(deltaXStr) < 0.01)
    % Refresh the GUI
    RefreshGUI(handles);
    
    % Highlight the current edit box
    uicontrol(hObject) % set the focus on hObject
    
    % And display a warning
    warndlg('Width of rectangle does not lie within the slider limits.');   

else
    % Set some appdatas 
    setappdata(hFigure, 'DeltaX', str2num(deltaXStr));

    % Update the GUI
    UpdateGUI(handles);
end

% --- Executes during object creation, after setting all properties.
function deltaXEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltaXEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function a0Slider_Callback(hObject, eventdata, handles)
% hObject    handle to a0Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%Get the handle to the main GUI
hFigure = handles.MainFigure;

% Get the deltaX
a0Value = get(hObject,'Value');

% Get some appdata
Coefficients = getappdata(hFigure, 'CoefficientsArray');  % [a0 a1 a2 a3 a4 a5]
Coefficients(1) = a0Value;

% Set some appdatas 
setappdata(hFigure, 'CoefficientsArray', Coefficients);

% Update the GUI
UpdateGUI(handles);


% --- Executes during object creation, after setting all properties.
function a0Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a0Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function a1Slider_Callback(hObject, eventdata, handles)
% hObject    handle to a1Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%Get the handle to the main GUI
hFigure = handles.MainFigure;

% Get the deltaX
a1Value = get(hObject,'Value');

% Get some appdata
Coefficients = getappdata(hFigure, 'CoefficientsArray');  % [a0 a1 a2 a3 a4 a5]
Coefficients(2) = a1Value;

% Set some appdatas 
setappdata(hFigure, 'CoefficientsArray', Coefficients);

% Update the GUI
UpdateGUI(handles);


% --- Executes during object creation, after setting all properties.
function a1Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a1Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function a2Slider_Callback(hObject, eventdata, handles)
% hObject    handle to a2Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%Get the handle to the main GUI
hFigure = handles.MainFigure;

% Get the deltaX
a2Value = get(hObject,'Value');

% Get some appdata
Coefficients = getappdata(hFigure, 'CoefficientsArray');  % [a0 a1 a2 a3 a4 a5]
Coefficients(3) = a2Value;

% Set some appdatas 
setappdata(hFigure, 'CoefficientsArray', Coefficients);

% Update the GUI
UpdateGUI(handles);


% --- Executes during object creation, after setting all properties.
function a2Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a2Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function a3Slider_Callback(hObject, eventdata, handles)
% hObject    handle to a3Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%Get the handle to the main GUI
hFigure = handles.MainFigure;

% Get the deltaX
a3Value = get(hObject,'Value');

% Get some appdata
Coefficients = getappdata(hFigure, 'CoefficientsArray');  % [a0 a1 a2 a3 a4 a5]
Coefficients(4) = a3Value;

% Set some appdatas 
setappdata(hFigure, 'CoefficientsArray', Coefficients);

% Update the GUI
UpdateGUI(handles);


% --- Executes during object creation, after setting all properties.
function a3Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a3Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function a4Slider_Callback(hObject, eventdata, handles)
% hObject    handle to a4Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%Get the handle to the main GUI
hFigure = handles.MainFigure;

% Get the deltaX
a4Value = get(hObject,'Value');

% Get some appdata
Coefficients = getappdata(hFigure, 'CoefficientsArray');  % [a0 a1 a2 a3 a4 a5]
Coefficients(5) = a4Value;

% Set some appdatas 
setappdata(hFigure, 'CoefficientsArray', Coefficients);

% Update the GUI
UpdateGUI(handles);

% --- Executes during object creation, after setting all properties.
function a4Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a4Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function a5Slider_Callback(hObject, eventdata, handles)
% hObject    handle to a5Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%Get the handle to the main GUI
hFigure = handles.MainFigure;

% Get the deltaX
a5Value = get(hObject,'Value');

% Get some appdata
Coefficients = getappdata(hFigure, 'CoefficientsArray');  % [a0 a1 a2 a3 a4 a5]
Coefficients(6) = a5Value;

% Set some appdatas 
setappdata(hFigure, 'CoefficientsArray', Coefficients);

% Update the GUI
UpdateGUI(handles);

% --- Executes during object creation, after setting all properties.
function a5Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a5Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function lowerLimitSlider_Callback(hObject, eventdata, handles)
% hObject    handle to lowerLimitSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%Get the handle to the main GUI
hFigure = handles.MainFigure;

% Get some appdata
integLimits = getappdata(hFigure, 'IntegrationLimits');    % [xmin xmax]

% Get the deltaX
xMin = get(hObject,'Value');
deltaX = getappdata(hFigure, 'DeltaX');

% Check whether the Upper limit is greater than lower limit or 
if xMin >= integLimits(2)
    % Refresh the GUI
    RefreshGUI(handles);

    % Highlight the current edit box
    uicontrol(hObject) % set the focus on hObject

    % And display a warning
    warndlg('Lower limit of integration should be < Upper limit of integration.');    
else
    integLimits(1) = xMin;
    if (integLimits(2) == 0)
        if (deltaX >= abs(integLimits(2)-integLimits(1))/10)
            deltaX = abs(integLimits(2)-integLimits(1))/10;
        end
    else
        if (deltaX >= abs(integLimits(2)/10))
            deltaX = abs(integLimits(2)/10);
        end
    end
    
    % Set some appdatas 
    setappdata(hFigure, 'IntegrationLimits', integLimits);
    setappdata(hFigure, 'DeltaX', deltaX);
    
    % Update the GUI
    UpdateGUI(handles);
end

% --- Executes during object creation, after setting all properties.
function lowerLimitSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lowerLimitSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function upperLimitSlider_Callback(hObject, eventdata, handles)
% hObject    handle to upperLimitSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%Get the handle to the main GUI
hFigure = handles.MainFigure;

% Get some appdata
integLimits = getappdata(hFigure, 'IntegrationLimits');    % [xmin xmax]
deltaX = getappdata(hFigure, 'DeltaX');

% Get the deltaX
xMax = get(hObject,'Value');

% Check whether the Upper limit is greater than lower limit or 
if xMax <= integLimits(1)-1
    % Refresh the GUI
    RefreshGUI(handles);

    % Highlight the current edit box
    uicontrol(hObject) % set the focus on hObject

    % And display a warning
    warndlg('Upper limit of integration should be > Lower limit of integration.');    
else
    integLimits(2) = xMax;
    if (integLimits(2) == 0)
        if (deltaX >= abs(integLimits(2)-integLimits(1))/10)
            deltaX = abs(integLimits(2)-integLimits(1))/10;
        end
    else
        if (deltaX >= abs(xMax/10))
            deltaX = abs(xMax/10);
        end
    end
    
    % Set some appdatas 
    setappdata(hFigure, 'IntegrationLimits', integLimits);
    setappdata(hFigure, 'DeltaX', deltaX);

    % Update the GUI
    UpdateGUI(handles);
end

% --- Executes during object creation, after setting all properties.
function upperLimitSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upperLimitSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


