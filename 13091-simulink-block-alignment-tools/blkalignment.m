function varargout = blkalignment(varargin)
%
% The Simulink Alignment is used to Align blocks in Simulink
% 
% version 1.0
% Po.Hu@bhtc.com
% 15.11.2006
%

%BLKALIGNMENT M-file for blkalignment.fig
%      BLKALIGNMENT, by itself, creates a new BLKALIGNMENT or raises the existing
%      singleton*.
%
%      H = BLKALIGNMENT returns the handle to a new BLKALIGNMENT or the handle to
%      the existing singleton*.
%
%      BLKALIGNMENT('Property','Value',...) creates a new BLKALIGNMENT using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to blkalignment_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      BLKALIGNMENT('CALLBACK') and BLKALIGNMENT('CALLBACK',hObject,...) call the
%      local function named CALLBACK in BLKALIGNMENT.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help blkalignment

% Last Modified by GUIDE v2.5 02-Nov-2006 21:14:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @blkalignment_OpeningFcn, ...
    'gui_OutputFcn',  @blkalignment_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
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


% --- Executes just before blkalignment is made visible.
function blkalignment_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for blkalignment
% handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes blkalignment wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = blkalignment_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;


% --- Executes on button press in aVt2Left.
function aVt2Left_Callback(hObject, eventdata, handles)
% hObject    handle to aVt2Left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

slblk = getSelectedBlkHandles(gcb);
if slblk.blkno > 1
    slblk = getSelectedBlkPositions(slblk);

    % set new position of blocks
    %==========================================================================
    % in this alignment to Vertical Left case, every block take the MOST LEFT
    % block's x of the left upper corner, size of the blocks is not changed.
    % i.e. the x static_length and y width of the each block remain the same.
    %==========================================================================

    for i = 1:slblk.blkno
        % x is the min. of x
        x       = slblk.blkMinPosition(1);
        y       = slblk.blkRecalPosition{i}(2);
        xlength = slblk.blkRecalPosition{i}(3);
        ywidth  = slblk.blkRecalPosition{i}(4);

        slblk.blkNewPosition{i} = [x, y, x+xlength, y+ywidth];
        set_param(slblk.blkh{i}, 'Position',slblk.blkNewPosition{i});
    end
    slblk = [];
end

% --- Executes on button press in aVt2Right.
function aVt2Right_Callback(hObject, eventdata, handles)
% hObject    handle to aVt2Right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

slblk = getSelectedBlkHandles(gcb);
if slblk.blkno > 1
    slblk = getSelectedBlkPositions(slblk);

    % set new position of blocks
    %==========================================================================
    % in this alignment to Vertical Right case, every block take the MOST RIGHT
    % block's x of the right lower corner, size of the blocks is not changed.
    % i.e. the x static_length and y width of the each block remain the same.
    %==========================================================================

    for i = 1:slblk.blkno
        % x is the max. of x
        x       = slblk.blkMaxPosition(1);
        y       = slblk.blkRecalPosition{i}(2);
        xlength = slblk.blkRecalPosition{i}(3);
        ywidth  = slblk.blkRecalPosition{i}(4);

        slblk.blkNewPosition{i} = [x-xlength, y, x-xlength+xlength, y+ywidth];
        set_param(slblk.blkh{i}, 'Position',slblk.blkNewPosition{i});
    end
    slblk = [];
end

% --- Executes on button press in aHz2Bottom.
function aHz2Bottom_Callback(hObject, eventdata, handles)
% hObject    handle to aHz2Bottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

slblk = getSelectedBlkHandles(gcb);
if slblk.blkno > 1
    slblk = getSelectedBlkPositions(slblk);

    % set new position of blocks
    %==========================================================================
    % in this alignment to Horizontal Bottom case, every block take the MOST BOTTOM
    % block's y of the lower left corner, size of the blocks is not changed.
    % i.e. the x static_length and y width of the each block remain the same.
    %==========================================================================

    for i = 1:slblk.blkno
        % y is the max. of y
        x       = slblk.blkRecalPosition{i}(1);
        y       = slblk.blkMaxPosition(2);
        xlength = slblk.blkRecalPosition{i}(3);
        ywidth  = slblk.blkRecalPosition{i}(4);

        slblk.blkNewPosition{i} = [x, y-ywidth, x+xlength, y-ywidth+ywidth];
        set_param(slblk.blkh{i}, 'Position',slblk.blkNewPosition{i});
    end
    slblk = [];
end

% --- Executes on button press in aHz2Top.
function aHz2Top_Callback(hObject, eventdata, handles)
% hObject    handle to aHz2Top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

slblk = getSelectedBlkHandles(gcb);
if slblk.blkno > 1
    slblk = getSelectedBlkPositions(slblk);

    % set new position of blocks
    %==========================================================================
    % in this alignment to Horizontal Top case, every block take the MOST TOP
    % block's y of the upper right corner, size of the blocks is not changed.
    % i.e. the x static_length and y width of the each block remain the same.
    %==========================================================================

    for i = 1:slblk.blkno
        % y is the max. of y
        x       = slblk.blkRecalPosition{i}(1);
        y       = slblk.blkMinPosition(2);
        xlength = slblk.blkRecalPosition{i}(3);
        ywidth  = slblk.blkRecalPosition{i}(4);

        slblk.blkNewPosition{i} = [x, y, x+xlength, y+ywidth];
        set_param(slblk.blkh{i}, 'Position',slblk.blkNewPosition{i});
    end
    slblk = [];
end

% --- Executes on button press in aVt2Center.
function aVt2Center_Callback(hObject, eventdata, handles)
% hObject    handle to aVt2Center (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


slblk = getSelectedBlkHandles(gcb);
if slblk.blkno > 1
    slblk = getSelectedBlkPositions(slblk);

    % set new position of blocks
    %==========================================================================
    % in this alignment to Vertical Center case, every block take the MOST TOP
    % block's MIDDLE x position, size of the blocks is not changed.
    % i.e. the x static_length and y width of the each block remain the same.
    %==========================================================================

    for i = 1:slblk.blkno
        % middle x position of the most top block
        minYidx = slblk.blkMinPositionIdx(2);
        XofminY = slblk.blkRecalPosition{minYidx}(1); % find the x value of block who has minY
        minhalfxlength = slblk.blkRelativeMiddlePosition{minYidx}(1); % middle x position of the MOST TOP block

        halfxlength = slblk.blkRelativeMiddlePosition{i}(1); % middle x position of current block

        xlength = slblk.blkRecalPosition{i}(3);
        ywidth  = slblk.blkRecalPosition{i}(4);
        x       = XofminY + minhalfxlength - halfxlength;
        if x < 15
            x = 15; % limitation of the window.
        end
        y       =  slblk.blkRecalPosition{i}(2);
        if y < 15
            y = 15; % limitation of the window.
        end

        slblk.blkNewPosition{i} = [x, y, x+xlength, y+ywidth];
        set_param(slblk.blkh{i}, 'Position',slblk.blkNewPosition{i});
    end
    slblk = [];
end

% --- Executes on button press in aHz2Center.
function aHz2Center_Callback(hObject, eventdata, handles)
% hObject    handle to aHz2Center (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
slblk = getSelectedBlkHandles(gcb);
if slblk.blkno > 1
    slblk = getSelectedBlkPositions(slblk);

    % set new position of blocks
    %==========================================================================
    % in this alignment to Vertical Center case, every block take the MOST TOP
    % block's MIDDLE x position, size of the blocks is not changed.
    % i.e. the x static_length and y width of the each block remain the same.
    %==========================================================================

    for i = 1:slblk.blkno
        % middle x position of the most top block
        minXidx = slblk.blkMinPositionIdx(1);
        YofminX = slblk.blkRecalPosition{minXidx}(2); % find the y value of block who has minX
        minhalfywidth = slblk.blkRelativeMiddlePosition{minXidx}(2); % middle x position of the MOST TOP block

        halfywidth = slblk.blkRelativeMiddlePosition{i}(2); % middle x position of current block

        xlength = slblk.blkRecalPosition{i}(3);
        ywidth  = slblk.blkRecalPosition{i}(4);
        x       = slblk.blkRecalPosition{i}(1);
        if x < 15
            x = 15; % limitation of the window.
        end
        y       =  YofminX + minhalfywidth - halfywidth;
        if y < 15
            y = 15; % limitation of the window.
        end

        slblk.blkNewPosition{i} = [x, y, x+xlength, y+ywidth];
        set_param(slblk.blkh{i}, 'Position',slblk.blkNewPosition{i});
    end
    slblk = [];
end

% --- Executes on button press in aHz2Same.
function aHz2Same_Callback(hObject, eventdata, handles)
% hObject    handle to aHz2Same (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

slblk = getSelectedBlkHandles(gcb);
if slblk.blkno > 1
    slblk = getSelectedBlkPositions(slblk);

    % set new position of blocks
    %==========================================================================
    % in this alignment to Horizontal to Same, every block take the MOST TOP
    % block's x static_length, y width of the blocks is not changed.
    % position of the block is also not changed.
    %==========================================================================

    for i = 1:slblk.blkno

        x = slblk.blkRecalPosition{i}(1);
        y = slblk.blkRecalPosition{i}(2);
        % static_length of MOST TOP block
        minYidx = slblk.blkMinPositionIdx(2);
        xlengthofminY = slblk.blkRecalPosition{minYidx}(3);
        xlength = xlengthofminY;
        ywidth = slblk.blkRecalPosition{i}(4);

        slblk.blkNewPosition{i} = [x, y, x+xlength, y+ywidth];
        set_param(slblk.blkh{i}, 'Position',slblk.blkNewPosition{i});
    end
    slblk = [];
end

% --- Executes on button press in aVt2Same.
function aVt2Same_Callback(hObject, eventdata, handles)
% hObject    handle to aVt2Same (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

slblk = getSelectedBlkHandles(gcb);
if slblk.blkno > 1
    slblk = getSelectedBlkPositions(slblk);

    % set new position of blocks
    %==========================================================================
    % in this alignment to Horizontal to Same, every block take the MOST TOP
    % block's x static_length, y width of the blocks is not changed.
    % position of the block is also not changed.
    %==========================================================================

    for i = 1:slblk.blkno

        x = slblk.blkRecalPosition{i}(1);
        y = slblk.blkRecalPosition{i}(2);
        xlength = slblk.blkRecalPosition{i}(3);
        % width of MOST Left block
        minXidx = slblk.blkMinPositionIdx(1);
        ywidthofminX = slblk.blkRecalPosition{minXidx}(4);
        ywidth = ywidthofminX;


        slblk.blkNewPosition{i} = [x, y, x+xlength, y+ywidth];
        set_param(slblk.blkh{i}, 'Position',slblk.blkNewPosition{i});
    end
    slblk = [];
end

% --- Executes on button press in aHzVt2Large.
function aHzVt2Large_Callback(hObject, eventdata, handles)
% hObject    handle to aHzVt2Large (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

slblk = getSelectedBlkHandles(gcb);
if slblk.blkno > 1
    slblk = getSelectedBlkPositions(slblk);

    % set new position of blocks
    %==========================================================================
    % in this alignment to Horizontal and vertical to Large, every block
    % take the MOST BIG block's x static_length and y width, the most big means
    % max(xlength*ywidth), the position of the blocks are also not changed.
    %==========================================================================

    for i = 1:slblk.blkno

        x = slblk.blkRecalPosition{i}(1);
        y = slblk.blkRecalPosition{i}(2);
        xlength = slblk.blkRecalPosition{slblk.blkMaxAreaIdx}(3);
        ywidth = slblk.blkRecalPosition{slblk.blkMaxAreaIdx}(4);

        slblk.blkNewPosition{i} = [x, y, x+xlength, y+ywidth];
        set_param(slblk.blkh{i}, 'Position',slblk.blkNewPosition{i});
    end
    slblk = [];
end

% % % --- Executes on button press in aHzVt2Small.
% % function aHzVt2Small_Callback(hObject, eventdata, handles)
% % % hObject    handle to aHzVt2Small (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in dVt.
function dVt_Callback(hObject, eventdata, handles)
% hObject    handle to dVt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
slblk = getSelectedBlkHandles(gcb);
if slblk.blkno > 2 % distribution at lease 3 blocks are selected
    slblk = getSelectedBlkPositions(slblk);

    % set new position of blocks
    %======================================================================
    % in this distribution in vertical, every block except the MOST TOP and
    % MOST BOTTOM will distributed with the same length in between. The
    % middle positions of them are the references for each block.
    %======================================================================
    
    % for ascending sorted y, the first is the minY and the last is maxY,
    % what we consider is only the block in between. i.e. 2:slblk.blkno-1
    for i = 2:slblk.blkno-1
        x = slblk.blkRecalPosition{slblk.blkSortedYPosition{2}(i)}(1);
        y = slblk.blkRecalPosition{slblk.blkSortedYPosition{2}(1)}(2)+...
            slblk.blkRelativeMiddlePosition{slblk.blkSortedYPosition{2}(1)}(2)+...
            (i-1)*slblk.blkdVt{2};
        
        halfywidth = slblk.blkRelativeMiddlePosition{slblk.blkSortedYPosition{2}(i)}(2);
        xlength = slblk.blkRecalPosition{slblk.blkSortedYPosition{2}(i)}(3);
                
        slblk.blkNewPosition{i} = [x, y-halfywidth, x+xlength, y+halfywidth];
        set_param(slblk.blkh{slblk.blkSortedYPosition{2}(i)},...
            'Position',slblk.blkNewPosition{i});
    end
end
slblk = [];


% --- Executes on button press in dHz.
function dHz_Callback(hObject, eventdata, handles)
% hObject    handle to dHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
slblk = getSelectedBlkHandles(gcb);
if slblk.blkno > 2 % distribution at lease 3 blocks are selected
    slblk = getSelectedBlkPositions(slblk);

    % set new position of blocks
    %======================================================================
    % in this distribution in Horizontal, every block except the MOST LEFT 
    % and MOST RIGHT will distributed with the same length in between. The
    % middle positions of them are the references for each block.
    %======================================================================
    
    % for ascending sorted x, the first is the minX and the last is maxX,
    % what we consider is only the block in between. i.e. 2:slblk.blkno-1
    for i = 2:slblk.blkno-1
        y = slblk.blkRecalPosition{slblk.blkSortedXPosition{2}(i)}(2);
        x = slblk.blkRecalPosition{slblk.blkSortedXPosition{2}(1)}(1)+...
            slblk.blkRelativeMiddlePosition{slblk.blkSortedXPosition{2}(1)}(1)+...
            (i-1)*slblk.blkdHz{2};
        
        halfxlength = slblk.blkRelativeMiddlePosition{slblk.blkSortedXPosition{2}(i)}(1);
        ywidth = slblk.blkRecalPosition{slblk.blkSortedYPosition{2}(i)}(4);
                
        slblk.blkNewPosition{i} = [x-halfxlength, y, x+halfxlength, y+ywidth];
        set_param(slblk.blkh{slblk.blkSortedXPosition{2}(i)},...
            'Position',slblk.blkNewPosition{i});
    end
end
slblk = [];


function blklength_Callback(hObject, eventdata, handles)
% hObject    handle to blklength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blklength as text
%        str2double(get(hObject,'String')) returns contents of blklength as a double
len_string = get(hObject,'String');
if isempty(len_string)
    % do nothing
else
    length = str2num(len_string);
    if isempty(length)
        errordlg('Please enter the integer value of length!')
    end
    length = round(length);
    set(hObject,'String',num2str(length));
end

% check length and width is not 0 or [], enable "Retrieve" button.
len = str2num(get(handles.blklength,'String'));
wid = str2num(get(handles.blkwidth,'String'));

if ((isempty(len)) + (isempty(wid))) > 0
    % button retrieve stays disable or set to disable
    set(handles.blksize_retrieve,'Enable','off');
elseif (len == 0) || (wid == 0)
    % button retrieve stays disable or set to disable
    set(handles.blksize_apply,'Enable','off');
else
    set(handles.blksize_apply, 'Enable', 'on');
end


% --- Executes during object creation, after setting all properties.
function blklength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blklength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function blkwidth_Callback(hObject, eventdata, handles)
% hObject    handle to blkwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blkwidth as text
%        str2double(get(hObject,'String')) returns contents of blkwidth as a double
wid_string = get(hObject,'String');
if isempty(wid_string)
    % do nothing
else
    width = str2num(wid_string);
    if isempty(width)
        errordlg('Please enter the integer value of width!')
    end
    width = round(width);
    set(hObject,'String',num2str(width));
end

% check length and width is not 0 or [], enable "Retrieve" button.
len = str2num(get(handles.blklength,'String'));
wid = str2num(get(handles.blkwidth,'String'));

if ((isempty(len)) + (isempty(wid))) > 0
    % button retrieve stays disable or set to disable
    set(handles.blksize_retrieve,'Enable','off');
elseif (len == 0) || (wid == 0)
    % button retrieve stays disable or set to disable
    set(handles.blksize_apply,'Enable','off');
else
    set(handles.blksize_apply, 'Enable', 'on');
end


% --- Executes during object creation, after setting all properties.
function blkwidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blkwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in blksize_apply.
function blksize_apply_Callback(hObject, eventdata, handles)
% hObject    handle to blksize_apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get selected blocks
slblk = getSelectedBlkHandles(gcb);
if slblk.blkno > 0 && isfield(slblk,'blk')
    slblk = getSelectedBlkPositions(slblk);

    % get user defined length and width
    len = str2num(get(handles.blklength,'String'));
    wid = str2num(get(handles.blkwidth,'String'));

    % enable retrieve button when apply button is pushed.
    set(handles.blksize_retrieve,'Enable','on');

    % original block size save to UserData of button blksize_retrieve
    set(handles.blksize_retrieve,'UserData',slblk);

    % set new position of blocks
    for i = 1:slblk.blkno
        x = slblk.blkRecalPosition{i}(1);
        y = slblk.blkRecalPosition{i}(2);
        xlength = len;
        ywidth = wid;
        slblk.blkNewPosition{i} = [x, y, x+xlength, y+ywidth];
        set_param(slblk.blkh{i}, 'Position',slblk.blkNewPosition{i});
    end
    slblk = [];
end




% --- Executes on button press in blksize_retrieve.
function blksize_retrieve_Callback(hObject, eventdata, handles)
% hObject    handle to blksize_retrieve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get save the data from UserData
saved_slblk = get(hObject, 'UserData');
slblk = getSelectedBlkPositions(saved_slblk);
for i = 1:saved_slblk.blkno
    x = slblk.blkposition{i}(1); %actual position
    y = slblk.blkposition{i}(2); %actual position
    xlength = saved_slblk.blkRecalPosition{i}(3);
    ywidth = saved_slblk.blkRecalPosition{i}(4);
    
    retrieve_blkposition{i} = [x, y, x+xlength, y+ywidth];
    set_param(saved_slblk.blkh{i}, 'Position', retrieve_blkposition{i});
end
% empty UserData and disable retrieve button
set(hObject,'UserData',[]);
set(hObject,'Enable','off');






%=========================================%
%                                         %  
%             --= Private =-              %
%                                         %
%=========================================% 


% get selected block handles
function slblk = getSelectedBlkHandles(sys)
if ~isempty(sys)
    % get parent of current block
    sysParent = get_param(sys,'Parent');

    slblk.blktemp = find_system(sysParent,'SearchDepth',1,'Selected','on');
    slblk.blkno = length(slblk.blktemp);

    % check if the parent block is include.
    a = 1;
    for i = 1:slblk.blkno
        if strcmp(sysParent, slblk.blktemp{i}) ~= 1
            slblk.blk{a} = slblk.blktemp{i};
            a = a+1;
        end
    end
    if isfield(slblk,'blk')
        slblk.blkh = get_param(slblk.blk,'Handle');
        slblk.blkno = length(slblk.blkh);
    end
else
    slblk.blkno = 0;
end


% get selected block positions
function slblk = getSelectedBlkPositions(slblk)


% get the position of each block
slblk.blkposition = get_param(slblk.blk,'Position');
% recalculate the position as
% [x left upper corner, y left upper corner,
%  static_length in x direction, width in y direction]
for i = 1:slblk.blkno

    x(i)           = slblk.blkposition{i}(1); % upper left corner
    y(i)           = slblk.blkposition{i}(2); % upper left corner
    xlength(i)     = slblk.blkposition{i}(3) - x(i);
    ywidth(i)      = slblk.blkposition{i}(4) - y(i);
    halfxlength(i) = round(xlength(i)/2); % center of block
    halfywidth(i)  = round(ywidth(i)/2);  % center of block
    blkarea(i)     = xlength(i)*ywidth(i); % area of the block

    x2(i) = x(i) + xlength(i); % lower right corner
    y2(i) = y(i) + ywidth(i);  % upper left corner

    slblk.blkRecalPosition{i,1} = [x(i), y(i), xlength(i), ywidth(i)];
    slblk.blkRelativeMiddlePosition{i,1} = [halfxlength(i), halfywidth(i)];
    slblk.blkAreaOfBlock{i,1} = blkarea(i);
end

% find max. and min. of x(i), y(i), xlength(i), ywidth(i) for further use
% ==========================================
% min_X x(i)           min_Y y2(i)
%   +-------------------+
%   |     xlength       |
%   |                   |
%   |ywidth             + halfywidth
%   |                   |
%   |    halfxlength    |
%   +---------+---------+
% max_Y y2(i)          max_X x2(i)
% ==========================================
[maxX, maxXidx] = max(x2); % max x is the x on the lower right corner
[minX, minXidx] = min(x);  % min x is the x on the upper left corner

[maxY, maxYidx] = max(y2);  % max y is the y on the lower left corner
[minY, minYidx] = min(y); % min y is the y on the upper right corner

maxXlength = max(xlength);
minXlength = min(xlength);

maxYwidth = max(ywidth);
minYwidth = min(ywidth);

[maxArea, maxAreaidx] = max(blkarea);
[minArea, minAreaidx] = min(blkarea);
if length(maxAreaidx) > 1
    % if two blocks with same MAX AREA but xlength, ywidth are different, the max
    % area is belong to the block who has the most minimum Y, i.e. minY
    % the most top position
    yValue = y(maxAreaidx(1));
    for i = 2:length(maxAreaidx)
        yValue = [yValue, y(maxAreaidx(i))];
    end
    [yOfMaxArea, yOfMaxAreaidx] = min(yValue);
    maxAreaidx = yValue(yOfMaxAreaidx);
    maxArea = blkarea(maxAreaidx);
end

if length(minAreaidx) > 1
    % if two blocks with same MIN AREA but xlength, ywidth are different, the max
    % area is belong to the block who has the most minimum X, i.e. minX of the
    % block which has min area the most left position
    xValue = x(minAreaidx(1));
    for i = 2:length(minAreaidx)
        xValue = [xValue, x(minAreaidx(i))];
    end
    [xOfMinArea, xOfMinAreaidx] = min(xValue);
    minAreaidx = xValue(xOfMinAreaidx);
    minArea = blkarea(minAreaidx);
end
slblk.blkMaxPosition    = [maxX, maxY, maxXlength, maxYwidth];
slblk.blkMaxPositionIdx = [maxXidx, maxYidx];
slblk.blkMinPosition    = [minX, minY, minXlength, minYwidth];
slblk.blkMinPositionIdx = [minXidx, minYidx];
slblk.blkMaxArea        = [maxArea];
slblk.blkMaxAreaIdx     = [maxAreaidx];
slblk.blkMinArea        = [minArea];
slblk.blkMinAreaIdx     = [minAreaidx];


% Distribution range
%
% +-------------------+
% |                   |
% |                   + ------------------+
% |                   |                   |
% +-------------------+                   |
%                                         |
%                                         |
%                                         |
%  +-----------------+                    |
%  |                 |                    |
%  |                 +                    \
%  |                 |                     - Distribution Range
%  +-----------------+                    /
%                                         |
%         .                               |
%         .                               |
%         .                               |
%                                         |
% +-------------------+                   |
% |                   |                   |
% |                   +-------------------+
% |                   |
% +-------------------+
% the vetical range to distribute 
dVtRange = maxY-slblk.blkRelativeMiddlePosition{maxYidx,1}(2)...
    -minY-slblk.blkRelativeMiddlePosition{minYidx,1}(2);

% lenght of between blocks.
dVtlength = round(dVtRange/(slblk.blkno-1));

slblk.blkdVt = [{dVtRange},{dVtlength}];

% the horizontal range to distribute
dHzRange = maxX-slblk.blkRelativeMiddlePosition{maxXidx,1}(1)...
    -minX-slblk.blkRelativeMiddlePosition{minXidx,1}(1);

% lenght of between blocks.
dHzlength = dHzRange/(slblk.blkno-1);

slblk.blkdHz = [{dHzRange},{dHzlength}];

% sort x, y for new ascending order
[ysort,IY] = sort(y); % ysort is the new ascending order, 
                      % IY is the position of the value before
[xsort,IX] = sort(x); % same as above.

slblk.blkSortedYPosition = [{ysort};{IY}];
slblk.blkSortedXPosition = [{xsort};{IX}];



