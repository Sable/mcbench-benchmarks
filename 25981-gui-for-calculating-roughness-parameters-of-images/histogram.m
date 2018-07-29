function varargout = histogram(varargin)
% GUI for Plotting historgam and equalizing image arrays
%    
% INPUT:
% images - array to plot histograms for (can be a single image as well)
% 'N' - image to display 
%
% to run:
%
%   histogram(images,'1')
%
% if want equalized images as output:
% 
%   im_eq=threshold(images,'1');
%
%  created by K.Artyushkova
%  January 2004

% Kateryna Artyushkova
% Postdoctoral Scientist
% Department of Chemical and Nuclear Engineering
% The University of New Mexico
% (505) 277-0750
% kartyush@unm.edu 

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @histogram_OpeningFcn, ...
                   'gui_OutputFcn',  @histogram_OutputFcn, ...
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


% --- Executes just before histogram is made visible.
function histogram_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to histogram (see VARARGIN)


% Update handles structure
axes(handles.axes1);
cla
data= varargin{1};
n=varargin{2};
n=str2double(n);
iptsetpref('ImshowAxesVisible', 'on')
imagesc(data(:,:,n)), colormap(gray)
set(handles.imi,'string',n);
handles.data=data;
handles.n=n;
guidata(hObject, handles);

% UIWAIT makes histogram wait for user response (see UIRESUME)
% uiwait(handles.figure1);

uiwait(handles.figure1);

% --- Executes during object creation, after setting all properties.
function slice_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slice_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function slice_select_Callback(hObject, eventdata, handles)
% hObject    handle to slice_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
data=handles.data;
[m,p,q]=size(data);
set(handles.im1,'string',1);
set(handles.imN,'string',q);
step=1/q;
slider_step(1)=step;
slider_step(2)=step;
set(handles.slice_select, 'SliderStep', slider_step, 'Max', q, 'Min',0)
i=get(hObject,'Value');
i=round(i);
    if i==0
        i=1;
    elseif i>=q
        i=q;
    else i=i;
    end
    set(handles.imi,'string',i);
    axes(handles.axes1);
iptsetpref('ImshowAxesVisible', 'on')
imagesc(data(:,:,i)), colormap(gray)
    axes(handles.axes2);
    hist(data(:,:,i))
    handles.n=i;
    guidata(hObject,handles)



% --- Executes on button press in equalize.
function equalize_Callback(hObject, eventdata, handles)
% hObject    handle to equalize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data=handles.data;
[m,p,q]=size(data);
for i=1:q
    data_eq(:,:,i)=histeq(uint8(data(:,:,i)));
end
data_eq=double(data_eq);

n=handles.n;
axes(handles.axes1);
iptsetpref('ImshowAxesVisible', 'on')
imagesc(data_eq(:,:,i)), colormap(gray)
      axes(handles.axes2);
    hist(data_eq(:,:,n))
handles.data_eq=data_eq;
    guidata(hObject,handles)
  



% --- Executes on button press in replace.
function varargout=replace_Callback(hObject, eventdata, handles)
% hObject    handle to replace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data=handles.data_eq;
handles.data=data;
handles.output=data;
varargout{1} = handles.output;
guidata(hObject,handles)
uiresume(handles.figure1);


% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);


    % --- Outputs from this function are returned to the command line.
function varargout = histogram_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure

data=handles.data;
handles.output=data;
varargout{1} = handles.output;
close



