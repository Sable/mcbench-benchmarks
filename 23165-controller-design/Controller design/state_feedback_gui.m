function varargout = state_feedback_gui(varargin)

global sys_tf sys_ss sys_fd sys_fd_rp
global a_dou b_dou c_dou d_dou
% STATE_FEEDBACK_GUI M-file for state_feedback_gui.fig
%      STATE_FEEDBACK_GUI, by itself, creates a new STATE_FEEDBACK_GUI or raises the existing
%      singleton*.
%
%      H = STATE_FEEDBACK_GUI returns the handle to a new STATE_FEEDBACK_GUI or the handle to
%      the existing singleton*.
%
%      STATE_FEEDBACK_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STATE_FEEDBACK_GUI.M with the given input arguments.
%
%      STATE_FEEDBACK_GUI('Property','Value',...) creates a new STATE_FEEDBACK_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before state_feedback_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to state_feedback_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help state_feedback_gui

% Last Modified by GUIDE v2.5 31-Jul-2008 12:27:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @state_feedback_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @state_feedback_gui_OutputFcn, ...
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


% --- Executes just before state_feedback_gui is made visible.
function state_feedback_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to state_feedback_gui (see VARARGIN)

% Choose default command line output for state_feedback_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes state_feedback_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = state_feedback_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in tf_pushb.
function tf_pushb_Callback(hObject, eventdata, handles)
% hObject    handle to tf_pushb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%====================== Values from Radio Button ======================

ss_pushbutton = get (handles.ss_radiob,'Value');
tf_pushbutton = get (handles.tf_radiob,'Value');

%================= Error If both Options Selected ====================

if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Max')
    errordlg('Select One Option from "State Space" or "Transfer Function"');
end

%================= Implementing Transfer Function ====================

if tf_pushbutton == get(handles.tf_radiob,'Max')
    clc;
    num= get (handles.num_edit,'string');
    num_dou = str2num(num);
    
    den= get (handles.den_edit,'string');
    den_dou = str2num(den);

    %================= Error If Either Num or Den is empty  ====================

    if isempty(num_dou) || isempty(den_dou)
    errordlg('Please enter in right format, For Example Num = [1 2] or Den = [1 2 3]');
    end

global    sys_tf 
    sys_tf = tf(num_dou,den_dou);            % Transfer Function
    
    %==========================================================================
%     ord =  order(sys_tf) 
%     if ord~= 2
%         errordlg('Enter Second Order Systems (This software is designed only for second order system')
%     end

    %==========================================================================
    
    %================= Error If Transfer Function Button is not selected =======

else
    errordlg('Select "Transfer Function');
end



% --- Executes on button press in ss_pushb.
function ss_pushb_Callback(hObject, eventdata, handles)
% hObject    handle to ss_pushb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%====================== Values from Radio Button ======================
ss_pushbutton = get (handles.ss_radiob,'Value');
tf_pushbutton = get (handles.tf_radiob,'Value');

%================= Error If both Options Selected ====================
if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Max')
    errordlg('Select One Option from "State Space" or "Transfer Function"');
end

%================= Implementing State Space Model ====================

if ss_pushbutton == get(handles.ss_radiob,'Max')

    clc;
    
    a= get(handles.A_edit,'String');
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
    
    %================= Error If Either A,B,C or D is empty ==============
    
    if isempty(a_dou) || isempty(b_dou) || isempty(c_dou) || isempty(d_dou)
        errordlg('Please enter all A,B,C and D');
    end
    
    global sys_ss
    sys_ss = ss(a_dou,b_dou,c_dou,d_dou);            % State Space Model

    %==========================================================================
%     ord =  order(sys_ss) 
%     if ord~= 2
%         errordlg('Enter Second Order Systems (This software is designed only for second order system')
%     end

    %======================================================================
    %====

    %================= Error If State Space Button is not selected =======
else
    errordlg('Select "State Space"');
end

%========================================================================


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


% --- Executes on button press in tf_radiob.
function tf_radiob_Callback(hObject, eventdata, handles)
% hObject    handle to tf_radiob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tf_radiob


% --- Executes on button press in ss_radiob.
function ss_radiob_Callback(hObject, eventdata, handles)
% hObject    handle to ss_radiob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ss_radiob



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



function zeta_edit_Callback(hObject, eventdata, handles)
% hObject    handle to zeta_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zeta_edit as text
%        str2double(get(hObject,'String')) returns contents of zeta_edit as a double


% --- Executes during object creation, after setting all properties.
function zeta_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zeta_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wn_edit_Callback(hObject, eventdata, handles)
% hObject    handle to wn_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wn_edit as text
%        str2double(get(hObject,'String')) returns contents of wn_edit as a double


% --- Executes during object creation, after setting all properties.
function wn_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wn_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PPC_pushb.
function PPC_pushb_Callback(hObject, eventdata, handles)
% hObject    handle to PPC_pushb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ====================== Values from Controller popup menu =================

clc;
value = get(handles.PPC_popupmenu,'Value');

%====================== Values from Radio Button ==========================

ss_pushbutton = get (handles.ss_radiob,'Value');
tf_pushbutton = get (handles.tf_radiob,'Value');


%==================== Selecting Designed by Zeta and Wn  %=================

if value == 1
    value_zeta_str = get(handles.zeta_edit,'String');
    value_zeta_dou = str2num (value_zeta_str);
    
    value_wn_str = get(handles.wn_edit,'String');
    value_wn_dou = str2num (value_wn_str);
    
    
    if tf_pushbutton == get(handles.tf_radiob,'Max')
        
        global sys_tf
        [num,den] = tfdata(sys_tf);
        [A B C D] = tf2ss (num{1,1},den{1,1});
        sys_uncomp = ss(A,B,C,D);

        % =================================================================
        syms s
        Det = det(s*eye(2) - A);                    % Eigen Values
        
        % ================== Desired Characteristics Equation =============
        
        num = [1 (2*value_wn_dou*value_zeta_dou) value_wn_dou^2];
        sys_sfb = tf(num,1);
        
        % ================== Transformation Matrix ========================
        
        M = [B A*B];                                % Controllability Matrix
        
%         if rank(M) ~= order (sys_uncomp)
%             set(handles.error_text,'string','System is Uncotrollable, State feedback Controller is not possible');
%             return;
%         end

        W = [(-A(2:2,2:2)- A(1:1,1:1)) 1;1 0];
        T = M*W ;                                   % Transformation Matrix
        
        % % ================== Gain Vector  ===============================
        
        k1 = value_wn_dou^2-(A(1:1,1:1)* A(2:2,2:2) - A(1:1,2:2) * A(2:2,1:1));
        k2 = 2*value_zeta_dou*value_wn_dou - (-A(2:2,2:2)- A(1:1,1:1)); 
        K = [k1 k2];
        K_original = [k1 k2] * inv(T);
        
        % % ================== Checking Step Response =====================
        
        A_new = A - (B*K_original);
        sys_ss_sfb = ss(A_new,B,C,D);
        figure
        step(sys_ss_sfb), title ('Step Response with Controller'),grid on
        [num1,den1] = ss2tf(A_new,B,C,D);
        global sys_fd
        sys_fd = tf(num1,den1);
    end
        
        if ss_pushbutton == get(handles.ss_radiob,'Max')
            
            global a_dou b_dou c_dou d_dou
            global sys_ss
            
            % =============================================================
            
            syms s
%             H = [c_dou*(s*eye(2)-a_dou)*b_dou + d_dou]
            Det = det(s*eye(2) - a_dou);                    % Eigen Values
            
            % ================== Desired Characteristics Equation =========
            
            num = [1 (2*value_wn_dou*value_zeta_dou) value_wn_dou^2];
            sys_sfb = tf(num,1);
            
            % ================== Transformation Matrix ====================
            
            M = [b_dou (a_dou * b_dou)];                      % Controllability Matrix

%             if rank(M) ~= order (sys_ss)
%                 clc
%                 set(handles.error_text,'string','System is Uncotrollable, State feedback Controller is not possible');
%                 return;
%             end

            W = [(-a_dou(2:2,2:2)- a_dou(1:1,1:1)) 1;1 0];
            T = M*W ;                                       % Transformation Matrix
            
            % % ================== Gain Vector  ===========================
            
            k1 = value_wn_dou^2-(a_dou(1:1,1:1)* a_dou(2:2,2:2) - a_dou(1:1,2:2) * a_dou(2:2,1:1)); 
            k2 = 2*value_zeta_dou*value_wn_dou - (-a_dou(2:2,2:2)- a_dou(1:1,1:1)); 
            K = [k1 k2];
            K_original = [k1 k2] * inv(T);
            
            % % ================== Checking Step Response =================
            
            A_new = a_dou - (b_dou*K_original);
            sys_ss_sfb = ss(A_new,b_dou,c_dou,d_dou);
            figure
            step(sys_ss_sfb), title ('Step Response with Controller'),grid on
            [num1,den1] = ss2tf(A_new,b_dou,c_dou,d_dou);
            global sys_fd
            sys_fd = tf(num1,den1);
        end

        [num2,den2] = tfdata(sys_fd);
        [r c] = size(den2{1,1});
        
        if c ~= 3
            set(handles.MO_text,'String','Approximation Not Valid');
            set(handles.PT_text,'String','Approximation Not Valid');
            set(handles.ST_text,'String','Approximation Not Valid');
        end

        roots_sys = roots(den2{1,1});
        roots_sys_str = num2str(roots_sys);
        
        set(handles.roots_text,'String',roots_sys_str);
        den_sp = den2{1,1}(1,3);
        wn = sqrt(den_sp);
        den_sp2 = den2{1,1}(1,2);
        b = den_sp2/(2*wn);
        
        if b<=1 && num2{1,1}(1,end-1) == 0 && c==3
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

    
    
% %============== Selecting design by desired Poles location ==============

if value == 2 
    value_str_rp = get(handles.rp_edit,'String');
    value_dou_rp = str2num (value_str_rp);
    
    if tf_pushbutton == get(handles.tf_radiob,'Max')
        global sys_tf
        [num,den] = tfdata(sys_tf);
        [A B C D] = tf2ss (num{1,1},den{1,1});
        sys_uncomp = ss(A,B,C,D);
       
        % =================================================================
        
        syms s
        Det = det(s*eye(2) - A);                    % Eigen Values
        
        % ================== Desired Characteristics Equation =============
        
        num1 = [1 (-value_dou_rp(1) - value_dou_rp(2)) (-value_dou_rp(1) * -value_dou_rp(2))];
        sys_sfb = tf(num1,1);
        
        % ================== Transformation Matrix ========================
        
        M = [B A*B];                                % Controllability Matrix
        
        if rank(M) ~= order (sys_uncomp)
            clc
            set(handles.error_text,'string','System is Uncotrollable, State feedback Controller is not possible');
            return;
        end

        W = [(-A(2:2,2:2)- A(1:1,1:1)) 1;1 0];
        T = M*W ;                                   % Transformation Matrix
        
        % % ================== Gain Vector  ===============================
        [num2,den2] = tfdata(sys_sfb);
        value_wn  = num2{1,1}(1,3);
        k1 = value_wn -(A(1:1,1:1)* A(2:2,2:2) - A(1:1,2:2) * A(2:2,1:1)); 
        den_sp2 = num2{1,1}(1,2);
        b = den_sp2/(2*sqrt(value_wn));
        k2 = 2*b*sqrt(value_wn) - (-A(2:2,2:2)- A(1:1,1:1)); 
        K = [k1 k2];
        K_original = [k1 k2] * inv(T);
        
        % % ================== Checking Step Response =====================
        
        A_new = A - (B*K_original);
        sys_tf_sfb = ss(A_new,B,C,D);
        figure
        step(sys_tf_sfb), title ('Step Response with Controller'),grid on
        [num1,den1] = ss2tf(A_new,B,C,D);
        global sys_fd_rp
        sys_fd_rp = tf(num1,den1);
    end

    if ss_pushbutton == get(handles.ss_radiob,'Max')
        global a_dou b_dou c_dou d_dou
        global sys_ss
        
        % =================================================================
        
        syms s
        Det = det(s*eye(2) - a_dou);                    % Eigen Values
        
        % ================== Desired Characteristics Equation =============
        
        num1 = [1 (-value_dou_rp(1) - value_dou_rp(2)) (-value_dou_rp(1) * -value_dou_rp(2))];
        sys_sfb = tf(num1,1);
        
        % ================== Transformation Matrix ========================
        
        M = [b_dou a_dou*b_dou];                                % Controllability Matrix
        
%         if rank(M) ~= order (sys_ss)
%             clc
%             set(handles.error_text,'string','System is Uncotrollable, State feedback Controller is not possible');
%             return;
%         end

        W = [(-a_dou(2:2,2:2)- a_dou(1:1,1:1)) 1;1 0];
        T = M*W ;                                   % Transformation Matrix
        
        % % ================== Gain Vector  ===============================
        [num2,den2] = tfdata(sys_sfb);
        de_sp = num2{1,1}(1,3);
        value_wn = sqrt(de_sp);
        k1 = value_wn -(a_dou(1:1,1:1)* a_dou(2:2,2:2) - a_dou(1:1,2:2) * a_dou(2:2,1:1)); 
        den_sp2 = num2{1,1}(1,2);
        b = den_sp2/(2*value_wn);
        k2 = 2*b*value_wn - (-a_dou(2:2,2:2)- a_dou(1:1,1:1)); 
        K = [k1 k2];
        K_original = [k1 k2] * inv(T);
        
        % % ================== Checking Step Response =====================
        
        A_new = a_dou - (b_dou*K_original);
        sys_ss_sfb = ss(A_new,b_dou,c_dou,d_dou);
        figure
        step(sys_ss_sfb), title ('Step Response with Controller'),grid on
        [num1,den1] = ss2tf(A_new,b_dou,c_dou,d_dou);
        global sys_fd_rp
        sys_fd_rp = tf(num1,den1);
    end
               
        [num2,den2] = tfdata(sys_fd_rp);
        [r c] = size(den2{1,1});
        
        if c ~= 3
            set(handles.MO_text,'String','Approximation Not Valid');
            set(handles.PT_text,'String','Approximation Not Valid');
            set(handles.ST_text,'String','Approximation Not Valid');
        end
        
        roots_sys = roots(den2{1,1});
        roots_sys_str = num2str(roots_sys);
        
        set(handles.roots_text,'String',roots_sys_str);
        den_sp = den2{1,1}(1,3);
        wn = sqrt(den_sp);
        den_sp2 = den2{1,1}(1,2);
        b = den_sp2/(2*wn);
        
        if b<=1 && num2{1,1}(1,end-1) == 0 && c==3
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
% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6



function rp_edit_Callback(hObject, eventdata, handles)
% hObject    handle to rp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rp_edit as text
%        str2double(get(hObject,'String')) returns contents of rp_edit as a double


% --- Executes during object creation, after setting all properties.
function rp_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PPC_popupmenu.
function PPC_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to PPC_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns PPC_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PPC_popupmenu


% --- Executes during object creation, after setting all properties.
function PPC_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PPC_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function New_Callback(hObject, eventdata, handles)
% hObject    handle to New (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mfile_Callback(hObject, eventdata, handles)
% hObject    handle to mfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function GUI_Callback(hObject, eventdata, handles)
% hObject    handle to GUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Figure_Callback(hObject, eventdata, handles)
% hObject    handle to Figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Model_Callback(hObject, eventdata, handles)
% hObject    handle to Model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Close_Callback(hObject, eventdata, handles)
% hObject    handle to Close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(handles.figure1) 


% --------------------------------------------------------------------
function SRWC_Callback(hObject, eventdata, handles)
% hObject    handle to SRWC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%====================== Values from Radio Button ======================
tf_pushbutton = get (handles.tf_radiob,'Value')
ss_pushbutton = get(handles.ss_radiob,'Value') 

%================= Error If both Options Selected ====================
if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Max')
    errordlg('Select One Option from "State Space" or "Transfer Function"')
end

%================= Error If both were not Selected ===================
if ss_pushbutton == get(handles.ss_radiob,'Min') && tf_pushbutton == get(handles.tf_radiob,'Min')
    errordlg('First Enter either "State Space" or "Transfer Function"')
end

%================= Implementing Transfer Function ====================
if tf_pushbutton == get(handles.tf_radiob,'Max') && ss_pushbutton == get(handles.ss_radiob,'Min')
    num= get (handles.num_edit,'string')
    num_dou = str2num(num)
    
    den= get (handles.den_edit,'string')
    den_dou = str2num(den)
    
    %================= Error If Either Num or Den is empty ==============
    if isempty(num_dou) || isempty(den_dou)
    errordlg('Please Enter "Transfer Function"')
    end
    
%     global
    sys_tf = tf(num_dou,den_dou)
    figure
    step(sys_tf),title('Step Response Without Controller'),grid on
end

%================= Implementing State Space Model ====================

if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Min')
    clc
    
    a= get(handles.A_edit,'String')
    a_dou = str2num(a)
    
    b= get(handles.B_edit,'String')
    b_dou = str2num(b)
    
    c= get(handles.C_edit,'String')
    c_dou = str2num(c)
    
    d= get(handles.D_edit,'String')
    d_dou = str2num(d)
    
    %================= Error If Either A,B,C or D is empty ==============
    
    if isempty(a_dou) || isempty(b_dou) || isempty(c_dou) || isempty(d_dou)
    errordlg('Please enter all A,B,C and D')
    end
    
%     global 
    sys_ss = ss(a_dou,b_dou,c_dou,d_dou)
    figure
    step(sys_ss),title('Step Response Without Controller'),grid on
end

% --------------------------------------------------------------------
function Time_r_Callback(hObject, eventdata, handles)
% hObject    handle to Time_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SRC_Callback(hObject, eventdata, handles)
% hObject    handle to SRC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function IRWC_Callback(hObject, eventdata, handles)
% hObject    handle to IRWC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%====================== Values from Radio Button ======================
tf_pushbutton = get (handles.tf_radiob,'Value')
ss_pushbutton = get(handles.ss_radiob,'Value') 

%================= Error If both Options Selected ====================
if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Max')
    errordlg('Select One Option from "State Space" or "Transfer Function"')
end

%================= Error If both were not Selected ===================
if ss_pushbutton == get(handles.ss_radiob,'Min') && tf_pushbutton == get(handles.tf_radiob,'Min')
    errordlg('First Enter either "State Space" or "Transfer Function"')
end

%================= Implementing Transfer Function ====================
if tf_pushbutton == get(handles.tf_radiob,'Max') && ss_pushbutton == get(handles.ss_radiob,'Min')
    num= get (handles.num_edit,'string')
    num_dou = str2num(num)
    
    den= get (handles.den_edit,'string')
    den_dou = str2num(den)
    
    %================= Error If Either Num or Den is empty ==============
    if isempty(num_dou) || isempty(den_dou)
    errordlg('Please Enter "Transfer Function"')
    end
    
%     global
    sys_tf = tf(num_dou,den_dou)
    figure
    Impulse(sys_tf),title('Impulse Response Without Controller'),grid on
end

%================= Implementing State Space Model ====================

if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Min')
    clc
    
    a= get(handles.A_edit,'String')
    a_dou = str2num(a)
    
    b= get(handles.B_edit,'String')
    b_dou = str2num(b)
    
    c= get(handles.C_edit,'String')
    c_dou = str2num(c)
    
    d= get(handles.D_edit,'String')
    d_dou = str2num(d)
    
    %================= Error If Either A,B,C or D is empty ==============
    
    if isempty(a_dou) || isempty(b_dou) || isempty(c_dou) || isempty(d_dou)
    errordlg('Please enter all A,B,C and D')
    end
    
%     global 
    sys_ss = ss(a_dou,b_dou,c_dou,d_dou)
    figure
    impulse(sys_ss),title('Impulse Response Without Controller'),grid on
end

% --------------------------------------------------------------------
function IRC_Callback(hObject, eventdata, handles)
% hObject    handle to IRC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Frequency_r_Callback(hObject, eventdata, handles)
% hObject    handle to Frequency_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function BPWC_Callback(hObject, eventdata, handles)
% hObject    handle to BPWC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%====================== Values from Radio Button ======================
tf_pushbutton = get (handles.tf_radiob,'Value')
ss_pushbutton = get(handles.ss_radiob,'Value') 

%================= Error If both Options Selected ====================
if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Max')
    errordlg('Select One Option from "State Space" or "Transfer Function"')
end

%================= Error If both were not Selected ===================
if ss_pushbutton == get(handles.ss_radiob,'Min') && tf_pushbutton == get(handles.tf_radiob,'Min')
    errordlg('First Enter either "State Space" or "Transfer Function"')
end

%================= Implementing Transfer Function ====================
if tf_pushbutton == get(handles.tf_radiob,'Max') && ss_pushbutton == get(handles.ss_radiob,'Min')
    num= get (handles.num_edit,'string')
    num_dou = str2num(num)
    
    den= get (handles.den_edit,'string')
    den_dou = str2num(den)
    
    %================= Error If Either Num or Den is empty ==============
    if isempty(num_dou) || isempty(den_dou)
    errordlg('Please Enter "Transfer Function"')
    end
    
%     global
    sys_tf = tf(num_dou,den_dou)
    figure
    bode(sys_tf),title('Bode Diagram Without Controller'),grid on
end

%================= Implementing State Space Model ====================

if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Min')
    clc
    
    a= get(handles.A_edit,'String')
    a_dou = str2num(a)
    
    b= get(handles.B_edit,'String')
    b_dou = str2num(b)
    
    c= get(handles.C_edit,'String')
    c_dou = str2num(c)
    
    d= get(handles.D_edit,'String')
    d_dou = str2num(d)
    
    %================= Error If Either A,B,C or D is empty ==============
    
    if isempty(a_dou) || isempty(b_dou) || isempty(c_dou) || isempty(d_dou)
    errordlg('Please enter all A,B,C and D')
    end
    
%     global 
    sys_ss = ss(a_dou,b_dou,c_dou,d_dou)
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
tf_pushbutton = get (handles.tf_radiob,'Value')
ss_pushbutton = get(handles.ss_radiob,'Value') 

%================= Error If both Options Selected ====================
if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Max')
    errordlg('Select One Option from "State Space" or "Transfer Function"')
end

%================= Error If both were not Selected ===================
if ss_pushbutton == get(handles.ss_radiob,'Min') && tf_pushbutton == get(handles.tf_radiob,'Min')
    errordlg('First Enter either "State Space" or "Transfer Function"')
end

%================= Implementing Transfer Function ====================
if tf_pushbutton == get(handles.tf_radiob,'Max') && ss_pushbutton == get(handles.ss_radiob,'Min')
    num= get (handles.num_edit,'string')
    num_dou = str2num(num)
    
    den= get (handles.den_edit,'string')
    den_dou = str2num(den)
    
    %================= Error If Either Num or Den is empty ==============
    if isempty(num_dou) || isempty(den_dou)
    errordlg('Please Enter "Transfer Function"')
    end
    
%     global
    sys_tf = tf(num_dou,den_dou)
    figure
    nyquist(sys_tf),title('Nyquist Plot Without Controller'),grid on
end

%================= Implementing State Space Model ====================

if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Min')
    clc
    
    a= get(handles.A_edit,'String')
    a_dou = str2num(a)
    
    b= get(handles.B_edit,'String')
    b_dou = str2num(b)
    
    c= get(handles.C_edit,'String')
    c_dou = str2num(c)
    
    d= get(handles.D_edit,'String')
    d_dou = str2num(d)
    
    %================= Error If Either A,B,C or D is empty ==============
    
    if isempty(a_dou) || isempty(b_dou) || isempty(c_dou) || isempty(d_dou)
    errordlg('Please enter all A,B,C and D')
    end
    
%     global 
    sys_ss = ss(a_dou,b_dou,c_dou,d_dou)
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
tf_pushbutton = get (handles.tf_radiob,'Value')
ss_pushbutton = get(handles.ss_radiob,'Value') 

%================= Error If both Options Selected ====================
if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Max')
    errordlg('Select One Option from "State Space" or "Transfer Function"')
end

%================= Error If both were not Selected ===================
if ss_pushbutton == get(handles.ss_radiob,'Min') && tf_pushbutton == get(handles.tf_radiob,'Min')
    errordlg('First Enter either "State Space" or "Transfer Function"')
end

%================= Implementing Transfer Function ====================
if tf_pushbutton == get(handles.tf_radiob,'Max') && ss_pushbutton == get(handles.ss_radiob,'Min')
    num= get (handles.num_edit,'string')
    num_dou = str2num(num)
    
    den= get (handles.den_edit,'string')
    den_dou = str2num(den)
    
    %================= Error If Either Num or Den is empty ==============
    if isempty(num_dou) || isempty(den_dou)
    errordlg('Please Enter "Transfer Function"')
    end
    
%     global
    sys_tf = tf(num_dou,den_dou)
    figure
    nichols(sys_tf),title('Nichols Chat Without Controller'),grid on
end

%================= Implementing State Space Model ====================

if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Min')
    clc
    
    a= get(handles.A_edit,'String')
    a_dou = str2num(a)
    
    b= get(handles.B_edit,'String')
    b_dou = str2num(b)
    
    c= get(handles.C_edit,'String')
    c_dou = str2num(c)
    
    d= get(handles.D_edit,'String')
    d_dou = str2num(d)
    
    %================= Error If Either A,B,C or D is empty ==============
    
    if isempty(a_dou) || isempty(b_dou) || isempty(c_dou) || isempty(d_dou)
    errordlg('Please enter all A,B,C and D')
    end
    
%     global 
    sys_ss = ss(a_dou,b_dou,c_dou,d_dou)
    figure
    nichols(sys_ss),title('Nichols Chat Without Controller'),grid on
end
%=====================================================================

% --------------------------------------------------------------------
function BPC_Callback(hObject, eventdata, handles)
% hObject    handle to BPC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc, 
value = get(handles.PPC_popupmenu,'Value')

if value == 1
     global sys_fd
     figure,bode(sys_fd),title('Bode Plot With State feedback Controller'),grid on
end

if value == 2
     global sys_fd_rp
     figure,bode(sys_fd_rp),title('Bode Plot With State feedback Controller'),grid on
end
% --------------------------------------------------------------------
function NPC_Callback(hObject, eventdata, handles)
% hObject    handle to NPC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc, 
value = get(handles.PPC_popupmenu,'Value')

if value == 1
     global sys_fd
     figure,nyquist(sys_fd),title('Nyquist Plot With State feedback Controller'),grid on
end

if value == 2
     global sys_fd_rp
     figure,nyquist(sys_fd_rp),title('Nyquist Plot With State feedback Controller'),grid on
end

% --------------------------------------------------------------------
function NCC_Callback(hObject, eventdata, handles)
% hObject    handle to NCC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clc, 
value = get(handles.PPC_popupmenu,'Value')

if value == 1
     global sys_fd
     figure,nichols(sys_fd),title('Nichols Chart With State feedback Controller'),grid on
end
% --------------------------------------------------------------------
function Root_l_Callback(hObject, eventdata, handles)
% hObject    handle to Root_l (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function RLWC_Callback(hObject, eventdata, handles)
% hObject    handle to RLWC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%====================== Values from Radio Button ======================
tf_pushbutton = get (handles.tf_radiob,'Value')
ss_pushbutton = get(handles.ss_radiob,'Value') 

%================= Error If both Options Selected ====================
if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Max')
    errordlg('Select One Option from "State Space" or "Transfer Function"')
end

%================= Error If both were not Selected ===================
if ss_pushbutton == get(handles.ss_radiob,'Min') && tf_pushbutton == get(handles.tf_radiob,'Min')
    errordlg('First Enter either "State Space" or "Transfer Function"')
end

%================= Implementing Transfer Function ====================
if tf_pushbutton == get(handles.tf_radiob,'Max') && ss_pushbutton == get(handles.ss_radiob,'Min')
    num= get (handles.num_edit,'string')
    num_dou = str2num(num)
    
    den= get (handles.den_edit,'string')
    den_dou = str2num(den)
    
    %================= Error If Either Num or Den is empty ==============
    if isempty(num_dou) || isempty(den_dou)
    errordlg('Please Enter "Transfer Function"')
    end
    
%     global
    sys_tf = tf(num_dou,den_dou)
    figure
    rlocus(sys_tf),title('Root Locus Without Controller')
end

%================= Implementing State Space Model ====================

if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Min')
    clc
    
    a= get(handles.A_edit,'String')
    a_dou = str2num(a)
    
    b= get(handles.B_edit,'String')
    b_dou = str2num(b)
    
    c= get(handles.C_edit,'String')
    c_dou = str2num(c)
    
    d= get(handles.D_edit,'String')
    d_dou = str2num(d)
    
    %================= Error If Either A,B,C or D is empty ==============
    
    if isempty(a_dou) || isempty(b_dou) || isempty(c_dou) || isempty(d_dou)
    errordlg('Please enter all A,B,C and D')
    end
    
%     global 
    sys_ss = ss(a_dou,b_dou,c_dou,d_dou)
    figure
    rlocus(sys_ss),title('Root Locus Without Controller'),grid on
end
% --------------------------------------------------------------------
function RLC_Callback(hObject, eventdata, handles)
% hObject    handle to RLC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc, 
value = get(handles.PPC_popupmenu,'Value')

if value == 1
     global sys_fd
     figure,rlocus(sys_fd),title('Root Locus With State feedback Controller')
end



% --------------------------------------------------------------------
function PZMWC_Callback(hObject, eventdata, handles)
% hObject    handle to PZMWC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%====================== Values from Radio Button ======================
tf_pushbutton = get (handles.tf_radiob,'Value')
ss_pushbutton = get(handles.ss_radiob,'Value') 

%================= Error If both Options Selected ====================
if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Max')
    errordlg('Select One Option from "State Space" or "Transfer Function"')
end

%================= Error If both were not Selected ===================
if ss_pushbutton == get(handles.ss_radiob,'Min') && tf_pushbutton == get(handles.tf_radiob,'Min')
    errordlg('First Enter either "State Space" or "Transfer Function"')
end

%================= Implementing Transfer Function ====================
if tf_pushbutton == get(handles.tf_radiob,'Max') && ss_pushbutton == get(handles.ss_radiob,'Min')
    num= get (handles.num_edit,'string')
    num_dou = str2num(num)
    
    den= get (handles.den_edit,'string')
    den_dou = str2num(den)
    
    %================= Error If Either Num or Den is empty ==============
    if isempty(num_dou) || isempty(den_dou)
    errordlg('Please Enter "Transfer Function"')
    end
    
%     global
    sys_tf = tf(num_dou,den_dou)
    figure
    pzmap(sys_tf),title('Pole Zero Map Without Controller')
end

%================= Implementing State Space Model ====================

if ss_pushbutton == get(handles.ss_radiob,'Max') && tf_pushbutton == get(handles.tf_radiob,'Min')
    clc
    
    a= get(handles.A_edit,'String')
    a_dou = str2num(a)
    
    b= get(handles.B_edit,'String')
    b_dou = str2num(b)
    
    c= get(handles.C_edit,'String')
    c_dou = str2num(c)
    
    d= get(handles.D_edit,'String')
    d_dou = str2num(d)
    
    %================= Error If Either A,B,C or D is empty ==============
    
    if isempty(a_dou) || isempty(b_dou) || isempty(c_dou) || isempty(d_dou)
    errordlg('Please enter all A,B,C and D')
    end
    
%     global 
    sys_ss = ss(a_dou,b_dou,c_dou,d_dou)
    figure
    pzmap(sys_ss),title('Pole Zero Map Without Controller')
end
%=====================================================================

% --------------------------------------------------------------------
function PZMC_Callback(hObject, eventdata, handles)
% hObject    handle to PZMC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clc, 
value = get(handles.PPC_popupmenu,'Value')

if value == 1
     global sys_fd
     figure,pzmap(sys_fd),title('Pole-Zero Map With State feedback Controller')
end

clc, 
value = get(handles.PPC_popupmenu,'Value')

if value == 2
     global sys_fd_rp
     figure,pzmap(sys_fd_rp),title('Pole-Zero Map With State feedback Controller')
end



function BA_edit_Callback(hObject, eventdata, handles)
% hObject    handle to A_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A_edit as text
%        str2double(get(hObject,'String')) returns contents of A_edit as a double


% --- Executes during object creation, after setting all properties.
function BA_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


