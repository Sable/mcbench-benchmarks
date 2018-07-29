function varargout = FermiLevel(varargin)
%This m-file gives information about some of the semiconductor fundamentals
%namely, the Fermi-Dirac Integral, Energy Bandgap vs. Temperature, Intrinsic
%Carrier Density, and Fermi Level position in Si, Ge, and GaAs as a function
%of temperature and doping concentration (In these figures, the dependence 
%of the Bandgap and Fermi intrinsic level on temperature is also shown). 
%For the calculation of the Fermi level, the charge neutrality equation is 
%solved numerically assuming Fermi-Dirac statistics instead of Maxwell-Boltzmann 
%statistics. For the foregoing reason, the program can be used to calculate
%the Fermi Level position either for nondegenerate or degenerate semiconductors.
%It is posible to change the doping concentration to a specific value in
%Fermi_Level.m (line 9)
%Journals:
%Ref 1: Solid State Electronics, 25, 1067 (1982)
%Ref 2: Semiconductor Physical Electronics, Sheng S. Li. pp 89
%Ref 3: Physica Status Solidi(b) vol. 188, 1995, pp 635-644
%Books:
%Semiconductor Physical Electronics
%Second Edition. Springer
%Sheng S. Li
%Advanced Semiconductor Fundamentals
%Second Edition. Prentice Hall
%Robert F. Pierret

% Edit the above text to modify the response to help FermiLevel

% Last Modified by GUIDE v2.5 20-Aug-2009 13:46:33
% Author: Ernesto Momox Beristain 
% email: emomox@essex.ac.uk
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FermiLevel_OpeningFcn, ...
                   'gui_OutputFcn',  @FermiLevel_OutputFcn, ...
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

global k J mo h gD gA;
k =8.617E-5;
J=1.602E-19;
mo=9.109E-31;
h=6.626E-34;
gD=2; gA=4;

% --- Executes just before FermiLevel is made visible.
function FermiLevel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FermiLevel (see VARARGIN)

% Choose default command line output for FermiLevel
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FermiLevel wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FermiLevel_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%ButonforSilicon
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
menuSiDon=get(handles.popupmenu1,'value');
switch menuSiDon
    case 1
        %no option available
    case 2
        ED=0.034;%Li 
        DonImpu='Li';
    case 3
        ED=0.043;%Sb
        DonImpu='Sb';
    case 4
        ED=0.046;%P
        DonImpu='P';
    case 5
        ED=0.054;%As
        DonImpu='As';
    case 6
        ED=0.071;%Bi
        DonImpu='Bi';
end
menuSiAcc=get(handles.popupmenu2,'value');
switch menuSiAcc
    case 1
        %no option available
    case 2
        EA=0.044;%B
        AccImpu='B';
    case 3
        EA=0.069;%Al
        AccImpu='Al';
    case 4
        EA=0.073;%Ga
        AccImpu='Ga';
    case 5
        EA=0.16;%In
        AccImpu='In';
    case 6
        EA=0.25;%Tl
        AccImpu='Tl';
end
%Fermi_Level(mdn, mdp, ED, EA, Material, EgO, alpha, beta, guess)
Fermi_Level(1.084,0.55,ED,EA,' Silicon',1.17,4.73E-4,636,0.55)
text(611.5,0.509,'Ec'); text(611.5,-0.528,'Ev'); text(611.5,-0.029,'Ei');
text(20.26,0.215,'n-type','FontWeight','bold','FontSize',12,'FontAngle','italic')
text(20.26,0.15,strcat('Donor Impurity: ',DonImpu),'FontWeight','bold');
text(20.26,-0.193,'p-type','FontWeight','bold','FontSize',12,'FontAngle','italic')
text(20.26,-0.26,strcat('Acceptor Impurity: ',AccImpu),'FontWeight','bold');
  
% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


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


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


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

%%ButtonforGe
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
menuGeDon=get(handles.popupmenu5,'value');
switch menuGeDon
    case 1
        %no option available
    case 2
        ED=0.0093;%Li 
        DonImpu='Li';
    case 3
        ED=0.0096;%Sb
        DonImpu='Sb';
    case 4
        ED=0.012;%P
        DonImpu='P';
    case 5
        ED=0.013;%As
        DonImpu='As';
    case 6
        ED=0.18;%S
        DonImpu='S';
end
menuGeAcc=get(handles.popupmenu6,'value');
switch menuGeAcc
    case 1
        %no option available
    case 2
        EA=0.01;%B
        AccImpu='B';
    case 3
        EA=0.01;%Al
        AccImpu='Al';
    case 4
        EA=0.01;%Tl
        AccImpu='Tl';
    case 5
        EA=0.011;%Ga
        AccImpu='Ga';
    case 6
        EA=0.011;%In
        AccImpu='In';
end
%Fermi_Level(mdn, mdp, ED, EA, Material, EgO, alpha, beta, guess)
Fermi_Level(0.561,0.29,ED,EA,' Germanium',0.744,4.77E-4,235,0.35)
text(610.5,0.272,'Ec'); text(610.5,-0.272,'Ev'); text(610.5,-0.03,'Ei');
text(20.26,0.115,'n-type','FontWeight','bold','FontSize',12,'FontAngle','italic')
text(20.26,0.062,strcat('Donor Impurity: ',DonImpu),'FontWeight','bold');
text(20.26,-0.066,'p-type','FontWeight','bold','FontSize',12,'FontAngle','italic')
text(20.26,-0.12,strcat('Acceptor Impurity: ',AccImpu),'FontWeight','bold');

% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


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


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


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

%%ButtonforGaAs
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
menuGaAsDon=get(handles.popupmenu8,'value');
switch menuGaAsDon
    case 1
        %no option available
    case 2
        ED=0.0058;%Si 
        DonImpu='Si';
    case 3
        ED=0.0059;%Se
        DonImpu='Se';
    case 4
        ED=0.006;%Ge
        DonImpu='Ge';
    case 5
        ED=0.006;%S
        DonImpu='S';
    case 6
        ED=0.006;%Sn
        DonImpu='S';
    case 7
        ED=0.03;%Te
        DonImpu='Te';
end
menuGaAsAcc=get(handles.popupmenu7,'value');
switch menuGaAsAcc
    case 1
        %no option available
    case 2
        EA=0.026;%C
        AccImpu='C';
    case 3
        EA=0.028;%Be
        AccImpu='Be';
    case 4
        EA=0.028;%Mg
        AccImpu='Mg';
    case 5
        EA=0.031;%Zn
        AccImpu='Zn';
    case 6
        EA=0.035;%Si
        AccImpu='Si';
    case 7
        EA=0.035;%Cd
        DonImpu='Cd';
end
%Fermi_Level(mdn, mdp, ED, EA, Material, EgO, alpha, beta, guess)
Fermi_Level(0.068,0.47,ED,EA,' Gallium Arsenide',1.519,5.41E-4,204,0.7)
text(604.3,0.6458,'Ec'); text(604.3,-0.6458,'Ev'); text(604.3,0.08,'Ei');
text(10.66,0.18,'n-type','FontWeight','bold','FontSize',12,'FontAngle','italic')
text(10.66,0.13,strcat('Donor Impurity: ',DonImpu),'FontWeight','bold');
text(8.29,-0.12,'p-type','FontWeight','bold','FontSize',12,'FontAngle','italic')
text(8.29,-0.18,strcat('Acceptor Impurity: ',AccImpu),'FontWeight','bold');


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7


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


% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8


% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%ButtonforFermiIntegral
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%FERMI-DIRAC INTEGRAL
%of order 1/2
%This program compares the Fermi Integral of order 1/2 when evaluated with
%the algorithm of Ref 1, Ref 2, and Ref 3.

hand=figure;
set(hand,'Name','Fermi-Dirac Integral','NumberTitle','off','Color',[0.65 0.81 0.82]);
screen=get(0,'ScreenSize');
width=screen(4);
large=screen(3);
set(hand,'position',[50,50,large-750,width-145]);
centerfig

%Ref 1: Solid State Electronics, 25, 1067 (1982)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=-8:0.2:8; %(Greek letter eta)
F=(exp(-n)+3*sqrt(pi/2)*((n+2.13)+((abs(n-2.13)).^2.4+9.6).^(5/12)).^(-3/2)).^-1;
Ref1=semilogy(n,F,'b','LineWidth',3); grid on, axis([-8 8 1E-4 20]),hold on
set(Ref1,'DisplayName','Ref 1');

%Ref 2: Semiconductor Physical Electronics, Sheng S. Li. pp 89
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ind=1:length(n)
    if n(ind)<=-4
        Fermi(ind)=exp(n(ind));
    elseif n(ind)>-4 && n(ind)<1
        Fermi(ind)=1/(exp(-n(ind))+0.27);
    elseif n(ind)>=1 && n(ind)<=4
        Fermi(ind)=(4/(3*sqrt(pi)))*(n(ind)^2+(pi^2)/6)^(3/4);
    else
        Fermi(ind)=(4/(3*sqrt(pi)))*n(ind)^(3/2);
    end
end 
Ref2=semilogy(n,Fermi,'r','LineWidth',2,'LineStyle','--');
set(Ref2,'DisplayName','Ref 2');

%Ref 3: Physica Status Solidi(b) vol. 188, 1995, pp 635-644
%the mfile is available at Matlab Central
%(a minor modification was made to plot the data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

aj=1/2;
eta=-8:0.2:8;
format long e;

for cont=1:length(eta)

%==============================================================
% Evaluation of Trapezoidal sum begins
range=8.;
if eta(cont) > 0.
   range=sqrt(eta(cont)+64.);end;
h=0.5;
nmax=range/h;
sum=0.;
if aj== (-0.5)
   sum=1./(1.+exp(-eta(cont)));end;
for i=1:nmax
   u=i*h;
   ff=2.*(u^(2.*aj+1))/(1.+exp(u*u-eta(cont)));
   sum=sum+ff;end;

%Trapezoidal Summation ends
%==============================================================

% Pole correction for trapezoidal sum begins
pol=0.;
npole=0;
% Fix the starting value of  BK1 to start while loop
bk1=0;
while bk1 <= 14.*pi
   npole=npole+1;
   bk=(2*npole -1)*pi;
   rho=sqrt(eta(cont)*eta(cont)+bk*bk);
   t1=1;
   t2=0;
   if eta(cont) < 0;
      tk=- aj*(atan(-bk/eta(cont))+pi);
   elseif eta(cont) ==0;
      tk=0.5*pi*aj;
   else;
      eta(cont) > 0;
      tk=aj*atan(bk/eta(cont));
   end;
   rk=- (rho^aj);
   tk=tk+0.5*atan(t2/t1);
   if eta(cont) < 0
      rk= -rk;
   end;
   ak=(2.*pi/h)*sqrt(0.5*(rho+eta(cont)));
   bk1=(2.*pi/h)*sqrt(0.5*(rho-eta(cont)));
   if bk1 <= (14.*pi)
   gama=exp(bk1);
   t1=gama*sin(ak+tk)-sin(tk);
   t2=1.-2.*gama*cos(ak)+gama*gama;
   pol=pol+4.*pi*rk*t1/t2;
   end; %ends if loop above
  end; % Top while loop ends
  npole=npole-1;
  fdp=sum*h+pol;
% Program ends with the following output
%==========================================================================
%   disp('Fermi-Dirac Integral Value');
%   disp(fdp/gamma(1+aj));
%   disp('Number of trapezoidal points & number of poles');
%   disp([round(nmax),npole]);
fermiIntegral(cont)=fdp/gamma(1+aj);
end

Ref3=semilogy(eta,fermiIntegral,'g','LineWidth',2,'LineStyle',':');
set(Ref3,'DisplayName','Ref 3');

%Asymtotic approach
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y4=(4/(3*sqrt(pi)))*n.^(3/2);
e1=plot(n,exp(n),'k','LineWidth',2,'LineStyle',':');
e2=plot(n,y4,'k','LineWidth',2,'LineStyle',':');
set(e1,'DisplayName','e^{\eta}');
set(e2,'DisplayName','4/(3sqrt(\pi))\eta^{3/2}');

title('Fermi-Dirac Integral, F_{1/2}(\eta)','FontSize',11,'FontWeight','bold')
xlabel('\eta  [(E_{F}-E_{C})/kT or (E_{V}-E_{F})/kT ]','FontSize',12,'FontWeight','bold')
ylabel('F_{1/2}(\eta)','FontSize',12,'FontWeight','bold')

legend('Location','NorthWest'), clc

%%ButtonforGapsvsT
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Temperature Dependence of Energy Band Gap
%GaAs, Si, Ge
%The temperature dependence of the energy bandgap is determined with the 
%following expression for Eg.
%Eg(T) = Eg(0)-(alfa*T^2)/(T+beta) 

hand=figure;
set(hand,'Name','Energy Band Gap vs Temperature','NumberTitle','off','Color',[0.65 0.81 0.82]);
screen=get(0,'ScreenSize');
width=screen(4);
large=screen(3);
set(hand,'position',[50,50,large-750,width-145]);
centerfig

T=linspace(0,1000,300);%Temperature range (K)

EgGaAs=1.519-(5.41E-4*T.^2)./(T+204);
plot(T,EgGaAs,'g','LineWidth',3), grid on, hold on

EgSi=1.17-(4.73E-4*T.^2)./(T+636);
plot(T,EgSi,'b','LineWidth',3)

EgGe=0.744-(4.77E-4*T.^2)./(T+235);
plot(T,EgGe,'c','LineWidth',3)

legend('GaAs','Si','Ge')
title('Energy Bandgaps of GaAs, Si, and Ge as a function of temperature','FontWeight','Bold')
xlabel('T(K)','FontWeight','Bold'), ylabel('Bandgap E_{g}(eV)','FontWeight','Bold')

%%ButtonforIntrinsic
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%INTRINSIC CARRIER DENSITY
%GaAs, Si, and Ge

T=200:2:2000;
EgGaAs=1.519-(5.41E-4*T.^2)./(T+204);
EgSi=1.17-(4.73E-4*T.^2)./(T+636);
EgGe=0.744-(4.77E-4*T.^2)./(T+235);
mo=9.109E-31;
k=8.61E-5;
%GaAs
mdnGaAs=0.068*mo;
mdpGaAs=0.47*mo;
%Si
mdnSi=1.084*mo;
mdpSi=0.55*mo;
%Ge
mdnGe=0.561*mo;
mdpGe=0.29*mo;
%
hand=figure(4);
set(hand,'Name','Intrinsic Carrier Density','NumberTitle','off','Color',[0.65 0.81 0.82]);
screen=get(0,'ScreenSize');
width=screen(4);
large=screen(3);
set(hand,'position',[50,50,large-400,width-145]);
centerfig
%
subplot(1,2,1)
niGaAs=(2.5E19*(T/300).^(3/2))*(((mdnGaAs*mdpGaAs)/mo^2)^(3/4)).*exp(-EgGaAs./(2*k*T));
semilogy(1000./T,niGaAs,'g','LineWidth',3), grid on
axis([0.5 4.5 1E6 1E20]), 
hold on
%
niSi=(2.5E19*(T/300).^(3/2))*(((mdnSi*mdpSi)/mo^2)^(3/4)).*exp(-EgSi./(2*k*T));
semilogy(1000./T,niSi,'b','LineWidth',3)
%
niGe=(2.5E19*(T/300).^(3/2))*(((mdnGe*mdpGe)/mo^2)^(3/4)).*exp(-EgGe./(2*k*T));
semilogy(1000./T,niGe,'c','LineWidth',3)
%
xlabel('1000/T (K^{-1})','FontWeight','Bold'), ylabel('Intrinsic carrier density n_{i} (cm^{-3})','FontWeight','Bold')
legend('GaAs','Si','Ge')
%
subplot(1,2,2)
semilogy(T,niGaAs,'g','LineWidth',3),axis([200 1600 10 1E20]), grid on, hold on
semilogy(T,niSi,'b','LineWidth',3)
semilogy(T,niGe,'c','LineWidth',3)
xlabel('T (K)','FontWeight','Bold'), ylabel('Intrinsic carrier density n_{i} (cm^{-3})','FontWeight','Bold')
legend('GaAs','Si','Ge','Location','NorthWest')


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
box=msgbox('Help displayed in the Command Window');
pause(4)
close(box)
help FermiLevel