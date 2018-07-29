function varargout = GaAs_QW(varargin)
% In semiconductors, it is possible to make actual potential wells by sandwiching a “well” 
% layer of one semiconductor material (such as InGaAs) between two “barrier” layers of another 
% semiconductor material (such as InP). In this structure, the electron has lower energy
% in the “well” material, and sees some potential barrier height Vo at the interface to the
% “barrier” materials. This kind of structure is used extensively in, for example, the lasers
% for telecommunications with optical fibers. In semiconductors, such potential wells are 
% called “quantum wells”.(*)
% 
% This m-file (GaAs_QW) calculates the energy levels in a GaAs single quantum well with constant
% effective mass vs. different well widths. It also plots the corresponding eigenfunctions given 
% the potential energy and well width.    
% 
% PhD Student. Ernesto Momox Beristain. University of Essex. 
%
% (*) David. A. B. Miller, Quantum Mechanics for Scientist and Engineers. Cambridge.
%
% Enjoy!

% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GaAs_QW

% Last Modified by GUIDE v2.5 05-Mar-2009 11:15:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GaAs_QW_OpeningFcn, ...
                   'gui_OutputFcn',  @GaAs_QW_OutputFcn, ...
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


% --- Executes just before GaAs_QW is made visible.
function GaAs_QW_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GaAs_QW (see VARARGIN)

% Choose default command line output for GaAs_QW
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GaAs_QW wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GaAs_QW_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hold off

Vo=eval(get(handles.edit1,'string'));
if Vo>=0.01 && Vo<=0.5
    
hbar=6.582E-16;
m=0.067*9.109E-31;
%Vo=input('Vo= ');

Lz=linspace(10E-10,400E-10,130);   %%%%%%%%%%%%%%%%%%%%%%definicion del vector Lz(largo del pozo)

progreso=waitbar(0,'Calculating Energy Levels vs Well Widths...');
for t=1:length(Lz)

Einf=1.602E-19*(hbar^2*pi^2)./(2*m*Lz(t).^2);
vo=Vo/Einf;
 
options=optimset('TolFun',1E-50,'TolX',1E-50,'MaxIter',100,'MaxFunEvals',100,'Display','off');
Repz=[]; anRepz=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Simetrica-Solucion

pasos=linspace(eps,vo,30);
k=1;
for c=1:length(pasos)
epz(c)=fsolve(@(epz) sqrt(epz)*tan((pi/2)*sqrt(epz))-sqrt(vo-epz),pasos(c),options);
if isreal(epz(c))
    Repz(k)=epz(c);
    k=k+1;
end
end
if isempty(Repz)==0
Repz=(round(Repz*10000))/10000;
nd=Repz(1);
j=1;
for i=2:length(Repz)
         if Repz(i-1)~=Repz(i) 
         j=j+1;
         nd(j)=Repz(i);
         end
    end
Repz=[];
simsols=nd;
Nsimsols=length(nd);

mm=length(simsols);
for nn=1:mm
Energias(nn,t)=simsols(nn)*Einf;
end

%waitbar(t/length(Lz),progreso)
end
%end%end del if general
%close(progreso)

% for graf=1:mm
% plot(Lz,Energias(graf,:),'LineStyle','none','Marker','square','Color',[0.06 0.3 0.7])
% hold on, grid on, axis auto
% end
% legend('Symmetric solution')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Antisimetrica-Solucion

anpasos=linspace(eps,vo,10);
ank=1;
for anc=1:length(anpasos)
anepz(anc)=fsolve(@(anepz) -sqrt(anepz)*cot((pi/2)*sqrt(anepz))-sqrt(vo-anepz),anpasos(anc),options);
if isreal(anepz(anc))
    anRepz(ank)=anepz(anc);
    ank=ank+1;
end
end
if isempty(anRepz)==0
anRepz=(round(anRepz*10000))/10000;
annd=anRepz(1);
anj=1;
for ani=2:length(anRepz)
         if anRepz(ani-1)~=anRepz(ani) 
         anj=anj+1;
         annd(anj)=anRepz(ani);
         end
    end
anRepz=[];
ansimsols=annd;
Nsimsols=length(annd);

anmm=length(ansimsols);
for annn=1:anmm
anEnergias(annn,t)=ansimsols(annn)*Einf;
end

%waitbar(t/length(Lz),progreso)
end
waitbar(t/length(Lz),progreso)
end%end del if general
close(progreso)

%close(progreso)

axes(handles.axes1);

for graf=1:mm
plot(Lz,Energias(graf,:),'s','MarkerSize',4,'Color',[0.6 0.3 0.7])
hold on, grid on, axis auto
end

for angraf=1:anmm
plot(Lz,anEnergias(angraf,:),'o','MarkerSize',4,'Color',[0.04314 0.5176 0.7804])
hold on, grid on, axis auto
xlabel('Well Width L_{z}'), ylabel('Energy(eV)')
end

else
    errordlg('10meV<Vo<500mev', 'Limitations');
end %end del if que checa Vo


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% clear all
% clc

hbar=6.582E-16;
m=0.067*9.109E-31;
Vo=eval(get(handles.edit3,'string'));
Lz=eval(get(handles.edit2,'string'))*1E-10;   %%%%%%%%%%%%%%%%%%%%%%definicion del vector Lz(largo del pozo)
if Vo>=0.01 && Vo<=0.5 && Lz>=10E-10 && Lz<=400E-10




progreso=waitbar(0,'Calculating Eigenfunctions...');
for t=1:length(Lz)

Einf=1.602E-19*(hbar^2*pi^2)./(2*m*Lz(t).^2);
vo=Vo/Einf;
 
options=optimset('TolFun',1E-50,'TolX',1E-50,'MaxIter',100,'MaxFunEvals',100,'Display','off');
Repz=[]; anRepz=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Simetrica-Solucion

pasos=linspace(eps,vo,30);
k=1;
for c=1:length(pasos)
epz(c)=fsolve(@(epz) sqrt(epz)*tan((pi/2)*sqrt(epz))-sqrt(vo-epz),pasos(c),options);
if isreal(epz(c))
    Repz(k)=epz(c);
    k=k+1;
end
end
if isempty(Repz)==0
Repz=(round(Repz*10000))/10000;
nd=Repz(1);
j=1;
for i=2:length(Repz)
         if Repz(i-1)~=Repz(i) 
         j=j+1;
         nd(j)=Repz(i);
         end
    end
Repz=[];
simsols=nd;
Nsimsols=length(nd);

mm=length(simsols);
for nn=1:mm
Energias(nn,t)=simsols(nn)*Einf;
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Antisimetrica-Solucion

anpasos=linspace(eps,vo,10);
ank=1;
for anc=1:length(anpasos)
anepz(anc)=fsolve(@(anepz) -sqrt(anepz)*cot((pi/2)*sqrt(anepz))-sqrt(vo-anepz),anpasos(anc),options);
if isreal(anepz(anc))
    anRepz(ank)=anepz(anc);
    ank=ank+1;
end
end
if isempty(anRepz)==0
anRepz=(round(anRepz*10000))/10000;
annd=anRepz(1);
anj=1;
for ani=2:length(anRepz)
         if anRepz(ani-1)~=anRepz(ani) 
         anj=anj+1;
         annd(anj)=anRepz(ani);
         end
    end
anRepz=[];
ansimsols=annd;
Nsimsols=length(annd);

anmm=length(ansimsols);
for annn=1:anmm
anEnergias(annn,t)=ansimsols(annn)*Einf;
end

end
waitbar(t/length(Lz),progreso)
end%end del if general
close(progreso)
       
z=linspace(-1.25*Lz,1.25*Lz,150);

%Eigenfuction Symmetric
for rr=1:length(Energias)
kg=sqrt((2*(0.067*9.109E-31))*(Vo-Energias(rr))*1.602E-19/(1.055E-34)^2);
k=sqrt((2*(0.067*9.109E-31))*Energias(rr)*1.602E-19/(1.055E-34)^2);
B=(cos(k*Lz/2))/exp(-kg*Lz/2);

for tt=1:length(z)
    if z(tt)<(-Lz/2)
        Y(rr,tt)=B*exp(kg*z(tt));
    elseif z(tt)>=(-Lz/2) && z(tt)<=(Lz/2)
        Y(rr,tt)=cos(k*z(tt));
    elseif z(tt)>=(Lz/2)
        Y(rr,tt)=B*exp(-kg*z(tt));
    end
%Y(rr,tt)=Energias(rr)+Y(rr,tt);
end
% figure(2)
% plot(z,Y,'s-','MarkerSize',4), grid on
% XX=[Lz/2 Lz/2]; YY=[-1 1]; line(XX,YY,'LineWidth',2.5,'Color',[0.6824 0.4667 0])
% XXn=[-Lz/2 -Lz/2]; YY=[-1 1]; line(XXn,YY,'LineWidth',2.5,'Color',[0.6824 0.4667 0])
end


for rra=1:length(anEnergias)
kga=sqrt((2*(0.067*9.109E-31))*(Vo-anEnergias(rra))*1.602E-19/(1.055E-34)^2);
ka=sqrt((2*(0.067*9.109E-31))*anEnergias(rra)*1.602E-19/(1.055E-34)^2);
Ba=(cos(ka*Lz/2))/exp(-kga*Lz/2);

for tt=1:length(z)
    if z(tt)<(-Lz/2)
        Ya(rra,tt)=Ba*exp(kga*z(tt));
    elseif z(tt)>=(-Lz/2) && z(tt)<=(Lz/2)
        Ya(rra,tt)=cos(ka*z(tt));
    elseif z(tt)>=(Lz/2)
        Ya(rra,tt)=Ba*exp(-kga*z(tt));
    end
%Ya(rra,tt)=anEnergias(rra)+Ya(rra,tt);
end
% figure(3)
% plot(z,Ya,'o-','MarkerSize',4), grid on
% XX=[Lz/2 Lz/2]; YY=[-1 1]; line(XX,YY,'LineWidth',2.5,'Color',[0.6824 0.4667 0])
% XXn=[-Lz/2 -Lz/2]; YY=[-1 1]; line(XXn,YY,'LineWidth',2.5,'Color',[0.6824 0.4667 0])
end

figure(1)
hand=figure(1);
set(hand,'Name','Eigenfunctions for the Specified Potential Energy (Vo) and Well Width (Lz) in the GaAs single QW','NumberTitle','off','Color',[0.65 0.81 0.82]);
set(hand,'position',[140,40,1024,768])

subplot(2,1,1)
plot(z,Y,'s-','MarkerSize',4), grid on, xlabel('z','FontSize',12,'FontWeight','bold'), ylabel('[a.u]','FontWeight','bold'),title('Symmetric Solutions','FontWeight','bold')
XX=[Lz/2 Lz/2]; YY=[-1 1]; line(XX,YY,'LineWidth',2.5,'Color',[0.6824 0.4667 0])
XXn=[-Lz/2 -Lz/2]; YY=[-1 1]; line(XXn,YY,'LineWidth',2.5,'Color',[0.6824 0.4667 0])

subplot(2,1,2)
plot(z,Ya,'o-','MarkerSize',4), grid on, xlabel('z','FontSize',12,'FontWeight','bold'), ylabel('[a.u]','FontWeight','bold'),title('Antisymmetric Solutions','FontWeight','bold')
XX=[Lz/2 Lz/2]; YY=[-1 1]; line(XX,YY,'LineWidth',2.5,'Color',[0.6824 0.4667 0])
XXn=[-Lz/2 -Lz/2]; YY=[-1 1]; line(XXn,YY,'LineWidth',2.5,'Color',[0.6824 0.4667 0])

else
    errordlg('10meV<=Vo<=500mev  &  10E-10<=Lz<=500E-10', 'Limitations');
end %end del if que checa Vo & Lz


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

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
logo=imread('logo-essex.jpg');
imshow(logo);
% Hint: place code in OpeningFcn to populate axes5


% --- Executes during object creation, after setting all properties.
function axes6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes6
esquema=imread('esq-well.bmp');
imshow(esquema);


% --- Executes during object creation, after setting all properties.
function axes7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes7
well=imread('GaAswell.jpg');
imshow(well);

