function varargout = EMFieldLoopDemo(varargin)
% EMFIELDLOOPDEMO M-file for EMFieldLoopDemo.fig
%      EMFIELDLOOPDEMO, by itself, creates a new EMFIELDLOOPDEMO or raises the existing
%      singleton*.
%
%      H = EMFIELDLOOPDEMO returns the handle to a new EMFIELDLOOPDEMO or the handle to
%      the existing singleton*.
%
%      EMFIELDLOOPDEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EMFIELDLOOPDEMO.M with the given input arguments.
%
%      EMFIELDLOOPDEMO('Property','Value',...) creates a new EMFIELDLOOPDEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EMFieldLoopDemo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EMFieldLoopDemo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EMFieldLoopDemo

% Last Modified by GUIDE v2.5 07-Oct-2008 08:05:11

% Copyright 2008 - 2009 The MathWorks, Inc.
%
% Auth/Revision:
%   The MathWorks Consulting Group
%   $Author: rjackey $
%   $Revision: 67 $  $Date: 2009-02-11 10:09:48 -0500 (Wed, 11 Feb 2009) $
% -------------------------------------------------------------------------

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EMFieldLoopDemo_OpeningFcn, ...
                   'gui_OutputFcn',  @EMFieldLoopDemo_OutputFcn, ...
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


% --- Executes just before EMFieldLoopDemo is made visible.
function EMFieldLoopDemo_OpeningFcn(hObject, eventdata, handles, varargin)  %#ok<INUSD,INUSL,DEFNU> 
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EMFieldLoopDemo (see VARARGIN)

% Choose default command line output for MainFig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Initialize the GUI (Bring in data and populate)
InitGUI(handles);


% --- Outputs from this function are returned to the command line.
function varargout = EMFieldLoopDemo_OutputFcn(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU> 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in Waveform_PUP.
function Waveform_PUP_Callback(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to Waveform_PUP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Waveform_PUP contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Waveform_PUP

% Get handle to the main figure
hFigure = handles.MainFig;

% Get the new value
NewValue = get(hObject,'Value');

% Set the new value
setappdata(hFigure,'WaveForm',NewValue);

% Refresh the GUI
RefreshGUI(handles);


% --- Executes during object creation, after setting all properties.
function Waveform_PUP_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to Waveform_PUP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CoilOn_CKB.
function CoilOn_CKB_Callback(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to CoilOn_CKB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get handle to the main figure
hFigure = handles.MainFig;

% Get the new value
NewValue = get(hObject,'Value');

% Set the new value
setappdata(hFigure,'CoilOn',NewValue);

% Refresh the GUI
RefreshGUI(handles);


% --- Executes on slider movement.
function Current_SLDR_Callback(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to Current_SLDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get handle to the main figure
hFigure = handles.MainFig;

% Get the new value
NewValue = get(hObject,'Value');

% Set the new value
setappdata(hFigure,'CurrentMag',NewValue);

% Refresh the GUI
RefreshGUI(handles);


% --- Executes during object creation, after setting all properties.
function Current_SLDR_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to Current_SLDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function Current_ET_Callback(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to Current_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Current_ET as text
%        str2double(get(hObject,'String')) returns contents of Current_ET as a double


% --- Executes during object creation, after setting all properties.
function Current_ET_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to Current_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function CoilDist_SLDR_Callback(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to CoilDist_SLDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get handle to the main figure
hFigure = handles.MainFig;

% Get the new value
NewValue = get(hObject,'Value');

% Validate and set the new value
if NewValue <= 0
    setappdata(hFigure,'CoilDist',0.01);
elseif NewValue>0 && NewValue<=1
    setappdata(hFigure,'CoilDist',NewValue);
end

% Refresh the GUI
RefreshGUI(handles);


% --- Executes during object creation, after setting all properties.
function CoilDist_SLDR_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to CoilDist_SLDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function CoilDist_ET_Callback(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to CoilDist_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CoilDist_ET as text
%        str2double(get(hObject,'String')) returns contents of CoilDist_ET as a double


% --- Executes during object creation, after setting all properties.
function CoilDist_ET_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to CoilDist_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function CoilWidth_SLDR_Callback(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to CoilWidth_SLDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get handle to the main figure
hFigure = handles.MainFig;

% Get the new value
NewValue = get(hObject,'Value');

% Validate and set the new value
if NewValue>=0 && NewValue<=1
    setappdata(hFigure,'CoilWidth',NewValue);
end

% Refresh the GUI
RefreshGUI(handles);


% --- Executes during object creation, after setting all properties.
function CoilWidth_SLDR_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to CoilWidth_SLDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function CoilHeight_SLDR_Callback(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to CoilHeight_SLDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get handle to the main figure
hFigure = handles.MainFig;

% Get the new value
NewValue = get(hObject,'Value');

% Validate and set the new value
if NewValue>=0 && NewValue<=1
    setappdata(hFigure,'CoilHeight',NewValue);
end

% Refresh the GUI
RefreshGUI(handles);


% --- Executes during object creation, after setting all properties.
function CoilHeight_SLDR_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to CoilHeight_SLDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function CoilWidth_ET_Callback(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to CoilWidth_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CoilWidth_ET as text
%        str2double(get(hObject,'String')) returns contents of CoilWidth_ET as a double


% --- Executes during object creation, after setting all properties.
function CoilWidth_ET_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to CoilWidth_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function CoilHeight_ET_Callback(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to CoilHeight_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CoilHeight_ET as text
%        str2double(get(hObject,'String')) returns contents of CoilHeight_ET as a double


% --- Executes during object creation, after setting all properties.
function CoilHeight_ET_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to CoilHeight_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function CoilR_SLDR_Callback(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to CoilR_SLDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get handle to the main figure
hFigure = handles.MainFig;

% Get the new value
NewValue = get(hObject,'Value');

% Set the new value
setappdata(hFigure,'CoilRExp',NewValue);

% Refresh the GUI
RefreshGUI(handles);

% --- Executes during object creation, after setting all properties.
function CoilR_SLDR_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to CoilR_SLDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function CoilR_ET_Callback(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to CoilR_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CoilR_ET as text
%        str2double(get(hObject,'String')) returns contents of CoilR_ET as a double


% --- Executes during object creation, after setting all properties.
function CoilR_ET_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to CoilR_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when MainFig is resized.
function MainFig_ResizeFcn(hObject, eventdata, handles) %#ok<INUSD,INUSL,DEFNU>
% hObject    handle to MainFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check the handles structure
if isempty(handles)
    
    % Do nothing - The ResizeFcn is sometimes called on GUI opening, at
    % which time the handles structure is empty.
    
else % Resize the figure normally
    
    % Set the minimum size of the GUI (pixels)
    MinSize = [650 550];
    
    % Get the figure location
    FigLocation = get(hObject,'Position');
    Width = FigLocation(3);
    Height = FigLocation(4);
    
        % Check that the GUI is at least the minimum size
    if (Width < MinSize(1)) || (Height < MinSize(2))
        Width = max(FigLocation(3),MinSize(1));
        Height = max(FigLocation(4),MinSize(2));
        yNew = FigLocation(2) - (Height - FigLocation(4));
        FigLocation = [FigLocation(1) yNew Width Height];
        set(hObject,'Position',FigLocation);
    end
    
    % Execute drawnow to bring the figure up-to-date
%     drawnow
    
    % Coil-Induced Current Panel - Align to bottom right
    CoilCurrent_PNL_Pos = get(handles.CoilCurrent_PNL,'Position');
    CoilCurrent_PNL_Pos(1) = Width - CoilCurrent_PNL_Pos(3); %align right
    %CoilCurrent_PNL_Pos(2) = ; %leave unchanged
    %CoilCurrent_PNL_Pos(3) = ; %leave unchanged
    %CoilCurrent_PNL_Pos(4) = ; %leave unchanged
    set(handles.CoilCurrent_PNL,'Position',CoilCurrent_PNL_Pos);
    
    % Current Panel - Align to right, above Coil-Induced Current Panel
    Current_PNL_Pos = get(handles.Current_PNL,'Position');
    Current_PNL_Pos(1) = Width - Current_PNL_Pos(3); %align right
    Current_PNL_Pos(2) = CoilCurrent_PNL_Pos(2) + CoilCurrent_PNL_Pos(4); %above other panel
    %Current_PNL_Pos(3) = ; %leave unchanged
    %Current_PNL_Pos(4) = ; %leave unchanged
    set(handles.Current_PNL,'Position',Current_PNL_Pos);

    % Current Axes 1 & 2 - Fill available space, but constrain height
    Current1_AX_TI = get(handles.Current1_AX,'TightInset');
    Current2_AX_TI = get(handles.Current2_AX,'TightInset');
    Current_AX_TI = max(Current1_AX_TI,Current2_AX_TI);
    Current_AX_Pos = get(handles.Current1_AX,'Position');
    Current_AX_Pos(1) = 10 + Current_AX_TI(1);
    Current_AX_Pos(2) = max( (Height-200),...
        ( Current_PNL_Pos(2) + Current_PNL_Pos(4) + Current_AX_TI(2) + 5) );
    Current_AX_Pos(3) = Width - Current_AX_Pos(1) - Current_AX_TI(3) - 10;
    Current_AX_Pos(4) = Height - Current_AX_Pos(2)- Current_AX_TI(4) - 5;
    set([handles.Current1_AX handles.Current2_AX],...
        'Position',Current_AX_Pos);
    
    % Magnetic Field Axes - Fill available space
    if strcmpi(get(handles.MagPlot_AX,'ActivePositionProperty'),'Position')
        MagPlot_AX_TI = get(handles.MagPlot_AX,'TightInset');
        %MagPlot_AX_Pos = get(handles.MagPlot_AX,'Position');
        MagPlot_AX_Pos(1) = 5 + MagPlot_AX_TI(1);
        MagPlot_AX_Pos(2) = 5 + MagPlot_AX_TI(2);
        MagPlot_AX_Pos(3) = Current_PNL_Pos(1) - MagPlot_AX_Pos(1) - ...
            MagPlot_AX_TI(3) - 5;
        MagPlot_AX_Pos(4) = Current_AX_Pos(2) - Current_AX_TI(2) - ...
            MagPlot_AX_Pos(2)- MagPlot_AX_TI(4) - 5;
        set(handles.MagPlot_AX,'Position',MagPlot_AX_Pos);
    else
        %MagPlot_AX_OPos = get(handles.Current1_AX,'OuterPosition');
        MagPlot_AX_OPos(1) = 0;
        MagPlot_AX_OPos(2) = 0;
        MagPlot_AX_OPos(3) = Current_PNL_Pos(1);
        MagPlot_AX_OPos(4) = Current_AX_Pos(2);
        set(handles.MagPlot_AX,'OuterPosition',MagPlot_AX_OPos);
    end
    
end



