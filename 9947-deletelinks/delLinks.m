function varargout = delLinks(varargin)
% DELLINKS M-file for delLinks.fig
%      DELLINKS, by itself, creates a new DELLINKS or raises the existing
%      singleton*.
%
%      H = DELLINKS returns the handle to a new DELLINKS or the handle to
%      the existing singleton*.
%
%      DELLINKS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DELLINKS.M with the given input arguments.
%
%      DELLINKS('Property','Value',...) creates a new DELLINKS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before delLinks_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to delLinks_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help delLinks

% Last Modified by GUIDE v2.5 26-Oct-2006 13:44:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @delLinks_OpeningFcn, ...
                   'gui_OutputFcn',  @delLinks_OutputFcn, ...
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


% --- Executes just before delLinks is made visible.
function delLinks_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to delLinks (see VARARGIN)

% Choose default command line output for delLinks
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes delLinks wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = delLinks_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function EdSelectedSubsystem_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EdSelectedSubsystem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function EdSelectedSubsystem_Callback(hObject, eventdata, handles)
% hObject    handle to EdSelectedSubsystem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EdSelectedSubsystem as text
%        str2double(get(hObject,'String')) returns contents of EdSelectedSubsystem as a double


% --- Executes on button press in PbSelectSubsystem.
function PbSelectSubsystem_Callback(hObject, eventdata, handles)
% hObject    handle to PbSelectSubsystem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.EdSelectedSubsystem,'String', gcb);

% --- Executes on button press in PbDeleteLinks.
function PbDeleteLinks_Callback(hObject, eventdata, handles)
% hObject    handle to PbDeleteLinks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

NumDelLinks=0;

if (strcmp(get(handles.EdSelectedSubsystem,'String'),'No Selection')==1)
    errordlg('Select a Subsystem first!','No Subsystem Selected');
    return
else
    answer = questdlg('All links in the selected subsystem will be broken! Continue?',...
        get(handles.EdSelectedSubsystem,'String'),'Yes','No','No');
    
    
    if strcmp (answer,'Yes') 
        libs={'dummy'};
        
        while isempty(libs)==0
            libs=find_system(gcb,'LookUnderMasks','all','LinkStatus','resolved');
            libStruct=cell2struct(libs,'libPath',2);
            cntLibPath=size(libStruct);
            
            for i=1:cntLibPath(1)
                set_param(libStruct(i).libPath,'LinkStatus','none');
                NumDelLinks=NumDelLinks+1;
            end
        end
        warndlg([num2str(NumDelLinks) ,' link(s) broken. Changes take effect after you have saved the model!'],'Links broken');
        return;
    else
        return ;
    end;
end;
%if needed:
%LinkStatus 'resolved' = Library Link active
%LinkStatus 'inactive' = Library Link disabled
%LinkStatus 'none' = Library Link broken 
