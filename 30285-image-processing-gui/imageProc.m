function varargout = imageProc(varargin)

% IMAGEPROC M-file for imageProc.fig
%      IMAGEPROC, by itself, creates a new IMAGEPROC or raises the existing
%      singleton*.
%
%      H = IMAGEPROC returns the handle to a new IMAGEPROC or the handle to
%      the existing singleton*.
%
%      IMAGEPROC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEPROC.M with the given input arguments.
%
%      IMAGEPROC('Property','Value',...) creates a new IMAGEPROC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imageProc_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imageProc_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help imageProc

% Last Modified by GUIDE v2.5 15-Feb-2011 10:30:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imageProc_OpeningFcn, ...
                   'gui_OutputFcn',  @imageProc_OutputFcn, ...
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


% --- Executes just before imageProc is made visible.
function imageProc_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imageProc (see VARARGIN)

% Choose default command line output for imageProc
handles.fileLoaded = 0;
handles.fileLoaded2 = 0;
set(handles.axes1,'Visible','off');
set(handles.axes2,'Visible','off');
set(handles.axesHist1,'Visible','off');
set(handles.axesHist2,'Visible','off');
set(handles.editPath, 'Visible', 'off');
set(handles.editSize, 'Visible', 'off');
set(handles.editComment, 'Visible', 'off');
set(handles.textHist1, 'Visible', 'off');
set(handles.textHist2, 'Visible', 'off');
set(handles.sliderBright, 'Enable', 'off');
set(handles.sliderContrast, 'Enable', 'off');
set(handles.sliderRotate, 'Enable', 'off');
set(handles.editBright,'String', sprintf('%10s:%4.0f%%', 'Brightness', 100*get(handles.sliderBright,'Value')));
set(handles.editContrast,'String', sprintf('%10s:%4.0f%%', 'Contrast', 100*get(handles.sliderContrast,'Value')));
set(handles.editRotate,'String', sprintf('%10s:%4.0f', 'Rotate', get(handles.sliderRotate,'Value')));
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes imageProc wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = imageProc_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LoadButton.
function LoadButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName] = uigetfile({'*.*'},'Load Image File');

if (FileName==0) % cancel pressed
    return;
end


handles.fullPath = [PathName FileName];
[a, b, Ext] = fileparts(FileName);
availableExt = {'.bmp','.jpg','.jpeg','.tiff','.png','.gif'};
FOUND = 0;
for (i=1:length(availableExt))
    if (strcmpi(Ext, availableExt{i}))
        FOUND=1;
        break;
    end
end

if (FOUND==0)
    h = msgbox('File type not supported!','Error','error');
    return;
end

set(handles.sliderRotate, 'Enable', 'on');
set(handles.sliderBright, 'Enable', 'on');
set(handles.sliderContrast, 'Enable', 'on');
set(handles.editPath, 'Visible', 'on');
set(handles.editSize, 'Visible', 'on');
set(handles.editComment, 'Visible', 'on');


info = imfinfo(handles.fullPath);
if (~isempty(info.Comment))
    % save current image comment (to be used later in image save)
    handles.currentImageComment = info.Comment{1};
else
    handles.currentImageComment = '';
end

set(handles.editSize, 'String', sprintf('SIZE (W x H) : %d x %d', info.Width, info.Height));
set(handles.editComment, 'String', sprintf('COMMENT: %s', handles.currentImageComment));
set(handles.editPath', 'String', handles.fullPath);


RGB = imread(handles.fullPath);

handles.RGB = RGB;
handles.RGB2 = RGB;
handles.fileLoaded = 1;
handles.fileLoaded2 = 0;

set(handles.axes1,'Visible','off'); set(handles.axes2,'Visible','off');
set(handles.axesHist1,'Visible','off'); set(handles.axesHist2,'Visible','off');
set(handles.textHist1, 'Visible', 'off');
axes(handles.axesHist2); cla;
set(handles.textHist2, 'Visible', 'off');

axes(handles.axes1); cla; imshow(RGB);
axes(handles.axes2); cla;

handles = updateHistograms(handles);

guidata(hObject, handles);



% --- Executes on button press in CopyButton.
function CopyButton_Callback(hObject, eventdata, handles)
% hObject    handle to CopyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.fileLoaded==1)
    handles.RGB2 = handles.RGB;
    axes(handles.axes2); imshow(handles.RGB2);
    handles.fileLoaded2 = 1;
    handles = updateHistograms(handles);
    guidata(hObject, handles);
else
    h = msgbox('No primary file has been loaded!','Error','error');
end

% --- Executes on button press in MedianButton.
function MedianButton_Callback(hObject, eventdata, handles)
% hObject    handle to MedianButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.fileLoaded==1)

    [M,N,ttt] = size(handles.RGB);

    RUN = 1;

    while (RUN==1)

        prompt = {'Enter Median Row Factor (0-5%):','Enter Median Column Factor (0-5%):'};
        dlg_title = 'Enter Median Parameters:';
        num_lines = 1;
        def = {'2','2'};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        if (isempty(answer))
            return;
        end

        M1 = str2num(answer{1})/100;
        M2 = str2num(answer{2})/100;

        if ((str2num(answer{1})>=0) & (str2num(answer{1})<=5)) & ((str2num(answer{2})>=0) & (str2num(answer{2})<=5))
            RUN = 0;
        end
    end

    M1 = round(M1 * M);
    M2 = round(M2 * N);

    w = waitbar(0, 'Median filtering ... Please wait ...');
    handles.RGB2(:,:,1) = medfilt2(handles.RGB(:,:,1),[M1 M2]);
    waitbar(1/3, w);
    handles.RGB2(:,:,2) = medfilt2(handles.RGB(:,:,2),[M1 M2]);
    waitbar(2/3, w);
    handles.RGB2(:,:,3) = medfilt2(handles.RGB(:,:,3),[M1 M2]);
    close(w);
    axes(handles.axes2); imshow(handles.RGB2);
    handles.fileLoaded2 = 1;
    handles = updateHistograms(handles);

    guidata(hObject, handles);
else
    h = msgbox('No primary file has been loaded!','Error','error');
end

% --- Executes on button press in SharpButton.
function SharpButton_Callback(hObject, eventdata, handles)
% hObject    handle to SharpButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.fileLoaded==1)
    H = fspecial('unsharp');
    handles.RGB2(:,:,1) = imfilter(handles.RGB(:,:,1),H,'replicate');
    handles.RGB2(:,:,2) = imfilter(handles.RGB(:,:,2),H,'replicate');
    handles.RGB2(:,:,3) = imfilter(handles.RGB(:,:,3),H,'replicate');
    axes(handles.axes2); imshow(handles.RGB2);
    handles.fileLoaded2 = 1;
    handles = updateHistograms(handles);
    guidata(hObject, handles);
else
    h = msgbox('No primary file has been loaded!','Error','error');
end

% --- Executes on button press in MotionButton.
function MotionButton_Callback(hObject, eventdata, handles)
% hObject    handle to MotionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.fileLoaded==1)

    [M,N,ttt] = size(handles.RGB);
    D = max(M,N);

    RUN = 1;

    while (RUN==1)

        prompt = {'Enter Motion Length (0-15%):','Enter Motion Angle (0-360):'};
        dlg_title = 'Enter Motion Parameters:';
        num_lines = 1;
        def = {'1','0'};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        if (isempty(answer))
            return;
        end
        
        M1 = str2num(answer{1})/100;
        M2 = str2num(answer{2});

        if ((str2num(answer{1})>=0) & (str2num(answer{1})<=15))
            RUN = 0;
        end
    end

    H = fspecial('motion',D * M1,M2);
    w = waitbar(0, 'Motion filtering ... Please wait ...');
    handles.RGB2(:,:,1) = imfilter(handles.RGB(:,:,1),H,'replicate');
    waitbar(1/3, w);
    handles.RGB2(:,:,2) = imfilter(handles.RGB(:,:,2),H,'replicate');
    waitbar(2/3, w);
    handles.RGB2(:,:,3) = imfilter(handles.RGB(:,:,3),H,'replicate');
    close(w);
    axes(handles.axes2); imshow(handles.RGB2);
    handles.fileLoaded2 = 1;
    handles = updateHistograms(handles);
    guidata(hObject, handles);
else
    h = msgbox('No primary file has been loaded!','Error','error');
end

% --- Executes on button press in GrayButton.
function GrayButton_Callback(hObject, eventdata, handles)
% hObject    handle to GrayButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.fileLoaded==1)
    Gray = rgb2gray(handles.RGB);
    handles.RGB2(:,:,1) = Gray;
    handles.RGB2(:,:,2) = Gray;
    handles.RGB2(:,:,3) = Gray;
    axes(handles.axes2); imshow(handles.RGB2);
    handles.fileLoaded2 = 1;
    handles = updateHistograms(handles);
    guidata(hObject, handles);
else
    h = msgbox('No primary file has been loaded!','Error','error');
end


% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if (handles.fileLoaded2==1)
    [file,path] = uiputfile('*.jpg','Save Secondary Image As');
    imwrite(handles.RGB2,[path file],'jpg');
else
    h = msgbox('No secondary file has been loaded!','Save Error','error');
end


% --- Executes on button press in ColorsButton.
function ColorsButton_Callback(hObject, eventdata, handles)
% hObject    handle to ColorsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.fileLoaded==1)
    RUN = 1;

    while (RUN==1)

        prompt = {'Enter threshold for RED (0-255):','Enter threshold for GREEN (0-255):','Enter threshold for BLUE (0-255):'};
        dlg_title = 'RGB Thresholds:';
        num_lines = 1;
        def = {'30','30','30'};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        if (isempty(answer))
            return;
        end
        T1 = str2num(answer{1});
        T2 = str2num(answer{2});
        T3 = str2num(answer{3});
        

        if ((T1>=0) & (T1<=256)) & ((T2>=0) && (T2<=256)) & ((T3>=0) && (T3<=256))
            RUN = 0;
        end
    end
    
    handles.RGB2 = filterColors(handles.RGB, T1, T2, T3, 5);
    axes(handles.axes2); imshow(handles.RGB2);
    handles.fileLoaded2 = 1;
    handles = updateHistograms(handles);

    guidata(hObject, handles);    
else
    h = msgbox('No primary file has been loaded!','Error','error');
end


% --- Executes on button press in ColorButton2.
function ColorButton2_Callback(hObject, eventdata, handles)
% hObject    handle to ColorButton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if (handles.fileLoaded==1)
    RUN = 1;

    while (RUN==1)

        prompt = {'Enter weight for RED (0-200%):','Enter weight for GREEN (0-200%):','Enter weight for BLUE (0-200%):'};
        dlg_title = 'Enter Color Weight Parameters:';
        num_lines = 1;
        def = {'100','100','100'};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        if (isempty(answer))
            return;
        end
        W1 = str2num(answer{1});
        W2 = str2num(answer{2});
        W3 = str2num(answer{3});
        

        if ((W1>=0) & (W1<=200)) & ((W2>=0) && (W2<=200)) & ((W3>=0) && (W3<=200))
            RUN = 0;
        end
    end
    
    handles.RGB2 = handles.RGB;
    R = double(handles.RGB2(:,:,1));
    G = double(handles.RGB2(:,:,2));
    B = double(handles.RGB2(:,:,3));
    
    R = R * W1 ./ 100;
    G = G * W2 ./ 100;
    B = B * W3 ./ 100;
    
    R(find(R>256)) = 256;
    G(find(G>256)) = 256;
    B(find(B>256)) = 256;
    
    handles.RGB2(:,:,1) = R;
    handles.RGB2(:,:,2) = G;
    handles.RGB2(:,:,3) = B;
    
    axes(handles.axes2); imshow(handles.RGB2);
    handles.fileLoaded2 = 1;
    handles = updateHistograms(handles);
    guidata(hObject, handles);    
else
    h = msgbox('No primary file has been loaded!','Error','error');
end


% --- Executes on button press in InvColorButton.
function InvColorButton_Callback(hObject, eventdata, handles)
% hObject    handle to InvColorButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.fileLoaded==1)
        
    R = double(handles.RGB(:,:,1));
    G = double(handles.RGB(:,:,2));
    B = double(handles.RGB(:,:,3));
        
    handles.RGB2(:,:,1) = 256 - R;
    handles.RGB2(:,:,2) = 256 - G;
    handles.RGB2(:,:,3) = 256 - B;
    
    axes(handles.axes2); imshow(handles.RGB2);
    handles.fileLoaded2 = 1;
    handles = updateHistograms(handles);
    guidata(hObject, handles);    
else
    h = msgbox('No primary file has been loaded!','Error','error');
end





function editSize_Callback(hObject, eventdata, handles)
% hObject    handle to editSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSize as text
%        str2double(get(hObject,'String')) returns contents of editSize as a double


% --- Executes during object creation, after setting all properties.
function editSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editComment_Callback(hObject, eventdata, handles)
% hObject    handle to editComment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editComment as text
%        str2double(get(hObject,'String')) returns contents of editComment as a double


% --- Executes during object creation, after setting all properties.
function editComment_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editComment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function editPath_Callback(hObject, eventdata, handles)
% hObject    handle to editPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPath as text
%        str2double(get(hObject,'String')) returns contents of editPath as a double


% --- Executes during object creation, after setting all properties.
function editPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on slider movement.
function sliderBright_Callback(hObject, eventdata, handles)
% hObject    handle to sliderBright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.editBright,'String', sprintf('%10s:%4.0f%%', 'Brightness', 100*get(handles.sliderBright,'Value')));


% --- Executes during object creation, after setting all properties.
function sliderBright_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderBright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderContrast_Callback(hObject, eventdata, handles)
% hObject    handle to sliderContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.editContrast,'String', sprintf('%10s:%4.0f%%', 'Contrast', 100*get(handles.sliderContrast,'Value')));


% --- Executes during object creation, after setting all properties.
function sliderContrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editBright_Callback(hObject, eventdata, handles)
% hObject    handle to editBright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBright as text
%        str2double(get(hObject,'String')) returns contents of editBright as a double


% --- Executes during object creation, after setting all properties.
function editBright_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function editContrast_Callback(hObject, eventdata, handles)
% hObject    handle to editContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editContrast as text
%        str2double(get(hObject,'String')) returns contents of editContrast as a double


% --- Executes during object creation, after setting all properties.
function editContrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbuttonContrastBrightness.
function pushbuttonContrastBrightness_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonContrastBrightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.fileLoaded==1)
    handles.RGB2 = changeBrightness(handles.RGB, get(handles.sliderBright, 'Value'), get(handles.sliderContrast, 'Value'));
    axes(handles.axes2); imshow(handles.RGB2);
    handles.fileLoaded2 = 1;
    handles = updateHistograms(handles);
    guidata(hObject, handles);
else
    h = msgbox('No primary file has been loaded!','Error','error');
end


function handlesNew = updateHistograms(handles)
handlesNew = handles;
if (handles.fileLoaded == 1)
    set(handles.textHist1, 'Visible', 'on');
    axes(handlesNew.axesHist1); 
    cla;
    ImageData1 = reshape(handlesNew.RGB(:,:,1), [size(handlesNew.RGB, 1) * size(handlesNew.RGB, 2) 1]);
    ImageData2 = reshape(handlesNew.RGB(:,:,2), [size(handlesNew.RGB, 1) * size(handlesNew.RGB, 2) 1]);
    ImageData3 = reshape(handlesNew.RGB(:,:,3), [size(handlesNew.RGB, 1) * size(handlesNew.RGB, 2) 1]);
    [H1, X1] = hist(ImageData1, 1:5:256);
    [H2, X2] = hist(ImageData2, 1:5:256);
    [H3, X3] = hist(ImageData3, 1:5:256);
    hold on;
    plot(X1, H1, 'r');
    plot(X2, H2, 'g');
    plot(X3, H3, 'b');    
    axis([0 256 0 max([H1 H2 H3])]);
end
if (handlesNew.fileLoaded2 == 1)
    set(handles.textHist2, 'Visible', 'on');
    axes(handlesNew.axesHist2); 
    cla;
    ImageData1 = reshape(handlesNew.RGB2(:,:,1), [size(handlesNew.RGB2, 1) * size(handlesNew.RGB2, 2) 1]);
    ImageData2 = reshape(handlesNew.RGB2(:,:,2), [size(handlesNew.RGB2, 1) * size(handlesNew.RGB2, 2) 1]);
    ImageData3 = reshape(handlesNew.RGB2(:,:,3), [size(handlesNew.RGB2, 1) * size(handlesNew.RGB2, 2) 1]);
    [H1, X1] = hist(ImageData1, 1:5:256);
    [H2, X2] = hist(ImageData2, 1:5:256);
    [H3, X3] = hist(ImageData3, 1:5:256);
    hold on;
    plot(X1, H1, 'r');
    plot(X2, H2, 'g');
    plot(X3, H3, 'b');    
    axis([0 256 0 max([H1 H2 H3])]);    
end



% --- Executes on button press in RotateButton.
function RotateButton_Callback(hObject, eventdata, handles)
% hObject    handle to RotateButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.RGB2 = imrotate(handles.RGB, round(get(handles.sliderRotate,'Value')));
handles.fileLoaded = 1;

axes(handles.axes2); cla; imshow(handles.RGB2);

handles = updateHistograms(handles);

guidata(hObject, handles);



% --- Executes on slider movement.
function sliderRotate_Callback(hObject, eventdata, handles)
% hObject    handle to sliderRotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.editRotate,'String', sprintf('%10s:%4.0f', 'Rotate', round(get(handles.sliderRotate,'Value'))));

% --- Executes during object creation, after setting all properties.
function sliderRotate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderRotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editRotate_Callback(hObject, eventdata, handles)
% hObject    handle to editRotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRotate as text
%        str2double(get(hObject,'String')) returns contents of editRotate as a double


% --- Executes during object creation, after setting all properties.
function editRotate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


