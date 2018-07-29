function varargout = LinkBudget(varargin)
% LINKBUDGET M-file for LinkBudget.fig
%      LINKBUDGET, by itself, creates a new LINKBUDGET or raises the
%      existing
%      singleton*.
%
%      H = LINKBUDGET returns the handle to a new LINKBUDGET or the handle
%      to
%      the existing singleton*.
%
%      LINKBUDGET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LINKBUDGET.M with the given input arguments.
%
%      LINKBUDGET('Property','Value',...) creates a new LINKBUDGET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LinkBudget_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LinkBudget_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LinkBudget

% Last Modified by GUIDE v2.5 12-Jul-2012 08:58:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LinkBudget_OpeningFcn, ...
                   'gui_OutputFcn',  @LinkBudget_OutputFcn, ...
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
end

% --- Executes just before LinkBudget is made visible.
function LinkBudget_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LinkBudget (see VARARGIN)

% Choose default command line output for LinkBudget
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% if you want to start with log scale
% LinkBudget('pushbutton8_Callback',hObject,eventdata,guidata(hObject))

% UIWAIT makes LinkBudget wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = LinkBudget_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
end

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
end


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
end

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
end


function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
end

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
end

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
end

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double
end

% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double
end

% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double
end

% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Retrieve input data from the GUI
PT=get(handles.edit1);
PT=str2num(PT.String);
PTorig=PT;
PTpop=get(handles.popupmenu1,'Value');
if PTpop==1   % W
    if isempty(PT)|PT<0
        warndlg('Incorrect or missing value in the following field: transmitter power');
        return
    end
    PTstr=' W';
elseif PTpop==2   % dBm
    if isempty(PT)
        warndlg('Incorrect or missing value in the following field: transmitter power');
        return
    end
    PT=1e-3*10.^(PT/10);
    PTstr=' dBm';
elseif PTpop==3   % dBW
    if isempty(PT)
        warndlg('Incorrect or missing value in the following field: transmitter power');
        return
    end
    PT=10.^(PT/10);
    PTstr=' dBW';
end


GT=get(handles.edit2);
GT=str2num(GT.String);
GTorig=GT;
GTpop=get(handles.popupmenu2,'Value');
if GTpop==1   % linear scale
    if isempty(GT)|GT<0
        warndlg('Incorrect or missing value in the following field: transmitter gain');
        return
    end
    GTstr=' ';
elseif GTpop==2   % dB
    if isempty(GT)
        warndlg('Incorrect or missing value in the following field: transmitter gain');
        return
    end
    GT=10.^(GT/10);
    GTstr=' dB';
end

fT=get(handles.edit3);
fT=str2num(fT.String);
fTorig=fT;
fTpop=get(handles.popupmenu3,'Value');
if fTpop==1   % linear
    if isempty(fT)|fT<0|fT>1
        warndlg('Incorrect or missing value in the following field: transmitter directivity function');
        return
    end
    fTstr=' ';
elseif fTpop==2   % dB
    if isempty(fT)|fT>0
        warndlg('Incorrect or missing value in the following field: transmitter directivity function');
        return
    end
    fT=10.^(fT/10);
    fTstr=' dB';
end

GR=get(handles.edit8);
GR=str2num(GR.String);
GRorig=GR;
GRpop=get(handles.popupmenu5,'Value');
if GRpop==1   % linear scale
    if isempty(GR)|GR<0
        warndlg('Incorrect or missing value in the following field: receiver gain');
        return
    end
    GRstr=' ';
elseif GRpop==2   % dB
    if isempty(GR)|GR<0
        warndlg('Incorrect or missing value in the following field: receiver gain');
        return
    end
    GR=10.^(GR/10);
    GRstr=' dB';
end

fR=get(handles.edit9);
fR=str2num(fR.String);
fRorig=fR;
fRpop=get(handles.popupmenu6,'Value');
if fRpop==1   % linear
    if isempty(fR)|fR<0|fR>1
        warndlg('Incorrect or missing value in the following field: receiver directivity function');
        return
    end
    fRstr=' ';
elseif fRpop==2   % dB
    if isempty(fR)|fR>0
        warndlg('Incorrect or missing value in the following field: receiver directivity function');
        return
    end
    fR=10.^(fR/10);
    fRstr=' dB';
end

freq=get(handles.edit13);
freq=str2num(freq.String);
if isempty(freq)|freq<=0
    warndlg('Incorrect or missing value in the following field: frequency');
    return
end

L=get(handles.edit14);
L=str2num(L.String);
if isempty(L)|L<=0
    warndlg('Incorrect or missing value in the following field: path length');
    return
end

Att=get(handles.edit15);
Att=str2num(Att.String);
Attorig=Att;
Attpop=get(handles.popupmenu7,'Value');
if Attpop==1   % linear
    if isempty(Att)|Att<=0|Att>1
        warndlg('Incorrect or missing value in the following field: additional attenuation');
        return
    end
    Attstr=' ';
elseif Attpop==2   % dB
    if isempty(Att)|Att>0
        warndlg('Incorrect or missing value in the following field: additional attenuation');
        return
    end
    Att=10.^(Att/10);
    Attstr=' dB';
end

% calculate received power
c=3e8;
lam=c/freq;
PR=PT.*GT.*fT.*(lam./(4*pi*L)).^2.*GR.*fR.*Att;
PRpop=get(handles.popupmenu4,'Value');
if PRpop==1   % W
    set(handles.edit7,'String',num2str(PR,'%3.2e'));
    PRstr=' W';
elseif PRpop==2   % dBm
    PR=10.*log10(PR./1e-3);
    set(handles.edit7,'String',num2str(round(PR*1000)/1000));
    PRstr=' dBm';
elseif PRpop==3   % dBW
    PR=10.*log10(PR);
    set(handles.edit7,'String',num2str(round(PR*1000)/1000));
    PRstr=' dBW';
end

RBval=get(handles.radiobutton1,'Value');

if RBval
    fighandles = findobj(0, '-depth',1, 'type','figure');
    figsexist=setdiff(fighandles,handles.figure1);
    NextFigNum=length(figsexist)+1;
    
    MsgBox=strvcat('     LINK BUDGET DATA', ...
    ' ', ...
    'TRASMITTER:', ...
    ['Power = ',num2str(PTorig),PTstr], ...
    ['Gain = ',num2str(GTorig),GTstr], ...
    ['Directivity function = ',num2str(fTorig),fTstr], ...
    ' ', ...
    'RECEIVER:', ...
    ['Power = ',num2str(PR),PRstr], ...
    ['Gain = ',num2str(GRorig),GRstr], ...
    ['Directivity function = ',num2str(fRorig),fRstr], ...
    ' ', ...
    'ADDITIONAL DATA:', ...
    ['Frequency = ',num2str(freq,'%3.2e'),' Hz'], ...
    ['Path length = ',num2str(L/1000),' km'], ...
    ['Additional attenuation = ',num2str(Attorig),Attstr], ...
    ' ');
    hmsg=msgbox(MsgBox,['Link budget ',num2str(NextFigNum)]);
end
end

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reset all inputs
set(handles.edit1,'String',num2str(0.001,'%3.2e'));
set(handles.edit2,'String',num2str(1));
set(handles.edit3,'String',num2str(1));
set(handles.edit8,'String',num2str(1));
set(handles.edit9,'String',num2str(1));
set(handles.edit13,'String',num2str(15e9,'%3.2e'));
set(handles.edit14,'String',num2str(1000));
set(handles.edit15,'String',num2str(1));
set(handles.edit7,'String','');

set(handles.popupmenu1,'Value',1);
set(handles.popupmenu2,'Value',1);
set(handles.popupmenu3,'Value',1);
set(handles.popupmenu4,'Value',1);
set(handles.popupmenu5,'Value',1);
set(handles.popupmenu6,'Value',1);
set(handles.popupmenu7,'Value',1);
end

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(handles.figure1);
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

UnitType{1,1}=' W';
UnitType{2,1}=' dBm';
UnitType{3,1}=' dBW';
set(hObject,'String',UnitType);
end

% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
end

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

UnitType{1,1}='';
UnitType{2,1}=' dB';
set(hObject,'String',UnitType);
end

% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
end

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

UnitType{1,1}='';
UnitType{2,1}=' dB';
set(hObject,'String',UnitType);
end

% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
end

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

UnitType{1,1}=' W';
UnitType{2,1}=' dBm';
UnitType{3,1}=' dBW';
set(hObject,'String',UnitType);
end

% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5
end

% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

UnitType{1,1}='';
UnitType{2,1}=' dB';
set(hObject,'String',UnitType);
end

% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        popupmenu6
end

% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

UnitType{1,1}='';
UnitType{2,1}=' dB';
set(hObject,'String',UnitType);
end

% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7
end

% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

UnitType{1,1}='';
UnitType{2,1}=' dB';
set(hObject,'String',UnitType);
end

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reset all inputs
set(handles.edit1,'String',num2str(10.*log10(1e-3/1e-3)));
set(handles.edit2,'String',num2str(0));
set(handles.edit3,'String',num2str(0));
set(handles.edit8,'String',num2str(0));
set(handles.edit9,'String',num2str(0));
set(handles.edit13,'String',num2str(15e9,'%3.2e'));
set(handles.edit14,'String',num2str(1000));
set(handles.edit15,'String',num2str(0));
set(handles.edit7,'String','');

set(handles.popupmenu1,'Value',2);
set(handles.popupmenu2,'Value',2);
set(handles.popupmenu3,'Value',2);
set(handles.popupmenu4,'Value',2);
set(handles.popupmenu5,'Value',2);
set(handles.popupmenu6,'Value',2);
set(handles.popupmenu7,'Value',2);
end

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Retrieve input data from the GUI
PT=get(handles.edit1);
PT=str2num(PT.String);
PTpop=get(handles.popupmenu1,'Value');
if PTpop==1
    if isempty(PT)|PT<0
        warndlg('Incorrect or missing value in the following field: transmitter power');
        return
    end
elseif PTpop==2   % dBm
    if isempty(PT)
        warndlg('Incorrect or missing value in the following field: transmitter power');
        return
    end
    PT=1e-3*10.^(PT/10);
elseif PTpop==3   % dBW
    if isempty(PT)
        warndlg('Incorrect or missing value in the following field: transmitter power');
        return
    end
    PT=10.^(PT/10);
end
set(handles.edit1,'String',num2str(PT,'%3.2e'));


GT=get(handles.edit2);
GT=str2num(GT.String);
GTpop=get(handles.popupmenu2,'Value');
if GTpop==1   % linear scale
    if isempty(GT)|GT<0
        warndlg('Incorrect or missing value in the following field: transmitter gain');
        return
    end
elseif GTpop==2   % dB
    if isempty(GT)
        warndlg('Incorrect or missing value in the following field: transmitter gain');
        return
    end
    GT=10.^(GT/10);
end
set(handles.edit2,'String',num2str(GT,'%3.2e'));

fT=get(handles.edit3);
fT=str2num(fT.String);
fTpop=get(handles.popupmenu3,'Value');
if fTpop==1   % linear
    if isempty(fT)|fT<0|fT>1
        warndlg('Incorrect or missing value in the following field: transmitter directivity function');
        return
    end
elseif fTpop==2   % dB
    if isempty(fT)|fT>0
        warndlg('Incorrect or missing value in the following field: transmitter directivity function');
        return
    end
    fT=10.^(fT/10);
end
set(handles.edit3,'String',num2str(fT,'%3.2e'));

GR=get(handles.edit8);
GR=str2num(GR.String);
GRpop=get(handles.popupmenu5,'Value');
if GRpop==1   % linear scale
    if isempty(GR)|GR<0
        warndlg('Incorrect or missing value in the following field: receiver gain');
        return
    end
elseif GRpop==2   % dB
    if isempty(GR)|GR<0
        warndlg('Incorrect or missing value in the following field: receiver gain');
        return
    end
    GR=10.^(GR/10);
end
set(handles.edit8,'String',num2str(GR,'%3.2e'));

fR=get(handles.edit9);
fR=str2num(fR.String);
fRpop=get(handles.popupmenu6,'Value');
if fRpop==1   % linear
if isempty(fR)|fR<0|fR>1
    warndlg('Incorrect or missing value in the following field: receiver directivity function');
    return
end
elseif fRpop==2   % dB
    if isempty(fR)|fR>0
        warndlg('Incorrect or missing value in the following field: receiver directivity function');
        return
    end
    fR=10.^(fR/10);
end
set(handles.edit9,'String',num2str(fR,'%3.2e'));

Att=get(handles.edit15);
Att=str2num(Att.String);
Attpop=get(handles.popupmenu7,'Value');
if Attpop==1   % linear
    if isempty(Att)|Att<=0|Att>1
        warndlg('Incorrect or missing value in the following field: additional attenuation');
        return
    end
elseif Attpop==2   % dB
    if isempty(Att)|Att>0
        warndlg('Incorrect or missing value in the following field: additional attenuation');
        return
    end
    Att=10.^(Att/10);
end
set(handles.edit15,'String',num2str(Att,'%3.2e'));


PR=get(handles.edit7);
PR=str2num(PR.String);
PRpop=get(handles.popupmenu1,'Value');
if PRpop==2   % dBm
    PR=1e-3*10.^(PR/10);
elseif PRpop==3   % dBW
    PR=10.^(PR/10);
end
set(handles.edit7,'String',num2str(PR,'%3.2e'));

set(handles.popupmenu1,'Value',1);
set(handles.popupmenu2,'Value',1);
set(handles.popupmenu3,'Value',1);
set(handles.popupmenu4,'Value',1);
set(handles.popupmenu5,'Value',1);
set(handles.popupmenu6,'Value',1);
set(handles.popupmenu7,'Value',1);
end

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Retrieve input data from the GUI
PT=get(handles.edit1);
PT=str2num(PT.String);
PTpop=get(handles.popupmenu1,'Value');
if PTpop==1
    if isempty(PT)|PT<0
        warndlg('Incorrect or missing value in the following field: transmitter power');
        return
    end
    PT=10.*log10(PT./1e-3);
elseif PTpop==2   % dBm
    if isempty(PT)
        warndlg('Incorrect or missing value in the following field: transmitter power');
        return
    end
elseif PTpop==3   % dBW
    if isempty(PT)
        warndlg('Incorrect or missing value in the following field: transmitter power');
        return
    end
    PT=10.^(PT/10);
    PT=10.*log10(PT./1e-3);
end
set(handles.edit1,'String',num2str(round(PT*1000)/1000));


GT=get(handles.edit2);
GT=str2num(GT.String);
GTpop=get(handles.popupmenu2,'Value');
if GTpop==1   % linear scale
    if isempty(GT)|GT<0
        warndlg('Incorrect or missing value in the following field: transmitter gain');
        return
    end
    GT=10.*log10(GT);
elseif GTpop==2   % dB
    if isempty(GT)
        warndlg('Incorrect or missing value in the following field: transmitter gain');
        return
    end
end
set(handles.edit2,'String',num2str(round(GT*1000)/1000));


fT=get(handles.edit3);
fT=str2num(fT.String);
fTpop=get(handles.popupmenu3,'Value');
if fTpop==1   % linear
    if isempty(fT)|fT<0|fT>1
        warndlg('Incorrect or missing value in the following field: transmitter directivity function');
        return
    end
    fT=10.*log10(fT);
elseif fTpop==2   % dB
    if isempty(fT)|fT>0
        warndlg('Incorrect or missing value in the following field: transmitter directivity function');
        return
    end
end
set(handles.edit3,'String',num2str(round(fT*1000)/1000));

GR=get(handles.edit8);
GR=str2num(GR.String);
GRpop=get(handles.popupmenu5,'Value');
if GRpop==1   % linear scale
    if isempty(GR)|GR<0
        warndlg('Incorrect or missing value in the following field: receiver gain');
        return
    end
    GR=10.*log10(GR);
elseif GRpop==2   % dB
    if isempty(GR)|GR<0
        warndlg('Incorrect or missing value in the following field: receiver gain');
        return
    end
end
set(handles.edit8,'String',num2str(round(GR*1000)/1000));

fR=get(handles.edit9);
fR=str2num(fR.String);
fRpop=get(handles.popupmenu6,'Value');
if fRpop==1   % linear
    if isempty(fR)|fR<0|fR>1
        warndlg('Incorrect or missing value in the following field: receiver directivity function');
        return
    end
    fR=10.*log10(fR);
elseif fRpop==2   % dB
    if isempty(fR)|fR>0
        warndlg('Incorrect or missing value in the following field: receiver directivity function');
        return
    end
end
set(handles.edit9,'String',num2str(round(fR*1000)/1000));

Att=get(handles.edit15);
Att=str2num(Att.String);
Attpop=get(handles.popupmenu7,'Value');
if Attpop==1   % linear
    if isempty(Att)|Att<=0|Att>1
        warndlg('Incorrect or missing value in the following field: additional attenuation');
        return
    end
    Att=10.*log10(Att);
elseif Attpop==2   % dB
    if isempty(Att)|Att>0
        warndlg('Incorrect or missing value in the following field: additional attenuation');
        return
    end
end
set(handles.edit15,'String',num2str(round(Att*1000)/1000));

PR=get(handles.edit7);
PR=str2num(PR.String);
PRpop=get(handles.popupmenu1,'Value');
if PRpop==1   % dBm
    PR=10.*log10(PR./1e-3);
elseif PRpop==3   % dBW
    PR=10.^(PR/10);
    PR=10.*log10(PR./1e-3);
end
set(handles.edit7,'String',num2str(round(PR*1000)/1000));

set(handles.popupmenu1,'Value',2);
set(handles.popupmenu2,'Value',2);
set(handles.popupmenu3,'Value',2);
set(handles.popupmenu4,'Value',2);
set(handles.popupmenu5,'Value',2);
set(handles.popupmenu6,'Value',2);
set(handles.popupmenu7,'Value',2);
end

% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
end

% --------------------------------------------------------------------
function Terrestrial_links_Callback(hObject, eventdata, handles)
% hObject    handle to Terrestrial_links (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function Estimate_rain_attenuation_terrestrial_Callback(hObject, eventdata, handles)
% hObject    handle to Estimate_rain_attenuation_terrestrial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt={'Enter rain rate (between 0 mm/h and 250 mm/h)',...
        'Enter EM wave polarization (H for horizontal, V for vertical, C for circular)', ...
        'Enter link elevation (between 0° and 90°)'};
name='Rain attenuation (single rain rate value)';
numlines=1;
defaultanswer={'5','V','0'};
answer=inputdlg(prompt,name,numlines,defaultanswer);

if isempty(answer)
    return
end
if isempty(answer{1})|isempty(answer{2})|isempty(answer{3})
    warndlg('Some of the required inputs is/are missing, please check');
    return
end

freq=get(handles.edit13);
freq=str2num(freq.String);
if isempty(freq)|freq<=0
    warndlg('Incorrect or missing value in the following field: frequency');
    return
end
if freq<1e9|freq>1000e9
    warndlg('Frequency should be between 1 GHz and 1000 GHz');
    return
end
freq=freq/1e9;

if strcmp(answer{2},'H')
    taur=0;
elseif strcmp(answer{2},'C')
    taur=pi/4;
elseif strcmp(answer{2},'V')
    taur=pi/2;
end

elev=str2num(answer{3});
if elev<0|elev>90
    warndlg('Link elevation should be between 0° and 90°');
    return
end
elev=elev*pi/180;

RR=str2num(answer{1});
if RR<0|RR>200
    warndlg('Rain rate should be between 0 mm/h and 250 mm/h');
    return
end

% estimate specific attenuation
khaj=[-5.33980 -0.35351 -0.23789 -0.94158];
khbj=[-0.10008 1.26970 0.86036 0.64552];
khcj=[1.13098 0.45400 0.15354 0.16817];
khmk=-0.18961;
khck=0.71147;

kvaj=[-3.80595 -3.44965 -0.39902 0.50167];
kvbj=[0.56934 -0.22911 0.73042 1.07319];
kvcj=[0.81061 0.51059 0.11899 0.27195];
kvmk=-0.16398;
kvck=0.63297;

ahaj=[-0.14318 0.29591 0.32177 -5.37610 16.1721];
ahbj=[1.82442 0.77564 0.63773 -0.96230 -3.29980];
ahcj=[-0.55187 0.19822 0.13164 1.47828 3.43990];
ahma=0.67849;
ahca=-1.95537;

avaj=[-0.07771 0.56727 -0.20238 -48.2991 48.5833];
avbj=[2.33840 0.95545 1.14520 0.791669 0.791459];
avcj=[-0.76284 0.54039 0.26809 0.116226 0.116479];
avma=-0.053739;
avca=0.83433;

kh=10.^(sum(khaj.*exp(-((log10(freq)-khbj)./khcj).^2))+khmk.*log10(freq)+khck);
kv=10.^(sum(kvaj.*exp(-((log10(freq)-kvbj)./kvcj).^2))+kvmk.*log10(freq)+kvck);

ah=sum(ahaj.*exp(-((log10(freq)-ahbj)./ahcj).^2))+ahma.*log10(freq)+ahca;
av=sum(avaj.*exp(-((log10(freq)-avbj)./avcj).^2))+avma.*log10(freq)+avca;

kappa=(kh+kv+(kh-kv).*cos(elev).*cos(elev).*cos(2.*taur))./2;
alfa=(kh.*ah+kv.*av+(kh.*ah-kv.*av).*cos(elev).*cos(elev).*cos(2.*taur))./(2.*kappa);

L=get(handles.edit14);
L=str2num(L.String);
if isempty(L)|L<=0
    warndlg('Incorrect or missing value in the following field: path length');
    return
end

Att=-kappa.*RR.^alfa.*L/1000;
set(handles.edit15,'String',num2str(round(Att*1000)/1000));
set(handles.popupmenu7,'Value',2);

if L>1000
    warndlg('Due to the spatial inhomogeneity of rain, for radio paths longer than 1 km the rain attenuation may be lower than the one reported in the "Additional attenuation" field');
    return
end
end

% --------------------------------------------------------------------
function Estimate_rain_attenuation_statistics_terrestrial_Callback(hObject, eventdata, handles)
% hObject    handle to Estimate_rain_attenuation_statistics_terrestrial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt={'Enter latitude of the reference site (between -90° N and 90° N)', ...
    'Enter longitude of the reference site (between 0° E and 360° E)', ...
    'Enter EM wave polarization (H for horizontal, V for vertical, C for circular)', ...
    'Enter link elevation (between 0° and 90°)'};
name='Rain attenuation statistics (terrestrial link)';
numlines=1;
defaultanswer={'45.4','9.5','V','0'};
answer=inputdlg(prompt,name,numlines,defaultanswer);

if isempty(answer)
    return
end
if isempty(answer{1})|isempty(answer{2})|isempty(answer{3})|isempty(answer{4})
    warndlg('Some of the required inputs is/are missing, please check');
    return
end

freq=get(handles.edit13);
freq=str2num(freq.String);
if isempty(freq)|freq<=0
    warndlg('Incorrect or missing value in the following field: frequency');
    return
end
if freq<1e9|freq>1000e9
    warndlg('Frequency should be between 1 GHz and 1000 GHz');
    return
end
freq=freq/1e9;

latit=str2num(answer{1});
if latit<-90|latit>90
    warndlg('Latitude of the reference site should be between -90° N and 90° N');
    return
end

longit=str2num(answer{2});
if longit<0|longit>360
    warndlg('Longitude of the reference site should be between 0° E and 360° E');
    return
end


if strcmp(answer{3},'H')
    taur=0;
elseif strcmp(answer{3},'C')
    taur=pi/4;
elseif strcmp(answer{3},'V')
    taur=pi/2;
end

elev=str2num(answer{4});
if elev<0|elev>90
    warndlg('Link elevation should be between 0° and 90°');
    return
end
elev=elev*pi/180;

L=get(handles.edit14);
L=str2num(L.String);
if isempty(L)|L<=0
    warndlg('Incorrect or missing value in the following field: path length');
    return
end
L=L/1000;

% estimate specific attenuation 
khaj=[-5.33980 -0.35351 -0.23789 -0.94158];
khbj=[-0.10008 1.26970 0.86036 0.64552];
khcj=[1.13098 0.45400 0.15354 0.16817];
khmk=-0.18961;
khck=0.71147;

kvaj=[-3.80595 -3.44965 -0.39902 0.50167];
kvbj=[0.56934 -0.22911 0.73042 1.07319];
kvcj=[0.81061 0.51059 0.11899 0.27195];
kvmk=-0.16398;
kvck=0.63297;

ahaj=[-0.14318 0.29591 0.32177 -5.37610 16.1721];
ahbj=[1.82442 0.77564 0.63773 -0.96230 -3.29980];
ahcj=[-0.55187 0.19822 0.13164 1.47828 3.43990];
ahma=0.67849;
ahca=-1.95537;

avaj=[-0.07771 0.56727 -0.20238 -48.2991 48.5833];
avbj=[2.33840 0.95545 1.14520 0.791669 0.791459];
avcj=[-0.76284 0.54039 0.26809 0.116226 0.116479];
avma=-0.053739;
avca=0.83433;

kh=10.^(sum(khaj.*exp(-((log10(freq)-khbj)./khcj).^2))+khmk.*log10(freq)+khck);
kv=10.^(sum(kvaj.*exp(-((log10(freq)-kvbj)./kvcj).^2))+kvmk.*log10(freq)+kvck);

ah=sum(ahaj.*exp(-((log10(freq)-ahbj)./ahcj).^2))+ahma.*log10(freq)+ahca;
av=sum(avaj.*exp(-((log10(freq)-avbj)./avcj).^2))+avma.*log10(freq)+avca;

kappa=(kh+kv+(kh-kv).*cos(elev).*cos(elev).*cos(2.*taur))./2;
alfa=(kh.*ah+kv.*av+(kh.*ah-kv.*av).*cos(elev).*cos(elev).*cos(2.*taur))./(2.*kappa);

% estimate rain rate statistics
load meteo.mat

% probability values
p=[(100:-1:1), ...
    (9:-1:1)*1e-1, ...
    (9:-1:1)*1e-2, ...
    (9:-1:1)*1e-3];


% convert longitudes to 0E .. 360E format
lon=longit;
lat=latit;
if lon < 0
    lon = lon + 360;
end

% bi-linear interpolation of parameters @ the required coordinates
pr6i  = interp2(lon_e40,lat_e40,pr6,lon,lat,'linear');
mti   = interp2(lon_e40,lat_e40,mt,lon,lat,'linear');
betai = interp2(lon_e40,lat_e40,conv_ratio,lon,lat,'linear');

% extract mean annual rainfall amount of stratiform type
msi = mti.*(1 - betai);

% percentage probability of rain in an average year
p0 = pr6i.*(1 - exp(-0.0079.*(msi./pr6i)));

% calculate rainfall rate exceeded for p% of the average year
% for all the probability levels given in input
if isnan(p0)
    p0 = 0;
    rr = 0;
else
    rr = zeros(size(p));
    ix = find(p > p0);
    if ~isempty(ix),
        rr(ix) = 0;
    end;
    ix = find(p <= p0);
    if ~isempty(ix),
        a = 1.09;
        b = mti./(21797.*p0);
        c = 26.02.*b;
        A = a.*b;
        B = a + c.*log(p(ix)./p0);
        C = log(p(ix)./p0);
        rr(ix) = (-B + sqrt(B.^2 - 4*A.*C))./(2*A);
    end
end

% clear I;
% I=find(rr>=0.1);
% p=p(I);
% rr=rr(I);

% estimate rain attenuation statistics using Brazilian method
a_p=(kappa.*(1.763.*rr.^(0.753+0.197/L)).^alfa).*L./(1+(L./(119.*rr.^(-0.244))));

figure('name','Yearly statistics of rain attenuation (terrestrial link)')
semilogy(a_p,p,'LineWidth',3);
grid on;
xlabel('Rain attenuation [dB]');
ylabel('Yearly percentage of time the abscissa is exceeded (%)')
title(['f = ',num2str(freq),' GHz, pol = ',answer{3},', elev = ',num2str(round(elev*180/pi*10)/10),'°, lat = ',num2str(latit),'° N, lon = ',num2str(longit),'° E'])
axis tight

end


% --------------------------------------------------------------------
function Estimate_RX_power_statistics_terrestrial_Callback(hObject, eventdata, handles)
% hObject    handle to Estimate_RX_power_statistics_terrestrial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt={'Enter latitude of the reference site (between -90° N and 90° N)', ...
    'Enter longitude of the reference site (between 0° E and 360° E)', ...
    'Enter EM wave polarization (H for horizontal, V for vertical, C for circular)', ...
    'Enter link elevation (between 0° and 90°)'};
name='Received power statistics (terrestrial link)';
numlines=1;
defaultanswer={'45.4','9.5','V','0'};
answer=inputdlg(prompt,name,numlines,defaultanswer);

if isempty(answer)
    return
end
if isempty(answer{1})|isempty(answer{2})|isempty(answer{3})|isempty(answer{4})
    warndlg('Some of the required inputs is/are missing, please check');
    return
end

freq=get(handles.edit13);
freq=str2num(freq.String);
if isempty(freq)|freq<=0
    warndlg('Incorrect or missing value in the following field: frequency');
    return
end
if freq<1e9|freq>1000e9
    warndlg('Frequency should be between 1 GHz and 1000 GHz');
    return
end
freq=freq/1e9;

latit=str2num(answer{1});
if latit<-90|latit>90
    warndlg('Latitude of the reference site should be between -90° N and 90° N');
    return
end

longit=str2num(answer{2});
if longit<0|longit>360
    warndlg('Longitude of the reference site should be between 0° E and 360° E');
    return
end


if strcmp(answer{3},'H')
    taur=0;
elseif strcmp(answer{3},'C')
    taur=pi/4;
elseif strcmp(answer{3},'V')
    taur=pi/2;
end

elev=str2num(answer{4});
if elev<0|elev>90
    warndlg('Link elevation should be between 0° and 90°');
    return
end
elev=elev*pi/180;

L=get(handles.edit14);
L=str2num(L.String);
if isempty(L)|L<=0
    warndlg('Incorrect or missing value in the following field: path length');
    return
end
L=L/1000;

% estimate specific attenuation 
khaj=[-5.33980 -0.35351 -0.23789 -0.94158];
khbj=[-0.10008 1.26970 0.86036 0.64552];
khcj=[1.13098 0.45400 0.15354 0.16817];
khmk=-0.18961;
khck=0.71147;

kvaj=[-3.80595 -3.44965 -0.39902 0.50167];
kvbj=[0.56934 -0.22911 0.73042 1.07319];
kvcj=[0.81061 0.51059 0.11899 0.27195];
kvmk=-0.16398;
kvck=0.63297;

ahaj=[-0.14318 0.29591 0.32177 -5.37610 16.1721];
ahbj=[1.82442 0.77564 0.63773 -0.96230 -3.29980];
ahcj=[-0.55187 0.19822 0.13164 1.47828 3.43990];
ahma=0.67849;
ahca=-1.95537;

avaj=[-0.07771 0.56727 -0.20238 -48.2991 48.5833];
avbj=[2.33840 0.95545 1.14520 0.791669 0.791459];
avcj=[-0.76284 0.54039 0.26809 0.116226 0.116479];
avma=-0.053739;
avca=0.83433;

kh=10.^(sum(khaj.*exp(-((log10(freq)-khbj)./khcj).^2))+khmk.*log10(freq)+khck);
kv=10.^(sum(kvaj.*exp(-((log10(freq)-kvbj)./kvcj).^2))+kvmk.*log10(freq)+kvck);

ah=sum(ahaj.*exp(-((log10(freq)-ahbj)./ahcj).^2))+ahma.*log10(freq)+ahca;
av=sum(avaj.*exp(-((log10(freq)-avbj)./avcj).^2))+avma.*log10(freq)+avca;

kappa=(kh+kv+(kh-kv).*cos(elev).*cos(elev).*cos(2.*taur))./2;
alfa=(kh.*ah+kv.*av+(kh.*ah-kv.*av).*cos(elev).*cos(elev).*cos(2.*taur))./(2.*kappa);

% estimate rain rate statistics
load meteo.mat

% probability values
p=[(100:-1:1), ...
    (9:-1:1)*1e-1, ...
    (9:-1:1)*1e-2, ...
    (9:-1:1)*1e-3];


% convert longitudes to 0E .. 360E format
lon=longit;
lat=latit;
if lon < 0
    lon = lon + 360;
end

% bi-linear interpolation of parameters @ the required coordinates
pr6i  = interp2(lon_e40,lat_e40,pr6,lon,lat,'linear');
mti   = interp2(lon_e40,lat_e40,mt,lon,lat,'linear');
betai = interp2(lon_e40,lat_e40,conv_ratio,lon,lat,'linear');

% extract mean annual rainfall amount of stratiform type
msi = mti.*(1 - betai);

% percentage probability of rain in an average year
p0 = pr6i.*(1 - exp(-0.0079.*(msi./pr6i)));

% calculate rainfall rate exceeded for p% of the average year
% for all the probability levels given in input
if isnan(p0)
    p0 = 0;
    rr = 0;
else
    rr = zeros(size(p));
    ix = find(p > p0);
    if ~isempty(ix),
        rr(ix) = 0;
    end;
    ix = find(p <= p0);
    if ~isempty(ix),
        a = 1.09;
        b = mti./(21797.*p0);
        c = 26.02.*b;
        A = a.*b;
        B = a + c.*log(p(ix)./p0);
        C = log(p(ix)./p0);
        rr(ix) = (-B + sqrt(B.^2 - 4*A.*C))./(2*A);
    end
end

% clear I;
% I=find(rr>=0.1);
% p=p(I);
% rr=rr(I);

% estimate rain attenuation statistics using Brazilian method
a_p=(kappa.*(1.763.*rr.^(0.753+0.197/L)).^alfa).*L./(1+(L./(119.*rr.^(-0.244))));

% calculate received power
LinkBudget('pushbutton5_Callback',hObject,eventdata,guidata(hObject))
PR=get(handles.edit7);
PR=str2num(PR.String);

PRpop=get(handles.popupmenu4,'Value');
if PRpop==1   % W
    PRstr=' W';
    a_p=10.^(-a_p/10);
    PR_stat=PR.*a_p;
elseif PRpop==2   % dBm
    PR=1e-3*10.^(PR/10);
    a_p=10.^(-a_p/10);
    PR_stat=PR.*a_p;
    PR_stat=10.*log10(PR_stat./1e-3);
    PRstr=' dBm';
elseif PRpop==3   % dBW
    PR=10.^(PR/10);
    a_p=10.^(-a_p/10);
    PR_stat=PR.*a_p;
    PR_stat=10.*log10(PR_stat);
    PRstr=' dBW';
end

figure('name','Yearly statistics of received power (terrestrial link)')
semilogy(PR_stat,p,'LineWidth',3);
grid on;
xlabel(['Received power (',PRstr,')']);
set(gca,'XDir','reverse')
ylabel('Yearly percentage of time the abscissa is exceeded (%)')
title(['f = ',num2str(freq),' GHz, pol = ',answer{3},', elev = ',num2str(round(elev*180/pi*10)/10),'°, lat = ',num2str(latit),'° N, lon = ',num2str(longit),'° E'])
axis tight

warndlg('Note: received power statistics are calculated by considering only rain attenuation. Depending on frequency, other minor effects may decrese the received power (e.g. scintillations, gaseous absorption due to water vapor and oxygen, ...)','Warning');

end


% --------------------------------------------------------------------
function Earth_space_Callback(hObject, eventdata, handles)
% hObject    handle to Earth_space (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function Estimate_rain_attenuation_statistics_earthspace_Callback(hObject, eventdata, handles)
% hObject    handle to Estimate_rain_attenuation_statistics_earthspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt={'Enter latitude of the reference site (between -90° N and 90° N)', ...
    'Enter longitude of the reference site (between 0° E and 360° E)', ...
    'Enter EM wave polarization (H for horizontal, V for vertical, C for circular)', ...
    'Enter altitude of the site (meters)', ...
    'Enter the longitude of the GEO satellite (between 0° E and 360° E)'};
name='Rain attenuation statistics (Earth-space link)';
numlines=1;
defaultanswer={'45.4','9.5','V','0','10'};
answer=inputdlg(prompt,name,numlines,defaultanswer);

if isempty(answer)
    return
end
if isempty(answer{1})|isempty(answer{2})|isempty(answer{3})|isempty(answer{4})|isempty(answer{5})
    warndlg('Some of the required inputs is/are missing, please check');
    return
end

freq=get(handles.edit13);
freq=str2num(freq.String);
if isempty(freq)|freq<=0
    warndlg('Incorrect or missing value in the following field: frequency');
    return
end
if freq<1e9|freq>1000e9
    warndlg('Frequency should be between 1 GHz and 1000 GHz');
    return
end
freq=freq/1e9;

latit=str2num(answer{1});
if latit<-90|latit>90
    warndlg('Latitude of the reference site should be between -90° N and 90° N');
    return
end

longit=str2num(answer{2});
if longit<0|longit>360
    warndlg('Longitude of the reference site should be between 0° E and 360° E');
    return
end

if strcmp(answer{3},'H')
    taur=0;
elseif strcmp(answer{3},'C')
    taur=pi/4;
elseif strcmp(answer{3},'V')
    taur=pi/2;
end

altit=str2num(answer{4});
if altit<0|altit>=10000
    warndlg('Link elevation should be between 0 meters and 10000 meters');
    return
end
altit=altit/1000;

lonGEO=str2num(answer{5});
if longit<0|longit>360
    warndlg('Longitude of the GEO satellite should be between 0° E and 360° E');
    return
end

% determine link elevation
elev=elevation(latit,longit,altit*0000,0,lonGEO,36000000);
set(handles.edit14,'String',num2str(36000000));

% estimate specific attenuation 
khaj=[-5.33980 -0.35351 -0.23789 -0.94158];
khbj=[-0.10008 1.26970 0.86036 0.64552];
khcj=[1.13098 0.45400 0.15354 0.16817];
khmk=-0.18961;
khck=0.71147;

kvaj=[-3.80595 -3.44965 -0.39902 0.50167];
kvbj=[0.56934 -0.22911 0.73042 1.07319];
kvcj=[0.81061 0.51059 0.11899 0.27195];
kvmk=-0.16398;
kvck=0.63297;

ahaj=[-0.14318 0.29591 0.32177 -5.37610 16.1721];
ahbj=[1.82442 0.77564 0.63773 -0.96230 -3.29980];
ahcj=[-0.55187 0.19822 0.13164 1.47828 3.43990];
ahma=0.67849;
ahca=-1.95537;

avaj=[-0.07771 0.56727 -0.20238 -48.2991 48.5833];
avbj=[2.33840 0.95545 1.14520 0.791669 0.791459];
avcj=[-0.76284 0.54039 0.26809 0.116226 0.116479];
avma=-0.053739;
avca=0.83433;

kh=10.^(sum(khaj.*exp(-((log10(freq)-khbj)./khcj).^2))+khmk.*log10(freq)+khck);
kv=10.^(sum(kvaj.*exp(-((log10(freq)-kvbj)./kvcj).^2))+kvmk.*log10(freq)+kvck);

ah=sum(ahaj.*exp(-((log10(freq)-ahbj)./ahcj).^2))+ahma.*log10(freq)+ahca;
av=sum(avaj.*exp(-((log10(freq)-avbj)./avcj).^2))+avma.*log10(freq)+avca;

kappa=(kh+kv+(kh-kv).*cos(elev).*cos(elev).*cos(2.*taur))./2;
alfa=(kh.*ah+kv.*av+(kh.*ah-kv.*av).*cos(elev).*cos(elev).*cos(2.*taur))./(2.*kappa);

% estimate rain rate statistics
load meteo.mat

% extract mean yearly rain height
lonRH=longit;
while lonRH>=360,
  lonRH=lonRH-360;
end
while lonRH<0,
  lonRH=lonRH+360;
end
RainHeight=interp2(Mlong_1dot5,Mlat_1dot5,iso0h,lonRH,latit,'linear')+0.36;

% probability values
p=[(100:-1:1), ...
    (9:-1:1)*1e-1, ...
    (9:-1:1)*1e-2, ...
    (9:-1:1)*1e-3];


% convert longitudes to 0E .. 360E format
lon=longit;
lat=latit;
if lon < 0
    lon = lon + 360;
end

% bi-linear interpolation of parameters @ the required coordinates
pr6i  = interp2(lon_e40,lat_e40,pr6,lon,lat,'linear');
mti   = interp2(lon_e40,lat_e40,mt,lon,lat,'linear');
betai = interp2(lon_e40,lat_e40,conv_ratio,lon,lat,'linear');

% extract mean annual rainfall amount of stratiform type
msi = mti.*(1 - betai);

% percentage probability of rain in an average year
p0 = pr6i.*(1 - exp(-0.0079.*(msi./pr6i)));

% calculate rainfall rate exceeded for p% of the average year
% for all the probability levels given in input
if isnan(p0)
    p0 = 0;
    rr = 0;
else
    rr = zeros(size(p));
    ix = find(p > p0);
    if ~isempty(ix),
        rr(ix) = 0;
    end;
    ix = find(p <= p0);
    if ~isempty(ix),
        a = 1.09;
        b = mti./(21797.*p0);
        c = 26.02.*b;
        A = a.*b;
        B = a + c.*log(p(ix)./p0);
        C = log(p(ix)./p0);
        rr(ix) = (-B + sqrt(B.^2 - 4*A.*C))./(2*A);
    end
end

% clear I;
% I=find(rr>=0.1);
% p=p(I);
% rr=rr(I);

% estimate rain attenuation statistics using classical method
clear I;
I=find(p==0.01);
RainPass=rr(I);
[prob,a_p]=PA_EarthSpace_new(p,RainPass,latit,elev*pi/180,altit,freq,RainHeight,alfa,kappa);

figure('name','Yearly statistics of rain attenuation (Earth-space link)')
semilogy(a_p,prob,'LineWidth',3);
grid on;
xlabel('Rain attenuation [dB]');
ylabel('Yearly percentage of time the abscissa is exceeded (%)')
title(['f = ',num2str(freq),' GHz, pol = ',answer{3},', elev = ',num2str(round(elev*10)/10),'°, lon (sat) = ',num2str(lonGEO),'° E, lat = ',num2str(latit),'° N, lon = ',num2str(longit),'° E'])
axis tight

end

% --------------------------------------------------------------------
function Estimate_RX_power_statistics_earthspace_Callback(hObject, eventdata, handles)
% hObject    handle to Estimate_RX_power_statistics_earthspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt={'Enter latitude of the reference site (between -90° N and 90° N)', ...
    'Enter longitude of the reference site (between 0° E and 360° E)', ...
    'Enter EM wave polarization (H for horizontal, V for vertical, C for circular)', ...
    'Enter altitude of the site (meters)', ...
    'Enter the longitude of the GEO satellite (between 0° E and 360° E)'};
name='Received power statistics (Earth-space link)';
numlines=1;
defaultanswer={'45.4','9.5','V','0','10'};
answer=inputdlg(prompt,name,numlines,defaultanswer);

if isempty(answer)
    return
end
if isempty(answer{1})|isempty(answer{2})|isempty(answer{3})|isempty(answer{4})|isempty(answer{5})
    warndlg('Some of the required inputs is/are missing, please check');
    return
end

freq=get(handles.edit13);
freq=str2num(freq.String);
if isempty(freq)|freq<=0
    warndlg('Incorrect or missing value in the following field: frequency');
    return
end
if freq<1e9|freq>1000e9
    warndlg('Frequency should be between 1 GHz and 1000 GHz');
    return
end
freq=freq/1e9;

latit=str2num(answer{1});
if latit<-90|latit>90
    warndlg('Latitude of the reference site should be between -90° N and 90° N');
    return
end

longit=str2num(answer{2});
if longit<0|longit>360
    warndlg('Longitude of the reference site should be between 0° E and 360° E');
    return
end

if strcmp(answer{3},'H')
    taur=0;
elseif strcmp(answer{3},'C')
    taur=pi/4;
elseif strcmp(answer{3},'V')
    taur=pi/2;
end

altit=str2num(answer{4});
if altit<0|altit>=10000
    warndlg('Link elevation should be between 0 meters and 10000 meters');
    return
end
altit=altit/1000;

lonGEO=str2num(answer{5});
if longit<0|longit>360
    warndlg('Longitude of the GEO satellite should be between 0° E and 360° E');
    return
end

% determine link elevation
elev=elevation(latit,longit,altit*0000,0,lonGEO,36000000);
set(handles.edit14,'String',num2str(36000000));

% estimate specific attenuation 
khaj=[-5.33980 -0.35351 -0.23789 -0.94158];
khbj=[-0.10008 1.26970 0.86036 0.64552];
khcj=[1.13098 0.45400 0.15354 0.16817];
khmk=-0.18961;
khck=0.71147;

kvaj=[-3.80595 -3.44965 -0.39902 0.50167];
kvbj=[0.56934 -0.22911 0.73042 1.07319];
kvcj=[0.81061 0.51059 0.11899 0.27195];
kvmk=-0.16398;
kvck=0.63297;

ahaj=[-0.14318 0.29591 0.32177 -5.37610 16.1721];
ahbj=[1.82442 0.77564 0.63773 -0.96230 -3.29980];
ahcj=[-0.55187 0.19822 0.13164 1.47828 3.43990];
ahma=0.67849;
ahca=-1.95537;

avaj=[-0.07771 0.56727 -0.20238 -48.2991 48.5833];
avbj=[2.33840 0.95545 1.14520 0.791669 0.791459];
avcj=[-0.76284 0.54039 0.26809 0.116226 0.116479];
avma=-0.053739;
avca=0.83433;

kh=10.^(sum(khaj.*exp(-((log10(freq)-khbj)./khcj).^2))+khmk.*log10(freq)+khck);
kv=10.^(sum(kvaj.*exp(-((log10(freq)-kvbj)./kvcj).^2))+kvmk.*log10(freq)+kvck);

ah=sum(ahaj.*exp(-((log10(freq)-ahbj)./ahcj).^2))+ahma.*log10(freq)+ahca;
av=sum(avaj.*exp(-((log10(freq)-avbj)./avcj).^2))+avma.*log10(freq)+avca;

kappa=(kh+kv+(kh-kv).*cos(elev).*cos(elev).*cos(2.*taur))./2;
alfa=(kh.*ah+kv.*av+(kh.*ah-kv.*av).*cos(elev).*cos(elev).*cos(2.*taur))./(2.*kappa);

% estimate rain rate statistics
load meteo.mat

% extract mean yearly rain height
lonRH=longit;
while lonRH>=360,
  lonRH=lonRH-360;
end
while lonRH<0,
  lonRH=lonRH+360;
end
RainHeight=interp2(Mlong_1dot5,Mlat_1dot5,iso0h,lonRH,latit,'linear')+0.36;

% probability values
p=[(100:-1:1), ...
    (9:-1:1)*1e-1, ...
    (9:-1:1)*1e-2, ...
    (9:-1:1)*1e-3];


% convert longitudes to 0E .. 360E format
lon=longit;
lat=latit;
if lon < 0
    lon = lon + 360;
end

% bi-linear interpolation of parameters @ the required coordinates
pr6i  = interp2(lon_e40,lat_e40,pr6,lon,lat,'linear');
mti   = interp2(lon_e40,lat_e40,mt,lon,lat,'linear');
betai = interp2(lon_e40,lat_e40,conv_ratio,lon,lat,'linear');

% extract mean annual rainfall amount of stratiform type
msi = mti.*(1 - betai);

% percentage probability of rain in an average year
p0 = pr6i.*(1 - exp(-0.0079.*(msi./pr6i)));

% calculate rainfall rate exceeded for p% of the average year
% for all the probability levels given in input
if isnan(p0)
    p0 = 0;
    rr = 0;
else
    rr = zeros(size(p));
    ix = find(p > p0);
    if ~isempty(ix),
        rr(ix) = 0;
    end;
    ix = find(p <= p0);
    if ~isempty(ix),
        a = 1.09;
        b = mti./(21797.*p0);
        c = 26.02.*b;
        A = a.*b;
        B = a + c.*log(p(ix)./p0);
        C = log(p(ix)./p0);
        rr(ix) = (-B + sqrt(B.^2 - 4*A.*C))./(2*A);
    end
end

% clear I;
% I=find(rr>=0.1);
% p=p(I);
% rr=rr(I);

% estimate rain attenuation statistics using classical method
clear I;
I=find(p==0.01);
RainPass=rr(I);
[prob,a_p]=PA_EarthSpace_new(p,RainPass,latit,elev*pi/180,altit,freq,RainHeight,alfa,kappa);

% calculate received power
LinkBudget('pushbutton5_Callback',hObject,eventdata,guidata(hObject))
PR=get(handles.edit7);
PR=str2num(PR.String);

PRpop=get(handles.popupmenu4,'Value');
if PRpop==1   % W
    PRstr=' W';
    a_p=10.^(-a_p/10);
    PR_stat=PR.*a_p;
elseif PRpop==2   % dBm
    PR=1e-3*10.^(PR/10);
    a_p=10.^(-a_p/10);
    PR_stat=PR.*a_p;
    PR_stat=10.*log10(PR_stat./1e-3);
    PRstr=' dBm';
elseif PRpop==3   % dBW
    PR=10.^(PR/10);
    a_p=10.^(-a_p/10);
    PR_stat=PR.*a_p;
    PR_stat=10.*log10(PR_stat);
    PRstr=' dBW';
end

figure('name','Yearly statistics of received power (Earth-space link)')
semilogy(PR_stat,prob,'LineWidth',3);
grid on;
xlabel(['Received power (',PRstr,')']);
set(gca,'XDir','reverse')
ylabel('Yearly percentage of time the abscissa is exceeded (%)')
title(['f = ',num2str(freq),' GHz, pol = ',answer{3},', elev = ',num2str(round(elev*10)/10),'°, lon (sat) = ',num2str(lonGEO),'° E, lat = ',num2str(latit),'° N, lon = ',num2str(longit),'° E'])
axis tight

warndlg('Note: received power statistics are calculated by considering only rain attenuation. Depending on frequency, other minor effects may decrese the received power (e.g. scintillations, gaseous absorption due to water vapor and oxygen, attenuation due to clouds...)','Warning');



end


function [prob, rainatt]=PA_EarthSpace_new(prob,R0_01,lat,elev,hasl,freq,HR,p1,p2)
%
%
% Input
% prob: probability (%)
% R0_01: rain rate for probability equal to 0.01%
% lat: station latitude (deg)
% elev: elevation (rad)
% hasl: station altitude above mean sea level (km)
% freq: frequency of the link (GHz)
% HR: measured rain height (km)
% p1: polarization angle [rad] in the case of 8 input parameters [rad]
%     ITU-R alpha parameter in the case of 9 input parameters
% p2: ITU-R k parameter in the case of 9 input parameters
%
% Output
% prob: probability (%)
% rainatt: rain attenuation (dB)
%
% Ref.: ITU-R Rec. P.618-10, 'Propagation data and prediction methods 
%       required for the design of Earth-space telecommunication systems',
%       Geneva, 2009.
%
% By: C. Riva
% Release: 12.IX.2011

if nargin<9,
  [pa, pk]=itur838_3(freq,p1,elev);
else
  pa=p1;
  pk=p2;
end

rainatt=zeros(size(prob)).*NaN;

Elevdeg=elev.*57.29578;
if R0_01>0,
  %measured 0 deg isotherm height above the ground level
  Hfr=HR;
  if elev>=0.0873,
    Ls=(Hfr-hasl)./sin(elev);
  else
    Ls=2.*(Hfr-hasl)./(sqrt((sin(elev)).^2+0.000235.*(Hfr-hasl))+sin(elev));
  end
  Lg=Ls.*cos(elev);
  Gamma=pk.*(R0_01.^pa);
  Rhz1=1./(1+0.78.*sqrt(Lg.*Gamma./freq)-0.38+0.38.*exp(-2.*Lg));
  Psi=atan((Hfr-hasl)./(Lg.*Rhz1));
  if Psi>elev,
    Lr=Lg.*Rhz1./cos(elev);
  else
    Lr=(Hfr-hasl)./sin(elev);
  end
  if abs(lat)<36,
    Ex=Elevdeg./(1+36-abs(lat));
  else
    Ex=Elevdeg;
  end
  Rvz1=1./(1+sqrt(sin(elev)).*((31-31.*exp(-Ex)).*sqrt(Lr.*Gamma./(freq.^4))-0.45));
  Le=Lr.*Rvz1;
  Az1=Gamma.*Le;
  z=zeros(size(prob));
  I=find(prob>=1);
  if ~isempty(I),
    z(I)=zeros(size(I));
  end
  I=find(prob<1);
  if ~isempty(I),
    if abs(lat)>=36,
      z(I)=zeros(size(I));
    else
      if Elevdeg>=25,
        z(I)=-0.005.*(abs(lat)-36)+zeros(size(I));
      else
        z(I)=-0.005.*(abs(lat)-36)+1.8-4.25.*sin(elev)+zeros(size(I));
      end
    end
  end

  Tle=(prob./0.01).^(-0.655-0.033.*log(prob)+0.045.*log(Az1)+z.*sin(elev).*(1-prob));
  rainatt=Az1.*Tle;
end
rainatt((prob<0.001)|(prob>5))=NaN;

end
