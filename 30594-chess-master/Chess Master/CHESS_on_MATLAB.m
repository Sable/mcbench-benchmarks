% =========================================================================
% =========================================================================
% ================================CHESS=================================
% =========================================================================
% =========================================================================
% 
% Author:
%   Muhammad Suleman Shafqat
%   Started on:     19Jan, 2011 (1200hrs)
%   Completed on:   20Jan, 2011 (1130hrs)
% 
% Version:
%   01
% 
% ---Functions---------Used for
%   Chess               main function
%   playerturn          player's turn
%   checkfp             check final position, it checks position and kills
%   wholoses            to check who loses and if no body return (loses=0)
%   reqmark             converts black to white backgrounds if necessary
%   whichpiece          reads the selected piece and converts it from icon to integer
% 
% ---Structures----------Used for 
% 
%   h                   structure for varialbes
%   ha                  global for components of GUI
% 
% ---Variables----------Used for 
% 
%   box                 to represent position of pieces
%   ipr                 initial position in row
%   ipc                 initial position in column
%   fpr                 final position in row
%   fpc                 final position in column
%   r                   row number of selected button 
%   c                   column number of selected button
%   background            to upload a background of board
%   bg                  background image is uploaded here
%   plrmark             an axis to show whose turn is this
%   check               binary variable to check whether a turn is correct or not
%   loses               checked after each turn, whether anybody loses or not
%   plr                 player who needs to turn
%   otherplr            other player
%   ed                  eventdata
% =========================================================================

% simple chess:
%       started on 19/1/2011 at 1200hrs
%       ended on 20/1/2011 at 1130hrs
% changing into symbols:
%       started on 28/1/2011 and completed by 1230hrs
function varargout = CHESS_on_MATLAB(varargin)
% CHESS M-file for CHESS.fig
% Last Modified by GUIDE v2.5 28-Jan-2011 12:16:36
% Begin initialization code
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CHESS_OpeningFcn, ...
                   'gui_OutputFcn',  @CHESS_OutputFcn, ...
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

% --- Executes just before CHESS is made visible.
function CHESS_OpeningFcn(hObj, ed, h, varargin)
% Choose default command line output for CHESS
h.output = hObj;
global ha
clc
% initialization gui components
ha(1)  = h.plrturn;
ha(11) = h.box11;ha(12) = h.box12;ha(13) = h.box13;ha(14) = h.box14;
ha(15) = h.box15;ha(16) = h.box16;ha(17) = h.box17;ha(18) = h.box18;
ha(21) = h.box21;ha(22) = h.box22;ha(23) = h.box23;ha(24) = h.box24;
ha(25) = h.box25;ha(26) = h.box26;ha(27) = h.box27;ha(28) = h.box28;
ha(31) = h.box31;ha(32) = h.box32;ha(33) = h.box33;ha(34) = h.box34;
ha(35) = h.box35;ha(36) = h.box36;ha(37) = h.box37;ha(38) = h.box38;
ha(41) = h.box41;ha(42) = h.box42;ha(43) = h.box43;ha(44) = h.box44;
ha(45) = h.box45;ha(46) = h.box46;ha(47) = h.box47;ha(48) = h.box48;
ha(51) = h.box51;ha(52) = h.box52;ha(53) = h.box53;ha(54) = h.box54;
ha(55) = h.box55;ha(56) = h.box56;ha(57) = h.box57;ha(58) = h.box58;
ha(61) = h.box61;ha(62) = h.box62;ha(63) = h.box63;ha(64) = h.box64;
ha(65) = h.box65;ha(66) = h.box66;ha(67) = h.box67;ha(68) = h.box68;
ha(71) = h.box71;ha(72) = h.box72;ha(73) = h.box73;ha(74) = h.box74;
ha(75) = h.box75;ha(76) = h.box76;ha(77) = h.box77;ha(78) = h.box78;
ha(81) = h.box81;ha(82) = h.box82;ha(83) = h.box83;ha(84) = h.box84;
ha(85) = h.box85;ha(86) = h.box86;ha(87) = h.box87;ha(88) = h.box88;

%uploading symbols of chess pieces to structure 'h'
h.blackpawn1=imread(strcat('pieces\blackpawn1','.png'));
h.blackpawn2=imread(strcat('pieces\blackpawn2','.png'));
h.whitepawn1=imread(strcat('pieces\whitepawn1','.png'));
h.whitepawn2=imread(strcat('pieces\whitepawn2','.png'));
h.blackrook1=imread(strcat('pieces\blackrook1','.png'));
h.blackrook2=imread(strcat('pieces\blackrook2','.png'));
h.whiterook1=imread(strcat('pieces\whiterook1','.png'));
h.whiterook2=imread(strcat('pieces\whiterook2','.png'));
h.blackbishop1=imread(strcat('pieces\blackbishop1','.png'));
h.blackbishop2=imread(strcat('pieces\blackbishop2','.png'));
h.whitebishop1=imread(strcat('pieces\whitebishop1','.png'));
h.whitebishop2=imread(strcat('pieces\whitebishop2','.png'));
h.blackknight1=imread(strcat('pieces\blackknight1','.png'));
h.blackknight2=imread(strcat('pieces\blackknight2','.png'));
h.whiteknight1=imread(strcat('pieces\whiteknight1','.png'));
h.whiteknight2=imread(strcat('pieces\whiteknight2','.png'));
h.blackqueen1=imread(strcat('pieces\blackqueen1','.png'));
h.blackqueen2=imread(strcat('pieces\blackqueen2','.png'));
h.whitequeen1=imread(strcat('pieces\whitequeen1','.png'));
h.whitequeen2=imread(strcat('pieces\whitequeen2','.png'));
h.blackking1=imread(strcat('pieces\blackking1','.png'));
h.blackking2=imread(strcat('pieces\blackking2','.png'));
h.whiteking1=imread(strcat('pieces\whiteking1','.png'));
h.whiteking2=imread(strcat('pieces\whiteking2','.png'));
h.black=imread(strcat('pieces\black','.png'));
h.white=imread(strcat('pieces\white','.png'));
% deletion of extra rows and colomns
h.blackpawn1(:,60,:)=[];
h.blackpawn2(:,60,:)=[];
h.whitepawn2(:,60,:)=[];
h.blackrook1(:,60,:)=[];
h.blackrook2(:,60,:)=[];
h.whiterook1(:,60,:)=[];
h.whiterook2(:,60,:)=[];
h.blackbishop1(:,60,:)=[];
h.blackbishop2(:,60,:)=[];
h.whitebishop1(:,60,:)=[];
h.whitebishop2(:,60,:)=[];
h.blackknight2(:,60,:)=[];
h.whiteknight2(:,60,:)=[];
h.whitequeen2(:,60,:)=[];
h.black(:,60,:)=[];
h.blackrook1(60,:,:)=[];
h.blackrook2(60,:,:)=[];
h.whiterook1(60,:,:)=[];
h.whiterook2(60,:,:)=[];
h.blackbishop1(60,:,:)=[];
h.blackbishop2(60,:,:)=[];
h.whitebishop1(60,:,:)=[];
h.whitebishop2(60,:,:)=[];
h.blackknight1(60,:,:)=[];
h.blackknight2(60,:,:)=[];
h.whiteknight1(60,:,:)=[];
h.whiteknight2(60,:,:)=[];
h.blackqueen1(60,:,:)=[];
h.whitequeen2(60,:,:)=[];
h.blackking1(60,:,:)=[];
h.blackking2(60,:,:)=[];
h.whiteking1(60,:,:)=[];
h.whiteking2(60,:,:)=[];
h.black(60,:,:)=[];
h.white(60,:,:)=[];

% initializing box;  8x8 box
% rook=2
% horse=3
% bishop=4
% queen=5
% king=10
% pawn=1
h.box=[ ...
    2  3  4  5  10 4  3  2 ; ...
    1  1  1  1  1  1  1  1 ; ...
    0  0  0  0  0  0  0  0  ; ...
    0  0  0  0  0  0  0  0  ; ...
    0  0  0  0  0  0  0  0  ; ...
    0  0  0  0  0  0  0  0  ; ...
    -1 -1 -1 -1 -1 -1 -1 -1 ; ...
    -2 -3 -4 -5 -10 -4 -3 -2  ];
% position variables
h.ipr=0;
h.ipc=0;
h.fpr=0;
h.fpc=0;
h.r=0;
h.c=0;
% showing whose turn......initially player one's turn it can be changed
h.plr=1;
set(ha(1),'CData',h.blackking2);
i=2;
% now initializing figure with player marks
for x=1:8
    for y=1:8
% required when to convert pieces from numbers to uploaded symbols
        if h.box(x,y)==1
            if i==1
                mark=h.blackpawn1;
                i=2;
            elseif i==2
                mark=h.blackpawn2;
                i=1;
            end
        elseif h.box(x,y)==-1
            if i==1
                mark=h.whitepawn1;
                i=2;
            elseif i==2
                mark=h.whitepawn2;
                i=1;
            end
        elseif h.box(x,y)==2
            if i==1
                mark=h.blackrook1;
                i=2;
            elseif i==2
                mark=h.blackrook2;
                i=1;
            end
        elseif h.box(x,y)==-2
            if i==1
                mark=h.whiterook1;
                i=2;
            elseif i==2
                mark=h.whiterook2;
                i=1;
            end
        elseif h.box(x,y)==3
            if i==1
                mark=h.blackknight1;
                i=2;
            elseif i==2
                mark=h.blackknight2;
                i=1;
            end
        elseif h.box(x,y)==-3
            if i==1
                mark=h.whiteknight1;
                i=2;
            elseif i==2
                mark=h.whiteknight2;
                i=1;
            end
        elseif h.box(x,y)==4
            if i==1
                mark=h.blackbishop1;
                i=2;
            elseif i==2
                mark=h.blackbishop2;
                i=1;
            end
        elseif h.box(x,y)==-4
            if i==1
                mark=h.whitebishop1;
                i=2;
            elseif i==2
                mark=h.whitebishop2;
                i=1;
            end
        elseif h.box(x,y)==5
            if i==1
                mark=h.blackqueen1;
                i=2;
            elseif i==2
                mark=h.blackqueen2;
                i=1;
            end
        elseif h.box(x,y)==-5
            if i==1
                mark=h.whitequeen1;
                i=2;
            elseif i==2
                mark=h.whitequeen2;
                i=1;
            end
        elseif h.box(x,y)==10
            if i==1
                mark=h.blackking1;
                i=2;
            elseif i==2
                mark=h.blackking2;
                i=1;
            end
        elseif h.box(x,y)==-10
            if i==1
                mark=h.whiteking1;
                i=2;
            elseif i==2
                mark=h.whiteking2;
                i=1;
            end
        else
            if i==1
                mark=h.black;
                i=2;
            elseif i==2
                mark=h.white;
                i=1;
            end
        end
        rc=x*10+y;
        set(ha(rc),'CData',mark);
    end
%     first row starting from white next row starting from black
    if i==1
        i=2;
    else i=1;
    end

end
%set(CHESS,'Visible','on')
% Update h structure
guidata(hObj, h);

function varargout = CHESS_OutputFcn(hObj, ed, h) 
% Get default command line output from h structure
varargout{1} = h.output;

% --- Executes on button press in exit.
function exit_Callback(hObj, ed, h)
% used to close the game anytime
close(gcbf)

% --- Executes during object creation, after setting all properties.
function plrturn_CreateFcn(hObj, ed, h)
if ispc && isequal(get(hObj,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObj,'BackgroundColor','white');
end

% --- Executes on button press in concede.
function concede_Callback(hObj, ed, h)
if h.plr==2
    msgbox('CHESS KING','Winner','custom',h.blackking2)
elseif h.plr==1
    msgbox('CHESS KING','Winner','custom',h.whiteking1)
end
close(gcbf);

function box11_Callback(hObj, ed, h)
global ha
h.r=1;h.c=1;
h=playerturn(ha,h);
guidata(hObj,h);

function box12_Callback(hObj, ed, h)
global ha
h.r=1;h.c=2;
h=playerturn(ha,h);
guidata(hObj,h);

function box13_Callback(hObj, ed, h)
global ha
h.r=1;h.c=3;
h=playerturn(ha,h);
guidata(hObj,h);

function box14_Callback(hObj, ed, h)
global ha
h.r=1;h.c=4;
h=playerturn(ha,h);
guidata(hObj,h);

function box15_Callback(hObj, ed, h)
global ha
h.r=1;h.c=5;
h=playerturn(ha,h);
guidata(hObj,h);

function box16_Callback(hObj, ed, h)
global ha
h.r=1;h.c=6;
h=playerturn(ha,h);
guidata(hObj,h);

function box17_Callback(hObj, ed, h)
global ha
h.r=1;h.c=7;
h=playerturn(ha,h);
guidata(hObj,h);

function box18_Callback(hObj, ed, h)
global ha
h.r=1;h.c=8;
h=playerturn(ha,h);
guidata(hObj,h);

function box21_Callback(hObj, ed, h)
global ha
h.r=2;h.c=1;
h=playerturn(ha,h);
guidata(hObj,h);

function box22_Callback(hObj, ed, h)
global ha
h.r=2;h.c=2;
h=playerturn(ha,h);
guidata(hObj,h);

function box23_Callback(hObj, ed, h)
global ha
h.r=2;h.c=3;
h=playerturn(ha,h);
guidata(hObj,h);

function box24_Callback(hObj, ed, h)
global ha
h.r=2;h.c=4;
h=playerturn(ha,h);
guidata(hObj,h);

function box25_Callback(hObj, ed, h)
global ha
h.r=2;h.c=5;
h=playerturn(ha,h);
guidata(hObj,h);

function box26_Callback(hObj, ed, h)
global ha
h.r=2;h.c=6;
h=playerturn(ha,h);
guidata(hObj,h);

function box27_Callback(hObj, ed, h)
global ha
h.r=2;h.c=7;
h=playerturn(ha,h);
guidata(hObj,h);

function box28_Callback(hObj, ed, h)
global ha
h.r=2;h.c=8;
h=playerturn(ha,h);
guidata(hObj,h);

function box31_Callback(hObj, ed, h)
global ha
h.r=3;h.c=1;
h=playerturn(ha,h);
guidata(hObj,h);

function box32_Callback(hObj, ed, h)
global ha
h.r=3;h.c=2;
h=playerturn(ha,h);
guidata(hObj,h);

function box33_Callback(hObj, ed, h)
global ha
h.r=3;h.c=3;
h=playerturn(ha,h);
guidata(hObj,h);

function box34_Callback(hObj, ed, h)
global ha
h.r=3;h.c=4;
h=playerturn(ha,h);
guidata(hObj,h);

function box35_Callback(hObj, ed, h)
global ha
h.r=3;h.c=5;
h=playerturn(ha,h);
guidata(hObj,h);

function box36_Callback(hObj, ed, h)
global ha
h.r=3;h.c=6;
h=playerturn(ha,h);
guidata(hObj,h);

function box37_Callback(hObj, ed, h)
global ha
h.r=3;h.c=7;
h=playerturn(ha,h);
guidata(hObj,h);

function box38_Callback(hObj, ed, h)
global ha
h.r=3;h.c=8;
h=playerturn(ha,h);
guidata(hObj,h);

function box41_Callback(hObj, ed, h)
global ha
h.r=4;h.c=1;
h=playerturn(ha,h);
guidata(hObj,h);

function box42_Callback(hObj, ed, h)
global ha
h.r=4;h.c=2;
h=playerturn(ha,h);
guidata(hObj,h);

function box43_Callback(hObj, ed, h)
global ha
h.r=4;h.c=3;
h=playerturn(ha,h);
guidata(hObj,h);

function box44_Callback(hObj, ed, h)
global ha
h.r=4;h.c=4;
h=playerturn(ha,h);
guidata(hObj,h);

function box45_Callback(hObj, ed, h)
global ha
h.r=4;h.c=5;
h=playerturn(ha,h);
guidata(hObj,h);

function box46_Callback(hObj, ed, h)
global ha
h.r=4;h.c=6;
h=playerturn(ha,h);
guidata(hObj,h);

function box47_Callback(hObj, ed, h)
global ha
h.r=4;h.c=7;
h=playerturn(ha,h);
guidata(hObj,h);

function box48_Callback(hObj, ed, h)
global ha
h.r=4;h.c=8;
h=playerturn(ha,h);
guidata(hObj,h);

function box51_Callback(hObj, ed, h)
global ha
h.r=5;h.c=1;
h=playerturn(ha,h);
guidata(hObj,h);

function box52_Callback(hObj, ed, h)
global ha
h.r=5;h.c=2;
h=playerturn(ha,h);
guidata(hObj,h);

function box53_Callback(hObj, ed, h)
global ha
h.r=5;h.c=3;
h=playerturn(ha,h);
guidata(hObj,h);

function box54_Callback(hObj, ed, h)
global ha
h.r=5;h.c=4;
h=playerturn(ha,h);
guidata(hObj,h);

function box55_Callback(hObj, ed, h)
global ha
h.r=5;h.c=5;
h=playerturn(ha,h);
guidata(hObj,h);

function box56_Callback(hObj, ed, h)
global ha
h.r=5;h.c=6;
h=playerturn(ha,h);
guidata(hObj,h);

function box57_Callback(hObj, ed, h)
global ha
h.r=5;h.c=7;
h=playerturn(ha,h);
guidata(hObj,h);

function box58_Callback(hObj, ed, h)
global ha
h.r=5;h.c=8;
h=playerturn(ha,h);
guidata(hObj,h);

function box61_Callback(hObj, ed, h)
global ha
h.r=6;h.c=1;
h=playerturn(ha,h);
guidata(hObj,h);

function box62_Callback(hObj, ed, h)
global ha
h.r=6;h.c=2;
h=playerturn(ha,h);
guidata(hObj,h);

function box63_Callback(hObj, ed, h)
global ha
h.r=6;h.c=3;
h=playerturn(ha,h);
guidata(hObj,h);

function box64_Callback(hObj, ed, h)
global ha
h.r=6;h.c=4;
h=playerturn(ha,h);
guidata(hObj,h);

function box65_Callback(hObj, ed, h)
global ha
h.r=6;h.c=5;
h=playerturn(ha,h);
guidata(hObj,h);

function box66_Callback(hObj, ed, h)
global ha
h.r=6;h.c=6;
h=playerturn(ha,h);
guidata(hObj,h);

function box67_Callback(hObj, ed, h)
global ha
h.r=6;h.c=7;
h=playerturn(ha,h);
guidata(hObj,h);

function box68_Callback(hObj, ed, h)
global ha
h.r=6;h.c=8;
h=playerturn(ha,h);
guidata(hObj,h);

function box71_Callback(hObj, ed, h)
global ha
h.r=7;h.c=1;
h=playerturn(ha,h);
guidata(hObj,h);

function box72_Callback(hObj, ed, h)
global ha
h.r=7;h.c=2;
h=playerturn(ha,h);
guidata(hObj,h);

function box73_Callback(hObj, ed, h)
global ha
h.r=7;h.c=3;
h=playerturn(ha,h);
guidata(hObj,h);

function box74_Callback(hObj, ed, h)
global ha
h.r=7;h.c=4;
h=playerturn(ha,h);
guidata(hObj,h);

function box75_Callback(hObj, ed, h)
global ha
h.r=7;h.c=5;
h=playerturn(ha,h);
guidata(hObj,h);

function box76_Callback(hObj, ed, h)
global ha
h.r=7;h.c=6;
h=playerturn(ha,h);
guidata(hObj,h);

function box77_Callback(hObj, ed, h)
global ha
h.r=7;h.c=7;
h=playerturn(ha,h);
guidata(hObj,h);

function box78_Callback(hObj, ed, h)
global ha
h.r=7;h.c=8;
h=playerturn(ha,h);
guidata(hObj,h);

function box81_Callback(hObj, ed, h)
global ha
h.r=8;h.c=1;
h=playerturn(ha,h);
guidata(hObj,h);

function box82_Callback(hObj, ed, h)
global ha
h.r=8;h.c=2;
h=playerturn(ha,h);
guidata(hObj,h);

function box83_Callback(hObj, ed, h)
global ha
h.r=8;h.c=3;
h=playerturn(ha,h);
guidata(hObj,h);

function box84_Callback(hObj, ed, h)
global ha
h.r=8;h.c=4;
h=playerturn(ha,h);
guidata(hObj,h);

function box85_Callback(hObj, ed, h)
global ha
h.r=8;h.c=5;
h=playerturn(ha,h);
guidata(hObj,h);

function box86_Callback(hObj, ed, h)
global ha
h.r=8;h.c=6;
h=playerturn(ha,h);
guidata(hObj,h);

function box87_Callback(hObj, ed, h)
global ha
h.r=8;h.c=7;
h=playerturn(ha,h);
guidata(hObj,h);

function box88_Callback(hObj, ed, h)
global ha
h.r=8;h.c=8;
h=playerturn(ha,h);
guidata(hObj,h);

% ================================================================
% ================================================================
% ================================================================
% ================================================================
