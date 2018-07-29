%AOK TFR 2.0
%Deming Zhang
%deming.zhang@gmail.com
%


function varargout = tfagui(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TFA_OpeningFcn, ...
                   'gui_OutputFcn',  @TFA_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before TFA is made visible.
function TFA_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for TFA
vars = evalin('base','who');
set(handles.listbox_var,'String',vars);

handles.fs=1;
handles.lag=32;
handles.fftlen=512;
handles.tstep=1;
handles.vol=2;
handles.sig=[];
handles.tfr=[];
handles.t=[];
handles.f=[];
handles.begin=1;
handles.end=1;
handles.res=1;
handles.color=JET;
handles.times=6;
handles.vmanner=1;%linear
handles.realf=1;
%Ridges
handles.ci=[];
handles.ri=[];

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
set(gcf,'Color',[1 1 1]);

% UIWAIT makes TFA wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = TFA_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes on slider movement.
function slider_vol_Callback(hObject, eventdata, handles)
h=get(hObject);
handles.vol=h.Value;
handles.output = hObject;
guidata(hObject, handles);

% --- Executes on selection change in listbox_color.
function listbox_color_Callback(hObject, eventdata, handles)
h=get(hObject);
list_entries = get(hObject,'String');
index_selected = get(hObject,'Value');
str = list_entries{index_selected};
handles.color=str2num(str);
handles.output = hObject;
guidata(hObject, handles);
colormap(handles.color);

% --- Executes on button press in pushbutton_apply.
function pushbutton_apply_Callback(hObject, eventdata, handles)
s=handles.sig;
if imag(s)==0,      s=[s imag(hilbert(s))];
else                s=[real(s) imag(s)];end
s=s(handles.begin:handles.end,:);
res=handles.res;
if res>1,    s=resample(s,10,round(res*10));
elseif res>0 & res~=1,    s=resample(s,10,round(10*res));end
%slen=handles.slen;
slen=length(s);
fs=handles.fs;
lag=handles.lag;
fftlen=handles.fftlen;
tstep=handles.tstep;
vol=handles.vol;

fid = fopen('signal','w');
fprintf(fid,'%d %d %d %d %f\n',slen,lag,fftlen,tstep,vol);
fprintf(fid,'%f %f\n',s');
fclose(fid);
tic
!ATFR.exe signal >NUL
toc
Nt=floor((slen+lag-1)/tstep+1);
fid=fopen('TFR','rb');
TFR=fread(fid,[fftlen,Nt],'double'); 
fclose(fid);
!del TFR signal >NUL

t=linspace(0,(slen-1)/fs,slen);
f=linspace(-fs*(0.5-1/fftlen),fs*(0.5-1/fftlen),fftlen);

suffix=round(lag/(2*tstep));
TFR=TFR(:,suffix+1:Nt-suffix);
TFR=[TFR(1+fftlen/2:end,:);TFR(1:fftlen/2,:)];

handles.t=t;
handles.f=f;
%save 'd:\tfr.mat' TFR;
handles.tfr=TFR;

updateAOK(handles);

axes(handles.ax_pow);
p=( abs(fftshift(fft(s(:,1)+i*s(:,2)))) );

plot(p,linspace(f(1),f(end),length(p)));  
if handles.realf==0,
axis([min(p)-1,max(p)+1,f(1),f(end)]);ylabel('Frequency(Hz)');title('Spectrum');
else axis([min(p)-1,max(p)+1,0,f(end)]);ylabel('Frequency(Hz)');title('Spectrum');
end
axes(handles.ax_wav);
ts=0:slen/(fs*(slen-1)):slen/fs;
if handles.realf==0,
plot(ts,s);axis tight;ylabel('WaveForm');
else plot(ts,s(:,1));axis tight;ylabel('WaveForm');
end
handles.output = hObject;
guidata(hObject, handles);


function edit_lag_Callback(hObject, eventdata, handles)
h=get(hObject);
handles.lag=str2num(h.String);
handles.output = hObject;
guidata(hObject, handles);


function edit_step_Callback(hObject, eventdata, handles)
h=get(hObject);
handles.tstep=str2num(h.String);
handles.output = hObject;
guidata(hObject, handles);

function edit_fft_Callback(hObject, eventdata, handles)
h=get(hObject);
handles.fftlen=str2num(h.String);
handles.output = hObject;
guidata(hObject, handles);


% --- Executes on selection change in listbox_manner.
function listbox_manner_Callback(hObject, eventdata, handles)
h=get(hObject);
handles.vmanner=h.Value;
handles.output = hObject;
guidata(hObject, handles);
updateAOK(handles);
% --------------------------------------------------------------------

% --- Executes on selection change in listbox_var.
function listbox_var_Callback(hObject, eventdata, handles)
sig=get_var_names(handles);
sig=sig(:);
handles.sig=sig;
handles.slen=length(sig);
handles.begin=1;
handles.end=handles.slen;
set(handles.edit_b,'String',num2str(handles.begin));
set(handles.edit_e,'String',num2str(handles.end));

if imag(sig)==0,
    axes(handles.ax_wav);
    plot([0:length(sig)-1]/handles.fs,sig);axis tight;ylabel('WaveForm');
    axes(handles.ax_pow);
    p=( abs(fftshift(fft(sig))) );
    plot(p(length(p)/2+1:end),linspace(0,0.5*handles.fs,length(p)/2)); 
else
    axes(handles.ax_wav);
    plot([0:length(sig)-1]/handles.fs,[real(sig) imag(sig)]);axis tight;ylabel('WaveForm');
    axes(handles.ax_pow);
    p=( abs(fftshift(fft(sig))) );
    plot(p,linspace(-0.5*handles.fs,0.5*handles.fs,length(p))); 
end


handles.output = hObject;
guidata(hObject, handles);


function sig = get_var_names(handles)
list_entries = get(handles.listbox_var,'String');
index_selected = get(handles.listbox_var,'Value');
sig = list_entries{index_selected(1)};
sig=evalin('base',sig);


% --- Executes on button press in pushbutton_update.
function pushbutton_update_Callback(hObject, eventdata, handles)
vars = evalin('base','who');
set(handles.listbox_var,'String',vars);



% --- Executes during object creation, after setting all properties.

function edit_fs_Callback(hObject, eventdata, handles)
h=get(hObject);
handles.fs=str2num(h.String);
handles.output = hObject;
guidata(hObject, handles);

function updateAOK(handles)
t=handles.t;
f=handles.f;
if handles.realf==1,
    len=ceil(length(f)/2);
    tfr=handles.tfr(len:end,:);
    f=f(len:end);
else
    tfr=handles.tfr;
end
pt=0.005*2^handles.times;
if handles.vmanner==1,
    tfr=tfr.^pt;
else
    tfr=10*log10(tfr.^pt);
end
axes(handles.ax_aok);imagesc(t,f,tfr);xlabel('Time(s)');axis xy;ylabel('Frequency(Hz)');title('Time Frequency Representation');
%axes(handles.ax_aok);imagesc(t,f,tfr);xlabel('Time(s)');axis xy;ylabel('Frequency(Hz)');title('AOK Time-Frequency Representation');

% --- Executes on slider movement.
function slider_times_Callback(hObject, eventdata, handles)
h=get(hObject);
handles.times=h.Value;
updateAOK(handles);
handles.output = hObject;
guidata(hObject, handles);

% --- Executes on slider movement.
function edit_res_Callback(hObject, eventdata, handles)
h=get(hObject);
handles.res=str2num(h.String);
handles.output = hObject;
guidata(hObject, handles);

% --- Executes on slider movement.
function edit_b_Callback(hObject, eventdata, handles)
h=get(hObject);
handles.begin=str2num(h.String);
handles.output = hObject;
guidata(hObject, handles);
% --- Executes on slider movement.
function edit_e_Callback(hObject, eventdata, handles)
h=get(hObject);
handles.end=str2num(h.String);
handles.output = hObject;
guidata(hObject, handles);


function edit_cmd_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cmd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cmd as text
%        str2double(get(hObject,'String')) returns contents of edit_cmd as a double
evalin('base',get(hObject,'String'));
set(hObject,'String','');
vars = evalin('base','who');
set(handles.listbox_var,'String',vars);

function axis_wav_Callback(hObject, eventdata, handles)
set(handles.edit_b,'String',num2str(handles.begin));
set(handles.edit_e,'String',num2str(handles.end));
handles.output = hObject;
guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[ri,ci]=ridges(handles.tfr,12);
ri=handles.f(ri);
ci=handles.t(ci);
axes(handles.ax_aok);hold on;plot(ci,ri,'r.');hold off;
handles.ri=ri;handles.ci=ci;
handles.output = hObject;
guidata(hObject, handles);

function [ri,ci] = ridges(m,par)
 if nargin < 2,    par=3;  end;
 m = abs(m);
 [nrows,ncols] = size(m);
 ridges   = zeros(size(m));
 t      = 1:nrows;
 tplus  =[nrows 1:nrows-1 ];% rshift(t);
 tminus =[2:nrows 1];% lshift(t);
for i = 1:ncols,    
 	x = m(:,i)'; 
    for j = 1:par,
		x=max([x(t); x(tplus); x(tminus)]);
    end;
	x = x(:);
	thresh = trimmean(x,5);
    ridges(:,i) = (~(m(:,i)<x)).*(m(:,i)>0.01*thresh);
 end;
 [ri,ci]=find(ridges>0);



% --- Executes on button press in pushbutton_load.
function pushbutton_load_Callback(hObject, eventdata, handles)
[fn, pn]=uigetfile('*.*', 'Mat or Ascii File to Load:');
if fn==0, return; end;
evalin('base', ['load(''' pn fn ''');']);
vars = evalin('base','who');
set(handles.listbox_var,'String',vars);


% --- Executes on button press in checkbox_real.
function checkbox_real_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_real (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=get(hObject);
handles.realf=h.Value;
handles.output = hObject;
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of checkbox_real


