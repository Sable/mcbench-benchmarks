function varargout = SelectionGUI(varargin)
% SELECTIONGUI - Select from a list of strings
% -------------------------------------------------------------
% Abstract: This GUI allows you to select from a list of strings, and
% returns the result.  The GUI presents a list of strings on the left pane,
% and allows the user to select them to the right pane.
%
% SelectionIndex = SelectionGUI(List,InitSelectionIndex,guiTitle);
%
% Inputs: 
%   List (cellstr array) - list of items that can be selected
%   SelectionIndex (double array) - Indices of initially selected items
%   guiTitle (char) - Title of the GUI
% 
% Outputs:
%   SelectionIndex (double array) - Indices of final selected items
%
% Examples:
%   States = {'Alaska','Hawaii','Texas','Washington','Washington DC','Florida'}
%   SelectionIndex = SelectionGUI(States,[1 2],'Pick some states')
%
% Notes: If user cancels, SelectionGUI will return zero.

% Copyright 2010 The MathWorks, Inc.
%
% Auth/Revision:
%   The MathWorks Consulting Group
%   $Author: rjackey $
%   $Revision: 280 $  $Date: 2010-07-26 17:00:35 -0700 (Mon, 26 Jul 2010) $
% -------------------------------------------------------------------------

% Edit the above text to modify the response to help SelectionGUI

% Last Modified by GUIDE v2.5 26-Jan-2010 15:01:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SelectionGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SelectionGUI_OutputFcn, ...
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


function SelectionGUI_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<INUSL,INUSL>
% --- Executes just before SelectionGUI is made visible.

% Check input arguments
if length(varargin) < 1
    ItemsList = {};
else
    ItemsList = varargin{1};
end

if length(varargin) < 2
    InitSelectionIndex = [];
else
    InitSelectionIndex = reshape(varargin{2},1,[]);
end

if length(varargin) < 3
    guiTitle = 'Selection Dialog';
else
    guiTitle = varargin{3};
end

% Set the main list of models
setappdata(handles.MainFig, 'ItemsList', ItemsList); 

% Set the output to be the initial selection
setappdata(handles.MainFig, 'OutputList', InitSelectionIndex); 

% Set the title of the GUI
setappdata(handles.MainFig, 'guiTitle', guiTitle); 

%Initialize the GUI
InitGUI(handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
uiwait(handles.MainFig);


function varargout = SelectionGUI_OutputFcn(hObject, eventdata, handles)  %#ok<INUSL,INUSL>
% --- Outputs from this function are returned to the command line.

%Get the handle to the main GUI
hFigure = handles.MainFig;

% Get default command line output from handles structure
varargout{1} = getappdata(hFigure, 'OutputList');

% Close down the GUI
CloseGUI(handles);


function MainFig_CloseRequestFcn(hObject, eventdata, handles)  %#ok<DEFNU,INUSL,INUSL>
% --- Executes when user attempts to close MainFig.

%Get the handle to the main GUI
hFigure = handles.MainFig;

% Allow the GUI's uiwait to stop waiting
uiresume(hFigure);

%Process the figure's close request
FIGURE_CloseRequestFcn(handles)


function OkPB_Callback(hObject, eventdata, handles)  %#ok<DEFNU,INUSL,INUSL>
% --- Executes on button press in OkPB.

% Get the handle to the main GUI
hFigure = handles.MainFig;

% Get the index of selected models
ItemsIdx_R = getappdata(hFigure, 'ItemsIdx_R'); 

% Copy the working variable over to the output variable
setappdata(hFigure, 'OutputList', ItemsIdx_R); 

% Request the figure's close event to fire
close(hFigure);


function CancelPB_Callback(hObject, eventdata, handles)  %#ok<DEFNU,INUSL,INUSL>
% --- Executes on button press in CancelPB.

% Get the handle to the main GUI
hFigure = handles.MainFig;

% Set the output variable to zero
setappdata(hFigure, 'OutputList', 0); 

% Request the figure's close event to fire
close(hFigure);


% --- Executes during object creation, after setting all properties.
function ItemsLeftLB_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU,INUSL,INUSL>
% hObject    handle to ItemsLeftLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes during object creation, after setting all properties.
function ItemsRightLB_CreateFcn(hObject, eventdata, handles)  %#ok<INUSD,DEFNU,INUSL,INUSL>
% hObject    handle to ItemsRightLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes during object creation, after setting all properties.
function SearchET_CreateFcn(hObject, eventdata, handles)  %#ok<INUSD,DEFNU,INUSL,INUSL>
% hObject    handle to SearchET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in SearchPB.
function SearchPB_Callback(hObject, eventdata, handles)  %#ok<DEFNU,INUSL,INUSL>
% hObject    handle to SearchPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the handle to the main GUI
hFigure = handles.MainFig;

% Get the main list of models
ItemsList = getappdata(hFigure, 'ItemsList'); 

% Get the index of selected models
ItemsIdx_L = getappdata(hFigure, 'ItemsIdx_L'); 

% Get the list of models
ItemsList_L = ItemsList(ItemsIdx_L); 

% Get the search string
SearchString = get(handles.SearchET,'String');

% Null the initial set of matches
Value_L = [];

% Find matches for the search string
for i=1:length(ItemsList_L)
    if regexpi(ItemsList_L{i},['.*' SearchString '.*'],'once')
        Value_L(end+1) = i; %#ok<AGROW>
    end
end

% Set the selection of the left listbox
set(handles.ItemsLeftLB,'Value',Value_L);


% --- Executes on button press in ToRightAllPB.
function ToRightAllPB_Callback(hObject, eventdata, handles)  %#ok<DEFNU,INUSL,INUSL>
% hObject    handle to ToRightAllPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the handle to the main GUI
hFigure = handles.MainFig;

% Get the main list of models
ItemsList = getappdata(hFigure, 'ItemsList'); 

% Set the selected models index
ItemsIdx_L = [];
ItemsIdx_R = 1:length(ItemsList);

% Set the index of selected models
setappdata(hFigure, 'ItemsIdx_L', ItemsIdx_L); 
setappdata(hFigure, 'ItemsIdx_R', ItemsIdx_R); 

% Refresh the GUI
RefreshGUI(handles);


% --- Executes on button press in ToRightPB.
function ToRightPB_Callback(hObject, eventdata, handles)  %#ok<DEFNU,INUSL,INUSL>
% hObject    handle to ToRightPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the handle to the main GUI
hFigure = handles.MainFig;

% Get the index of selected models
ItemsIdx_L = getappdata(hFigure, 'ItemsIdx_L'); 
ItemsIdx_R = getappdata(hFigure, 'ItemsIdx_R'); 

% Get the listbox selection indices
Value_L = get(handles.ItemsLeftLB,'Value');

% Set the selected models index
ItemsIdx_R = [ItemsIdx_R, ItemsIdx_L(Value_L)];
ItemsIdx_L(Value_L) = [];

% Set the index of selected models
setappdata(hFigure, 'ItemsIdx_L', ItemsIdx_L); 
setappdata(hFigure, 'ItemsIdx_R', ItemsIdx_R); 

% Refresh the GUI
RefreshGUI(handles);


% --- Executes on button press in ToLeftPB.
function ToLeftPB_Callback(hObject, eventdata, handles)  %#ok<DEFNU,INUSL,INUSL>
% hObject    handle to ToLeftPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the handle to the main GUI
hFigure = handles.MainFig;

% Get the index of selected models
ItemsIdx_L = getappdata(hFigure, 'ItemsIdx_L'); 
ItemsIdx_R = getappdata(hFigure, 'ItemsIdx_R'); 

% Get the listbox selection indices
Value_R = get(handles.ItemsRightLB,'Value');

% Set the selected models index
ItemsIdx_L = [ItemsIdx_L, ItemsIdx_R(Value_R)];
ItemsIdx_R(Value_R) = [];

% Set the index of selected models
setappdata(hFigure, 'ItemsIdx_L', ItemsIdx_L); 
setappdata(hFigure, 'ItemsIdx_R', ItemsIdx_R); 

% Refresh the GUI
RefreshGUI(handles);


% --- Executes on button press in ToLeftAllPB.
function ToLeftAllPB_Callback(hObject, eventdata, handles)  %#ok<DEFNU,INUSL,INUSL>
% hObject    handle to ToLeftAllPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the handle to the main GUI
hFigure = handles.MainFig;

% Get the main list of models
ItemsList = getappdata(hFigure, 'ItemsList'); 

% Set the selected models index
ItemsIdx_L = 1:length(ItemsList);
ItemsIdx_R = [];

% Set the index of selected models
setappdata(hFigure, 'ItemsIdx_L', ItemsIdx_L); 
setappdata(hFigure, 'ItemsIdx_R', ItemsIdx_R); 

% Refresh the GUI
RefreshGUI(handles);

