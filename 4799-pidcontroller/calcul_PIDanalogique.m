function varargout = calcul_PIDanalogique(varargin)

% CALCUL_PIDANALOGIQUE M-file for calcul_PIDanalogique.fig
%      CALCUL_PIDANALOGIQUE, by itself, creates a new CALCUL_PIDANALOGIQUE or raises the existing
%      singleton*.
%
%      H = CALCUL_PIDANALOGIQUE returns the handle to a new CALCUL_PIDANALOGIQUE or the handle to
%      the existing singleton*.
%
%      CALCUL_PIDANALOGIQUE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALCUL_PIDANALOGIQUE.M with the given input arguments.
%
%      CALCUL_PIDANALOGIQUE('Property','Value',...) creates a new CALCUL_PIDANALOGIQUE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before calcul_PIDanalogique_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to calcul_PIDanalogique_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help calcul_PIDanalogique

% Last Modified by GUIDE v2.5 18-Apr-2004 15:37:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @calcul_PIDanalogique_OpeningFcn, ...
                   'gui_OutputFcn',  @calcul_PIDanalogique_OutputFcn, ...
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


% --- Executes just before calcul_PIDanalogique is made visible.
function calcul_PIDanalogique_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to calcul_PIDanalogique (see VARARGIN)

% Choose default command line output for calcul_PIDanalogique
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes calcul_PIDanalogique wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = calcul_PIDanalogique_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function t_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function t_Callback(hObject, eventdata, handles)
% hObject    handle to t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of t as text
%        str2double(get(hObject,'String')) returns contents of t as a double
t = str2double(get(hObject, 'String'));
if isnan(t)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

data = getappdata(gcbf, 'metricdata');
data.t = t;
setappdata(gcbf, 'metricdata', data);


% --- Executes during object creation, after setting all properties.
function k_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function k_Callback(hObject, eventdata, handles)
% hObject    handle to k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
k = str2double(get(hObject, 'String'));

% Hints: get(hObject,'String') returns contents of k as text
%        str2double(get(hObject,'String')) returns contents of k as a double
if isnan(k)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

data = getappdata(gcbf, 'metricdata');
data.k = k;
setappdata(gcbf, 'metricdata', data);


% --- Executes during object creation, after setting all properties.
function theta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function theta_Callback(hObject, eventdata, handles)
% hObject    handle to theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
theta = str2double(get(hObject, 'String'));
% Hints: get(hObject,'String') returns contents of theta as text
%        str2double(get(hObject,'String')) returns contents of theta as a double
if isnan(theta)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

data = getappdata(gcbf, 'metricdata');
data.theta = theta;
setappdata(gcbf, 'metricdata', data);


% --- Executes on button press in calcul.
function calcul_Callback(hObject, eventdata, handles)
% hObject    handle to calcul (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc

% clear all
% close all

data = getappdata(gcbf, 'metricdata');
%*****************%
%*Ziegler Nichols*%
%*****************%

 
if get(handles.ziegler, 'Value')
    kc_zigler =1.2*data.t/(data.theta*data.k);
    Ti_zigler = 2*data.theta;
    Td_zigler = 0.5*data.theta;
    set(handles.kc, 'String', kc_zigler);
     set(handles.ti, 'String', Ti_zigler); 
     set(handles.td, 'String', Td_zigler);
end
%******************%
%****Cohen Coon****%
%******************%
if get(handles.cohen, 'Value')
    kc_cohen = (16*data.t+3*data.theta)/(12*data.k*data.theta);
    Ti_cohen = data.theta*(32+6*data.theta/data.t)/(13+8*data.theta/data.t);
    Td_cohen = 4*data.theta/(11+20*data.theta/data.t);
    set(handles.kc, 'String', kc_cohen);
     set(handles.ti, 'String', Ti_cohen); 
     set(handles.td, 'String', Td_cohen);
end
%****************%
%**REGLABILITEE**%
%****************%
if get(handles.reglab, 'Value')
    rc = data.theta/data.t;
    if  ((rc >= 0) & (rc < 0.1))
        kp_regla = 5/data.k ;   
        Ti_regla = data.t;
        Td_regla = 0;
        set(handles.kc, 'String', kp_regla);
        set(handles.ti, 'String', Ti_regla); 
        set(handles.td, 'String', Td_regla);
    elseif ((rc >= 0.1) & (rc < 0.2))
        kp_regla = 0.5/(data.k*rc);
        Ti_regla = data.t;
        Td_regla = 0;
        set(handles.kc, 'String', kp_regla);
        set(handles.ti, 'String', Ti_regla); 
        set(handles.td, 'String', Td_regla);
    elseif ((rc >= 0.2) & (rc < 0.5))
        kp_regla = 0.5*(1+0.5*rc)/(data.k*rc)
        Ti_regla = data.t*(1+0.5*rc)
        Td_regla = data.t*0.5*rc/(0.5*rc+1)
        set(handles.kc, 'String', kp_regla);
        set(handles.ti, 'String', Ti_regla); 
        set(handles.td, 'String', Td_regla);
    else
        disp(                   '****************************************************')
        disp(                   '*************** IL FAUT QUE: ***********************')
        disp(                   '*                  theta                           *')
        disp(                   '***    0 <= ---------------------------- <= 0.5  ***')
        disp(                   '*                    T                             *')
        disp(                   '****************************************************')
        disp(                   '****************************************************')
        set(handles.kc, 'String', 0);
        set(handles.ti, 'String', 0); 
        set(handles.td, 'String', 0);
    end
end
%***************************%
%**OPTIMISATION DE CRITERE**%
%***************************%
if get(handles.optim, 'Value')
   

    
    %regulateur
    %**********************
    %asservissement
    %**********************
    if get(handles.ass, 'Value')
            %a
            Asservissement(1).ise  = 1.26239;
            Asservissement(1).iae  = 1.13031;
            Asservissement(1).itae = 0.98384;
            %b
            Asservissement(2).ise  = -0.83880;
            Asservissement(2).iae  = -0.81314;
            Asservissement(2).itae = -0.49851;
            %c
            Asservissement(3).ise  = 6.03560;
            Asservissement(3).iae  = 7.7527;
            Asservissement(3).itae = 2.71348;
            %d
            Asservissement(4).ise  = -6.0191;
            Asservissement(4).iae  = -5.7241;
            Asservissement(4).itae = -2.29778;
            %e
            Asservissement(5).ise  = 0.47617;
            Asservissement(5).iae  = 0.32175;
            Asservissement(5).itae = 0.21433;
            %f
            Asservissement(6).ise  = 0.24572;
            Asservissement(6).iae  = 0.17707;
            Asservissement(6).itae = 0.16768;
        if get(handles.ise, 'Value')
            %ISE
            kp_ass = Asservissement(1).ise*((data.theta/data.t)^Asservissement(2).ise)/data.k;
            Ti_ass = kp_ass*data.t/(Asservissement(3).ise+(data.theta/data.t)*Asservissement(4).ise);
            Td_ass = (data.t/kp_ass)*Asservissement(5).ise*(data.theta/data.t)^Asservissement(6).ise;
            set(handles.kc, 'String', kp_ass);
            set(handles.ti, 'String', Ti_ass); 
            set(handles.td, 'String', Td_ass);
        elseif get(handles.iae, 'Value')
            %IAE    
            kp_ass = Asservissement(1).iae*((data.theta/data.t)^Asservissement(2).iae)/data.k;
            Ti_ass = kp_ass*data.t/(Asservissement(3).iae+(data.theta/data.t)*Asservissement(4).iae);
            Td_ass = (data.t/kp_ass)*Asservissement(5).iae*(data.theta/data.t)^Asservissement(6).iae;
            set(handles.kc, 'String', kp_ass);
            set(handles.ti, 'String', Ti_ass); 
            set(handles.td, 'String', Td_ass);
        elseif get(handles.itae, 'Value')
            %ITAE
            kp_ass = Asservissement(1).itae*((data.theta/data.t)^Asservissement(2).itae)/data.k;
            Ti_ass = kp_ass*data.t/(Asservissement(3).itae+(data.theta/data.t)*Asservissement(4).itae);
            Td_ass = (data.t/kp_ass)*Asservissement(5).itae*(data.theta/data.t)^Asservissement(6).itae;
            set(handles.kc, 'String', kp_ass);
            set(handles.ti, 'String', Ti_ass); 
            set(handles.td, 'String', Td_ass);
        end
    end
    %**********************
    %Regulation
    %**********************
     if get(handles.regu, 'Value')
         %REGULATION
         %a
         Regulation(1).ise  = 1.3466;
         Regulation(1).iae  = 1.31509;
         Regulation(1).itae = 1.3176;
         %b
         Regulation(2).ise  = -0.9308;
         Regulation(2).iae  = -0.8826;
         Regulation(2).itae = -0.7937;
         %c
         Regulation(3).ise  = 1.6585;
         Regulation(3).iae  = 1.2587;
         Regulation(3).itae = 1.12499;
         %d
         Regulation(4).ise  = -1.25738;
         Regulation(4).iae  = -1.3756;
         Regulation(4).itae = -1.42609;
         %e
         Regulation(5).ise  = 0.79715;
         Regulation(5).iae  = 0.5655;
         Regulation(5).itae = 0.49547;
         %f
         Regulation(6).ise  = 0.41941;
         Regulation(6).iae  = 0.476;
         Regulation(6).itae = 0.41932;
         if get(handles.ise, 'Value')
             %ise
             kp_reg = Regulation(1).ise*((data.theta/data.t)^Regulation(2).ise)/data.k;
             Ti_reg = kp_reg*data.t/(Regulation(3).ise*(data.theta/data.t)^Regulation(4).ise);
             Td_reg = (data.t/kp_reg)*Regulation(5).ise*(data.theta/data.t)^Regulation(6).ise;
             set(handles.kc, 'String', kp_reg);
             set(handles.ti, 'String', Ti_reg); 
             set(handles.td, 'String', Td_reg);
         elseif get(handles.iae, 'Value')
             %iae
             kp_reg = Regulation(1).iae*((data.theta/data.t)^Regulation(2).iae)/data.k;
             Ti_reg = kp_reg*data.t/(Regulation(3).iae*(data.theta/data.t)^Regulation(4).iae);
             Td_reg = (data.t/kp_reg)*Regulation(5).iae*(data.theta/data.t)^Regulation(6).iae;
             set(handles.kc, 'String', kp_reg);
             set(handles.ti, 'String', Ti_reg); 
             set(handles.td, 'String', Td_reg);
         elseif get(handles.itae, 'Value')
             %itae
             kp_reg = Regulation(1).itae*((data.theta/data.t)^Regulation(2).itae)/data.k;
             Ti_reg = kp_reg*data.t/(Regulation(3).itae*(data.theta/data.t)^Regulation(4).itae);
             Td_reg = (data.t/kp_reg)*Regulation(5).itae*(data.theta/data.t)^Regulation(6).itae;
             set(handles.kc, 'String', kp_reg);
             set(handles.ti, 'String', Ti_reg); 
             set(handles.td, 'String', Td_reg);
         end
     end
end
%*******************************
%**IMC
%**************
if get(handles.imc, 'Value')
   
    kp_imc = (data.t+data.theta/2)/(data.k*data.tc+data.k*data.theta/2);
    Ti_imc = data.t+data.theta/2;
    Td_imc = data.theta*data.t/(2*data.t+data.theta);
    set(handles.kc, 'String', kp_imc);
    set(handles.ti, 'String', Ti_imc); 
    set(handles.td, 'String', Td_imc);
end
if (get(handles.pid1, 'Value') | get(handles.pid2, 'Value'))
    sys = tf(data.k,[data.t 1]);
    sys.inputd = data.theta;
    sysz = c2d(sys,data.te,'zoh');
    [B,A] = tfdata(sysz,'z^-1');
    H_d = tf(1,[1/data.w0^2 2*data.xi/data.w0^2 1]);
    H_d.inputd = data.theta;;% 2 sec input delay
    H_dz = c2d(H_d,data.te,'zoh');
    set(H_dz,'variable','z^-1');
    [N,P] = tfdata(H_dz,'z^-1');
    D = (A(2)-1)*B(2)*B(3)^2-B(3)^3-(A(3)-A(2))*B(2)^2*B(3)-A(3)*B(2)^3;
    r0 = ((P(2)*(A(2)-1)-P(3)+A(2)-1-A(2)^2+A(3))*B(3)^2+A(3)*(A(2)-1-P(2))*B(2)^2+(P(2)*(A(2)-A(3))+A(2)-A(2)^2+A(2)*A(3))*B(2)*B(3))/D;
    r1 = (P(3)*(A(2)-A(3))+P(2)*A(3)+(A(2)-A(3))^2)*B(2)*B(3)/D;
    r2 = (B(2)*B(3)*A(3)*(A(2)+P(3)-A(2))+A(3)*B(2)^2*(A(2)-P(2)-1)-(A(3)*B(1))^2)/D;
    s1 = ((P(3)+A(2)-A(3))*B(1)*B(2)^2-(1+P(2)-A(2))*B(2)^3+A(3)*B(1)*B(2))/D;
    if get(handles.pid1, 'Value')
        k_pid = (r0*s1-r1-(2+s1)*r2)/(1+s1)^2;
        Ti_pid = data.te*data.k*(1+s1)/(r0+r1+r2);
        Td_pid = data.te*(s1^2*r0-s1*r1+r2)/(data.k*(1+s1)^3);
        tdn1 = -s1*data.te/(1+s1);
    elseif get(handles.pid2, 'Value')
        k_pid = -(r1+2*r2)/(1+s1);
        Ti_pid = -data.te*(r1+2*r2)/(r1+r0+r2);
        Td_pid= data.te*(s1*r1+(s1-1)*r2)/((r1+2*r2)*(1+s1));
        tdn2 = -s1*data.te/(1+s1);
    end
    set(handles.kc, 'String', k_pid);
    set(handles.ti, 'String', Ti_pid); 
    set(handles.td, 'String', Td_pid);
end
    
% --- Executes on button press in ziegler.
function ziegler_Callback(hObject, eventdata, handles)
% hObject    handle to ziegler (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ziegler

set(handles.ziegler, 'Value', 1);
set(handles.cohen, 'Value', 0);
set(handles.reglab, 'Value', 0);

set(handles.optim, 'Value', 0);
set(handles.imc, 'Value', 0);
set(handles.pid1, 'Value', 0);
 set(handles.pid2, 'Value', 0);
 set(handles.itae, 'visible','off');
 set(handles.iae, 'visible','off');
 set(handles.ise, 'visible','off');
 set(handles.cadreop1, 'visible','off');
 set(handles.cadreop2, 'visible','off');
 set(handles.cadreop3, 'visible','off');
 set(handles.mode, 'visible','off');
 set(handles.critere, 'visible','off');
 set(handles.opt, 'visible','off');
 set(handles.regu, 'visible','off');
 set(handles.ass, 'visible','off');
 set(handles.tc, 'visible','off');
 set(handles.filtre, 'visible','off');
 set(handles.cpd, 'visible','off');
 set(handles.txi, 'visible','off');
 set(handles.tw0, 'visible','off');
 set(handles.xi, 'visible','off');
 set(handles.w0, 'visible','off');
 set(handles.tte, 'visible','off');
 set(handles.te, 'visible','off');
 set(handles.tpd, 'visible','off');

% --- Executes on button press in cohen.
function cohen_Callback(hObject, eventdata, handles)
% hObject    handle to cohen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cohen
set(handles.ziegler, 'Value', 0);
set(handles.cohen, 'Value', 1);
set(handles.reglab, 'Value', 0);

set(handles.optim, 'Value', 0);
set(handles.imc, 'Value', 0);
set(handles.pid1, 'Value', 0);
set(handles.pid2, 'Value', 0);
set(handles.itae, 'visible','off');
 set(handles.iae, 'visible','off');
 set(handles.ise, 'visible','off');
 set(handles.cadreop1, 'visible','off');
 set(handles.cadreop2, 'visible','off');
 set(handles.cadreop3, 'visible','off');
 set(handles.mode, 'visible','off');
 set(handles.critere, 'visible','off');
 set(handles.opt, 'visible','off');
 set(handles.regu, 'visible','off');
 set(handles.ass, 'visible','off');
 set(handles.tc, 'visible','off');
 set(handles.filtre, 'visible','off');
  set(handles.cpd, 'visible','off');
 set(handles.txi, 'visible','off');
 set(handles.tw0, 'visible','off');
 set(handles.xi, 'visible','off');
 set(handles.w0, 'visible','off');
 set(handles.tte, 'visible','off');
 set(handles.te, 'visible','off');
 set(handles.tpd, 'visible','off');



% --- Executes on button press in reglab.
function reglab_Callback(hObject, eventdata, handles)
% hObject    handle to reglab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of reglab
 set(handles.itae, 'visible','off');
 set(handles.iae, 'visible','off');
 set(handles.ise, 'visible','off');
 set(handles.cadreop1, 'visible','off');
 set(handles.cadreop2, 'visible','off');
 set(handles.cadreop3, 'visible','off');
 set(handles.mode, 'visible','off');
 set(handles.critere, 'visible','off');
 set(handles.opt, 'visible','off');
 set(handles.regu, 'visible','off');
 set(handles.ass, 'visible','off');
set(handles.ziegler, 'Value', 0);
set(handles.tc, 'visible','off');
 set(handles.filtre, 'visible','off');

set(handles.cohen, 'Value', 0);
set(handles.reglab, 'Value', 1);

set(handles.optim, 'Value', 0);
set(handles.imc, 'Value', 0);
set(handles.pid1, 'Value', 0);
set(handles.pid2, 'Value', 0);
 set(handles.cpd, 'visible','off');
 set(handles.txi, 'visible','off');
 set(handles.tw0, 'visible','off');
 set(handles.xi, 'visible','off');
 set(handles.w0, 'visible','off');
 set(handles.tte, 'visible','off');
 set(handles.te, 'visible','off');
 set(handles.tpd, 'visible','off');


% --- Executes on button press in optim.
function optim_Callback(hObject, eventdata, handles)
% hObject    handle to optim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of optim
 set(handles.ziegler, 'Value', 0);
 set(handles.cohen, 'Value', 0);
 set(handles.reglab, 'Value', 0);

 set(handles.optim, 'Value', 1);
 set(handles.imc, 'Value', 0);
 set(handles.pid1, 'Value', 0);
set(handles.pid2, 'Value', 0);
 set(handles.itae, 'visible','on');
 set(handles.iae, 'visible','on');
 set(handles.ise, 'visible','on');
 set(handles.cadreop1, 'visible','on');
 set(handles.cadreop2, 'visible','on');
 set(handles.cadreop3, 'visible','on');
 set(handles.mode, 'visible','on');
 set(handles.critere, 'visible','on');
 set(handles.opt, 'visible','on');
 set(handles.regu, 'visible','on');
 set(handles.ass, 'visible','on');
  set(handles.tc, 'visible','off');
 set(handles.filtre, 'visible','off');
  set(handles.cpd, 'visible','off');
 set(handles.txi, 'visible','off');
 set(handles.tw0, 'visible','off');
 set(handles.xi, 'visible','off');
 set(handles.w0, 'visible','off');
 set(handles.tte, 'visible','off');
 set(handles.te, 'visible','off');
 set(handles.tpd, 'visible','off');



% --- Executes on button press in imc.
function imc_Callback(hObject, eventdata, handles)
% hObject    handle to imc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of imc

set(handles.ziegler, 'Value', 0);
set(handles.cohen, 'Value', 0);
set(handles.reglab, 'Value', 0);

set(handles.optim, 'Value', 0);
set(handles.imc, 'Value', 1);
set(handles.pid1, 'Value', 0);
set(handles.pid2, 'Value', 0);
set(handles.itae, 'visible','off');
 set(handles.iae, 'visible','off');
 set(handles.ise, 'visible','off');
 set(handles.cadreop1, 'visible','off');
 set(handles.cadreop2, 'visible','off');
 set(handles.cadreop3, 'visible','off');
 set(handles.mode, 'visible','off');
 set(handles.critere, 'visible','off');
 set(handles.opt, 'visible','off');
 set(handles.regu, 'visible','off');
 set(handles.ass, 'visible','off');
 set(handles.tc, 'visible','on');
 set(handles.filtre, 'visible','on');
  set(handles.cpd, 'visible','off');
 set(handles.txi, 'visible','off');
 set(handles.tw0, 'visible','off');
 set(handles.xi, 'visible','off');
 set(handles.w0, 'visible','off');
 set(handles.tte, 'visible','off');
 set(handles.te, 'visible','off');
 set(handles.tpd, 'visible','off');


% --- Executes on button press in ass.
function ass_Callback(hObject, eventdata, handles)
% hObject    handle to ass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.ass, 'Value', 1);
set(handles.regu, 'Value', 0);
% Hint: get(hObject,'Value') returns toggle state of ass


% --- Executes on button press in regu.
function regu_Callback(hObject, eventdata, handles)
% hObject    handle to regu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.ass, 'Value', 0);
set(handles.regu, 'Value', 1);

% Hint: get(hObject,'Value') returns toggle state of regu


% --- Executes on button press in ise.
function ise_Callback(hObject, eventdata, handles)
% hObject    handle to ise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ise
set(handles.ise, 'Value',1);
set(handles.iae, 'Value', 0);
set(handles.itae, 'Value', 0);

% --- Executes on button press in iae.
function iae_Callback(hObject, eventdata, handles)
% hObject    handle to iae (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of iae
set(handles.ise, 'Value',0);
set(handles.iae, 'Value', 1);
set(handles.itae, 'Value', 0);

% --- Executes on button press in itae.
function itae_Callback(hObject, eventdata, handles)
% hObject    handle to itae (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of itae
set(handles.ise, 'Value',0);
set(handles.iae, 'Value', 0);
set(handles.itae, 'Value', 1);


% --- Executes during object creation, after setting all properties.
function tc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function tc_Callback(hObject, eventdata, handles)
% hObject    handle to tc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tc = str2double(get(hObject, 'String'));
if isnan(tc)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

data = getappdata(gcbf, 'metricdata');
data.tc = tc;
setappdata(gcbf, 'metricdata', data);


% Hints: get(hObject,'String') returns contents of tc as text
%        str2double(get(hObject,'String')) returns contents of tc as a double


% --- Executes during object creation, after setting all properties.
function kc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function kc_Callback(hObject, eventdata, handles)
% hObject    handle to kc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kc as text
%        str2double(get(hObject,'String')) returns contents of kc as a double


% --- Executes during object creation, after setting all properties.
function ti_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ti_Callback(hObject, eventdata, handles)
% hObject    handle to ti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ti as text
%        str2double(get(hObject,'String')) returns contents of ti as a double


% --- Executes during object creation, after setting all properties.
function td_CreateFcn(hObject, eventdata, handles)
% hObject    handle to td (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function td_Callback(hObject, eventdata, handles)
% hObject    handle to td (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of td as text
%        str2double(get(hObject,'String')) returns contents of td as a double


% --- Executes during object creation, after setting all properties.


% --- Executes on button press in pid1.
function pid1_Callback(hObject, eventdata, handles)
% hObject    handle to pid1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pid1
set(handles.ziegler, 'Value', 0);
set(handles.cohen, 'Value', 0);
set(handles.reglab, 'Value', 0);
set(handles.optim, 'Value', 0);
set(handles.imc, 'Value', 0);
set(handles.pid1, 'Value', 1);
set(handles.pid2, 'Value', 0);
set(handles.itae, 'visible','off');
 set(handles.iae, 'visible','off');
 set(handles.ise, 'visible','off');
 set(handles.cadreop1, 'visible','off');
 set(handles.cadreop2, 'visible','off');
 set(handles.cadreop3, 'visible','off');
 set(handles.mode, 'visible','off');
 set(handles.critere, 'visible','off');
 set(handles.opt, 'visible','off');
 set(handles.regu, 'visible','off');
 set(handles.ass, 'visible','off');
 set(handles.tc, 'visible','off');
 set(handles.filtre, 'visible','off');
 
  set(handles.cpd, 'visible','on');
 set(handles.txi, 'visible','on');
 set(handles.tw0, 'visible','on');
 set(handles.xi, 'visible','on');
 set(handles.w0, 'visible','on');
 set(handles.tte, 'visible','on');
 set(handles.te, 'visible','on');
 set(handles.tpd, 'visible','on');

% --- Executes on button press in pid2.
function pid2_Callback(hObject, eventdata, handles)
% hObject    handle to pid2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pid2
set(handles.ziegler, 'Value', 0);
set(handles.cohen, 'Value', 0);
set(handles.reglab, 'Value', 0);
set(handles.optim, 'Value', 0);
set(handles.imc, 'Value', 0);
set(handles.pid1, 'Value', 0);
set(handles.pid2, 'Value', 1);
set(handles.itae, 'visible','off');
 set(handles.iae, 'visible','off');
 set(handles.ise, 'visible','off');
 set(handles.cadreop1, 'visible','off');
 set(handles.cadreop2, 'visible','off');
 set(handles.cadreop3, 'visible','off');
 set(handles.mode, 'visible','off');
 set(handles.critere, 'visible','off');
 set(handles.opt, 'visible','off');
 set(handles.regu, 'visible','off');
 set(handles.ass, 'visible','off');
 set(handles.tc, 'visible','off');
 set(handles.filtre, 'visible','off');
 
  set(handles.cpd, 'visible','on');
 set(handles.txi, 'visible','on');
 set(handles.tw0, 'visible','on');
 set(handles.xi, 'visible','on');
 set(handles.w0, 'visible','on');
 set(handles.tte, 'visible','on');
 set(handles.te, 'visible','on');
 set(handles.tpd, 'visible','on');


% --- Executes during object creation, after setting all properties.
function w0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to w0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function w0_Callback(hObject, eventdata, handles)
% hObject    handle to w0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of w0 as text
%        str2double(get(hObject,'String')) returns contents of w0 as a double
w0 = str2double(get(hObject, 'String'));
if isnan(w0)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

data = getappdata(gcbf, 'metricdata');
data.w0 = w0;
setappdata(gcbf, 'metricdata', data);

% --- Executes during object creation, after setting all properties.
function te_CreateFcn(hObject, eventdata, handles)
% hObject    handle to te (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function te_Callback(hObject, eventdata, handles)
% hObject    handle to te (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of te as text
%        str2double(get(hObject,'String')) returns contents of te as a double
te = str2double(get(hObject, 'String'));
if isnan(te)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

data = getappdata(gcbf, 'metricdata');
data.te = te;
setappdata(gcbf, 'metricdata', data);

% --- Executes during object creation, after setting all properties.
function xi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function xi_Callback(hObject, eventdata, handles)
% hObject    handle to xi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xi as text
%        str2double(get(hObject,'String')) returns contents of xi as a double
xi = str2double(get(hObject, 'String'));
if isnan(xi)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

data = getappdata(gcbf, 'metricdata');
data.xi = xi;
setappdata(gcbf, 'metricdata', data);


% --- Executes on button press in simuler.
function simuler_Callback(hObject, eventdata, handles)
% hObject    handle to simuler (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


