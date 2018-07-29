function varargout = nlsegui(varargin)
% NLSEGUI M-file for nlsegui.fig
%      NLSEGUI, by itself, creates a new NLSEGUI or raises the existing
%      singleton*.
%
%      H = NLSEGUI returns the handle to a new NLSEGUI or the handle to
%      the existing singleton*.
%
%      NLSEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NLSEGUI.M with the given input arguments.
%
%      NLSEGUI('Property','Value',...) creates a new NLSEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nlsegui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nlsegui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nlsegui

% Last Modified by GUIDE v2.5 08-May-2004 23:31:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @nlsegui_OpeningFcn, ...
    'gui_OutputFcn',  @nlsegui_OutputFcn, ...
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


% --- Executes just before nlsegui is made visible.
function nlsegui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nlsegui (see VARARGIN)

% Choose default command line output for nlsegui

handles.output = hObject;
guidata(hObject, handles);


%----Input Signal----------------
handles.Signal_num = 0;
guidata(hObject,handles);
handles.Signal = [];
guidata(hObject,handles);
handles.Frequency_Chirp = [];
guidata(hObject,handles);
handles.Signal_Spectrum = [];
guidata(hObject,handles);
handles.Frequency_Chirp = [];
guidata(hObject,handles);
handles.Time_Window = 20;   % Time Window = 20 T_0
guidata(hObject,handles);
handles.Samples_Num = 2^10;
guidata(hObject,handles);
handles.Time = [];
guidata(hObject,handles);
handles.Frequency = [];
guidata(hObject,handles);
%-------------Loaded Signals List-------------------
handles.Loaded_Signal_List = [];
guidata(hObject,handles);
handles.Loaded_Signal_Ppty = [];    % Signal Properties like Spectral and Temporal width. 
guidata(hObject,handles);
handles.Empty = [];
guidata(hObject,handles);
handles.Signal_Spec=[];         % Signal Specifications 
guidata(hObject,handles);
%-----------------------------------------------------
set(handles.Loaded_Signals,'String','','Value',0);
%------------------------------------------------------
%--------- Plotted Data Index--------------------------
handles.Ploted_Data_Index_Display1 = [];
guidata(hObject,handles);
handles.Ploted_Data_Index_Display2 = [];
guidata(hObject,handles);
%----- Launch Data ------------------------------
handles.Launch_Signal_List = [];
guidata(hObject,handles);
handles.Media_Ppty = [];   
guidata(hObject,handles);
handles.Launch_Signal_num = 0;
guidata(hObject,handles);
handles.Input_Signal_Index = [];
guidata(hObject,handles);
handles.Launch_Data_Signal = [];
guidata(hObject,handles);
handles.Launch_Data_Signal_Ppty = [];
guidata(hObject,handles);
handles.Launch_Data_Signal_chirp = [];
guidata(hObject,handles);
handles.Launch_Data_Spectrum = [];
guidata(hObject,handles);
handles.Step_N = 100;
guidata(hObject,handles);
handles.z = [];
guidata(hObject,handles);
handles.L_Empty = [];
guidata(hObject,handles);
handles.Launch_Status = [];
guidata(hObject,handles);
handles.Para_3D = [10];
guidata(hObject,handles);
handles.Para_Mov = [10,handles.Time_Window,1;10,2*pi*(handles.Samples_Num-1)/handles.Time_Window,handles.Samples_Num];
guidata(hObject,handles);
handles.show_side_by_side = [0,0];
guidata(hObject,handles);
handles.FC_SAL = [-50, 50, handles.Time_Window];
guidata(hObject,handles);
handles.Play_Index_Display1 = 0;
guidata(hObject,handles);
handles.Play_Index_Display2 = 0;
guidata(hObject,handles);
handles.Special_Medium_Index = [];
guidata(hObject,handles);
handles.fun_Second_order_GVD = {'','','',''};
guidata(hObject,handles);
handles.TW_Compare_Index = [];
guidata(hObject,handles);
handles.SW_Compare_Index = [];
guidata(hObject,handles);
handles.Snapshot_Compare_Index = [];
guidata(hObject,handles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes nlsegui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = nlsegui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function gFile_Callback(hObject, eventdata, handles)
% hObject    handle to gFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
% --------------------------------------------------------------------
% ---------------------INPUT SIGNAL ----------------------------------
% --------------------------------------------------------------------
% --------------------------------------------------------------------

function gInput_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function gPT_Callback(hObject, eventdata, handles)
% Menu       Pulse Type

% --------------------------------------------------------------------
function gSG_Callback(hObject, eventdata, handles)
% Menu       Super Gaussian   

%----------- Pulse Parameters ----------------

handles.Signal_Spec= [handles.Signal_Spec;[1,1,0,1,1]];
guidata(hObject,handles);
prompt{1} = 'Width';
prompt{2} = 'm';
prompt{3} = 'Chirp Parameter';
prompt{4} = 'Amplitude';
default_ans = {num2str(handles.Signal_Spec(handles.Signal_num+1,1)),num2str(handles.Signal_Spec(handles.Signal_num+1,2)),num2str(handles.Signal_Spec(handles.Signal_num+1,3)),num2str(handles.Signal_Spec(handles.Signal_num+1,4))};
title = 'Parameters For Super-Gaussian Pulse';
answer = inputdlg(prompt,title,1,default_ans);
if ~isempty(answer),
    handles.Signal_num = handles.Signal_num + 1;
    % Taking input from the user
    guidata(hObject,handles);
    handles.Signal_Spec(handles.Signal_num,1) = str2num(answer{1});
    guidata(hObject,handles);
    handles.Signal_Spec(handles.Signal_num,2) = str2num(answer{2});
    guidata(hObject,handles);
    handles.Signal_Spec(handles.Signal_num,3) = str2num(answer{3});
    guidata(hObject,handles);
    handles.Signal_Spec(handles.Signal_num,4) = str2num(answer{4});
    guidata(hObject,handles);
    %--------------------Generating Time & Frequnecy vector ----------------------
    G=[0:(handles.Samples_Num-1)];
    step_T=handles.Time_Window/(handles.Samples_Num-1);
    handles.Time=[-handles.Time_Window/2:(handles.Time_Window/(handles.Samples_Num-1)):handles.Time_Window/2];
    guidata(hObject,handles);
    f=G/(handles.Samples_Num*step_T);
    handles.Frequency=2*pi*[f(1,1:handles.Samples_Num/2),(f(1,(handles.Samples_Num/2+1):handles.Samples_Num)-ones(1,handles.Samples_Num/2)/step_T)]
    guidata(hObject,handles);
    %----------------------------------------------------------------------
    Tmp_Signal=handles.Signal_Spec(handles.Signal_num,4)*exp(-((1+handles.Signal_Spec(handles.Signal_num,3)*sqrt(-1))/2)*(handles.Time./handles.Signal_Spec(handles.Signal_num,1)).^(2*handles.Signal_Spec(handles.Signal_num,2)));
    handles.Signal=[handles.Signal; Tmp_Signal]; 
    guidata(hObject,handles);
    %--------Finding FFT of the Signal-----------------------------------
    handles.Frequency_Chirp=[handles.Frequency_Chirp;-2*handles.Signal_Spec(handles.Signal_num,3)*handles.Signal_Spec(handles.Signal_num,2)*((handles.Time/handles.Signal_Spec(handles.Signal_num,1)).^(2*handles.Signal_Spec(handles.Signal_num,2)-1))/handles.Signal_Spec(handles.Signal_num,1)];
    guidata(hObject,handles);
    tmpFFT=fft(Tmp_Signal);
    handles.Signal_Spectrum = [handles.Signal_Spectrum;tmpFFT];
    guidata(hObject,handles);
    handles.Loaded_Signal_Ppty =[handles.Loaded_Signal_Ppty;[sqrt(var(handles.Time,abs(Tmp_Signal).^2)),sqrt(var(handles.Frequency,abs(tmpFFT).^2))]];
    guidata(hObject,handles);
    handles.Loaded_Signal_List=[handles.Loaded_Signal_List; ['S',num2str(handles.Signal_num)]];
    guidata(hObject,handles);
    handles.Empty=[handles.Empty;['         ']];
    guidata(hObject,handles);
    tmpStr=cat(2,handles.Loaded_Signal_List,handles.Empty,num2str(handles.Loaded_Signal_Ppty(:,1)),handles.Empty,num2str(handles.Loaded_Signal_Ppty(:,2)));
    set(handles.Loaded_Signals,'String',tmpStr,'Value',handles.Signal_num);
    set(handles.gRemove_IS,'Enable','on');
    set(handles.gIS_Edit,'Enable','on');
else
    handles.Signal_Spec = handles.Signal_Spec(1:handles.Signal_num,:);
    guidata(hObject,handles);
    
end
% --------------------------------------------------------------------
function gHS_Callback(hObject, eventdata, handles)
%Menu        Hyperbolic-Secant

handles.Signal_Spec =[handles.Signal_Spec;[1,0,1,0,2]];
guidata(hObject,handles);
prompt{1} = 'Width';
prompt{2} = 'Chirp Parameter';
prompt{3} = 'Amplitude'
default_ans = {num2str(handles.Signal_Spec(handles.Signal_num+1,1)),num2str(handles.Signal_Spec(handles.Signal_num+1,2)),num2str(handles.Signal_Spec(handles.Signal_num+1,3))};
title = 'Parameters For Hyperbolic-Secant Pulse';
answer = inputdlg(prompt,title,1,default_ans);
if ~isempty(answer),
    handles.Signal_num=handles.Signal_num+1;
    guidata(hObject,handles);
    %----------- Pulse Parameters ----------------
    
    handles.Signal_Spec(handles.Signal_num,1) =str2num(answer{1})
    guidata(hObject,handles);
    handles.Signal_Spec(handles.Signal_num,2) =str2num(answer{2});
    guidata(hObject,handles);
    handles.Signal_Spec(handles.Signal_num,3) =str2num(answer{3});
    guidata(hObject,handles);
    %--------------------Generating Time & Frequnecy vector ----------------------
    G=[0:(handles.Samples_Num-1)];
    step_T=handles.Time_Window/(handles.Samples_Num-1);
    handles.Time=[-handles.Time_Window/2:handles.Time_Window/(handles.Samples_Num-1):handles.Time_Window/2];
    guidata(hObject,handles);
    f=G/(handles.Samples_Num*step_T);
    handles.Frequency=2*pi*[f(1,1:handles.Samples_Num/2),(f(1,(handles.Samples_Num/2+1):handles.Samples_Num)-ones(1,handles.Samples_Num/2)/step_T)]
    guidata(hObject,handles);
    %----------------------------------------------------------------------
    Tmp_Signal=handles.Signal_Spec(handles.Signal_num,3)*sech(handles.Time./handles.Signal_Spec(handles.Signal_num,1)).*exp(-((handles.Signal_Spec(handles.Signal_num,2)*sqrt(-1))/2)*(handles.Time./handles.Signal_Spec(handles.Signal_num,1)).^2);
    handles.Signal=[handles.Signal;Tmp_Signal]; 
    guidata(hObject,handles);
    %--------Finding FFT of the Signal-----------------------------------
    handles.Frequency_Chirp=[handles.Frequency_Chirp;-2*handles.Signal_Spec(handles.Signal_num,2)*(handles.Time/handles.Signal_Spec(handles.Signal_num,1))/handles.Signal_Spec(handles.Signal_num,1)];
    guidata(hObject,handles);
    tmpFFT=fft(Tmp_Signal);
    handles.Signal_Spectrum = [handles.Signal_Spectrum;tmpFFT];
    guidata(hObject,handles);
    handles.Loaded_Signal_Ppty =[handles.Loaded_Signal_Ppty;[sqrt(var(handles.Time,abs(Tmp_Signal).^2)),sqrt(var(handles.Frequency,abs(tmpFFT).^2))]];
    guidata(hObject,handles);
    handles.Loaded_Signal_List=[handles.Loaded_Signal_List; ['S',num2str(handles.Signal_num)]];
    guidata(hObject,handles);
    handles.Empty=[handles.Empty;['         ']];
    guidata(hObject,handles);
    
    tmpStr=cat(2,handles.Loaded_Signal_List,handles.Empty,num2str(handles.Loaded_Signal_Ppty(:,1)),handles.Empty,num2str(handles.Loaded_Signal_Ppty(:,2)));
    set(handles.Loaded_Signals,'String',tmpStr,'Value',handles.Signal_num);
    set(handles.gRemove_IS,'Enable','on');
    set(handles.gIS_Edit,'Enable','on');
else
    handles.Signal_Spec = handles.Signal_Spec(1:handles.Signal_num,:);
    guidata(hObject,handles);
end
% --------------------------------------------------------------------
function gNoS_Callback(hObject, eventdata, handles)
% Menu      Number of Samples
if handles.Launch_Signal_num~=0,
    errordlg('Invoked Resolution Conflicts with Launch Module!','Error Dialog Box','modal');
else
    prompt{1} = 'Number of Sampling Points(Radix 2)';
    default_ans = {num2str(handles.Samples_Num)};
    title = 'Number of Sampling Points';
    answer = inputdlg(prompt,title,1,default_ans);
    if ~isempty(answer),
        
        handles.Samples_Num = str2num(answer{1});
        guidata(hObject,handles);
        
        if handles.Signal_num~=0,
            %--------------------Generating Time & Frequnecy vector ----------------------
            G=[0:(handles.Samples_Num-1)];
            step_T=handles.Time_Window/(handles.Samples_Num-1);
            handles.Time=[-handles.Time_Window/2:handles.Time_Window/(handles.Samples_Num-1):handles.Time_Window/2];
            guidata(hObject,handles);
            f=G/(handles.Samples_Num*step_T);
            handles.Frequency=2*pi*[f(1,1:handles.Samples_Num/2),(f(1,(handles.Samples_Num/2+1):handles.Samples_Num)-ones(1,handles.Samples_Num/2)/step_T)];
            guidata(hObject,handles);
            %----------------------------------------------------------------------
            
            handles.Signal=[]; 
            guidata(hObject,handles);
            handles.Signal_Spectrum = [];
            guidata(hObject,handles);
            
            for n=1:handles.Signal_num,
                if handles.Signal_Spec(n,5)==2,
                    Tmp_Signal=handles.Signal_Spec(n,3)*sech(handles.Time./handles.Signal_Spec(n,1)).*exp(-((handles.Signal_Spec(n,2)*sqrt(-1))/2)*(handles.Time./handles.Signal_Spec(n,1)).^2);
                    handles.Signal(n,:)=Tmp_Signal; 
                    guidata(hObject,handles);
                    
                    %--------Finding FFT of the Signal-----------------------------------
                    handles.Frequency_Chirp=[handles.Frequency_Chirp;-2*handles.Signal_Spec(handles.Signal_num,2)*(handles.Time/handles.Signal_Spec(handles.Signal_num,1))/handles.Signal_Spec(handles.Signal_num,1)];
                    guidata(hObject,handles);
                    tmpFFT=fft(Tmp_Signal);
                    handles.Signal_Spectrum(n,:) = tmpFFT;
                    guidata(hObject,handles);
                    handles.Loaded_Signal_Ppty(n,:) =[sqrt(var(handles.Time,abs(Tmp_Signal).^2)),sqrt(var(handles.Frequency,abs(tmpFFT).^2))];
                    guidata(hObject,handles);
                elseif handles.Signal_Spec(n,5)==1,
                    Tmp_Signal=handles.Signal_Spec(n,4)*exp(-((1+handles.Signal_Spec(n,3)*sqrt(-1))/2)*(handles.Time./handles.Signal_Spec(n,1)).^(2*handles.Signal_Spec(n,2)));
                    handles.Signal(n,:)=Tmp_Signal; 
                    guidata(hObject,handles);
                    %--------Finding FFT of the Signal-----------------------------------
                    handles.Frequency_Chirp=[handles.Frequency_Chirp;-2*handles.Signal_Spec(handles.Signal_num,3)*handles.Signal_Spec(handles.Signal_num,2)*((handles.Time/handles.Signal_Spec(handles.Signal_num,1)).^(2*handles.Signal_Spec(handles.Signal_num,2)-1))/handles.Signal_Spec(handles.Signal_num,1)];
                    guidata(hObject,handles);
                    tmpFFT=fft(Tmp_Signal);
                    handles.Signal_Spectrum(n,:) = tmpFFT;
                    guidata(hObject,handles);
                    handles.Loaded_Signal_Ppty(n,:) = [sqrt(var(handles.Time,abs(Tmp_Signal).^2)),sqrt(var(handles.Frequency,abs(tmpFFT).^2))];
                    guidata(hObject,handles);
                end
            end
            tmpStr=cat(2,handles.Loaded_Signal_List,handles.Empty,num2str(handles.Loaded_Signal_Ppty(:,1)),handles.Empty,num2str(handles.Loaded_Signal_Ppty(:,2)));
            set(handles.Loaded_Signals,'String',tmpStr);
        end
    end
end

% --------------------------------------------------------------------
function gTW_Callback(hObject, eventdata, handles)
% Menu       Time Window   
if handles.Launch_Signal_num ~=0,
    errordlg('Invoked Resolution Conflicts with Launch Module!','Error Dialog Box','modal');
else
    prompt{1} = 'Time Window';
    default_ans = {num2str(handles.Time_Window)};
    title = 'Time Window';
    answer = inputdlg(prompt,title,1,default_ans);
    if ~isempty(answer),
        
        handles.Time_Window = str2num(answer{1})
        guidata(hObject,handles);
        
        if handles.Signal_num~=0,
            %--------------------Generating Time & Frequnecy vector ----------------------
            G=[0:(handles.Samples_Num-1)];
            step_T=handles.Time_Window/(handles.Samples_Num-1);
            handles.Time=[-handles.Time_Window/2:handles.Time_Window/(handles.Samples_Num-1):handles.Time_Window/2];
            guidata(hObject,handles);
            f=G/(handles.Samples_Num*step_T);
            handles.Frequency=2*pi*[f(1,1:handles.Samples_Num/2),(f(1,(handles.Samples_Num/2+1):handles.Samples_Num)-ones(1,handles.Samples_Num/2)/step_T)];
            guidata(hObject,handles);
            %----------------------------------------------------------------------
            
            handles.Signal=[]; 
            guidata(hObject,handles);
            handles.Signal_Spectrum = [];
            guidata(hObject,handles);
            
            for n=1:handles.Signal_num,
                if handles.Signal_Spec(n,5)==2,
                    Tmp_Signal=handles.Signal_Spec(n,3)*sech(handles.Time./handles.Signal_Spec(n,1)).*exp(-((handles.Signal_Spec(n,2)*sqrt(-1))/2)*(handles.Time./handles.Signal_Spec(n,1)).^2);
                    handles.Signal(n,:)=Tmp_Signal; 
                    guidata(hObject,handles);
                    
                    %--------Finding FFT of the Signal-----------------------------------
                    handles.Frequency_Chirp=[handles.Frequency_Chirp;-2*handles.Signal_Spec(handles.Signal_num,2)*(handles.Time/handles.Signal_Spec(handles.Signal_num,1))/handles.Signal_Spec(handles.Signal_num,1)];
                    guidata(hObject,handles);
                    tmpFFT=fft(Tmp_Signal);
                    handles.Signal_Spectrum(n,:) = tmpFFT;
                    guidata(hObject,handles);
                    handles.Loaded_Signal_Ppty(n,:) =[sqrt(var(handles.Time,abs(Tmp_Signal).^2)),sqrt(var(handles.Frequency,abs(tmpFFT).^2))];
                    guidata(hObject,handles);
                elseif handles.Signal_Spec(n,5)==1,
                    Tmp_Signal=handles.Signal_Spec(n,4)*exp(-((1+handles.Signal_Spec(n,3)*sqrt(-1))/2)*(handles.Time./handles.Signal_Spec(n,1)).^(2*handles.Signal_Spec(n,2)));
                    handles.Signal(n,:)=Tmp_Signal; 
                    guidata(hObject,handles);
                    %--------Finding FFT of the Signal-----------------------------------
                    handles.Frequency_Chirp=[handles.Frequency_Chirp;-2*handles.Signal_Spec(handles.Signal_num,3)*handles.Signal_Spec(handles.Signal_num,2)*((handles.Time/handles.Signal_Spec(handles.Signal_num,1)).^(2*handles.Signal_Spec(handles.Signal_num,2)-1))/handles.Signal_Spec(handles.Signal_num,1)];
                    guidata(hObject,handles);
                    tmpFFT=fft(Tmp_Signal);
                    handles.Signal_Spectrum(n,:) = tmpFFT;
                    guidata(hObject,handles);
                    handles.Loaded_Signal_Ppty(n,:) = [sqrt(var(handles.Time,abs(Tmp_Signal).^2)),sqrt(var(handles.Frequency,abs(tmpFFT).^2))];
                    guidata(hObject,handles);
                end
            end
            tmpStr=cat(2,handles.Loaded_Signal_List,handles.Empty,num2str(handles.Loaded_Signal_Ppty(:,1)),handles.Empty,num2str(handles.Loaded_Signal_Ppty(:,2)));
            set(handles.Loaded_Signals,'String',tmpStr);
        end
    end
end

% --------------------------------------------------------------------
function gLaunch_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function gSpectrum_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function gSS_Display1_Callback(hObject, eventdata, handles)
% Menu       Show Spectrum

n=get(handles.Loaded_Signals,'Value');
if n==0,
    errordlg('No Signal selected!','Error Dialog Box','modal');
elseif ~isempty(handles.Ploted_Data_Index_Display1),
    button = questdlg('Do you want to Erase the existing plot?','','Yes','No','Yes'); 
    if strcmp(button,'Yes'),
        handles.Ploted_Data_Index_Display1 = [2,n];% 2---> refers to spectrum plot
        guidata(hObject,handles);
        h=plot( fftshift(handles.Frequency),((1/handles.Samples_Num)*abs(fftshift(handles.Signal_Spectrum(n,:)))).^2,'Parent',handles.Display1);
        set(get(handles.Display1,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(get(handles.Display1,'XLabel'),'String','Frequency (T_0^{-1})','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(handles.gRefreshDisplay1,'Enable','on','Visible','on');
        set(handles.gShowframes,'Visible','off','Value',1)
        set(handles.gShow1,'Enable','on');
        set(handles.gT1,'String','');
        handles.Play_Index_Display1 = 0;
        guidata(hObject,handles);
        handles.show_side_by_side(1,1) = 0;
        guidata(hObject,handles);
    else
        s=2;found=0;
        [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display1);
        while ~found && s<=tmp_n,
            if n==handles.Ploted_Data_Index_Display1(1,s),
                found=1;
            end
            s=s+1;
        end
        if found==0,
            handles.Ploted_Data_Index_Display1 = [handles.Ploted_Data_Index_Display1,n];
            guidata(hObject,handles);
        end
        
        [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display1);
        h=plot( fftshift(handles.Frequency),((1/handles.Samples_Num)*abs(fftshift(handles.Signal_Spectrum(handles.Ploted_Data_Index_Display1(1,2:tmp_n),:)))).^2,'Parent',handles.Display1);
        set(get(handles.Display1,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(get(handles.Display1,'XLabel'),'String','Frequency (T_0^{-1})','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(handles.gRefreshDisplay1,'Enable','on','Visible','on');
        set(handles.gShowframes,'Visible','off','Value',1)
        set(handles.gShow1,'Enable','on');
        set(handles.gT1,'String','')
        handles.Play_Index_Display1 = 0;
        guidata(hObject,handles);
        handles.show_side_by_side(1,1) = 0;
        guidata(hObject,handles);
    end
else
    handles.Ploted_Data_Index_Display1 = [2,n];
    guidata(hObject,handles);
    h=plot( fftshift(handles.Frequency),((1/handles.Samples_Num)*abs(fftshift(handles.Signal_Spectrum(n,:)))).^2,'Parent',handles.Display1);
    set(get(handles.Display1,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display1,'XLabel'),'String','Frequency (T_0^{-1})','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(handles.gRefreshDisplay1,'Enable','on','Visible','on');
    set(handles.gShowframes,'Visible','off','Value',1);
    set(handles.gShow1,'Enable','on');
    set(handles.gT1,'String','');
    handles.Play_Index_Display1 = 0;
    guidata(hObject,handles);
    handles.show_side_by_side(1,1) = 0;
    guidata(hObject,handles);
end


% --------------------------------------------------------------------
function gSS_Display2_Callback(hObject, eventdata, handles)
% Menu       Show Spectrum 

n=get(handles.Loaded_Signals,'Value');
if n==0,
    errordlg('No Signal selected!','Error Dialog Box','modal');
elseif ~isempty(handles.Ploted_Data_Index_Display2),
    button = questdlg('Do you want to Erase the existing plot?','','Yes','No','Yes'); 
    if strcmp(button,'Yes'),
        handles.Ploted_Data_Index_Display2 = [2,n];
        guidata(hObject,handles);
        h=plot( fftshift(handles.Frequency),((1/handles.Samples_Num)*abs(fftshift(handles.Signal_Spectrum(n,:)))).^2,'Parent',handles.Display2);
        set(get(handles.Display2,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(get(handles.Display2,'XLabel'),'String','Frequency (T_0^{-1})','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(handles.gRefreshDisplay2,'Enable','on','Visible','on');
        set(handles.gShowframe2,'Visible','off','Value',1)
        set(handles.gShow2,'Enable','on');
        set(handles.gT2,'String','');
        handles.Play_Index_Display2 = 0;
        guidata(hObject,handles);
        handles.show_side_by_side(1,1) = 0;
        guidata(hObject,handles);
    else
        s=2;found=0;
        [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display2);
        while ~found && s<=tmp_n,
            if n==handles.Ploted_Data_Index_Display2(1,s),
                found=1;
            end
            s=s+1;
        end
        if found==0,
            handles.Ploted_Data_Index_Display2 = [handles.Ploted_Data_Index_Display2,n];
            guidata(hObject,handles);
        end
        [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display2);
        h=plot( fftshift(handles.Frequency),((1/handles.Samples_Num)*abs(fftshift(handles.Signal_Spectrum(handles.Ploted_Data_Index_Display2(1,2:tmp_n),:)))).^2,'Parent',handles.Display2);
        set(get(handles.Display2,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(get(handles.Display2,'XLabel'),'String','Frequency (T_0^{-1})','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(handles.gRefreshDisplay2,'Enable','on','Visible','on');
        set(handles.gShowframe2,'Visible','off','Value',1)
        set(handles.gShow2,'Enable','on');
        set(handles.gT2,'String','');
        handles.Play_Index_Display2 = 0;
        guidata(hObject,handles);
        handles.show_side_by_side(1,1) = 0;
        guidata(hObject,handles);
    end
else
    handles.Ploted_Data_Index_Display2 = [2,n];
    guidata(hObject,handles);
    h=plot( fftshift(handles.Frequency),((1/handles.Samples_Num)*abs(fftshift(handles.Signal_Spectrum(n,:)))).^2,'Parent',handles.Display2);
    set(get(handles.Display2,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display2,'XLabel'),'String','Frequency (T_0^{-1})','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(handles.gRefreshDisplay2,'Enable','on','Visible','on');
    set(handles.gShowframe2,'Visible','off','Value',1)
    set(handles.gShow2,'Enable','on');
    set(handles.gT2,'String','');
    handles.Play_Index_Display2 = 0;
    guidata(hObject,handles);
    handles.show_side_by_side(1,1) = 0;
    guidata(hObject,handles);
end
% --------------------------------------------------------------------
function gSFC_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function gSFC_Display1_Callback(hObject, eventdata, handles)
% shows the frequency chirp of the signal
n=get(handles.Loaded_Signals,'Value');
if n==0,
    errordlg('No Signal selected!','Error Dialog Box','modal');
elseif ~isempty(handles.Ploted_Data_Index_Display1),
    button = questdlg('Do you want to Erase the existing plot?','','Yes','No','Yes'); 
    if strcmp(button,'Yes'),
        handles.Ploted_Data_Index_Display1 = [3,n];
        guidata(hObject,handles);
        h=plot(handles.Time,handles.Frequency_Chirp(n,:),'Parent',handles.Display1);
        set(get(handles.Display1,'YLabel'),'String','Frequency Chirp','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(get(handles.Display1,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(handles.gRefreshDisplay1,'Enable','on','Visible','on');
        set(handles.gShowframes,'Visible','off','Value',1)
        set(handles.gShow1,'Enable','on');
        set(handles.gT1,'String','');
        handles.Play_Index_Display1 = 0;
        guidata(hObject,handles);
        handles.show_side_by_side(1,1) = 0;
        guidata(hObject,handles);
    else
        s=2;found=0;
        [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display1);
        while ~found && s<=tmp_n,
            if n==handles.Ploted_Data_Index_Display1(1,s),
                found=1;
            end
            s=s+1;
        end
        if found==0,
            handles.Ploted_Data_Index_Display1 = [handles.Ploted_Data_Index_Display1,n];
            guidata(hObject,handles);
        end
        [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display1);
        h=plot( handles.Time,handles.Frequency_Chirp(handles.Ploted_Data_Index_Display1(1,2:tmp_n),:),'Parent',handles.Display1);
        set(get(handles.Display1,'YLabel'),'String','Frequency Chirp','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(get(handles.Display1,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(handles.gRefreshDisplay1,'Enable','on','Visible','on');
        set(handles.gShowframes,'Visible','off','Value',1)
        set(handles.gShow1,'Enable','on');
        set(handles.gT1,'String','');
        handles.Play_Index_Display1 = 0;
        guidata(hObject,handles);
        handles.show_side_by_side(1,1) = 0;
        guidata(hObject,handles);
    end
else
    handles.Ploted_Data_Index_Display1 = [3,n];
    guidata(hObject,handles);
    h=plot( handles.Time,handles.Frequency_Chirp(n,:),'Parent',handles.Display1);
    set(get(handles.Display1,'YLabel'),'String','Frequency Chirp','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display1,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(handles.gRefreshDisplay1,'Enable','on','Visible','on');
    set(handles.gShowframes,'Visible','off','Value',1)
    set(handles.gShow1,'Enable','on');
    set(handles.gT1,'String','');
    handles.Play_Index_Display1 = 0;
    guidata(hObject,handles);
    handles.show_side_by_side(1,1) = 0;
    guidata(hObject,handles);
end
% --------------------------------------------------------------------
function gSFC_Display2_Callback(hObject, eventdata, handles)

n=get(handles.Loaded_Signals,'Value');
if n==0,
    errordlg('No Signal selected!','Error Dialog Box','modal');
elseif ~isempty(handles.Ploted_Data_Index_Display2),
    button = questdlg('Do you want to Erase the existing plot?','','Yes','No','Yes'); 
    if strcmp(button,'Yes'),
        handles.Ploted_Data_Index_Display2 = [3,n];
        guidata(hObject,handles);
        h=plot( handles.Time,handles.Frequency_Chirp(n,:),'Parent',handles.Display2);
        set(get(handles.Display2,'YLabel'),'String','Frequency Chirp','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(get(handles.Display2,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(handles.gRefreshDisplay1,'Enable','on','Visible','on');
        set(handles.gShowframe2,'Visible','off','Value',1)
        set(handles.gShow2,'Enable','on');
        set(handles.gT2,'String','');
        handles.Play_Index_Display2 = 0;
        guidata(hObject,handles);
        handles.show_side_by_side(1,1) = 0;
        guidata(hObject,handles);
    else
        s=2;found=0;
        [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display2);
        while ~found && s<=tmp_n,
            if n==handles.Ploted_Data_Index_Display2(1,s),
                found=1;
            end
            s=s+1;
        end
        if found==0,
            handles.Ploted_Data_Index_Display2 = [handles.Ploted_Data_Index_Display2,n];
            guidata(hObject,handles);
        end
        [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display2);
        h=plot( handles.Time,handles.Frequency_Chirp(handles.Ploted_Data_Index_Display2(1,2:tmp_n),:),'Parent',handles.Display2);
        set(get(handles.Display2,'YLabel'),'String','Frequency Chirp','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(get(handles.Display2,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(handles.gRefreshDisplay2,'Enable','on','Visible','on');
        set(handles.gShowframe2,'Visible','off','Value',1)
        set(handles.gShow2,'Enable','on');
        set(handles.gT2,'String','')
        handles.Play_Index_Display2 = 0;
        guidata(hObject,handles);
        handles.show_side_by_side(1,1) = 0;
        guidata(hObject,handles);
    end
else
    handles.Ploted_Data_Index_Display2 = [3,n];
    guidata(hObject,handles);
    h=plot( handles.Time,handles.Frequency_Chirp(n,:),'Parent',handles.Display2);
    set(get(handles.Display2,'YLabel'),'String','Frequency Chirp','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display2,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(handles.gRefreshDisplay2,'Enable','on','Visible','on');
    set(handles.gShowframe2,'Visible','off','Value',1);
    set(handles.gShow2,'Enable','on');
    set(handles.gT2,'String','')
    handles.Play_Index_Display2 = 0;
    guidata(hObject,handles);
    handles.show_side_by_side(1,1) = 0;
    guidata(hObject,handles);
end

% --------------------------------------------------------------------
function gSSig_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function gSSig_Display1_Callback(hObject, eventdata, handles)

n=get(handles.Loaded_Signals,'Value');
if n==0,
    errordlg('No Signal selected!','Error Dialog Box','modal');
elseif ~isempty(handles.Ploted_Data_Index_Display1),
    button = questdlg('Do you want to Erase the existing plot?','','Yes','No','Yes');
    if strcmp(button,'Yes'),
        handles.Ploted_Data_Index_Display1 = [1,n];
        guidata(hObject,handles);
        h=plot( handles.Time,abs(handles.Signal(n,:)).^2,'Parent',handles.Display1);
        set(get(handles.Display1,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(get(handles.Display1,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(handles.gRefreshDisplay1,'Enable','on','Visible','on');
        set(handles.gShowframes,'Visible','off','Value',1);
        set(handles.gShow1,'Enable','on');
        set(handles.gT1,'String','');
        handles.Play_Index_Display1 = 0;
        guidata(hObject,handles);
        handles.show_side_by_side(1,1) = 0;
        guidata(hObject,handles);
    else
        s=2;found=0;
        [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display1);
        while ~found && s<=tmp_n,
            if n==handles.Ploted_Data_Index_Display1(1,s),
                found=1;
            end
            s=s+1;
        end
        if found==0,
            handles.Ploted_Data_Index_Display1 = [handles.Ploted_Data_Index_Display1,n];
            guidata(hObject,handles);
        end
        [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display1);
        h=plot( handles.Time,abs(handles.Signal(handles.Ploted_Data_Index_Display1(1,2:tmp_n),:)).^2,'Parent',handles.Display1);
        set(get(handles.Display1,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(get(handles.Display1,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(handles.gRefreshDisplay1,'Enable','on','Visible','on');
        set(handles.gShowframes,'Visible','off','Value',1);
        set(handles.gShow1,'Enable','on');
        set(handles.gT1,'String','');
        handles.Play_Index_Display1 = 0;
        guidata(hObject,handles);
        handles.show_side_by_side(1,1) = 0;
        guidata(hObject,handles);
    end
else
    handles.Ploted_Data_Index_Display1 = [1,n];
    guidata(hObject,handles);
    h=plot( handles.Time,abs(handles.Signal(n,:)).^2,'Parent',handles.Display1);
    set(get(handles.Display1,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display1,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(handles.gRefreshDisplay1,'Enable','on','Visible','on');
    set(handles.gShowframes,'Visible','off','Value',1);
    set(handles.gShow1,'Enable','on');
    set(handles.gT1,'String','');
    handles.Play_Index_Display1 = 0;
    guidata(hObject,handles);
    handles.show_side_by_side(1,1) = 0;
    guidata(hObject,handles);
end

% --------------------------------------------------------------------
function gSSig_Display2_Callback(hObject, eventdata, handles)

n=get(handles.Loaded_Signals,'Value');
if n==0,
    errordlg('No Signal selected!','Error Dialog Box','modal');
elseif ~isempty(handles.Ploted_Data_Index_Display2),
    button = questdlg('Do you want to Erase the existing plot?','','Yes','No','Yes');
    if strcmp(button,'Yes'),
        handles.Ploted_Data_Index_Display2 = [1,n];
        guidata(hObject,handles);
        h=plot( handles.Time,abs(handles.Signal(n,:)).^2,'Parent',handles.Display2);
        set(get(handles.Display2,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(get(handles.Display2,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(handles.gRefreshDisplay2,'Enable','on','Visible','on');
        set(handles.gShowframe2,'Visible','off','Value',1);
        set(handles.gShow2,'Enable','on');
        set(handles.gT2,'String','')
        handles.Play_Index_Display2 = 0;
        guidata(hObject,handles);
        handles.show_side_by_side(1,1) = 0;
        guidata(hObject,handles);
    else
        s=2;found=0;
        [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display2);
        while ~found && s<=tmp_n,
            if n==handles.Ploted_Data_Index_Display2(1,s),
                found=1;
            end
            s=s+1;
        end
        if found==0,
            handles.Ploted_Data_Index_Display2 = [handles.Ploted_Data_Index_Display2,n];
            guidata(hObject,handles);
        end
        [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display2);
        h=plot( handles.Time,abs(handles.Signal(handles.Ploted_Data_Index_Display2(1,2:tmp_n),:)).^2,'Parent',handles.Display2);
        set(get(handles.Display2,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(get(handles.Display2,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(handles.gRefreshDisplay2,'Enable','on','Visible','on');
        set(handles.gShowframe2,'Visible','off','Value',1);
        set(handles.gShow2,'Enable','on');
        set(handles.gT2,'String','')
        handles.Play_Index_Display2 = 0;
        guidata(hObject,handles);
        handles.show_side_by_side(1,1) = 0;
        guidata(hObject,handles);
    end
else
    handles.Ploted_Data_Index_Display2 = [1,n]
    guidata(hObject,handles);
    h=plot( handles.Time,abs(handles.Signal(n,:)).^2,'Parent',handles.Display2);
    set(get(handles.Display2,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display2,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(handles.gRefreshDisplay2,'Enable','on','Visible','on');
    set(handles.gShowframe2,'Visible','off','Value',1);
    set(handles.gShow2,'Enable','on');
    set(handles.gT2,'String','');
    handles.Play_Index_Display2 = 0;
    guidata(hObject,handles);
    handles.show_side_by_side(1,1) = 0;
    guidata(hObject,handles);
end

% --------------------------------------------------------------------
function gSC_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Loaded_Signals_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Loaded_Signals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Loaded_Signals.
function Loaded_Signals_Callback(hObject, eventdata, handles)
% hObject    handle to Loaded_Signals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Loaded_Signals contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Loaded_Signals


% --- Executes on button press in gIS_Edit.
function gIS_Edit_Callback(hObject, eventdata, handles)
n=get(handles.Loaded_Signals,'Value');
if n==0,
    errordlg('No Signal selected!','Error Dialog Box','modal');
elseif ismember(n,handles.Input_Signal_Index)
    errordlg('Being used by Launch Module!','Error Dialog Box','modal');
else
    if handles.Signal_Spec(n,5)==2,
        prompt{1} = 'Width';
        prompt{2} = 'Chirp Parameter';
        prompt{3} = 'Amplitude'
        default_ans = {num2str(handles.Signal_Spec(n,1)),num2str(handles.Signal_Spec(n,2)),num2str(handles.Signal_Spec(n,3))};
        title = 'Parameters For Hyperbolic-Secant Pulse';
        answer = inputdlg(prompt,title,1,default_ans);
        
        if ~isempty(answer),
            %----------- Pulse Parameters ----------------
            
            handles.Signal_Spec(n,1) =str2num(answer{1})
            guidata(hObject,handles);
            handles.Signal_Spec(n,2) =str2num(answer{2});
            guidata(hObject,handles);
            handles.Signal_Spec(n,3) =str2num(answer{3});
            guidata(hObject,handles);
            Tmp_Signal=handles.Signal_Spec(n,3)*sech(handles.Time./handles.Signal_Spec(n,1)).*exp(-((handles.Signal_Spec(n,2)*sqrt(-1))/2)*(handles.Time./handles.Signal_Spec(n,1)).^2);
            handles.Signal(n,:)=Tmp_Signal; 
            guidata(hObject,handles);
            
            %--------Finding FFT of the Signal-----------------------------------
            handles.Frequency_Chirp(n,:)=-2*handles.Signal_Spec(n,2)*(handles.Time/handles.Signal_Spec(n,1))/handles.Signal_Spec(n,1);
            guidata(hObject,handles);
            tmpFFT=fft(Tmp_Signal);
            handles.Signal_Spectrum(n,:) = tmpFFT;
            handles.Loaded_Signal_Ppty(n,:) =[sqrt(var(handles.Time,abs(Tmp_Signal).^2)),sqrt(var(handles.Frequency,abs(tmpFFT).^2))];
            guidata(hObject,handles);
            tmpStr=cat(2,handles.Loaded_Signal_List,handles.Empty,num2str(handles.Loaded_Signal_Ppty(:,1)),handles.Empty,num2str(handles.Loaded_Signal_Ppty(:,2)));
            set(handles.Loaded_Signals,'String',tmpStr);
        end
    elseif handles.Signal_Spec(n,5)==1,
        prompt{1} = 'Width';
        prompt{2} = 'm';
        prompt{3} = 'Chirp Parameter';
        prompt{4} = 'Amplitude';
        default_ans = {num2str(handles.Signal_Spec(n,1)),num2str(handles.Signal_Spec(n,2)),num2str(handles.Signal_Spec(n,3)),num2str(handles.Signal_Spec(n,4))};
        title = 'Parameters For Super-Gaussian Pulse';
        answer = inputdlg(prompt,title,1,default_ans);
        
        if ~isempty(answer),
            %----------- Pulse Parameters ----------------
            
            handles.Signal_Spec(n,1) =str2num(answer{1})
            guidata(hObject,handles);
            handles.Signal_Spec(n,2) =str2num(answer{2});
            guidata(hObject,handles);
            handles.Signal_Spec(n,3) =str2num(answer{3});
            guidata(hObject,handles);
            handles.Signal_Spec(n,4) =str2num(answer{4});
            guidata(hObject,handles);
            Tmp_Signal=handles.Signal_Spec(n,4)*exp(-((1+handles.Signal_Spec(n,3)*sqrt(-1))/2)*(handles.Time./handles.Signal_Spec(n,1)).^(2*handles.Signal_Spec(n,2)));
            handles.Signal(n,:)=Tmp_Signal; 
            guidata(hObject,handles);
            %--------Finding FFT of the Signal-----------------------------------
            handles.Frequency_Chirp(n,:)=-2*handles.Signal_Spec(n,3)*handles.Signal_Spec(n,2)*((handles.Time/handles.Signal_Spec(n,1)).^(2*handles.Signal_Spec(n,2)-1))/handles.Signal_Spec(n,1);
            guidata(hObject,handles);
            tmpFFT=fft(Tmp_Signal);
            handles.Signal_Spectrum(n,:) = tmpFFT;
            handles.Loaded_Signal_Ppty(n,:) = [sqrt(var(handles.Time,abs(Tmp_Signal).^2)),sqrt(var(handles.Frequency,abs(tmpFFT).^2))];
            guidata(hObject,handles);
            tmpStr=cat(2,handles.Loaded_Signal_List,handles.Empty,num2str(handles.Loaded_Signal_Ppty(:,1)),handles.Empty,num2str(handles.Loaded_Signal_Ppty(:,2)));
            set(handles.Loaded_Signals,'String',tmpStr);
        end
    elseif handles.Signal_Spec(n,5)==0,
        errordlg('Parametrs non-editable','Error Dialog Box','modal');
    end
end

% --- Executes on button press in gRemove_IS.
function gRemove_IS_Callback(hObject, eventdata, handles)
% Remove Selected

n=get(handles.Loaded_Signals,'Value');
if n==0,
    errordlg('No Signal selected!','Error Dialog Box','modal');
    set(handles.gRemove_IS,'Enable','off');
    set(handles.gIS_Edit,'Enable','off');
elseif ismember(n,handles.Input_Signal_Index)
    errordlg('Being used by Launch Module!','Error Dialog Box','modal');
elseif handles.Signal_num==1,
    handles.Signal = [];
    guidata(hObject,handles);
    handles.Frequency_Chirp = [];
    guidata(hObject,handles);
    handles.Signal_Spectrum = [];
    guidata(hObject,handles);
    handles.Frequency_Chirp = [];
    guidata(hObject,handles);
    handles.Loaded_Signal_List = [];
    guidata(hObject,handles);
    handles.Loaded_Signal_Ppty = [];
    guidata(hObject,handles);
    handles.Ploted_Data_Index_Display1 = [];
    guidata(hObject,handles);
    handles.Ploted_Data_Index_Display2 = [];
    guidata(hObject,handles);
    handles.Empty = [];
    guidata(hObject,handles);
    handles.Signal_num = 0;
    guidata(hObject,handles);
    handles.Signal_Spec = [];
    guidata(hObject,handles);
    set(handles.Loaded_Signals,'String','','Value',handles.Signal_num);
    set(handles.gRemove_IS,'Enable','off');
    set(handles.gIS_Edit,'Enable','off');
elseif n==handles.Signal_num,
    handles.Signal = handles.Signal(1:(n-1),:);
    guidata(hObject,handles);
    handles.Frequency_Chirp = handles.Frequency_Chirp(1:(n-1),:);
    guidata(hObject,handles);
    handles.Signal_Spectrum = handles.Signal_Spectrum(1:(n-1),:);
    guidata(hObject,handles);
    handles.Loaded_Signal_List = handles.Loaded_Signal_List(1:(handles.Signal_num-1),:);
    guidata(hObject,handles);
    handles.Loaded_Signal_Ppty = handles.Loaded_Signal_Ppty(1:(n-1),:);
    guidata(hObject,handles);
    handles.Signal_Spec = handles.Signal_Spec(1:(n-1),:);
    guidata(hObject,handles);
    s=2;found=0;
    [tmp_m,tmp_n] = size(handles.Ploted_Data_Index_Display1);
    while ~found && s<=tmp_n,
        if n==handles.Ploted_Data_Index_Display1(1,s),
            found=1;
        end
        s=s+1;
    end
    if found==1&& 2==tmp_n,
        handles.Ploted_Data_Index_Display1=[];
        guidata(hObject,handles);
    elseif found ==1,
        handles.Ploted_Data_Index_Display1=[handles.Ploted_Data_Index_Display1(1,1:s-2),handles.Ploted_Data_Index_Display1(1,s:tmp_n)];
        guidata(hObject,handles);
    end
    s=2;found=0;
    [tmp_m,tmp_n] = size(handles.Ploted_Data_Index_Display2);
    while ~found && s<=tmp_n,
        if n==handles.Ploted_Data_Index_Display2(1,s),
            found=1;
        end
        s=s+1;
    end
    if found==1 && 2==tmp_n,
        handles.Ploted_Data_Index_Display2=[];
        guidata(hObject,handles);
    elseif found ==1,
        handles.Ploted_Data_Index_Display2=[handles.Ploted_Data_Index_Display2(1,1:s-2),handles.Ploted_Data_Index_Display2(1,s:tmp_n)];
        guidata(hObject,handles);
    end
    handles.Empty = handles.Empty(1:(n-1),:);
    guidata(hObject,handles);
    handles.Signal_num = handles.Signal_num - 1;
    guidata(hObject,handles);
    tmpStr = cat(2,handles.Loaded_Signal_List,handles.Empty,num2str(handles.Loaded_Signal_Ppty(:,1)),handles.Empty,num2str(handles.Loaded_Signal_Ppty(:,2)));
    set(handles.Loaded_Signals,'String',tmpStr,'Value',handles.Signal_num);
    set(handles.gRemove_IS,'Enable','on');
    set(handles.gIS_Edit,'Enable','on');
else
    handles.Loaded_Signal_List = handles.Loaded_Signal_List(1:(handles.Signal_num-1),:);
    guidata(hObject,handles);
    handles.Signal = [handles.Signal(1:(n-1),:);handles.Signal((n+1):handles.Signal_num,:)];
    guidata(hObject,handles);
    handles.Frequency_Chirp = [handles.Frequency_Chirp(1:(n-1),:);handles.Frequency_Chirp((n+1):handles.Signal_num,:)];
    guidata(hObject,handles);
    handles.Signal_Spectrum = [handles.Signal_Spectrum(1:(n-1),:);handles.Signal_Spectrum((n+1):handles.Signal_num,:)];
    guidata(hObject,handles);
    handles.Signal_Spectrum = handles.Signal_Spectrum(1:(n-1),:);
    guidata(hObject,handles);
    handles.Loaded_Signal_Ppty = [handles.Loaded_Signal_Ppty(1:(n-1),:);handles.Loaded_Signal_Ppty(n+1:(handles.Signal_num),:)];
    guidata(hObject,handles); 
    handles.Empty = [handles.Empty(1:(n-1),:);handles.Empty(n+1:(handles.Signal_num),:)];
    guidata(hObject,handles);
    handles.Signal_Spec = [handles.Signal_Spec(1:(n-1),:);handles.Signal_Spec(n+1:(handles.Signal_num),:)];
    s=2;found=0;
    [tmp_m,tmp_n] = size(handles.Ploted_Data_Index_Display1);
    while ~found && s<=tmp_n,
        if n==handles.Ploted_Data_Index_Display1(1,s),
            found=1;
        end
        s=s+1;
    end
    if found==1 && 2==tmp_n,
        handles.Ploted_Data_Index_Display1=[];
        guidata(hObject,handles);
    elseif found ==1,
        handles.Ploted_Data_Index_Display1=[handles.Ploted_Data_Index_Display1(1,1:s-2),handles.Ploted_Data_Index_Display1(1,s:tmp_n)];
        guidata(hObject,handles);
    end
    s=2;found=0;
    [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display2);
    while ~found && s<=tmp_n,
        if n==handles.Ploted_Data_Index_Display2(1,s),
            found=1;
        end
        s=s+1;
    end
    if found==1 && 2==tmp_n,
        handles.Ploted_Data_Index_Display2=[];
        guidata(hObject,handles);
    elseif found ==1,
        handles.Ploted_Data_Index_Display2=[handles.Ploted_Data_Index_Display2(1,1:s-2),handles.Ploted_Data_Index_Display2(1,s:tmp_n)];
        guidata(hObject,handles);
    end
    handles.Signal_num = handles.Signal_num-1;
    guidata(hObject,handles);
    tmpStr=cat(2,handles.Loaded_Signal_List,handles.Empty,num2str(handles.Loaded_Signal_Ppty(:,1)),handles.Empty,num2str(handles.Loaded_Signal_Ppty(:,2)));
    set(handles.Loaded_Signals,'String',tmpStr,'Value',handles.Signal_num);
    set(handles.gRemove_IS,'Enable','on');
    set(handles.gIS_Edit,'Enable','on');
end
% --------------------------------------------------------------------
function gQuit_Callback(hObject, eventdata, handles)

delete(handles.figure1);


% --- Executes on button press in gRefreshDisplay1.
function gRefreshDisplay1_Callback(hObject, eventdata, handles)

if isempty(handles.Ploted_Data_Index_Display1),
    set(handles.gRefreshDisplay1,'Enable','off');
    axes(handles.Display1);
    cla;
    set(get(handles.Display1,'YLabel'),'String','');
    set(get(handles.Display1,'XLabel'),'String','');
    set(handles.Display1,'XTickLabel','','YTickLabel','');
    set(handles.gShow1,'Enable','off');
elseif handles.Ploted_Data_Index_Display1(1,1)==1,
    [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display1);
    h=plot( handles.Time,abs(handles.Signal(handles.Ploted_Data_Index_Display1(1,2:tmp_n),:)).^2,'Parent',handles.Display1);
    set(get(handles.Display1,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display1,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
elseif handles.Ploted_Data_Index_Display1(1,1)==2,
    [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display1);
    h=plot( fftshift(handles.Frequency),((1/handles.Samples_Num)*abs(fftshift(handles.Signal_Spectrum(handles.Ploted_Data_Index_Display1(1,2:tmp_n),:)))).^2,'Parent',handles.Display1);
    set(get(handles.Display1,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display1,'XLabel'),'String','Frequency (T_0^{-1})','FontSize',12,'FontName','Courier New','FontWeight','bold')
else
    [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display1);
    h=plot( handles.Time,handles.Frequency_Chirp(handles.Ploted_Data_Index_Display1(1,2:tmp_n),:),'Parent',handles.Display1);
    set(get(handles.Display1,'YLabel'),'String','Frequency Chirp','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display1,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
end


% --- Executes on button press in gRefreshDisplay2.
function gRefreshDisplay2_Callback(hObject, eventdata, handles)

if isempty(handles.Ploted_Data_Index_Display2),
    set(handles.gRefreshDisplay2,'Enable','off');
    axes(handles.Display2);
    cla;
    set(get(handles.Display2,'YLabel'),'String','');
    set(get(handles.Display2,'XLabel'),'String','');
    set(handles.Display2,'XTickLabel','','YTickLabel','');
    set(handles.gShow2,'Enable','off');
elseif handles.Ploted_Data_Index_Display2(1,1)==1,
    [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display2);
    h=plot( handles.Time,abs(handles.Signal(handles.Ploted_Data_Index_Display2(1,2:tmp_n),:)).^2,'Parent',handles.Display2);
    set(get(handles.Display2,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display2,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
elseif handles.Ploted_Data_Index_Display2(1,1)==2,
    [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display2);
    h=plot( fftshift(handles.Frequency),((1/handles.Samples_Num)*abs(fftshift(handles.Signal_Spectrum(handles.Ploted_Data_Index_Display2(1,2:tmp_n),:)))).^2,'Parent',handles.Display2);
    set(get(handles.Display2,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display2,'XLabel'),'String','Frequency (T_0^{-1})','FontSize',12,'FontName','Courier New','FontWeight','bold')
else
    [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display2);
    h=plot( handles.Time,handles.Frequency_Chirp(handles.Ploted_Data_Index_Display2(1,2:tmp_n),:),'Parent',handles.Display2);
    set(get(handles.Display2,'YLabel'),'String','Frequency Chirp','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display2,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
end


% --- Executes on button press in gShow1.
function gShow1_Callback(hObject, eventdata, handles)
if handles.Play_Index_Display1==1,
    n = get(handles.gLaunch_List,'Value');
    i = floor(get(handles.gShowframes,'Value'));
    m = sum(handles.Media_Ppty(:,2,n));
    figure(2)
    plot(handles.Time,abs(handles.Launch_Data_Signal(i,:,n)).^2);
    grid off
    axis on
    axis([-handles.Para_Mov(1,2)/2 handles.Para_Mov(1,2)/2 0 handles.Para_Mov(1,3)])
    ylabel('Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    xlabel('Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
elseif handles.Play_Index_Display1==2,
    n = get(handles.gLaunch_List,'Value');
    i = floor(get(handles.gShowframes,'Value'));
    m = sum(handles.Media_Ppty(:,2,n));
    figure(2)
    plot(fftshift(handles.Frequency),abs(fftshift(handles.Launch_Data_Spectrum(i,:,n))).^2);
    grid off
    axis on
    axis([-handles.Para_Mov(2,2)/2 handles.Para_Mov(2,2)/2 0 handles.Para_Mov(2,3)])
    ylabel('Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    xlabel('Frequency (T_0^{-1})','FontSize',12,'FontName','Courier New','FontWeight','bold')
else
    if isempty(handles.Ploted_Data_Index_Display1),
        errordlg('The Signal has been removed!','Error Dialog Box','modal');
        set(handles.gShow1,'Enable','off');
    elseif handles.Ploted_Data_Index_Display1(1,1)==1,
        figure(2);
        [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display1);
        h=plot( handles.Time,abs(handles.Signal(handles.Ploted_Data_Index_Display1(1,2:tmp_n),:)).^2);
        xlabel('Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        ylabel('Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    elseif handles.Ploted_Data_Index_Display1(1,1)==2,
        figure(2);
        [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display1);
        h=plot( fftshift(handles.Frequency),((1/handles.Samples_Num)*abs(fftshift(handles.Signal_Spectrum(handles.Ploted_Data_Index_Display1(1,2:tmp_n),:)))).^2);
        xlabel('Frequency (T_0^{-1})','FontSize',12,'FontName','Courier New','FontWeight','bold')
        ylabel('Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    else
        figure(2);
        [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display1);
        h=plot(handles.Time,handles.Frequency_Chirp(handles.Ploted_Data_Index_Display1(1,2:tmp_n),:));
        xlabel('Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        ylabel('Frequency Chirp','FontSize',12,'FontName','Courier New','FontWeight','bold')
    end
end

% --- Executes on button press in gShow2.
function gShow2_Callback(hObject, eventdata, handles)

if handles.Play_Index_Display2==1,
    n = get(handles.gLaunch_List,'Value');
    i = floor(get(handles.gShowframes,'Value'));
    m = sum(handles.Media_Ppty(:,2,n));
    figure(3)
    plot(handles.Time,abs(handles.Launch_Data_Signal(i,:,n)).^2);
    grid off
    axis on
    axis([-handles.Para_Mov(1,2)/2 handles.Para_Mov(1,2)/2 0 handles.Para_Mov(1,3)])
    ylabel('Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    xlabel('Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
elseif handles.Play_Index_Display2==2,
    n = get(handles.gLaunch_List,'Value');
    i = floor(get(handles.gShowframe2,'Value'));
    m = sum(handles.Media_Ppty(:,2,n));
    figure(3)
    plot(fftshift(handles.Frequency),abs(fftshift(handles.Launch_Data_Spectrum(i,:,n))).^2);
    grid off
    axis on
    axis([-handles.Para_Mov(2,2)/2 handles.Para_Mov(2,2)/2 0 handles.Para_Mov(2,3)])
    ylabel('Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    xlabel('Frequency (T_0^{-1})','FontSize',12,'FontName','Courier New','FontWeight','bold')
else
    if isempty(handles.Ploted_Data_Index_Display2),
        errordlg('The Signal has been removed!','Error Dialog Box','modal');
        set(handles.gShow2,'Enable','off');
    elseif handles.Ploted_Data_Index_Display2(1,1)==1,
        figure(3);
        [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display2);
        h=plot( handles.Time,abs(handles.Signal(handles.Ploted_Data_Index_Display2(1,2:tmp_n),:)).^2);
        xlabel('Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        ylabel('Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    elseif handles.Ploted_Data_Index_Display2(1,1)==2,
        figure(3);
        [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display2);
        h=plot( fftshift(handles.Frequency),((1/handles.Samples_Num)*abs(fftshift(handles.Signal_Spectrum(handles.Ploted_Data_Index_Display2(1,2:tmp_n),:)))).^2);
        xlabel('Frequency (T_0^{-1})','FontSize',12,'FontName','Courier New','FontWeight','bold')
        ylabel('Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    else
        figure(3);
        [tmp_m,tmp_n]=size(handles.Ploted_Data_Index_Display2);
        h=plot( handles.Time,handles.Frequency_Chirp(handles.Ploted_Data_Index_Display2(1,2:tmp_n),:));
        xlabel('Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        ylabel('Frequency Chirp','FontSize',12,'FontName','Courier New','FontWeight','bold')
    end
end

% --- Executes during object creation, after setting all properties.
function gLaunch_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gLaunch_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in gLaunch_List.
function gLaunch_List_Callback(hObject, eventdata, handles)

% --- Executes on button press in gL_Remove.
function gL_Remove_Callback(hObject, eventdata, handles)


% --- Executes on button press in gL_Edit.
function gL_Edit_Callback(hObject, eventdata, handles)
n=get(handles.gLaunch_List,'Value');
[selection,ok] = listdlg('ListString',handles.Loaded_Signal_List,'SelectionMode','single','InitialValue', handles.Input_Signal_Index(n,1),'Name','Choose Input Signal','ListSize',[150 100]);
if ~isempty(selection),
    handles.Input_Signal_Index(n,1) = selection;
end
if handles.Special_Medium_Index(1,n)==0,
    for j=1:4,
        prompt{1} = 'Length';
        prompt{2} = 'Number of Points Along the Length';
        prompt{3} = 'Second order GVD';
        prompt{4} = 'Third order GVD';
        prompt{5} = 'Nonlinear Coefficient';
        prompt{6} = 'Absorption Coefficient';
        prompt{7} = 'Self-steepening Parameter';
        prompt{8} = 'Raman Scattering Parameter';
        default_ans ={num2str(handles.Media_Ppty(j,1,n)),num2str(handles.Media_Ppty(j,2,n)),num2str(handles.Media_Ppty(j,3,n)),num2str(handles.Media_Ppty(j,4,n)),num2str(handles.Media_Ppty(j,5,n)),num2str(handles.Media_Ppty(j,6,n)),num2str(handles.Media_Ppty(j,7,n)),num2str(handles.Media_Ppty(j,8,n))}; 
        title = ['Medium Parameters For Medium ',num2str(j)];
        answer = inputdlg(prompt,title,1,default_ans);
        if ~isempty(answer),
            handles.Media_Ppty(j,1,n)=str2num(answer{1});
            handles.Media_Ppty(j,2,n)=str2num(answer{2});
            handles.Media_Ppty(j,3,n)=str2num(answer{3});
            handles.Media_Ppty(j,4,n)=str2num(answer{4});
            handles.Media_Ppty(j,5,n)=str2num(answer{5});
            handles.Media_Ppty(j,6,n)=str2num(answer{6});
            handles.Media_Ppty(j,7,n)=str2num(answer{7});
            handles.Media_Ppty(j,8,n)=str2num(answer{8});
        end
    end
else
    
    for j=1:4,
        prompt{1} = 'Length';
        prompt{2} = 'Number of Points Along the Length';
        prompt{3} = 'Second order GVD';
        prompt{4} = 'Third order GVD';
        prompt{5} = 'Nonlinear Coefficient';
        prompt{6} = 'Absorption Coefficient';
        prompt{7} = 'Self-steepening Parameter';
        prompt{8} = 'Raman Scattering Parameter';
        default_ans ={num2str(handles.Media_Ppty(j,1,n)),num2str(handles.Media_Ppty(j,2,n)), handles.fun_Second_order_GVD{n,j} ,num2str(handles.Media_Ppty(j,4,n)),num2str(handles.Media_Ppty(j,5,n)),num2str(handles.Media_Ppty(j,6,n)),num2str(handles.Media_Ppty(j,7)),num2str(handles.Media_Ppty(j,8,n))}; 
        title = ['Medium Parameters For Medium ',num2str(j)];
        answer = inputdlg(prompt,title,1,default_ans);
        if ~isempty(answer),
            handles.Media_Ppty(j,1,n) = str2num(answer{1});
            handles.Media_Ppty(j,2,n) = str2num(answer{2});
            handles.fun_Second_order_GVD{handles.Launch_Signal_num,j} = answer{3};
            guidata(hObject,handles);
            handles.Media_Ppty(j,4,n) = str2num(answer{4});
            handles.Media_Ppty(j,5,n) = str2num(answer{5});
            handles.Media_Ppty(j,6,n) = str2num(answer{6});
            handles.Media_Ppty(j,7,n) = str2num(answer{7});
            handles.Media_Ppty(j,8,n) = str2num(answer{8});
        end
    end
end
handles.Launch_Status(n,:) =['waiting.......'];
guidata(hObject,handles);
tmpStr=cat(2,handles.Launch_Signal_List,handles.L_Empty,handles.Loaded_Signal_List(handles.Input_Signal_Index,:),handles.L_Empty,handles.Launch_Status);
set(handles.gLaunch_List,'String',tmpStr,'Value',n);


% --- Executes on button press in gLaunch_Signal.
function gLaunch_Signal_Callback(hObject, eventdata, handles)
%   NLSE:   U_Z = a*j*U_TT + b*U_TTT - N_L^2*|U|^2*U
%   a=+\-(1);
%   b=L_2D/L_3D;
%   N_L^2=L_2D/L_NL
%   Z=z/L_2D;
%   W--> Time Window
n = get(handles.gLaunch_List,'Value');
Omega = handles.Frequency;
Input = handles.Signal(handles.Input_Signal_Index(n,1),:);
tmp_Launch_Data_Signal = [];
tmp_Launch_Data_Spectrum = [];
tmp_z=[0];
tmp_var_T=[];
tmp_var_freq=[];
z = 0;
for j=1:4,
    if handles.Media_Ppty(j,1,n)~=0,
        h = handles.Media_Ppty(j,1,n)/handles.Media_Ppty(j,2,n);
        if handles.Special_Medium_Index(1,n)==0,
            a = inline(num2str(handles.Media_Ppty(j,3,n)),'z');
        else
            a = inline(handles.fun_Second_order_GVD{n,j},'z');
        end
        b = handles.Media_Ppty(j,4,n);
        N_L = handles.Media_Ppty(j,5,n);
        alpha = handles.Media_Ppty(j,6,n);
        s = handles.Media_Ppty(j,7,n);
        T_R = handles.Media_Ppty(j,8,n);
        M = handles.Media_Ppty(j,2,n);
        %------------------------------------------
        % Collocation Points
        %------------------------------------------
        
        OUT= zeros(M,handles.Samples_Num);
        OUTf = zeros(M,handles.Samples_Num);
        OUT(1,:) = Input;
        OUTf(1,:) = (fft(OUT(1,:))); % FFT of the Input Signal
        for i=1:M,
            E2 = exp(-0.5*sqrt(-1)*a(i*h)*h*(Omega.*Omega)/2);
            E3 = exp(-sqrt(-1)*b*h*Omega.*Omega.*Omega/2);
            z = z + h;
            tmp_z = [tmp_z, z];
            tmpOUT = ifft(fft(exp(alpha*i*h)*OUT(i,:)).*E2.*E3);
            K1 = F(i*h+h,N_L,s,T_R,tmpOUT,Omega,alpha)*h;
            K2 = F(i*h+h/2,N_L,s,T_R,tmpOUT+K1/2,Omega,alpha)*h;
            K3 = F(i*h+h/2,N_L,s,T_R,tmpOUT+K2/2,Omega,alpha)*h;
            K4 = F(i*h+h,N_L,s,T_R,tmpOUT+K3,Omega,alpha)*h;
            tmpOUT = tmpOUT+(K1+2*K2+2*K3+K4)/6;
            OUTf(i+1,:) = exp(-alpha*i*h)*fft(tmpOUT).*(E2.*E3);
            OUT(i+1,:) = exp(-alpha*i*h)*ifft(fft(tmpOUT).*(E2.*E3));
            tmp_var_T = [tmp_var_T, sqrt(var(handles.Time,abs(OUT(i,:)).^2))];
            tmp_var_freq =[tmp_var_freq, sqrt(var(handles.Frequency,abs(OUTf(i,:)).^2))];
            
        end
        Input = OUT(M+1,:);
        tmp_Launch_Data_Signal = [tmp_Launch_Data_Signal; OUT(1:M,:)];
        tmp_Launch_Data_Spectrum = [tmp_Launch_Data_Spectrum; OUTf(1:M,:)];
    end
end
m = sum(handles.Media_Ppty(:,2,n));
handles.z(n,:) = [tmp_z(1,1:m),zeros(1,(handles.Step_N-m))];
guidata(hObject,handles);
handles.Launch_Data_Signal(:,:,n) = [tmp_Launch_Data_Signal; zeros((handles.Step_N-m),handles.Samples_Num)];
guidata(hObject,handles);
handles.Launch_Data_Spectrum(:,:,n) = [tmp_Launch_Data_Spectrum; zeros(handles.Step_N-m,handles.Samples_Num)];
guidata(hObject,handles);
handles.Launch_Data_Signal_chirp(:,:,n) = [angle(tmp_Launch_Data_Signal); zeros((handles.Step_N-m),handles.Samples_Num)];
guidata(hObject,handles);
handles.Launch_Data_Signal_Ppty(:,:,n) = cat(2,[tmp_var_T;tmp_var_freq], zeros(2,(handles.Step_N-m)));
guidata(hObject,handles);
handles.Launch_Status(n,:) = '     Done     ' ;
guidata(hObject,handles);
tmpStr = cat(2,handles.Launch_Signal_List,handles.L_Empty,handles.Loaded_Signal_List(handles.Input_Signal_Index,:),handles.L_Empty,handles.Launch_Status);
set(handles.gLaunch_List,'String',tmpStr,'Value',n);
% --------------------------------------------------------------------
%--------------------------------------------------------------------------
function r=F(z,N_L,s,T_R,U,Omega,alpha)
tmp = ifft(Omega.*fft(U));
r=-(N_L)*sqrt(-1)*exp(-alpha*z)*((abs(U).^2).*U + (2*s-sqrt(-1)*T_R)*(abs(U).^2).*tmp - (s-sqrt(-1)*T_R)*(U.^2).*conj(tmp));
%----------------------------------------------------------------------
function gSelect_Media_Callback(hObject, eventdata, handles)
% Selecting Media for launching the pulse
if get(handles.Loaded_Signals,'Value')==0,
    errordlg('No Signal selected!','Error Dialog Box','modal');
else
    prompt{1} = 'Number of Media';
    default_ans = {'1'};
    title = 'Selecting Media';
    answer = inputdlg(prompt,title,1,default_ans);
    if ~isempty(answer),
        tmp = str2num(answer{1});
        handles.Launch_Signal_num = handles.Launch_Signal_num+1;
        guidata(hObject,handles);
        handles.Input_Signal_Index  = [handles.Input_Signal_Index;get(handles.Loaded_Signals,'Value')];
        guidata(hObject,handles);
        tmp_Media_Ppty = zeros(4,8);
        for j=1:tmp,
            tmp_Media_Ppty(j,:) = [1,100,1,0,1,0,0,0];
            prompt{1} = 'Length';
            prompt{2} = 'Number of Points Along the Length';
            prompt{3} = 'Second order GVD';
            prompt{4} = 'Third order GVD';
            prompt{5} = 'Nonlinear Coefficient';
            prompt{6} = 'Absorption Coefficient';
            prompt{7} = 'Self-steepening Parameter';
            prompt{8} = 'Raman Scattering Parameter';
            default_ans ={num2str(tmp_Media_Ppty(j,1)),num2str(tmp_Media_Ppty(j,2)),num2str(tmp_Media_Ppty(j,3)),num2str(tmp_Media_Ppty(j,4)),num2str(tmp_Media_Ppty(j,5)),num2str(tmp_Media_Ppty(j,6)),num2str(tmp_Media_Ppty(j,7)),num2str(tmp_Media_Ppty(j,7))}; 
            title = ['Medium Parameters For Medium ',num2str(j)];
            answer = inputdlg(prompt,title,1,default_ans);
            if ~isempty(answer),
                tmp_Media_Ppty(j,1)=str2num(answer{1});
                tmp_Media_Ppty(j,2)=str2num(answer{2});
                tmp_Media_Ppty(j,3)=str2num(answer{3});
                tmp_Media_Ppty(j,4)=str2num(answer{4});
                tmp_Media_Ppty(j,5)=str2num(answer{5});
                tmp_Media_Ppty(j,6)=str2num(answer{6});
                tmp_Media_Ppty(j,7)=str2num(answer{7});
                tmp_Media_Ppty(j,8)=str2num(answer{8});
            end
        end
        handles.Para_3D(handles.Launch_Signal_num,1) = 10;
        guidata(hObject,handles);
        handles.Media_Ppty(:,:,handles.Launch_Signal_num) = tmp_Media_Ppty;
        guidata(hObject,handles);
        handles.Special_Medium_Index =[handles.Special_Medium_Index,0];
        guidata(hObject,handles);
        handles.Launch_Signal_List=[handles.Launch_Signal_List; ['L',num2str(handles.Launch_Signal_num)]];
        guidata(hObject,handles);
        handles.L_Empty = [handles.L_Empty;'          '];
        guidata(hObject,handles);
        handles.Launch_Status = [handles.Launch_Status ; 'waiting.......'];
        guidata(hObject,handles);
        tmpStr=cat(2,handles.Launch_Signal_List,handles.L_Empty,handles.Loaded_Signal_List(handles.Input_Signal_Index,:),handles.L_Empty,handles.Launch_Status);
        set(handles.gLaunch_List,'String',tmpStr,'Value',handles.Launch_Signal_num);
        set(handles.gL_Remove,'Enable','on');
        set(handles.gL_Edit,'Enable','on');
        set(handles.gLaunch_Signal,'Enable','on');
    end
end    
% --- Executes on button press in gL_Refresh.
function gL_Refresh_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function gOSPM_Callback(hObject, eventdata, handles)
n=handles.Step_N;
prompt{1} = 'Size';
default_ans = {num2str(handles.Step_N)};
title = 'Optimum Size of Propagation Matrix';
answer = inputdlg(prompt,title,1,default_ans);
if ~isempty(answer),
    handles.Step_N = str2num(answer{1});
    guidata(hObject,handles);
    if handles.Launch_Signal_num~=0;
        handles.z = cat(2,handles.z,zeros(handles.Launch_Signal_num,handles.Step_N-n));
        guidata(hObject,handles);
        handles.Launch_Data_Signal = cat(1, handles.Launch_Data_Signal, zeros(handles.Step_N-n, handles.Samples_Num, handles.Launch_Signal_num));
        guidata(hObject,handles);
        handles.Launch_Data_Signal_chirp = cat(1, handles.Launch_Data_Signal_chirp, zeros(handles.Step_N-n, handles.Samples_Num, handles.Launch_Signal_num));
        guidata(hObject,handles);
        handles.Launch_Data_Spectrum = cat(1, handles.Launch_Data_Spectrum, zeros(handles.Step_N-n, handles.Samples_Num, handles.Launch_Signal_num));
        guidata(hObject,handles);
        handles.Launch_Data_Signal_Ppty = cat(2,handles.Launch_Data_Signal_Ppty, zeros(2,(handles.Step_N-n),handles.Launch_Signal_num));
        guidata(hObject,handles);
    end
end


% --------------------------------------------------------------------
function g3DV_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function g3D_SP_Callback(hObject, eventdata, handles)
% sets parameters for the 3d view.
n = get(handles.gLaunch_List,'Value');
if handles.Launch_Signal_num==0,
    errordlg('Launch Data Unavailable!','Error Dialog Box','modal');
else
    prompt{1} = 'Skip #Elements';
    default_ans = {num2str(handles.Para_3D(n,1))};
    title = 'Parameters';
    answer = inputdlg(prompt,title,1,default_ans);
    if ~isempty(answer),
        handles.Para_3D(n,1) = str2num(answer{1});
        guidata(hObject,handles);
    end
end

% --------------------------------------------------------------------
function g3DShow_Callback(hObject, eventdata, handles)
n = get(handles.gLaunch_List,'Value');
if handles.Launch_Signal_num==0,
    errordlg('Launch Data Unavailable!','Error Dialog Box','modal');
else
    figure(n+3)
    Z=ones(1,handles.Samples_Num);
    m = sum(handles.Media_Ppty(:,2,n));
    hold on
    view(-50,50);
    xlabel('Distance(L_D)','FontSize',12,'FontName','Courier New','FontWeight','bold');
    ylabel('Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold');
    zlabel('Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold');
    title('Pulse Propagation','FontSize',12,'FontName','Courier New','FontWeight','bold')
    for i=1:handles.Para_3D(n,1):m,
        plot3(handles.z(n,i)*Z,handles.Time,abs(handles.Launch_Data_Signal(i,:,n)).^2);
    end
    hold off
end
%--------------------------------------------------------------------
function g3DShow_Spect_Callback(hObject, eventdata, handles)
n = get(handles.gLaunch_List,'Value');
if handles.Launch_Signal_num==0,
    errordlg('Launch Data Unavailable!','Error Dialog Box','modal');
else
    figure(n+7)
    Z=ones(1,handles.Samples_Num);
    m = sum(handles.Media_Ppty(:,2,n));
    hold on
    view(-50,50);
    xlabel('Distance(L_D)','FontSize',12,'FontName','Courier New','FontWeight','bold');
    ylabel('\omega (T_0^{-1})','FontSize',12,'FontName','Courier New','FontWeight','bold');
    zlabel('Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold');
    title('Pulse Propagation','FontSize',12,'FontName','Courier New','FontWeight','bold')
    for i=1:handles.Para_3D(n,1):m,
        tmp_frequency = fftshift(handles.Frequency);
        tmp_intensity = abs(fftshift(handles.Launch_Data_Spectrum(i,:,n))).^2;
        plot3(handles.z(n,i)*Z(400:600),tmp_frequency(400:600),tmp_intensity(400:600));
    end
    hold off
end
% --------------------------------------------------------------------
function gMov_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function gAP_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function gPlay_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function gM_Display1_Callback(hObject, eventdata, handles)
n = get(handles.gLaunch_List,'Value');
if handles.Launch_Signal_num==0,
    errordlg('Launch Data Unavailable!','Error Dialog Box','modal');
else
    m = sum(handles.Media_Ppty(:,2,n));
    h = plot(handles.Time,abs(handles.Launch_Data_Signal(1,:,n)).^2,'Parent',handles.Display1);
    grid off
    axis on
    set(handles.Display1,'XLim',[-handles.Para_Mov(1,2)/2 handles.Para_Mov(1,2)/2],'YLim',[0 handles.Para_Mov(1,3)])
    set(get(handles.Display1,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display1,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
    M(1)=getframe;
    set(h,'EraseMode','xor')
    for i=1:(m-1),
        set(h,'XData',handles.Time,'YData',abs(handles.Launch_Data_Signal(i+1,:,n)).^2);
        grid off
        axis on
        set(handles.Display1,'XLim',[-handles.Para_Mov(1,2)/2 handles.Para_Mov(1,2)/2],'YLim',[0 handles.Para_Mov(1,3)])
        M(i+1)=getframe;
    end
end
% --------------------------------------------------------------------
function gM_Display2_Callback(hObject, eventdata, handles)
n = get(handles.gLaunch_List,'Value');
if handles.Launch_Signal_num==0,
    errordlg('Launch Data Unavailable!','Error Dialog Box','modal');
else
    m = sum(handles.Media_Ppty(:,2,n));
    h = plot(handles.Time,abs(handles.Launch_Data_Signal(1,:,n)).^2,'Parent',handles.Display2);
    grid off
    axis on
    set(handles.Display2,'XLim',[-handles.Para_Mov(1,2)/2 handles.Para_Mov(1,2)/2],'YLim',[0 handles.Para_Mov(1,3)])
    set(get(handles.Display2,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display2,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
    M(1)=getframe;
    set(h,'EraseMode','xor')
    for i=1:(m-1),
        set(h,'XData',handles.Time,'YData',abs(handles.Launch_Data_Signal(i+1,:,n)).^2);
        grid off
        axis on
        set(handles.Display2,'XLim',[-handles.Para_Mov(1,2)/2 handles.Para_Mov(1,2)/2],'YLim',[0 handles.Para_Mov(1,3)])
        M(i+1)=getframe;
    end
end
% --------------------------------------------------------------------
function gM_SP_Callback(hObject, eventdata, handles)
% Set parameters for Movie
prompt{1} = 'Frames Per Sec';
prompt{2} = 'Time Window';
prompt{3} = 'Intensity';
default_ans = {num2str(handles.Para_Mov(1,1)),num2str(handles.Para_Mov(1,2)),num2str(handles.Para_Mov(1,3))};
title = 'Parameters For Signal Display';
answer = inputdlg(prompt,title,1,default_ans);
if ~isempty(answer),
    handles.Para_Mov(1,1) = str2num(answer{1});
    guidata(hObject,handles);
    handles.Para_Mov(1,2) = str2num(answer{2});
    guidata(hObject,handles);
    handles.Para_Mov(1,3) = str2num(answer{3});
    guidata(hObject,handles);
end
prompt{1} = 'Frames Per Sec';
prompt{2} = 'Frequency Limit';
prompt{3} = 'Intensity';
default_ans = {num2str(handles.Para_Mov(2,1)),num2str(handles.Para_Mov(2,2)),num2str(handles.Para_Mov(2,3))};
title = 'Parameters For Spectrum Display';
answer = inputdlg(prompt,title,1,default_ans);
if ~isempty(answer),
    handles.Para_Mov(2,1) = str2num(answer{1});
    guidata(hObject,handles);
    handles.Para_Mov(2,2) = str2num(answer{2});
    guidata(hObject,handles);
    handles.Para_Mov(2,3) = str2num(answer{3});
    guidata(hObject,handles);
end

% --------------------------------------------------------------------
function gWV_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function gSW_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function gShowframes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gShowframes (see GCBO)
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
% --------------------------------------------------------------
function gSnap_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function gSnap_Display1_Callback(hObject, eventdata, handles)
if handles.Launch_Signal_num==0,
    errordlg('Launch Data Unavailable!','Error Dialog Box','modal');
else
    handles.Play_Index_Display1 = 1;
    guidata(hObject,handles);
    handles.show_side_by_side(1,1) = 0;
    guidata(hObject,handles);
    set(handles.gShowframes,'Max',handles.Step_N,'Visible','on','Value',1)
    set(handles.gRefreshDisplay1,'Visible','off')
    set(handles.gShow1,'Enable','on')
end
% --------------------------------------------------------------------
function gsnap_Display2_Callback(hObject, eventdata, handles)
if handles.Launch_Signal_num==0,
    errordlg('Launch Data Unavailable!','Error Dialog Box','modal');
else
    handles.Play_Index_Display2 = 1;
    guidata(hObject,handles);
    handles.show_side_by_side(1,1) = 0;
    guidata(hObject,handles);
    set(handles.gShowframe2,'Max',handles.Step_N,'Visible','on','Value',1)
    set(handles.gRefreshDisplay2,'Visible','off');
    set(handles.gShow2,'Enable','on');
end
% --- Executes on slider movement.
function gShowframes_Callback(hObject, eventdata, handles)
if handles.Play_Index_Display1==1;
    n = get(handles.gLaunch_List,'Value');
    i = floor(get(handles.gShowframes,'Value'));
    m = sum(handles.Media_Ppty(:,2,n));
    if handles.show_side_by_side(1,1)==1,
        h = plot(handles.Time(1,1:handles.Samples_Num-1),diff(unwrap(handles.Launch_Data_Signal_chirp(i,:,n)))./diff(handles.Time),'Parent',handles.Display2);
        grid off
        axis on
        set(handles.Display2,'XLim',[-handles.FC_SAL(1,3)/2 handles.FC_SAL(1,3)/2],'YLim',[handles.FC_SAL(1,1) handles.FC_SAL(1,2)])
        set(get(handles.Display2,'YLabel'),'String','Frequency Chirp','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(get(handles.Display2,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(handles.gShowframe2,'Visible','off','Value',1);
        set(handles.gRefreshDisplay2,'Visible','on','Enable','off');
        set(handles.gShow2,'Enable','off');
        set(handles.gT2,'String',['n=',num2str(i),',','z=',num2str(handles.z(n,i)),'(L_D)']);
    end
    h = plot(handles.Time,abs(handles.Launch_Data_Signal(i,:,n)).^2,'Parent',handles.Display1);
    grid off
    axis on
    set(handles.Display1,'XLim',[-handles.Para_Mov(1,2)/2 handles.Para_Mov(1,2)/2],'YLim',[0 handles.Para_Mov(1,3)])
    set(get(handles.Display1,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display1,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(handles.gT1,'String',['n=',num2str(i),',','z=',num2str(handles.z(n,i)),'(L_D)']);
else
    n = get(handles.gLaunch_List,'Value');
    i = floor(get(handles.gShowframes,'Value'));
    m = sum(handles.Media_Ppty(:,2,n));
    if handles.show_side_by_side(1,1)==1,
        h = plot(handles.Time(1,1:handles.Samples_Num-1),diff(unwrap(handles.Launch_Data_Signal_chirp(i,:,n)))./diff(handles.Time),'Parent',handles.Display2);
        grid off
        axis on
        set(handles.Display2,'XLim',[-handles.FC_SAL(1,3)/2 handles.FC_SAL(1,3)/2],'YLim',[handles.FC_SAL(1,1) handles.FC_SAL(1,2)])
        set(get(handles.Display2,'YLabel'),'String','Frequency Chirp','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(get(handles.Display2,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(handles.gShowframe2,'Visible','off','Value',1);
        set(handles.gRefreshDisplay2,'Visible','on','Enable','off');
        set(handles.gShow2,'Enable','off');
        set(handles.gT2,'String',['n=',num2str(i),',','z=',num2str(handles.z(n,i)),'(L_D)']);
    end
    h = plot(fftshift(handles.Frequency),abs(fftshift(handles.Launch_Data_Spectrum(i,:,n))).^2,'Parent',handles.Display1);
    grid off
    axis on
    set(handles.Display1,'XLim',[-handles.Para_Mov(2,2)/2 handles.Para_Mov(2,2)/2],'YLim',[0 handles.Para_Mov(2,3)])
    set(get(handles.Display1,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display1,'XLabel'),'String','Frequency (T_0^{-1})','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(handles.gT1,'String',['n=',num2str(i),',','z=',num2str(handles.z(n,i)),'(L_D)']);
end


% --- Executes during object creation, after setting all properties.
function gShowframe2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gShowframe2 (see GCBO)
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

function gShowframe2_Callback(hObject, eventdata, handles)
if handles.Play_Index_Display2==1;
    n = get(handles.gLaunch_List,'Value');
    i = floor(get(handles.gShowframe2,'Value'));
    m = sum(handles.Media_Ppty(:,2,n));
    h = plot(handles.Time,abs(handles.Launch_Data_Signal(i,:,n)).^2,'Parent',handles.Display2);
    grid off
    axis on
    set(handles.Display2,'XLim',[-handles.Para_Mov(1,2)/2 handles.Para_Mov(1,2)/2],'YLim',[0 handles.Para_Mov(1,3)])
    set(get(handles.Display2,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display2,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(handles.gT2,'String',['n=',num2str(i),',','z=',num2str(handles.z(n,i)),'(L_D)']);
    if handles.show_side_by_side(1,1)==1,
        h = plot(handles.Time,unwrap(handles.Launch_Data_Signal_chirp(i,:,n)),'Parent',handles.Display1);
        grid off
        axis on
        set(handles.Display1,'XLim',[-handles.FC_SAL(1,3)/2 handles.FC_SAL(1,3)/2],'YLim',[handles.FC_SAL(1,1) handles.FC_SAL(1,2)])
        set(get(handles.Display1,'YLabel'),'String','Frequency Chirp','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(get(handles.Display1,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(handles.gShowframes,'Visible','off','Value',1);
        set(handles.gRefreshDisplay1,'Visible','on','Enable','off');
        set(handles.gShow1,'Enable','off');
        set(handles.gT1,'String',['n=',num2str(i),',','z=',num2str(handles.z(n,i)),'(L_D)']);
    end
else
    n = get(handles.gLaunch_List,'Value');
    i = floor(get(handles.gShowframe2,'Value'));
    m = sum(handles.Media_Ppty(:,2,n));
    h = plot(fftshift(handles.Frequency),abs(fftshift(handles.Launch_Data_Spectrum(i,:,n))).^2,'Parent',handles.Display2);
    grid off
    axis on
    set(handles.Display2,'XLim',[-handles.Para_Mov(2,2)/2 handles.Para_Mov(2,2)/2],'YLim',[0 handles.Para_Mov(2,3)])
    set(get(handles.Display2,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display2,'XLabel'),'String','Frequency (T_0^{-1})','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(handles.gT2,'String',['n=',num2str(i),',','z=',num2str(handles.z(n,i)),'(L_D)']);
    if handles.show_side_by_side(1,1)==1,
        h = plot(handles.Time,unwrap(handles.Launch_Data_Signal_chirp(i,:,n)),'Parent',handles.Display1);
        grid off
        axis on
        set(handles.Display1,'XLim',[-handles.FC_SAL(1,3)/2 handles.FC_SAL(1,3)/2],'YLim',[handles.FC_SAL(1,1) handles.FC_SAL(1,2)])
        set(get(handles.Display1,'YLabel'),'String','Frequency Chirp','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(get(handles.Display1,'XLabel'),'String','Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        set(handles.gShowframes,'Visible','off','Value',1)
        set(handles.gRefreshDisplay1,'Visible','on','Enable','off');
        set(handles.gShow1,'Enable','off');
        set(handles.gT1,'String',['n=',num2str(i),',','z=',num2str(handles.z(n,i)),'(L_D)']);
    end
    
end

% --------------------------------------------------------------------
function gL_SFC_Callback(hObject, eventdata, handles)
% Enables visualisation of Frequency Chirp to be shown as you move through the frames 
% of the signal or spectrum. 
if handles.Launch_Signal_num==0,
    errordlg('Launch Data Unavailable!','Error Dialog Box','modal');
else
    handles.show_side_by_side(1,1) = 1;
    guidata(hObject,handles);
end

% --------------------------------------------------------------------
function gFC_SAL_Callback(hObject, eventdata, handles)
% Sets the axis limits for the chirp plot
prompt{1} = 'Min';
prompt{2} = 'Max';
prompt{3} = 'Time Window';
default_ans = {num2str(handles.FC_SAL(1,1)),num2str(handles.FC_SAL(1,2)),num2str(handles.FC_SAL(1,3))};
title = 'Set YLim for Chirp Plot';
answer = inputdlg(prompt,title,1,default_ans);
if ~isempty(answer),
    handles.FC_SAL(1,1) = str2num(answer{1});
    guidata(hObject,handles);
    handles.FC_SAL(1,2) = str2num(answer{2});
    guidata(hObject,handles);
    handles.FC_SAL(1,3) = str2num(answer{3});
    guidata(hObject,handles);
end

%---------------------------------------------------------------------
function gTWidth_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function gTW_Display1_Callback(hObject, eventdata, handles)
n = get(handles.gLaunch_List,'Value');
if handles.Launch_Signal_num==0,
    errordlg('Launch Data Unavailable!','Error Dialog Box','modal');
else
    %     axes(handles.Display1);
    %     cla;
    set(handles.gT1,'String','');
    set(handles.gShowframes,'Visible','off','Value',1)
    set(handles.gRefreshDisplay1,'Visible','on','Enable','off');
    set(handles.gShow1,'Enable','off');
    h = plot(handles.z,handles.Launch_Data_Signal_Ppty(1,:,n),'Parent',handles.Display1);
    set(get(handles.Display1,'YLabel'),'String','Temporal Width (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display1,'XLabel'),'String','Distance (L_D)','FontSize',12,'FontName','Courier New','FontWeight','bold')
end


% --------------------------------------------------------------------
function gTW_Display2_Callback(hObject, eventdata, handles)
n = get(handles.gLaunch_List,'Value');
if handles.Launch_Signal_num==0,
    errordlg('Launch Data Unavailable!','Error Dialog Box','modal');
else
    axes(handles.Display2);
    cla;
    set(handles.gT2,'String','')
    set(handles.gShowframe2,'Visible','off','Value',1)
    set(handles.gRefreshDisplay2,'Visible','on','Enable','off');
    set(handles.gShow2,'Enable','off');
    h = plot(handles.z,handles.Launch_Data_Signal_Ppty(1,:,n),'Parent',handles.Display2);
    grid off
    axis on
    set(get(handles.Display2,'YLabel'),'String','Temporal Width (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display2,'XLabel'),'String','Distance (L_D)','FontSize',12,'FontName','Courier New','FontWeight','bold')
end

% --------------------------------------------------------------------
function gSW_Display1_Callback(hObject, eventdata, handles)
n = get(handles.gLaunch_List,'Value');
if handles.Launch_Signal_num==0,
    errordlg('Launch Data Unavailable!','Error Dialog Box','modal');
else
    axes(handles.Display1);
    cla;
    set(handles.gT1,'String','');
    set(handles.gShowframes,'Visible','off','Value',1)
    set(handles.gRefreshDisplay1,'Visible','on','Enable','off');
    set(handles.gShow1,'Enable','off');
    h = plot(handles.z,handles.Launch_Data_Signal_Ppty(2,:,n),'Parent',handles.Display1);
    grid off
    axis on
    set(get(handles.Display1,'YLabel'),'String','Spectral Width (T_0^{-1})','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display1,'XLabel'),'String','Distance (L_D)','FontSize',12,'FontName','Courier New','FontWeight','bold')
end


% --------------------------------------------------------------------
function gSW_Display2_Callback(hObject, eventdata, handles)
n = get(handles.gLaunch_List,'Value');
if handles.Launch_Signal_num==0,
    errordlg('Launch Data Unavailable!','Error Dialog Box','modal');
else
    axes(handles.Display2);
    cla;
    set(handles.gT2,'String','');
    set(handles.gShowframe2,'Visible','off','Value',1)
    set(handles.gRefreshDisplay2,'Visible','on','Enable','off');
    set(handles.gShow2,'Enable','off');
    h = plot(handles.z,handles.Launch_Data_Signal_Ppty(2,:,n),'Parent',handles.Display2);
    grid off
    axis on
    set(get(handles.Display2,'YLabel'),'String','Spectral Width (T_0^{-1})','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display2,'XLabel'),'String','Distance (L_D)','FontSize',12,'FontName','Courier New','FontWeight','bold')
end


% --------------------------------------------------------------------
function gM_PSpect_Callback(hObject, eventdata, handles)
% hObject    handle to gM_PSpect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function gM_PS_Display1_Callback(hObject, eventdata, handles)
n = get(handles.gLaunch_List,'Value');
if handles.Launch_Signal_num==0,
    errordlg('Launch Data Unavailable!','Error Dialog Box','modal');
else
    m = sum(handles.Media_Ppty(:,2,n));
    h = plot(fftshift(handles.Frequency),abs(fftshift(handles.Launch_Data_Spectrum(1,:,n))).^2,'Parent',handles.Display1);
    grid off
    axis on
    set(handles.Display1,'XLim',[-handles.Para_Mov(2,2)/2 handles.Para_Mov(2,2)/2],'YLim',[0 handles.Para_Mov(2,3)])
    set(get(handles.Display1,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display1,'XLabel'),'String','Frequency (T_0^{-1})','FontSize',12,'FontName','Courier New','FontWeight','bold')
    M(1)=getframe;
    set(h,'EraseMode','xor')
    for i=1:(m-1),
        set(h,'XData',fftshift(handles.Frequency),'YData',abs(fftshift(handles.Launch_Data_Spectrum(i+1,:,n))).^2);
        grid off
        axis on
        set(handles.Display1,'XLim',[-handles.Para_Mov(2,2)/2 handles.Para_Mov(2,2)/2],'YLim',[0 handles.Para_Mov(2,3)])
        M(i+1)=getframe;
    end
end

% --------------------------------------------------------------------
function gM_PS_Display2_Callback(hObject, eventdata, handles)
n = get(handles.gLaunch_List,'Value');
if handles.Launch_Signal_num==0,
    errordlg('Launch Data Unavailable!','Error Dialog Box','modal');
else
    m = sum(handles.Media_Ppty(:,2,n));
    h = plot(fftshift(handles.Frequency),abs(fftshift(handles.Launch_Data_Spectrum(1,:,n))).^2,'Parent',handles.Display2);
    grid off
    axis on
    set(handles.Display2,'XLim',[-handles.Para_Mov(2,2)/2 handles.Para_Mov(2,2)/2],'YLim',[0 handles.Para_Mov(2,3)])
    set(get(handles.Display2,'YLabel'),'String','Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
    set(get(handles.Display2,'XLabel'),'String','Frequency (T_0^{-1})','FontSize',12,'FontName','Courier New','FontWeight','bold')
    M(1)=getframe;
    set(h,'EraseMode','xor')
    for i=1:(m-1),
        set(h,'XData',fftshift(handles.Frequency),'YData',abs(fftshift(handles.Launch_Data_Spectrum(i+1,:,n))).^2);
        grid off
        axis on
        set(handles.Display2,'XLim',[-handles.Para_Mov(2,2)/2 handles.Para_Mov(2,2)/2],'YLim',[0 handles.Para_Mov(2,3)])
        M(i+1)=getframe;
    end
end


% --------------------------------------------------------------------
function gSnap_Signal_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function gSnap_Spectrum_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function gSnap_Spectrum_Display1_Callback(hObject, eventdata, handles)
if handles.Launch_Signal_num==0,
    errordlg('Launch Data Unavailable!','Error Dialog Box','modal');
else
    handles.Play_Index_Display1 = 2;
    guidata(hObject,handles);
    set(handles.gShowframes,'Max',handles.Step_N,'Visible','on','Value',1)
    set(handles.gRefreshDisplay1,'Visible','off')
    set(handles.gShow1,'Enable','on')
end

% --------------------------------------------------------------------
function gSnap_Spectrum_Display2_Callback(hObject, eventdata, handles)
if handles.Launch_Signal_num==0,
    errordlg('Launch Data Unavailable!','Error Dialog Box','modal');
else
    handles.Play_Index_Display2 = 2;
    guidata(hObject,handles);
    set(handles.gShowframe2,'Max',handles.Step_N,'Visible','on','Value',1)
    set(handles.gRefreshDisplay2,'Visible','off')
    set(handles.gShow2,'Enable','on')
end


% --------------------------------------------------------------------
function gExtract_Sig_Callback(hObject, eventdata, handles)
n = get(handles.gLaunch_List,'Value');
prompt{1} = 'The Frame No.';
default_ans = {'1'};
title = 'Parameters For Signal Display';
answer = inputdlg(prompt,title,1,default_ans);

if ~isempty(answer),
    frame_no = str2num(answer{1});
    Tmp_Signal = handles.Launch_Data_Signal(frame_no,:,n);
    handles.Signal_num = handles.Signal_num + 1;
    guidata(hObject,handles);
    handles.Signal=[handles.Signal; Tmp_Signal]; 
    guidata(hObject,handles);
    handles.Frequency_Chirp = [handles.Frequency_Chirp;[0,diff(unwrap(handles.Launch_Data_Signal_chirp(frame_no,:,n)))./diff(handles.Time)]];
    guidata(hObject,handles);
    tmpFFT=fft(Tmp_Signal);
    handles.Signal_Spectrum = [handles.Signal_Spectrum;tmpFFT];
    guidata(hObject,handles);
    handles.Loaded_Signal_Ppty = [handles.Loaded_Signal_Ppty;[sqrt(var(handles.Time,abs(Tmp_Signal).^2)),sqrt(var(handles.Frequency,abs(tmpFFT).^2))]];
    guidata(hObject,handles);
    handles.Loaded_Signal_List = [handles.Loaded_Signal_List; ['S',num2str(handles.Signal_num)]];
    guidata(hObject,handles);
    handles.Empty=[handles.Empty;['         ']];
    guidata(hObject,handles);
    tmpStr=cat(2,handles.Loaded_Signal_List,handles.Empty,num2str(handles.Loaded_Signal_Ppty(:,1)),handles.Empty,num2str(handles.Loaded_Signal_Ppty(:,2)));
    set(handles.Loaded_Signals,'String',tmpStr,'Value',handles.Signal_num);
    set(handles.gRemove_IS,'Enable','on');
    set(handles.gIS_Edit,'Enable','on');
    handles.Signal_Spec = [handles.Signal_Spec;[0 0 0 0 0]];
    guidata(hObject,handles); 
end


% --------------------------------------------------------------------
function gS_Medium_Callback(hObject, eventdata, handles)
% hObject    handle to gS_Medium (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function gSM_Select_Medium_Callback(hObject, eventdata, handles)

if get(handles.Loaded_Signals,'Value')==0,
    errordlg('No Signal selected!','Error Dialog Box','modal');
else
    prompt{1} = 'Number of Media';
    default_ans = {'1'};
    title = 'Selecting Media';
    answer = inputdlg(prompt,title,1,default_ans);
    if ~isempty(answer),
        tmp = str2num(answer{1});
        handles.Launch_Signal_num = handles.Launch_Signal_num+1;
        guidata(hObject,handles);
        handles.Input_Signal_Index  = [handles.Input_Signal_Index;get(handles.Loaded_Signals,'Value')];
        guidata(hObject,handles);
        tmp_Media_Ppty = zeros(4,8);
        for j=1:tmp,
            tmp_Media_Ppty(j,:) = [1,100,1,0,1,0,0,0];
            prompt{1} = 'Length';
            prompt{2} = 'Number of Points Along the Length';
            prompt{3} = 'Second order GVD';
            prompt{4} = 'Third order GVD';
            prompt{5} = 'Nonlinear Coefficient';
            prompt{6} = 'Absorption Coefficient';
            prompt{7} = 'Self-steepening Parameter';
            prompt{8} = 'Raman Scattering Parameter';
            default_ans ={num2str(tmp_Media_Ppty(j,1)),num2str(tmp_Media_Ppty(j,2)),'-.5*z+1',num2str(tmp_Media_Ppty(j,4)),num2str(tmp_Media_Ppty(j,5)),num2str(tmp_Media_Ppty(j,6)),num2str(tmp_Media_Ppty(j,7)),num2str(tmp_Media_Ppty(j,8))}; 
            title = ['Medium Parameters For Medium ',num2str(j)];
            answer = inputdlg(prompt,title,1,default_ans);
            if ~isempty(answer),
                tmp_Media_Ppty(j,1) = str2num(answer{1});
                tmp_Media_Ppty(j,2) = str2num(answer{2});
                handles.fun_Second_order_GVD{handles.Launch_Signal_num,j} = answer{3};
                guidata(hObject,handles);
                tmp_Media_Ppty(j,4) = str2num(answer{4});
                tmp_Media_Ppty(j,5) = str2num(answer{5});
                tmp_Media_Ppty(j,6) = str2num(answer{6});
                tmp_Media_Ppty(j,7) = str2num(answer{7});
                tmp_Media_Ppty(j,8) = str2num(answer{8});
            end
        end
        
        handles.Para_3D(handles.Launch_Signal_num,1) = 10;
        guidata(hObject,handles);
        handles.Media_Ppty(:,:,handles.Launch_Signal_num) = tmp_Media_Ppty;
        guidata(hObject,handles);
        handles.Special_Medium_Index =[handles.Special_Medium_Index,1];
        guidata(hObject,handles);
        handles.Launch_Signal_List=[handles.Launch_Signal_List; ['L',num2str(handles.Launch_Signal_num)]];
        guidata(hObject,handles);
        handles.L_Empty = [handles.L_Empty;'          '];
        guidata(hObject,handles);
        handles.Launch_Status = [handles.Launch_Status ; 'waiting.......'];
        guidata(hObject,handles);
        tmpStr=cat(2,handles.Launch_Signal_List,handles.L_Empty,handles.Loaded_Signal_List(handles.Input_Signal_Index,:),handles.L_Empty,handles.Launch_Status);
        set(handles.gLaunch_List,'String',tmpStr,'Value',handles.Launch_Signal_num);
        set(handles.gL_Remove,'Enable','on');
        set(handles.gL_Edit,'Enable','on');
        set(handles.gLaunch_Signal,'Enable','on');
    end
end    


% --------------------------------------------------------------------
function gShow_Dispersion_Profile_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function gSM_SDP_D1_Callback(hObject, eventdata, handles)
n = get(handles.gLaunch_List,'Value');
z=[];
f=[];
for j=1:4,
    if handles.Media_Ppty(j,1,n)~=0,
        
        if  handles.Special_Medium_Index(1,n)~=0,
            fun = inline(handles.fun_Second_order_GVD{n,j},'z');
        else
            fun=inline(num2str(handles.Media_Ppty(j,3,n)),'z');
        end
        h = handles.Media_Ppty(j,1,n)/handles.Media_Ppty(j,2,n);
        z=[z,j-1+[0:h:1]];
        f=[f,fun([0:h:1])];
        
    end
end
h = plot(z,f,'Parent',handles.Display1);
set(get(handles.Display1,'YLabel'),'String','\beta(z)_0^{(2)}','FontSize',12,'FontName','Courier New','FontWeight','bold')
set(get(handles.Display1,'XLabel'),'String','Distance (L_D)','FontSize',12,'FontName','Courier New','FontWeight','bold')


% --------------------------------------------------------------------
function gSM_SDP_D2_Callback(hObject, eventdata, handles)
n = get(handles.gLaunch_List,'Value');
z=[];
f=[];
for j=1:4,
    if handles.Media_Ppty(j,1,n)~=0,
        
        if  handles.Special_Medium_Index(1,n)~=0,
            fun = inline(handles.fun_Second_order_GVD{n,j},'z');
        else
            fun=inline(num2str(handles.Media_Ppty(j,3,n)),'z');
        end
        h = handles.Media_Ppty(j,1,n)/handles.Media_Ppty(j,2,n);
        z=[z,j-1+[0:h:1]];
        f=[f,fun([0:h:1])];
        
    end
end
h = plot(z,f,'Parent',handles.Display2);
set(get(handles.Display2,'YLabel'),'String','\beta(z)_0^{(2)}','FontSize',12,'FontName','Courier New','FontWeight','bold')
set(get(handles.Display2,'XLabel'),'String','Distance (L_D)','FontSize',12,'FontName','Courier New','FontWeight','bold')




% --------------------------------------------------------------------
function gL_GF_Callback(hObject, eventdata, handles)
if handles.Play_Index_Display1==1;
    n = get(handles.gLaunch_List,'Value');
    i = floor(get(handles.gShowframes,'Value'));
    if ~isempty(handles.Snapshot_Compare_Index),
        button = questdlg('Do you want to Erase the existing plot?','','Yes','No','Yes');
        if strcmp(button,'Yes'),
            handles.Snapshot_Compare_Index = [i];
            guidata(hObject,handles);
            figure(2)
            hold on
            subplot(2,1,2);plot(handles.Time(1,1:handles.Samples_Num-1),diff(unwrap(handles.Launch_Data_Signal_chirp(i,:,n)))./diff(handles.Time),'LineWidth',1);
            grid off
            axis on
            axis([-handles.FC_SAL(1,3)/2 handles.FC_SAL(1,3)/2 handles.FC_SAL(1,1) handles.FC_SAL(1,2)])
            ylabel('Frequency Chirp','FontSize',12,'FontName','Courier New','FontWeight','bold')
            xlabel('Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
            subplot(2,1,1);plot(handles.Time,abs(handles.Launch_Data_Signal(i,:,n)).^2,'LineWidth',1);
            grid off
            axis on
            axis([-handles.Para_Mov(1,2)/2 handles.Para_Mov(1,2)/2 0 handles.Para_Mov(1,3)])
            ylabel('Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
            xlabel('Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
            %             title(['z=',num2str(handles.z(n,i)),'(L_D)']);
            hold off
        else
            s=1;found=0;
            [tmp_m,tmp_n]=size(handles.Snapshot_Compare_Index);
            while ~found && s<=tmp_n,
                if i==handles.Snapshot_Compare_Index(1,s),
                    found=1;
                end
                s=s+1;
            end
            if found==0,
                handles.Snapshot_Compare_Index = [handles.Snapshot_Compare_Index,i]
                guidata(hObject,handles);
            end
            [tmp_m,tmp_n]=size(handles.Snapshot_Compare_Index);
            figure(2)
            hold on
            subplot(2,1,2);
            hold on
            for k=1:tmp_n,
                plot(handles.Time(1,1:handles.Samples_Num-1),diff(unwrap(handles.Launch_Data_Signal_chirp(handles.Snapshot_Compare_Index(k),:,n)))./diff(handles.Time),'Color',[0 0 k/tmp_n],'LineWidth',1);
            end
            hold off
            grid off
            axis on
            axis([-handles.FC_SAL(1,3)/2 handles.FC_SAL(1,3)/2 handles.FC_SAL(1,1) handles.FC_SAL(1,2)])
            ylabel('Frequency Chirp','FontSize',12,'FontName','Courier New','FontWeight','bold')
            xlabel('Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
            subplot(2,1,1);
            hold on
            for k=1:tmp_n,
                plot(handles.Time,abs(handles.Launch_Data_Signal(handles.Snapshot_Compare_Index(k),:,n)).^2,'Color',[0 0 k/tmp_n],'LineWidth',1);
            end
            hold off
            grid off
            axis on
            axis([-handles.Para_Mov(1,2)/2 handles.Para_Mov(1,2)/2 0 handles.Para_Mov(1,3)])
            ylabel('Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
            xlabel('Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
            %             title(['z=',num2str(handles.z(n,i)),'(L_D)']);
            hold off
        end
    else
        handles.Snapshot_Compare_Index = [i];
        guidata(hObject,handles);
        
        figure(2)
        hold on
        subplot(2,1,2);plot(handles.Time(1,1:handles.Samples_Num-1),diff(unwrap(handles.Launch_Data_Signal_chirp(i,:,n)))./diff(handles.Time),'LineWidth',1);
        grid off
        axis on
        axis([-handles.FC_SAL(1,3)/2 handles.FC_SAL(1,3)/2 handles.FC_SAL(1,1) handles.FC_SAL(1,2)])
        ylabel('Frequency Chirp','FontSize',12,'FontName','Courier New','FontWeight','bold')
        xlabel('Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        subplot(2,1,1);plot(handles.Time,abs(handles.Launch_Data_Signal(i,:,n)).^2,'LineWidth',1);
        grid off
        axis on
        axis([-handles.Para_Mov(1,2)/2 handles.Para_Mov(1,2)/2 0 handles.Para_Mov(1,3)])
        ylabel('Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
        xlabel('Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        %         title(['z=',num2str(handles.z(n,i)),'(L_D)']);
        hold off
    end
else
    n = get(handles.gLaunch_List,'Value');
    i = floor(get(handles.gShowframes,'Value'));
    if ~isempty(handles.Snapshot_Compare_Index),
        button = questdlg('Do you want to Erase the existing plot?','','Yes','No','Yes');
        if strcmp(button,'Yes'),
            handles.Snapshot_Compare_Index = [i];
            guidata(hObject,handles);
            figure(2)
            hold on
            subplot(2,1,2);plot(handles.Time(1,1:handles.Samples_Num-1),diff(unwrap(handles.Launch_Data_Signal_chirp(i,:,n)))./diff(handles.Time),'LineWidth',1);
            grid off
            axis on
            axis([-handles.FC_SAL(1,3)/2 handles.FC_SAL(1,3)/2 handles.FC_SAL(1,1) handles.FC_SAL(1,2)])
            ylabel('Frequency Chirp','FontSize',12,'FontName','Courier New','FontWeight','bold')
            xlabel('Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
            subplot(2,1,1);plot(fftshift(handles.Frequency),abs(fftshift(handles.Launch_Data_Spectrum(i,:,n))).^2,'LineWidth',1)
            grid off
            axis on
            axis([-handles.Para_Mov(2,2)/2 handles.Para_Mov(2,2)/2 0 handles.Para_Mov(2,3)])
            ylabel('Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
            xlabel('Frequency (T_0^{-1})','FontSize',12,'FontName','Courier New','FontWeight','bold')
            %             title(['z=',num2str(handles.z(n,i)),'(L_D)']);
            hold off
        else
            s=1;found=0;
            [tmp_m,tmp_n]=size(handles.Snapshot_Compare_Index);
            while ~found && s<=tmp_n,
                if i==handles.Snapshot_Compare_Index(1,s),
                    found=1;
                end
                s=s+1;
            end
            if found==0,
                handles.Snapshot_Compare_Index = [handles.Snapshot_Compare_Index,i]
                guidata(hObject,handles);
            end
            [tmp_m,tmp_n]=size(handles.Snapshot_Compare_Index);
            figure(2)
            hold on
            subplot(2,1,2);
            hold on
            for k=1:tmp_n,
                plot(handles.Time(1,1:handles.Samples_Num-1),diff(unwrap(handles.Launch_Data_Signal_chirp(handles.Snapshot_Compare_Index(k),:,n)))./diff(handles.Time),'Color',[0 0 k/tmp_n],'LineWidth',1);
            end
            hold off
            grid off
            axis on
            axis([-handles.FC_SAL(1,3)/2 handles.FC_SAL(1,3)/2 handles.FC_SAL(1,1) handles.FC_SAL(1,2)])
            ylabel('Frequency Chirp','FontSize',12,'FontName','Courier New','FontWeight','bold')
            xlabel('Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
            subplot(2,1,1);
            hold on
            for k=1:tmp_n,
                plot(fftshift(handles.Frequency),abs(fftshift(handles.Launch_Data_Spectrum(handles.Snapshot_Compare_Index(k),:,n))).^2,'Color',[0 0 k/tmp_n],'LineWidth',1);
            end
            hold off
            grid off
            axis on
            axis([-handles.Para_Mov(2,2)/2 handles.Para_Mov(2,2)/2 0 handles.Para_Mov(2,3)])
            ylabel('Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
            xlabel('Frequency (T_0^{-1})','FontSize',12,'FontName','Courier New','FontWeight','bold')
            %             title(['z=',num2str(handles.z(n,i)),'(L_D)']);
            hold off
        end
    else
        handles.Snapshot_Compare_Index = [i];
        guidata(hObject,handles);
        
        figure(2)
        hold on
        subplot(2,1,2);plot(handles.Time(1,1:handles.Samples_Num-1),diff(unwrap(handles.Launch_Data_Signal_chirp(i,:,n)))./diff(handles.Time));
        grid off
        axis on
        axis([-handles.FC_SAL(1,3)/2 handles.FC_SAL(1,3)/2 handles.FC_SAL(1,1) handles.FC_SAL(1,2)])
        ylabel('Frequency Chirp','FontSize',12,'FontName','Courier New','FontWeight','bold')
        xlabel('Time (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        subplot(2,1,1);plot(fftshift(handles.Frequency),abs(fftshift(handles.Launch_Data_Spectrum(i,:,n))).^2,'LineWidth',1);
        grid off
        axis on
        axis([-handles.Para_Mov(2,2)/2 handles.Para_Mov(2,2)/2 0 handles.Para_Mov(2,3)])
        ylabel('Intensity','FontSize',12,'FontName','Courier New','FontWeight','bold')
        xlabel('Frequency (T_0^{-1})','FontSize',12,'FontName','Courier New','FontWeight','bold')
        %         title(['z=',num2str(handles.z(n,i)),'(L_D)']);
        hold off
    end
    
end


% --------------------------------------------------------------------
function gLTW_Compare_Callback(hObject, eventdata, handles)

n = get(handles.gLaunch_List,'Value')
handles.TW_Compare_Index
if handles.Launch_Signal_num==0,
    errordlg('Launch Data Unavailable!','Error Dialog Box','modal');
elseif ~isempty(handles.TW_Compare_Index),
    button = questdlg('Do you want to Erase the existing plot?','','Yes','No','Yes');
    if strcmp(button,'Yes'),
        handles.TW_Compare_Index = [n];
        guidata(hObject,handles);
        figure(21)
        plot(handles.z,handles.Launch_Data_Signal_Ppty(1,:,n));
        ylabel('Temporal Width (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        xlabel('Distance (L_D)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        
    else
        s=1;found=0;
        [tmp_m,tmp_n]=size(handles.TW_Compare_Index);
        while ~found && s<=tmp_n,
            if n==handles.TW_Compare_Index(1,s),
                found=1;
            end
            s=s+1;
        end
        if found==0,
            handles.TW_Compare_Index = [handles.TW_Compare_Index,n];
            guidata(hObject,handles);
        end
         figure(21)
         hold on
        [tmp_m,tmp_n]=size(handles.TW_Compare_Index);
        for k=1:tmp_n,
            plot(handles.z,handles.Launch_Data_Signal_Ppty(1,:,handles.TW_Compare_Index(1,k)),'Color',[0 0 k/tmp_n],'LineWidth',1);
        end
        ylabel('Temporal Width (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        xlabel('Distance (L_D)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        hold off
    end
else
        handles.TW_Compare_Index = [n];
        guidata(hObject,handles);    
        figure(21)
        plot(handles.z,handles.Launch_Data_Signal_Ppty(1,:,n));
        ylabel('Temporal Width (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        xlabel('Distance (L_D)','FontSize',12,'FontName','Courier New','FontWeight','bold')
end

% --------------------------------------------------------------------
function gLSW_Compare_Callback(hObject, eventdata, handles)

n = get(handles.gLaunch_List,'Value');
if handles.Launch_Signal_num==0,
    errordlg('Launch Data Unavailable!','Error Dialog Box','modal');
elseif ~isempty(handles.SW_Compare_Index),
    button = questdlg('Do you want to Erase the existing plot?','','Yes','No','Yes');
    if strcmp(button,'Yes'),
        handles.SW_Compare_Index = [n]
        guidata(hObject,handles);
        figure(35)
        plot(handles.z,handles.Launch_Data_Signal_Ppty(2,:,n));
        ylabel('Spectral Width (T_0{-1})','FontSize',12,'FontName','Courier New','FontWeight','bold')
        xlabel('Distance (L_D)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        
    else
        s=1;found=0;
        [tmp_m,tmp_n]=size(handles.SW_Compare_Index);
        while ~found && s<=tmp_n,
            if n==handles.SW_Compare_Index(1,s),
                found=1;
            end
            s=s+1;
        end
        if found==0,
            handles.SW_Compare_Index = [handles.SW_Compare_Index,n];
            guidata(hObject,handles);
        end
        figure(21)
         hold on
        [tmp_m,tmp_n]=size(handles.SW_Compare_Index);
        for k=1:tmp_n,
            plot(handles.z,handles.Launch_Data_Signal_Ppty(2,:,handles.SW_Compare_Index(1,k)),'Color',[0 0 k/tmp_n],'LineWidth',1);
        end
        ylabel('Spectral Width (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        xlabel('Distance (L_D)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        hold off
    end
else
        handles.SW_Compare_Index = [n]
        guidata(hObject,handles);
        figure(35)
        plot(handles.z,handles.Launch_Data_Signal_Ppty(2,:,n));
        ylabel('Spectral Width (T_0)','FontSize',12,'FontName','Courier New','FontWeight','bold')
        xlabel('Distance (L_D)','FontSize',12,'FontName','Courier New','FontWeight','bold')
end

