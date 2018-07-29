function varargout = spectral_mva(varargin)
% SPECTRAL_MVA M-file for spectral_mva.fig
%      SPECTRAL_MVA is a GUI for running Multivariate analysis of spectroscopic data
%      
%      Initially designed for analysis of X-ray Photoelectron spectra, can
%      analys any type of datatables, containing spectra or any other data
%
%      Opens MAT files with or without a variable X
%      Opens VMS files (XPS spectra) either from original vision software or CASAXPS software
%       
%      Preprocessing options of SMOOTHING, NORMALIZING, DERIVATIZING and SHIFTING spectra   
%
%      Three MVA methods - PCA, SIMPLISMA and MCR
%      PLS_TOOLBOX from Eigenvector is a must 
%
%       created by K.Artyushkova
%      kartyush@unm.edu
%      last update -06/21/2007
% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spectral_mva_OpeningFcn, ...
                   'gui_OutputFcn',  @spectral_mva_OutputFcn, ...
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


% --- Executes just before spectral_mva is made visible.
function spectral_mva_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to spectral_mva (see VARARGIN)

% Choose default command line output for spectral_mva
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
plotgui

% UIWAIT makes spectral_mva wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = spectral_mva_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function open_vms_Callback(hObject, eventdata, handles)
% hObject    handle to open_vms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname]=uigetfiles('*.vms','Open vms files');
cd(pathname)
[N,M]=size(filename);
if M==1;
    [BE,data]=vms_sp_read(char(filename(:,1)),0);
else
    [BE, data(:,M)]=vms_sp_read(char(filename(:,1)),0);
     for i=2:M
    [BE, data(:,i-1)]=vms_sp_read(char(filename(:,i)),0);
end
end

handles.or_sp=data;
handles.data=data;
handles.BE=BE;
handles.BE_or=BE;
axes(handles.axes1)
plot(BE,data)
set(gca,'Xdir','reverse')
guidata(hObject,handles)


% --------------------------------------------------------------------
function open_mat_Callback(hObject, eventdata, handles)
% hObject    handle to open_mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=lddlgpls('*','load spectra');
BE=lddlgpls('*','load BE - click cancel if no BE to load')
a=isempty(BE);
    if a==1
    h= warndlg('The Binding energy range is absent and will be generated automaticaly','Opening MAT file');
    pause(3)
    [n,m]=size(data);
    BE=[n:-1:1]';
    axes(handles.axes1)
reverplot(BE,data)
    else
        
    BE=BE;
    axes(handles.axes1)
plot(BE,data)
set(gca,'Xdir','reverse')
end
    handles.or_sp=data;
    handles.BE_or=BE;
    handles.data=data;
    handles.BE=BE;
guidata(hObject,handles)

% --------------------------------------------------------------------
function save_spectra_Callback(hObject, eventdata, handles)
% hObject    handle to save_spectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datapath = uigetdir;
cd(datapath)
spectra=handles.data;
BE=handles.BE;
[filename, pathname] = uiputfile('*.mat', 'Save images as');
save(filename)


% --- Executes during object creation, after setting all properties.
function spectrum_selection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spectrum_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function spectrum_selection_Callback(hObject, eventdata, handles)
% hObject    handle to spectrum_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


data=handles.data;
BE=handles.BE;
[n,m]=size(data);

set(handles.Min,'string',1);
set(handles.Max,'string',m);

step=1/m;
slider_step(1)=step;
slider_step(2)=step;
if step==1;
    set(handles.spectrum_selection, 'SliderStep', slider_step, 'Max', 2, 'Min',0,'Value',1)
    i=1;
else
    set(handles.spectrum_selection, 'SliderStep', slider_step, 'Max', m, 'Min',0)
    i=get(hObject,'Value');
    i=round(i);
    if i==0
        i=1;
    elseif i>=m
        i=m;
    else i=i;
    end
end
set(handles.current,'string',i);
axes(handles.axes1)
plot(BE,data(:,i))
set(gca,'Xdir','reverse')
handles.N=i;
%guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function Number_comps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Number_comps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Number_comps_Callback(hObject, eventdata, handles)
% hObject    handle to Number_comps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Number_comps as text
%        str2double(get(hObject,'String')) returns contents of Number_comps as a double

Npca=str2double(get(hObject,'String')) ;
handles.Npca=Npca;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function scal_pca_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scal_pca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



% --- Executes on button press in pca_button.
function pca_button_Callback(hObject, eventdata, handles)
% hObject    handle to pca_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Npca=handles.Npca;
data=handles.data;
s=preprocess;
options.preprocessing=s;
options.display='off';
options.plots='final';
model=pca(data, Npca,options);
handles.model=model;
guidata(hObject,handles)



% --- Executes on button press in display_loads.
function display_loads_Callback(hObject, eventdata, handles)
% hObject    handle to display_loads (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
model=handles.model;
plotloads(model)


% --- Executes on button press in disp_score_pca.
function disp_score_pca_Callback(hObject, eventdata, handles)
% hObject    handle to disp_score_pca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
model=handles.model;
plotscores(model)


% --------------------------------------------------------------------
function save_pca_Callback(hObject, eventdata, handles)
% hObject    handle to save_pca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
model=handles.model;
BE=handles.BE;
scores=model.loads{1};
loads=model.loads{2};
datapath = uigetdir;
cd(datapath)
[filename, pathname] = uiputfile('*.mat', 'Save results as');
save(filename)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function normalize_Callback(hObject, eventdata, handles)
% hObject    handle to normalize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=handles.data;
BE=handles.BE;
[m,n]=size(data);
axes(handles.axes1)
plot(data)
[x,y] = gselect('x');
for i=1:n
        K(i)=data(x,i)/100;
        data_n(:,i)=data(:,i)/K(i);    
end
   
data=data_n;
handles.data_n=data;
handles.data=data_n;
axes(handles.axes1)
plot(BE,data)
set(gca,'Xdir','reverse')
guidata(hObject,handles)


% --------------------------------------------------------------------
function derivatize_Callback(hObject, eventdata, handles)
% hObject    handle to derivatize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=handles.data;
BE=handles.BE;
[m,n]=size(data);
type=questdlg('Which derivative you wnat to apply?','Derivatization','1st', '2nd', '1st');
N=inputdlg('Enter the width of smoothing window');  
N=str2double(N);    
if type=='1st'
    for i=1:n
     data_d(i,:) = savgol(data(:,i)',N, 2 ,1);
 end
else
    for i=1:n
     data_d(i,:) = savgol(data(:,i)',N, 2 ,2);
 end
end
data=data_d';
handles.data_d=data;
handles.data=data;
axes(handles.axes1)
plot(BE,data)
set(gca,'Xdir','reverse')
guidata(hObject,handles)


% --------------------------------------------------------------------
function Undo_normalization_Callback(hObject, eventdata, handles)
% hObject    handle to Undo_normalization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=handles.or_sp;
BE=handles.BE_or;
handles.data=data;
axes(handles.axes1)
plot(BE,data)
set(gca,'Xdir','reverse')
guidata(hObject,handles)

% --------------------------------------------------------------------
function undo_deriv_Callback(hObject, eventdata, handles)
% hObject    handle to undo_deriv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data=handles.or_sp;
BE=handles.BE_or;
handles.data=data;
axes(handles.axes1)
plot(BE,data)
set(gca,'Xdir','reverse')
guidata(hObject,handles)

% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function smooth_Callback(hObject, eventdata, handles)
% hObject    handle to smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=handles.data;
BE=handles.BE;
[m,n]=size(data);
N=inputdlg('Enter the odd width of smoothing window > 3 - larger window causes more smoothing');  
N=str2double(N);    
for i=1:n
     data_s(i,:) = savgol(data(:,i)',N, 2 ,0);
end
data=data_s';
handles.data_s=data;
handles.data=data;
axes(handles.axes1)
plot(BE,data)
set(gca,'Xdir','reverse')
guidata(hObject,handles)

% --------------------------------------------------------------------
function opencasavms_Callback(hObject, eventdata, handles)
% hObject    handle to opencasavms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname]=uigetfiles('*.vms','Open vms files');
cd(pathname)
[N,M]=size(filename);
if M==1;
    [BE,data]=vms_sp_read_casa(char(filename(:,1)),0);
else
    [BE, data(:,M)]=vms_sp_read_casa(char(filename(:,1)),0);
     for i=2:M
    [BE, data(:,i-1)]=vms_sp_read_casa(char(filename(:,i)),0);
end
end

handles.or_sp=data;
handles.data=data;
handles.BE=BE;
handles.BE_or=BE;
axes(handles.axes1)
plot(BE,data)
set(gca,'Xdir','reverse')
guidata(hObject,handles)



% --- Executes on button press in Plot_gui.
function Plot_gui_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data(:,1)=handles.BE;
temp=handles.data;
[n,m]=size(temp);
data(:,2:m+1)=handles.data;
H.Position=[262 118 560 335];
figure(H)
plotgui(data);
set(gca,'Xdir','reverse')
handles.H=H;
guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function Nsimp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nsimp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Nsimp_Callback(hObject, eventdata, handles)
% hObject    handle to Nsimp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Nsimp as text
%        str2double(get(hObject,'String')) returns contents of Nsimp as a double
Nsimp=str2double(get(hObject,'String'));
handles.der=0;
handles.Nsimp=Nsimp;
guidata(hObject,handles)


% --- Executes on button press in simplisma_main.
function simplisma_main_Callback(hObject, eventdata, handles)
% hObject    handle to simplisma_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
offset=handles.offset;
Nsimp=handles.Nsimp;
der=handles.der;
data=handles.data;
BE=handles.BE;
if der==0
    [purspec,purint,purity_spec]=simplisma(data',BE, offset,Nsimp);
else
   data2=invder(data');
   [purspec,purint,purity_spec]=simplisma(data',BE, offset,Nsimp,data2);
end

model=handles.model;
modelsimp=model;
modelsimp.loads{1}=purspec';
modelsimp.loads{2}=purint;
handles.modelsimp=modelsimp;
guidata(hObject,handles)


% --- Executes on button press in simp_disp_spectr.
function simp_disp_spectr_Callback(hObject, eventdata, handles)
% hObject    handle to simp_disp_spectr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
modelsimp=handles.modelsimp;
plotscores(modelsimp)

% --- Executes on button press in simp_disp_int.
function simp_disp_int_Callback(hObject, eventdata, handles)
% hObject    handle to simp_disp_int (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
modelsimp=handles.modelsimp;
plotloads(modelsimp)

% --- Executes during object creation, after setting all properties.
function simp_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to simp_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function simp_offset_Callback(hObject, eventdata, handles)
% hObject    handle to simp_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of simp_offset as text
%        str2double(get(hObject,'String')) returns contents of simp_offset as a double

offset=str2double(get(hObject,'String')) ;
handles.offset=offset;
guidata(hObject,handles)


% --- Executes on button press in simpl_2nd.
function simpl_2nd_Callback(hObject, eventdata, handles)
% hObject    handle to simpl_2nd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of simpl_2nd


der=get(hObject,'Value');
handles.der=der;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes on button press in mcr_main.
function mcr_main_Callback(hObject, eventdata, handles)
% hObject    handle to mcr_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data=handles.data;
[n,m]=size(data);
opt=questdlg('Which intialization you want to use?','MCR','Random   ', 'PCA      ', 'Simplisma', 'Random   ');
if opt=='Random   ';
    N=inputdlg('Enter the number of components');  
    Nmcr=str2double(N);
    c0=rand(Nmcr,n);
elseif opt=='PCA      '    
    model=handles.model;
    c0=model.loads{1}';
else
    model=handles.modelsimp;
    c0=model.loads{1}';
end

opt=questdlg('Do you want to apply nonnegativity to Concentrations?','MCR','Yes', 'No ', 'Yes');
if opt=='Yes'
   options.ccon='nonneg';
else
   options.ccon='none';
end

opt=questdlg('Do you want to apply nonnegativity to Spectra?','MCR','Yes', 'No ', 'Yes');
if opt=='Yes'
   options.scon='nonneg';
else
   options.scon='none';
end
options.display='off';
options.plots='final';
modelmcr = mcr(data',c0,options);
handles.modelmcr=modelmcr;
guidata(hObject,handles)

% --- Executes on button press in mcr_disp_sp.
function mcr_disp_sp_Callback(hObject, eventdata, handles)
% hObject    handle to mcr_disp_sp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
modelmcr=handles.modelmcr;
plotscores(modelmcr)


% --- Executes on button press in mcr_disp_int.
function mcr_disp_int_Callback(hObject, eventdata, handles)
% hObject    handle to mcr_disp_int (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
modelmcr=handles.modelmcr;
plotloads(modelmcr)


% --------------------------------------------------------------------
function save_simpl_Callback(hObject, eventdata, handles)
% hObject    handle to save_simpl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
modelsimp=handles.modelsimp;
BE=handles.BE;
scores=modelsimp.loads{1};
loads=modelsimp.loads{2};
datapath = uigetdir;
cd(datapath)
[filename, pathname] = uiputfile('*.mat', 'Save results as');
save(filename)


% --------------------------------------------------------------------
function save_mcr_Callback(hObject, eventdata, handles)
% hObject    handle to save_mcr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

modelmcr=handles.modelmcr;
BE=handles.BE;
scores=modelmcr.loads{1};
loads=modelmcr.loads{2};
datapath = uigetdir;
cd(datapath)
[filename, pathname] = uiputfile('*.mat', 'Save results as');
save(filename)



% --------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

modelpca=handle.model;
modelsimp=handles.modelsimp;
modelmcr=handles.modelmcr;
data=handles.data
BE=handles.BE;
datapath = uigetdir;
cd(datapath)
[filename, pathname] = uiputfile('*.mat', 'Save results as');
save(filename)


% --------------------------------------------------------------------
function open_casa_Callback(hObject, eventdata, handles)
% hObject    handle to open_casa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

M = inputdlg('how many txt files to open?');
M=str2double(M);
if M==1;
    [datafile,datapath] = uigetfile('*.*','Choose a vms file');
    cd(datapath)
    [n,BE,data,d]=textread(datafile,'%f%f%f%f','headerlines',4);
    
else
    prompt={'BE1:','BE2:'};
     def={'295','282'};
     dlgTitle='Enter the starting and enegind BE for the spectra';
     lineNo=1;
     answer=inputdlg(prompt,dlgTitle,lineNo,def);
     N=str2double(answer);
    for i=1:M
      [datafile,datapath] = uigetfile('*.*','Choose a vms file');
      cd(datapath)
     [n,BE,temp,d]=textread(datafile,'%f%f%f%f','headerlines',4);
     [i1,y]=find(BE==N(1));
     [i2,y]=find(BE==N(2));
     data(:,i)=temp(i1:i2);
 end
 BE=BE(i1:i2);
end

handles.or_sp=data;
handles.data=data;
handles.BE=BE;
handles.BE_or=BE;
axes(handles.axes1)
plot(BE,data)
set(gca,'Xdir','reverse')
guidata(hObject,handles)


% --- Executes on button press in reverse.
function reverse_Callback(hObject, eventdata, handles)
% hObject    handle to reverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

H=handles.H;
figure(1)
set(gca,'Xdir','reverse')


% --- Executes when figure1 window is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Calibrate_Callback(hObject, eventdata, handles)
% hObject    handle to Calibrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data=handles.data;
BE=handles.BE_or;
handles.BE_or_un=BE;
handles.or_sp_un=data;
C=inputdlg('Which binding energy to use for calibration? Example: 285 or 284.8');  
C=str2double(C);
[x_sh, y_sh]=shift_spectra(data, BE,C);
data=y_sh;
BE=x_sh;
handles.or_sp=data;
handles.BE_or=BE;
handles.data=data;
handles.BE=BE;
axes(handles.axes1)
plot(BE,data)
set(gca,'Xdir','reverse')
guidata(hObject,handles)



% --------------------------------------------------------------------
function Undo_calibrate_Callback(hObject, eventdata, handles)
% hObject    handle to Undo_calibrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data=handles.or_sp_un;
handles.or_sp=data;
BE=handles.BE_or_un;
handles.data=data;
handles.BE_or=BE;
handles.BE=BE;
axes(handles.axes1)
plot(BE,data)
set(gca,'Xdir','reverse')
guidata(hObject,handles)




% --------------------------------------------------------------------
function open_vms2_Callback(hObject, eventdata, handles)
% hObject    handle to open_vms2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname]=uigetfiles('*.vms','Open vms files');
cd(pathname)
[N,M]=size(filename);
if M==1;
    [BE,data]=vms_sp_read2(char(filename(:,1)),0);
else
    [BE, data(:,1)]=vms_sp_read2(char(filename(:,1)),0);
    [BE, data(:,M)]=vms_sp_read2(char(filename(:,1)),0);
   for i=2:M
    [BE, data(:,i-1)]=vms_sp_read2(char(filename(:,i)),0);
end
end

handles.or_sp=data;
handles.data=data;
handles.BE=BE;
handles.BE_or=BE;
axes(handles.axes1)
plot(BE,data)
set(gca,'Xdir','reverse')
guidata(hObject,handles)


% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data=handles.data;
BE=handles.BE_or;
handles.BE_or_un=BE;
handles.or_sp_un=data;
C=inputdlg('Which binding energy to use for calibration? Example: 285 or 284.8');  
C=str2double(C);
[x_sh, y_sh]=shift_spectra_or(data, BE,C);
data=y_sh;
BE=x_sh;
handles.or_sp=data;
handles.BE_or=BE;
handles.data=data;
handles.BE=BE;
axes(handles.axes1)
plot(BE,data)
set(gca,'Xdir','reverse')
guidata(hObject,handles)





% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname]=uigetfiles('*.vms','Open vms files');
cd(pathname)
[N,M]=size(filename);
if M==1;
    [BE,data]=vms_sp_read_casa2(char(filename(:,1)),0);
else
    [BE, data(:,M)]=vms_sp_read_casa2(char(filename(:,1)),0);
     for i=2:M
    [BE, data(:,i-1)]=vms_sp_read_casa2(char(filename(:,i)),0);
end
end

handles.or_sp=data;
handles.data=data;
handles.BE=BE;
handles.BE_or=BE;
axes(handles.axes1)
plot(BE,data)
set(gca,'Xdir','reverse')
guidata(hObject,handles)



% --------------------------------------------------------------------
function Untitled_6_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data=handles.data;
BE=handles.BE_or;
handles.BE_or_un=BE;
handles.or_sp_un=data;
[y_sh, x_sh]=shift_spectra_diff(data, BE);
BE=y_sh;
data=x_sh;
handles.or_sp=data;
handles.BE_or=BE;
handles.data=data;
handles.BE=BE;
axes(handles.axes1)
plot(BE,data)
set(gca,'Xdir','reverse')
guidata(hObject,handles)
