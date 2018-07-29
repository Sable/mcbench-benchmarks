function varargout = VScope(varargin)
% VSCOPE M-file for VScope.fig
%      VSCOPE, by itself, creates a new VSCOPE or raises the existing
%      singleton*.
%
%      H = VSCOPE returns the handle to a new VSCOPE or the handle to
%      the existing singleton*.
%
%      VSCOPE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VSCOPE.M with the given input arguments.
%
%      VSCOPE('Property','Value',...) creates a new VSCOPE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VScope_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VScope_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VScope

% Last Modified by GUIDE v2.5 15-Jan-2009 11:33:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VScope_OpeningFcn, ...
                   'gui_OutputFcn',  @VScope_OutputFcn, ...
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


% --- Executes just before VScope is made visible.
function VScope_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VScope (see VARARGIN)

% Choose default command line output for VScope
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VScope wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VScope_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%pushbutton3_Callback(handles.pushbutton3,[],handles)

% set(handles.text2,'string','BISMILLAH AR REHMAN AR RAHIM')
% pause(2)
% set(handles.text2,'string','ALLAH AKBAR')
% pause(2)
% set(handles.text2,'string','Welcome to Virtual Oscilloscope!!')
% pause(2)
% 
% s=serial('com1');
% fopen(s);
% fprintf(s,'*idn?');
% out=fscanf(s);
% out=strcat('Oscilloscope ID=  ',out)
% fclose(s);
% set(handles.text2,out)
% %fclose(s);
% pause(3)
% set(handles.text2,'string',' ')

%---------------------------------------------------------
set(handles.popupmenu11,'enable','off')
set(handles.popupmenu6,'enable','off')
set(handles.popupmenu5,'enable','off')
set(handles.popupmenu4,'enable','off')
set(handles.popupmenu9,'enable','off')
set(handles.popupmenu10,'enable','off')
set(handles.togglebutton2,'enable','off')
set(handles.pushbutton6,'enable','off')
set(handles.popupmenu3,'enable','off')
set(handles.popupmenu2,'enable','off')

set(handles.radiobutton4,'enable','on')
set(handles.radiobutton5,'enable','on')
set(handles.radiobutton6,'enable','on')
set(handles.radiobutton7,'enable','on')
set(handles.slider1,'enable','on')
set(handles.slider2,'enable','on')

% % % % % function latch2(off)
% % % % % set(off,'value',0)
% % % % % 
% % % % % % --- Executes on button press in radiobutton8.
% % % % % function radiobutton8_Callback(hObject, eventdata, handles)
% % % % % % hObject    handle to radiobutton8 (see GCBO)
% % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % 
% % % % % % Hint: get(hObject,'Value') returns toggle state of radiobutton8
% % % % % 
% % % % % off = [handles.radiobutton9]
% % % % % latch2(off)
% % % % % 
% % % % % set(handles.popupmenu11,'enable','off')
% % % % % set(handles.popupmenu6,'enable','off')
% % % % % set(handles.popupmenu5,'enable','off')
% % % % % set(handles.popupmenu4,'enable','off')
% % % % % set(handles.popupmenu9,'enable','off')
% % % % % set(handles.popupmenu10,'enable','off')
% % % % % set(handles.togglebutton2,'enable','off')
% % % % % set(handles.pushbutton6,'enable','off')
% % % % % set(handles.popupmenu3,'enable','off')
% % % % % set(handles.popupmenu2,'enable','off')
% % % % % 
% % % % % set(handles.radiobutton4,'enable','on')
% % % % % set(handles.radiobutton5,'enable','on')
% % % % % set(handles.radiobutton6,'enable','on')
% % % % % set(handles.radiobutton7,'enable','on')
% % % % % set(handles.slider1,'enable','on')
% % % % % set(handles.slider2,'enable','on')
% % % % % 
% % % % % 
% % % % % 
% % % % % % --- Executes on button press in radiobutton9.
% % % % % function radiobutton9_Callback(hObject, eventdata, handles)
% % % % % % hObject    handle to radiobutton9 (see GCBO)
% % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % 
% % % % % % Hint: get(hObject,'Value') returns toggle state of radiobutton9
% % % % % 
% % % % % off = [handles.radiobutton8]
% % % % % latch2(off)
% % % % % 
% % % % % set(handles.radiobutton4,'enable','off')
% % % % % set(handles.radiobutton5,'enable','off')
% % % % % set(handles.radiobutton6,'enable','off')
% % % % % set(handles.radiobutton7,'enable','off')
% % % % % set(handles.slider1,'enable','off')
% % % % % set(handles.slider2,'enable','off')
% % % % % 
% % % % % set(handles.popupmenu11,'enable','on')
% % % % % set(handles.popupmenu6,'enable','on')
% % % % % set(handles.popupmenu5,'enable','on')
% % % % % set(handles.popupmenu4,'enable','on')
% % % % % set(handles.popupmenu9,'enable','on')
% % % % % set(handles.popupmenu10,'enable','on')
% % % % % set(handles.togglebutton2,'enable','on')
% % % % % set(handles.pushbutton6,'enable','on')
% % % % % set(handles.popupmenu3,'enable','on')
% % % % % set(handles.popupmenu2,'enable','on')














%----------------------------------------------------------------------
function latch(off)
set(off,'Value',0)



% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

freq=get(handles.slider1,'value');
set(handles.text3,'string',freq);

save freq freq

% Latching On CHECK BOXES
%*************************************************************************

% if (get(handles.checkbox1,'value')) == get(handles.checkbox1,'Max')
%    %set(handles.checkbox2,'value',0)
%    %set(handles.checkbox3,'value',0)
%   t=-10:0.1:10;
%   y=sin(t*val1)
%   axis(handles.axes1)
%   plot(t,y)
%   %hold on
% elseif (get(handles.checkbox2,'value')) == get(handles.checkbox2,'Max')
%     %set(handles.checkbox1,'value',0)
%     %set(handles.checkbox3,'value',0)
%    t1=-10:0.1:10;
%    y1=cos(t1*val1)
%    axis(handles.axes1)
%    plot(t1,y1,'r')
%    %hold on
% elseif (get(handles.checkbox3,'value')) == get(handles.checkbox3,'Max')
%     %set(handles.checkbox1,'value',0)
%     %set(handles.checkbox2,'value',0)
%    t2=-10:0.1:10;
%    y2=tan(t2*val1)
%    axis(handles.axes1)
%    plot(t2,y2,'k')
%    %hold on
% else axis(handles.axes1)
%    cla
% end
%**************************************************************************

% Latching On Radio Buttons SLIDER 1
%**************************************************************************
if (get(handles.radiobutton4,'value')) == get(handles.radiobutton4,'Max')
  
   a=get(handles.slider2,'value');
   
   
   t=-8:0.001:8;
   y=a*sin(2*pi*freq*t);
   
   axis(handles.axes1);
   plot(t,y);
   axis([-8 8 -10 10]);
elseif (get(handles.radiobutton5,'value')) == get(handles.radiobutton5,'Max')
   
   a=get(handles.slider2,'value');
     
   
   t1=-8:0.001:8;
   y1=a*cos(2*pi*freq*t1);
   %axis([-2 2 -5 5])
   axis(handles.axes1);
   plot(t1,y1,'r');
   axis([-8 8 -10 10]);
elseif (get(handles.radiobutton6,'value')) == get(handles.radiobutton6,'Max')
   
   a=get(handles.slider2,'value');
   
   
   t2=-8:0.001:8;
   y2=a*tan(2*pi*freq*t2);
   %axis([-2 2 -5 5])
   axis(handles.axes1);
   plot(t2,y2,'k');
   axis([-8 8 -10 10]);
elseif (get(handles.radiobutton7,'value')) == get(handles.radiobutton7,'Max')
    
    a=get(handles.slider2,'value');
    t3=-8:0.001:8;
    y3=a*square(2*pi*freq*t3);
    axis(handles.axes1);
    plot(t3,y3,'m');
    axis([-8 8 -10 10]);
else axis(handles.axes1)
    cla
end

 
%**************************************************************************

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%Latching On Radio Buttons Only* SLIDER 2
%**************************************************************************
a=get(handles.slider2,'value');
set(handles.text4,'string',a);

save a a

if (get(handles.radiobutton4,'value')) == get(handles.radiobutton4,'Max')
  
   freq=get(handles.slider1,'value');
   
   
   t=-8:0.001:8;
   y=a*sin(2*pi*freq*t);
   %axis([-2 2 -5 5])
   axis(handles.axes1);
   plot(t,y);
   axis([-8 8 -10 10]);
   
elseif (get(handles.radiobutton5,'value')) == get(handles.radiobutton5,'Max')
   
   freq=get(handles.slider1,'value');
     
   
   t1=-8:0.001:8;
   y1=a*cos(2*pi*freq*t1);
   %axis([-2 2 -5 5])
   axis(handles.axes1);
   plot(t1,y1,'r');
   axis([-8 8 -10 10]);
elseif (get(handles.radiobutton6,'value')) == get(handles.radiobutton6,'Max')
   
   freq=get(handles.slider1,'value');
   
   
   t2=-8:0.001:8;
   y2=a*tan(2*pi*freq*t2);
   %axis([-2 2 -5 5])
   axis(handles.axes1);
   plot(t2,y2,'k');
   axis([-8 8 -10 10]);
elseif (get(handles.radiobutton7,'value')) == get(handles.radiobutton7,'Max')
    freq=get(handles.slider1,'value');
    
    t3=-8:0.001:8;
    y3=a*square(2*pi*freq*t3);
    axis(handles.axes1);
    plot(t3,y3,'m');
    axis([-8 8 -10 10]);
else axis(handles.axes1)
    cla
end


%**************************************************************************


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end











%Latching On Check Boxes
%**************************************************************************

% % --- Executes on button press in checkbox1.
% function checkbox1_Callback(h, eventdata, handles, varargin)
% % hObject    handle to checkbox1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hint: get(hObject,'Value') returns toggle state of checkbox1
% 
% %function checkbox1_Callback(h,eventdata,handles,varargin)
% if (get(handles.checkbox1,'value')) == get(handles.checkbox1,'Max')
%    t=-10:0.1:10;
%    y=sin(t*val1)
%    axis(handles.axes1)
%    plot(t,y)
% else axis(handles.axes1)
%      cla
%  end




% --- Executes on button press in checkbox2.
% function checkbox2_Callback(h, eventdata, handles, varargin)
% % hObject    handle to checkbox2 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hint: get(hObject,'Value') returns toggle state of checkbox2
% if (get(handles.checkbox2,'value')) == get(handles.checkbox2,'Max')
%     t1=-10:0.1:10;
%     y1=cos(t1*val1)
%     axis(handles.axes1)
%     plot(t1,y1,'r')
% else axis(handles.axes1)
%     cla
% end
% 
% 
% % --- Executes on button press in checkbox3.
% function checkbox3_Callback(h, eventdata, handles, varargin)
% % hObject    handle to checkbox3 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hint: get(hObject,'Value') returns toggle state of checkbox3
% 
% if (get(handles.checkbox3,'value')) == get(handles.checkbox3,'Max')
%     t2=-10:0.1:10;
%     y2=tan(t2*val1)
%     axis(handles.axes1)
%     plot(t2,y2,'k')
% else axis(handles.axes1)
%     cla
% end


%**************************************************************************
    







%Latching On Radio Buttons
%**************************************************************************

% --- Executes on button press in radiobutton4.
function varargout = radiobutton4_Callback(h, eventdata, handles, varargin)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4

off = [handles.radiobutton5,handles.radiobutton6,handles.radiobutton7];
latch(off)
if (get(handles.radiobutton4,'value')) == get(handles.radiobutton4,'Max')
    idd='1';
    
   freq=get(handles.slider1,'value');
   
   a=get(handles.slider2,'value');
   
   
   t=-8:0.001:8;
   y=a*sin(2*pi*freq*t);
   
   axis(handles.axes1);   
   plot(t,y);
   %grid minor;
   axis([-8 8 -10 10]);
   
% % %    save valuerb4 a freq t y
   
else axis(handles.axes1)
     cla
     idd='0';
end
 
save idd idd;

% --- Executes on button press in radiobutton5.
function varargout = radiobutton5_Callback(h, eventdata, handles, varargin)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5
off = [handles.radiobutton4,handles.radiobutton6,handles.radiobutton7];
latch(off);
if (get(handles.radiobutton5,'value')) == get(handles.radiobutton5,'Max')
    idd='2';
   freq=get(handles.slider1,'value');
   
   a=get(handles.slider2,'value');
    
   
   t1=-8:0.001:8;
   y1=a*cos(2*pi*freq*t1);
   
   axis(handles.axes1);
   plot(t1,y1,'r');
   %grid minor;
   axis([-8 8 -10 10]);
   
% % %    save valuerb5 a freq t1 y1
   
else axis(handles.axes1)
     cla
     idd='0';
 end
save idd idd;
% --- Executes on button press in radiobutton6.
function varargout = radiobutton6_Callback(h, eventdata, handles, varargin)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6
off = [handles.radiobutton4,handles.radiobutton5,handles.radiobutton7];
latch(off);
if (get(handles.radiobutton6,'value')) == get(handles.radiobutton6,'Max')
    idd='3';
   freq=get(handles.slider1,'value');
   
   a=get(handles.slider2,'value');
  
   
   t2=-8:0.001:8;
   y2=a*tan(2*pi*freq*t2);
   
   axis(handles.axes1);
   plot(t2,y2,'k');
   %grid minor;
   axis([-8 8 -10 10]);
% % %    save valuerb6 a freq t2 y2
   
else axis(handles.axes1)
     cla
     idd='0';
end

save idd idd;
 %*************************************************************************


% --- Executes on button press in radiobutton7.
function varargout = radiobutton7_Callback(h, eventdata, handles, varargin)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7

off = [handles.radiobutton4,handles.radiobutton5,handles.radiobutton6];
latch(off);
if (get(handles.radiobutton7,'value')) == get(handles.radiobutton7,'Max')
    idd='4';
    freq=get(handles.slider1,'value');
    a=get(handles.slider2,'value');
    t3=-8:0.001:8;
    y3=a*square(2*pi*freq*t3);
    axis(handles.axes1);
    plot(t3,y3,'m');
    %grid minor;
    axis([-8 8 -10 10]);
% % %     save valuerb7 a freq t3 y3
    
else axis(handles.axes1)
    cla
    idd='0'
end

save idd idd;




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sure



% --- Executes on button press in togglebutton2.
function varargout = togglebutton2_Callback(h, eventdata, handles, varargin)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2


button_state=get(handles.togglebutton2,'value');

if button_state == get(handles.togglebutton2,'Max')
    s=serial('com1');
    s.inputbuffersize=16384;
    s.outputbuffersize=16384;
    handles.data=s;
    fopen(s);
    x1=s.status;
    x1=strcat('COM1= ',x1);
    set(handles.text2,'string', x1);
    pause(1);
    set(handles.text2,'string',' ');
    guidata(handles.togglebutton2,handles);
elseif button_state == get(handles.togglebutton2,'Min')
    s=handles.data;
    fclose(s);
    x1=s.status;
    x1=strcat('COM1=  ', x1);
    set(handles.text2,'string', x1);
    pause(1);
    set(handles.text2,'string',' ');
    clear
end
    


% % % % % % % % % % --- Executes on button press in pushbutton3.
% % % % % % % % % function varargout = pushbutton3_Callback(h, eventdata, handles, varargin)
% % % % % % % % % % hObject    handle to pushbutton3 (see GCBO)
% % % % % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % % % % 
% % % % % % % % % s=serial('com1');
% % % % % % % % % nxg=s.status;
% % % % % % % % % if nxg == 'open'
% % % % % % % % %     set(handles.text2,'string','COM1 already open')
% % % % % % % % % else
% % % % % % % % %     s.inputbuffersize=16384;
% % % % % % % % %     s.outputbuffersize=16384;
% % % % % % % % %     handles.data=s;
% % % % % % % % %     fopen(s);
% % % % % % % % %     x1=s.status;
% % % % % % % % %     x1=strcat('COM1= ',x1);
% % % % % % % % %     set(handles.text2,'string', x1)
% % % % % % % % %     pause(1)
% % % % % % % % %     set(handles.text2,'string',' ')
% % % % % % % % %     guidata(handles.pushbutton3,handles)
% % % % % % % % % end
% % % % % % % % % 
% % % % % % % % %    
% % % % % % % % %     
% % % % % % % % % 
% % % % % % % % % % --- Executes on button press in pushbutton4.
% % % % % % % % % function varargout = pushbutton4_Callback(h, eventdata, handles, varargin)
% % % % % % % % % % hObject    handle to pushbutton4 (see GCBO)
% % % % % % % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % % % % % % handles    structure with handles and user data (see GUIDATA)
% % % % % % % % % 
% % % % % % % % % % % s=serial('com1');
% % % % % % % % % % % fopen(s);
% % % % % % % % % % % fclose(s)
% % % % % % % % % % % x1=s.status;
% % % % % % % % % % % x1=strcat('COM1=  ', x1)
% % % % % % % % % % % set(handles.text2,'string', x1)
% % % % % % % % % % % pause(5)
% % % % % % % % % % % set(handles.text2,'string',' ')
% % % % % % % % % 
% % % % % % % % % 
% % % % % % % % % s=handles.data;
% % % % % % % % % fclose(s);
% % % % % % % % % x1=s.status;
% % % % % % % % % x1=strcat('COM1=  ', x1)
% % % % % % % % % set(handles.text2,'string', x1)
% % % % % % % % % pause(1)
% % % % % % % % % set(handles.text2,'string',' ')
% % % % % % % % % clear





% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sure2




% --- Executes on button press in pushbutton6.
function varargout = pushbutton6_Callback(h, eventdata, handles, varargin)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA

s=handles.data;
fclose(s);
nn=s.status;
nn=strcat('COM1= ',nn)
set(handles.text2,'string',nn)
clear

waveformm


% --- Executes on selection change in popupmenu2.
function varargout = popupmenu2_Callback(h, eventdata, handles, varargin)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
s=handles.data;
wadt=get(handles.popupmenu2,'value');
switch wadt
    case 1
        set(handles.text2,'string',' ');
    case 2        
        fprintf(s,':acquire1:memory?');
        out1=fscanf(s);        
        set(handles.text2,'string',out1);

    case 3       
        fprintf(s,':acquire1:point');
        out2=fscanf(s);
%       out2=hex2dec(out2);
        out2=num2str(out2);
        set(handles.text2,'string',out2);
end


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3

s=handles.data;
otcm=get(handles.popupmenu3,'value');
switch otcm
    case 1
        set(handles.text2,'string',' ');
    case 2        
        fprintf(s,'*idn?');
        out1=fscanf(s);        
        set(handles.text2,'string',out1);
    case 3        
        fprintf(s,'*lrn?');
        out2=fscanf(s);        
        set(handles.text2,'string',out2);
    case 4        
        fprintf(s,'*wai?');
        out3=fscanf(s);       
        set(handles.text2,'string',out3);
end

      
% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4

s=handles.data; 
br=get(handles.popupmenu4,'value');
switch br
    case 1        
        s.baudrate=0;
        br1=s.baudrate;
        br1=num2str(br1);
        br1=strcat('BaudRate= ',br1);
        set(handles.text2,'string',br1);
    case 2        
        s.baudrate=2400;
        br2=s.baudrate;
        br2=num2str(br2);
        br2=strcat('BaudRate= ',br2);
        set(handles.text2,'string',br2);
        
    case 3        
        s.baudrate=4800;
        br3=s.baudrate;
        br3=num2str(br3);
        br3=strcat('BaudRate= ',br3);
        set(handles.text2,'string',br3);
    case 4        
        s.baudrate=9600;
        br4=s.baudrate;
        br4=num2str(br4);
        br4=strcat('BaudRate= ',br4);
        set(handles.text2,'string',br4);
    case 5        
        s.baudrate=19200;
        br5=s.baudrate;
        br5=num2str(br5);
        br5=strcat('BaudRate= ',br5);
        set(handles.text2,'string',br5);
    case 6       
        s.baudrate=38400;
        br6=s.baudrate;
        br6=num2str(br6);
        br6=strcat('BaudRate= ',br6);
        set(handles.text2,'string',br6);
end


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5

s=handles.data;
sb=get(handles.popupmenu5,'value');
switch sb
    case 1       
        s.stopbit=1;
        sb1=s.stopbit;
        sb1=num2str(sb1);
        sb1=strcat('StopBit= ',sb1);        
        set(handles.text2,'string',sb1);
    case 2       
        s.stopbit=2;
        sb2=s.stopbit;
        sb2=num2str(sb2);
        sb2=strcat('StopBit= ',sb2);
        set(handles.text2,'string',sb2);
end




% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6

s=handles.data; 
par=get(handles.popupmenu6,'value');
switch par
    case 1        
        s.parity='none';
        sta1=s.parity;
        sta1=strcat('Parity= ',sta1);
        set(handles.text2,'string',sta1);
    case 2       
        s.parity='even';
        sta2=s.parity;
        sta2=strcat('Parity= ',sta2);
        set(handles.text2,'string',sta2);
    case 3        
        s.parity='odd';
        sta3=s.parity;
        sta3=strcat('Parity= ',sta3);
        set(handles.text2,'string',sta3);
end



% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu9.
function popupmenu9_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu9

s=handles.data;
wam=get(handles.popupmenu9,'value');
switch wam
    case 1        
        fprintf(s,':acquire:mode0');
        fprintf(s,':acquire:mode?');
        out1=fscanf(s);
        out1=strcat('WaveformAcquisitionMode= ',out1);
        set(handles.text2,'string',out1);
        
    case 2        
        fprintf(s,':acquire:mode1');
        fprintf(s,':acquire:mode?');
        out2=fscanf(s);
        out2=strcat('WaveformAcquisitionMode= ',out2);
        set(handles.text2,'string',out2);
        
    case 3        
        fprintf(s,':acquire:mode2');
        fprintf(s,':acquire:mode?');
        out3=fscanf(s);
        out3=strcat('WaveformAcquisitionMode= ',out3);
        set(handles.text2,'string',out3);
end


% --- Executes during object creation, after setting all properties.
function popupmenu9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu10.
function popupmenu10_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu10

s=handles.data; 
rl=get(handles.popupmenu10,'value');
switch rl
    case 1        
        fprintf(s,':acquire:lenght0');
        fprintf(s,':acquire:length?');
        out1=fscanf(s);
        out1=strcat('RecordLength= ',out1);
        set(handles.text2,'string',out1);
        
    case 2       
        fprintf(s,':acquire:lenght1');
        fprintf(s,':acquire:length?');
        out2=fscanf(s);
        out2=strcat('RecordLength= ',out2);
        set(handles.text2,'string',out2);
        
    case 3       
        fprintf(s,':acquire:lenght2');
        fprintf(s,':acquire:length?');
        out3=fscanf(s);
        out3=strcat('RecordLength= ',out3);
        set(handles.text2,'string',out3);
       
    case 4       
        fprintf(s,':acquire:lenght3');
        fprintf(s,':acquire:length?');
        out4=fscanf(s);
        out4=strcat('RecordLength= ',out4);
        set(handles.text2,'string',out4);
        
    case 5        
        fprintf(s,':acquire:lenght4');
        fprintf(s,':acquire:length?');
        out5=fscanf(s);
        out5=strcat('RecordLength= ',out5);
        set(handles.text2,'string',out5);
        
    case 6        
        fprintf(s,':acquire:lenght5');
        fprintf(s,':acquire:length?');
        out6=fscanf(s);
        out6=strcat('RecordLength= ',out6);
        set(handles.text2,'string',out6);
        
    case 7       
        fprintf(s,':acquire:lenght6');
        fprintf(s,':acquire:length?');
        out7=fscanf(s);
        out7=strcat('RecordLength= ',out7);
        set(handles.text2,'string',out7);
        
    case 8       
        fprintf(s,':acquire:lenght7');
        fprintf(s,':acquire:length?');
        out8=fscanf(s);
        out8=strcat('RecordLength= ',out8);
        set(handles.text2,'string',out8);
end


% --- Executes during object creation, after setting all properties.
function popupmenu10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu11.
function popupmenu11_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu11

s=handles.data;
an=get(handles.popupmenu11,'value');
switch an
    case 1        
        fprintf(s,':acquire:average1');
        fprintf(s,':acquire:average?');
        out1=fscanf(s);
        out1=strcat('AverageNumber= ',out1);
        set(handles.text2,'string',out1);
        
    case 2        
        fprintf(s,':acquire:average2');
        fprintf(s,':acquire:average?');
        out2=fscanf(s);
        out2=strcat('AverageNumber= ',out2);
        set(handles.text2,'string',out2);
       
    case 3        
        fprintf(s,':acquire:average3');
        fprintf(s,':acquire:average?');
        out3=fscanf(s);
        out3=strcat('AverageNumber= ',out3);
        set(handles.text2,'string',out3);
       
    case 4        
        fprintf(s,':acquire:average4');
        fprintf(s,':acquire:average?');
        out4=fscanf(s);
        out4=strcat('AverageNumber= ',out4);
        set(handles.text2,'string',out4);
        
    case 5       
        fprintf(s,':acquire:average5');
        fprintf(s,':acquire:average?');
        out5=fscanf(s);
        out5=strcat('AverageNumber= ',out5);
        set(handles.text2,'string',out5);
        
    case 6        
        fprintf(s,':acquire:average6');
        fprintf(s,':acquire:average?');
        out6=fscanf(s);
        out6=strcat('AverageNumber= ',out6);
        set(handles.text2,'string',out6);
        
    case 7       
        fprintf(s,':acquire:average7');
        fprintf(s,':acquire:average?');
        out7=fscanf(s);
        out7=strcat('AverageNumber= ',out7);
        set(handles.text2,'string',out7);
        
    case 8        
        fprintf(s,':acquire:average8');
        fprintf(s,':acquire:average?');
        out8=fscanf(s);
        out8=strcat('AverageNumber= ',out8);
        set(handles.text2,'string',out8);
        
end


% --- Executes during object creation, after setting all properties.
function popupmenu11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


sure2


% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

open heelp.txt

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function Untitled_15_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_16_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_17_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_18_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_19_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_20_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_13_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_14_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_7_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[F] = uigetfile('*.fig','Select any .fig file');
open(F);

% --------------------------------------------------------------------
function Untitled_11_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sure


% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_9_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_12_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_8_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_21_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;
fprintf(s,':acquire:average1')
fprintf(s,':acquire:average?')
out1=fscanf(s);
out1=strcat('AverageNumber= ',out1)
set(handles.text2,'string',out1)


% --------------------------------------------------------------------
function Untitled_22_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;
fprintf(s,':acquire:average2')
fprintf(s,':acquire:average?')
out2=fscanf(s);
out2=strcat('AverageNumber= ',out2)
set(handles.text2,'string',out2)



% --------------------------------------------------------------------
function Untitled_23_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;
fprintf(s,':acquire:average3')
fprintf(s,':acquire:average?')
out3=fscanf(s);
out3=strcat('AverageNumber= ',out3)
set(handles.text2,'string',out3)


% --------------------------------------------------------------------
function Untitled_24_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;
fprintf(s,':acquire:average4')
fprintf(s,':acquire:average?')
out4=fscanf(s);
out4=strcat('AverageNumber= ',out4)
set(handles.text2,'string',out4)


% --------------------------------------------------------------------
function Untitled_25_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;
fprintf(s,':acquire:average5')
fprintf(s,':acquire:average?')
out5=fscanf(s);
out5=strcat('AverageNumber= ',out5)
set(handles.text2,'string',out5)

% --------------------------------------------------------------------
function Untitled_26_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;
fprintf(s,':acquire:average6')
fprintf(s,':acquire:average?')
out6=fscanf(s);
out6=strcat('AverageNumber= ',out6)
set(handles.text2,'string',out6)

% --------------------------------------------------------------------
function Untitled_27_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;
fprintf(s,':acquire:average7')
fprintf(s,':acquire:average?')
out7=fscanf(s);
out7=strcat('AverageNumber= ',out7)
set(handles.text2,'string',out7)

% --------------------------------------------------------------------
function Untitled_28_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;
fprintf(s,':acquire:average8')
fprintf(s,':acquire:average?')
out8=fscanf(s);
out8=strcat('AverageNumber= ',out8)
set(handles.text2,'string',out8)

% --------------------------------------------------------------------
function Untitled_29_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data; 
s.parity='none';
sta1=s.parity;
sta1=strcat('Parity= ',sta1)
set(handles.text2,'string',sta1)        


% --------------------------------------------------------------------
function Untitled_30_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;
s.parity='even';
sta2=s.parity;
sta2=strcat('Parity= ',sta2)
set(handles.text2,'string',sta2)
% --------------------------------------------------------------------
function Untitled_31_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;
s.parity='odd';
sta3=s.parity;
sta3=strcat('Parity= ',sta3)
set(handles.text2,'string',sta3)

% --------------------------------------------------------------------
function Untitled_32_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;
s.stopbit=1;
sb1=s.stopbit;
sb1=num2str(sb1);
sb1=strcat('StopBit= ',sb1)        
set(handles.text2,'string',sb1)


% --------------------------------------------------------------------
function Untitled_33_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;
s.stopbit=2;
sb2=s.stopbit;
sb2=num2str(sb2);
sb2=strcat('StopBit= ',sb2)
set(handles.text2,'string',sb2)


% --------------------------------------------------------------------
function Untitled_34_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;
s.baudrate=0;
        br1=s.baudrate;
        br1=num2str(br1);
        br1=strcat('BaudRate= ',br1)
        set(handles.text2,'string',br1)


% --------------------------------------------------------------------
function Untitled_35_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s=handles.data;
s.baudrate=2400;
        br2=s.baudrate;
        br2=num2str(br2);
        br2=strcat('BaudRate= ',br2)
        set(handles.text2,'string',br2)

% --------------------------------------------------------------------
function Untitled_36_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s=handles.data;
s.baudrate=4800;
        br3=s.baudrate;
        br3=num2str(br3);
        br3=strcat('BaudRate= ',br3)
        set(handles.text2,'string',br3)
% --------------------------------------------------------------------
function Untitled_37_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s=handles.data;
s.baudrate=9600;
        br4=s.baudrate;
        br4=num2str(br4);
        br4=strcat('BaudRate= ',br4)
        set(handles.text2,'string',br4)
    
    

% --------------------------------------------------------------------
function Untitled_38_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;       
        s.baudrate=19200;
        br5=s.baudrate;
        br5=num2str(br5);
        br5=strcat('BaudRate= ',br5)
        set(handles.text2,'string',br5)
% --------------------------------------------------------------------
function Untitled_39_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;      
        s.baudrate=38400;
        br6=s.baudrate;
        br6=num2str(br6);
        br6=strcat('BaudRate= ',br6)
        set(handles.text2,'string',br6)
% --------------------------------------------------------------------
function Untitled_40_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s=handles.data;
fprintf(s,':acquire:mode0')
        fprintf(s,':acquire:mode?')
        out1=fscanf(s);
        out1=strcat('WaveformAcquisitionMode= ',out1)
        set(handles.text2,'string',out1)
        
    
        
    
% --------------------------------------------------------------------
function Untitled_41_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;        
        fprintf(s,':acquire:mode1')
        fprintf(s,':acquire:mode?')
        out2=fscanf(s);
        out2=strcat('WaveformAcquisitionMode= ',out2)
        set(handles.text2,'string',out2)
% --------------------------------------------------------------------
function Untitled_42_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;        
        fprintf(s,':acquire:mode2')
        fprintf(s,':acquire:mode?')
        out3=fscanf(s);
        out3=strcat('WaveformAcquisitionMode= ',out3)
        set(handles.text2,'string',out3)
% --------------------------------------------------------------------
function Untitled_43_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf(s,':acquire:lenght0')
        fprintf(s,':acquire:length?')
        out1=fscanf(s);
        out1=strcat('RecordLength= ',out1)
        set(handles.text2,'string',out1)
        
% --------------------------------------------------------------------
function Untitled_44_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;       
        fprintf(s,':acquire:lenght1')
        fprintf(s,':acquire:length?')
        out2=fscanf(s);
        out2=strcat('RecordLength= ',out2)
        set(handles.text2,'string',out2)
% --------------------------------------------------------------------
function Untitled_45_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;       
        fprintf(s,':acquire:lenght2')
        fprintf(s,':acquire:length?')
        out3=fscanf(s);
        out3=strcat('RecordLength= ',out3)
        set(handles.text2,'string',out3)
% --------------------------------------------------------------------
function Untitled_46_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;      
        fprintf(s,':acquire:lenght3')
        fprintf(s,':acquire:length?')
        out4=fscanf(s);
        out4=strcat('RecordLength= ',out4)
        set(handles.text2,'string',out4)
% --------------------------------------------------------------------
function Untitled_47_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;        
        fprintf(s,':acquire:lenght4')
        fprintf(s,':acquire:length?')
        out5=fscanf(s);
        out5=strcat('RecordLength= ',out5)
        set(handles.text2,'string',out5)
% --------------------------------------------------------------------
function Untitled_48_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;       
        fprintf(s,':acquire:lenght5')
        fprintf(s,':acquire:length?')
        out6=fscanf(s);
        out6=strcat('RecordLength= ',out6)
        set(handles.text2,'string',out6)
% --------------------------------------------------------------------
function Untitled_49_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;       
        fprintf(s,':acquire:lenght6')
        fprintf(s,':acquire:length?')
        out7=fscanf(s);
        out7=strcat('RecordLength= ',out7)
        set(handles.text2,'string',out7)
% --------------------------------------------------------------------
function Untitled_50_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;       
        fprintf(s,':acquire:lenght7')
        fprintf(s,':acquire:length?')
        out8=fscanf(s);
        out8=strcat('RecordLength= ',out8)
        set(handles.text2,'string',out8)

% --------------------------------------------------------------------
function Untitled_53_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;
set(handles.text2,'string',' ')

% --------------------------------------------------------------------
function Untitled_54_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;       
        fprintf(s,':acquire1:memory?')
        out1=fscanf(s);        
        set(handles.text2,'string',out1)
% --------------------------------------------------------------------
function Untitled_55_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;       
        fprintf(s,':acquire1:point')
        out2=fscanf(s);
%       out2=hex2dec(out2);
        out2=num2str(out2);
        set(handles.text2,'string',out2)
% --------------------------------------------------------------------
function Untitled_57_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s=handles.data;
fprintf(s,'*idn?')
        out1=fscanf(s);        
        set(handles.text2,'string',out1)
   
   
% --------------------------------------------------------------------
function Untitled_58_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;        
        fprintf(s,'*lrn?')
        out2=fscanf(s);        
        set(handles.text2,'string',out2)
% --------------------------------------------------------------------
function Untitled_59_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;        
        fprintf(s,'*wai?')
        out3=fscanf(s);       
        set(handles.text2,'string',out3)
% --------------------------------------------------------------------
function Untitled_51_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.data;
fclose(s);
nn=s.status;
nn=strcat('COM1= ',nn)
set(handles.text2,'string',nn)
clear

waveformm

% --------------------------------------------------------------------
function Untitled_52_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_56_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_61_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_62_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_63_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_64_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_60_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_65_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_67_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.popupmenu11,'enable','off');
set(handles.popupmenu6,'enable','off');
set(handles.popupmenu5,'enable','off');
set(handles.popupmenu4,'enable','off');
set(handles.popupmenu9,'enable','off');
set(handles.popupmenu10,'enable','off');
set(handles.togglebutton2,'enable','off');
set(handles.pushbutton6,'enable','off');
set(handles.popupmenu3,'enable','off');
set(handles.popupmenu2,'enable','off');

set(handles.radiobutton4,'enable','on');
set(handles.radiobutton5,'enable','on');
set(handles.radiobutton6,'enable','on');
set(handles.radiobutton7,'enable','on');
set(handles.slider1,'enable','on');
set(handles.slider2,'enable','on');


% --------------------------------------------------------------------
function Untitled_68_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_68 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.radiobutton4,'enable','off');
set(handles.radiobutton5,'enable','off');
set(handles.radiobutton6,'enable','off');
set(handles.radiobutton7,'enable','off');
set(handles.slider1,'enable','off');
set(handles.slider2,'enable','off');

set(handles.popupmenu11,'enable','on');
set(handles.popupmenu6,'enable','on');
set(handles.popupmenu5,'enable','on');
set(handles.popupmenu4,'enable','on');
set(handles.popupmenu9,'enable','on');
set(handles.popupmenu10,'enable','on');
set(handles.togglebutton2,'enable','on');
set(handles.pushbutton6,'enable','on');
set(handles.popupmenu3,'enable','on');
set(handles.popupmenu2,'enable','on');

% --------------------------------------------------------------------
function Untitled_66_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_70_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_70 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function Untitled_72_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_72 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load idd;
load freq;
load a;

if idd == '0'
    set(handles.text2,'string','No Graph To Save');
    pause(2);
    set(handles.text2,'string',' ');
else
    set(handles.text2,'string','Graph Saved');
    pause(2);
    set(handles.text2,'string',' ');
end

save head a freq idd;

% --------------------------------------------------------------------
function Untitled_73_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_73 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load head;

if idd == '1'
    t=-8:0.001:8;
    y=a*sin(2*pi*freq*t);
    axis(handles.axes1);   
    plot(t,y);
    axis([-8 8 -10 10]);
    set(handles.text2,'string','Graph Loaded');
    pause(2);
    set(handles.text2,'string',' ');
elseif idd == '2'
    t1=-8:0.001:8;
    y=a*cos(2*pi*freq*t1);
    axis(handles.axes1);   
    plot(t1,y,'r');
    axis([-8 8 -10 10]);
    set(handles.text2,'string','Graph Loaded');
    pause(2);
    set(handles.text2,'string',' ');
elseif idd == '3'
    t2=-8:0.001:8;
    y=a*tan(2*pi*freq*t2);
    axis(handles.axes1);   
    plot(t2,y,'k');
    axis([-8 8 -10 10]);
    set(handles.text2,'string','Graph Loaded');
    pause(2);
    set(handles.text2,'string',' ');
elseif idd == '4'
    t3=-8:0.001:8;
    y=a*square(2*pi*freq*t3);
    axis(handles.axes1);   
    plot(t3,y,'m');
    axis([-8 8 -10 10]);
    set(handles.text2,'string','Graph Loaded');
    pause(2);
    set(handles.text2,'string',' ');
end

% --------------------------------------------------------------------
function Untitled_71_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_71 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function Untitled_75_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_75 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

grid minor;

% --------------------------------------------------------------------
function Untitled_76_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_76 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

grid off;

% --------------------------------------------------------------------
function Untitled_74_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_74 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


