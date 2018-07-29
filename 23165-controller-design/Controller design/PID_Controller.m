function varargout = PID_Controller(varargin)

global sys_tf sys_ss sys_fd_P sys_fd_PD sys_fd_PI sys_fd_PID
global a_dou b_dou c_dou d_dou
global sys_final_P sys_final_PI sys_final_PD sys_final_PID

% PID_CONTROLLER M-file for PID_Controller.fig
%      PID_CONTROLLER, by itself, creates a new PID_CONTROLLER or raises the existing
%      singleton*.
%
%      H = PID_CONTROLLER returns the handle to a new PID_CONTROLLER or the handle to
%      the existing singleton*.
%
%      PID_CONTROLLER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PID_CONTROLLER.M with the given input arguments.
%
%      PID_CONTROLLER('Property','Value',...) creates a new PID_CONTROLLER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PID_Controller_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PID_Controller_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PID_Controller

% Last Modified by GUIDE v2.5 04-Sep-2008 09:14:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PID_Controller_OpeningFcn, ...
                   'gui_OutputFcn',  @PID_Controller_OutputFcn, ...
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

% --- Executes just before PID_Controller is made visible.
function PID_Controller_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PID_Controller (see VARARGIN)

% Choose default command line output for PID_Controller
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PID_Controller wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PID_Controller_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ss_pushb.
function ss_pushb_Callback(hObject, eventdata, handles)
% hObject    handle to ss_pushb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%====================== Values from Radio Button ======================
ss_pushbutton = get (handles.ss_radiob,'Value');
tf_pushbutton = get (handles.tf_radiob,'Value');

%================= Implementing State Space Model ====================
if ss_pushbutton == get(handles.ss_radiob,'Max')

    a = get(handles.A_edit,'String');
    global a_dou
    a_dou = str2num(a);
    
    b= get(handles.B_edit,'String');
    global b_dou
    b_dou = str2num(b);
    
    c= get(handles.C_edit,'String');
    global c_dou
    c_dou = str2num(c);
    
    d= get(handles.D_edit,'String');
    global d_dou
    d_dou = str2num(d);
    
    %================= Error If Either A,B,C or D is empty ================
    
    if isempty(a_dou) || isempty(b_dou) || isempty(c_dou) || isempty(d_dou)
        errordlg('Please enter all A,B,C and D in correct format');
    end
    
    %======= Error If the State Space Model is not correct ================
    [r1 c1] = size(a_dou);
    [r2 c2] = size(c_dou);
    [r3 c3] = size(b_dou);
    [r4 c4] = size(d_dou);
        if c1 ~= c2
            errordlg('Please Enter Valid State Space Model');
        end
        if r1 ~= r3
            errordlg('Please Enter Valid State Space Model');
        end
        if c3 ~= c4
            errordlg('Please Enter Valid State Space Model');
        end
           
    global sys_ss
    sys_ss = ss(a_dou,b_dou,c_dou,d_dou);            % State Space Model
    
     [s t]= step(sys_ss);
     axes(handles.axes1)
     plot(t,s),grid on
    
    %================= Error If State Space Button is not selected ========
else
    errordlg('Select "State Space"');
end

    %======================= Time Response ================================
    
%     sys_s = tf(a_dou,b_dou,c_dou,d_dou)
%     sys_s = tf(n,d)
    sys_s= tf(sys_ss);
    [num,den] = tfdata(sys_s);
    [r c] = size(den{1,1});
    
    if c ~= 3
        set(handles.MOS_text,'String','Approximation Not Valid');
        set(handles.PTS_text,'String','Approximation Not Valid');
        set(handles.STS_text,'String','Approximation Not Valid');
    end
    
    roots_sys = roots(den{1,1});
    roots_sys_str = num2str(roots_sys);
    
    set(handles.ROS_text,'String',roots_sys_str);

    den_sp = den{1,1}(1,3);
    wn = sqrt(den_sp);
    den_sp2 = den{1,1}(1,2);
    b = den_sp2/(2*wn);
    [r c] = size(den{1,1});
    
    if b<=1 && num{1,1}(1,end-1) == 0 && c == 3
        MOS = exp(-(b*pi)/(sqrt(1-b^2)))*100;
        MOS_str = num2str(MOS);
        MOS_real = strcat(MOS_str,' %');
        set(handles.MOS_text,'String',MOS_real);
        
        PTS = pi/(wn*(sqrt(1-b^2)));
        PTS_str = num2str(PTS);
        PTS_real = strcat(PTS_str,' Sec');
        set(handles.PTS_text,'String',PTS_real);
        
        STS = 4/(b*wn);
        STS_str = num2str(STS);
        STS_real = strcat(STS_str,' Sec');
        set(handles.STS_text,'String',STS_real);
    else
        set(handles.MOS_text,'String','Approximation Not Valid');
        set(handles.PTS_text,'String','Approximation Not Valid');
        set(handles.STS_text,'String','Approximation Not Valid');
    end


%==========================================================================


function A_edit_Callback(hObject, eventdata, handles)
% hObject    handle to A_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A_edit as text
%        str2double(get(hObject,'String')) returns contents of A_edit as a double


% --- Executes during object creation, after setting all properties.
function A_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function B_edit_Callback(hObject, eventdata, handles)
% hObject    handle to B_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of B_edit as text
%        str2double(get(hObject,'String')) returns contents of B_edit as a double


% --- Executes during object creation, after setting all properties.
function B_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to B_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function C_edit_Callback(hObject, eventdata, handles)
% hObject    handle to C_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of C_edit as text
%        str2double(get(hObject,'String')) returns contents of C_edit as a double


% --- Executes during object creation, after setting all properties.
function C_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to C_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function D_edit_Callback(hObject, eventdata, handles)
% hObject    handle to D_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of D_edit as text
%        str2double(get(hObject,'String')) returns contents of D_edit as a double


% --- Executes during object creation, after setting all properties.
function D_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to D_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tf_pushb.
function tf_pushb_Callback(hObject, eventdata, handles)
% hObject    handle to tf_pushb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%====================== Values from Radio Button ======================
ss_pushbutton = get (handles.ss_radiob,'Value');
tf_pushbutton = get (handles.tf_radiob,'Value');

%================= Implementing Transfer Function ====================

if tf_pushbutton == get(handles.tf_radiob,'Max')
     
    num= get (handles.num_edit,'string');
    num_dou = str2num(num);
    
    den= get (handles.den_edit,'string');
    den_dou = str2num(den);

    %================= Error If Either Num or Den is empty  ====================
    if isempty(num_dou) || isempty(den_dou)
        errordlg('Please enter in right format, For Example Num = [1 2] or Den = [1 2 3]');
    end
    % =====================================================================
    
    global sys_tf
    sys_tf = tf(num_dou,den_dou);            % Transfer Function
    
    [s t]= step(sys_tf);
    axes(handles.axes1)
    plot(t,s),grid on
    
    %================= Error If Transfer Function Button is not selected=======

else
    errordlg('Select "Transfer Function');
end

    %======================= Time Response ================================
    
    [num,den] = tfdata(sys_tf);
    [r c] = size(den{1,1});
    
    if c ~= 3
        set(handles.MOS_text,'String','Approximation Not Valid');
        set(handles.PTS_text,'String','Approximation Not Valid');
        set(handles.STS_text,'String','Approximation Not Valid');
    end
    
    roots_sys = roots(den{1,1});
    roots_sys_str = num2str(roots_sys);
    
    set(handles.ROS_text,'String',roots_sys_str);

    den_sp = den{1,1}(1,3);
    wn = sqrt(den_sp);
    den_sp2 = den{1,1}(1,2);
    b = den_sp2/(2*wn);
    [r c] = size(den{1,1});
    
    if b<=1 && num{1,1}(1,end-1) == 0 && c == 3
        MOS = exp(-(b*pi)/(sqrt(1-b^2)))*100;
        MOS_str = num2str(MOS);
        MOS_real = strcat(MOS_str,' %');
        set(handles.MOS_text,'String',MOS_real);
        
        PTS = pi/(wn*(sqrt(1-b^2)));
        PTS_str = num2str(PTS);
        PTS_real = strcat(PTS_str,' Sec');
        set(handles.PTS_text,'String',PTS_real);
        
        STS = 4/(b*wn);
        STS_str = num2str(STS);
        STS_real = strcat(STS_str,' Sec');
        set(handles.STS_text,'String',STS_real);
    else
        set(handles.MOS_text,'String','Approximation Not Valid');
        set(handles.PTS_text,'String','Approximation Not Valid');
        set(handles.STS_text,'String','Approximation Not Valid');
    end
%==========================================================================

function num_edit_Callback(hObject, eventdata, handles)
% hObject    handle to num_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_edit as text
%        str2double(get(hObject,'String')) returns contents of num_edit as a double


% --- Executes during object creation, after setting all properties.
function num_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function den_edit_Callback(hObject, eventdata, handles)
% hObject    handle to den_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of den_edit as text
%        str2double(get(hObject,'String')) returns contents of den_edit as a double


% --- Executes during object creation, after setting all properties.
function den_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to den_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PID_popupmenu.
function PID_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to PID_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns PID_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PID_popupmenu


% --- Executes during object creation, after setting all properties.
function PID_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PID_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Kp_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Kp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Kp_edit as text
%        str2double(get(hObject,'String')) returns contents of Kp_edit as a double


% --- Executes during object creation, after setting all properties.
function Kp_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Kp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ki_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Ki_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ki_edit as text
%        str2double(get(hObject,'String')) returns contents of Ki_edit as a double


% --- Executes during object creation, after setting all properties.
function Ki_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ki_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Kd_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Kd_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Kd_edit as text
%        str2double(get(hObject,'String')) returns contents of Kd_edit as a double


% --- Executes during object creation, after setting all properties.
function Kd_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Kd_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PID_pushb.
function PID_pushb_Callback(hObject, eventdata, handles)
% hObject    handle to PID_pushb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%===== Values from Controller popup menu and Responses menu ===============

value = get(handles.PID_popupmenu,'Value');


%====================== Values from Radio Button ======================

ss_pushbutton = get (handles.ss_radiob,'Value');
tf_pushbutton = get (handles.tf_radiob,'Value');

%==================== Selecting Only Proportional Controller %===============

if value == 1
    value_str = get(handles.Kp_edit,'String');
    value_dou = str2num (value_str);
    
    if tf_pushbutton == get(handles.tf_radiob,'Max');

        global sys_tf
        sys_final_P = sys_tf * value_dou;
        global sys_fd_P
        sys_fd_P = feedback(sys_final_P,1);    

    end
    
    if ss_pushbutton == get(handles.ss_radiob,'Max')
        
        %================= Error If Either A,B,C or D is empty ================
    global a_dou b_dou c_dou d_dou
    if isempty(a_dou) || isempty(b_dou) || isempty(c_dou) || isempty(d_dou)
        errordlg('Please enter all A,B,C and D in correct format');
    end
    
    %======= Error If the State Space Model is not correct ================
    [r1 c1] = size(a_dou);
    [r2 c2] = size(c_dou);
    [r3 c3] = size(b_dou);
    [r4 c4] = size(d_dou);
        if c1 ~= c2
            errordlg('Please Enter Valid State Space Model');
        end
        if r1 ~= r3
            errordlg('Please Enter Valid State Space Model');
        end
        if c3 ~= c4
            errordlg('Please Enter Valid State Space Model');
        end
        %==================================================================
        global a_dou b_dou c_dou d_dou
        [num den] = ss2tf(a_dou, b_dou ,c_dou ,d_dou);
        sys_tf_ss = tf(num,den);
        sys_final_P = sys_tf_ss * value_dou;
        global sys_fd_P
        sys_fd_P = feedback(sys_final_P,1);
        
    end
        
        [s t]= step(sys_final_P);
        axes(handles.axes5)
        plot(t,s),grid on
        set(handles.OLSR_text,'String','P Controller');
        
        global sys_fd_P
        [s t]= step(sys_fd_P);
        axes(handles.axes6)
        plot(t,s),grid on
        set(handles.CLSR_text,'String','P Controller');

end
    
    
%==================== Selecting Proportional Integral Controller ===============

if value == 2 
    value_str = get(handles.Kp_edit,'String');
    value_dou = str2num (value_str);
    
    value_strPi = get(handles.Ki_edit,'String');
    value_douPi = str2num (value_strPi);
    value_tfpi = tf(value_douPi,[1 0]);
    
    if tf_pushbutton == get(handles.tf_radiob,'Max')

        global sys_tf
        PI = value_dou + value_tfpi;
        sys_final_PI = sys_tf * PI;
        global sys_fd_PI
        sys_fd_PI = feedback(sys_final_PI,1);
             
    end
    
    if ss_pushbutton == get(handles.ss_radiob,'Max')
        
         %================= Error If Either A,B,C or D is empty ================
    global a_dou b_dou c_dou d_dou
    if isempty(a_dou) || isempty(b_dou) || isempty(c_dou) || isempty(d_dou)
        errordlg('Please enter all A,B,C and D in correct format');
    end
    
    %======= Error If the State Space Model is not correct ================
    [r1 c1] = size(a_dou);
    [r2 c2] = size(c_dou);
    [r3 c3] = size(b_dou);
    [r4 c4] = size(d_dou);
        if c1 ~= c2
            errordlg('Please Enter Valid State Space Model');
        end
        if r1 ~= r3
            errordlg('Please Enter Valid State Space Model');
        end
        if c3 ~= c4
            errordlg('Please Enter Valid State Space Model');
        end
        %==================================================================
        global a_dou b_dou c_dou d_dou
        [num den] = ss2tf(a_dou, b_dou ,c_dou ,d_dou);
        sys_tf_ss = tf(num,den);
        PI = value_dou + value_tfpi;
        sys_final_PI = sys_tf_ss * PI;
        global sys_fd_PI
        sys_fd_PI = feedback(sys_final_PI,1);    
    end
    
     [s t]= step(sys_fd_PI);
     axes(handles.axes6)
     plot(t,s),grid on
     set(handles.CLSR_text,'String','PI Controller');
     
     [s t]= step(sys_final_PI);
     axes(handles.axes5)
     plot(t,s),grid on
     set(handles.OLSR_text,'String','PI Controller');
   
 
end
    
%==================== Selecting Proportional Derivative Controller ===============    

if value == 3 
    value_str = get(handles.Kp_edit,'String');
    value_dou = str2num (value_str);
    
    value_strPd = get(handles.Kd_edit,'String');
    value_douPd = str2num (value_strPd);
    value_tfpd = tf([value_douPd 0],1);
    
    if tf_pushbutton == get(handles.tf_radiob,'Max')
   
        global sys_tf
        PD = value_dou + value_tfpd;
        sys_final_PD = sys_tf * PD;
        global sys_fd_PD
        sys_fd_PD = feedback(sys_final_PD,1);
    end
    
    if ss_pushbutton == get(handles.ss_radiob,'Max')
        
         %================= Error If Either A,B,C or D is empty ================
    global a_dou b_dou c_dou d_dou
    if isempty(a_dou) || isempty(b_dou) || isempty(c_dou) || isempty(d_dou)
        errordlg('Please enter all A,B,C and D in correct format');
    end
    
    %======= Error If the State Space Model is not correct ================
    [r1 c1] = size(a_dou);
    [r2 c2] = size(c_dou);
    [r3 c3] = size(b_dou);
    [r4 c4] = size(d_dou);
        if c1 ~= c2
            errordlg('Please Enter Valid State Space Model');
        end
        if r1 ~= r3
            errordlg('Please Enter Valid State Space Model');
        end
        if c3 ~= c4
            errordlg('Please Enter Valid State Space Model');
        end
        %==================================================================
        global a_dou b_dou c_dou d_dou
        [num den] = ss2tf(a_dou, b_dou ,c_dou ,d_dou);
        sys_tf_ss = tf(num,den);
        PD = value_dou + value_tfpd;
        sys_final_PD = sys_tf_ss * PD;
        global sys_fd_PD
        sys_fd_PD = feedback(sys_final_PD,1);    
    end
    
    [s t]= step(sys_fd_PD);
    axes(handles.axes6)
    plot(t,s),grid on
    set(handles.CLSR_text,'String','PD Controller');
    
    [s t]= step(sys_final_PD);
    axes(handles.axes5)
    plot(t,s),grid on
    set(handles.OLSR_text,'String','PD Controller');
end
    
%==================== Selecting PID Controller ===============   

if value == 4
    value_str = get(handles.Kp_edit,'String');
    value_dou = str2num (value_str);
 
    value_strPd = get(handles.Kd_edit,'String');
    value_douPd = str2num (value_strPd);
    value_tfpd = tf([value_douPd 0],1);
        
    value_strPi = get(handles.Ki_edit,'String');
    value_douPi = str2num (value_strPi);
    value_tfpi = tf(value_douPi,[1 0]);
        
        
     if tf_pushbutton == get(handles.tf_radiob,'Max')
   
        global sys_tf
        PID = value_dou + value_tfpi + value_tfpd;
        sys_final_PID = sys_tf * PID;
        global sys_fd_PID
        sys_fd_PID = feedback(sys_final_PID,1);
    end
    
    if ss_pushbutton == get(handles.ss_radiob,'Max')
        
         %================= Error If Either A,B,C or D is empty ================
    global a_dou b_dou c_dou d_dou
    if isempty(a_dou) || isempty(b_dou) || isempty(c_dou) || isempty(d_dou)
        errordlg('Please enter all A,B,C and D in correct format');
    end
    
    %======= Error If the State Space Model is not correct ================
    [r1 c1] = size(a_dou);
    [r2 c2] = size(c_dou);
    [r3 c3] = size(b_dou);
    [r4 c4] = size(d_dou);
        if c1 ~= c2
            errordlg('Please Enter Valid State Space Model');
        end
        if r1 ~= r3
            errordlg('Please Enter Valid State Space Model');
        end
        if c3 ~= c4
            errordlg('Please Enter Valid State Space Model');
        end
        %==================================================================
        global a_dou b_dou c_dou d_dou
        [num den] = ss2tf(a_dou, b_dou ,c_dou ,d_dou);
        sys_tf_ss = tf(num,den);
        PID = value_dou + value_tfpi + value_tfpd;
        sys_final_PID = sys_tf_ss * PID;
        global sys_fd_PID
        sys_fd_PID = feedback(sys_final_PID,1);    
    end

    [s t]= step(sys_fd_PID);
    axes(handles.axes6)
    plot(t,s),grid on
    set(handles.CLSR_text,'String','PID Controller');
    
    [s t]= step(sys_final_PID);
    axes(handles.axes5)
    plot(t,s),grid on
    set(handles.OLSR_text,'String','PID Controller');
               
    
end
% --------------------------------------------------------------------
function SRWC_Callback(hObject, eventdata, handles)
% hObject    handle to SRWC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%====================== Values from Radio Button ======================
tf_pushbutton = get (handles.tf_radiob,'Value');
ss_pushbutton = get(handles.ss_radiob,'Value'); 

%================= Error If both Options Selected ====================
if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Max')
    errordlg('Select One Option from "State Space" or "Transfer Function"');
end

%================= Error If both were not Selected ===================
if ss_pushbutton == get(handles.ss_radiob,'Min') && tf_pushbutton == get(handles.tf_radiob,'Min')
    errordlg('First Enter either "State Space" or "Transfer Function"');
end

%================= Implementing Transfer Function ====================
if tf_pushbutton == get(handles.tf_radiob,'Max') && ss_pushbutton == get(handles.ss_radiob,'Min')
    num= get (handles.num_edit,'string');
    num_dou = str2num(num);
    
    den= get (handles.den_edit,'string');
    den_dou = str2num(den);
    
    %================= Error If Either Num or Den is empty ==============
    if isempty(num_dou) || isempty(den_dou)
        errordlg('Please Enter "Transfer Function"');
    end
    
    sys_tf = tf(num_dou,den_dou);
    figure
    step(sys_tf),title('Step Response Without Controller'),grid on
end

%================= Implementing State Space Model ====================

if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Min')
         
    a= get(handles.A_edit,'String');
    a_dou = str2num(a);
    
    b= get(handles.B_edit,'String');
    b_dou = str2num(b);
    
    c= get(handles.C_edit,'String');
    c_dou = str2num(c);
    
    d= get(handles.D_edit,'String');
    d_dou = str2num(d);
    
    %================= Error If Either A,B,C or D is empty ==============
    
    if isempty(a_dou) || isempty(b_dou) || isempty(c_dou) || isempty(d_dou)
        errordlg('Please enter all A,B,C and D');
    end
    
    sys_ss = ss(a_dou,b_dou,c_dou,d_dou);
    figure
    step(sys_ss),title('Step Response Without Controller'),grid on
end

% --------------------------------------------------------------------
function IRWC_Callback(hObject, eventdata, handles)
% hObject    handle to IRWC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%====================== Values from Radio Button ======================
tf_pushbutton = get (handles.tf_radiob,'Value');
ss_pushbutton = get(handles.ss_radiob,'Value');

%================= Error If both were not Selected ===================
if ss_pushbutton == get(handles.ss_radiob,'Min') && tf_pushbutton == get(handles.tf_radiob,'Min')
    errordlg('First Enter either "State Space" or "Transfer Function"');
end

%================= Implementing Transfer Function ====================
if tf_pushbutton == get(handles.tf_radiob,'Max') && ss_pushbutton == get(handles.ss_radiob,'Min')
    num= get (handles.num_edit,'string');
    num_dou = str2num(num);
    
    den= get (handles.den_edit,'string');
    den_dou = str2num(den);
    
    %================= Error If Either Num or Den is empty ==============
    if isempty(num_dou) || isempty(den_dou)
        errordlg('Please Enter "Transfer Function"');
    end

    sys_tf = tf(num_dou,den_dou);
    figure
    Impulse(sys_tf),title('Impulse Response Without Controller'),grid on
end

%================= Implementing State Space Model ====================

if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Min')
        
    a= get(handles.A_edit,'String');
    a_dou = str2num(a);
    
    b= get(handles.B_edit,'String');
    b_dou = str2num(b);
    
    c= get(handles.C_edit,'String');
    c_dou = str2num(c);
    
    d= get(handles.D_edit,'String');
    d_dou = str2num(d);
    
    %================= Error If Either A,B,C or D is empty ==============
    
    if isempty(a_dou) || isempty(b_dou) || isempty(c_dou) || isempty(d_dou)
        errordlg('Please enter all A,B,C and D')
    end
     
    sys_ss = ss(a_dou,b_dou,c_dou,d_dou);
    figure
    impulse(sys_ss),title('Impulse Response Without Controller'),grid on
end
% --------------------------------------------------------------------
function PZMWC_Callback(hObject, eventdata, handles)
% hObject    handle to PZMWC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%====================== Values from Radio Button ======================
tf_pushbutton = get (handles.tf_radiob,'Value');
ss_pushbutton = get(handles.ss_radiob,'Value'); 

%================= Implementing Transfer Function ====================
if tf_pushbutton == get(handles.tf_radiob,'Max') && ss_pushbutton == get(handles.ss_radiob,'Min')
    num= get (handles.num_edit,'string');
    num_dou = str2num(num);
    
    den= get (handles.den_edit,'string');
    den_dou = str2num(den);
    
    %================= Error If Either Num or Den is empty ==============
    if isempty(num_dou) || isempty(den_dou)
        errordlg('Please Enter "Transfer Function"');
    end
    
    sys_tf = tf(num_dou,den_dou);
    figure
    pzmap(sys_tf),title('Pole Zero Map Without Controller'),grid on
end

%================= Implementing State Space Model ====================

if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Min')
     
    a= get(handles.A_edit,'String');
    a_dou = str2num(a);
    
    b= get(handles.B_edit,'String');
    b_dou = str2num(b);
    
    c= get(handles.C_edit,'String');
    c_dou = str2num(c);
    
    d= get(handles.D_edit,'String');
    d_dou = str2num(d);
    
    %================= Error If Either A,B,C or D is empty ==============
    
    if isempty(a_dou) || isempty(b_dou) || isempty(c_dou) || isempty(d_dou)
        errordlg('Please enter all A,B,C and D')
    end
    
    sys_ss = ss(a_dou,b_dou,c_dou,d_dou);
    figure
    pzmap(sys_ss),title('Pole Zero Map Without Controller'),grid on
end
%=====================================================================


% --------------------------------------------------------------------
function SRC_Callback(hObject, eventdata, handles)
% hObject    handle to SRC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = get(handles.PID_popupmenu,'Value');

if value == 1
    global sys_fd_P
    figure,step(sys_fd_P),title('Step Response With Proportional Controller'),grid on
end

if value == 2
    global sys_fd_PI
    figure,step(sys_fd_PI),title('Step Response With Proportional Integral Controller'),grid on
end

if value == 3
    global sys_fd_PD
    figure,step(sys_fd_PD),title('Step Response With Proportional Derivative Controller'),grid on
end

if value == 4
    global sys_fd_PID
    figure,step(sys_fd_PID),title('Step Response With PID Controller'),grid on
end

% --------------------------------------------------------------------
function IRC_Callback(hObject, eventdata, handles)
% hObject    handle to IRC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = get(handles.PID_popupmenu,'Value');

if value == 1
    global sys_fd_P
    figure,impulse(sys_fd_P),title('Impulse Response With Proportional Controller'),grid on
end

if value == 2
    global sys_fd_PI
    figure,impulse(sys_fd_PI),title('Impulse Response With Proportional Integral Controller'),grid on
end

if value == 3
    global sys_fd_PD
    figure,impulse(sys_fd_PD),title('Impulse Response With Proportional Derivative Controller'),grid on
end

if value == 4
    global sys_fd_PID
    figure,impulse(sys_fd_PID),title('Impulse Response With PID Controller'),grid on
end

% --------------------------------------------------------------------
function PZMC_Callback(hObject, eventdata, handles)
% hObject    handle to PZMC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = get(handles.PID_popupmenu,'Value');

if value == 1
    global sys_fd_P
    figure,pzmap(sys_fd_P),title('Pole Zero Map With Proportional Controller'),grid on
end

if value == 2
    global sys_fd_PI
    figure,pzmap(sys_fd_PI),title('Pole Zero Map With Proportional Integral Controller'),grid on
end

if value == 3
    global sys_fd_PD
    figure,pzmap(sys_fd_PD),title('Pole Zero Map With Proportional Derivative Controller'),grid on
end

if value == 4
    global sys_fd_PID
    figure,pzmap(sys_fd_PID),title('Pole Zero Map With PID Controller'),grid on
end

% --------------------------------------------------------------------
function BPWC_Callback(hObject, eventdata, handles)
% hObject    handle to BPWC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%====================== Values from Radio Button ======================
tf_pushbutton = get (handles.tf_radiob,'Value');
ss_pushbutton = get(handles.ss_radiob,'Value');

%================= Error If both were not Selected ===================
if ss_pushbutton == get(handles.ss_radiob,'Min') && tf_pushbutton == get(handles.tf_radiob,'Min')
    errordlg('First Enter either "State Space" or "Transfer Function"');
end

%================= Implementing Transfer Function ====================
if tf_pushbutton == get(handles.tf_radiob,'Max') && ss_pushbutton == get(handles.ss_radiob,'Min')
    num= get (handles.num_edit,'string');
    num_dou = str2num(num);
    
    den= get (handles.den_edit,'string');
    den_dou = str2num(den);
    
    %================= Error If Either Num or Den is empty ================
    if isempty(num_dou) || isempty(den_dou)
        errordlg('Please Enter "Transfer Function"');
    end
    
    sys_tf = tf(num_dou,den_dou);
    figure
    bode(sys_tf),title('Bode Diagram Without Controller'),grid on
end

%================= Implementing State Space Model =========================

if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Min')
        
    a= get(handles.A_edit,'String');
    a_dou = str2num(a);
    
    b= get(handles.B_edit,'String');
    b_dou = str2num(b);
    
    c= get(handles.C_edit,'String');
    c_dou = str2num(c);
    
    d= get(handles.D_edit,'String');
    d_dou = str2num(d);
    
    %================= Error If Either A,B,C or D is empty ================
    
    if isempty(a_dou) || isempty(b_dou) || isempty(c_dou) || isempty(d_dou)
        errordlg('Please enter all A,B,C and D');
    end
    
    sys_ss = ss(a_dou,b_dou,c_dou,d_dou);
    figure
    bode(sys_ss),title('Bode Diagram Without Controller'),grid on
end
%=====================================================================
% --------------------------------------------------------------------
function NPWC_Callback(hObject, eventdata, handles)
% hObject    handle to NPWC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%====================== Values from Radio Button ======================
tf_pushbutton = get (handles.tf_radiob,'Value');
ss_pushbutton = get(handles.ss_radiob,'Value');

%================= Error If both were not Selected ===================
if ss_pushbutton == get(handles.ss_radiob,'Min') && tf_pushbutton == get(handles.tf_radiob,'Min')
    errordlg('First Enter either "State Space" or "Transfer Function"');
end

%================= Implementing Transfer Function ====================
if tf_pushbutton == get(handles.tf_radiob,'Max') && ss_pushbutton == get(handles.ss_radiob,'Min')
    num= get (handles.num_edit,'string');
    num_dou = str2num(num);
    
    den= get (handles.den_edit,'string');
    den_dou = str2num(den);
    
    %================= Error If Either Num or Den is empty ==============
    if isempty(num_dou) || isempty(den_dou)
        errordlg('Please Enter "Transfer Function"');
    end
    
    sys_tf = tf(num_dou,den_dou);
    figure
    nyquist(sys_tf),title('Nyquist Plot Without Controller'),grid on
end

%================= Implementing State Space Model ====================

if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Min')
       
    a= get(handles.A_edit,'String');
    a_dou = str2num(a);
    
    b= get(handles.B_edit,'String');
    b_dou = str2num(b);
    
    c= get(handles.C_edit,'String');
    c_dou = str2num(c);
    
    d= get(handles.D_edit,'String');
    d_dou = str2num(d);
    
    %================= Error If Either A,B,C or D is empty ==============
    
    if isempty(a_dou) || isempty(b_dou) || isempty(c_dou) || isempty(d_dou)
        errordlg('Please enter all A,B,C and D');
    end
    
    sys_ss = ss(a_dou,b_dou,c_dou,d_dou);
    figure
    nyquist(sys_ss),title('Nyquist Plot Without Controller'),grid on
end
%=====================================================================

% --------------------------------------------------------------------
function NCWC_Callback(hObject, eventdata, handles)
% hObject    handle to NCWC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%====================== Values from Radio Button ======================
tf_pushbutton = get (handles.tf_radiob,'Value');
ss_pushbutton = get(handles.ss_radiob,'Value');

%================= Error If both were not Selected ===================
if ss_pushbutton == get(handles.ss_radiob,'Min') && tf_pushbutton == get(handles.tf_radiob,'Min')
    errordlg('First Enter either "State Space" or "Transfer Function"');
end

%================= Implementing Transfer Function ====================
if tf_pushbutton == get(handles.tf_radiob,'Max') && ss_pushbutton == get(handles.ss_radiob,'Min')
    num= get (handles.num_edit,'string');
    num_dou = str2num(num);
    
    den= get (handles.den_edit,'string');
    den_dou = str2num(den);
    
    %================= Error If Either Num or Den is empty ==============
    if isempty(num_dou) || isempty(den_dou)
        errordlg('Please Enter "Transfer Function"');
    end

    sys_tf = tf(num_dou,den_dou);
    figure
    nichols(sys_tf),title('Nichols Chat Without Controller'),grid on
end

%================= Implementing State Space Model ====================

if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Min')
        
    a= get(handles.A_edit,'String');
    a_dou = str2num(a);
    
    b= get(handles.B_edit,'String');
    b_dou = str2num(b);
    
    c= get(handles.C_edit,'String');
    c_dou = str2num(c);
    
    d= get(handles.D_edit,'String');
    d_dou = str2num(d);
    
    %================= Error If Either A,B,C or D is empty ==============
    
    if isempty(a_dou) || isempty(b_dou) || isempty(c_dou) || isempty(d_dou)
        errordlg('Please enter all A,B,C and D');
    end

    sys_ss = ss(a_dou,b_dou,c_dou,d_dou);
    figure
    nichols(sys_ss),title('Nichols Chat Without Controller'),grid on
end
%=====================================================================

% --------------------------------------------------------------------
function BPC_Callback(hObject, eventdata, handles)
% hObject    handle to BPC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = get(handles.PID_popupmenu,'Value');

if value == 1
    global sys_fd_P
    figure,bode(sys_fd_P),title('Bode Plot With Proportional Controller'),grid on
end

if value == 2
    global sys_fd_PI
    figure,bode(sys_fd_PI),title('Bode Plot With Proportional Integral Controller'),grid on
end

if value == 3
    global sys_fd_PD
    figure,bode(sys_fd_PD),title('Bode Plot With Proportional Derivative Controller'),grid on
end

if value == 4
    global sys_fd_PID
    figure,bode(sys_fd_PID),title('Bode Plot With PID Controller'),grid on
end

% --------------------------------------------------------------------
function NPC_Callback(hObject, eventdata, handles)
% hObject    handle to NPC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = get(handles.PID_popupmenu,'Value');

if value == 1
    global sys_fd_P
    figure,nyquist(sys_fd_P),title('Nyquist Plot With Proportional Controller'),grid on
end

if value == 2
    global sys_fd_PI
    figure,nyquist(sys_fd_PI),title('Nyquist Plot With Proportional Integral Controller'),grid on
end

if value == 3
    global sys_fd_PD
    figure,nyquist(sys_fd_PD),title('Nyquist Plot With Proportional Derivative Controller'),grid on
end

if value == 4
    global sys_fd_PID
    figure,nyquist(sys_fd_PID),title('Nyquist Plot With PID Controller'),grid on
end

% --------------------------------------------------------------------
function NCC_Callback(hObject, eventdata, handles)
% hObject    handle to NCC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = get(handles.PID_popupmenu,'Value');

if value == 1
    global sys_fd_P
    figure,nichols(sys_fd_P),title('Nichols ChartWith Proportional Controller'),grid on
end

if value == 2
    global sys_fd_PI
    figure,nichols(sys_fd_PI),title('Nichols Chart With Proportional Integral Controller'),grid on
end

if value == 3
    global sys_fd_PD
    figure,nichols(sys_fd_PD),title('Nichols Chart With Proportional Derivative Controller'),grid on
end

if value == 4
    global sys_fd_PID
    figure,nichols(sys_fd_PID),title('Nichols Chart With PID Controller'),grid on
end

% --------------------------------------------------------------------
function RLWC_Callback(hObject, eventdata, handles)
% hObject    handle to RLWC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%====================== Values from Radio Button ======================
tf_pushbutton = get (handles.tf_radiob,'Value');
ss_pushbutton = get(handles.ss_radiob,'Value');

%================= Error If both Options Selected ====================
if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Max')
    errordlg('Select One Option from "State Space" or "Transfer Function"');
end

%================= Error If both were not Selected ===================
if ss_pushbutton == get(handles.ss_radiob,'Min') && tf_pushbutton == get(handles.tf_radiob,'Min')
    errordlg('First Enter either "State Space" or "Transfer Function"');
end

%================= Implementing Transfer Function ====================
if tf_pushbutton == get(handles.tf_radiob,'Max') && ss_pushbutton == get(handles.ss_radiob,'Min')
    num= get (handles.num_edit,'string');
    num_dou = str2num(num);
    
    den= get (handles.den_edit,'string');
    den_dou = str2num(den);
    
    %================= Error If Either Num or Den is empty ==============
    if isempty(num_dou) || isempty(den_dou)
        errordlg('Please Enter "Transfer Function"');
    end
    
    sys_tf = tf(num_dou,den_dou);
    figure
    rlocus(sys_tf),title('Root Locus Without Controller')
end

%================= Implementing State Space Model ====================

if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Min')
       
    a= get(handles.A_edit,'String');
    a_dou = str2num(a);
    
    b= get(handles.B_edit,'String');
    b_dou = str2num(b);
    
    c= get(handles.C_edit,'String');
    c_dou = str2num(c);
    
    d= get(handles.D_edit,'String');
    d_dou = str2num(d);
    
    %================= Error If Either A,B,C or D is empty ==============
    
    if isempty(a_dou) || isempty(b_dou) || isempty(c_dou) || isempty(d_dou)
        errordlg('Please enter all A,B,C and D');
    end
    
    sys_ss = ss(a_dou,b_dou,c_dou,d_dou);
    figure
    rlocus(sys_ss),title('Root Locus Without Controller'),grid on
end

% --------------------------------------------------------------------
function RLC_Callback(hObject, eventdata, handles)
% hObject    handle to RLC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = get(handles.PID_popupmenu,'Value');

if value == 1
    global sys_fd_P
    figure,rlocus(sys_fd_P),title('Root Locus With Proportional Controller')
end

if value == 2
    global sys_fd_PI
    figure,rlocus(sys_fd_PI),title('Root Locus With Proportional Integral Controller')
end

if value == 3
    global sys_fd_PD
    figure,rlocus(sys_fd_PD),title('Root Locus With Proportional Derivative Controller')
end

if value == 4
    global sys_fd_PID
    figure,rlocus(sys_fd_PID),title('Root Locus With PID Controller')
end

% --------------------------------------------------------------------

function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------


% --- Executes on selection change in TAFR_popupmenu.
function TAFR_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to TAFR_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns TAFR_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TAFR_popupmenu


% --- Executes during object creation, after setting all properties.
function TAFR_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TAFR_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in TAFR_pushb.
function TAFR_pushb_Callback(hObject, eventdata, handles)
% hObject    handle to TAFR_pushb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% =============== Values from Pop Up menus (Controller and Responses)======

value_response = get(handles.TAFR_popupmenu,'Value');
value = get(handles.PID_popupmenu,'Value');

% =========================================================================

% ========================Proportional Controller =========================
if value ==1

    % ==================== Time Response ==================================
    
    if value_response == 1
        set(handles.MOlabel_text,'String','Maximum Overshoot >');
        set(handles.PTlabel_text,'String','Peak Time >');
        set(handles.STlabel_text,'String','Settling Time >');
        
        global sys_fd_P
        order_sys = order(sys_fd_P);
        order_sys_str = num2str(order_sys);
        set(handles.Order_text,'String',order_sys_str);
        
        [num,den] = tfdata(sys_fd_P);
        [r c] = size(den{1,1});
        
        if c ~= 3
            set(handles.MO_text,'String','Approximation Not Valid');
            set(handles.PT_text,'String','Approximation Not Valid');
            set(handles.ST_text,'String','Approximation Not Valid');
        end

        roots_sys = roots(den{1,1});
        roots_sys_str = num2str(roots_sys);
        
        set(handles.roots_text,'String',roots_sys_str);
        den_sp = den{1,1}(1,3);
        wn = sqrt(den_sp);
        den_sp2 = den{1,1}(1,2);
        b = den_sp2/(2*wn);
        
        
        if b<=1 && num{1,1}(1,end-1) == 0 && c==3
            MO = exp(-(b*pi)/(sqrt(1-b^2)))*100;
            MO_str = num2str(MO);
            MO_real = strcat(MO_str,' %');
            set(handles.MO_text,'String',MO_real);
            
            PT = pi/(wn*(sqrt(1-b^2)));
            PT_str = num2str(PT);
            PT_real = strcat(PT_str,' Sec');
            set(handles.PT_text,'String',PT_real);
            
            ST = 4/(b*wn);
            ST_str = num2str(ST);
            ST_real = strcat(ST_str,' Sec');
            set(handles.ST_text,'String',ST_real);
        
        else
            set(handles.MO_text,'String','Approximation Not Valid');
            set(handles.PT_text,'String','Approximation Not Valid');
            set(handles.ST_text,'String','Approximation Not Valid');
        end
    end
    % ====================== Frequncy Response ============================
    
    if value_response ==2
        set(handles.MOlabel_text,'String','Gain Margin >');
        set(handles.PTlabel_text,'String','Phase Margin >');
        set(handles.STlabel_text,'String','Bandwidth >');
        
        global sys_fd_P
        order_sys = order(sys_fd_P);
        order_sys_str = num2str(order_sys);
        set(handles.Order_text,'String',order_sys_str);
        
        band = bandwidth(sys_fd_P);
        band_str = num2str(band);
        set(handles.ST_text,'String',band_str);
    
        [gm pm wcg wcp]=margin (sys_fd_P);
        gm_str = num2str(gm);
        set(handles.MO_text,'String',gm_str);
    
        pm_str = num2str(pm);
        set(handles.PT_text,'String',pm_str);
    end
end

% ================Proportional Integral Controller ========================

if value ==2
    
    % ==================== Time Response ==================================
    
    if value_response == 1
        set(handles.MOlabel_text,'String','Maximum Overshoot >');
        set(handles.PTlabel_text,'String','Peak Time >');
        set(handles.STlabel_text,'String','Settling Time >');
        
       
        global sys_fd_PI
        order_sys = order(sys_fd_PI);
        order_sys_str = num2str(order_sys);
        set(handles.Order_text,'String',order_sys_str);
        
        [num,den] = tfdata(sys_fd_PI);
        [r c] = size(den{1,1});
        
        if c ~= 3
            set(handles.MO_text,'String','Approximation Not Valid');
            set(handles.PT_text,'String','Approximation Not Valid');
            set(handles.ST_text,'String','Approximation Not Valid');
        end

        roots_sys = roots(den{1,1});
        roots_sys_str = num2str(roots_sys);
        
        set(handles.roots_text,'String',roots_sys_str);
        den_sp = den{1,1}(1,3);
        wn = sqrt(den_sp);
        den_sp2 = den{1,1}(1,2);
        b = den_sp2/(2*wn);
        
        
        if b<=1 && num{1,1}(1,end-1) == 0 && c==3
            MO = exp(-(b*pi)/(sqrt(1-b^2)))*100;
            MO_str = num2str(MO);
            MO_real = strcat(MO_str,' %');
            set(handles.MO_text,'String',MO_real);
            
            PT = pi/(wn*(sqrt(1-b^2)));
            PT_str = num2str(PT);
            PT_real = strcat(PT_str,' Sec');
            set(handles.PT_text,'String',PT_real);
            
            ST = 4/(b*wn);
            ST_str = num2str(ST);
            ST_real = strcat(ST_str,' Sec');
            set(handles.ST_text,'String',ST_real);
        
        else
            set(handles.MO_text,'String','Approximation Not Valid');
            set(handles.PT_text,'String','Approximation Not Valid');
            set(handles.ST_text,'String','Approximation Not Valid');
        end
    end
    
    % ==================== Frequency Response =============================
    
    if value_response ==2
        set(handles.MOlabel_text,'String','Gain Margin >');
        set(handles.PTlabel_text,'String','Phase Margin >');
        set(handles.STlabel_text,'String','Bandwidth >');
    
        global sys_fd_PI
        order_sys = order(sys_fd_PI);
        order_sys_str = num2str(order_sys);
        set(handles.Order_text,'String',order_sys_str);
    
        band = bandwidth(sys_fd_PI);
        band_str = num2str(band);
        set(handles.ST_text,'String',band_str);
    
        [gm pm wcg wcp]=margin (sys_fd_PI);
        gm_str = num2str(gm);
        set(handles.MO_text,'String',gm_str);

        pm_str = num2str(pm);
        set(handles.PT_text,'String',pm_str);
    end
end

% ================Proportional Integral Controller =========================

if value ==3
    
     % ==================== Time Response ==================================
     
     if value_response == 1
        set(handles.MOlabel_text,'String','Maximum Overshoot >');
        set(handles.PTlabel_text,'String','Peak Time >');
        set(handles.STlabel_text,'String','Settling Time >');
        
       
        global sys_fd_PD
        order_sys = order(sys_fd_PD);
        order_sys_str = num2str(order_sys);
        set(handles.Order_text,'String',order_sys_str);
        
        [num,den] = tfdata(sys_fd_PD);
        [r c] = size(den{1,1});
        
        if c ~= 3
            set(handles.MO_text,'String','Approximation Not Valid');
            set(handles.PT_text,'String','Approximation Not Valid');
            set(handles.ST_text,'String','Approximation Not Valid');
        end

        roots_sys = roots(den{1,1});
        roots_sys_str = num2str(roots_sys);
        
        set(handles.roots_text,'String',roots_sys_str);
        den_sp = den{1,1}(1,3);
        wn = sqrt(den_sp);
        den_sp2 = den{1,1}(1,2);
        b = den_sp2/(2*wn);
        
        
        if b<=1 && num{1,1}(1,end-1) == 0 && c==3
            MO = exp(-(b*pi)/(sqrt(1-b^2)))*100;
            MO_str = num2str(MO);
            MO_real = strcat(MO_str,' %');
            set(handles.MO_text,'String',MO_real);
            
            PT = pi/(wn*(sqrt(1-b^2)));
            PT_str = num2str(PT);
            PT_real = strcat(PT_str,' Sec');
            set(handles.PT_text,'String',PT_real);
            
            ST = 4/(b*wn);
            ST_str = num2str(ST);
            ST_real = strcat(ST_str,' Sec');
            set(handles.ST_text,'String',ST_real);
        
        else
            set(handles.MO_text,'String','Approximation Not Valid');
            set(handles.PT_text,'String','Approximation Not Valid');
            set(handles.ST_text,'String','Approximation Not Valid');
        end
     end
     
     % ==================== Frequency Response ============================

     if value_response ==2
         set(handles.MOlabel_text,'String','Gain Margin >');
         set(handles.PTlabel_text,'String','Phase Margin >');
         set(handles.STlabel_text,'String','Bandwidth >');

         global sys_fd_PD
         order_sys = order(sys_fd_PD);
         order_sys_str = num2str(order_sys);
         set(handles.Order_text,'String',order_sys_str);
    
         band = bandwidth(sys_fd_PD);
         band_str = num2str(band);
         set(handles.ST_text,'String',band_str);
        
         [gm pm wcg wcp]=margin (sys_fd_PD);
         gm_str = num2str(gm);
         set(handles.MO_text,'String',gm_str);
    
         pm_str = num2str(pm);
         set(handles.PT_text,'String',pm_str);
    
     end
end

% ================Proportional Integral Derivative Controller =============

if value ==4
    
     % ==================== Time Response =================================

     if value_response == 1
        set(handles.MOlabel_text,'String','Maximum Overshoot >');
        set(handles.PTlabel_text,'String','Peak Time >');
        set(handles.STlabel_text,'String','Settling Time >');
        
       
        global sys_fd_PID
        order_sys = order(sys_fd_PID);
        order_sys_str = num2str(order_sys);
        set(handles.Order_text,'String',order_sys_str);
        
        [num,den] = tfdata(sys_fd_PID);
        [r c] = size(den{1,1});
        
        if c ~= 3
            set(handles.MO_text,'String','Approximation Not Valid');
            set(handles.PT_text,'String','Approximation Not Valid');
            set(handles.ST_text,'String','Approximation Not Valid');
        end

        roots_sys = roots(den{1,1});
        roots_sys_str = num2str(roots_sys);
        
        set(handles.roots_text,'String',roots_sys_str);
        den_sp = den{1,1}(1,3);
        wn = sqrt(den_sp);
        den_sp2 = den{1,1}(1,2);
        b = den_sp2/(2*wn);
        
        
        if b<=1 && num{1,1}(1,end-1) == 0 && c==3
            MO = exp(-(b*pi)/(sqrt(1-b^2)))*100;
            MO_str = num2str(MO);
            MO_real = strcat(MO_str,' %');
            set(handles.MO_text,'String',MO_real);
            
            PT = pi/(wn*(sqrt(1-b^2)));
            PT_str = num2str(PT);
            PT_real = strcat(PT_str,' Sec');
            set(handles.PT_text,'String',PT_real);
            
            ST = 4/(b*wn);
            ST_str = num2str(ST);
            ST_real = strcat(ST_str,' Sec');
            set(handles.ST_text,'String',ST_real);
        
        else
            set(handles.MO_text,'String','Approximation Not Valid');
            set(handles.PT_text,'String','Approximation Not Valid');
            set(handles.ST_text,'String','Approximation Not Valid');
        end
     end
     
     % ==================== Frequency Response ============================
     
     if value_response == 2
         set(handles.MOlabel_text,'String','Gain Margin >');
         set(handles.PTlabel_text,'String','Phase Margin >');
         set(handles.STlabel_text,'String','Bandwidth >');
    
         global sys_fd_PID
         order_sys = order(sys_fd_PID);
         order_sys_str = num2str(order_sys);
         set(handles.Order_text,'String',order_sys_str);
    
         band = bandwidth(sys_fd_PID);
         band_str = num2str(band);
         set(handles.ST_text,'String',band_str);
    
         [gm pm wcg wcp]=margin (sys_fd_PID);
         gm_str = num2str(gm);
         set(handles.MO_text,'String',gm_str);
    
         pm_str = num2str(pm);
         set(handles.PT_text,'String',pm_str);
     end
end