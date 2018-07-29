function varargout = LinTestPJ(varargin)
%GUI made by Paulo Silva to solve Catalin Eberhardt problem at
%http://www.mathworks.com/matlabcentral/newsreader/view_thread/300770
%psychology experiment that measures how people map numbers to space.
%The task would is as follows: two numbers (e.g. -10 and 10) mark the 
%extremities of a line, which is constant from trial to trial; a series of 
%numbers appear one by one in the upper part of the screen, and the 
%participant has to click on the line where they think that number should 
%be (so, for instance, the number 1 would require a click a little to the 
%right of the line's midpoint, if the line goes from -10 to 10).
%
%When the GUI starts 10 diferent values are selected and each user will be
%asked to click on the line where he or she thinks the value is located
%
%This GUI will log each participant results and gives the option to save
%the results to a text file
%
% LINTESTPJ M-file for LinTestPJ.fig
%      LINTESTPJ, by itself, creates a new LINTESTPJ or raises the existing
%      singleton*.
%
%      H = LINTESTPJ returns the handle to a new LINTESTPJ or the handle to
%      the existing singleton*.
%
%      LINTESTPJ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LINTESTPJ.M with the given input arguments.
%
%      LINTESTPJ('Property','Value',...) creates a new LINTESTPJ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LinTestPJ_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LinTestPJ_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LinTestPJ

% Last Modified by GUIDE v2.5 12-Jan-2011 19:37:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LinTestPJ_OpeningFcn, ...
                   'gui_OutputFcn',  @LinTestPJ_OutputFcn, ...
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


% --- Executes just before LinTestPJ is made visible.
function LinTestPJ_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LinTestPJ (see VARARGIN)

% Choose default command line output for LinTestPJ
handles.output = hObject;

while (1)
TestValues=ceil(10*rand(1,10));
for a=1:length(TestValues)
Sig=rand;
if (Sig>=0.5)
    Signal=1;
else
    Signal=-1;
end
TestValues(a)=TestValues(a)*Signal;
end

if ((length(unique(TestValues))==length(TestValues(:)))~=0)
    break
end

end

handles.TestValues=TestValues;

% Update handles structure
guidata(hObject, handles);

global Stop

line([0 1],[0.5 0.5]);
box off;
Stop=1;

set(handles.listbox1,'Visible','off');

% UIWAIT makes LinTestPJ wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LinTestPJ_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

User = inputdlg('Please write your name');

global Stop
Stop=0;
hold on;

TestValues=handles.TestValues;

Test=0;

VAL_X=[];
VAL_Y=[];
        but = 1;
        while ((but == 1) & (Stop==0) & (Test<10))
            Test=Test+1;
            set(handles.edit1,'String',TestValues(Test))
            [xi,yi,but] = ginput(1);
            %plot(xi,yi,'r*');
            VAL_X=[VAL_X xi];
            VAL_Y=[VAL_Y yi];
        
        end
       
error=TestValues-VAL_X;        
str_part = sprintf('User: %s Test Values: %s Selected: %s P.Error %s S.Error: %s ',...
    User{:},mat2str(TestValues),mat2str(error,2),mat2str(VAL_X,2),...
    num2str(abs(sum(error)/10))); %'something'
old_str = get(handles.listbox1, 'String' );
new_str = strvcat(old_str, str_part); %
set(handles.listbox1, 'String', new_str);
  
 
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Stop
Stop=1;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (strcmp(get(handles.listbox1,'Visible'),'off'));
    set(handles.listbox1,'Visible','on');
    set(handles.pushbutton3,'String','Hide Results');
else
    set(handles.pushbutton3,'String','Show Results');
    set(handles.listbox1,'Visible','off');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ListBoxValues = get(handles.listbox1, 'String');
fid = fopen('LinTestPJ.txt', 'a+');
% print a title, followed by a blank line
%sprintf(fid, '%s', ListBoxValues);

sizelist=size(ListBoxValues)

lines=sizelist(1);
col=sizelist(2);

for b=1:lines
for a=1:col
%set(handles.listbox1,'Value',a);
str=sprintf('%s',ListBoxValues(b,a)); % the most versatile
fprintf(fid,'%s',str);
end
fprintf(fid,'\n');
end



% print a title, followed by a blank line
fclose(fid);

disp('Results saved to LinTestPJ.txt on the Current Directory');
msgbox('Results saved to LinTestPJ.txt on the Current Directory');


