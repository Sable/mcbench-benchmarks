function varargout = tictactoe(varargin)
    
    
% TICTACTOE M-file for tictactoe.fig
%      TICTACTOE, by itself, creates a new TICTACTOE or raises the existing
%      singleton*.
%
%      H = TICTACTOE returns the handle to a new TICTACTOE or the handle to
%      the existing singleton*.
%
%      TICTACTOE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TICTACTOE.M with the given input arguments.
%
%      TICTACTOE('Property','Value',...) creates a new TICTACTOE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tictactoe_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tictactoe_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tictactoe

% Last Modified by GUIDE v2.5 07-Jan-2011 10:20:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tictactoe_OpeningFcn, ...
                   'gui_OutputFcn',  @tictactoe_OutputFcn, ...
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


% --- Executes just before tictactoe is made visible.
function tictactoe_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tictactoe (see VARARGIN)

% Choose default command line output for tictactoe
handles.output = hObject;
handles.plr=1;
handles.box=[0 0 0;0 0 0;0 0 0];
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tictactoe wait for user response (see UIRESUME)
%  uiwait(handles.figure1);
% my_gui('Position', [71.8 44.9 74.8 19.7])

% --- Outputs from this function are returned to the command line.
function varargout = tictactoe_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in box11.
function box11_Callback(hObject, eventdata, handles)
% hObject    handle to box11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%update player mark depending on whose turn
if handles.plr==1
    plrmark='X';
elseif handles.plr==2
    plrmark='O';
end
%if not already marked
if handles.box(1,1)==0
   set(hObject,'String',plrmark)
   handles.box(1,1)=handles.plr;
   %update player value
   winner=whowins(handles.plr,handles.box);
   if handles.plr==1
       handles.plr=2;
   else handles.plr=1;
   end
end
%when nobody wins winner=0 other wise close program with results
if winner~=0
    close(handles.figure1);
    if winner==1
        msgbox('Player 1 Wins');
    elseif winner==2
        msgbox('Player 2 Wins');
    elseif winner==-1
        msgbox('Its a Draw');
    end        
end
guidata(hObject,handles);

% --- Executes on button press in box12.
function box12_Callback(hObject, eventdata, handles)
% hObject    handle to box12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%update player mark depending on whose turn
if handles.plr==1
    plrmark='X';
elseif handles.plr==2
    plrmark='O';
end
%if not already marked
if handles.box(1,2)==0
   set(hObject,'String',plrmark)
   handles.box(1,2)=handles.plr;
   %update player value
   winner=whowins(handles.plr,handles.box);
   if handles.plr==1
       handles.plr=2;
   else handles.plr=1;
   end
end
%when nobody wins winner=0 other wise close program with results
if winner~=0
    close(handles.figure1);
    if winner==1
        msgbox('Player 1 Wins');
    elseif winner==2
        msgbox('Player 2 Wins');
    elseif winner==-1
        msgbox('Its a Draw');
    end        
end
guidata(hObject,handles);


% --- Executes on button press in box21.
function box21_Callback(hObject, eventdata, handles)
% hObject    handle to box21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%update player mark depending on whose turn
if handles.plr==1
    plrmark='X';
elseif handles.plr==2
    plrmark='O';
end
%if not already marked
if handles.box(2,1)==0
   set(hObject,'String',plrmark)
   handles.box(2,1)=handles.plr;
   %update player value
   winner=whowins(handles.plr,handles.box);
   if handles.plr==1
       handles.plr=2;
   else handles.plr=1;
   end
end
%when nobody wins winner=0 other wise close program with results
if winner~=0
    close(handles.figure1);
    if winner==1
        msgbox('Player 1 Wins');
    elseif winner==2
        msgbox('Player 2 Wins');
    elseif winner==-1
        msgbox('Its a Draw');
    end        
end
guidata(hObject,handles);


% --- Executes on button press in box22.
function box22_Callback(hObject, eventdata, handles)
% hObject    handle to box22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%update player mark depending on whose turn
if handles.plr==1
    plrmark='X';
elseif handles.plr==2
    plrmark='O';
end
%if not already marked
if handles.box(2,2)==0
   set(hObject,'String',plrmark)
   handles.box(2,2)=handles.plr;
   %update player value
   winner=whowins(handles.plr,handles.box);
   if handles.plr==1
       handles.plr=2;
   else handles.plr=1;
   end
end
%when nobody wins winner=0 other wise close program with results
if winner~=0
    close(handles.figure1);
    if winner==1
        msgbox('Player 1 Wins');
    elseif winner==2
        msgbox('Player 2 Wins');
    elseif winner==-1
        msgbox('Its a Draw');
    end        
end
guidata(hObject,handles);


% --- Executes on button press in box31.
function box31_Callback(hObject, eventdata, handles)
% hObject    handle to box31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%update player mark depending on whose turn
if handles.plr==1
    plrmark='X';
elseif handles.plr==2
    plrmark='O';
end
%if not already marked
if handles.box(3,1)==0
   set(hObject,'String',plrmark)
   handles.box(3,1)=handles.plr;
   %update player value
   winner=whowins(handles.plr,handles.box);
   if handles.plr==1
       handles.plr=2;
   else handles.plr=1;
   end
end
%when nobody wins winner=0 other wise close program with results
if winner~=0
    close(handles.figure1);
    if winner==1
        msgbox('Player 1 Wins');
    elseif winner==2
        msgbox('Player 2 Wins');
    elseif winner==-1
        msgbox('Its a Draw');
    end        
end
guidata(hObject,handles);


% --- Executes on button press in box32.
function box32_Callback(hObject, eventdata, handles)
% hObject    handle to box32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%update player mark depending on whose turn
if handles.plr==1
    plrmark='X';
elseif handles.plr==2
    plrmark='O';
end
%if not already marked
if handles.box(3,2)==0
   set(hObject,'String',plrmark)
   handles.box(3,2)=handles.plr;
   %update player value
   winner=whowins(handles.plr,handles.box);
   if handles.plr==1
       handles.plr=2;
   else handles.plr=1;
   end
end
%when nobody wins winner=0 other wise close program with results
if winner~=0
    close(handles.figure1);
    if winner==1
        msgbox('Player 1 Wins');
    elseif winner==2
        msgbox('Player 2 Wins');
    elseif winner==-1
        msgbox('Its a Draw');
    end        
end
guidata(hObject,handles);


% --- Executes on button press in box13.
function box13_Callback(hObject, eventdata, handles)
% hObject    handle to box13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%update player mark depending on whose turn
if handles.plr==1
    plrmark='X';
elseif handles.plr==2
    plrmark='O';
end
%if not already marked
if handles.box(1,3)==0
   set(hObject,'String',plrmark)
   handles.box(1,3)=handles.plr;
   %update player value
   winner=whowins(handles.plr,handles.box);
   if handles.plr==1
       handles.plr=2;
   else handles.plr=1;
   end
end
%when nobody wins winner=0 other wise close program with results
if winner~=0
    close(handles.figure1);
    if winner==1
        msgbox('Player 1 Wins');
    elseif winner==2
        msgbox('Player 2 Wins');
    elseif winner==-1
        msgbox('Its a Draw');
    end        
end
guidata(hObject,handles);


% --- Executes on button press in box23.
function box23_Callback(hObject, eventdata, handles)
% hObject    handle to box23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%update player mark depending on whose turn
if handles.plr==1
    plrmark='X';
elseif handles.plr==2
    plrmark='O';
end
%if not already marked
if handles.box(2,3)==0
   set(hObject,'String',plrmark)
   handles.box(2,3)=handles.plr;
   %update player value
   winner=whowins(handles.plr,handles.box);
   if handles.plr==1
       handles.plr=2;
   else handles.plr=1;
   end
end
%when nobody wins winner=0 other wise close program with results
if winner~=0
    close(handles.figure1);
    if winner==1
        msgbox('Player 1 Wins');
    elseif winner==2
        msgbox('Player 2 Wins');
    elseif winner==-1
        msgbox('Its a Draw');
    end        
end
guidata(hObject,handles);


% --- Executes on button press in box33.
function box33_Callback(hObject, eventdata, handles)
% hObject    handle to box33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%update player mark depending on whose turn
if handles.plr==1
    plrmark='X';
elseif handles.plr==2
    plrmark='O';
end
%if not already marked
if handles.box(3,3)==0
   set(hObject,'String',plrmark)
   handles.box(3,3)=handles.plr;
   %update player value
   winner=whowins(handles.plr,handles.box);
   if handles.plr==1
       handles.plr=2;
   else handles.plr=1;
   end
end
%when nobody wins winner=0 other wise close program with results
if winner~=0
    close(handles.figure1);
    if winner==1
        msgbox('Player 1 Wins');
    elseif winner==2
        msgbox('Player 2 Wins');
    elseif winner==-1
        msgbox('Its a Draw');
    end        
end
guidata(hObject,handles);


% --- Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1);
