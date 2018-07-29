function varargout = MDOF_vibration_calculator3(varargin)
% MDOF_VIBRATION_CALCULATOR3 M-file for MDOF_vibration_calculator3.fig
%      MDOF_VIBRATION_CALCULATOR3, by itself, creates a new MDOF_VIBRATION_CALCULATOR3 or raises the existing
%      singleton*.
%
%      H = MDOF_VIBRATION_CALCULATOR3 returns the handle to a new MDOF_VIBRATION_CALCULATOR3 or the handle to
%      the existing singleton*.
%
%      MDOF_VIBRATION_CALCULATOR3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MDOF_VIBRATION_CALCULATOR3.M with the given input arguments.
%
%      MDOF_VIBRATION_CALCULATOR3('Property','Value',...) creates a new MDOF_VIBRATION_CALCULATOR3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MDOF_vibration_calculator3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MDOF_vibration_calculator3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MDOF_vibration_calculator3

% Last Modified by GUIDE v2.5 11-Oct-2011 22:48:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MDOF_vibration_calculator3_OpeningFcn, ...
                   'gui_OutputFcn',  @MDOF_vibration_calculator3_OutputFcn, ...
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


% --- Executes just before MDOF_vibration_calculator3 is made visible.
function MDOF_vibration_calculator3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MDOF_vibration_calculator3 (see VARARGIN)

% Choose default command line output for MDOF_vibration_calculator3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global CC
CC = 0;
initial_function(hObject, eventdata, handles)
% UIWAIT makes MDOF_vibration_calculator3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MDOF_vibration_calculator3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc

AcquiringData(hObject, eventdata, handles);
Calculating_Modal_Equation(hObject, eventdata, handles)
[z,wn,f0,wdr,x0,v0] = Definding_Modal_Equa_values(hObject, eventdata, handles);
Displaying_Modal_Equation(z,wn,f0,wdr,x0,v0,hObject, eventdata, handles);
Calculation_XDisplacement(hObject, eventdata, handles);
% Displaying_XDisplacement(hObject, eventdata, handles)
Plotting_XT(hObject, eventdata, handles)
Plotting_RT(hObject, eventdata, handles)

function Animation_2mass(hObject, eventdata, handles)
global XT t CC

axes(handles.axes1);    cla(handles.axes1);
set(handles.pushbutton3, 'string','Stop');
    if CC == 0
        CC = 1;
    else
        CC = 0;
    end
posx=[0.5 -0.5 -0.5 0.5];   
posy=[0.5 0.5 -0.5 -0.5];
h1=line(0,0);

line([-5 10],[-0.5 -0.5],'color','k','linewidth',2);%base line
line([0 0],[-0.5 5],'color','k','linewidth',2); %a wall on left 
block1=patch(posx,posy,'y');    
block2=patch(posx,posy,'g');

axes(handles.axes1);
axis([0 10 -1 1]);
Ratio = 1/max(max(abs(XT)));
xini = [3; 6];
for i = 1 : length(t)
            if ishandle(h1) == 0 || CC  == 0
                set(handles.pushbutton3, 'string','Play');
                cla(handles.axes1);
                break
            else  
                Movx1 = xini(1) + Ratio * XT(1,i);
                Movx2 = xini(2) + Ratio * XT(2,i);
                set(h1,'xdata',[0 Movx1-0.5 Movx2-0.5],'ydata',[0 0 0]);
                set(block1,'xdata', posx + Movx1, 'ydata', posy);
                set(block2,'xdata', posx + Movx2, 'ydata', posy);

               pause(0.015);
            end
end
CC = 0;
set(handles.pushbutton3, 'string','Play');

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Animation_2mass(hObject, eventdata, handles)

function Plotting_RT(hObject, eventdata, handles)
global t RT
plot(handles.axes2,t, RT);legend(handles.axes2,'r_1(t)','r_2(t)');
xlabel(handles.axes2,'Time, t'); ylabel(handles.axes2,'Displacement')

function Plotting_XT(hObject, eventdata, handles)
global t XT
plot(handles.axes3,t, XT);legend(handles.axes3,'x_1(t)','x_2(t)');
xlabel(handles.axes3,'Time, t'); ylabel(handles.axes3,'Displacement')

% function Displaying_XDisplacement(hObject, eventdata, handles)
% global S func
% 
% switch func
%     case 1
%             R1 = get(handles.text10,'string');
%             R2 = get(handles.text11,'string');
%             R1a = str2num(R1(11:15)); R1b = R1(16:35);
%             R2a = str2num(R2(11:15)); R2b = R2(16:35);
%             
%             X11 = S(1,1)*R1a;       X12 = S(1,2)*R2a;
%             X21 = S(2,1)*R1a;       X22 = S(2,2)*R2a;
%             
%             set(handles.text14, 'string',['']);
%     case 2 
%         set(handles.text14,'string','  Sorry ');
%         set(handles.text15,'string','  Sorry ');
%     case 3
%         set(handles.text14,'string','  Sorry ');
%         set(handles.text15,'string','  Sorry ');
% end

% set(handles.text14,'string','')
% set(handles.text15,'string','')


function Calculation_XDisplacement(hObject, eventdata, handles)
global RT S XT
XT = S*RT;

function Displaying_Modal_Equation(z,wn,f0,wdr,x0,v0, hObject, eventdata, handles)
global M t func RT S
zz = z*0.5./wn; wwn = wn; wwdr = wdr; xx0 = x0; vv0 = v0; ff0 = f0;
RT = zeros(length(M),length(t));

for i = 1 : length(M)
    z = zz(i);    wn = wwn(i);     wdr = wwdr(i); 
    x0 = xx0(i);     v0 = vv0(i);     f0 = ff0(i);
%     z,wn,wdr,x0,v0,f0

    switch func
        case 1      % func 1 : F0 = 0
                    if z >= 1
                        warndlg('This is not underdamp system because ...the damping ratio is larger than 1. Please insert the value correctly.');
                        %XT = 0*t;                    
                    else
                        wd = wn*sqrt(1-z^2);
                        X     = f0/sqrt((wn^2 - wdr^2)^2 + (2*z*wn*wdr)^2);
                        Theta = atan(2*z*wn*wdr/(wn^2 - wdr^2));
                        Phi = atan((wd*(x0 - X*cos(Theta)))/(v0 + (x0 - X*cos(Theta))*z*wn - wdr*X*sin(Theta)));
                        A     = (x0 - X*cos(Theta))/sin(Phi);
                        RT(i,:) = A*exp(-z*wn*t).*sin(wd*t + Phi) + X*cos(wdr*t - Theta);
                        if i == 1
                            if z == 0
                                set(handles.text10, 'string',['  r1(t) = ',sprintf('%4.3f',A),...
                            ' sin(',sprintf('%4.3f',wd),...
                            't + ',sprintf('%4.3f',Phi),')']);
                            else
                            set(handles.text10, 'string',['  r1(t) = ',sprintf('%4.3f',A),...
                            'exp(',sprintf('%4.3f',-z*wn),'t) sin(',sprintf('%4.3f',wd),...
                            't + ',sprintf('%4.3f',Phi),')']);
                            end
                        else
                            if z == 0
                                set(handles.text11, 'string',['  r2(t) = ',sprintf('%4.3f',A),...
                            ' sin(',sprintf('%4.3f',wd),...
                            't + ',sprintf('%4.3f',Phi),')']);
                            else
                            set(handles.text11, 'string',['  r2(t) = ',sprintf('%4.3f',A),...
                            'exp(',sprintf('%4.3f',-z*wn),'t) sin(',sprintf('%4.3f',wd),...
                            't + ',sprintf('%4.3f',Phi),')']);
                            end
                        end
                    end
        case 2      % func 1 : F0 cos wt
                    wd = wn*sqrt(1-z^2);
                   
                    X     = f0/sqrt((wn^2 - wdr^2)^2 + (2*z*wn*wdr)^2);
                    Theta = atan(2*z*wn*wdr/(wn^2 - wdr^2));
                    Phi = atan((wd*(x0 - X*cos(Theta)))/(v0 + (x0 - X*cos(Theta))*z*wn - wdr*X*sin(Theta)));
                    A     = (x0 - X*cos(Theta))/sin(Phi);
                    RT(i,:) = A*exp(-z*wn*t).*sin(wd*t + Phi) + X*cos(wdr*t - Theta);
                    if i ==1
                        if z == 0
                            set(handles.text10, 'string',['  r1(t) = ',sprintf('%4.3f',A),...
                            ' sin(', sprintf('%4.3f',wd),'t + ',...
                            sprintf('%4.3f',Phi),') + ',sprintf('%4.3f',X),'cos(',sprintf('%4.3f',wdr),...
                            't - ',sprintf('%4.3f',Theta),')']);
                        else
                            set(handles.text10, 'string',['  r1(t) = ',sprintf('%4.3f',S(1,1)*A),'exp(',...
                            sprintf('%4.3f',-z*wn),'t) sin(', sprintf('%4.3f',wd),'t + ',...
                            sprintf('%4.3f',Phi),') + ',sprintf('%4.3f',X),'cos(',sprintf('%4.3f',wdr),...
                            't - ',sprintf('%4.3f',Theta),')']);
                         end                       
                    else
                        if z == 0
                             set(handles.text11, 'string',['  r2(t) = ',sprintf('%4.3f',A),...
                            ' sin(', sprintf('%4.3f',wd),'t + ',...
                            sprintf('%4.3f',Phi),') + ',sprintf('%4.3f',X),'cos(',sprintf('%4.3f',wdr),...
                            't - ',sprintf('%4.3f',Theta),')']);
                        else
                            set(handles.text11, 'string',['  r2(t) = ',sprintf('%4.3f',A),'exp(',...
                            sprintf('%4.3f',-z*wn),'t) sin(', sprintf('%4.3f',wd),'t + ',...
                            sprintf('%4.3f',Phi),') + ',sprintf('%4.3f',X),'cos(',sprintf('%4.3f',wdr),...
                            't - ',sprintf('%4.3f',Theta),')']);
                        end
                    end

        case 3      % func 1 : F0 sin wt
                    wd    = wn*sqrt(1-z^2);
                    T     = f0/sqrt((wn^2 - wdr^2)^2 + (2*z*wn*wdr)^2);
                    X     = f0/((wn^2 - wdr^2)^2 + (2*z*wn*wdr)^2);
                    Theta = atan(2*z*wn*wdr/(wn^2 - wdr^2));
                    Phi   = atan((wd*(x0 + X*cos(Theta)))/(v0 + (x0 + X*cos(Theta))*z*wn + wdr*X*sin(Theta)));
                    A     = (x0 + X*cos(Theta))/sin(Phi);
                    RT(i,:)    = A*exp(-z*wn*t).*sin(wd*t + Phi) + T*sin(wdr*t + Theta);
                    if i == 1
                        if z == 0
                            set(handles.text10, 'string',['  r1(t) = ',sprintf('%4.3f',A),...
                            ' sin(', sprintf('%4.3f',wd),'t + ',...
                            sprintf('%4.3f',Phi),') + ',sprintf('%4.3f',T),'sin(',sprintf('%4.3f',wdr),...
                            't + ',sprintf('%4.3f',Theta),')']);
                        else
                         set(handles.text10, 'string',['  r1(t) = ',sprintf('%4.3f',A),'exp(',...
                            sprintf('%4.3f',-z*wn),'t) sin(', sprintf('%4.3f',wd),'t + ',...
                            sprintf('%4.3f',Phi),') + ',sprintf('%4.3f',T),'sin(',sprintf('%4.3f',wdr),...
                            't + ',sprintf('%4.3f',Theta),')']);
                        end
                    else
                        if z == 0
                            set(handles.text11, 'string',['  r2(t) = ',sprintf('%4.3f',A),' sin(', sprintf('%4.3f',wd),'t + ',...
                            sprintf('%4.3f',Phi),') + ',sprintf('%4.3f',T),'sin(',sprintf('%4.3f',wdr),...
                            't + ',sprintf('%4.3f',Theta),')']);
                        else
                        set(handles.text11, 'string',['  r2(t) = ',sprintf('%4.3f',A),'exp(',...
                            sprintf('%4.3f',-z*wn),'t) sin(', sprintf('%4.3f',wd),'t + ',...
                            sprintf('%4.3f',Phi),') + ',sprintf('%4.3f',T),'sin(',sprintf('%4.3f',wdr),...
                            't + ',sprintf('%4.3f',Theta),')']);
                        end
                    end
    end
end


function [z,wn,f0,wdr,x0,v0] = Definding_Modal_Equa_values(hObject, eventdata, handles)

global M B F0 w wn
global  PCMP PKMP  S Sinv 


x0 = str2num(get(handles.edit9,'string'));
v0 = str2num(get(handles.edit10,'string'));

% x0, v0,
% Intial value of modal equation
r0 = Sinv*x0;       x0 = r0;
rdot0 = Sinv*v0;    v0 = rdot0;
zz = diag(PCMP);

% Define each of modal equation value

for i = 1 : length(M)    
    z(i) = zz(i);
    wn(i) = sqrtm(PKMP(i,i));    
    FF = S'*B.*F0;
    f0(i) = FF(i,2);
    wdr(i) = w;
end
z = z'; f0 = f0'; wdr = wdr';
%  r0, rdot0, f0, F0,z,wn,wdr



function Calculating_Modal_Equation(hObject, eventdata, handles)

global M C K
global CM PCMP KM PKMP U S Sinv wn

Minvsquare = inv(chol(M));
KM = Minvsquare*K*Minvsquare;
CM = Minvsquare*C*Minvsquare;
U = chol(M);
[P,lam] = eig(U'\K/U);
[w,k]   = sort(sqrt(diag(lam)));
P = P(:,k);
    for i = 1:length(M)
      if P(1,i) < 0
         P(:,i) = -P(:,i);
      end
    end
PKMP = P'*KM*P;
PCMP = P'*CM*P;
S = U\P;    Sinv = inv(S);  wn = w;
% S,Sinv,U,PKMP,PCMP, wn

function AcquiringData(hObject, eventdata, handles)

global M C K B F0 w t x0 v0

M = str2num(get(handles.edit1,'string'));
C = str2num(get(handles.edit2,'string'));
K = str2num(get(handles.edit3,'string'));
B = str2num(get(handles.edit4,'string'));
F0 = str2num(get(handles.edit5,'string'));
w  = str2num(get(handles.edit6,'string'));
t0 = str2num(get(handles.edit7,'string'));
tf = str2num(get(handles.edit8,'string'));
x0 = str2num(get(handles.edit9,'string'));
v0 = str2num(get(handles.edit10,'string'));

t  = t0:0.05:tf;
if size(C) ~= size(M)
    warndlg('Please check matrix size of M, C, K')
end

% M, C, K, B, F0, w, t, x0, v0

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
global func

switch get(hObject,'Value')
    case 1
            func = 1;     
            set(handles.edit5,'string',0);set(handles.edit5,'enable','off');
            set(handles.edit6,'string',0);set(handles.edit6,'enable','off');
    case 2
            func = 2;
            set(handles.edit5,'enable','on');
            set(handles.edit6,'enable','on');
    case 3
            func = 3;
            set(handles.edit5,'enable','on');
            set(handles.edit6,'enable','on');
end
   
function initial_function(hObject, eventdata, handles)
global func
        func = 1;     
        set(handles.edit5,'string',0);set(handles.edit5,'enable','off');
        set(handles.edit6,'string',0);set(handles.edit6,'enable','off');
        set(handles.popupmenu1,'value',1);
        set(handles.axes1,'visible','off');
        
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global func

set(handles.edit1,'string','[3 0 ; 0 1]');
set(handles.edit2,'string','[0 0 ; 0 0]');
set(handles.edit3,'string','[3 -1 ; -1 3]');
set(handles.edit4,'string','[0 0 ; 0 1]');
set(handles.edit5,'string','1');set(handles.edit5,'enable','on');
set(handles.edit6,'string','1');set(handles.edit6,'enable','on');
set(handles.edit9,'string','[1;0]');
set(handles.edit10,'string','[0;0]');
set(handles.popupmenu1,'value',1);
 func = 1;    

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
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



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


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



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


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



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


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



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


 
