function varargout = GaAs_GaAlAs_QW(varargin)
% GaAs-GaAlAs Quantum Well
% 
% In a type I quantum well, the energy difference ?Eg between the larger band gap of the barrier 
% and the smaller band gap of the well material causes a confinement potential both for the electrons
% in the conduction band and for the holes in the valence band. In a GaAs-GaAlAs quantum well, e.g., 
% the resulting well depths are ?Ve~ 2?Eg/3 and ?Vh~ ?Eg/3, respectively. In these semiconductors, 
% the electrons in the conduction band behave as if they had an effective mass, m*, that is different 
% from the free electron mass, mo, and this mass is different in the two materials, e.g., mw in the 
% well and mb in the barrier. Because the electron effective mass differs in the two materials, the 
% boundary condition that is used at the interface between the two materials for the derivative of 
% the wavefunction is not continuity of the derivative d?/dz ; instead, a common choice is continuity
% of (1/m*)(d?/dz) where m* is different for the materials in the well and in the barrier.
% 
% This m-file (GaAs_GaAlAs_QW.m) plots the eigenfuctions for electrons, heavy and light holes given the
% Al composition (x) and the well width Lz (Å) of a GaAs-GaAlAs quantum well. It also calculates the
% different energy levels for electrons, heavy and light holes given the Al composition (x).
% 
% UNIVERSITY OF ESSEX
% Optoelectronics Research Group
% PhD Student Ernesto Momox Beristain
% 
% March 2009
% 
% Enjoy!


% Edit the above text to modify the response to help GaAs_GaAlAs_QW

% Last Modified by GUIDE v2.5 19-Mar-2009 23:37:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GaAs_GaAlAs_QW_OpeningFcn, ...
                   'gui_OutputFcn',  @GaAs_GaAlAs_QW_OutputFcn, ...
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


% --- Executes just before GaAs_GaAlAs_QW is made visible.
function GaAs_GaAlAs_QW_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GaAs_GaAlAs_QW (see VARARGIN)

% Choose default command line output for GaAs_GaAlAs_QW
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GaAs_GaAlAs_QW wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GaAs_GaAlAs_QW_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hbar=1.0545E-34;
q=1.6021E-19;
mo=9.1093E-31;

x=eval(get(handles.edit3,'string'));
if x>0 && x<=0.9
    
xm=1-x;
 
for tipos=1:3

if tipos==1
    mb=(0.067+0.083*x)*mo;
    mw=0.067*mo;
    Vo=(0.7482)*x;
elseif tipos==2
    mb=(0.45+0.2)*mo;
    mw=0.45*mo;
    Vo=(0.4988)*x;
elseif tipos==3
    mb=(0.082+0.068*x)*mo;
    mw=0.082*mo;
    Vo=(0.4988)*x;
end

Lz=linspace(2E-10,160E-10,90);

options=optimset('TolFun',1E-100,'TolX',1E-100,'MaxIter',100,'MaxFunEvals',100,'Display','off');
steps=linspace(0,Vo,40);
REsim=[]; REant=[]; Esimetricas=[]; Eantisimetricas=[];

if tipos==1
    work=waitbar(0,'Electron Energy vs. Lz´s');
elseif tipos==2
    work=waitbar(0,'Heavy-hole Energy vs. Lz´s');
elseif tipos==3
    work=waitbar(0,'Light-hole energy vs. Lz´s');
end


for l=1:length(Lz)
    
a=1;
for c=1:length(steps)
    Esim(c)=fsolve(@(Esim) ((sqrt((2*mw*Esim*q)/(hbar^2)))/mw)*tan((sqrt((2*mw*Esim*q)/(hbar^2)))*Lz(l)/2)-(sqrt((2*mb*(Vo-Esim)*q)/(hbar^2)))/mb,steps(c),options);
    if isreal(Esim(c))
    REsim(a)=Esim(c);
    a=a+1;
    end
end

if isempty(REsim)==0
REsim=(round(REsim*10000))/10000;
n=REsim(1); 
j=1;
for i=2:length(REsim)
    if REsim(i-1)~=REsim(i)
        j=j+1;
        n(j)=REsim(i);
    end
end
REsim=[];
end
Esim=n;
mm=length(Esim);
for nn=1:mm
    Esimetricas(nn,l)=Esim(nn);
end


aodd=1;
for codd=1:length(steps)
    Eant(codd)=fsolve(@(Eant) ((sqrt((2*mw*Eant*q)/(hbar^2)))/mw)*(tan((sqrt((2*mw*Eant*q)/(hbar^2)))*Lz(l)/2))^(-1)+(sqrt((2*mb*(Vo-Eant)*q)/(hbar^2)))/mb,steps(codd),options);
    if isreal(Eant(codd))
    REant(aodd)=Eant(codd);
    aodd=aodd+1;
    end
end

if isempty(REant)==0
REant=(round(REant*10000))/10000;
nodd=REant(1); 
jodd=1;
for iodd=2:length(REant)
    if REant(iodd-1)~=REant(iodd)
        jodd=jodd+1;
        nodd(jodd)=REant(iodd);
    end
end
REant=[];
end
Eant=nodd;
mmodd=length(Eant);
for nnodd=1:mmodd
    Eantisimetricas(nnodd,l)=Eant(nnodd);
end



waitbar(l/length(Lz),work)
end 
close(work)

%Mandar a Graficar en un solo axes las sols Simetricas y Antisimetricas
hand=figure(1);
set(hand,'Name','Energy level diagrams for electrons, heavy and light holes in GaAs-GaAlAs quantum wells vs. the GaAs slab thickness.','NumberTitle','off','Color',[0.65 0.81 0.82]);
set(hand,'position',[90,40,1100,800])


[Esimfil Esimcol]=size(Esimetricas);
for ee=1:Esimfil
    subplot(1,3,tipos)
    plot(Lz,Esimetricas(ee,:),'s','MarkerSize',4,'MarkerFaceColor',[0 0 1],'LineWidth',1,'Color',[0.6 0.6 0.6]),axis([0 max(Lz) 3E-3 Vo]);
    if tipos==1
        xlabel('Well width Lz (m)','FontWeight','bold'); ylabel('Electron Energy (eV)','FontWeight','bold');title(['GaAs-Ga_{',num2str(xm),'}','Al_{',num2str(x),'}','As'],'FontWeight','bold');
    elseif tipos==2
        xlabel('Well width Lz (m)','FontWeight','bold'); ylabel('Heavy-Hole Energy (eV)','FontWeight','bold');title(['GaAs-Ga_{',num2str(xm),'}','Al_{',num2str(x),'}','As'],'FontWeight','bold');
    elseif tipos==3
        xlabel('Well width Lz (m)','FontWeight','bold'); ylabel('Light-Hole Energy (eV)','FontWeight','bold');title(['GaAs-Ga_{',num2str(xm),'}','Al_{',num2str(x),'}','As'],'FontWeight','bold');
    end
    hold on
end

[Eantfil Eantcol]=size(Eantisimetricas);
for dd=1:Eantfil
    subplot(1,3,tipos)
    plot(Lz,Eantisimetricas(dd,:),'o','MarkerSize',4,'MarkerFaceColor',[1 0 0],'LineWidth',1,'Color',[0.3 0.3 0.3]),grid on
    hold on
end

end %tipos

else 
    errordlg('0 < x <=0.9','Restrictions');
end


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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x=eval(get(handles.edit1,'string'));
Lz=eval(get(handles.edit2,'string'));
Lz=Lz*1E-10;

if x>0 && x<=0.9 && Lz>=5E-10 && Lz<=160E-10;

hbar=1.0545E-34;
q=1.6021E-19;
mo=9.1093E-31;
xm=1-x;

for tipos=1:3

if tipos==1
    mb=(0.067+0.083*x)*mo;
    mw=0.067*mo;
    Vo=(0.7482)*x;
elseif tipos==2
    mb=(0.45+0.2)*mo;
    mw=0.45*mo;
    Vo=(0.4988)*x;
elseif tipos==3
    mb=(0.082+0.068*x)*mo;
    mw=0.082*mo;
    Vo=(0.4988)*x;
end

options=optimset('TolFun',1E-100,'TolX',1E-100,'MaxIter',100,'MaxFunEvals',100,'Display','off');
steps=linspace(eps,Vo,40);
REsim=[]; REant=[]; Esimetricas=[]; Eantisimetricas=[]; Y=[]; Ya=[]; nodd=[];%para ver si se quitan las broncas

if tipos==1
    work=waitbar(0,'Electron Energy vs. Lz´s');
elseif tipos==2
    work=waitbar(0,'Heavy-hole Energy vs. Lz´s');
elseif tipos==3
    work=waitbar(0,'Light-hole energy vs. Lz´s');
end


for l=1:length(Lz)
    
a=1;
for c=1:length(steps)
    Esim(c)=fsolve(@(Esim) ((sqrt((2*mw*Esim*q)/(hbar^2)))/mw)*tan((sqrt((2*mw*Esim*q)/(hbar^2)))*Lz(l)/2)-(sqrt((2*mb*(Vo-Esim)*q)/(hbar^2)))/mb,steps(c),options);
    if isreal(Esim(c))
    REsim(a)=Esim(c);
    a=a+1;
    end
end

if isempty(REsim)==0
REsim=(round(REsim*10000))/10000;
n=REsim(1); 
j=1;
for i=2:length(REsim)
    if REsim(i-1)~=REsim(i)
        j=j+1;
        n(j)=REsim(i);
    end
end
REsim=[];
end
Esim=n;
mm=length(Esim);
for nn=1:mm
    Esimetricas(nn,l)=Esim(nn);
end

aodd=1;
for codd=1:length(steps)
    Eant(codd)=fsolve(@(Eant) ((sqrt((2*mw*Eant*q)/(hbar^2)))/mw)*(tan((sqrt((2*mw*Eant*q)/(hbar^2)))*Lz(l)/2))^(-1)+(sqrt((2*mb*(Vo-Eant)*q)/(hbar^2)))/mb,steps(codd),options);
    if isreal(Eant(codd))
    REant(aodd)=Eant(codd);
    aodd=aodd+1;
    end
end

if isempty(REant)==0
REant=(round(REant*10000))/10000;
nodd=REant(1); 
jodd=1;
for iodd=2:length(REant)
    if REant(iodd-1)~=REant(iodd)
        jodd=jodd+1;
        nodd(jodd)=REant(iodd);
    end
end
REant=[];
end
Eanti=nodd;
mmodd=length(Eanti);
for nnodd=1:mmodd
    Eantisimetricas(nnodd,l)=Eanti(nnodd);
end

waitbar(l/length(Lz),work)
end
close(work)

%Mandar a Graficar en un solo axes las sols Simetricas y Antisimetricas
hand=figure(2); axes;
set(hand,'Name','Energy levels for electrons, heavy and light holes in a GaAs-GaAlAs quantum well','NumberTitle','off','Color',[0.65 0.81 0.82]);
set(hand,'position',[90,150,1100,800])


if tipos==1
    columna=1; subplot(1,3,columna); xlabel('Well width (m)','FontWeight','Bold'); ylabel('Electron Energy (eV)','FontWeight','Bold'); 
    elseif tipos==2
        columna=2;  subplot(1,3,columna); xlabel('Well width (m)','FontWeight','Bold'); ylabel('Heavy Hole Energy (eV)','FontWeight','Bold'); 
    elseif tipos==3
        columna=3; subplot(1,3,columna); xlabel('Well width (m)','FontWeight','Bold'); ylabel('Ligth Hole Energy (eV)','FontWeight','Bold')
end

axis([-Lz Lz 0 Vo]); grid minor
XX=[Lz/2 Lz/2]; YY=[-1 1]; line(XX,YY,'LineWidth',5,'Color','k')
XXn=[-Lz/2 -Lz/2]; YY=[-1 1]; line(XXn,YY,'LineWidth',5,'Color','k')

X=[-Lz/2 Lz/2];

for lineas=1:length(Esimetricas)
    Ysim=[Esimetricas(lineas) Esimetricas(lineas)];
    line(X,Ysim,'LineWidth',3,'Color','b'); hold on
end

for lineas2=1:length(Eantisimetricas)
    Yant=[Eantisimetricas(lineas2) Eantisimetricas(lineas2)];
    line(X,Yant,'LineWidth',3,'Color','r'); hold on
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
z=linspace(-1.5*Lz,1.5*Lz,300);

for rr=1:length(Esimetricas)

kg=sqrt((2*mb*(Vo-Esimetricas(rr))*q)/(hbar^2));
k=sqrt((2*mw*Esimetricas(rr))*q/(hbar^2));

B=(cos(k*Lz/2))/exp(-kg*Lz/2);

for tt=1:length(z)
    if z(tt)<(-Lz/2)
        Y(rr,tt)=B*exp(kg*z(tt));
    elseif z(tt)>=(-Lz/2) && z(tt)<=(Lz/2)
        Y(rr,tt)=cos(k*z(tt));
    elseif z(tt)>=(Lz/2)
        Y(rr,tt)=B*exp(-kg*z(tt));
    end
end
end

if isempty(Eantisimetricas)==0
for rra=1:length(Eantisimetricas)

kga=sqrt((2*mb*(Vo-Eantisimetricas(rra))*q)/(hbar^2));
ka=sqrt((2*mw*Eantisimetricas(rra))*q/(hbar^2));

Ba=(cos(ka*Lz/2))/exp(-kga*Lz/2);

for tt=1:length(z)
    if z(tt)<(-Lz/2)
        Ya(rra,tt)=Ba*exp(kga*z(tt));
    elseif z(tt)>=(-Lz/2) && z(tt)<=(Lz/2)
        Ya(rra,tt)=cos(ka*z(tt));
    elseif z(tt)>=(Lz/2)
        Ya(rra,tt)=Ba*exp(-kga*z(tt));
    end

end
end
end

hh=figure(3);
set(hh,'Name','Eigenfunctions for electrons, heavy and light holes in a GaAs-GaAlAs quantum well','NumberTitle','off','Color',[0.65 0.81 0.82]);
set(hh,'position',[90,40,1100,600])

if tipos==1
    col=1; titulo='-----ELECTRONS-----';
elseif tipos==2
    col=2; titulo='-----HEAVY HOLES-----';
elseif tipos==3
    col=3; titulo='-----LIGHT HOLES-----';
end
    
subplot(2,3,col)
plot(z,Y,'LineWidth',1.5,'Color','b'),grid on, xlabel('z (m)','FontSize',12,'FontWeight','bold'), ylabel('[a.u]','FontWeight','bold'),title({titulo;'';'Symmetric Solutions'},'FontWeight','bold')
XX=[Lz/2 Lz/2]; YY=[-1 1]; line(XX,YY,'LineWidth',3,'LineStyle',':','Color','k')
XXn=[-Lz/2 -Lz/2]; YY=[-1 1]; line(XXn,YY,'LineWidth',3,'LineStyle',':','Color','k')

if isempty(Ya)==0
subplot(2,3,col+3)
plot(z,Ya,'LineWidth',1.5,'Color','r'),grid on, xlabel('z (m)','FontSize',12,'FontWeight','bold'), ylabel('[a.u]','FontWeight','bold'),title('Antisymmetric Solutions','FontWeight','bold')
XX=[Lz/2 Lz/2]; YY=[-1 1]; line(XX,YY,'LineWidth',3,'LineStyle',':','Color','k')
XXn=[-Lz/2 -Lz/2]; YY=[-1 1]; line(XXn,YY,'LineWidth',3,'LineStyle',':','Color','k')
end
end

else
    errordlg('0 < x <= 0.9  &  5Å <= Lz <= 160Å','Restrictions')
end
%%%