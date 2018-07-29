function varargout = guiDatePicker(varargin)
% GUIDATEPICKER MATLAB code for guiDatePicker.fig
%      GUIDATEPICKER, by itself, creates a new GUIDATEPICKER or raises the existing
%      singleton*.
%
%      H = GUIDATEPICKER returns the handle to a new GUIDATEPICKER or the handle to
%      the existing singleton*.
%
%      GUIDATEPICKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIDATEPICKER.M with the given input arguments.
%
%      GUIDATEPICKER('Property','Value',...) creates a new GUIDATEPICKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiDatePicker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiDatePicker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiDatePicker

% Last Modified by GUIDE v2.5 21-Apr-2011 12:54:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiDatePicker_OpeningFcn, ...
                   'gui_OutputFcn',  @guiDatePicker_OutputFcn, ...
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


% --- Executes just before guiDatePicker is made visible.
function guiDatePicker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiDatePicker (see VARARGIN)
year = 2000:1:2020;
dt = varargin{1}; %
if ~isempty(dt)
    [YYi, MMi, DDi, hhI, mmI, ssI] = datevec(dt);
    wo = find(year==YYi);
    set(handles.Year,'Value',wo);
    set(handles.Month,'Value',MMi);
    set(handles.Hours,'String',num2str(hhI));
    set(handles.Minutes,'String',num2str(mmI));
end


y = get(handles.Year,'String');
yi = get(handles.Year,'Value');
m = get(handles.Month,'String');
mi = get(handles.Month,'Value');
yy = y(yi);

YY = str2double(yy);
MM = mi;
ldom = eomday(YY,MM);
for i = 1:ldom
    dtn(i) = datenum([YY MM i 0 0 0]);
    dts{i} = datestr(dtn);
    %disp(char(dts(i)));
end
    [n,s] = weekday(datenum([YY MM 1 0 0 0]));
% clear calendar    
for i = 1:7
    for j = 1:6
        D{j,i} = '';
    end
end
% update calendar
num = 0;
for i = n:7
    num = num + 1;
    D{1,i} = num;
end
for j = 2:6
    for i = 1:7
        num = num + 1;
        if num > ldom
            break;
        end
        D{j,i} = num;
    end
end

set(handles.Calendar,'Data',D);


% Choose default command line output for guiDatePicker
handles.output = hObject;

% Close handles structure
guidata(hObject, handles);

% UIWAIT makes guiDatePicker wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiDatePicker_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
close(gcf);

% --- Executes on selection change in Year.
function Year_Callback(hObject, eventdata, handles)
% hObject    handle to Year (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Year contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Year

y = get(handles.Year,'String');
yi = get(handles.Year,'Value');
m = get(handles.Month,'String');
mi = get(handles.Month,'Value');
yy = y(yi);

YY = str2double(yy);
MM = mi;
ldom = eomday(YY,MM);
for i = 1:ldom
    dtn(i) = datenum([YY MM i 0 0 0]);
    dts{i} = datestr(dtn);
    %disp(char(dts(i)));
end
    [n,s] = weekday(datenum([YY MM 1 0 0 0]));
% clear calendar    
for i = 1:7
    for j = 1:6
        D{j,i} = '';
    end
end
% update calendar
num = 0;
for i = n:7
    num = num + 1;
    D{1,i} = num;
end
for j = 2:6
    for i = 1:7
        num = num + 1;
        if num > ldom
            break;
        end
        D{j,i} = num;
    end
end

set(handles.Calendar,'Data',D);


% --- Executes during object creation, after setting all properties.
function Year_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Year (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Month.
function Month_Callback(hObject, eventdata, handles)
% hObject    handle to Month (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Month contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Month
y = get(handles.Year,'String');
yi = get(handles.Year,'Value');
m = get(handles.Month,'String');
mi = get(handles.Month,'Value');
yy = y(yi);

YY = str2double(yy);
MM = mi;
ldom = eomday(YY,MM);
for i = 1:ldom
    dtn(i) = datenum([YY MM i 0 0 0]);
    dts{i} = datestr(dtn);
    %disp(char(dts(i)));
end
    [n,s] = weekday(datenum([YY MM 1 0 0 0]));
% clear calendar    
for i = 1:7
    for j = 1:6
        D{j,i} = '';
    end
end
% update calendar
num = 0;
for i = n:7
    num = num + 1;
    D{1,i} = num;
end
for j = 2:6
    for i = 1:7
        num = num + 1;
        if num > ldom
            break;
        end
        D{j,i} = num;
    end
end

set(handles.Calendar,'Data',D);



% --- Executes during object creation, after setting all properties.
function Month_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Month (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Close.
function Close_Callback(hObject, eventdata, handles)
% hObject    handle to Close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

y = get(handles.Year,'String');
yi = get(handles.Year,'Value');
m = get(handles.Month,'String');
mi = get(handles.Month,'Value');
yy = y(yi);

YY = str2double(yy);
MM = mi;
if isfield(handles,'Day')
    DD = handles.Day;
    hh = str2double(get(handles.Hours,'String'));
    mm = str2double(get(handles.Minutes,'String'));

    % x = datenum([YY MM DD hh mm 0])
    handles.output = datenum([YY MM DD hh mm 0]);
    % Close handles structure
    guidata(hObject, handles);

    uiresume;
else
   errordlg('Day was not selected','DatePicker Error');
end

% --- Executes during object creation, after setting all properties.
function Calendar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CTDtab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when selected cell(s) is changed in Calendar.
function Calendar_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to Calendar (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
        sel = eventdata.Indices;      % Get selection indices (row, col)
                                     % Noncontiguous selections are ok
        selcols = unique(sel(:,2));   % Get all selected data col IDs
        selrows = unique(sel(:,1));
        num = get(hObject,'Data');  % Get copy of uitable data
        
x = num(selrows,selcols);
handles.Day = x{1};

% Close handles structure
guidata(hObject, handles);


function Hours_Callback(hObject, eventdata, handles)
% hObject    handle to Hours (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Hours as text
%        str2double(get(hObject,'String')) returns contents of Hours as a double


% --- Executes during object creation, after setting all properties.
function Hours_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Hours (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Minutes_Callback(hObject, eventdata, handles)
% hObject    handle to Minutes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Minutes as text
%        str2double(get(hObject,'String')) returns contents of Minutes as a double


% --- Executes during object creation, after setting all properties.
function Minutes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Minutes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
