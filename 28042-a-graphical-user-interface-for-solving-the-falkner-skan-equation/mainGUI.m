function varargout = mainGUI(varargin)
% MAINGUI M-file for mainGUI.fig
%      MAINGUI, by itself, creates a new MAINGUI or raises the existing
%      singleton*.
%
%      H = MAINGUI returns the handle to a new MAINGUI or the handle to
%      the existing singleton*.
%
%      MAINGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINGUI.M with the given input arguments.
%
%      MAINGUI('Property','Value',...) creates a new MAINGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mainGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mainGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help mainGUI

% Last Modified by GUIDE v2.5 30-Mar-2010 14:47:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mainGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @mainGUI_OutputFcn, ...
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
%global CHOISE
clc


% --- Executes just before mainGUI is made visible.
function mainGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mainGUI (see VARARGIN)

% Choose default command line output for mainGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mainGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

set(handles.MainMenu_BtnPnl, 'SelectionChangeFcn', @MainMenu_BtnPnl_SelectionChangeFcn);
initialize_gui(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = mainGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function beta0_edit_Callback(hObject, eventdata, handles)
% hObject    handle to beta0_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    value = str2double(get(hObject,'String'));
    if (isempty(value))
        set(hObject,'String','0')
    end
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function beta0_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beta0_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function betai_edit_Callback(hObject, eventdata, handles)
% hObject    handle to betai_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    value = str2num(get(hObject,'String'));
    if (isempty(value))
        set(hObject,'String','0')
    end
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function betai_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to betai_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function betaf_edit_Callback(hObject, eventdata, handles)
% hObject    handle to betaf_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    value = str2double(get(hObject,'String'));
    if (isempty(value))
        set(hObject,'String','0')
    end
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function betaf_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to betaf_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function eps1_edit_Callback(hObject, eventdata, handles)
% hObject    handle to eps1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    value = str2double(get(hObject,'String'));
    if (isempty(value))
        set(hObject,'String','0')
    end
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function eps1_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eps1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function alpha0_edit_Callback(hObject, eventdata, handles)
% hObject    handle to eps1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    value = str2double(get(hObject,'String'));
    if (isempty(value))
        set(hObject,'String','0')
    end
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function alpha0_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eps1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function eps2i_edit_Callback(hObject, eventdata, handles)
% hObject    handle to eps2i_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    value = str2double(get(hObject,'String'));
    if (isempty(value))
        set(hObject,'String','0')
    end
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function eps2i_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eps2i_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function eps2f_edit_Callback(hObject, eventdata, handles)
% hObject    handle to eps2f_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    value = str2double(get(hObject,'String'));
    if (isempty(value))
        set(hObject,'String','0')
    end
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function eps2f_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eps2f_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function EtaInf0_edit_Callback(hObject, eventdata, handles)
% hObject    handle to EtaInf0_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    value = str2double(get(hObject,'String'));
    if (isempty(value))
        set(hObject,'String','0')
    end
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function EtaInf0_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EtaInf0_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dbeta_edit_Callback(hObject, eventdata, handles)
% hObject    handle to dbeta_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    value = str2double(get(hObject,'String'));
    if (isempty(value))
        set(hObject,'String','0')
    end
    guidata(hObject, handles);
    

% --- Executes during object creation, after setting all properties.
function dbeta_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dbeta_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function deps2_edit_Callback(hObject, eventdata, handles)
% hObject    handle to deps2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    value = str2double(get(hObject,'String'));
    if (isempty(value))
        set(hObject,'String','0')
    end
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function deps2_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deps2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in Run_PshBtn.
function Run_PshBtn_Callback(hObject, eventdata, handles)
% hObject    handle to Run_PshBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CHOISE
style = ['r' 'k' 'b' 'g' 'y' 'c' 'm' 'r.' 'k.' 'b.' 'g.' 'y.' 'c.' 'm.'];
switch (CHOISE)
    case 1
        Beta0 = str2double(get(handles.beta0_edit,'String'));
        Beta = str2double(get(handles.betai_edit,'String'));
        eps1 = str2double(get(handles.eps1_edit,'String'));
        eps2 = str2double(get(handles.eps2i_edit,'String'));
        Alfa0 = str2double(get(handles.alpha0_edit,'String'));
        EtaInf0 = str2double(get(handles.EtaInf0_edit,'String'));
        [Ex f u v Alfa EtaInf itrs] = FalknerSkanSolver(Beta0, Beta, eps1, ...
                                                        eps2, Alfa0, ... 
                                                        EtaInf0, hObject, 1);
        iterations = 1:1:itrs;
        axes(handles.Alfa_axis)
        hold off
        plot(iterations, Alfa, 'o');
        title('Shooting angle \alpha')
        xlabel('iterations');
        axes(handles.EtaInf_axis)
        hold off
        plot(iterations, EtaInf, 'o');
        title('Free boundary condition \eta Inf')
        xlabel('iterations');
        Eta = Ex*EtaInf(end);
        axes(handles.f_axis)
        hold off
        plot(Eta, f, 'r');
        title('f(\eta)');
        xlabel('\eta');
        axes(handles.df_axis)
        hold off
        plot(Eta, u, 'r');
        title('f''(\eta)');
        xlabel('\eta');
        axes(handles.d2f_axis)
        hold off
        plot(Eta, v, 'r');
        title('f''''(\eta)')
        xlabel('\eta');
    case 2
        t1 = cputime;
        S = {};
        Beta0 = str2double(get(handles.beta0_edit,'String'));
        Beta = str2double(get(handles.betai_edit,'String'));
        eps1 = str2double(get(handles.eps1_edit,'String'));
        eps2 = str2double(get(handles.eps2i_edit,'String'));
        FinalEps2 = str2double(get(handles.eps2f_edit,'String'));
        StepEps2 = str2double(get(handles.deps2_edit,'String'));
        Alfa0 = str2double(get(handles.alpha0_edit,'String'));
        EtaInf0 = str2double(get(handles.EtaInf0_edit,'String'));
        msg = '   eps2      Alpha       Eta Inf  f(Eta Inf)  df\dEta(Eta Inf)  d^2f\dEta^2(Eta Inf)';   
        msg1= '|------------------------------------------------------------------------------------';
        msg = strcat(msg, msg1);
        set(handles.Info_LstBx, 'String', msg);
        i = 1;
        xLim = eps2;
        axes(handles.Alfa_axis)
        hold off
        axes(handles.EtaInf_axis)   
        hold off
        axes(handles.f_axis)
        hold off
        axes(handles.df_axis)
        hold off
        axes(handles.d2f_axis)
        hold off
        while (eps2 >= FinalEps2)
            [Ex f u v Alfa EtaInf itrs] = FalknerSkanSolver(Beta0, ... 
                                                            Beta, ...
                                                            eps1, eps2, ...
                                                            Alfa0, ... 
                                                            EtaInf0, ...
                                                            hObject, 0);
            [msg1 err] = sprintf('|%1.1e  %1.11f  %1.5f   %1.7f     %1.7f           %1.7f', eps2, Alfa(end), EtaInf(end), f(end), u(end), v(end));
            msg = strcat(msg, msg1);
            set(handles.Info_LstBx, 'String', msg);
            % plotting
            [s err] = sprintf('ep2 = %1.0e', eps2);
            S(i)= {s};
            Eta = Ex*EtaInf(end);
            axes(handles.f_axis)
            plot(Eta, f, style(i));
            title('f(\eta)')
            xlabel('\eta');
            legend(S);
            hold on 
            axes(handles.df_axis)
            plot(Eta, u, style(i));
            title('f''(\eta)')
            xlabel('\eta');
            legend(S);
            hold on
            axes(handles.d2f_axis)
            plot(Eta, v, style(i));
            title('f''''(\eta)')
            xlabel('\eta');
            legend(S);
            hold on
            axes(handles.Alfa_axis)
            plot(Beta, Alfa(end), 'bo');
            title('Shooting angle \alpha')
            xlabel('\epsilon2');
            hold on
            axes(handles.EtaInf_axis)
            plot(Beta, EtaInf(end), 'bo');
            title('Free boundary condition \eta Inf')
            xlabel('\epsilon2');
            hold on
            i = i + 1;
            eps2 = eps2*StepEps2;
        end
        t2 = cputime - t1;
        [msg1 err] = sprintf('| ');
        msg = strcat(msg, msg1);
        set(handles.Info_LstBx, 'String', msg);
        [msg1 err] = sprintf('|Computational time: %d s', t2);
        msg = strcat(msg, msg1);
        set(handles.Info_LstBx, 'String', msg);
    case 3
        t1 = cputime;
        S = {};
        Beta0 = str2double(get(handles.beta0_edit,'String'));
        Beta = str2double(get(handles.betai_edit,'String'));
        FinalBeta = str2double(get(handles.betaf_edit,'String'));
        StepBeta = str2double(get(handles.dbeta_edit,'String'));
        eps1 = str2double(get(handles.eps1_edit,'String'));
        eps2 = str2double(get(handles.eps2i_edit,'String'));
        Alfa0 = str2double(get(handles.alpha0_edit,'String'));
        EtaInf0 = str2double(get(handles.EtaInf0_edit,'String'));
        msg = '   Beta       Alpha       Eta Inf  f(Eta Inf)  df\dEta(Eta Inf)  d^2f\dEta^2(Eta Inf)';
        msg1= '|-------------------------------------------------------------------------------------';
        msg = strcat(msg, msg1);
        set(handles.Info_LstBx, 'String', msg);
        ArrayBeta = Beta:StepBeta:FinalBeta;
        i = 1;
        axes(handles.Alfa_axis)
        hold off
        axes(handles.EtaInf_axis)   
        hold off
        axes(handles.f_axis)
        hold off
        axes(handles.df_axis)
        hold off
        axes(handles.d2f_axis)
        hold off
        while (Beta <= FinalBeta)
            [Ex f u v Alfa EtaInf itrs] = FalknerSkanSolver(Beta0, ... 
                                                            Beta, ...
                                                            eps1, eps2, ...
                                                            Alfa0, ... 
                                                            EtaInf0, ...
                                                            hObject, 0);
            ArrayAlfa(i) = Alfa(end);
            ArrayEtaInf(i) = EtaInf(end);
            [msg1 err] = sprintf('|  %2.4f   %1.11f  %1.5f   %1.7f     %1.7f           %1.7f', Beta, Alfa(end), EtaInf(end), f(end), u(end), v(end));
            msg = strcat(msg, msg1);
            set(handles.Info_LstBx, 'String', msg);
            % plotting
            [s err] = sprintf('Beta = %1.1f', Beta);
            S(i)= {s};
            Eta = Ex*EtaInf(end);
            axes(handles.f_axis)
            plot(Eta, f, style(i));
            title('f(\eta)')
            xlabel('\eta');
            legend(S);
            hold on
            axes(handles.df_axis)
            plot(Eta, u, style(i));
            title('f''(\eta)')
            xlabel('\eta');
            legend(S);
            hold on
            axes(handles.d2f_axis)
            plot(Eta, v, style(i));
            title('f''''(\eta)')
            xlabel('\eta');
            legend(S);
            hold on
            axes(handles.Alfa_axis)
            plot(Beta, Alfa(end), 'bo');
            title('Shooting angle \alpha')
            xlabel('\beta');
            hold on
            axes(handles.EtaInf_axis)
            plot(Beta, EtaInf(end), 'bo');
            title('Free boundary condition \eta Inf')
            xlabel('\beta');
            hold on
            i = i + 1;
            Beta = Beta + StepBeta;
        end
        t2 = cputime - t1;
        [msg1 err] = sprintf('| ');
        msg = strcat(msg, msg1);
        set(handles.Info_LstBx, 'String', msg);
        [msg1 err] = sprintf('|Computational time: %d s', t2);
        msg = strcat(msg, msg1);
        set(handles.Info_LstBx, 'String', msg);
end

% --- Executes on button press in Reset_PshBtn.
function Reset_PshBtn_Callback(hObject, eventdata, handles)
% hObject    handle to Reset_PshBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    initialize_gui(hObject, handles);




% --- Executes on selection change in Info_LstBx.
function Info_LstBx_Callback(hObject, eventdata, handles)
% hObject    handle to Info_LstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Info_LstBx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Info_LstBx


% --- Executes during object creation, after setting all properties.
function Info_LstBx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Info_LstBx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dbeta_edit__Callback(hObject, eventdata, handles)
% hObject    handle to alpha0_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha0_edit as text
%        str2double(get(hObject,'String')) returns contents of alpha0_edit as a double


% --- Executes during object creation, after setting all properties.
function dbeta_edit__CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha0_edit (see GCBO)
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
function MainMenu_BtnPnl_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to MainMenu_BtnPnl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CHOISE
handles = guidata(hObject);

switch get(eventdata.NewValue, 'Tag')
    case 'Chose1_RdBtn'
        set(handles.betaf_edit, 'Visible', 'Off');
        set(handles.betaf_text, 'Visible', 'Off');
        set(handles.betafp_text, 'Visible', 'Off');
        set(handles.dbeta_text, 'Visible', 'Off');
        set(handles.dbeta_edit, 'Visible', 'Off');
        set(handles.betaip_text, 'String', '');
        set(handles.eps2f_edit, 'Visible', 'Off');
        set(handles.eps2f_text, 'Visible', 'Off');
        set(handles.eps2fp_text, 'Visible', 'Off');
        set(handles.deps2_edit, 'Visible', 'Off');
        set(handles.deps2_text, 'Visible', 'Off');
        set(handles.deps2p_text, 'Visible', 'Off');
        set(handles.eps2ip_text, 'String', '2');
        CHOISE = 1;
    case 'Chose2_RdBtn'
        set(handles.betaf_edit, 'Visible', 'Off');
        set(handles.betaf_text, 'Visible', 'Off');
        set(handles.betafp_text, 'Visible', 'Off');
        set(handles.dbeta_text, 'Visible', 'Off');
        set(handles.dbeta_edit, 'Visible', 'Off');
        set(handles.betaip_text, 'String', '');
        set(handles.eps2f_edit, 'Visible', 'On');
        set(handles.eps2f_text, 'Visible', 'On');
        set(handles.eps2fp_text, 'Visible', 'On');
        set(handles.deps2_edit, 'Visible', 'On');
        set(handles.deps2_text, 'Visible', 'On');
        set(handles.deps2p_text, 'Visible', 'On');
        set(handles.eps2ip_text, 'String', '2,i');
        CHOISE = 2;        
    case 'Chose3_RdBtn'
        set(handles.betaf_edit, 'Visible', 'On');
        set(handles.betaf_text, 'Visible', 'On');
        set(handles.betafp_text, 'Visible', 'On');
        set(handles.dbeta_text, 'Visible', 'On');
        set(handles.dbeta_edit, 'Visible', 'On');
        set(handles.betaip_text, 'String', 'i');
        set(handles.eps2f_edit, 'Visible', 'Off');
        set(handles.eps2f_text, 'Visible', 'Off');
        set(handles.eps2fp_text, 'Visible', 'Off');
        set(handles.deps2_edit, 'Visible', 'Off');
        set(handles.deps2_text, 'Visible', 'Off');
        set(handles.deps2p_text, 'Visible', 'Off');
        set(handles.eps2ip_text, 'String', '2');
        CHOISE = 3;        
end


function initialize_gui(hObject, handles)
    global CHOISE;
    set(handles.Chose1_RdBtn, 'Value', 1.0);
    set(handles.Chose2_RdBtn, 'Value', 0.0);
    set(handles.Chose3_RdBtn, 'Value', 0.0);
    set(handles.betaf_edit, 'Visible', 'Off');
    set(handles.betaf_text, 'Visible', 'Off');
    set(handles.betafp_text, 'Visible', 'Off');
    set(handles.dbeta_text, 'Visible', 'Off');
    set(handles.dbeta_edit, 'Visible', 'Off');
    set(handles.betaip_text, 'String', '');
    set(handles.eps2f_edit, 'Visible', 'Off');
    set(handles.eps2f_text, 'Visible', 'Off');
    set(handles.eps2fp_text, 'Visible', 'Off');
    set(handles.deps2_edit, 'Visible', 'Off');
    set(handles.deps2_text, 'Visible', 'Off');
    set(handles.deps2p_text, 'Visible', 'Off');
    set(handles.eps2ip_text, 'String', '2');
    set(handles.Info_LstBx, 'String', '');
    CHOISE = 1;


