function varargout = Vaporizercalculation(varargin)
% VAPORIZERCALCULATION M-file for Vaporizercalculation.fig
%      VAPORIZERCALCULATION, by itself, creates a new VAPORIZERCALCULATION or raises the existing
%      singleton*.
%
%      H = VAPORIZERCALCULATION returns the handle to a new VAPORIZERCALCULATION or the handle to
%      the existing singleton*.
%
%      VAPORIZERCALCULATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VAPORIZERCALCULATION.M with the given input arguments.
%
%      VAPORIZERCALCULATION('Property','Value',...) creates a new VAPORIZERCALCULATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Vaporizercalculation_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Vaporizercalculation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help Vaporizercalculation

% Last Modified by GUIDE v2.5 30-Nov-2007 12:43:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Vaporizercalculation_OpeningFcn, ...
                   'gui_OutputFcn',  @Vaporizercalculation_OutputFcn, ...
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


% --- Executes just before Vaporizercalculation is made visible.
function Vaporizercalculation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Vaporizercalculation (see VARARGIN)

% Choose default command line output for Vaporizercalculation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Vaporizercalculation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Vaporizercalculation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function Flowrate_Callback(hObject, eventdata, handles)
% hObject    handle to Flowrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Flowrate as text
%        str2double(get(hObject,'String')) returns contents of Flowrate as a double


% --- Executes during object creation, after setting all properties.
function Flowrate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Flowrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Tubedia_Callback(hObject, eventdata, handles)
% hObject    handle to Tubedia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tubedia as text
%        str2double(get(hObject,'String')) returns contents of Tubedia as a double


% --- Executes during object creation, after setting all properties.
function Tubedia_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tubedia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Tubelength_Callback(hObject, eventdata, handles)
% hObject    handle to Tubelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tubelength as text
%        str2double(get(hObject,'String')) returns contents of Tubelength as a double


% --- Executes during object creation, after setting all properties.
function Tubelength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tubelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function TempN2out_Callback(hObject, eventdata, handles)
% hObject    handle to TempN2out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TempN2out as text
%        str2double(get(hObject,'String')) returns contents of TempN2out as a double


% --- Executes during object creation, after setting all properties.
function TempN2out_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TempN2out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Tempairin_Callback(hObject, eventdata, handles)
% hObject    handle to Tempairin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tempairin as text
%        str2double(get(hObject,'String')) returns contents of Tempairin as a double


% --- Executes during object creation, after setting all properties.
function Tempairin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tempairin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Tubethickness_Callback(hObject, eventdata, handles)
% hObject    handle to Tubethickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tubethickness as text
%        str2double(get(hObject,'String')) returns contents of Tubethickness as a double


% --- Executes during object creation, after setting all properties.
function Tubethickness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tubethickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in correlationN2.
function correlationN2_Callback(hObject, eventdata, handles)
% hObject    handle to correlationN2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(hObject,'String');
handles.acN2=contents{get(hObject,'Value')};
guidata(hObject, handles);
    
% Hints: contents = get(hObject,'String') returns correlationN2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from correlationN2


% --- Executes during object creation, after setting all properties.
function correlationN2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to correlationN2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in correlationair.
function correlationair_Callback(hObject, eventdata, handles)
% hObject    handle to correlationair (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(hObject,'String');
handles.acair=contents;%if only one name
%handles.acair=contents{get(hObject,'Value')};%if more than one correlation
guidata(hObject, handles);
% Hints: contents = get(hObject,'String') returns correlationair contents as cell array
%        contents{get(hObject,'Value')} returns selected item from correlationair


% --- Executes during object creation, after setting all properties.
function correlationair_CreateFcn(hObject, eventdata, handles)
% hObject    handle to correlationair (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tubenumber=str2double(get(handles.tubeN,'String'));TubeD=str2double(get(handles.Tubedia,'String'))*1e-2;LengthD=str2double(get(handles.Tubelength,'String'))*.3048;Tubet=str2double(get(handles.Tubethickness,'String'))*1e-3;
finno=str2double(get(handles.finN,'String'));finlength=str2double(get(handles.finlen,'String'))*1e-2;Fint=str2double(get(handles.fint,'String'))*1e-3;kfin=str2double(get(handles.kfin,'String'));
Flowrate=str2double(get(handles.Flowrate,'String'))*1/3600;TempN2outlet=str2double(get(handles.TempN2out,'String'))+273;Tempairin=str2double(get(handles.Tempairin,'String'))+273;
Tubepressure=str2double(get(handles.tubepres,'string'))*1e5;
MaxTensile=str2double(get(handles.maxtenstress,'string'));
try handles.acboiling;
catch
    errordlg('Select a correlation for boiling','Correlation Error');
    return
end
try handles.acN2;
catch
    errordlg('Select a correlation for N2 flow','Correlation Error');
    return
end
try handles.acair;
catch
    errordlg('Select a correlation for air flow','Correlation Error');
    return
end
handles.hoop=round(Tubepressure*(TubeD-2*Tubet)/(2*Tubet));
if handles.hoop<MaxTensile
    handles.decresult=['Tube is safe'];
else
    handles.decresult=['Tube is not safe under given conditions'];
end
N2table=xlsread('NIST Nitrogen thermophysical properties','Sheet1','B3:I72');
airtable=xlsread('NIST Nitrogen thermophysical properties','Sheet1','B79:I88');
N2propT=N2table(:,1);
if ~isempty(find(N2propT==TempN2outlet))
    tmn2out=find(N2propT==TempN2outlet);
    N2out=N2table(tmn2out,:);
    N2out.den=N2out(2);
else
        tn2outlow=find(N2propT<TempN2outlet,1,'last');
        tn2outhigh=find(N2propT>TempN2outlet,1);
        N2outlow=N2table(tn2outlow,:);
        N2outhigh=N2table(tn2outhigh,:);
        if N2outlow(2)==N2outhigh(2)
            N2out.den=N2outlow(2);
        else
        N2out.den=interp1([N2outlow(1),N2outhigh(1)],[N2outlow(2),N2outhigh(2)],TempN2outlet);end                
end
wb=waitbar(0,'Please Wait','Name','Calculation in Progress');
for i=1:1
    TempN2in(i)=-196+273;TempN2out(i)=N2table(find(isnan(N2table),1)-1,1);
    TmN2(i)=(TempN2in(i)+TempN2out(i))/2;%bq=[1 1];
if ~isempty(find(N2propT==TmN2(i)))
    tmn2=find(N2propT==TmN2(i));
    mN2m=N2table(tmn2,:);
    mN2(i).den=mN2m(2);mN2(i).cp=mN2m(3);mN2(i).u=mN2m(4);mN2(i).k=mN2m(5);mN2(i).v=mN2m(6);mN2(i).a=mN2m(7);mN2(i).Pr=mN2m(8);
else
    if TmN2(i)==N2table(find(isnan(N2table),1)-1,1)
        tmn2low=find(N2propT<TmN2(i),1,'last');
        tmn2high=find(N2propT>TmN2(i),1);
        mN2low=N2table(tmn2low+1,:);
        mN2high=N2table(tmn2high-1,:);
else
    tmn2low=find(N2propT<TmN2(i),1,'last');
        tmn2high=find(N2propT>TmN2(i),1);
        mN2low=N2table(tmn2low,:);
        mN2high=N2table(tmn2high,:);
end
        if mN2low(2)==mN2high(2)
            mN2(i).den=mN2low(2);
        else
        mN2(i).den=interp1([mN2low(1),mN2high(1)],[mN2low(2),mN2high(2)],TmN2(i));end
        if mN2low(3)==mN2high(3)
            mN2(i).cp=mN2low(3);
        else
            mN2(i).cp=interp1([mN2low(1),mN2high(1)],[mN2low(3),mN2high(3)],TmN2(i));end
        if mN2low(4)==mN2high(4)
            mN2(i).u=mN2low(4);
        else
            mN2(i).u=interp1([mN2low(1),mN2high(1)],[mN2low(4),mN2high(4)],TmN2(i));end
        if mN2low(5)==mN2high(5)
            mN2(i).k=mN2low(5);
        else
            mN2(i).k=interp1([mN2low(1),mN2high(1)],[mN2low(5),mN2high(5)],TmN2(i));end
        if mN2low(6)==mN2high(6)
            mN2(i).v=mN2low(6);
        else
            mN2(i).v=interp1([mN2low(1),mN2high(1)],[mN2low(6),mN2high(6)],TmN2(i));end
        if mN2low(7)==mN2high(7)
            mN2(i).a=mN2low(7);
        else
            mN2(i).a=interp1([mN2low(1),mN2high(1)],[mN2low(7),mN2high(7)],TmN2(i));end
        if mN2low(8)==mN2high(8)
            mN2(i).Pr=mN2low(8);
        else
            mN2(i).Pr=interp1([mN2low(1),mN2high(1)],[mN2low(8),mN2high(8)],TmN2(i));end
end
ReN2(i)=4*Flowrate*N2out.den/(pi*(TubeD-2*Tubet)*mN2(i).u*1e-6);
f(i)=(0.790*log(ReN2(i))-1.64)^(-2);
switch handles.acN2
    case 'Gnielinski'
NuN2(i)=(f(i)/8*(ReN2(i)-1000)*mN2(i).Pr)/(1+12.7*(f(i)/8)^0.5*(mN2(i).Pr^(2/3)-1));%0.5<Pr<2000 & 3000<Re<5*10^6 (for small to large temperature difference)(can also be applied for rough tubes with f from moody chart)
    case 'Petukhov'
        NuN2(i)=(f(i)/8*ReN2(i)*mN2(i).Pr)/(1.07+12.7*(f(i)/8)^0.5*(mN2(i).Pr^(2/3)-1));%0.5<Pr<2000 & 10^4<Re<5*10^6 (for small to large temperature difference)
    case 'Dittus & Boelter'
        NuN2(i)= 0.023*ReN2(i)^(4/5)*mN2(i).Pr^0.4;%0.7<=Pr<=160;Re>=10000;L/D>=10 (for small to moderate temperature difference)
    case 'Colburn'
        NuN2(i)= 0.023*ReN2(i)^(4/5)*mN2(i).Pr^(1/3);%0.7<=Pr<=160;Re>=10000;L/D>=10 (for small to moderate temperature difference)
    case 'Seban & Shimazaki'
        NuN2(i)= 5 + 0.025*(ReN2(i)*mN2(i).Pr)^0.8;%Re*Pr>100
    case 'Sleicher & Rouse'
        a=0.88-0.24/(4+mN2(i).Pr); b=0.333+0.5*10^(-.6*mN2(i).Pr);
        NuN2(i)= 5 + 0.015*ReN2(i)^a*mN2(i).Pr^b;    
end
hN2(i)=NuN2(i)*mN2(i).k*1e-3/(TubeD-2*Tubet);j=1;
waitbar(i/tubenumber);
Tsurf(i)=Tempairin-1;q(i)=10;Lengthheat=0.2*.3048;Tsurfcheck=[1 1];er=[30 1];hairo=[1 1];
while q(i)>0
    j=1;
    if er(j)<25
        er(j+1)=er(j);
        hairo(j+1)=hairo(j);
        Tsurfcheck(j+1)=Tsurfcheck(j);
    end
    Tmair(i)=(Tsurf(i)+Tempairin)/2;
    if Tmair(i)<=airtable(1,1)+1
        Lengthheat=Lengthheat+.1*.3048;Tsurf(i)=Tempairin-1;Tmair(i)=(Tsurf(i)+Tempairin)/2;
    end
    b=1/Tmair(i);
    airpropT=airtable(:,1);
if ~isempty(find(airpropT==Tmair(i)))
    tmair=find(airpropT==Tmair(i));
    mairm=airtable(tmair,:);
    mair(i).den=mairm(2);mair(i).cp=mairm(3);mair(i).u=mairm(4);mair(i).k=mairm(5);mair(i).v=mairm(6);mair(i).a=mairm(7);mair(i).Pr=mairm(8);
else
        tmairlow=find(airpropT<Tmair(i),1,'last');
        tmairhigh=find(airpropT>Tmair(i),1);
        mairlow=airtable(tmairlow,:);
        mairhigh=airtable(tmairhigh,:);
        if mairlow(2)==mairhigh(2)
            mair(i).den=mairlow(2);
        else
        mair(i).den=interp1([mairlow(1),mairhigh(1)],[mairlow(2),mairhigh(2)],Tmair(i));end
        if mairlow(3)==mairhigh(3)
            mair(i).cp=mairlow(3);
        else
            mair(i).cp=interp1([mairlow(1),mairhigh(1)],[mairlow(3),mairhigh(3)],Tmair(i));end
        if mairlow(4)==mairhigh(4)
            mair(i).u=mairlow(4);
        else
            mair(i).u=interp1([mairlow(1),mairhigh(1)],[mairlow(4),mairhigh(4)],Tmair(i));end
        if mairlow(5)==mairhigh(5)
            mair(i).k=mairlow(5);
        else
            mair(i).k=interp1([mairlow(1),mairhigh(1)],[mairlow(5),mairhigh(5)],Tmair(i));end
        if mairlow(6)==mairhigh(6)
            mair(i).v=mairlow(6);
        else
            mair(i).v=interp1([mairlow(1),mairhigh(1)],[mairlow(6),mairhigh(6)],Tmair(i));end
        if mairlow(7)==mairhigh(7)
            mair(i).a=mairlow(7);
        else
            mair(i).a=interp1([mairlow(1),mairhigh(1)],[mairlow(7),mairhigh(7)],Tmair(i));end
        if mairlow(8)==mairhigh(8)
            mair(i).Pr=mairlow(8);
        else
            mair(i).Pr=interp1([mairlow(1),mairhigh(1)],[mairlow(8),mairhigh(8)],Tmair(i));end
end
Grair(i)=(Lengthheat)^3*9.8*1/Tmair(i)*(Tempairin-Tsurf(i))/((mair(i).v*1e-6)^2);
switch handles.acair    
    case 'LeFevre, Ede'
    Nuair(i)=4/3*(7*Grair(i)*mair(i).Pr^2/(5*(20+21*mair(i).Pr)))^(1/4)+4*(272+315*mair(i).Pr)*Lengthheat/(35*(64+63*mair(i).Pr)*(TubeD));
end
hair(i)=Nuair(i)*mair(i).k*1e-3/(Lengthheat);
finarea=2*finlength*Lengthheat+Fint*Lengthheat+2*finlength*Fint;totalarea=finno*finarea+(pi*TubeD-finno*Fint)*Lengthheat;
finP=2*(Lengthheat+Fint);fintiparea=Lengthheat*Fint;m=(hair(i)*finP/(kfin*fintiparea))^.5;
finq=(hair(i)*finP*kfin*fintiparea)^.5*(Tempairin-Tsurf(i))*(sinh(m*finlength)+hair(i)/(m*kfin)*cosh(m*finlength))/(cosh(m*finlength)+hair(i)/(m*kfin)*sinh(m*finlength));
fineta=finq/(hair(i)*finarea*(Tempairin-Tsurf(i)));
qconvin(i)=hN2(i)*(pi*(TubeD-2*Tubet)*LengthD)*(TempN2out(i)-TempN2in(i))/(log((Tsurf(i)-TempN2in(i))/(Tsurf(i)-TempN2out(i))));
qfin(i)=hair(i)*(finno*fineta*finarea+(totalarea-finno*finarea))*(Tempairin-Tsurf(i));
qconvout(i)=(pi*(TubeD)*LengthD)*hair(i)*(Tempairin-Tsurf(i));%-0.8*5.6e-8*(pi*(TubeD)*LengthD)*(Tempairin^4-Tsurf(i)^4);%((Tempairin-TempN2in(i))-(Tempairin-TempN2out(i)))/(log((Tempairin-TempN2in(i))/(Tempairin-TempN2out(i))));%-0.8*5.6e-8*(Tempairin^4-Tsurf(i)^4);%+(2*pi*LengthD*kfin)/(log(TubeD/(TubeD-2*Tubet)))*2;(Tsurf(i)-(TempN2out(i)+TempN2in(i))/2)
q(i)=qconvin(i)-qfin(i)-qconvout(i);
erq1=Flowrate*N2out.den*(mN2(i).cp*1e3*(TempN2out(i)-TempN2in(i)))-qconvin(i);
erq2=Flowrate*N2out.den*(mN2(i).cp*1e3*(TempN2out(i)-TempN2in(i)))-qfin(i)-qconvout(i);
if abs(erq1)>abs(erq2)
    er(j)=(abs(erq1)-abs(erq2))/abs(erq1)*100;
elseif abs(erq1)<abs(erq2)
    er(j)=(abs(erq2)-abs(erq1))/abs(erq2)*100;
end
bq(j)=q(i);
if q(i)<0 && er(j)<25
    q(i)=10;Tsurface(i)=Tsurf(i);Tsurfcheck(j)=Tsurf(i);Lengthheat=Lengthheat+.1*.3048;Tsurf(i)=Tempairin;hairo(j)=hair(i);
if Tsurfcheck(j)==Tsurfcheck(j+1)
        q(i)=-10;end
end
Tsurf(i)=Tsurf(i)-1;
if Tsurf(i)<=TempN2out(i)-1
if er(j+1)<25 && er(j)>25
        q(i)=-10;
else
    q(i)=10;Tsurface(i)=Tsurf(i);hairo(j)=hair(i);Lengthheat=Lengthheat+.1*.3048;Tsurf(i)=Tempairin-1;end
end
end
Lengthheat=Lengthheat-.1*.3048;QN2total(i)=Flowrate*N2out.den*(mN2(i).cp*(TempN2out(i)-TempN2in(i))+199.1);hair(i)=hairo(j+1);erf(i)=er(j+1);
handles.lengthheat=Lengthheat*39.3701;
Tsurface(i)=Tsurface(i)-273;handles.QN2boil=Flowrate*N2out.den*199.1;
qflux(i)=Flowrate*N2out.den*199.1e3/(pi*(TubeD-2*Tubet)*(LengthD-Lengthheat));
massflux(i)=Flowrate*N2out.den*199.1e3/(pi/4*(TubeD-2*Tubet)^2);
bo=qflux(i)/(massflux(i)*199.1e3);
nann2=find(isnan(N2table),1);
denliq=N2table(nann2-1,2);kliq=N2table(nann2-1,5);uliq=N2table(nann2-1,4);Prliq=N2table(nann2-1,8);
dengas=N2table(nann2+1,2);rp=.5/3.3958;%pressure critical 3.3958MPa
switch handles.acboiling
    case 'Steiner, Taborek'        
        Fm=0.377+.199*log(28.02)+.000028427*28.02^2;%Molecular mass=28.02;
        nf=0.7-0.13*exp(1.105*rp);
        Fpf=2.816*rp^.45+(3.4+1.7/(1-rp^7))*rp^3.7;
        Fnb=Fpf*(qflux(i)/10000)^nf*((TubeD-2*Tubet)/.01)^(-0.4)*Fm;%.01 & 10000 from steiner taborek reference table
        for q=1:2
            x=0.2+0.6*(q-1);
        Ftp=((1-x)^1.5+1.9*x^0.6*(denliq/dengas)^0.35)^1.1;
        hbo(q)=((4380*Fnb)^3+(hN2(i)*Ftp)^3)^(1/3);end        
        handles.hb(i)=round((hbo(1)+hbo(2))/2);
    case 'Kandlikar'
        for q=1:2
            x=0.2+0.6*(q-1);
    hbo(q)=hN2(i)*(1.136*(denliq/dengas)^0.45*x^0.72*(1-x)^0.08+667.2*bo^.7*(1-x)^0.8)*4.7;
    end        
        handles.hb(i)=round((hbo(1)+hbo(2))/2);
    case 'Shah'
        if bo>.0011
                fs=14.7;% shah's constant
            elseif bo<.0011
                fs=15.43;% shah's constant
            end
        for q=1:2
            x=0.2+0.6*(q-1);
        Reliqn2=Flowrate*N2out.den*(1-x)/(pi*(TubeD-2*Tubet)*uliq*1e-6);
        hliqn2= 0.023*Reliqn2^0.8*Prliq^0.4*kliq/(TubeD-2*Tubet);%0.7<=Pr<=160;Re>=10000;L/D>=10 (for small to moderate temperature difference)
        co=((1-x)/x)^0.8*(dengas/denliq)^0.5;
        if co>1 && bo<0.0003
            hnb=hliqn2*230*bo^0.5;
        elseif co>1 && bo<0.001
            hnb=hliqn2*(1+46*bo^0.5);
        elseif co<1 || co>0.1            
            hnb=hliqn2*fs*bo^0.5*exp(2.74*co-.1);
        elseif co<1
            hnb=hliqn2*fs*bo^0.5*exp(2.74*co-.15);
        end
        hcb=hN2(i)*1.8/co;
        if hnb>hcb
            hbo(q)=hnb;
        else
            hbo(q)=hcb;
        end
        end        
        handles.hb(i)=round((hbo(1)+hbo(2))/2);
end
    handles.Tsurfaceboil(i)=round(Flowrate*N2out.den*199.1e3/(handles.hb*pi*(TubeD-2*Tubet)*(LengthD-Lengthheat))+TempN2out(i)-273);
end
%superheating module
for i=2:tubenumber
    wb=waitbar(i/tubenumber);
    TempN2in(i)=TempN2out(i-1);
    TempN2out(i)=TempN2in(i);
    bq=[1 1];
    Q(i)=-10;
    while Q(i)<=0
 if TempN2out(i)>TempN2outlet
    q(i)=100;
    Q(i)=100;
    break
 end
TempN2out(i)=TempN2out(i)+1;
TmN2(i)=(TempN2out(i)+TempN2in(i))/2;
if ~isempty(find(N2propT==TmN2(i)))
    tmn2=find(N2propT==TmN2(i));
    mN2m=N2table(tmn2,:);
    mN2(i).den=mN2m(2);mN2(i).cp=mN2m(3);mN2(i).u=mN2m(4);mN2(i).k=mN2m(5);mN2(i).v=mN2m(6);mN2(i).a=mN2m(7);mN2(i).Pr=mN2m(8);
else
        tmn2low=find(N2propT<TmN2(i),1,'last');
        tmn2high=find(N2propT>TmN2(i),1);
        mN2low=N2table(tmn2low,:);
        mN2high=N2table(tmn2high,:);
        if mN2low(2)==mN2high(2)
            mN2(i).den=mN2low(2);
        else
        mN2(i).den=interp1([mN2low(1),mN2high(1)],[mN2low(2),mN2high(2)],TmN2(i));end
        if mN2low(3)==mN2high(3)
            mN2(i).cp=mN2low(3);
        else
            mN2(i).cp=interp1([mN2low(1),mN2high(1)],[mN2low(3),mN2high(3)],TmN2(i));end
        if mN2low(4)==mN2high(4)
            mN2(i).u=mN2low(4);
        else
            mN2(i).u=interp1([mN2low(1),mN2high(1)],[mN2low(4),mN2high(4)],TmN2(i));end
        if mN2low(5)==mN2high(5)
            mN2(i).k=mN2low(5);
        else
            mN2(i).k=interp1([mN2low(1),mN2high(1)],[mN2low(5),mN2high(5)],TmN2(i));end
        if mN2low(6)==mN2high(6)
            mN2(i).v=mN2low(6);
        else
            mN2(i).v=interp1([mN2low(1),mN2high(1)],[mN2low(6),mN2high(6)],TmN2(i));end
        if mN2low(7)==mN2high(7)
            mN2(i).a=mN2low(7);
        else
            mN2(i).a=interp1([mN2low(1),mN2high(1)],[mN2low(7),mN2high(7)],TmN2(i));end
        if mN2low(8)==mN2high(8)
            mN2(i).Pr=mN2low(8);
        else
            mN2(i).Pr=interp1([mN2low(1),mN2high(1)],[mN2low(8),mN2high(8)],TmN2(i));end
end
ReN2(i)=4*Flowrate*N2out.den/(pi*(TubeD-2*Tubet)*mN2(i).u*1e-6);
f(i)=(0.790*log(ReN2(i))-1.64)^(-2);
switch handles.acN2
    case 'Gnielinski'
NuN2(i)=(f(i)/8*(ReN2(i)-1000)*mN2(i).Pr)/(1+12.7*(f(i)/8)^0.5*(mN2(i).Pr^(2/3)-1));%0.5<Pr<2000 & 3000<Re<5*10^6 (for small to large temperature difference)(can also be applied for rough tubes with f from moody chart)
    case 'Petukhov'
        NuN2(i)=(f(i)/8*ReN2(i)*mN2(i).Pr)/(1.07+12.7*(f(i)/8)^0.5*(mN2(i).Pr^(2/3)-1));%0.5<Pr<2000 & 10^4<Re<5*10^6 (for small to large temperature difference)
    case 'Dittus & Boelter'
        NuN2(i)= 0.023*ReN2(i)^(4/5)*mN2(i).Pr^0.4;%0.7<=Pr<=160;Re>=10000;L/D>=10 (for small to moderate temperature difference)
    case 'Colburn'
        NuN2(i)= 0.023*ReN2(i)^(4/5)*mN2(i).Pr^(1/3);%0.7<=Pr<=160;Re>=10000;L/D>=10 (for small to moderate temperature difference)
    case 'Seban & Shimazaki'
        NuN2(i)= 5 + 0.025*(ReN2(i)*mN2(i).Pr)^0.8;%Re*Pr>100
    case 'Sleicher & Rouse'
        a=0.88-0.24/(4+mN2(i).Pr); b=0.333+0.5*10^(-.6*mN2(i).Pr);
        NuN2(i)= 5 + 0.015*ReN2(i)^a*mN2(i).Pr^b;    
end
hN2(i)=NuN2(i)*mN2(i).k*1e-3/(TubeD-2*Tubet);
Tsurf(i)=Tempairin-1;q(i)=10;er=[30 1];
while q(i)>0
    j=1;
    if bq(j)<=0
        bq(j+1)=bq(j);end
    Tmair(i)=(Tsurf(i)+Tempairin)/2;
    b=1/Tmair(i);
    airpropT=airtable(:,1);
if ~isempty(find(airpropT==Tmair(i)))
    tmair=find(airpropT==Tmair(i));
    mairm=airtable(tmair,:);
    mair(i).den=mairm(2);mair(i).cp=mairm(3);mair(i).u=mairm(4);mair(i).k=mairm(5);mair(i).v=mairm(6);mair(i).a=mairm(7);mair(i).Pr=mairm(8);
else
        tmairlow=find(airpropT<Tmair(i),1,'last');
        tmairhigh=find(airpropT>Tmair(i),1);
        mairlow=airtable(tmairlow,:);
        mairhigh=airtable(tmairhigh,:);
        if mairlow(2)==mairhigh(2)
            mair(i).den=mairlow(2);
        else
        mair(i).den=interp1([mairlow(1),mairhigh(1)],[mairlow(2),mairhigh(2)],Tmair(i));end
        if mairlow(3)==mairhigh(3)
            mair(i).cp=mairlow(3);
        else
            mair(i).cp=interp1([mairlow(1),mairhigh(1)],[mairlow(3),mairhigh(3)],Tmair(i));end
        if mairlow(4)==mairhigh(4)
            mair(i).u=mairlow(4);
        else
            mair(i).u=interp1([mairlow(1),mairhigh(1)],[mairlow(4),mairhigh(4)],Tmair(i));end
        if mairlow(5)==mairhigh(5)
            mair(i).k=mairlow(5);
        else
            mair(i).k=interp1([mairlow(1),mairhigh(1)],[mairlow(5),mairhigh(5)],Tmair(i));end
        if mairlow(6)==mairhigh(6)
            mair(i).v=mairlow(6);
        else
            mair(i).v=interp1([mairlow(1),mairhigh(1)],[mairlow(6),mairhigh(6)],Tmair(i));end
        if mairlow(7)==mairhigh(7)
            mair(i).a=mairlow(7);
        else
            mair(i).a=interp1([mairlow(1),mairhigh(1)],[mairlow(7),mairhigh(7)],Tmair(i));end
        if mairlow(8)==mairhigh(8)
            mair(i).Pr=mairlow(8);
        else
            mair(i).Pr=interp1([mairlow(1),mairhigh(1)],[mairlow(8),mairhigh(8)],Tmair(i));end
end
Grair(i)=(LengthD)^3*9.8*1/Tmair(i)*(Tempairin-Tsurf(i))/((mair(i).v*1e-6)^2);
switch handles.acair    
    case 'LeFevre, Ede'
    Nuair(i)=4/3*(7*Grair(i)*mair(i).Pr^2/(5*(20+21*mair(i).Pr)))^(1/4)+4*(272+315*mair(i).Pr)*LengthD/(35*(64+63*mair(i).Pr)*(TubeD));
end
hair(i)=Nuair(i)*mair(i).k*1e-3/(LengthD);
finarea=2*finlength*LengthD+Fint*LengthD+2*finlength*Fint;totalarea=finno*finarea+(pi*TubeD-finno*Fint)*LengthD;
finP=2*(LengthD+Fint);fintiparea=LengthD*Fint;m=(hair(i)*finP/(kfin*fintiparea))^.5;
finq=(hair(i)*finP*kfin*fintiparea)^.5*(Tempairin-Tsurf(i))*(sinh(m*finlength)+hair(i)/(m*kfin)*cosh(m*finlength))/(cosh(m*finlength)+hair(i)/(m*kfin)*sinh(m*finlength));
fineta=finq/(hair(i)*finarea*(Tempairin-Tsurf(i)));
qconvin(i)=hN2(i)*(pi*(TubeD-2*Tubet)*LengthD)*(TempN2out(i)-TempN2in(i))/(log((Tsurf(i)-TempN2in(i))/(Tsurf(i)-TempN2out(i))));
qfin(i)=hair(i)*(finno*fineta*finarea+(totalarea-finno*finarea))*(Tempairin-Tsurf(i));
qconvout(i)=(pi*(TubeD)*LengthD)*hair(i)*(Tempairin-Tsurf(i));
q(i)=qconvin(i)-qfin(i)-qconvout(i);
erq1=Flowrate*N2out.den*(mN2(i).cp*1e3*(TempN2out(i)-TempN2in(i)))-qconvin(i);
erq2=Flowrate*N2out.den*(mN2(i).cp*1e3*(TempN2out(i)-TempN2in(i)))-qfin(i)-qconvout(i);
if abs(erq1)>abs(erq2)
   er(j)=(abs(erq1)-abs(erq2))/abs(erq1)*100;
elseif abs(erq1)<abs(erq2)
    er(j)=(abs(erq2)-abs(erq1))/abs(erq2)*100;
end
bq(j)=q(i);
if bq(j)<=0% && er(j)<25
    if TempN2out(i)>TempN2outlet
    q(i)=-10;
    Q(i)=10;
    break
    end
    hN2o(i)=hN2(i);
    hairo(i)=hair(i);   
 Tsurface(i)=Tsurf(i);
    q(i)=-10;Q(i)=-10;er(i)=er(j);
end
Tsurf(i)=Tsurf(i)-1;
if Tsurf(i)<=TempN2out(i)+1
        q(i)=-10;
        Q(i)=-10;end
if Tsurf(i)<=TempN2out(i)+1
if bq(j+1)<=0 && bq(j)>0 
        q(i)=-10;
        Q(i)=10;
else
    q(i)=-10;
    Q(i)=-10;end
end
end
    end
    hair(i)=hairo(i);hN2(i)=hN2o(i);
    erq1=Flowrate*N2out.den*(mN2(i).cp*1e3*(TempN2out(i)-TempN2in(i)))-hN2(i)*(pi*(TubeD-2*Tubet)*LengthD)*(TempN2out(i)-TempN2in(i))/(log((Tsurface(i)-TempN2in(i))/(Tsurface(i)-TempN2out(i))));
erq2=Flowrate*N2out.den*(mN2(i).cp*1e3*(TempN2out(i)-TempN2in(i)))-hair(i)*(finno*fineta*finarea+(totalarea-finno*finarea))*(Tempairin-Tsurface(i))-(pi*(TubeD)*LengthD)*hair(i)*(Tempairin-Tsurface(i));
if abs(erq1)>abs(erq2)
    erf(i)=(abs(erq1)-abs(erq2))/abs(erq1)*100;
elseif abs(erq1)<abs(erq2)
    erf(i)=(abs(erq2)-abs(erq1))/abs(erq2)*100;
end
    TempN2out(i)=TempN2out(i)-1;QN2total(i)=Flowrate*N2out.den*(mN2(i).cp*(TempN2out(i)-TempN2in(i)));
try TempN2out(i)>TempN2outlet;
Tsurface(i)=Tsurface(i)-273;
catch
    Tsurface(i)=0;hair(i)=0;hN2(i)=0;QN2total(i)=0;
end
end
%superheating module end
handles.QN2totala=round(QN2total*1e3)/1e3;handles.TempN2outa=round(TempN2out)-273;handles.TempN2ina=round(TempN2in)-273;handles.htN2a=round(hN2);handles.htaira=round(hair);handles.Tsurfacea=round(Tsurface);handles.errorr=round(erf);
for j=1:i
    strrespop(j)={['Results Tube ' num2str(j)]};
end
handles.strrespop=strrespop';graphvarmenu={'Tube No.';'Qtube';'Tinlet';'Toutlet';'Tsurface';'hN2';'hair';'Error'};
set(handles.resultpop,'string',strrespop');set(handles.resultpop,'enable','on');set(handles.graphvmenu,'String',graphvarmenu);
set(handles.varsx,'enable','inactive');set(handles.varsy,'enable','inactive');set(handles.variay,'enable','on')
set(handles.graphvmenu,'enable','on');set(handles.variax,'enable','on');
set(handles.resultfig,{'Visible' 'Xcolor' 'Ycolor' 'Xtick' 'Ytick'},{'on' 'w','w',[],[]});
close(wb);
axes(handles.resultfig);
cla;
guidata(hObject, handles);
function fint_Callback(hObject, eventdata, handles)
% hObject    handle to fint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.finthickness=str2double(get(hObject,'String'));
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of fint as text
%        str2double(get(hObject,'String')) returns contents of fint as a double


% --- Executes during object creation, after setting all properties.
function fint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --------------------------------------------------------------------
function newcalc_Callback(hObject, eventdata, handles)
% hObject    handle to newcalc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.tubeN,'String','0');set(handles.Tubedia,'String','0');set(handles.Tubelength,'String','0');set(handles.Tubethickness,'String','0');set(handles.tubepres,'String','0');set(handles.maxtenstress,'String','0');
set(handles.finN,'String','0');set(handles.fint,'String','0');set(handles.finlen,'String','0');set(handles.kfin,'String','0');
set(handles.Flowrate,'String','0');set(handles.TempN2out,'String','0');set(handles.Tempairin,'String','0');
axes(handles.resultfig);cla;set(handles.resultfig,'visible','off');set(handles.resultpop,'string',' ');set(handles.resultpop,'enable','off');
set(handles.varsx,'enable','off');set(handles.varsx,'string','');set(handles.varsy,'enable','off');set(handles.varsy,'string','');set(handles.variay,'enable','off');
set(handles.butplot,'enable','off');set(handles.graphvmenu,'string','');set(handles.graphvmenu,'enable','off');set(handles.variax,'enable','off');
% --------------------------------------------------------------------
function loaddr_Callback(hObject, eventdata, handles)
% hObject    handle to loaddr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.mat';'*.*'},'Load');
loadd=load('-mat',filename);
set(handles.tubeN,'String',loadd.tubeno);set(handles.Tubedia,'String',loadd.dia);set(handles.Tubelength,'String',loadd.tubelength);set(handles.Tubethickness,'String',loadd.tubethickness);set(handles.tubepres,'String',loadd.tubepress);set(handles.maxtenstress,'string',loadd.tensilest);
set(handles.finN,'String',loadd.finnum);set(handles.fint,'String',loadd.finthickness);set(handles.finlen,'String',loadd.finlength);set(handles.kfin,'String',loadd.fink);
set(handles.Flowrate,'String',loadd.Flowrate);set(handles.TempN2out,'String',loadd.tempN2outlet);set(handles.Tempairin,'String',loadd.tempairinlet);
set(handles.resultpop,'String',loadd.tubename);set(handles.resultpop,'enable','on');
set(handles.resultfig,{'Visible' 'Xcolor' 'Ycolor' 'Xtick' 'Ytick'},{'on' 'w','w',[],[]});
graphvarmenu={'Tube No.';'Qtube';'Tinlet';'Toutlet';'Tsurface';'hN2';'hair';'Error'};
set(handles.graphvmenu,'String',graphvarmenu);set(handles.varsx,'enable','inactive');set(handles.varsy,'enable','inactive');set(handles.variay,'enable','on')
set(handles.graphvmenu,'enable','on');set(handles.variax,'enable','on');
handles.hoop=loadd.hoopst;handles.decresult=loadd.dectube;handles.lengthheat=loadd.lengthheat;
handles.QN2boil=loadd.qboil;handles.Tsurfaceboil=loadd.tsurfboil;handles.hb=loadd.hboil;
handles.QN2totala=loadd.qtotal;handles.TempN2outa=loadd.tempout;handles.errorr=loadd.errorr;
handles.TempN2ina=loadd.tempin;handles.TempN2outa=loadd.tempout;handles.htN2a=loadd.shn2;
handles.htaira=loadd.shair;handles.Tsurfacea=loadd.tsurface;
guidata(hObject, handles);
% --------------------------------------------------------------------
function savedr_Callback(hObject, eventdata, handles)
% hObject    handle to savedr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saved.tubeno=get(handles.tubeN,'String');saved.dia=get(handles.Tubedia,'String');
saved.tubelength=get(handles.Tubelength,'String');saved.tubethickness=get(handles.Tubethickness,'String');
saved.tubepress=get(handles.tubepres,'string');saved.tensilest=get(handles.maxtenstress,'string');
saved.finnum=get(handles.finN,'String');saved.finthickness=get(handles.fint,'String');
saved.finlength=get(handles.finlen,'String');saved.fink=get(handles.kfin,'String');
saved.Flowrate=get(handles.Flowrate,'String');saved.tempN2outlet=get(handles.TempN2out,'String');
saved.tempairinlet=get(handles.Tempairin,'String');saved.errorr=handles.errorr;
saved.hoopst=handles.hoop;saved.dectube=handles.decresult;
saved.tubename=handles.strrespop;
saved.qboil=handles.QN2boil;saved.tsurfboil=handles.Tsurfaceboil;saved.hboil=handles.hb;saved.lengthheat=handles.lengthheat;
saved.qtotal=handles.QN2totala;saved.tempout=handles.TempN2outa;
saved.tempin=handles.TempN2ina;saved.tempout=handles.TempN2outa;saved.shn2=handles.htN2a;
saved.shair=handles.htaira;saved.tsurface=handles.Tsurfacea;
[filename, pathname] = uiputfile({'*.mat';'*.*'},'Save');
save(filename,'-struct','saved')


function tubepres_Callback(hObject, eventdata, handles)
% hObject    handle to tubepres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tubepres as text
%        str2double(get(hObject,'String')) returns contents of tubepres as a double


% --- Executes during object creation, after setting all properties.
function tubepres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tubepres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function maxtenstress_Callback(hObject, eventdata, handles)
% hObject    handle to maxtenstress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxtenstress as text
%        str2double(get(hObject,'String')) returns contents of maxtenstress as a double


% --- Executes during object creation, after setting all properties.
function maxtenstress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxtenstress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on selection change in resultpop.
function resultpop_Callback(hObject, eventdata, handles)
% hObject    handle to resultpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.resultfig);
cla;
tubes=get(hObject,'String');tubename=tubes{get(hObject,'Value')};
for j=1:length(tubes)
    if strmatch(tubes{j},tubename,'exact')
        break;end
end
axis([-4 8 -4 15]);
hold on
fill([1 1 3 3],[0 10 10 0],'b');
fill([3.3 3.3 4 4],[0 10 10 0],[1 0.631 0.404],'LineStyle','none');
fill([3 3 3.3 3.3],[0 10 10 0],[0.753 0.753 0.753],{'LineStyle' 'LineWidth'},{'--' 2});
text(2,14,['Tube Number ' num2str(j)],{'HorizontalAlignment' 'Fontweight'},{'center' 'bold'})
text(2,12,['Q_{tube}=' num2str(handles.QN2totala(j)) 'kW    Hoop Stress=' num2str(handles.hoop/1e3) 'kPa' '(' handles.decresult ')'],{'HorizontalAlignment' 'Fontsize'},{'center' 8});
text(-1.5,5,['h_{N2}=' num2str(handles.htN2a(j)) 'W/m^{2}K'],{'HorizontalAlignment' 'Fontsize'},{'center' 8});text(6,7,['h_{air}=' num2str(handles.htaira(j)) 'W/m^{2}K'],{'HorizontalAlignment' 'Fontsize'},{'center' 8});
text(-1.5,4,'\uparrow  \uparrow  \uparrow','HorizontalAlignment','center');text(6,6,'\downarrow \downarrow \downarrow ','HorizontalAlignment','center');
text(1,0,['T_{inlet}=' num2str(handles.TempN2ina(j)) '\circC\rightarrow'],{'HorizontalAlignment' 'Fontsize'},{'right' 8});text(1,9.9,['T_{outlet}=' num2str(handles.TempN2outa(j)) '\circC\rightarrow'],{'HorizontalAlignment' 'Fontsize'},{'right' 8});text(4,2.7,['\leftarrowT_{surface}=' num2str(handles.Tsurfacea(j)) '\circC'],'fontsize',8);
line([0.95 0.95],[-0.5 10.5],'Color','k','LineStyle','-.','LineWidth',2);
if j==1
for k=1:6
a=0.5+0.5*(k-1);
line([1 3],[a a],'Color','k','LineStyle','-','LineWidth',2);
end
for k=1:4
    a=a+0.5;
    line([1 3],[a a],'Color','k','LineStyle','--','LineWidth',2);
end
while a<9
    a=a+0.5;
    line([1 3],[a a],'Color','k','LineStyle',':','LineWidth',2);
end
text(4,9,['\leftarrowT_{surface}=' num2str(handles.Tsurfaceboil) '\circC'],'Fontsize',8);
text(0.8,7,['h_{boiling}=' num2str(handles.hb) 'W/m^{2}K'],{'HorizontalAlignment' 'Fontsize'},{'right' 8});
text(2.3,-1.5,['Subcooled Length = ' num2str(handles.lengthheat) ' inch'],{'HorizontalAlignment' 'Fontsize'},{'Center' 8});
end
hold off
% Hints: contents = get(hObject,'String') returns resultpop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from resultpop


% --- Executes during object creation, after setting all properties.
function resultpop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resultpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on selection change in correlationboiling.
function correlationboiling_Callback(hObject, eventdata, handles)
% hObject    handle to correlationboiling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(hObject,'String');
handles.acboiling=contents{get(hObject,'Value')};
guidata(hObject, handles);
% Hints: contents = get(hObject,'String') returns correlationboiling contents as cell array
%        contents{get(hObject,'Value')} returns selected item from correlationboiling


% --- Executes during object creation, after setting all properties.
function correlationboiling_CreateFcn(hObject, eventdata, handles)
% hObject    handle to correlationboiling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function tubeN_Callback(hObject, eventdata, handles)
% hObject    handle to tubeN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tubeN as text
%        str2double(get(hObject,'String')) returns contents of tubeN as a double


% --- Executes during object creation, after setting all properties.
function tubeN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tubeN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function finN_Callback(hObject, eventdata, handles)
% hObject    handle to finN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of finN as text
%        str2double(get(hObject,'String')) returns contents of finN as a double


% --- Executes during object creation, after setting all properties.
function finN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function finlen_Callback(hObject, eventdata, handles)
% hObject    handle to finlen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of finlen as text
%        str2double(get(hObject,'String')) returns contents of finlen as a double


% --- Executes during object creation, after setting all properties.
function finlen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finlen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end





function kfin_Callback(hObject, eventdata, handles)
% hObject    handle to kfin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kfin as text
%        str2double(get(hObject,'String')) returns contents of kfin as a double


% --- Executes during object creation, after setting all properties.
function kfin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kfin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --------------------------------------------------------------------
function expexcel_Callback(hObject, eventdata, handles)
% hObject    handle to expexcel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
boilxcl={'boiling',handles.TempN2ina(1),handles.TempN2outa(1),handles.Tsurfaceboil, round(handles.QN2boil) handles.hb};
for i=1:length(handles.TempN2ina)
tubexcl(i,:)=[i,handles.TempN2ina(i),handles.TempN2outa(i),handles.Tsurfacea(i),handles.QN2totala(i) handles.htN2a(i) handles.htaira(i) handles.errorr(i)];
end
xlswrite('Calculation Results',boilxcl,'sheet1',['A2:F2']);
xlswrite('Calculation Results',tubexcl,'sheet1',['A3:H' num2str(length(handles.TempN2ina)+2)]);

% --------------------------------------------------------------------
function exptex_Callback(hObject, eventdata, handles)
% hObject    handle to exptex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Create or verify a valid file name.
[fname,dname]=uiputfile('*.doc','Save As');
  if isequal(fname,0), return, end
  filespec=fullfile(dname,fname);
[dname,fname,fext]=fileparts(filespec);

% Start a session with MSWord.
wrd=actxserver('Word.Application');

% Open or create a document.
doc=invoke(wrd.Documents,'Add');

% Insert some text at the end of the document.
myrange=doc.Content;
resstrhead=['Tube' '  Qtube ' '       Tinlet ' '       Toutlet ' '    Tsurface ' '      hN2 ' '        hair        ' ' Error'];
resstrunit=['          ' '  (kW) ' '             (C)   ' '           (C)    ' '        (C)   ' '    (W/m2K)   ' '(W/m2K)' '    (%)'];
invoke(myrange,'InsertAfter',resstrhead);
myrange.InsertParagraphAfter;
invoke(myrange,'InsertAfter',resstrunit);
myrange.InsertParagraphAfter;
for i=1:length(handles.TempN2ina)
resnum(i,:)=[i  handles.QN2totala(i) handles.TempN2ina(i) handles.TempN2outa(i) handles.Tsurfacea(i) handles.htN2a(i) handles.htaira(i) handles.errorr(i)];end
resstr=num2str(resnum);
for i=1:length(handles.TempN2ina)
invoke(myrange,'InsertAfter',resstr(i,:));
myrange.InsertParagraphAfter;
end

% Save and close the document.
invoke(doc,'SaveAs',filespec,1);
doc.Close;

% Quit Word and close the server connection.
wrd.Quit;
delete(wrd);




% --- Executes on selection change in graphvmenu.
function graphvmenu_Callback(hObject, eventdata, handles)
% hObject    handle to graphvmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(hObject,'String');
handles.variablesel=contents{get(hObject,'Value')};
guidata(hObject,handles);
% Hints: contents = get(hObject,'String') returns graphvmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from graphvmenu


% --- Executes during object creation, after setting all properties.
function graphvmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to graphvmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in variax.
function variax_Callback(hObject, eventdata, handles)
% hObject    handle to variax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try handles.variablesel;
if strcmp(get(handles.varsy,'string'),'') || ~strcmp(get(handles.varsy,'string'),handles.variablesel)
set(handles.varsx,'string',handles.variablesel);
switch handles.variablesel
    case 'Qtube'
    handles.plotx=handles.QN2totala;
    handles.labelx='Q_{tube} (kW)';
    case 'Toutlet'
        handles.plotx=handles.TempN2outa;
        handles.labelx='Tube Outlet Temperature (\circC)';
    case 'Tinlet'
        handles.plotx=handles.TempN2ina;
        handles.labelx='Tube Inlet Temperature (\circC)';
    case 'hN2'
        handles.plotx=handles.htN2a;
        handles.labelx='h_{N2} (W/m^2K)';
    case 'hair'
        handles.plotx=handles.htaira;
        handles.labelx='h_{air} (W/m^2K)';
    case 'Tsurface'
        handles.plotx=handles.Tsurfacea;
        handles.labelx='Surface Temperature (\circC)';
    case 'Tube No.'
        handles.plotx=[1:length(handles.TempN2outa)];
        handles.labelx='Tube Number';
    case 'Error'
        handles.plotx=handles.errorr;
        handles.labelx='Error (%)';
end
elseif strcmp(get(handles.varsy,'string'),handles.variablesel)
    set(handles.varsx,'string',handles.variablesel);handles.plotx=handles.ploty;
    handles.labelx=handles.labely;
    handles.ploty=[];handles.labely='';set(handles.varsy,'string','');
end
try ~isempty(handles.plotx) && ~isempty(handles.ploty);
    set(handles.butplot,'enable','on');
end
catch
    errordlg('Select a Variable','Error');
    return
end
guidata(hObject,handles);
% --- Executes on button press in variay.
function variay_Callback(hObject, eventdata, handles)
% hObject    handle to variay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try handles.variablesel;
if strcmp(get(handles.varsx,'string'),'') || ~strcmp(get(handles.varsx,'string'),handles.variablesel)
set(handles.varsy,'string',handles.variablesel);
switch handles.variablesel
    case 'Qtube'
    handles.ploty=handles.QN2totala;
    handles.labely='Q_{tube} (kW)';
    case 'Toutlet'
        handles.ploty=handles.TempN2outa;
        handles.labely='Tube Outlet Temperature (\circC)';
    case 'Tinlet'
        handles.ploty=handles.TempN2ina;
        handles.labely='Tube Inlet Temperature (\circC)';
    case 'hN2'
        handles.ploty=handles.htN2a;
        handles.labely='h_{N2} (W/m^2K)';
    case 'hair'
        handles.ploty=handles.htaira;
        handles.labely='h_{air} (W/m^2K)';
    case 'Tsurface'
        handles.ploty=handles.Tsurfacea;
        handles.labely='Surface Temperature (\circC)';
    case 'Tube No.'
        handles.ploty=[1:length(handles.TempN2outa)];
        handles.labely='Tube Number';        
    case 'Error'
        handles.ploty=handles.errorr;
        handles.labely='Error (%)';
end
elseif strcmp(get(handles.varsx,'string'),handles.variablesel)
    set(handles.varsy,'string',handles.variablesel);handles.ploty=handles.plotx;
    handles.labely=handles.labelx;
    handles.plotx=[];handles.labelx='';set(handles.varsx,'string','');
end
try ~isempty(handles.plotx) && ~isempty(handles.ploty);
    set(handles.butplot,'enable','on');
end
catch
    errordlg('Select a Variable','Error');
    return
end
guidata(hObject,handles);


function varsx_Callback(hObject, eventdata, handles)
% hObject    handle to varsx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of varsx as text
%        str2double(get(hObject,'String')) returns contents of varsx as a double


% --- Executes during object creation, after setting all properties.
function varsx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to varsx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function varsy_Callback(hObject, eventdata, handles)
% hObject    handle to varsy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of varsy as text
%        str2double(get(hObject,'String')) returns contents of varsy as a double


% --- Executes during object creation, after setting all properties.
function varsy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to varsy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



% --- Executes on button press in butplot.
function butplot_Callback(hObject, eventdata, handles)
% hObject    handle to butplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try handles.h;
    close(handles.h);
end
handles.h=figure;
plot(handles.plotx,handles.ploty);box off
xlabel(handles.labelx);ylabel(handles.labely);
title([handles.labelx ' Vs ' handles.labely]);
guidata(hObject,handles);

function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to varsy (see GCBO)

function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to varsy (see GCBO)