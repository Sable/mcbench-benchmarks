function varargout = OceanMap(varargin)

%OceanMap - GUI: Manually input values of an m x n matrix and save as *.MAT file.
%
% Syntax:
%       OCEANMAP, by itself, creates a new OCEANMAP or raises the existing
%       singleton*.
%
%       H = OCEANMAP returns the handle to a new OCEANMAP or the handle to
%       the existing singleton*.
%
%       OCEANMAP('CALLBACK',hObject,eventData,handles,...) calls the local
%       function named CALLBACK in OCEANMAP.M with the given input arguments.
%
%       OCEANMAP('Property','Value',...) creates a new OCEANMAP or raises the
%       existing singleton*.  Starting from the left, property value pairs are
%       applied to the GUI before OceanMap_OpeningFunction gets called.  An
%       unrecognized property name or invalid value makes property application
%       stop.  All inputs are passed to OceanMap_OpeningFcn via varargin.
%
%       *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%       instance to run (singleton)".
%
% Inputs:
%       none
%
% Outputs:
%       saved file (*.MAT) containing m x n array
%
% Example: 
%       Not really applicable- load the GUI and see!
%
% Notes:
%       The number of rows and columns can be updated actively, without
%       losing data already contained in the matrix
%
%       You should call OceanMap from the command line, as clicking on the 
%       .fig file doesnt work: The ActiveX FlexArray doesn't initialise.
%
%       Currently, Multidimensional Arrays are not supported... I'd be
%       pleased to hear if anyone modifies the software for extra
%       dimensions.
%
%       The output matrix DOES NOT CONTAIN row and column numbers
%
% Background Information:
%       OceanMap was originally created for the purpose of tracking a 
%       submersible vehicle using a grid painted onto the floor of a water 
%       tank. Technicians use this software to input the grid pattern 
%       painted and convert it to matrix form. Other software performed 
%       postprocessing to find the submarine's path by comparing grid 
%       numbers (recorded by the sub's onboard camera) and comparing them 
%       to the output matrix from OceanMap.
%
%       Clearly, this software can be used for far less specialised purposes.

% Other m-files required: 
%       none
%
% Subfunctions: 
%       All create-fcns and callbacks etc associated with GUI Objects (see Help GUIDE)
%       labelupdate(handles) 
%                           - refreshes row/column numbering
%       savethedamnfile(filename, savethismatrix) 
%                           - saves file according to filename input in GUI
%       
% Files required: 
%       OceanMap.m OceanMap.fig OceanMap_activex1
%
% See also: 
%       GridNav GUI file (for postprocessing of results)
%       GUIDE, GUIDATA, GUIHANDLES
%
% Author: Thomas Clark, B.A.(Cantab) General Engineering
% email address: thc29@cam.ac.uk
% Created August 2005; Last revision: 25-August-2005
% Using Matlab 7.0.1.24704 (R14) Service Pack 1
%
% Thanks to Denis Gilbert (Maurice Lamontagne Institute, Dept. of Fisheries 
% and Oceans Canada) for header file format (from www.mathworks.com).
%
% GUI Initialisation code Copyright 2002-2003 The MathWorks, Inc.

% --------------------------BEGIN CODE-------------------------------------------------------BEGIN CODE

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OceanMap_OpeningFcn, ...
                   'gui_OutputFcn',  @OceanMap_OutputFcn, ...
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


% -------------------------OPENING FUNCTION----------------------------------------OPENING FUNCTION (inc. activex1)

% --- Executes just before OceanMap is made visible.-

function OceanMap_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OceanMap (see VARARGIN)

% Choose default command line output for OceanMap
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OceanMap wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Initialising row and column numbers
labelupdate(handles);

% initialising global variables
global NUMROWS
NUMROWS = 200;
global NUMCOLS
NUMCOLS = 200;



% ------------------LABELLING UPDATE FUNCTION-------------------------------------------LABELLING UPDATE FUNCTION
function labelupdate(handles)

% Label the rows
set(handles.activex1,'Col',0);
for k=1:get(handles.activex1,'Rows')-1
    set(handles.activex1,'Row',k);
    set(handles.activex1,'Text',['Row ' num2str(k)]);
end;

% Label the Columns
k = 0;
set(handles.activex1,'Row',0);
set(handles.activex1,'Col',0);
set(handles.activex1,'Text','Column #:');
for k = 1:get(handles.activex1,'Cols')-1
    set (handles.activex1,'Col',k);
    set (handles.activex1,'Text',[num2str(k)]);
end;

% --- Outputs from this function are returned to the command line.
function varargout = OceanMap_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% ------------------FILENAME TEXT BOX 'EDIT 1'-------------------------------------------FILENAME EDIT TEXT BOX

function fileditbox_Callback(hObject, eventdata, handles)
% hObject    handle to fileditbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fileditbox as text
%        str2double(get(hObject,'String')) returns contents of fileditbox as a double

global FILENAME;
FILENAME = get(hObject,'String');


% --- Executes during object creation, after setting all properties.
function fileditbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileditbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

global FILENAME;
FILENAME = get(hObject,'String');

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), ...
                                get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% -------------------DATA EXPORT-----------------------------------------------------------------DATA EXPORT

% --- Executes on button press in exportbutton.
function exportbutton_Callback(hObject, eventdata, handles)
% hObject    handle to exportbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Recalling the desired filename in double format from the Edit1 textbox
global FILENAME;

% Initialising the OceanMap storage matrix:
gridmatrix = zeros([get(handles.activex1,'rows')-1],...
                                    [get(handles.activex1,'Cols')-1]);

% Obtaining and storing the OceanMap pattern (excluding row and col #s).
%   N.B. Null entries returned as 0, Invalid Entries as NaN
%        No imaginary numbers used. i,j, are scratch variables.

for i = 2:get(handles.activex1,'Cols') % For Loop 1
    for j = 2:get(handles.activex1,'rows') % For Loop 2
        set(handles.activex1,'Col',(i-1));
        set(handles.activex1,'Row',(j-1));
        gridmatrix((j-1),(i-1)) =  get(handles.activex1,'Value');
    end; % End For 2
end; %End For 1

savethefile(FILENAME,gridmatrix);

% Saving the variable gridmatrix in a .m file corresponding to the input
% filename.
function savethefile(filename,savethismatrix)

save(filename, 'savethismatrix');


% -------------------------OPTIONS PANEL------------------------------------------------------OPTIONS PANEL

function rowseditbox_Callback(hObject, eventdata, handles)
% hObject    handle to rowseditbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rowseditbox as text
%        str2double(get(hObject,'String')) returns contents of rowseditbox as a double
global NUMROWS
NUMROWS = str2num(get(hObject,'String'))+1;

% --- Executes during object creation, after setting all properties.
function rowseditbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rowseditbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
                                get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function colseditbox_Callback(hObject, eventdata, handles)
% hObject    handle to colseditbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of colseditbox as text
%        str2double(get(hObject,'String')) returns contents of colseditbox as a double
global NUMCOLS
NUMCOLS = str2num(get(hObject,'String'))+1;

% --- Executes during object creation, after setting all properties.
function colseditbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colseditbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
                                get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in updatebutton.
function updatebutton_Callback(hObject, eventdata, handles)
% hObject    handle to updatebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update the number of columns and rows in the table
global NUMCOLS
global NUMROWS
set(handles.activex1,'Rows', NUMROWS);
set(handles.activex1,'Cols', NUMCOLS);
labelupdate(handles);

% -------------------------END OF CODE-------------------------------------------------------END OF CODE


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over exportbutton.
function exportbutton_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to exportbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


