function varargout = KUKA_GUI(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @KUKA_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @KUKA_GUI_OutputFcn, ...
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                        %%
%%%                  Written by Rohit Mishra                               %%
%%%                  A.C. Patil College of Engg.                                            %%
%%%                  March 2013                                            %%
%%%                  Simulation of six axis kuka kr6.                      %%
%%%                                                                        %%
%%%      The purpose of this program is to simulate a six axis kuka kr6    %%		
%%%      robot located in the DRHR DEPT. at BARC MUMBAI .  This            %%
%%%      program simulates Forward Kinematics of this robot.               %%
%%%      To operate this program:                                          %% 
%%%           1)     Make sure that KUKA.WRL, KUKA_GUI.fig, KUKA_GUI.m     %%
%%%                  are in the appropriate path.                          %%       
%%%           2)     Execute KUKA_GUI.m                                    %%
%%%           4)     Have fun!                                             %%
%%%      If you have question about this program email Rohit Mishra        %%
%%%      <mishra.rohit2410@gmail.com> .  Rohit Mishra is Final Year Student%%
%%%      from Mumbai University(ACPCE, TRONIX 2013)has developed this      %%
%%%      project with the help of his friends Tejas Mahadik, Kaushik       %%
%%%      Natrajan and  Siddhesh Chavan .                                   %%
%%%      We are thankful to our project guide and HOD Dr. V.N. Pawar for   %%
%%%      his unwavering support and guidance in helping us with this       %%
%%%      project and also to Mrs. Varsha Shirwalkar at Barc, Mumbai.       %%
%%%                                                                        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           


function KUKA_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
KUKA = vrworld('KUKA.wrl');
open(KUKA)
view(KUKA)

    radian=0
    KUKA.shoulder.rotation = [0, 1, 0, radian];
      
    KUKA.elbow.rotation = [0, 0, 1, radian];

    KUKA.pitch.rotation = [0, 0, 1, radian];
  
    KUKA.roll.rotation = [1, 0, 0, radian];
   
    KUKA.yaw.rotation = [0, 0, 1, radian];
   
    KUKA.drill.rotation = [1, 0, 0, radian];
 

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
KUKA = vrworld('KUKA.wrl');
open(KUKA)
T1=get(handles.slider1,'value');
set(handles.edit57,'String',num2str(T1));
guidata(hObject, handles);
    radian=T1*pi/180;
    q1=radian;
    KUKA.shoulder.rotation = [0, 1, 0, radian];
  
% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
KUKA = vrworld('KUKA.wrl');
open(KUKA)
T2=get(handles.slider2,'value');
set(handles.edit58,'String',num2str(T2));
guidata(hObject, handles);
    radian=T2*pi/180;
    q2=radian;
    KUKA.elbow.rotation = [0, 0, 1, radian];


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
KUKA = vrworld('KUKA.wrl');
open(KUKA)
T3=get(handles.slider3,'value');
set(handles.edit59,'String',num2str(T3));
guidata(hObject, handles);
    radian=T3*pi/180;
    q3=radian;
    KUKA.pitch.rotation = [0, 0, 1, radian];



% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
KUKA = vrworld('KUKA.wrl');
open(KUKA)
T4=-get(handles.slider4,'value');
set(handles.edit60,'String',num2str(T4));
guidata(hObject, handles);
    radian=T4*pi/180;
    q4=radian;
    KUKA.roll.rotation = [1, 0, 0, radian];


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
KUKA = vrworld('KUKA.wrl');
open(KUKA)
T5=-get(handles.slider5,'value');
    set(handles.edit61,'String',num2str(T5));
    guidata(hObject, handles);
    radian=T5*pi/180;
    q5=radian;
    KUKA.yaw.rotation = [0, 0, 1, radian];
    
    
    % --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
KUKA = vrworld('KUKA.wrl');
open(KUKA)
T6=-get(handles.slider6,'value');
set(handles.edit62,'String',num2str(T6));
guidata(hObject, handles);
    radian=T6*pi/180;
    q6=radian;
    KUKA.drill.rotation = [1, 0, 0, radian];


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)


% % % GIVEN JOINT VARIABLES

d=[335   0   0   -295    0   -80];
a=[75    270 90  0   0   0];
 
% % TRANSFORMATION MATRIX 1.
q1=get(handles.slider1,'Value');
T1=[    cos(q1)     0       -sin(q1) a(1)*cos(q1)
        sin(q1)     0       -cos(q1) a(1)*sin(q1)   
        0           -1          0       d(1)
        0           0           0        1      ];

% % TRANSFORMATION MATRIX 2.    
q2=get(handles.slider2,'Value');
T2=[    cos(q2)     -sin(q2)    0   a(2)*cos(q2)
        sin(q2)     cos(q2)     0   a(2)*sin(q2)
        0               0       1       0
        0               0       0       1   ];
    

% % TRANSFORMATION MATRIX 3.        
q3=get(handles.slider3,'Value');
T3=[    cos(q3)         0    sin(q3)   a(3)*cos(q3)
        sin(q3)         0    -cos(q3)   a(3)*sin(q3)
        0               0       0       0
        0               0       0       1   ];
% % TRANSFORMATION MATRIX 4.    
q4=get(handles.slider4,'Value');
T4=[    cos(q4)         0   -sin(q4)    0
        sin(q4)         0    cos(q4)    0
        0              -1       0      d(4)
        0               0       0       1   ];
    

% % TRANSFORMATION MATRIX 5.
q5=get(handles.slider5,'Value');
T5=[    cos(q5)     0       sin(q5)           0       
        sin(q5)     0       -cos(q5)          0
        0           1          0               0
        0           0          0               1       ];
    

% % TRANSFORMATION MATRIX 6.        
q6=get(handles.slider6,'Value');
T6=[    cos(q6)     -sin(q6)        0           0
        sin(q6)     cos(q6)     0               0
        0           0           1           0
        0           0           0               1   ];
    
        
        
A=T1*T2*T3*T4*T5*T6;
       
set(handles.edit42,'String',num2str(A(13)));
set(handles.edit43,'String',num2str(A(14)));
set(handles.edit44,'String',num2str(A(15)));
set(handles.edit48,'String',num2str(A(1)));
set(handles.edit49,'String',num2str(A(5)));
set(handles.edit50,'String',num2str(A(9)));
set(handles.edit51,'String',num2str(A(2)));
set(handles.edit52,'String',num2str(A(6)));
set(handles.edit53,'String',num2str(A(10)));
set(handles.edit54,'String',num2str(A(3)));
set(handles.edit55,'String',num2str(A(7)));
set(handles.edit56,'String',num2str(A(11)));
guidata(hObject, handles);
