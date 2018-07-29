function varargout = LEMS1im_GUI(varargin)
% LEMS1IM_GUI M-file for LEMS1im_GUI.fig
%      LEMS1IM_GUI, by itself, creates a new LEMS1IM_GUI or raises the existing
%      singleton*.
%
%      H = LEMS1IM_GUI returns the handle to a new LEMS1IM_GUI or the handle to
%      the existing singleton*.
%
%      LEMS1IM_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LEMS1IM_GUI.M with the given input arguments.
%
%      LEMS1IM_GUI('Property','Value',...) creates a new LEMS1IM_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LEMS1im_GUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LEMS1im_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LEMS1im_GUI

% Last Modified by GUIDE v2.5 16-Nov-2006 12:33:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LEMS1im_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @LEMS1im_GUI_OutputFcn, ...
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


% --- Executes just before LEMS1im_GUI is made visible.
function LEMS1im_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LEMS1im_GUI (see VARARGIN)

colormap(gray(256))
% --- make slider invisible
set(handles.slider1,'Min',0,'Max',255)
handles.data.flag.read = 1;
handles.data.flag.crop = 0;
handles.data.flag.threshold = 0;
handles.data.flag.B0 = 0;
handles.data.flag.filter = 0;
handles.data.flag.LEMS = 0;
handles.data.flag.save = 0;
handles = enable_main(handles);
handles = diseable_threshold(handles);
handles = diseable_filter(handles);
handles = diseable_B0(handles);
handles = diseable_LEMS(handles);
handles = diseable_save(handles);

% Choose default command line output for LEMS1im_GUI
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% --- splash screen
I = imread('splash_screen2.jpg');
imshow(I);

% UIWAIT makes LEMS1im_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LEMS1im_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% keyboard
% --- ask the file
[I,p] = LEMS1im_read();
% --- display image
imagesc(uint8(I));axis image
% --- save data
handles.data.p = p;
handles.data.I = I;
% --- update button
handles.data.flag.crop = 2;
handles = enable_main(handles);
%--- save the handles structure.
guidata(hObject,handles)

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% === CROP

% --- call the crop function
[I,p] = LEMS1im_crop(handles.data.p);
% --- display image
imagesc(uint8(I));axis image
% --- save data
handles.data.p = p;
handles.data.I = I;
handles.data.If = I; % by default
% --- update button
handles.data.flag.crop = 1;
handles.data.flag.threshold = 2;
if handles.data.flag.B0 == 1,
    handles.data.flag.B0 == 2;
end
if handles.data.flag.filter == 1,
    handles.data.flag.filter == 2;
end
if handles.data.flag.LEMS == 1,
    handles.data.flag.LEMS == 2;
end
if handles.data.flag.save == 1,
    handles.data.flag.save == 2;
end
handles = enable_main(handles);
%--- save the handles structure.
guidata(hObject,handles)

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- make threshold visible
handles = enable_threshold(handles);
% --- diseable all buttons 
handles = diseable_main(handles);
% --- wait for apply threshold to resume normal operation
%--- save the handles structure.
guidata(hObject,handles)

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- update the controls
handles = enable_filter(handles);
handles = diseable_main(handles);
% --- display the image
imagesc(handles.data.I),axis image
%--- save the handles structure.
guidata(hObject,handles)

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = enable_LEMS(handles);
handles = diseable_main(handles);
%--- save the handles structure.
guidata(hObject,handles)

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = enable_save(handles);
handles = diseable_main(handles);
%--- save the handles structure.
guidata(hObject,handles)

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- update control
handles = enable_B0(handles);
handles = diseable_main(handles);
%--- save the handles structure.
guidata(hObject,handles)

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% --- get value
handles.data.p.t = get(hObject,'Value');
% --- update manual update
set(handles.edit1,'string',num2str(handles.data.p.t)); 
imagesc(handles.data.I>handles.data.p.t);axis image
% --- compute the noise
I = handles.data.I;
handles.data.p.bck_mean = mean(I(I<handles.data.p.t));
handles.data.p.bck_std = std(I(I<handles.data.p.t));
%--- save the handles structure.
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% ============================== USER FUNCTIONS
% ---------------------------------------------------
function handles = diseable_main(handles)
set(handles.pushbutton1,'enable','off');
set(handles.pushbutton2,'enable','off');
set(handles.pushbutton3,'enable','off');
set(handles.pushbutton4,'enable','off');
set(handles.pushbutton5,'enable','off');
set(handles.pushbutton6,'enable','off');
set(handles.pushbutton7,'enable','off');

% ---------------------------------------------------
function handles = enable_main(handles)
if handles.data.flag.read > 0
    set(handles.pushbutton1,'enable','on');
else
    set(handles.pushbutton1,'enable','off');
end
if handles.data.flag.crop > 0;
    set(handles.pushbutton2,'enable','on');
    if handles.data.flag.crop == 1,
        set(handles.pushbutton2,'ForegroundColor',[0 0 0]);
    else
        set(handles.pushbutton2,'ForegroundColor',[1 0 0]);
    end
else 
    set(handles.pushbutton2,'enable','off');
end
if handles.data.flag.threshold > 0;
    set(handles.pushbutton3,'enable','on');
    if handles.data.flag.threshold == 1,
        set(handles.pushbutton3,'ForegroundColor',[0 0 0]);
    else
        set(handles.pushbutton3,'ForegroundColor',[1 0 0]);
    end
else 
    set(handles.pushbutton3,'enable','off');
end
if handles.data.flag.B0 > 0;
    set(handles.pushbutton7,'enable','on');
    if handles.data.flag.B0 == 1,
        set(handles.pushbutton7,'ForegroundColor',[0 0 0]);
    else
        set(handles.pushbutton7,'ForegroundColor',[1 0 0]);
    end
else 
    set(handles.pushbutton7,'enable','off');
end
if handles.data.flag.filter > 0,
    set(handles.pushbutton4,'enable','on');
    if handles.data.flag.filter == 1,
        set(handles.pushbutton4,'ForegroundColor',[0 0 0]);
    else
        set(handles.pushbutton4,'ForegroundColor',[1 0 0]);
    end
else 
    set(handles.pushbutton4,'enable','off');
end
if handles.data.flag.LEMS > 0;
    set(handles.pushbutton5,'enable','on');
    if handles.data.flag.LEMS == 1,
        set(handles.pushbutton5,'ForegroundColor',[0 0 0]);
    else
        set(handles.pushbutton5,'ForegroundColor',[1 0 0]);
    end
else 
    set(handles.pushbutton5,'enable','off');
end
if handles.data.flag.save > 0;
    set(handles.pushbutton6,'enable','on');
    if handles.data.flag.save == 1,
        set(handles.pushbutton6,'ForegroundColor',[0 0 0]);
    else
        set(handles.pushbutton6,'ForegroundColor',[1 0 0]);
    end
else 
    set(handles.pushbutton6,'enable','off');
end

% ---------------------------------------------------
function handles = diseable_threshold(handles)
set(handles.uipanel2,'visible','off');
set(handles.slider1,'visible','off');

% ---------------------------------------------------
function handles = enable_threshold(handles)
set(handles.uipanel2,'visible','on');
set(handles.slider1,'visible','on');

% ---------------------------------------------------
function handles = diseable_filter(handles)
set(handles.uipanel4,'visible','off');

% ---------------------------------------------------
function handles = enable_filter(handles)
set(handles.uipanel4,'visible','on');

% ---------------------------------------------------
function handles = diseable_B0(handles)
set(handles.uipanel6,'visible','off');

% ---------------------------------------------------
function handles = enable_B0(handles)
set(handles.uipanel6,'visible','on');

% ---------------------------------------------------
function handles = diseable_LEMS(handles)
set(handles.uipanel8,'visible','off');

% ---------------------------------------------------
function handles = enable_LEMS(handles)
set(handles.uipanel8,'visible','on');

% ---------------------------------------------------
function handles = diseable_save(handles)
set(handles.uipanel9,'visible','off');

% ---------------------------------------------------
function handles = enable_save(handles)
set(handles.uipanel9,'visible','on');


% ==================================================
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

% --- get value
handles.data.p.t = str2num(get(hObject,'string'));
% --- update manual update
set(handles.slider1,'value',handles.data.p.t); 
imagesc(handles.data.I>handles.data.p.t);axis image
% --- compute the noise
I = handles.data.I;
handles.data.p.bck_mean = mean(I(I<handles.data.p.t));
handles.data.p.bck_std = std(I(I<handles.data.p.t));
%--- save the handles structure.
guidata(hObject,handles)

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


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ========== APPLY THRESHOLD

% --- fuzzy parameters
handles.data.p.a = str2num(get(handles.edit2,'string'));
handles.data.p.b = str2num(get(handles.edit3,'string'));
% --- update display
set(handles.text10,'string',num2str(handles.data.p.bck_std*0.655));
set(handles.text5,'string',num2str(handles.data.p.bck_std*0.655));
set(handles.edit6,'string',num2str(handles.data.p.bck_std*0.655));
% --- find the mask
fuzzy = [handles.data.p.a  handles.data.p.b];
% disp(['     Fuzzy rule: ' num2str(fuzzy)])
I = medfilt2(handles.data.I,[5 5]);
handles.data.Imask = NeckMask(I,handles.data.p.bck_mean+0.655*handles.data.p.bck_std*fuzzy);
% --- clean the mask
if (get(handles.checkbox7,'Value') == get(hObject,'Max'))
    handles.data.ImaskClean = NeckMaskCLean( handles.data.Imask ); % !!!!!
else
    handles.data.ImaskClean = handles.data.Imask>0; % !!!!!
end
if (get(handles.checkbox8,'Value') == get(hObject,'Max'))
    handles.data.ImaskClean = imopen(handles.data.ImaskClean>0,strel('disk',1,0)); % !!!!!
end

% --- display the mask
imagesc(handles.data.ImaskClean),axis image

%--- save the handles structure.
guidata(hObject,handles)


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- apply before leaving
pushbutton8_Callback(hObject, eventdata, handles)
% --- disable threshold parameters
handles = diseable_threshold(handles);
% --- update button
handles.data.flag.threshold = 1;
handles.data.flag.B0 = 2;
if handles.data.flag.filter == 1,
    handles.data.flag.filter = 2;
end
if handles.data.flag.LEMS == 1,
    handles.data.flag.LEMS = 2;
end
if handles.data.flag.save == 1,
    handles.data.flag.save = 2;
end
% --- enable main buttons
handles = enable_main(handles);
%--- save the handles structure.
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function pushbutton8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% APPLY THE FILTER

imagesc(handles.data.I,[0 255]),axis image
% --- read the iterations number
handles.data.p.filter.iterations = ...
    str2num(get(handles.edit4,'string'));
% --- read the noise scale
handles.data.p.filter.sigma = ...
    str2num(get(handles.edit6,'string'));
% --- call the actual filter
if (get(handles.checkbox4,'Value') == get(hObject,'Max'))
    % Checkbox is checked - use B0
    If = anisoOS(handles.data.I,'tukeyPsi',...
        sqrt(2)*handles.data.p.filter.sigma,...
        handles.data.p.filter.iterations,1,...
        handles.data.B0);
else
    % Checkbox is not checked - don't use B0
    If = anisoOS(handles.data.I,'tukeyPsi',...
        sqrt(2)*handles.data.p.filter.sigma,...
        handles.data.p.filter.iterations,1);
end
handles.data.If = If;
imagesc(If,[0 255]),axis image
%--- save the handles structure.
guidata(hObject,handles)

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- do not apply the filter becasue it may take too much time
% pushbutton10_Callback(hObject, eventdata, handles)

% --- restore the controls
handles = diseable_filter(handles);
% --- update button
handles.data.flag.filter = 1;
handles.data.flag.LEMS = 2;
if handles.data.flag.save == 1,
    handles.data.flag.save = 2;
end
handles = enable_main(handles);
%--- save the handles structure.
guidata(hObject,handles)




% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% == COMPUTE B0
handles.data.p.B0_order = str2num(get(handles.edit7,'string')); 
disp(['     B initialized with a polynomial fit, order: ' num2str(handles.data.p.B0_order)])
B0 = PolyMaskFilter(double(handles.data.I),handles.data.p.B0_order,handles.data.ImaskClean);
% --- make sure the B0 is >0
sig = 31;
G = fspecial('gaussian',3*sig+1,sig);
temp = imfilter(double(handles.data.I),G,'same','replicate');
handles.data.B0 = max(0.5*temp,B0);
if (get(handles.checkbox15,'Value') == get(hObject,'Max'))
    handles.data.B0 = min(5*temp,handles.data.B0);
end
% --- display
imagesc(handles.data.B0),axis image
%--- save the handles structure.
guidata(hObject,handles)

% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ---- compute B0
pushbutton12_Callback(hObject, eventdata, handles)
% --- done
handles = diseable_B0(handles);

% --- update button
handles.data.flag.B0 = 1;
handles.data.flag.filter = 2;
if handles.data.flag.LEMS == 1,
    handles.data.flag.LEMS = 2;
end
if handles.data.flag.save == 1,
    handles.data.flag.save = 2;
end
handles = enable_main(handles);
%--- save the handles structure.
guidata(hObject,handles)



% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ====== LEMS

% --- get the parameters
options = BiasCorrLEMSS2D;
a = str2num(get(handles.edit10,'string'));
b = str2num(get(handles.edit11,'string'));
options.Nknots = [a b];
if (get(handles.checkbox5,'Value') == get(hObject,'Max'))
    % Checkbox is checked - iterative display 
    options.flag_display = 1;
    h = figure(2);
else
    % Checkbox is not checked - display only final results
    options.flag_display = 0;
    h = -1;
end
if (get(handles.checkbox6,'Value') == get(hObject,'Max'))
    % Checkbox is checked - update border knots 
    options.flag_allknots = 1;
else
    % Checkbox is not checked - does not cahnge border knots
    options.flag_allknots = 0;
end
options.NiterMax = str2num(get(handles.edit8,'string'));
options.Bgain = str2num(get(handles.edit12,'string'));
% --- actual correction
algo = 'LEMS2D';
% algo_option = ['k' num2str(options.Nknots(1)) 'f' num2str(flag_filter) 'sg' num2str(options.GainSmooth) 'Ni' num2str(options.NiterMax)];
  
B = BiasCorrLEMSS2D(handles.data.If,...
    handles.data.Imask.*handles.data.ImaskClean,...
    handles.data.p.bck_mean,...
    handles.data.p.bck_std,...
    options,...
    handles.data.B0);
Ic = handles.data.I./B.*handles.data.Imask + ...
    (1-handles.data.Imask).*handles.data.I;

% --- save the resutls and param
handles.data.p.options = options;
handles.data.Ic = Ic;
handles.data.B = B;
% --- update the display
axes(handles.axes1)
imagesc(Ic,[0 255]),axis image

%--- save the handles structure.
guidata(hObject,handles)

% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- update control
handles = diseable_LEMS(handles);
% --- update buttons
handles.data.flag.LEMS = 1;
handles.data.flag.save = 2;
handles = enable_main(handles);
%--- save the handles structure.
guidata(hObject,handles)


function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% REGION GROWING FROM CORNER
[handles.data.p.bck_mask,handles.data.p.bck_mean,handles.data.p.bck_std] =...
    NeckBackground(handles.data.I,2,3);
%--- save the handles structure.
guidata(hObject,handles)


% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9


% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10


% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11


% --- Executes on button press in checkbox12.
function checkbox12_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox12


% --- Executes on button press in checkbox13.
function checkbox13_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox13


% --- Executes on button press in checkbox14.
function checkbox14_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox14


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% SAVE ALL THE FILES
f = handles.data.p.filename(1:end-4);
p = handles.data.p.filepath;
if (get(handles.checkbox9,'Value') == get(hObject,'Max')),
    Ic = handles.data.Ic;
    Ic = Ic/255*(handles.data.p.Imax-handles.data.p.Imin);
    Ic = Ic+handles.data.p.Imin;
%     I = uint16(I/max(I(:))*65535);
    imwrite(uint16(Ic),[p f '_Icor.tif'],'tif');
end
if (get(handles.checkbox10,'Value') == get(hObject,'Max')),
    B0 = handles.data.B0;
    B0 = B0/mean(B0(handles.data.ImaskClean(:)))*...
        handles.data.p.options.Bgain;
    Ic = handles.data.I./B0.*handles.data.Imask + ...
    (1-handles.data.Imask).*handles.data.I;
    Ic = Ic/255*(handles.data.p.Imax-handles.data.p.Imin);
    Ic = Ic+handles.data.p.Imin;
%     I = uint16(I/max(I(:))*65535);
    imwrite(uint16(Ic),[p f '_I0cor.tif'],'tif');
end
if (get(handles.checkbox11,'Value') == get(hObject,'Max')),
    Ic = handles.data.B;
    Ic = Ic/255*(handles.data.p.Imax-handles.data.p.Imin);
    Ic = Ic+handles.data.p.Imin;
%     I = uint16(I/max(I(:))*65535);
    imwrite(uint16(Ic),[p f '_B.tif'],'tif');
end
if (get(handles.checkbox12,'Value') == get(hObject,'Max')),
    Ic = handles.data.B0;
    Ic = Ic/255*(handles.data.p.Imax-handles.data.p.Imin);
    Ic = Ic+handles.data.p.Imin;
%     I = uint16(I/max(I(:))*65535);
    imwrite(uint16(Ic),[p f '_B0.tif'],'tif');
end
if (get(handles.checkbox13,'Value') == get(hObject,'Max')),
    Ic = handles.data.Imask;
    Ic = Ic*255;
%     I = uint16(I/max(I(:))*65535);
    imwrite(uint8(Ic),[p f '_Imask.tif'],'tif');
end
if (get(handles.checkbox14,'Value') == get(hObject,'Max')),
    data = handles.data;
    save([p f '_results.mat'],'data');
end

disp('Results saved')

% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% DONE SAVE

handles.data.flag.save = 1;
handles = enable_main(handles);
handles = diseable_save(handles);
%--- save the handles structure.
guidata(hObject,handles)

% --- Executes on button press in checkbox15.
function checkbox15_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox15

%%%%%%%%% FUCNTIONS %%%%%%%%%%%%%%%%%%%%
function [] = im(I,r),
%
%
%
if exist('r','var'),
    imagesc(I,r);
else
    imagesc(I)
end
axis image,axis off
% impixelinfo
drawnow




