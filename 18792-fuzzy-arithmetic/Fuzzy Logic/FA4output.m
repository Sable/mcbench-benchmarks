function varargout = FA4output(varargin)
% FA4OUTPUT M-file for FA4output.fig
%      FA4OUTPUT, by itself, creates a new FA4OUTPUT or raises the existing
%      singleton*.
%
%      H = FA4OUTPUT returns the handle to a new FA4OUTPUT or the handle to
%      the existing singleton*.
%
%      FA4OUTPUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FA4OUTPUT.M with the given input arguments.
%
%      FA4OUTPUT('Property','Value',...) creates a new FA4OUTPUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FA4output_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FA4output_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FA4output

% Last Modified by GUIDE v2.5 06-Feb-2008 22:31:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FA4output_OpeningFcn, ...
                   'gui_OutputFcn',  @FA4output_OutputFcn, ...
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


% --- Executes just before FA4output is made visible.
function FA4output_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FA4output (see VARARGIN)

% Choose default command line output for FA4output
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FA4output wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FA4output_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global x;
global A;
global B;

C1 = fuzarith(x, A, B, 'sum'); % range,A,B,and function
subplot(2,2,1);
plot(x, A, 'b--', x, B, 'm:', x, C1, 'c'); % specifying type of line and 
grid on;                                         % color of the same
%title('fuzzy addition A+B');
legend('A','B','C');

% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global x ;
global A;
global B;

%Subtraction
C2 = fuzarith(x, A, B, 'sub');
subplot(2,2,2);
plot(x, A, 'b--', x, B, 'm:', x, C2, 'c');
grid on;
%title('fuzzy subtraction A-B');
legend('A','B','C');

% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)

global x ;
global A;
global B;
C3 = fuzarith(x, A, B, 'prod');
subplot(2,2,3);
plot(x, A, 'b--', x, B, 'm:', x, C3, 'c');
grid on;
%title('fuzzy Multiplication A*B');
legend('A','B','C');

% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)

global x ;
global A;
global B;

C4 = fuzarith(x, A, B, 'div');
subplot(2,2,4);
plot(x, A, 'b--', x, B, 'm:', x, C4, 'c');
grid on;
%title('fuzzy division A/B');
legend('A','B','C');

% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


