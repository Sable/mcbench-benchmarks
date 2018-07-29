function varargout = quadratic(varargin)
% QUADRATIC M-file for quadratic.fig
%      QUADRATIC, by itself, creates a new QUADRATIC or raises the existing
%      singleton*.
%
%      H = QUADRATIC returns the handle to a new QUADRATIC or the handle to
%      the existing singleton*.
%
%      QUADRATIC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QUADRATIC.M with the given input arguments.
%
%      QUADRATIC('Property','Value',...) creates a new QUADRATIC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before quadratic_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to quadratic_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help quadratic

% Last Modified by GUIDE v2.5 26-Jan-2009 10:33:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @quadratic_OpeningFcn, ...
                   'gui_OutputFcn',  @quadratic_OutputFcn, ...
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


% --- Executes just before quadratic is made visible.
function quadratic_OpeningFcn(hObject, eventdata, handles, varargin)
axes(handles.axes1)
colordef black
plot(zeros(1))
grid on
movegui(hObject, 'center')
% Choose default command line output for quadratic
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
colordef black
% UIWAIT makes quadratic wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = quadratic_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in solve_b.
function solve_b_Callback(hObject, eventdata, handles)
a=str2double(get(handles.a,'String'));
b=str2double(get(handles.b,'String'));
c=str2double(get(handles.c,'String'));
%Check the input values.
if isempty(a) ||isnan(a)
    errordlg('Please enter an integer value');
    set(handles.a,'String',1);
    return
end

if isempty(b) ||isnan(b)
    errordlg('Please enter an integer value');
    set(handles.b,'String',1);
    return
end

if isempty(c) ||isnan(c)
    errordlg('Please enter an integer value');
    set(handles.c,'String',1);
    return
end
% Compute the roots
x1=(-b+sqrt(b^2-4*a*c))/(2*a);
x2=(-b-sqrt(b^2-4*a*c))/(2*a);
% Show roots
set(handles.r_1,'String',num2str(x1));
set(handles.r_2,'String',num2str(x2));
%If roots are not complex, plot roots
if isreal(x1)
    x=-10:1/100:10;
    s=a*x.^2+b*x+c;
    axes(handles.axes1)
%     colordef black
    plot(x,s)    
    title('EQUATION AND ROOTS')
    grid on
    hold on
    plot(x1,a*x1.^2+b*x1+c,'s','Color','g')
    plot(x2,a*x2.^2+b*x2+c,'s','Color','m')    
    hold off    
else
    cla
end

function a_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of a as text
%        str2double(get(hObject,'String')) returns contents of a as a double

% --- Executes during object creation, after setting all properties.
function a_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function b_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of b as text
%        str2double(get(hObject,'String')) returns contents of b as a double

% --- Executes during object creation, after setting all properties.
function b_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function c_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of c as text
%        str2double(get(hObject,'String')) returns contents of c as a double

% --- Executes during object creation, after setting all properties.
function c_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


