function varargout = adjustIntensityRangeGui(varargin)
% ADJUSTINTENSITYRANGEGUI M-file for adjustIntensityRangeGui.fig
%      ADJUSTINTENSITYRANGEGUI, by itself, creates a new ADJUSTINTENSITYRANGEGUI or raises the existing
%      singleton*.
%
%      H = ADJUSTINTENSITYRANGEGUI returns the handle to a new ADJUSTINTENSITYRANGEGUI or the handle to
%      the existing singleton*.
%
%      ADJUSTINTENSITYRANGEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADJUSTINTENSITYRANGEGUI.M with the given input arguments.
%
%      ADJUSTINTENSITYRANGEGUI('Property','Value',...) creates a new ADJUSTINTENSITYRANGEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before adjustIntensityRangeGui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to adjustIntensityRangeGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help adjustIntensityRangeGui

% Last Modified by GUIDE v2.5 11-Aug-2004 09:30:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @adjustIntensityRangeGui_OpeningFcn, ...
                   'gui_OutputFcn',  @adjustIntensityRangeGui_OutputFcn, ...
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
%--------------------------------------------------------
% --- Executes just before adjustIntensityRangeGui is made visible.
%--------------------------------------------------------
function adjustIntensityRangeGui_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for adjustIntensityRangeGui
handles.output = hObject;

hMainGui = getappdata(0,'hMainGui');
intensityParam = getappdata(hMainGui,'intensityParam');
set(handles.lowerEdit,'String',num2str(intensityParam.lowerLimit));
set(handles.upperEdit,'String',num2str(intensityParam.upperLimit));
handles.intensityParam = intensityParam;

% Set the slider's value and step size
handax=findobj(hMainGui,'tag','axes1');
cimg = getimage(handax);
cmin = intensityParam.minIntensity;
cmax = intensityParam.maxIntensity;
rng = cmax-cmin;

if cmax == 0
    cmin = 0; cmax = 1;
    step_size = 1;
elseif cmax <= 1
    step_size = double(rng/256);
else
    step_size = 1/double(rng-1);
end
set(handles.lowerSlider,'Min',cmin,'Max',cmax,...
    'Value', intensityParam.lowerLimit,'SliderStep',[step_size step_size]);
set(handles.upperSlider,'Min',cmin,'Max',cmax,...
    'Value',intensityParam.upperLimit,'SliderStep',[step_size step_size]);
set(handles.upperEdit,'String',num2str(intensityParam.upperLimit));
set(handles.lowerEdit,'String',num2str(intensityParam.lowerLimit));

guidata(hObject, handles);

%--------------------------------------------------------
% --- Outputs from this function are returned to the command line.
%--------------------------------------------------------
function varargout = adjustIntensityRangeGui_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

%--------------------------------------------------------
% --- Executes during object creation, after setting all properties.
%--------------------------------------------------------
function lowerSlider_CreateFcn(hObject, eventdata, handles)
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
% --- Executes on slider movement.
%--------------------------------------------------------
function lowerSlider_Callback(hObject, eventdata, handles)
lwLimit= round(get(hObject,'Value')); 
upLimit = round(get(handles.upperSlider,'Value'));
if lwLimit<upLimit
    set(handles.lowerEdit,'String',num2str(lwLimit));
    hMainGui = getappdata(0,'hMainGui');
    handax=findobj(hMainGui,'tag','axes1');
    ll = get(handax,'Clim');
    set(handax,'Clim',[lwLimit ll(2)]);
    handles.intensityParam.lowerLimit = lwLimit;
else
    errordlg('Lower limit cannot be larger than the upper');
end
guidata(hObject, handles);

%--------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function upperSlider_CreateFcn(hObject, eventdata, handles)
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
%--------------------------------------------------------
% --- Executes on slider movement.
%--------------------------------------------------------
function upperSlider_Callback(hObject, eventdata, handles)
upLimit= round(get(hObject,'Value')); 
lwLimit = round(get(handles.lowerSlider,'Value'));
if lwLimit < upLimit
    set(handles.upperEdit,'String',num2str(upLimit));
    hMainGui = getappdata(0,'hMainGui');
    handax=findobj(hMainGui,'tag','axes1');
    ll = get(handax,'Clim');
    set(handax,'Clim',[ll(1) upLimit]);
    handles.intensityParam.upperLimit = upLimit;
else
    errordlg('Lower limit cannot be larger than upper limit');
end
guidata(hObject, handles);
%--------------------------------------------------------
% --- Executes on button press in pushbuttonApply.
%--------------------------------------------------------
function pushbuttonApply_Callback(hObject, eventdata, handles)
hMainGui = getappdata(0,'hMainGui');
setappdata(hMainGui,'intensityParam',handles.intensityParam);
% getappdata(hMainGui,'intensityParam')
if ishandle(handles.figure1),
    close(handles.figure1);
end 
%--------------------------------------------------------
% --- Executes during object creation, after setting all properties.
%--------------------------------------------------------
function lowerEdit_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
%--------------------------------------------------------
%--------------------------------------------------------
function lowerEdit_Callback(hObject, eventdata, handles)
strg = get(hObject,'String');
lwLimit =str2num(strg);
upLimit = get(handles.upperSlider,'Value');
maxLimit = get(handles.lowerSlider,'Max');
if lwLimit <= maxLimit
    if lwLimit < upLimit
        set(handles.lowerSlider,'Value',lwLimit);
        hMainGui = getappdata(0,'hMainGui');
        handax=findobj(hMainGui,'tag','axes1');
        ll = get(handax,'Clim');
        set(handax,'CLim',[lwLimit ll(2)]);
        handles.intensityParam.lowerLimit = lwLimit;
    else
        errordlg('Lower limit cannot be larger than upper limit');
    end
else
    errordlg('Larger than maximum limit');
end
guidata(hObject, handles);
%--------------------------------------------------------
% --- Executes during object creation, after setting all properties.
%--------------------------------------------------------
function upperEdit_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
%--------------------------------------------------------
%--------------------------------------------------------
function upperEdit_Callback(hObject, eventdata, handles)
strg = get(hObject,'String');
upLimit =str2num(strg);
lwLimit = get(handles.lowerSlider,'Value');
maxLimit = get(handles.lowerSlider,'Max');
if upLimit <=maxLimit
    if upLimit > lwLimit
        set(handles.upperSlider,'Value',upLimit);
        hMainGui = getappdata(0,'hMainGui');
        handax=findobj(hMainGui,'tag','axes1');
        ll = get(handax,'CLim');
        set(handax,'CLim',[ll(1) upLimit]);
        handles.intensityParam.upperLimit = upLimit;
    else
        errordlg('Lower limit cannot be larger than the upper');
    end
else
    errordlg('Larger than maximum limit');
end
guidata(hObject, handles);
    
%--------------------------------------------------------
% --- Executes on button press in pushbuttonCancel.
function pushbuttonCancel_Callback(hObject, eventdata, handles)
close(handles.figure1);
