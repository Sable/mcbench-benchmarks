function varargout = MCT(varargin)
% MCT M-file for MCT.fig
%      MCT, by itself, creates a new MCT or raises the existing
%      singleton*.
%
%      H = MCT returns the handle to a new MCT or the handle to
%      the existing singleton*.
%
%      MCT('Property','Value',...) creates a new MCT using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to MCT_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      MCT('CALLBACK') and MCT('CALLBACK',hObject,...) call the
%      local function named CALLBACK in MCT.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MCT

% Last Modified by GUIDE v2.5 11-Feb-2006 15:04:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MCT_OpeningFcn, ...
    'gui_OutputFcn',  @MCT_OutputFcn, ...
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


% --- Executes just before MCT is made visible.
function MCT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for MCT
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MCT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MCT_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function zf_Callback(hObject, eventdata, handles)
% hObject    handle to zf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zf as text
%        str2double(get(hObject,'String')) returns contents of zf as a double

% --- Executes during object creation, after setting all properties.
function zf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function q_Callback(hObject, eventdata, handles)
% hObject    handle to q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of q as text
%        str2double(get(hObject,'String')) returns contents of q as a double

% --- Executes during object creation, after setting all properties.
function q_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function xd_Callback(hObject, eventdata, handles)
% hObject    handle to xd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xd as text
%        str2double(get(hObject,'String')) returns contents of xd as a double

% --- Executes during object creation, after setting all properties.
function xd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function xb_Callback(hObject, eventdata, handles)
% hObject    handle to xb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xb as text
%        str2double(get(hObject,'String')) returns contents of xb as a double

% --- Executes during object creation, after setting all properties.
function xb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function R_Callback(hObject, eventdata, handles)
% hObject    handle to R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R as text
%        str2double(get(hObject,'String')) returns contents of R as a double

% --- Executes during object creation, after setting all properties.
function R_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function alpha_Callback(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha as text
%        str2double(get(hObject,'String')) returns contents of alpha as a double

% --- Executes during object creation, after setting all properties.
function alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get data from GUI
alpha = str2double(get(handles.alpha,'String'));
R = str2double(get(handles.R,'String'));
q = str2double(get(handles.q,'String'));
zf = str2double(get(handles.zf,'String'));
xb = str2double(get(handles.xb,'String'));
xd = str2double(get(handles.xd,'String'));

% Error checks
if any([zf xb xd] >= 1) || any([zf xb xd] <= 0)
    errordlg('The molar fractions (zf,xb,xd) must be between 0 and 1!')
    return
end

if q > 1 || q < 0
    errordlg('The feed quality must be between 0 and 1 (0 <= q <= 1)!')
    return
end

if alpha < 1
    errordlg('Alpha must be greater than 1!')
    return
end

% Computation of equilibrium curve
ye = 0:0.001:1;
xe = equilib(ye,alpha);

% Computing the intersection of feed line and operating lines
xi = (-(q-1)*(1-R/(R+1))*xd-zf)/((q-1)*R/(R+1)-q);
yi = (zf+xd*q/R)/(1+q/R);

yi2 = interp1(xe,ye,xi);
if yi > yi2
    errordlg('The distillation is not possible! Try a different operation condition.')
    return
end

% plotting operating feed lines and equilibrium curve
axes(handles.axes1)
cla
hold on
plot(xe,ye,'r','LineWidth',1)
xlabel('X','FontWeight','bold'), ylabel('Y','FontWeight','bold')
axis([0 1 0 1])
set(line([xd xi,zf xi,xb xi],[xd yi,zf yi,xb yi]),'Color','b')
set(line([0 1],[0 1]),'Color','k')

% Stepping off stages
% Rectifying section
i = 1;
xp(1) = xd;
yp(1) = xd;
y = xd;
while xp(i) > xi
    xp(i+1)= equilib(y,alpha);
    yp(i+1)= R/(R+1)*xp(i+1)+xd/(R+1);
    y = yp(i+1);
    set(line([xp(i) xp(i+1)],[yp(i) yp(i)]),'Color','m')
    text(xp(i+1),yp(i),num2str(i))
    if xp(i+1) > xi
        set(line([xp(i+1) xp(i+1)],[yp(i) yp(i+1)]),'Color','m')
    end
    i = i+1;
end

% Stripping section
ss = (yi-xb)/(xi-xb);
yp(i) = ss*(xp(i)-xb)+xb;
y = yp(i);
set(line([xp(i) xp(i)],[yp(i-1) yp(i)]),'Color','m')

while xp(i) > xb
    xp(i+1) = equilib(y,alpha);
    yp(i+1) = ss*(xp(i+1)-xb)+xb;
    y = yp(i+1);
    set(line([xp(i) xp(i+1)],[yp(i) yp(i)]),'Color','m');
    text(xp(i+1),yp(i),num2str(i))
    if xp(i+1) > xb
        set(line([xp(i+1) xp(i+1)],[yp(i) yp(i+1)]),'Color','m')
    end
    i = i+1;
end
hold off

% Write on the GUI the final number of plates
set(handles.numplates,'String',i-1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x = equilib(y,alpha)
% Constant relative volatility model
x = y./(alpha-y*(alpha-1));

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fig2 = figure;

alpha = get(handles.alpha,'String');
R = get(handles.R,'String');
q = get(handles.q,'String');
zf = get(handles.zf,'String');
xb = get(handles.xb,'String');
xd = get(handles.xd,'String');

% copy axes into the new figure (this is not trivial)
new_handle = copyobj(handles.axes1,fig2);
set(new_handle, 'units', 'normalized', 'position', [0.13 0.11 0.775 0.815]);
text(0.75,0.35,['zf = ' zf]); text(0.75,0.3,['q = ' q]); text(0.75,0.25,['xd = ' xd])
text(0.75,0.2,['xb = ' xb]); text(0.75,0.15,['R = ' R]); text(0.75,0.1,['alpha = ' alpha])
rectangle('Position',[0.7,0.05,0.25,0.35])

% Save the graph with a unique name
hgsave(new_handle,genvarname(['mctd_' datestr(clock, 'HHMMSS')]))

% --------------------------------------------------------------------
function HelpMenu_Callback(hObject, eventdata, handles)
% hObject    handle to HelpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function AboutMenu_Callback(hObject, eventdata, handles)
% hObject    handle to AboutMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Credits and final reference (Text Box in Help/About)
help.message = {{'This GUI was created following the McCabe and Thiele Graphical Method in: '; ...
    '';'McCabe, Smith and Harriott. Unit Operations of Chemical Engineering, '; ...
    'McGraw-Hill, 7th Edition, 2004.'; ...
    '';'The autor wants to acknowledge the function "McCabe-Thiele Method for an Ideal Binary Mixture" (FileID = 4472) by Housam Binous.';...
    '';'Comments, bugs or suggestions, please write to cgelmi@gmail.com'; ...
      ;'Claudio Gelmi, Pontificia Universidad Católica de Chile.'; ...
    '';'http://www.systemsbiology.cl'};'About this GUI'};
msgbox(help.message{1},help.message{2})