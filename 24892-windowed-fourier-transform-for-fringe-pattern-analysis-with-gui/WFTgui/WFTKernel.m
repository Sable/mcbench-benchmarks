function varargout = WFTKernel(varargin)
% Function:             Windowed Fourier transofmr (Kernel)
% Initially Developed:  Dr Qian Kemao (16 May 2009)
% Last modified:        Dr Qian Kemao (17 May 2009)
% Version:              1.0
% Copyrights:           All rights reserved.
% Contact:              mkmqian@ntu.edu.sg (Dr Qian Kemao)

%WFTKERNEL M-file for WFTKernel.fig
%      WFTKERNEL, by itself, creates a new WFTKERNEL or raises the existing
%      singleton*.
%
%      H = WFTKERNEL returns the handle to a new WFTKERNEL or the handle to
%      the existing singleton*.
%
%      WFTKERNEL('Property','Value',...) creates a new WFTKERNEL using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to WFTKernel_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      WFTKERNEL('CALLBACK') and WFTKERNEL('CALLBACK',hObject,...) call the
%      local function named CALLBACK in WFTKERNEL.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help WFTKernel

% Last Modified by GUIDE v2.5 16-May-2009 10:09:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WFTKernel_OpeningFcn, ...
                   'gui_OutputFcn',  @WFTKernel_OutputFcn, ...
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


% --- Executes just before WFTKernel is made visible.
function WFTKernel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for WFTKernel
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes WFTKernel wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = WFTKernel_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_sigmax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sigmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sigmax as text
%        str2double(get(hObject,'String')) returns contents of edit_sigmax as a double


% --- Executes during object creation, after setting all properties.
function edit_sigmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sigmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_wxl_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wxl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wxl as text
%        str2double(get(hObject,'String')) returns contents of edit_wxl as a double


% --- Executes during object creation, after setting all properties.
function edit_wxl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wxl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_wxi_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wxi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wxi as text
%        str2double(get(hObject,'String')) returns contents of edit_wxi as a double


% --- Executes during object creation, after setting all properties.
function edit_wxi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wxi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_wxh_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wxh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wxh as text
%        str2double(get(hObject,'String')) returns contents of edit_wxh as a double


% --- Executes during object creation, after setting all properties.
function edit_wxh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wxh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_sigmay_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sigmay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sigmay as text
%        str2double(get(hObject,'String')) returns contents of edit_sigmay as a double


% --- Executes during object creation, after setting all properties.
function edit_sigmay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sigmay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_wyl_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wyl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wyl as text
%        str2double(get(hObject,'String')) returns contents of edit_wyl as a double


% --- Executes during object creation, after setting all properties.
function edit_wyl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wyl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_wyi_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wyi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wyi as text
%        str2double(get(hObject,'String')) returns contents of edit_wyi as a double


% --- Executes during object creation, after setting all properties.
function edit_wyi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wyi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_wyh_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wyh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wyh as text
%        str2double(get(hObject,'String')) returns contents of edit_wyh as a double


% --- Executes during object creation, after setting all properties.
function edit_wyh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wyh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_thr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_thr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_thr as text
%        str2double(get(hObject,'String')) returns contents of edit_thr as a double


% --- Executes during object creation, after setting all properties.
function edit_thr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_thr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_WFTRun.
function push_WFTRun_Callback(hObject, eventdata, handles)
% hObject    handle to push_WFTRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load result
H=findobj('Tag','radiobutton_wff');   val=get(H,'Value');
if val==1
    g.AlgorithmType='wff';
else
    g.AlgorithmType='wfr';
end
H=findobj('Tag','edit_sigmax'); sigmax=str2num(get(H,'String'));
H=findobj('Tag','edit_sigmax'); sigmax=str2num(get(H,'String'));
H=findobj('Tag','edit_wxl');    wxl=str2num(get(H,'String'));
H=findobj('Tag','edit_wxi');    wxi=str2num(get(H,'String'));
H=findobj('Tag','edit_wxh');    wxh=str2num(get(H,'String'));
H=findobj('Tag','edit_sigmay'); sigmay=str2num(get(H,'String'));
H=findobj('Tag','edit_wyl');    wyl=str2num(get(H,'String'));
H=findobj('Tag','edit_wyi');    wyi=str2num(get(H,'String'));
H=findobj('Tag','edit_wyh');    wyh=str2num(get(H,'String'));
H=findobj('Tag','edit_thr');    thr=str2num(get(H,'String'));
g0=wft2fw(g.AlgorithmType,g.f,sigmax,wxl,wxi,wxh,sigmay,wyl,wyi,wyh,thr);
if strcmp(g.AlgorithmType,'wff')
    g.filtered=g0.filtered;
else
    g.wx=g0.wx;
    g.wy=g0.wy;
    g.r=g0.r;
    g.phase=g0.phase;
    g.filtered=g.r.*exp(sqrt(-1)*g.phase);
end
save result g;
H=findobj('Name','Windowed Fourier Transform (WFT)');figure(H);imagesc(angle(g.filtered));
H=findobj('Name','WFT Kernel');close(H);
