function varargout = tcrol(varargin)
%This GUI contemplates how mysterious-looking situations can sometimes be
% explained with simple mathematical rules. It gives a clear and understandable 
% description of the behavior arising from a logistic equation that expresses 
% the population of a system of animals as Nnew = Lambda*Nold (1 - Nold).
% Varying the parameter Lambda can give several different outcomes, 
% including extinction, stable growth to a limiting population, cyclical 
% oscillation of population sizes, and even chaotic variation. This
% example, originating in work of May, Oster, and Yorke, was one of the
% early manifestations of chaos theory. More information can be found, for
% example, in an essay by Robert May:
% 
% http://members.fortunecity.com/templarser/rhythm.html 
% 
% ...And it means that sometimes a whole population of frogs, or worms, 
% or people, can die for no reason whatsoever, just because that is the way 
% the numbers work...
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2008) The chaotic rhythm of life: explore the
% May-Oster-Yorke law. 
% http://www.mathworks.com/matlabcentral/fileexchange/18915


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tcrol_OpeningFcn, ...
                   'gui_OutputFcn',  @tcrol_OutputFcn, ...
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


% --- Executes just before tcrol is made visible.
function tcrol_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tcrol (see VARARGIN)

% Choose default command line output for tcrol
handles.G=30;
handles.N=repmat(0.1,1,handles.G);
handles.Lambda=1;
for i=2:handles.G
    handles.N(i)=handles.N(i-1)*handles.Lambda*(1-handles.N(i-1));
end
updateplot(handles,hObject)

% --- Outputs from this function are returned to the command line.
function varargout = tcrol_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.N(1)=get(hObject,'Value');
set(handles.uipanel1,'Title',['Initial population: ' num2str(handles.N(1))])
for i=2:handles.G
    handles.N(i)=handles.N(i-1)*handles.Lambda*(1-handles.N(i-1));
end
updateplot(handles,hObject)

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.Lambda=get(hObject,'Value');
set(handles.uipanel2,'Title',['Lambda: ' num2str(handles.Lambda)])
for i=2:handles.G
    handles.N(i)=handles.N(i-1)*handles.Lambda*(1-handles.N(i-1));
end
updateplot(handles,hObject)

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider
tmpG=round(get(hObject,'Value'));
set(handles.uipanel3,'Title',['N. of generations: ' num2str(tmpG)])
if tmpG<handles.G
    handles.N(tmpG+1:end)=[];
else
    l=tmpG-length(handles.N);
    tmpN=repmat(1,1,l+1);
    tmpN(1)=handles.N(end);
    for i=2:l+1
        tmpN(i)=tmpN(i-1)*handles.Lambda*(1-tmpN(i-1));
    end
    tmpN(1)=[];
    handles.N=[handles.N tmpN];
end
handles.G=tmpG;
updateplot(handles,hObject)

function updateplot(handles,hObject)
plot(handles.N)
title('The chaotic rhythms of life')
xlabel('Generation')
ylabel('Population')
axis square
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);


