% Developed in SK_Labs Inc. and for personal use only (Copy righted).
% Contact for any query satendra.svnit@gmail.com (Founder Sk_Labs Inc.)

function varargout = Projectsinglephase(varargin)
% PROJECTSINGLEPHASE M-file for Projectsinglephase.fig
%      PROJECTSINGLEPHASE, by itself, creates a new PROJECTSINGLEPHASE or raises the existing
%      singleton*.
%
%      H = PROJECTSINGLEPHASE returns the handle to a new PROJECTSINGLEPHASE or the handle to
%      the existing singleton*.
%
%      PROJECTSINGLEPHASE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECTSINGLEPHASE.M with the given input arguments.
%
%      PROJECTSINGLEPHASE('Property','Value',...) creates a new PROJECTSINGLEPHASE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Projectsinglephase_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Projectsinglephase_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Projectsinglephase

% Last Modified by GUIDE v2.5 03-Oct-2010 13:56:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Projectsinglephase_OpeningFcn, ...
                   'gui_OutputFcn',  @Projectsinglephase_OutputFcn, ...
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


% --- Executes just before Projectsinglephase current made visible.
function Projectsinglephase_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Projectsinglephase (see VARARGIN)

% Choose default command line output for Projectsinglephase
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Projectsinglephase wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Projectsinglephase_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function r_Callback(hObject, eventdata, handles)
% hObject    handle to r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of r as text
%        str2double(get(hObject,'String')) returns contents of r as a double


% --- Executes during object creation, after setting all properties.
function r_CreateFcn(hObject, eventdata, handles)
% hObject    handle to r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xl_Callback(hObject, eventdata, handles)
% hObject    handle to xl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xl as text
%        str2double(get(hObject,'String')) returns contents of xl as a double


% --- Executes during object creation, after setting all properties.
function xl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xc_Callback(hObject, eventdata, handles)
% hObject    handle to xc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xc as text
%        str2double(get(hObject,'String')) returns contents of xc as a double


% --- Executes during object creation, after setting all properties.
function xc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pfr_Callback(hObject, eventdata, handles)
% hObject    handle to pfr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pfr as text
%        str2double(get(hObject,'String')) returns contents of pfr as a double


% --- Executes during object creation, after setting all properties.
function pfr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pfr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in short.
function short_Callback(hObject, eventdata, handles)
% hObject    handle to short (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice=menu('Enter your choice','single phase','3 phase')
switch choice
    case 1
        whitebg([.4 0.5 .6])
r=get(handles.r,'String');
xl = get(handles.xl,'String');
xc = get(handles.xc,'String');
pfr = get(handles.pfr,'String');
pr=get(handles.pr,'string');
vr=get(handles.vr,'string');
% a and b are variables of Strings type, and need to be converted
% to variables of Number type before they can be added together
r=str2num(r);
xl=str2num(xl);
xc=str2num(xc);
pfr=str2num(pfr);
pr=str2num(pr);
vr=str2num(vr); 

ir=pr*1000/(vr*pfr);
ir=ir*(pfr-j*sind(acosd(pfr)));
vs=vr*1000+ir*(r+j*xl);
vs=vs/1000;
%vs=abs(vs);
is=ir;
phase_difference=angle(vs)-angle(is);
pfs=cos(phase_difference);

loss=ir*ir*r/1000;
loss=abs(loss);
ps=vs*is*pfs/1000;
ps=abs(ps);
eta=pr*100/ps;
is=abs(is);

vs=abs(vs);
volreg=((vs-vr)/vr)*100;
volreg=abs(volreg);


%phase difference calculation
ang_vs=angle(vs);
ang_is=angle(is);
theta=0:pi/100:2*pi;
mod_vs=abs(vs);
mod_is=abs(is);
phase_difference=ang_vs-ang_is;
%effeciency

eta=(pr*100/(ps));


%phase difference,power-factor

is = num2str(is);
loss = num2str(loss);
ps = num2str(ps);
vs = num2str(vs);
eta = num2str(eta);
volreg = num2str(volreg);
pfs = num2str(pfs);

plot(theta,mod_vs*sin(theta),theta,mod_is*sin(theta+phase_difference))
legend('Inputs-Voltage wave','Input-current wave')
grid
xlabel('Angle(In radians)');    %  label the x-axis
ylabel('Function Magnitude');  %  label the y-axis
title('Graph 1.0');
% need to convert the answer back into String type to display it
set(handles.current,'String',is);
set(handles.loss,'String',loss);
set(handles.power,'String',ps);
set(handles.voltage,'String',vs);
set(handles.regulation,'String',volreg);
set(handles.effe,'string',eta);
set(handles.pfs,'string',pfs);
    case 2
        whitebg([0 .4 .6])
r=get(handles.r,'String');
xl = get(handles.xl,'String');
xc = get(handles.xc,'String');
pfr = get(handles.pfr,'String');
pr=get(handles.pr,'string');
vr=get(handles.vr,'string');
% a and b are variables of Strings type, and need to be converted
% to variables of Number type before they can be added together
r=str2num(r);
xl=str2num(xl);
xc=str2num(xc);
pfr=str2num(pfr);
pr=str2num(pr);
vr=str2num(vr); 

ir=pr*1000/(1.732*vr*pfr);

loss=3*ir*ir*r/1000;

vs=(vr*1000/1.732+ir*r*pfr+ir*xl*sind(acosd(pfr)))/1000;

vs=vs*1.732;

ps=pr+loss/1000 ;


eta=(pr/(pr+loss*.001))*100;

volreg=((vs-vr)/vr)*100;

is=ir;

%phase difference,power-factor
%phase difference calculation
ang_vs=angle(vs);
ang_is=angle(is);
theta=0:pi/100:2*pi;
mod_vs=abs(vs);
mod_is=abs(is);
phase_difference=ang_vs-ang_is;
pfs=cos(phase_difference);

ir = num2str(ir);
loss = num2str(loss);
ps = num2str(ps);
vs = num2str(vs);
eta = num2str(eta);
volreg = num2str(volreg);
pfs = num2str(pfs);



plot(theta,mod_vs*sin(theta),theta,mod_is*sin(theta+phase_difference))
legend('Inputs-Voltage wave','Input-current wave')
grid
xlabel('Angle(In radians)');    %  label the x-axis
ylabel('Function Magnitude');  %  label the y-axis
title('Graph 1.0');
% need to convert the answer back into String type to display it

% need to convert the answer back into String type to display it
set(handles.current,'String',ir);
set(handles.loss,'String',loss);
set(handles.power,'String',ps);
set(handles.voltage,'String',vs);
set(handles.regulation,'String',volreg);
set(handles.effe,'string',eta);
set(handles.pfs,'String',pfs);
end 

guidata(hObject, handles);


%==========================================================================
%==========================================================================
%==========================================================================


% --- Executes on button press in nominal_pie.
function nominal_pie_Callback(hObject, eventdata, handles)
% hObject    handle to nominal_pie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Nominal_pie 3-phase calculaton
%Calculation part
choice=menu('Enter choice','1-Phase','3-Phase')
switch choice
    case 1
        whitebg([1 .6 .8])
r=get(handles.r,'String');
xl = get(handles.xl,'String');
xc = get(handles.xc,'String');
pfr = get(handles.pfr,'String');
pr=get(handles.pr,'string');
vr=get(handles.vr,'string');

%string2num
r=str2num(r);
xl=str2num(xl);
xc=str2num(xc);
pfr=str2num(pfr);
pr=str2num(pr);
vr=str2num(vr); 
%current at the recieving end
ir=pr*1000/(vr*pfr);
ir=ir*(pfr-j*sind(acosd(pfr)));

%current in the first capacitive branch
ic1=(1i*vr*1000)/(2*xc);

%current in the load branch
il=ir+ic1;

%sending end voltage
vs=((vr*1000)+il*(r+1i*xl))/1000;

%current in second capacitive branch
ic2=(1i*vs*1000)/(2*xc);

%supply current
is=il+ic2;

%losses
loss=abs(is)*abs(is)*r/1000;

%power input
ps=pr+loss/1000 ;


%voltage regulation
volreg=((abs(vs)-abs(vr))/abs(vr))*100;

%phase difference calculation
ang_vs=angle(vs);
ang_is=angle(is);
theta=0:pi/100:2*pi;
mod_vs=abs(vs);
mod_is=abs(is);
phase_difference=ang_vs-ang_is;
%effeciency

eta=(pr*100/(ps));

plot(theta,mod_vs*sin(theta),theta,mod_is*sin(theta+phase_difference))
legend('Inputs-Voltage wave','Input-current wave')
grid
xlabel('Angle(In radians)');    %  label the x-axis
ylabel('Function Magnitude');  %  label the y-axis
title('Graph 1.0');


% need to convert the answer back into String type to display it

is=abs(is);
vs=abs(vs);
is = num2str(is);
loss = num2str(loss);
ps = num2str(ps);
vs = num2str(vs);
eta = num2str(eta);
volreg = num2str(abs(volreg));
pfs=num2str(cos(phase_difference));




set(handles.current,'String',is);
set(handles.loss,'String',loss);
set(handles.power,'String',ps);
set(handles.voltage,'String',vs);
set(handles.regulation,'String',volreg);
set(handles.effe,'string',eta);
set(handles.pfs,'String',pfs);
    case 2
        whitebg([1 .6 .1])
%lighting phong
r=get(handles.r,'String');
xl = get(handles.xl,'String');
xc = get(handles.xc,'String');
pfr = get(handles.pfr,'String');
pr=get(handles.pr,'string');
vr=get(handles.vr,'string');

%string2num
r=str2num(r);
xl=str2num(xl);
xc=str2num(xc);
pfr=str2num(pfr);
pr=str2num(pr);
vr=str2num(vr); 
%current at the recieving end
ir=pr*1000/(1.732*vr*pfr);
ir=ir*(pfr-j*sind(acosd(pfr)));

%current in the first capacitive branch
ic1=(1i*vr*1000)/(2*1.732*xc);

%current in the load branch
il=ir+ic1;

%sending end voltage
vs=((vr*1000/1.732)+il*(r+1i*xl))/1000;

%current in second capacitive branch
ic2=(1i*vs*1000)/(2*xc);

%supply current
is=il+ic2;

%losses
loss=abs(is)*abs(is)*r/1000;

%voltage regulation
volreg=((abs(vs)*1.732-abs(vr))/abs(vr))*100;

%phase difference calculation
ang_vs=angle(vs);
ang_is=angle(is);
theta=0:pi/100:2*pi;
mod_vs=abs(vs);
mod_is=abs(is);
phase_difference=ang_vs-ang_is;
%effeciency
ps=3*abs(vs)*abs(is)*cos(phase_difference)/1000;
eta=(pr*100/(ps));

vs=vs*1.732;
% need to convert the answer back into String type to display it

is=abs(is);
vs=abs(vs);
is = num2str(is);
loss = num2str(loss);
ps = num2str(ps);
vs = num2str(vs);
eta = num2str(eta);
volreg = num2str(abs(volreg));
pfs=num2str(cos(phase_difference));



plot(theta,mod_vs*sin(theta),theta,mod_is*sin(theta+phase_difference))
legend('Inputs-Voltage wave','Input-current wave')
grid
xlabel('Angle(In radians)');    %  label the x-axis
ylabel('Function Magnitude');  %  label the y-axis
title('Graph 1.0');


set(handles.current,'String',is);
set(handles.loss,'String',loss);
set(handles.power,'String',ps);
set(handles.voltage,'String',vs);
set(handles.regulation,'String',volreg);
set(handles.effe,'string',eta);
set(handles.pfs,'String',pfs);
end
guidata(hObject, handles);

%==========================================================================
%==========================================================================
%==========================================================================

% --- Executes on button press in Nominal_T.
function Nominal_T_Callback(hObject, eventdata, handles)
% hObject    handle to Nominal_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice=menu('Enter Choice','1-Phase','3-Phase')   
switch choice
    case 1
        whitebg([.2 .6 .1])
r=get(handles.r,'String');
xl = get(handles.xl,'String');
xc = get(handles.xc,'String');
pfr = get(handles.pfr,'String');
pr=get(handles.pr,'string');
vr=get(handles.vr,'string');

%string2num
r=str2num(r);
xl=str2num(xl);
xc=str2num(xc);
pfr=str2num(pfr);
pr=str2num(pr);
vr=str2num(vr); 

%Calculation part
%receiving end current
ir=pr*1000/(vr*pfr);
%impedence
z=r+1i*xl;
%current in vector mode
ir=ir*(pfr-j*sind(acosd(pfr)));
%mid-point voltage
v1=(vr*1000)+ir*(z/2);
v1=v1/1000;

%current in capacitive branch
ic=1i*v1*1000/xc;

%current from sending end
is=ir+ic;

%sending end voltage
vs=v1*1000+is*z*.5;
vs=vs/1000;

%voltage regulation
volreg=((abs(vs)-abs(vr))/vr)*100;

%phase difference,power-factor
ang_vs=angle(vs);
ang_is=angle(is);
ang_net=ang_vs-ang_is;
theta=0:pi/100:2*pi;
mod_vs=abs(vs)
mod_is=abs(is)
phase_difference=ang_vs-ang_is;
pfs=cos(phase_difference);
%line losses
loss=mod_is*mod_is*r/1000;

%input power
ps=(mod_vs*mod_is*cos(phase_difference))/1000;

%effeciency

eta=pr*100/(ps);


% need to convert the answer back into String type to display it


is = num2str(is);
loss = num2str(loss);
ps = num2str(ps);
vs = num2str(vs);
eta = num2str(eta);
volreg = num2str(abs(volreg));
pfs=num2str(pfs);


%curve ploting
plot(theta,mod_vs*sin(theta),theta,mod_is*sin(theta+ang_net))
legend('Inputs-Voltage wave','Input-current wave')
grid
xlabel('Angle(In radians)');    %  label the x-axis
ylabel('Function Magnitude');  %  label the y-axis
title('Graph 1.0');

set(handles.current,'String',mod_is);
set(handles.loss,'String',loss);
set(handles.power,'String',ps);
set(handles.voltage,'String',mod_vs);
set(handles.regulation,'String',volreg);
set(handles.effe,'string',eta);
set(handles.pfs,'String',pfs);
    case 2
whitebg([0 .5 .3])
r=get(handles.r,'String');
xl = get(handles.xl,'String');
xc = get(handles.xc,'String');
pfr = get(handles.pfr,'String');
pr=get(handles.pr,'string');
vr=get(handles.vr,'string');

%string2num
r=str2num(r);
xl=str2num(xl);
xc=str2num(xc);
pfr=str2num(pfr);
pr=str2num(pr);
vr=str2num(vr); 

%Calculation part
%receiving end current
ir=pr*1000/(1.732*vr*pfr);
%impedence
z=r+1i*xl;

%current in vector mode
ir=ir*(pfr-j*sind(acosd(pfr)));

%mid-point voltage
v1=(vr*1000/1.732)+ir*(z/2);
v1=v1/1000;

%current in capacitive branch
ic=1i*v1*1000/xc;

%current from sending end
is=ir+ic;

%sending end voltage
vs=v1*1000+is*z*.5;
vs=vs*1.732/1000;

%voltage regulation
volreg=((abs(vs)-abs(vr))/vr)*100;

%phase difference,power-factor
ang_vs=angle(vs);
ang_is=angle(is);
ang_net=ang_vs-ang_is;
theta=0:pi/100:2*pi;
mod_vs=abs(vs)
mod_is=abs(is)
phase_difference=ang_vs-ang_is;
pfs=cos(phase_difference);
%line losses
loss=3*mod_is*mod_is*r/1000;

%input power
ps=(1.732*mod_vs*mod_is*cos(phase_difference))/1000;

%effeciency

eta=pr*100/(ps);


% need to convert the answer back into String type to display it


is = num2str(is);
loss = num2str(loss);
ps = num2str(ps);
vs = num2str(vs);
eta = num2str(eta);
volreg = num2str(abs(volreg));
pfs=num2str(pfs);


%curve ploting
plot(theta,mod_vs*sin(theta),theta,mod_is*sin(theta+ang_net))
legend('Inputs-Voltage wave','Input-current wave')
grid
xlabel('Angle(In radians)');    %  label the x-axis
ylabel('Function Magnitude');  %  label the y-axis
title('Graph 1.0');

set(handles.current,'String',mod_is);
set(handles.loss,'String',loss);
set(handles.power,'String',ps);
set(handles.voltage,'String',mod_vs);
set(handles.regulation,'String',volreg);
set(handles.effe,'string',eta);
set(handles.pfs,'String',pfs);

guidata(hObject, handles);
end 
%==========================================================================
%==========================================================================
%==========================================================================
%=========================================================================


% --- Executes on button press in End_Condensor.
function End_Condensor_Callback(hObject, eventdata, handles)
% hObject    handle to End_Condensor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 choice=menu('Enter your choice','1-Phase','3-Phase')
 switch choice
     case 1
           whitebg([0 0.3 .5])
r=get(handles.r,'String');
xl = get(handles.xl,'String');
xc = get(handles.xc,'String');
pfr = get(handles.pfr,'String');
pr=get(handles.pr,'string');
vr=get(handles.vr,'string');

%string2num
r=str2num(r);
xl=str2num(xl);
xc=str2num(xc);
pfr=str2num(pfr);
pr=str2num(pr);
vr=str2num(vr);
%current at recieving side
ir=pr*1000/(vr*pfr);
%current in phaser form
ir=ir*(pfr-j*sind(acosd(pfr)));
%capacitor current
ic=1i*vr*1000/xc;
%sending end current
is=ir+ic;
zs=r+j*xl;
%sending end voltage
vs=vr+is*zs/1000
%voltage regulation
volreg=((abs(vs)-vr)/vr)*100;
%losses
loss=abs(is)*abs(is)*r/1000;

%phase difference,power-factor
ang_vs=angle(vs);
ang_is=angle(is);
ang_net=ang_vs-ang_is;
theta=0:pi/100:2*pi;
mod_vs=abs(vs)
mod_is=abs(is)
phase_difference=ang_vs-ang_is;
pfs=cos(phase_difference);
%line losses
loss=mod_is*mod_is*r/1000;

%input power
ps=(mod_vs*mod_is*cos(phase_difference))/1000;
%effeciency
eff=pr*100/(ps);

%curve ploting
plot(theta,mod_vs*sin(theta),theta,mod_is*sin(theta+ang_net))
legend('Inputs-Voltage wave','Input-current wave')
grid
xlabel('Angle(In radians)');    %  label the x-axis
ylabel('Function Magnitude');  %  label the y-axis
title('Graph 1.0');

%values back to string
is = num2str(is);
loss = num2str(loss);
ps = num2str(ps);
vs = num2str(vs);
eff = num2str(eff);
volreg = num2str(abs(volreg));
pfs=num2str(pfs);
is=abs(is);
vs=abs(vs);

%Sending to the output box
set(handles.current,'String',mod_is);
set(handles.loss,'String',loss);
set(handles.power,'String',ps);
set(handles.voltage,'String',mod_vs);
set(handles.regulation,'String',volreg);
set(handles.effe,'string',eff);
set(handles.pfs,'String',pfs);
     case 2
         msgbox('Bad input !! fetal error')
 end

function pr_Callback(hObject, eventdata, handles)
% hObject    handle to pr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pr as text
%        str2double(get(hObject,'String')) returns contents of pr as a double


% --- Executes during object creation, after setting all properties.
function pr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vr_Callback(hObject, eventdata, handles)
% hObject    handle to vr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vr as text
%        str2double(get(hObject,'String')) returns contents of vr as a double


% --- Executes during object creation, after setting all properties.
function vr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vr (see GCBO)
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


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in long_transmission.
function long_transmission_Callback(hObject, eventdata, handles)
% hObject    handle to long_transmission (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice=menu('Enter your Choice','1-Phase','3-Phase');
switch choice
    case 1 
        msgbox('Bad Input !!! Fetal Error')
    case 2
whitebg([0 .4 .13])
% hObject    handle to End_Condensor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%code for end_condensor method
%Calculation part
%string 2 number calculation
    
%whitebg([0 .4 0.4]) 
r=get(handles.r,'String');
xl = get(handles.xl,'String');
xc = get(handles.xc,'String');
pfr = get(handles.pfr,'String');
pr=get(handles.pr,'string');
vr=get(handles.vr,'string');
% to variables of Number type before they can be added together
r=str2num(r);
xl=str2num(xl);
xc=str2num(xc);
pfr=str2num(pfr);
pr=str2num(pr);
vr=str2num(vr); 
%current at recieving end
ir=pr*1000/(vr*pfr*1.732);
ir=ir*(pfr-j*sind(acosd(pfr)))
%impedence
z=r+j*xl
%admitence
y=j*1/xc
%sending end voltage
vs=(vr/1.732)*cosh(sqrt(y*z))*1000+ir*sqrt((z/y))*sinh(sqrt(y*z));
vs=vs*sqrt(3)/1000;

%sending end current
is=(vr*(sqrt(y/z))*sinh((sqrt(y*z)))/1000)+ir*cosh((sqrt((y*z))))
vs=abs(vs);
%power factor calculation
mod_vs=abs(vs);
mod_is=abs(is);
ang_vs=angle(vs);
ang_is=angle(is);
phase_difference=ang_vs-ang_is;
ps=1.732*mod_vs*mod_is/1000;
eta=pr*100/abs(ps);


pfs=cos(phase_difference);
volreg=(mod_vs-abs(vr))/abs(vr);
loss=3*ir*ir*r/1000;
loss=abs(loss);
vs=abs(vs);
is=abs(is);




is = num2str(is);
loss = num2str(loss);
ps = num2str(ps);
vs = num2str(vs);
eta = num2str(eta);
volreg = num2str(volreg);
theta=0:pi/100:2*pi;



plot(theta,mod_vs*sin(theta),theta,mod_is*sin(theta+phase_difference))
legend('Inputs-Voltage wave','Input-current wave')
grid
xlabel('Angle(In radians)');    %  label the x-axis
ylabel('Function Magnitude');  %  label the y-axis
title('Graph 1.0');
% need to convert the answer back into String type to display it


% need to convert the answer back into String type to display it
set(handles.current,'String',is);
set(handles.loss,'String',loss);
set(handles.power,'String',ps);
set(handles.voltage,'String',vs);
set(handles.regulation,'String',volreg);
set(handles.effe,'string',eta);
set(handles.pfs,'String',pfs);
guidata(hObject, handles);guidata(hObject, handles);
end 
