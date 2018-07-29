function varargout = iconwz(varargin)
% ICONWZ Icon image creater
%
%      Draw desire button icon using 'iconwz'.
%      Click 'Pen' icon.
%      Select pen color in color pellet.
%      Draw image on convas.
%      If you want some idea of how to draw an image click preset icon image.
%      Click 'Done' button after you satistified with the image.
%      A variable 'CData' was created in workspace.
%      Open your GUI figure in GUIDE or create a new GUI.
%      Draw a push button of size 24x24 pixels.
%      Clear 'String' properties of the push button and
%      type 'CData' in CData value of the push button.
%      Run it. You should see the image on the button.
%      Inspect this code for advance usages.
%      Done.
%
%   Visit http://www.geocities.com/kyawtuns/tools.html for more info.

% Auther: Kyaw Tun
% DACS, NUS
% http://www.geocities.com/kyawtuns

% Last Modified by GUIDE v2.5 10-Mar-2004 16:14:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @iconwz_OpeningFcn, ...
                   'gui_OutputFcn',  @iconwz_OutputFcn, ...
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


% --- Executes just before iconwz is made visible.
function iconwz_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to iconwz (see VARARGIN)


% --- draw grid line
set(handles.axes1, 'XTick', [[1:16]./16]);
set(handles.axes1, 'YTick', [[1:16]./16]);
set(handles.axes1, 'Color', [get(0,'defaultUicontrolBackgroundColor')]);

handles.Color = 1; % current pen color
handles.Picture = 17 * ones(16, 16);    % icon picture of 16 x 16 pixel 
                                        % value represent color
handles.CData = Picture2CData(handles.Picture);                                        
                                    
% --- draw color pellet         
Color = 1;
for k1 = 3:-1:0
    for k2 = 0:1:3
        PaintRectangle(k2, k1, Color, 4);
        Color = Color + 1;
    end
end


% --- set up preset button icon
% set(handles.btnDraw, 'CData', getdata('pen'));



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes iconwz wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = iconwz_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = [];


% --------------------------------------------------------------------
function mnuFile_Callback(hObject, eventdata, handles)
% hObject    handle to mnuFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnuFileNew_Callback(hObject, eventdata, handles)
% hObject    handle to mnuFileNew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
btnClear_Callback(handles.btnClear, eventdata, handles)

% --------------------------------------------------------------------
function mnuFileExit_Callback(hObject, eventdata, handles)
% hObject    handle to mnuFileExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

closereq;


% ====================
function PaintRectangle(XBlockNo, YBlockNo, Color, N)
% show color of selected pixel


FaceColor = ColorMap(Color);
hd = rectangle('Position', [XBlockNo, YBlockNo, 1, 1] ./ N, ...
    'FaceColor', FaceColor);



% ========================
function c = ColorMap(k)
% convert color index k into colorcode

% color pellet from Microsoft Word custom toolbar icon editor

Color = {[1 1 1] % white
[1 1 0] % yellow
[    0    1.0000    0.5020] % light green
[0.5020    1.0000    1.0000] % blue green
[0.8353    0.8157    0.7843] % gray
[0.5020    0.5020         0] % horse shit
[    0    0.5020         0] % deep green
[  0    0.5020    0.5020] % school green
[0 0 1] % blue   
[1 0 1] % magenta 
[1 0 0] % red
[   0.5020    0.5020    0.5020] % smoke
[    0         0    0.5020] % deep blue
[ 0.5020         0    0.5020] % deep magenta
[  0.5020         0    0.2510] % deep magenta red
[0 0 0] % black
[0.83137254901961   0.81568627450980   0.78431372549020] % default background color
};

c = Color{k};


% --- Executes on button press in btnSend.
function btnSend_Callback(hObject, eventdata, handles)
% hObject    handle to btnSend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clipboard('copy', mat2str(handles.Picture));
handles.CData = Picture2CData(handles.Picture);
assignin('base', 'CData', handles.CData);
set(handles.btnTest, 'CData', handles.CData);
set(handles.textMessage, 'String', sprintf(['Icon color code was sent to clipboard.\n', ...
        'The image data ''CData'' variable was created in workspace.']));


% --- Executes on button press in btnErase.
function btnErase_Callback(hObject, eventdata, handles)
% hObject    handle to btnErase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of btnErase


% ===========================
function PutIcon(hObject, eventdata, handles, Type)

Yes = questdlg('Do you want to copy image?', 'Comfirmation', 'Yes', 'No', 'Yes');
if ~isequal(Yes, 'Yes'), return; end

handles.Picture = getdata(Type, 1);

axes(handles.axes1); % make canvas active
cla; % clear figure
for x = 1:16
    for y = 1:16
        PaintRectangle (x-1,y-1,handles.Picture(17-y,x),16);
    end
end
    
guidata(handles.axes1, handles);


% ==================================


% --- Executes on button press in btnDraw.
function btnDraw_Callback(hObject, eventdata, handles)
% hObject    handle to btnDraw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[X,Y,BUTTON] = ginput(1);
while isequal(BUTTON, 1)
    WhoIs = get(gco, 'Tag');
    if isempty(WhoIs) 
        WhoIs = get(get(gco, 'Parent'), 'Tag'); % if not son than father
    end
	set(handles.textMessage, 'String', ['X = ', num2str(X), '; Y = ', num2str(Y)])
    if isequal(WhoIs, 'axes1') % drawing
        XBlockNo = ceil(X * 16); % block no
        YBlockNo = ceil(Y * 16);
        PaintRectangle(XBlockNo-1, YBlockNo-1, handles.Color, 16);
        handles.Picture((17-YBlockNo), XBlockNo) = handles.Color;
    elseif isequal(WhoIs, 'Pellet') % change color
        x = ceil(X * 4);
        y = floor((1-Y) * 4);
        Color = y * 4 + x;
        handles.Color = Color;
        guidata(handles.Pellet, handles);
    elseif isequal(WhoIs, 'btnErase') % Erase mode
        handles.Color = 17;
        guidata(handles.Pellet, handles);        
    else
        break
    end
    [X,Y,BUTTON] = ginput(1);
end
handles.CData = Picture2CData(handles.Picture);
guidata(handles.Pellet, handles);





% --- Executes on button press in btnClear.
function btnClear_Callback(hObject, eventdata, handles)
% hObject    handle to btnClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PutIcon('clear', handles);



% --------------------------------------------------------------------
function mnuFileSave_Callback(hObject, eventdata, handles)
% hObject    handle to mnuFileSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 [filename, pathname] = uiputfile({'*.mat'},'Save as');
 if isequal(filename,0) | isequal(pathname,0)
     return
 end
 if length(filename) < 4 || ~isequal(filename(end-3:end), '.mat')
     filename = [filename, '.mat'];
 end
 CData = handles.CData; 
 Picture = handles.Picture;
 save([pathname, filename], '-mat', 'CData', 'Picture');
 set(handles.textMessage, 'String', 'file saved');

 
 % =================================
 function CData = Picture2CData(Picture)
 
 k = 0;
for y = 1:16
    for x = 1:16
        CData(x,y,:) = ColorMap(Picture(x,y));
    end
end


% --------------------------------------------------------------------
function mnuFileOpen_Callback(hObject, eventdata, handles)
% hObject    handle to mnuFileOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[filename, pathname] = uigetfile({'*.mat'},'Save as');
if isequal(filename,0) | isequal(pathname,0)
    return
end

Picture = [];
load ([pathname, filename], '-mat');
if ~isempty(Picture) && isequal(size(Picture), size(handles.Picture))
    handles.Picture = Picture;
    handles.CData = Picture2CData(handles.Picture);
    axes(handles.axes1); % make canvas active
    cla; % clear figure
    for x = 1:16
        for y = 1:16
            PaintRectangle (x-1,y-1,handles.Picture(17-y,x),16);
        end
    end
    
    guidata(handles.axes1, handles);
end


% --- Executes on button press in btnHelp.
function btnHelp_Callback(hObject, eventdata, handles)
% hObject    handle to btnHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp(' ')
disp(' ')
disp(' Draw desire button icon using ''iconwz''.')
disp(' Click ''Pen'' icon.')
disp(' Select pen color in color pellet.')
disp(' Draw image on convas.')
disp(' If you want some idea of how to draw an image click preset icon image.')
disp(' Click ''Done'' button after you satistified with the image.')
disp(' A variable ''CData'' was created in workspace.')
disp(' Open your GUI figure in GUIDE or create a new GUI.')
disp(' Draw a push button of size 24x24 pixels.')
disp(' Clear ''String'' properties of the push button and')
disp(' type ''CData'' in CData value of the push button.')
disp(' Run it. You should see the image on the button.')
disp(' Inspect this code for advance usages.')
disp(' Done.')
disp(' ')

set(handles.textMessage, 'String', 'See help text in command window');


% --- Executes on button press in pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


