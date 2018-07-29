function varargout = FILTROS(varargin)
%==========================================================================
% By: Frank Maldonado
%     Juan Pablo Ramón
% =========================================================================
 
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @FILTROS_OpeningFcn, ...
    'gui_OutputFcn',  @FILTROS_OutputFcn, ...
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
 
 
% --- Executes just before FILTROS is made visible.
function FILTROS_OpeningFcn(hObject, eventdata, handles, varargin)
% _________________________________________________________________________
% Centering the GUI interface
scrsz=get(0,'ScreenSize');
pos_a=get(gcf,'Position');
xr=scrsz(3)-pos_a(3);
xp=round(xr/2);
yr=scrsz(4)-pos_a(4);
yp=round(yr/2);
set(gcf,'Position',[xp yp pos_a(3) pos_a(4)]);
%Adding a image 
a=imread('fondo.png');
image(a);
axis off;
% _________________________________________________________________________
set(handles.orden,'Visible','off');%Makes invisible the static text
%"Filter Order”, and will be only visible just after the "Enter" push button
% has been clicked.
set(handles.ordenfiltro,'Visible','off');%Makes invisible the edit text
%that is in front of "Filter Order", which tag is "ordenfiltro" and will be
% only visible just after the "Enter" push button has been clicked.
set(handles.aplicar,'Visible','off');%Makes invisible the "Applied in Real
% Time" push button, and will be only visible just after the "Enter" push
% button has been clicked.
% _________________________________________________________________________
% We set invisible the static texts "Fpb2"y "Fsb2" as also the edit text
% that are in front of these, which tags are "p2" y "s2".Because these are
% only needed when the type filter is  bandstop or bandpaas and when the
% program starts the lowpass filter is select by default.
set(handles.Fpb2,'Visible','off');%
set(handles.Fsb2,'Visible','off');%
set(handles.p2,'Visible','off');%
set(handles.s2,'Visible','off');%
handles.output = hObject;
guidata(hObject, handles);
 
% --- Outputs from this function are returned to the command line.
function varargout = FILTROS_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;
% _________________________________________________________________________
 
% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% We set invisible the static texts "Fpb2"y "Fsb2" as also the edit text
% that are in front of these, which tags are "p2" y "s2". These only will be
% visible when  a bandstop or bandpaas fliter be selected.
lista2 = get(handles.popupmenu2, 'Value');%We get a number depending on the
% selection of the pop menu:
% 1 if is a lowpass filter
% 2 if is a highpass filter
% 3 if is a bandpass filter
% 4 if is a bandstop filter
if (lista2==1 || lista2==2)
    set(handles.Fpb2,'Visible','off');
    set(handles.Fsb2,'Visible','off');
    set(handles.p2,'Visible','off');
    set(handles.s2,'Visible','off');
else
    set(handles.Fpb2,'Visible','on');
    set(handles.Fsb2,'Visible','on');
    set(handles.p2,'Visible','on');
    set(handles.s2,'Visible','on');
end
guidata(hObject,handles);
 
% --- Executes on button press in aplicar.
function aplicar_Callback(hObject, eventdata, handles)
TIEMPO_REAL % Opens TIEMPO_REAL GUI interface.
close FILTROS% Close the present GUI interface FILTROS
 
 
 
function Aceptar_Callback(hObject, eventdata, handles)
global a b fsx%This are the global variables, used to export data
% to  "TIEMPO_REAL" GUI interface, where:
% (a)is numerator and (b)denominator of the filter transfer function.
% (fsx) is the sample frequency.
% _________________________________________________________________________
% To make a directly use of the handles, we have to make sure that in the
% property inspector, of each handle used, in the section of "Callback"
% and "CreateFcn" be erased, to ensure these features and avoid any mistake review the handles properties in the GUI file TIEMPO_REAL.
% _________________________________________________________________________
%"str2double" Converts a string to double-precision value
% In this section we get the values entered
fsx=str2double(get(handles.Fs,'String'));
fpbx=str2double(get(handles.Fpb1,'String'));%
fpb2x=str2double(get(handles.Fpb2,'String'));%
fsbx=str2double(get(handles.Fsb1,'String'));%
fsb2x=str2double(get(handles.Fsb2,'String'));%
Rp=str2double(get(handles.rpl,'String'));%
As=str2double(get(handles.asl,'String'));%
% _________________________________________________________________________
% In this section we display some errors and set some values, when some
% wrong values are entered; obviously you can add any condition to avoid that
% an error be displayed in the command window.
if (fsx<8000 || isnan(fsx)||fsx>44100)%In general the sound cards support
    %     frequencies from 8000 to 44100.
    errordlg('Invalid Sample Rate value (Range 8000-44100) ','ERROR');
    set(handles.Fs,'String',8000);
    fsx=8000;
end
if (Rp<=0 || isnan(Rp))
    errordlg('Invalid Bandpass ripple value ',' ERROR ');
    set(handles.rpl,'String',4);
    Rp=4;
end
 
if (As<=0 || isnan(As))
    errordlg('Invalid Bandstop attenuation value ',' ERROR ');
    set(handles.asl,'String',Rp+30);
    As=Rp+30;
end
if (Rp>As || Rp==As)
    errordlg('Bandpass ripple must be less than Bandstop attenuation','ERROR');
    set(handles.asl,'String',Rp+10);
    As=Rp+10;
end
% _________________________________________________________________________
 
set(handles.aplicar,'Visible','on');%Makes visible the "Enter" push button.
fs=fsx/2;%We make this to normalize the frequencies,
fpb=fpbx/fs;
fpb2=fpb2x/fs;
fsb=fsbx/fs;
fsb2=fsb2x/fs;
%__________________________________________________________________________
 
lista = get(handles.popupmenu1,'Value');
%We get a number depending on the selection of the pop menu:
% 1 if is a Butterworth filter
% 2 if is a Chebyshev 1 filter
% 3 if is a Chebyshev 2 filter
% 4 if is a Elliptic filter
lista2 = get(handles.popupmenu2,'Value');
%We get a number depending on the selection of the pop menu:
% 1 if is a lowpass filter
% 2 if is a highpass filter
% 3 if is a bandpass filter
% 4 if is a bandstop filter
% The entered values are applied in the filter type selected.
switch lista2
    case 1
        switch lista
            case 1
                [N,Wn] = buttord(fpb,fsb,Rp,As);
                [b,a] = butter(N,Wn,'low');
            case 2
                [N,Wn] = cheb1ord(fpb,fsb,Rp,As);
                [b,a] = cheby1(N,Rp,Wn,'low');
            case 3
                [N,Wn] = cheb2ord(fpb,fsb,Rp,As);
                [b,a] = cheby2(N,As,Wn,'low');
            case 4
                [N,Wn] = ellipord(fpb,fsb,Rp,As);
                [b,a] = ellip(N,Rp,As,Wn,'low');
        end
    case 2
        switch lista
            case 1
                [N,Wn] = buttord(fpb,fsb,Rp,As);
                [b,a] = butter(N,Wn,'high');
            case 2
                [N,Wn] = cheb1ord(fpb,fsb,Rp,As);
                [b,a] = cheby1(N,Rp,Wn,'high');
            case 3
                [N,Wn] = cheb2ord(fpb,fsb,Rp,As);
                [b,a] = cheby2(N,As,Wn,'high');
            case 4
                [N,Wn] = ellipord(fpb,fsb,Rp,As);
                [b,a] = ellip(N,Rp,As,Wn,'high');
        end
    case 3
        wp=[fpb fpb2];
        ws=[fsb fsb2];
        switch lista
            case 1
                [N,wn]=buttord(wp, ws, Rp, As);
                [b,a] =butter(N,wn,'bandpass');
                
            case 2
                [N,wn]=cheb1ord(wp,ws, Rp, As);
                [b,a] =cheby1(N,Rp,wn,'bandpass');
            case 3
                [N,wn]=cheb2ord(wp,ws, Rp, As);
                [b,a] =cheby2(N,As,wn,'bandpass');
            case 4
                [N,wn]=ellipord(wp, ws, Rp, As);
                [b,a] =ellip(N,Rp,As,wn,'bandpass');
        end
    case 4
        wp=[fpb fpb2];
        ws=[fsb fsb2];
        switch lista
            case 1
                [N,wn]=buttord(wp, ws, Rp, As);
                [b,a] =butter(N,wn,'stop');
            case 2
                [N,wn]=cheb1ord(wp, ws, Rp, As);
                [b,a] =cheby1(N,Rp,wn,'stop');
                
            case 3
                [N,wn]=cheb2ord(wp, ws, Rp, As);
                [b,a] =cheby2(N,As,wn,'stop');
            case 4
                [N,wn]=ellipord(wp,ws,Rp,As);
                [b,a] =ellip(N,Rp,As,wn,'stop');
        end
end
% _________________________________________________________________________
set(handles.orden,'Visible','on');%%Makes visible the static text
%"Filter Order"
set(handles.ordenfiltro,'Visible','on');%Makes visible the edit text
%that is in front of "Filter Order", which tag is "ordenfiltro"
set(handles.orden, 'String', num2str(N));%displays the filter order
 
 
axes(handles.axes1);
[H,w] = freqz(b,a,512,fsx);
plot(w,(abs(H)).^2);
title('Frequency Response (Magnitude)');
xlabel('Frequency (Hz)');
ylabel('|H(\omega)|^2');
grid on;
 
axes(handles.axes2);
plot(w,20*log10(abs(H)));
title('Frequency Response (Magnitude)');
xlabel('Frequency (Hz)');
ylabel('|H(\omega)| (dB)');
ylim([-As-10 2]);
grid on;
 
axes(handles.axes3);
plot(w,angle(H));
title('Frequency Response (Phase)');
xlabel('Frequency (Hz)');
ylabel('Phase');
grid on;
 
axes(handles.axes4);
[h,n] = impz(b,a,50);
stem(n,h);
title('Impulse Response')
xlabel('Time [n]');
ylabel('h[n]');
 
axes(handles.axes5);
z = roots(b);
p = roots(a);
zplane(z,p);
title('Z Plane');
xlabel('Real Part');
ylabel('Imaginary Part');

