function varargout = ModDemodDigital(varargin)
% MODDEMODDIGITAL M-file for ModDemodDigital.fig
%      MODDEMODDIGITAL, by itself, creates a new MODDEMODDIGITAL or raises the existing
%      singleton*.
%
%      H = MODDEMODDIGITAL returns the handle to a new MODDEMODDIGITAL or the handle to
%      the existing singleton*.
%
%      MODDEMODDIGITAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODDEMODDIGITAL.M with the given input arguments.
%
%      MODDEMODDIGITAL('Property','Value',...) creates a new MODDEMODDIGITAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ModDemodDigital_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ModDemodDigital_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ModDemodDigital

% Last Modified by GUIDE v2.5 25-Oct-2010 12:31:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ModDemodDigital_OpeningFcn, ...
                   'gui_OutputFcn',  @ModDemodDigital_OutputFcn, ...
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


% --- Executes just before ModDemodDigital is made visible.
function ModDemodDigital_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ModDemodDigital (see VARARGIN)

% Choose default command line output for ModDemodDigital
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ModDemodDigital wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ModDemodDigital_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
 H = imread('\robot.bmp');
 imshow(H,[0 200]);
 

% --------------------------------------------------------------------
function mnuhelpbox_Callback(hObject, eventdata, handles)
% hObject    handle to mnuhelpbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox(' Chuong trinh khong co huong dan su dung. Rat xin loi vi su bat tien nay !  The Program without user manual, So sorry for this inconvenient !', 'Help','warn')

% --------------------------------------------------------------------
function mnuabout_Callback(hObject, eventdata, handles)
% hObject    handle to mnuabout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.OK,'Visible','on');
set(handles.edit,'string','0');
H = imread('\tacke.bmp');
subplot(1,1,1);
imshow(H,[0 200]);
 
% --------------------------------------------------------------------
function mnuexit_Callback(hObject, eventdata, handles)
% hObject    handle to mnuexit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all

% --------------------------------------------------------------------

% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = get(handles.edit,'string');
n = str2num(a);
if n == 0
 H = imread('\robot.bmp');
 imshow(H,[0 200]);
 set(handles.edit,'string','1');
 set(handles.OK,'visible','off');
elseif n==1
 K = imread('\tacke.bmp');
 imshow(K,[0 200]);
 set(handles.edit,'string','0');
 end

% --- Executes during object creation, after setting all properties.
function edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function mnumodulation_Callback(hObject, eventdata, handles)
% hObject    handle to mnumodulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Simulation
% --------------------------------------------------------------------

% --------------------------------------------------------------------
function mnumatlab_Callback(hObject, eventdata, handles)
% hObject    handle to mnumatlab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CRAZY=0;

% --------------------------------------------------------------------
function mnusimulink_Callback(hObject, eventdata, handles)
% hObject    handle to mnusimulink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CRAZY=0;

% --------------------------------------------------------------------
function mnuhelp_Callback(hObject, eventdata, handles)
% hObject    handle to mnuhelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CRAZY=0;

% --------------------------------------------------------------------
function mnuBERS_Callback(hObject, eventdata, handles)
% hObject    handle to mnuBERS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure(1);
EbN0dB=-4:1:24;
EbN0lin=10.^(EbN0dB/10);
colors={'b-','g-','r-','c-','m-','y-','k-'};
index=1;

%BPSK
BPSK = 0.5*erfc(sqrt(EbN0lin));
plotHandle=plot(EbN0dB,log10(BPSK),char(colors(index)));grid on;
set(plotHandle,'LineWidth',1.5);
hold on;
index=index+1;

%M-PSK
m=2:1:5;
M=2.^m;
for i=M,
    k=log2(i);
    berErr = 1/k*erfc(sqrt(EbN0lin*k)*sin(pi/i));
    plotHandle=plot(EbN0dB,log10(berErr),char(colors(index)));
    set(plotHandle,'LineWidth',1.5);
    index=index+1;
end

%Binary DPSK
Pb = 0.5*exp(-EbN0lin);
plotHandle = plot(EbN0dB,log10(Pb),char(colors(index)));
set(plotHandle,'LineWidth',1.5);
index=index+1;

%Differential QPSK
a=sqrt(2*EbN0lin*(1-sqrt(1/2)));
b=sqrt(2*EbN0lin*(1+sqrt(1/2)));
Pb = marcumq(a,b,1)-1/2.*besseli(0,a.*b).*exp(-1/2*(a.^2+b.^2));
plotHandle = plot(EbN0dB,log10(Pb),char(colors(index)));
set(plotHandle,'LineWidth',1.5);
index=index+1;

legend('BPSK','QPSK','8-PSK','16-PSK','32-PSK','D-BPSK','D-QPSK');
axis([-4 24 -8 0]);
set(gca,'XTick',-4:1:24); 
xlabel('Eb/No (dB)');ylabel('Bit Error Rate');title('BER Curvers of PSK Signal');


% --------------------------------------------------------------------
function mnuask_Callback(hObject, eventdata, handles)
% hObject    handle to mnuask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bdclose all
set_param(0,'CharacterEncoding','Windows-1252')
ASK


% --------------------------------------------------------------------
function mnufsk_Callback(hObject, eventdata, handles)
% hObject    handle to mnufsk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bdclose all
set_param(0,'CharacterEncoding','Windows-1252')
FSK


% --------------------------------------------------------------------
function mnuook_Callback(hObject, eventdata, handles)
% hObject    handle to mnuook (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bdclose all
set_param(0,'CharacterEncoding','Windows-1252')
OOK


% --------------------------------------------------------------------
function mnubpsk_Callback(hObject, eventdata, handles)
% hObject    handle to mnubpsk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
BPSK


% --------------------------------------------------------------------
function mnuqpsk_Callback(hObject, eventdata, handles)
% hObject    handle to mnuqpsk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
QPSK


% --------------------------------------------------------------------
function mnu8psk_Callback(hObject, eventdata, handles)
% hObject    handle to mnu8psk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MPSK


% --------------------------------------------------------------------
function mnudbpsk_Callback(hObject, eventdata, handles)
% hObject    handle to mnudbpsk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DBPSK


% --------------------------------------------------------------------
function mnuqam_Callback(hObject, eventdata, handles)
% hObject    handle to mnuqam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
QAM
