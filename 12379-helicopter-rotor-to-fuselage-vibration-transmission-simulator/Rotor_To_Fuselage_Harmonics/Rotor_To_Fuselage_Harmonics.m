function varargout = Rotor_To_Fuselage_Harmonics(varargin)
% ROTOR_TO_FUSELAGE_HARMONICS M-file for Rotor_To_Fuselage_Harmonics.fig
%      ROTOR_TO_FUSELAGE_HARMONICS, by itself, creates a new ROTOR_TO_FUSELAGE_HARMONICS or raises the existing
%      singleton*.
%
%      H = ROTOR_TO_FUSELAGE_HARMONICS returns the handle to a new ROTOR_TO_FUSELAGE_HARMONICS or the handle to
%      the existing singleton*.
%
%      ROTOR_TO_FUSELAGE_HARMONICS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROTOR_TO_FUSELAGE_HARMONICS.M with the given input arguments.
%
%      ROTOR_TO_FUSELAGE_HARMONICS('Property','Value',...) creates a new ROTOR_TO_FUSELAGE_HARMONICS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Rotor_To_Fuselage_Harmonics_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Rotor_To_Fuselage_Harmonics_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help Rotor_To_Fuselage_Harmonics

% Last Modified by GUIDE v2.5 22-Jul-2006 06:46:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Rotor_To_Fuselage_Harmonics_OpeningFcn, ...
                   'gui_OutputFcn',  @Rotor_To_Fuselage_Harmonics_OutputFcn, ...
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


% --- Executes just before Rotor_To_Fuselage_Harmonics is made visible.
function Rotor_To_Fuselage_Harmonics_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Rotor_To_Fuselage_Harmonics (see VARARGIN)

% Choose default command line output for Rotor_To_Fuselage_Harmonics
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

axes(handles.axes1)
axis off
axes(handles.axes3)
axis off
axes(handles.axes4)
axis off

% UIWAIT makes Rotor_To_Fuselage_Harmonics wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = Rotor_To_Fuselage_Harmonics_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

SS=get(0,'ScreenSize');
x=(SS(3)-800)/2;
y=(SS(4)-544)/2;
set(handles.figure1,'Position',[ x    y   800   544])


% --- Executes on selection change in No_of_Blades.
function No_of_Blades_Callback(hObject, eventdata, handles)
% hObject    handle to No_of_Blades (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns No_of_Blades contents as cell array
%        contents{get(hObject,'Value')} returns selected item from No_of_Blades


% --- Executes during object creation, after setting all properties.
function No_of_Blades_CreateFcn(hObject, eventdata, handles)
% hObject    handle to No_of_Blades (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in No_of_Harmonics.
function No_of_Harmonics_Callback(hObject, eventdata, handles)
% hObject    handle to No_of_Harmonics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns No_of_Harmonics contents as cell array
%        contents{get(hObject,'Value')} returns selected item from No_of_Harmonics


% --- Executes during object creation, after setting all properties.
function No_of_Harmonics_CreateFcn(hObject, eventdata, handles)
% hObject    handle to No_of_Harmonics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Compute.
function Compute_Callback(hObject, eventdata, handles)
% hObject    handle to Compute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Nb = get(handles.No_of_Blades,'Value')+1;
if Nb>6
    Nb=Nb+1;
end
n = get(handles.No_of_Harmonics,'Value')-1;

axes(handles.axes3)
cla
axis on
Resultant_Oscillation( Nb,n )
load DataFile1
handles.Waves=copyobj(Waves,gca);
delete(Waves)
delete DataFile1.mat
clear Waves
set(handles.slider1,'Value',0)

title('Resultant Oscillation Transmitted to Hull','Position',[179.129 1.017 17.321],'FontWeight','Bold');
legend('1 Per rev','Transmitted','Location','SouthEast');
set(legend,'Position',[0.9105 0.193 0.01 0.01])

axes(handles.axes1)
cla
Rotor_Harmonics(Nb,n)
load DataFile
handles.iprev=iprev;
handles.Azimuths=Azimuths;
handles.indx=indx;
handles.bihn=bihn;
handles.betaprev=betaprev;

for j=1:Nb
    handles.BladeSet(j,:)=copyobj(BladeSet(j,:),gca);
end

for j=1:361
    handles.ShadedBeta(j)=copyobj(ShadedBeta(j),gca);
end
   
handles.Div=copyobj(Div,gca);
handles.cyl=copyobj(cyl,gca);
handles.HP=copyobj(HP,gca);
handles.CROSSLINE=copyobj(CROSSLINE,gca);
handles.ANGLES=copyobj(ANGLES,gca);
handles.BladeSurface=copyobj(BladeSurface,gca);
handles.Head=copyobj(Head,gca);
handles.rotoredge=copyobj(rotoredge,gca);

handles.PsiArcStart=plot(90,0,'m*');
handles.PsiArc=plot(90,0,'m*');
handles.PsiArcEnd=plot(90,0,'m*');
handles.ShowPsi=text(105,0,['\psi =' num2str(0) '^o'],'color','m');

if get(handles.Radio3x,'Value')==get(handles.Radio3x,'Max')
    handles.speed=3;
elseif get(handles.Radio1x,'Value')==get(handles.Radio1x,'Max')
    handles.speed=1;
elseif get(handles.Radio5x,'Value')==get(handles.Radio5x,'Max')
    handles.speed=5;
end

delete(BladeSet)
delete(BladeSurface)
delete(HP)
delete(cyl)
delete(CROSSLINE)
delete(ANGLES)
delete(Div)
delete(ShadedBeta)
delete(Head)
delete(rotoredge)

delete DataFile.mat
clear DataFile BladeSet BladeSurface cyl HP iprev betaprev Azimuths ... 
    bihn Div indx CROSSLINE ANGLES ShadedBeta Head rotoredge

camlookat(handles.cyl)
camzoom(1.5)

set(handles.Outer_Cylinder,'Enable','on')
set(handles.Wave_Surface,'Enable','on')
set(handles.WaveOnHP,'Enable','on')
set(handles.Shaded_Beta,'Enable','on')
set(handles.HPlane,'Enable','on')
set(handles.Transmitted_Wave,'Enable','on')
set(handles.Iso_View,'Enable','on')
set(handles.Top_View,'Enable','on')
set(handles.Star_View,'Enable','on')
set(handles.Rear_View,'Enable','on')
set(handles.Rotate_View,'Enable','on')
set(handles.Start,'Enable','on')
set(handles.Radio3x,'Enable','on')
set(handles.Radio1x,'Enable','on')
set(handles.Radio5x,'Enable','on')

set(handles.Outer_Cylinder,'value',1)
set(handles.Wave_Surface,'Value',0)
set(handles.WaveOnHP,'Value',1)
set(handles.Shaded_Beta,'Value',1)
set(handles.HPlane,'Value',1)
set(handles.Transmitted_Wave,'Value',1)
set(handles.Iso_View,'Value',0)
set(handles.Top_View,'Value',0)
set(handles.Star_View,'Value',0)
set(handles.Rear_View,'Value',0)
set(handles.Rotate_View,'Value',0)
set(handles.Start,'Value',0)
set(handles.Radio3x,'Value',1)
set(handles.Radio1x,'Value',0)
set(handles.Radio5x,'Value',0)

guidata(gcbo,handles) 

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles = guidata(gcbo);
axes(handles.axes1)
Nb = get(handles.No_of_Blades,'Value')+1;
if Nb>6
    Nb=Nb+1;
end
n = get(handles.No_of_Harmonics,'Value')-1;
i=round(get(hObject,'Value'));

delete(handles.PsiArc)
delete(handles.PsiArcEnd)
delete(handles.ShowPsi)

thet=linspace(0,i,35)*pi/180;
xarc=90*cos(thet);
yarc=90*sin(thet);

handles.PsiArc=plot(xarc,yarc,'m');
handles.PsiArcEnd=plot(xarc(end),yarc(end),'m*');
handles.ShowPsi=text(105*cos(i*pi/180),105*sin(i*pi/180),['\psi =' num2str(i) '^o'],'color','m');

for j=1:Nb
    rotate(handles.BladeSet(j,:),[0 0 1],(i-handles.iprev),[0 0 0])
end
rotate(handles.Head,[0 0 1],(i-handles.iprev),[0 0 0])

handles.Azimuths=handles.Azimuths+(i-handles.iprev);

cross360indx=find(handles.Azimuths>=360);
handles.Azimuths(cross360indx)=handles.Azimuths(cross360indx)-360;

negativeindex=find(handles.Azimuths<0);
handles.Azimuths(negativeindex)=handles.Azimuths(negativeindex)+360;

hanldes.indx=handles.Azimuths+1;

FlapAxes=-[-sin(handles.Azimuths'*pi/180) cos(handles.Azimuths'*pi/180) zeros(Nb,1)];
beta=handles.bihn(hanldes.indx)*180/pi;

for j=1:Nb
    rotate(handles.BladeSet(j,:),FlapAxes(j,:),beta(j)-handles.betaprev(j),[0 0 0])
end

handles.SBindx=handles.indx+1;
zeroSBindx=find(handles.SBindx>=361);
handles.SBindx(zeroSBindx)=handles.SBindx(zeroSBindx)-361+handles.speed;

if get(handles.Shaded_Beta,'Value')==get(handles.Shaded_Beta,'Max')
    set(handles.ShadedBeta,'Visible','off')
    set(handles.ShadedBeta(handles.Azimuths+1),'Visible','on')
else
    set(handles.ShadedBeta,'Visible','off')
end
handles.betaprev=beta;

if i==360
set(handles.slider1,'Value',0)
handles.iprev=0;
else
handles.iprev =i;
end

guidata(gcbo,handles) 

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in Rotate_View.
function Rotate_View_Callback(hObject, eventdata, handles)
% hObject    handle to Rotate_View (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Rotate_View
rotate3d

% --- Executes on button press in Outer_Cylinder.
function Outer_Cylinder_Callback(hObject, eventdata, handles)
% hObject    handle to Outer_Cylinder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Outer_Cylinder

handles = guidata(gcbo);
if (get(hObject,'Value') == get(hObject,'Max'))
    set(handles.cyl,'Visible','on')
else
    set(handles.cyl,'Visible','off')
end


% --- Executes on button press in Wave_Surface.
function Wave_Surface_Callback(hObject, eventdata, handles)
% hObject    handle to Wave_Surface (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Wave_Surface

handles = guidata(gcbo);
if (get(hObject,'Value') == get(hObject,'Max'))
    set(handles.BladeSurface,'Visible','on')
else
    set(handles.BladeSurface,'Visible','off')
end


% --- Executes on button press in WaveOnHP.
function WaveOnHP_Callback(hObject, eventdata, handles)
% hObject    handle to WaveOnHP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of WaveOnHP
handles = guidata(gcbo);
if (get(hObject,'Value') == get(hObject,'Max'))
    set(handles.rotoredge,'Visible','on')
    set(handles.Div,'Visible','on')
else
    set(handles.rotoredge,'Visible','off')
    set(handles.Div,'Visible','off')
end


% --- Executes on button press in Shaded_Beta.
function Shaded_Beta_Callback(hObject, eventdata, handles)
% hObject    handle to Shaded_Beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Shaded_Beta

handles = guidata(gcbo);

if get(handles.Start,'Value')==get(handles.Start,'Min')

    if (get(hObject,'Value') == get(hObject,'Max'))
        set(handles.ShadedBeta(handles.Azimuths+1),'Visible','on')
    else
        set(handles.ShadedBeta,'Visible','off')
    end
end



% --- Executes on button press in HPlane.
function HPlane_Callback(hObject, eventdata, handles)
% hObject    handle to HPlane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HPlane

% load DataFile

handles = guidata(gcbo);

if (get(hObject,'Value') == get(hObject,'Max'))
    set(handles.HP,'Visible','on')
    if get(handles.Start,'Value')==get(handles.Start,'Min')
        set(handles.PsiArc,'Visible','on')
        set(handles.PsiArcStart,'Visible','on')
        set(handles.PsiArcEnd,'Visible','on')
        set(handles.ShowPsi,'Visible','on')
    end
else
    set(handles.HP,'Visible','off')
    if get(handles.Start,'Value')==get(handles.Start,'Min')
        set(handles.PsiArc,'Visible','off')
        set(handles.PsiArcStart,'Visible','off')
        set(handles.PsiArcEnd,'Visible','off')
        set(handles.ShowPsi,'Visible','off')
    end
end
guidata(gcbo,handles) 


% --- Executes on button press in Iso_View.
function Iso_View_Callback(hObject, eventdata, handles)
% hObject    handle to Iso_View (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcbo);
view(3)
camlookat(handles.cyl)
camzoom(1.5)


% --- Executes on button press in Star_View.
function Star_View_Callback(hObject, eventdata, handles)
% hObject    handle to Star_View (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcbo);
view(0,180)
camlookat(handles.cyl)
camzoom(1.1)


% --- Executes on button press in Rear_View.
function Rear_View_Callback(hObject, eventdata, handles)
% hObject    handle to Rear_View (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcbo);
view(90,0)
camlookat(handles.cyl)
camzoom(1.1)
% --- Executes on button press in Top_View.
function Top_View_Callback(hObject, eventdata, handles)
% hObject    handle to Top_View (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcbo);
view(0,90)
camlookat(handles.cyl)
camzoom(1.5)

% --- Executes on button press in Start.
function Start_Callback(hObject, eventdata, handles)
% hObject    handle to Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Start
handles = guidata(gcbo);
axes(handles.axes1)

Nb = get(handles.No_of_Blades,'Value')+1;
if Nb>6
    Nb=Nb+1;
end
n = get(handles.No_of_Harmonics,'Value')-1;

set(handles.No_of_Blades,'Enable','off')
set(handles.No_of_Harmonics,'Enable','off')
set(handles.Compute,'Enable','off') 
set(handles.slider1,'Enable','off') 

% set(handles.slider1,'Value',1)
i=round(get(handles.slider1,'Value'));
% handles.iprev=0;
if i==0
    set(handles.slider1,'Value',handles.speed);
end

while get(handles.Start,'Value')==get(handles.Start,'Max')
    
    i=round(get(handles.slider1,'Value'));
    
    if get(handles.Radio3x,'Value')==get(handles.Radio3x,'Max')
        handles.speed=3;
    elseif get(handles.Radio1x,'Value')==get(handles.Radio1x,'Max')
        handles.speed=1;
    elseif get(handles.Radio5x,'Value')==get(handles.Radio5x,'Max')
        handles.speed=5;
    end
    
    delete(handles.PsiArc)
    delete(handles.PsiArcEnd)
    delete(handles.ShowPsi)
    
    thet=linspace(0,i,35)*pi/180;
    xarc=90*cos(thet);
    yarc=90*sin(thet);
    handles.PsiArc=plot(xarc,yarc,'m');
    handles.PsiArcEnd=plot(xarc(end),yarc(end),'m*');
    handles.ShowPsi=text(105*cos(i*pi/180),105*sin(i*pi/180),['\psi =' num2str(i) '^o'],'color','m');
    
    if get(handles.HPlane,'Value')==get(handles.HPlane,'Min')
        set(handles.PsiArc,'Visible','off')
        set(handles.PsiArcStart,'Visible','off')
        set(handles.PsiArcEnd,'Visible','off')
        set(handles.ShowPsi,'Visible','off')
    else
        set(handles.PsiArc,'Visible','on')
        set(handles.PsiArcStart,'Visible','on')
        set(handles.PsiArcEnd,'Visible','on')
        set(handles.ShowPsi,'Visible','on')
    end
    
    
    handles.Azimuths=handles.Azimuths+(i-handles.iprev);
    
    cross360indx=find(handles.Azimuths>=360);
    handles.Azimuths(cross360indx)=handles.Azimuths(cross360indx)-360;
    negativeindex=find(handles.Azimuths<0);
    handles.Azimuths(negativeindex)=handles.Azimuths(negativeindex)+360;

    handles.indx=handles.Azimuths;%+handles.speed;
    zeroindx=find(handles.indx==0);
    handles.indx(zeroindx)=handles.speed;
    
    cross360indx=find(handles.indx>=360);
    handles.indx(cross360indx)=handles.indx(cross360indx)-360;
    negativeindex=find(handles.indx<0);
    handles.indx(negativeindex)=handles.indx(negativeindex)+360;

    FlapAxes=-[-sin(handles.Azimuths'*pi/180) cos(handles.Azimuths'*pi/180) zeros(Nb,1)];

    bindx=handles.indx;
    
    bicross360indx=find(bindx>=361);
    bindx(bicross360indx)=bindx(bicross360indx)-361;%+handles.speed;
    
    zerobindx=find(bindx==0);
    bindx(zerobindx)=1;
     
    beta=handles.bihn(bindx)*180/pi;  % changed recently

    
    for j=1:Nb
        rotate(handles.BladeSet(j,:),[0 0 1],(i-handles.iprev),[0 0 0])
    end
    rotate(handles.Head,[0 0 1],(i-handles.iprev),[0 0 0])
%     rotate(handles.BladeSet(:,:),[0 0 1],(i-handles.iprev),[0 0 0])
    
    for j=1:Nb
        rotate(handles.BladeSet(j,:),FlapAxes(j,:),beta(j)-handles.betaprev(j),[0 0 0])
    end
    
    zeroindx=find(handles.indx==0);
    handles.indx(zeroindx)=handles.speed;
    
    handles.SBindx=handles.indx+1;

    zeroSBindx=find(handles.SBindx>=361);
    handles.SBindx(zeroSBindx)=handles.SBindx(zeroSBindx)-361+handles.speed;
    
    if get(handles.Shaded_Beta,'Value')==get(handles.Shaded_Beta,'Max')
        set(handles.ShadedBeta,'Visible','off')
        set(handles.ShadedBeta(handles.SBindx),'Visible','on')
    else
        set(handles.ShadedBeta,'Visible','off')
    end

    handles.betaprev=beta;

    next=i+handles.speed;
    if next>=361
        next=next-361+handles.speed;
    end

    if i==360
        set(handles.slider1,'Value',0)
        i=0;
        handles.iprev=0;
    else
        handles.iprev =i;
    end
    set(handles.slider1,'Value',next);
    drawnow

    
end
set(handles.slider1,'Value',i)
set(handles.No_of_Blades,'Enable','on')
set(handles.No_of_Harmonics,'Enable','on')
set(handles.Compute,'Enable','on') 
set(handles.slider1,'Enable','on') 

guidata(gcbo,handles)


% --- Executes on button press in Author.
function Author_Callback(hObject, eventdata, handles)
% hObject    handle to Author (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Author

state=get(hObject,'Value');
if state==get(hObject,'Max')
    axes(handles.axes4)
    B = imread('Banner.jpg');
    set(handles.axes4,'Visible','on')
    B=image(B);
    save('ha','B')
    axis off
    axes(handles.axes1)
elseif state==get(hObject,'Min')
    axes(handles.axes4)
    load ha;
    set(B,'Visible','off')
    set(handles.axes4,'Visible','off')
    axes(handles.axes1)
end

% --- Executes on button press in Radio3x.
function Radio3x_Callback(hObject, eventdata, handles)
% hObject    handle to Radio3x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Radio3x

handles.speed=3;
set(handles.Radio1x,'Value',0)
set(handles.Radio5x,'Value',0)
guidata(gcbo,handles)

% --- Executes on button press in Radio1x.
function Radio1x_Callback(hObject, eventdata, handles)
% hObject    handle to Radio1x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Radio1x

handles.speed=1;
set(handles.Radio3x,'Value',0)
set(handles.Radio5x,'Value',0)
guidata(gcbo,handles)



% --- Executes on button press in Radio5x.
function Radio5x_Callback(hObject, eventdata, handles)
% hObject    handle to Radio5x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Radio5x

handles.speed=5;
set(handles.Radio1x,'Value',0)
set(handles.Radio3x,'Value',0)
guidata(gcbo,handles)

% --- Executes on button press in Transmitted_Wave.
function Transmitted_Wave_Callback(hObject, eventdata, handles)
% hObject    handle to Transmitted_WAve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Transmitted_WAve
handles = guidata(gcbo);
axes(handles.axes3)
if (get(hObject,'Value') == get(hObject,'Max'))
    set(handles.axes3,'Visible','on')
    set(handles.Waves,'Visible','on')
    title('Resultant Oscillation Transmitted to Hull','Position',[179.129 1.017 17.321],'FontWeight','Bold');
    legend('1 Per rev','Transmitted','Location','SouthEast');
    set(legend,'Position',[0.9105 0.193 0.01 0.01])
else
    set(handles.Waves,'Visible','off')
    delete(legend)
    title([])
    set(handles.axes3,'Visible','off')
end
axes(handles.axes1)



function whileclosing(hObject, eventdata, handles)

clc
clear
aa=0;
save looktargetfile aa
delete looktargetfile.mat
closereq

msg=['  Please Review in mathworks.com or Send your Feedbacks to author   ';...
     '                                                                    ';...
     '     j.divahar@yahoo.com / j.divahar@gmail.com                      ';...
     '                                                                    ';...
     '     HomePage: http://four.fsphost.com/jdivahar                     '];
    

button = msgbox(msg,'Thank you For Trying !');