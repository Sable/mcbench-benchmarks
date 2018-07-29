% =========================================================================
% =========================================================================
% ================================CHECKERS=================================
% =========================================================================
% =========================================================================
% 
% Author:
%   Muhammad Suleman Shafqat
%   Started on:     10Jan, 2011
%   Completed on:   17Jan, 2011 (1930hrs)
% 
% Modified by:
%   Nil
% 
% Version:
%   01
% 
% 
% 
% ---Functions---------Used for
%   Checkers            main function
%   playerturn          player's turn
%   checkfp             check final position, it checks position and kills
%   wholoses            to check who loses and if no body return (loses=0)
%   
% ---Structures----------Used for 
% 
%   handles             structure for varialbes
%   ha                  global for components of GUI
% 
% ---Variables----------Used for 
% 
%   box                 to represent position of pieces
%   dblbox              to represent doubled pieces on board (initially zeros)
%   ipx                 initial position in row
%   ipy                 initial position in column
%   fpx                 final position in row
%   fpy                 final position in column
%   x                   row number of selected button 
%   y                   column number of selected button
%   bkground            to upload a background of board
%   bg                  background image is uploaded here
%   plrmark             an axis to show whose turn is this
%   plr1mark            mark of player 1's pieces
%   plr2mark            mark of player 2's pieces
%   plr1dblmark         mark of player 1's doubled piece
%   plr2dblmark         mark of player 2's doubled piece
%   check               binary variable to check whether a turn is correct or not
%   loses               checked after each turn, whether anybody loses or not
%   plr                 player who needs to turn
%   otherplr            other player
% 
% =========================================================================
function varargout = Checkers(varargin)
% CHECKERS M-file for Checkers.fig

% initialization code
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Checkers_OpeningFcn, ...
                   'gui_OutputFcn',  @Checkers_OutputFcn, ...
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
% End initialization code

% --- Executes just before Checkers is made visible.
function Checkers_OpeningFcn(hObject, eventdata, handles, varargin)
% hObject    handle to figure
% handles    structure with handles and user data
% varargin   command line arguments to Checkers
global ha
clc

% initialization
ha(1)  = handles.plrmark;
ha(2)  = handles.bkground;
ha(11) = handles.box11;
ha(13) = handles.box13;
ha(15) = handles.box15;
ha(17) = handles.box17;
ha(31) = handles.box31;
ha(33) = handles.box33;
ha(35) = handles.box35;
ha(37) = handles.box37;
ha(51) = handles.box51;
ha(53) = handles.box53;
ha(55) = handles.box55;
ha(57) = handles.box57;
ha(71) = handles.box71;
ha(73) = handles.box73;
ha(75) = handles.box75;
ha(77) = handles.box77;
ha(22) = handles.box22;
ha(24) = handles.box24;
ha(26) = handles.box26;
ha(28) = handles.box28;
ha(42) = handles.box42;
ha(44) = handles.box44;
ha(46) = handles.box46;
ha(48) = handles.box48;
ha(62) = handles.box62;
ha(64) = handles.box64;
ha(66) = handles.box66;
ha(68) = handles.box68;
ha(82) = handles.box82;
ha(84) = handles.box84;
ha(86) = handles.box86;
ha(88) = handles.box88;
% Choose default command line output for Checkers
handles.output = hObject;
handles.plr=1;
% initializing box;  i have added some extra zeros to original 8x8 box
% why...? well it was needed to check position of a piece whether is there
% any opponents piece in its vicinity or not.
handles.box=[ ...
    1 0 1 0 1 0 1 0 0 0 0; ...
    0 1 0 1 0 1 0 1 0 0 0; ...
    1 0 1 0 1 0 1 0 0 0 0; ...
    0 0 0 0 0 0 0 0 0 0 0; ...
    0 0 0 0 0 0 0 0 0 0 0; ...
    0 2 0 2 0 2 0 2 0 0 0; ...
    2 0 2 0 2 0 2 0 0 0 0; ...
    0 2 0 2 0 2 0 2 0 0 0; ...
    0 0 0 0 0 0 0 0 0 0 0; ...
    0 0 0 0 0 0 0 0 0 0 0; ...
    0 0 0 0 0 0 0 0 0 0 0     ];
% position variables
handles.ipx=0;
handles.ipy=0;
handles.fpx=0;
handles.fpy=0;
handles.x=0;
handles.y=0;
% dblbox is for the doubled pieces
handles.dblbox=zeros(8,8);

handles.plr1mark=imread(strcat('plr1mark','.png'));
handles.plr2mark=imread(strcat('plr2mark','.png'));
handles.plr1dblmark=imread(strcat('plr1dblmark','.png'));
handles.plr2dblmark=imread(strcat('plr2dblmark','.png'));
% handles.blank=imread(strcat('blank','.png'));
handles.blank(:,:,1)=zeros();
handles.blank(:,:,2)=zeros();
handles.blank(:,:,3)=zeros();
% showing whose turn......initially player one's turn it can be changed
axes(ha(1));
image(handles.plr1mark);
axis off;
% show a background
[bg]=imread(strcat('background','.png'));
axes(ha(2));
image(bg);
axis off;
% now initializing figure with player marks
set(ha(11),'CData',handles.plr1mark);
set(ha(13),'CData',handles.plr1mark);
set(ha(15),'CData',handles.plr1mark);
set(ha(17),'CData',handles.plr1mark);
set(ha(22),'CData',handles.plr1mark);
set(ha(24),'CData',handles.plr1mark);
set(ha(26),'CData',handles.plr1mark);
set(ha(28),'CData',handles.plr1mark);
set(ha(31),'CData',handles.plr1mark);
set(ha(33),'CData',handles.plr1mark);
set(ha(35),'CData',handles.plr1mark);
set(ha(37),'CData',handles.plr1mark);
set(ha(62),'CData',handles.plr2mark);
set(ha(64),'CData',handles.plr2mark);
set(ha(66),'CData',handles.plr2mark);
set(ha(68),'CData',handles.plr2mark);
set(ha(71),'CData',handles.plr2mark);
set(ha(73),'CData',handles.plr2mark);
set(ha(75),'CData',handles.plr2mark);
set(ha(77),'CData',handles.plr2mark);
set(ha(82),'CData',handles.plr2mark);
set(ha(84),'CData',handles.plr2mark);
set(ha(86),'CData',handles.plr2mark);
set(ha(88),'CData',handles.plr2mark);

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = Checkers_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% used to close the game anytime
% close(handles.figure1);
close(gcbf)

% --- Executes on button press in box11.
function box11_Callback(hObject, eventdata, handles)
global ha
handles.x=1;handles.y=1;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box13.
function box13_Callback(hObject, eventdata, handles)
global ha
handles.x=1;handles.y=3;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box15.
function box15_Callback(hObject, eventdata, handles)
global ha
handles.x=1;handles.y=5;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box17.
function box17_Callback(hObject, eventdata, handles)
global ha
handles.x=1;handles.y=7;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box22.
function box22_Callback(hObject, eventdata, handles)
global ha
handles.x=2;handles.y=2;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box24.
function box24_Callback(hObject, eventdata, handles)
global ha
handles.x=2;handles.y=4;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box26.
function box26_Callback(hObject, eventdata, handles)
global ha
handles.x=2;handles.y=6;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box28.
function box28_Callback(hObject, eventdata, handles)
global ha
handles.x=2;handles.y=8;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box31.
function box31_Callback(hObject, eventdata, handles)
global ha
handles.x=3;handles.y=1;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box33.
function box33_Callback(hObject, eventdata, handles)
global ha
handles.x=3;handles.y=3;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box35.
function box35_Callback(hObject, eventdata, handles)
global ha
handles.x=3;handles.y=5;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box37.
function box37_Callback(hObject, eventdata, handles)
global ha
handles.x=3;handles.y=7;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box42.
function box42_Callback(hObject, eventdata, handles)
global ha
handles.x=4;handles.y=2;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box44.
function box44_Callback(hObject, eventdata, handles)
global ha
handles.x=4;handles.y=4;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box46.
function box46_Callback(hObject, eventdata, handles)
global ha
handles.x=4;handles.y=6;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box48.
function box48_Callback(hObject, eventdata, handles)
global ha
handles.x=4;handles.y=8;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box51.
function box51_Callback(hObject, eventdata, handles)
global ha
handles.x=5;handles.y=1;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box53.
function box53_Callback(hObject, eventdata, handles)
global ha
handles.x=5;handles.y=3;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box55.
function box55_Callback(hObject, eventdata, handles)
global ha
handles.x=5;handles.y=5;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box57.
function box57_Callback(hObject, eventdata, handles)
global ha
handles.x=5;handles.y=7;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box62.
function box62_Callback(hObject, eventdata, handles)
global ha
handles.x=6;handles.y=2;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box64.
function box64_Callback(hObject, eventdata, handles)
global ha
handles.x=6;handles.y=4;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box66.
function box66_Callback(hObject, eventdata, handles)
global ha
handles.x=6;handles.y=6;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box68.
function box68_Callback(hObject, eventdata, handles)
global ha
handles.x=6;handles.y=8;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box71.
function box71_Callback(hObject, eventdata, handles)
global ha
handles.x=7;handles.y=1;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box73.
function box73_Callback(hObject, eventdata, handles)
global ha
handles.x=7;handles.y=3;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box75.
function box75_Callback(hObject, eventdata, handles)
global ha
handles.x=7;handles.y=5;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box77.
function box77_Callback(hObject, eventdata, handles)
global ha
handles.x=7;handles.y=7;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box82.
function box82_Callback(hObject, eventdata, handles)
global ha
handles.x=8;handles.y=2;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box84.
function box84_Callback(hObject, eventdata, handles)
global ha
handles.x=8;handles.y=4;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box86.
function box86_Callback(hObject, eventdata, handles)
global ha
handles.x=8;handles.y=6;
handles=playerturn(ha,handles);
guidata(hObject,handles);

% --- Executes on button press in box88.
function box88_Callback(hObject, eventdata, handles)
global ha
handles.x=8;handles.y=8;
handles=playerturn(ha,handles);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function plrmark_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in concede.
function concede_Callback(hObject, eventdata, handles)
close(handles.figure1);
if handles.plr==2
    msgbox('BLACK Wins','Winner','custom',handles.plr1mark);
elseif handles.plr==1
    msgbox('RED Wins','Winner','custom',handles.plr2mark);
end
% ========================================================================= 
% =========================================================================
% =========================================================================
% =========================================================================
% =========================================================================
