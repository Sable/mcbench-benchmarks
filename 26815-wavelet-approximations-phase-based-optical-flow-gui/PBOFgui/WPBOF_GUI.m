function varargout = WPBOF_GUI(varargin)
%02/28/10
%author: Michael P Dessauer
%
%This method implements a phase-based Opic Flow Algorithm described in:
% Gautama, T. and Van Hulle, M.M. (2002).  A Phase-based Approach to the
% Estimation of the Optical Flow Field Using Spatial Filtering.
% IEEE Trans. Neural Networks, 13(5), 1127--1136.
%http://www.mathworks.de/matlabcentral/fileexchange/2422-phase-based-optica
%l-flow
%
%This method is used for tracking wavelet/optical flow-based
%detection for automatic target recognition in the following paper:
%
%3.	Dessauer, M. and Dua S. “Wavelet-based optical flow object detection,
%motion estimation, and tracking on moving vehicles” 
%Proc. Conf. SPIE Defense, Security, and Sensing. 7694-56. April 5-9, 2010.
%
% Additionally, the user can select wavelet approximation type and level
% for reducing image size. All of the paprameters are described in the
% optical_flow_wav.m function, expect for winSize, which controls the size
% of the gabor filters. "Quiver Size" gives the amount of locations in the
% x and y axis for the quiver plot

% An initial test image sequence is provided an automatically loaded. This
% image sequence is a subset from the Video Surveeillance Online Repository
% (VISOR) located:
% http://imagelab.ing.unimore.it/visor/video_details.asp?idvideo=339

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WPBOF_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @WPBOF_GUI_OutputFcn, ...
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


% --- Executes just before WPBOF_GUI is made visible.
function WPBOF_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to WPBOF_GUI (see VARARGIN)

%Load initial image sequence
load VisionTraffic.mat
handles.current_data=data;
%Show the image 
imagesc(handles.current_data(:,:,1),'Parent',handles.imageView);
stackLen = size(handles.current_data,3);
%Set the image sequence slider max and min values, current, and step size
set(handles.slider1,'Min',1);
set(handles.slider1,'Max',stackLen);
set(handles.slider1,'Value',1);
stepSize(1)=1/stackLen;
stepSize(2)=1/stackLen*4;
set(handles.slider1,'sliderstep',stepSize);
colormap gray
handles.gotOF=0;
handles.nc_min = 5;
handles.wavLevel = 2;
handles.wavType = 'haar';
handles.thresh_lin = .05;
handles.gx = 0;
handles.winNum = 1;
handles.tempNum = 2;
handles.quiverSize = [50 50];
handles.timeTotal = 0;
handles.timePerFrame = 0;
handles.uniqueID = 0;


handles.pressStop=0;
handles.pressPause=0;


% Choose default command line output for WPBOF_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes WPBOF_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = WPBOF_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browseImgStack.
function browseImgStack_Callback(hObject, eventdata, handles)
% hObject    handle to browseImgStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiopen('matlab');
handles.current_data=data;
set(handles.slider1,'Max',size(handles.current_data,3));
guidata(hObject,handles);

% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imgStack = handles.current_data;
%get start value
startFrame=get(handles.slider1,'Value');

str = get(hObject,'String');

state=find(strcmp(str,handles.Strings)); 

set(hObject,'String',handles.Strings{3-state}); 

%Set up values for the optical flow NEED TO FIX!!!
if handles.gotOF~=0
    tempFront = size(imgStack,3)-size(handles.u,3);
    tempBack = tempFront;
else
    tempFront=0;
    tempBack=0;
end
OFexist=1;


if (state==1)
    for i=startFrame:size(imgStack,3)-tempBack
         if find(strcmp(get(hObject,'String'),...
                handles.Strings)) == 1
            guidata(hObject,handles);
            break
         end
        imagesc(imgStack(:,:,i),'Parent',handles.imageView);
        set(handles.slider1,'Value',i);
        set(handles.slider_editText,'String',num2str(i))
        if OFexist==1 && handles.gotOF~=0
            imagesc(handles.u(:,:,i),'Parent',handles.OFviewX);
            imagesc(handles.v(:,:,i),'Parent',handles.OFviewY);
            imagesc(handles.current_data(:,:,i),'Parent',handles.OFcombine);
            hold on
            [u1 v1 x y] = resizeQuiver(handles.u(:,:,i),handles.v(:,:,i),handles.current_data(:,:,i),handles.quiverSize);
            quiver(x,y,u1,v1,'Parent',handles.OFcombine,'y');
        end
        handles.currentFrame=i;
        guidata(hObject,handles);
        pause(.75);
    end
end

if handles.currentFrame==size(imgStack,3)-tempBack
    pause(1);
    set(handles.slider1,'Value',startFrame);
    set(handles.slider_editText,'String',num2str(startFrame));
end
set(hObject,'String',handles.Strings{1}); 
guidata(hObject,handles);


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to imgStackSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% set(hObject,'Min')=1;
% set(hObject,'Max')=size(handles.current_data,3);

%obtain the slider value from the slider component
sliderValue=round(get(hObject,'Value'));
%puts the slider value into the edit text component
set(handles.slider_editText,'String',num2str(sliderValue))
%displays the slider value frame number
imagesc(handles.current_data(:,:,sliderValue),'Parent',handles.imageView);
if handles.gotOF==1 && sliderValue<=size(handles.u,3)
   imagesc(handles.u(:,:,sliderValue),'Parent',handles.OFviewX);
   imagesc(handles.v(:,:,sliderValue),'Parent',handles.OFviewY);
   imagesc(handles.current_data(:,:,sliderValue),'Parent',handles.OFcombine);
   hold on
   [u1 v1 x y] = resizeQuiver(handles.u(:,:,sliderValue),handles.v(:,:,sliderValue),...
       handles.current_data(:,:,sliderValue),handles.quiverSize);
   quiver(x,y,u1,v1,'Parent',handles.OFcombine,'y');
end
%Updates handles structure
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgStackSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
% set(handles.slider1,'Min',1);
% set(handles.slider1,'Max',size(handles.current_data,3));
% set(handles.slider1,'Value',1);

guidata(hObject,handles);


function slider_editText_Callback(hObject, eventdata, handles)
% hObject    handle to slider_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of slider_editText as text
%        str2double(get(hObject,'String')) returns contents of slider_editText as a double
sliderValue = get(handles.slider_editText,'String');

%convrt from string to number if possible, otherwise returns empty
sliderValue = str2num(sliderValue);

%if user inputs something is not a number, or if the input is less than 0
%or greater than 100, then the slider value defaults to 0
if (isempty(sliderValue) || sliderValue < 1 || sliderValue > 3)
    set(handles.slider1,'Value',1);
    set(handles.slider_editText,'String','1');
else
    set(handles.slider1,'Value',sliderValue);
end

% --- Executes during object creation, after setting all properties.
function slider_editText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function play_CreateFcn(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.Strings = {'Play';'Pause'}; 
% Commit the new struct element to appdata
guidata(hObject, handles); 



function wavLevel_Callback(hObject, eventdata, handles)
% hObject    handle to wavLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wavLevel as text
%        str2double(get(hObject,'String')) returns contents of wavLevel as a double
handles.wavLevel = round(str2num(get(hObject,'String')));
guidata(hObject, handles); 

% --- Executes during object creation, after setting all properties.
function wavLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wavLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.wavLevel = 2;
set(hObject,'String',num2str(handles.wavLevel));
guidata(hObject, handles); 





function gx_Callback(hObject, eventdata, handles)
% hObject    handle to gx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gx as text
%        str2double(get(hObject,'String')) returns contents of gx as a double
handles.gx=str2num(get(hObject,'String'));
guidata(hObject, handles); 

% --- Executes during object creation, after setting all properties.
function gx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.gx = 0;
set(hObject,'String',num2str(handles.gx));
guidata(hObject, handles); 



function thresh_lin_Callback(hObject, eventdata, handles)
% hObject    handle to thresh_lin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresh_lin as text
%        str2double(get(hObject,'String')) returns contents of thresh_lin as a double
handles.thresh_lin=str2num(get(hObject,'String'));
guidata(hObject, handles); 

% --- Executes during object creation, after setting all properties.
function thresh_lin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresh_lin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.thresh_lin = .05;
set(hObject,'String',num2str(handles.thresh_lin));
guidata(hObject, handles); 


function winNum_Callback(hObject, eventdata, handles)
% hObject    handle to winNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of winNum as text
%        str2double(get(hObject,'String')) returns contents of winNum as a double
handles.winNum=str2num(get(hObject,'String'));
guidata(hObject, handles); 

% --- Executes during object creation, after setting all properties.
function winNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to winNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.winNum = 1;
set(hObject,'String',num2str(handles.winNum));
guidata(hObject, handles); 



function tempNum_Callback(hObject, eventdata, handles)
% hObject    handle to tempNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tempNum as text
%        str2double(get(hObject,'String')) returns contents of tempNum as a double
handles.tempNum=round(str2num(get(hObject,'String')));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function tempNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tempNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.tempNum = 2;
set(hObject,'String',num2str(handles.tempNum));
guidata(hObject, handles); 



function nc_min_Callback(hObject, eventdata, handles)
% hObject    handle to nc_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nc_min as text
%        str2double(get(hObject,'String')) returns contents of nc_min as a double
handles.nc_min=round(str2num(get(hObject,'String')));
guidata(hObject, handles); 

% --- Executes during object creation, after setting all properties.
function nc_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nc_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.nc_min = 5;
set(hObject,'String',num2str(handles.nc_min));
guidata(hObject, handles); 


% --- Executes on button press in getOpticalFlow.
function getOpticalFlow_Callback(hObject, eventdata, handles)
% hObject    handle to getOpticalFlow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
col = get(hObject,'backg');
set(hObject,'str','RUNNING...','backg',[1 .6 .6])
pause(.01)
tic;
[handles] = PBOF_wav(handles);
%Get time values and display them
handles.timeTotal=toc;
set(handles.staticTimeTotal,'String',num2str(handles.timeTotal));
handles.timePerFrame=handles.timeTotal/size(handles.u,3);
set(handles.staticTimePreFrame,'String',num2str(handles.timePerFrame));
%Now revert back to original push button color
set(hObject,'str','Get Opitical Flow','backg',col);
imagesc(handles.u(:,:,1),'Parent',handles.OFviewX);
imagesc(handles.v(:,:,1),'Parent',handles.OFviewY);
set(handles.slider1,'Max',size(handles.u,3));
handles.gotOF=1;
guidata(hObject, handles);



% --- Executes on selection change in wavLevelMenu.
function wavLevelMenu_Callback(hObject, eventdata, handles)
% hObject    handle to wavLevelMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.wavLevel=round(str2num(get(hObject,'String')));
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns wavLevelMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from wavLevelMenu


% --- Executes during object creation, after setting all properties.
function wavLevelMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wavLevelMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when uipanel3 is resized.
function uipanel3_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in wavType.
function wavType_Callback(hObject, eventdata, handles)
% hObject    handle to wavType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns wavType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from wavType
switch get(hObject,'Value')   
    case 'haar'
        handles.wavTpe='haar';
    case 'db1'
        handles.wavTpe='db1';
    case 'db3'
        handles.wavTpe='db3';
    case 'sym'
        handles.wavTpe='sym';
    otherwise
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function wavType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wavType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadWorkspaceMat.
function loadWorkspaceMat_Callback(hObject, eventdata, handles)
% hObject    handle to loadWorkspaceMat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
importVariable = cell2mat(inputdlg('Enter name of base workspace variable that has mapData')); 
% make sure the input matches a variable that exists in base: 
baseVars = evalin('base','who()'); 
if max(strcmp(baseVars,importVariable))==0, error('nomatch'), end;
imSeq=evalin('base',importVariable);
if ndims(imSeq)==3
   handles.current_data = imSeq;
   imagesc(handles.current_data(:,:,1),'Parent',handles.imageView);
else
    error('Not correct dimensions');
end
guidata(hObject, handles);
% setappdata(fH,'mapData',evalin('base',importVariable)); 
% Then do some error-checking to be sure it is a proper map s



function quiverSizeX_Callback(hObject, eventdata, handles)
% hObject    handle to quiverSizeX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of quiverSizeX as text
%        str2double(get(hObject,'String')) returns contents of quiverSizeX as a double
handles.quiverSize(1)=round(str2num(get(hObject,'String')));
guidata(hObject, handles); 

% --- Executes during object creation, after setting all properties.
function quiverSizeX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to quiverSizeX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function quiverSizeY_Callback(hObject, eventdata, handles)
% hObject    handle to quiverSizeY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of quiverSizeY as text
%        str2double(get(hObject,'String')) returns contents of quiverSizeY as a double
handles.quiverSize(2)=round(str2num(get(hObject,'String')));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function quiverSizeY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to quiverSizeY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function staticTimePreFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to staticTimePreFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in createOpticalFlowMatFile.
function createOpticalFlowMatFile_Callback(hObject, eventdata, handles)
% hObject    handle to createOpticalFlowMatFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.gotOF==1
   O(:,:,:,1)=handles.u;
   O(:,:,:,2)=handles.v;
   if handles.uniqueID==1
       varName = strcat('OF_wavType',handles.wavType,'wavLev',int2str(handles.wavLevel),...
           'gx',handles.gx,'threshLin',num2str(100*handles.thresh_lin),'winSize',num2str(10*handles.winNum),...
           'tempNum',int2str(handles.tempNum),'ncMin',int2str(handles.nc_min));
   else
       varName = 'O';
   end
   assignin('base',varName,O);
end


% --- Executes on button press in createUniqueName.
function createUniqueName_Callback(hObject, eventdata, handles)
% hObject    handle to createUniqueName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of createUniqueName
checkBox = get(hObject,'Value');
if (checkBox)
    handles.uniqueID=1;
end
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extra functions required to run
function [u1 v1 x y] = resizeQuiver(u,v,img,quiverSize)

%This function resizes velocity measures (u,v) to overlay onto an image
%(img) to size (quiverSize) so that velocity values can be visualized more
%effectively

%check to see if quiverSize is 1 or 2 values
if max(size(quiverSize))==1
    quiverSize(2)=quiverSize(1);
end
%First stage is resizing velocity values
uR = imresize(u,[quiverSize(2) quiverSize(1)],'bilinear');
vR = imresize(v,[quiverSize(2) quiverSize(1)],'bilinear');

%Now flip to correctly index with quiver

%uR = flipud(uR);
%vR = flipud(vR);

%Now reshape these matrices into vector form
[imR imC] = size(img);

scaleR = imR/quiverSize(1);
scaleC = imC/quiverSize(2);

count=1;
for i=1:quiverSize(1)
    for j=1:quiverSize(2)
        u1(count)=uR(i,j);
        v1(count)=vR(i,j);
        y(count)=round((i-1)*scaleR+1);
        x(count)=round((j-1)*scaleC+1);
        count=count+1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [handles] = PBOF_wav(handles)


%Now get the correct resized data
[r c t] = size(handles.current_data);
for i=1:t
    [C1,S1] = wavedec2(handles.current_data(:,:,i),handles.wavLevel,handles.wavType);
    II(:,:,i)=appcoef2(C1,S1,handles.wavLevel,handles.wavType);
end

%Now start the iteration for acquiring optical flow
for i=1:size(II,3)-handles.tempNum

    %Now get the optical flow using the values set above
    O = optical_flow_wav(II(:,:,i:i+handles.tempNum-1), handles.gx, handles.thresh_lin, handles.nc_min,handles.winNum);
    
    O = nan2zero(O);
    %Get optical flow values (resized to original frame dims)
    u(:,:,i)=2^(handles.wavLevel).*imresize(O(:,:,1),[r c],'bilinear');
    v(:,:,i)=2^(handles.wavLevel).*imresize(O(:,:,2),[r c],'bilinear');

end

handles.u=u;
handles.v=v;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [zeroMat] = nan2zero(nanMat)
%
%This function changes values in nanMat == NaN to zero

zeroMat = zeros(size(nanMat));

ind = find(isnan(nanMat)==0);

zeroMat(ind) = nanMat(ind);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Phase-based Opic Flow Algorithm, described in
% Gautama, T. and Van Hulle, M.M. (2002).  A Phase-based Approach to the
% Estimation of the Optical Flow Field Using Spatial Filtering.
% IEEE Trans. Neural Networks, 13(5), 1127--1136.
%
% Usage: O = optical_flow (II, gx, thres_lin, nc_min)
%	II [sy sx st]	Image Sequence (Y-X-t)
%	gx		Number of velocity vectors along X-axis (0=all)
%	thres_lin	Linearity threshold [.05]
%	nc_min		Minimal number of valid component velocities for
%				computation of full velocity [5]

function O = optical_flow_wav (II, gx, thres_lin, nc_min,winSize)

if (nargin<1)
	error ('Please provide an input sequence');
end
if (nargin<2)
	gx = 0;
end
if (nargin<3)
	thres_lin = .05;
end
if (nargin<4)
	nc_min = 5;
end
[sy sx st] = size(II);

if (gx==0)
	jmp = 1;
else
	jmp = floor(sx/gx);
	jmp = jmp + (jmp==0);
end

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% Load Filterbank Parameters %
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
W = [	0.02156825 -0.08049382; ...
	0.05892557 -0.05892557; ...
	0.08049382 -0.02156825; ...
	0.08049382 0.02156825; ...
	0.05892557 0.05892557; ...
	0.02156825 0.08049382; ...
	0.06315486 -0.10938742; ...
	0.10938742 -0.06315486; ...
	0.12630971 0.00000000; ...
	0.10938742 0.06315486; ...
	0.06315486 0.10938742];
S = [9.31648319 9.31648319 9.31648319 9.31648319 9.31648319 9.31648319 ...
	6.14658664 6.14658664 6.14658664 6.14658664 6.14658664]';
nn = size(W,1);

		%%%%%%%
		% Aux %
		%%%%%%%
xx = (1:st);
xx3 = zeros(1,1,st);
xx3(1:st) = 1:st;
Sxx = sum(xx.^2);
Sx = sum(xx);
den = (st.*Sxx-Sx.^2);
pi2 = 2*pi;


		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% Compute Filter Outputs & Component Velocities %
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tclock1 = clock;
AC = zeros(sy,sx,st);
AS = zeros(sy,sx,st);
FV = zeros(nn,sy,sx);	% Filter Component Velocity
LE = zeros(nn,sy,sx);	% MSE of Regression
Ec = zeros(sy,sx,nn);
%offset = ceil(max(S)*sqrt(log(100)));	% Point where Gaussian envelope drops to 10%
offset=0;
[offx offy] = meshgrid(1:sx,1:sy);
for n=1:nn;end;
for i=offset+1:jmp:(sy-offset);end;
for n=1:nn
	% Generate 1D kernels
	win_len = floor(winSize*S(n));
	cx = (0:win_len-1)'-win_len/2+.5;
	cx2 = pi2.*cx;
	G = exp(-cx.^2./(2*S(n)*S(n)))./(sqrt(2*pi)*S(n));
	FCx = G.*cos(W(n,1).*cx2);
	FCy = G.*cos(W(n,2).*cx2);
	FSx = G.*sin(W(n,1).*cx2);
	FSy = G.*sin(W(n,2).*cx2);

	% Exceptions for null frequencies
	if (sum(FCx.^2)==0)
		FCx = ones(win_len,1);
	end
	if (sum(FCy.^2)==0)
		FCy = ones(win_len,1);
	end
	if (sum(FSx.^2)==0)
		FSx = ones(win_len,1);
	end
	if (sum(FSy.^2)==0)
		FSy = ones(win_len,1);
	end

	% Perform Convolutions, room for improvement (subsampling)
	for t=1:st
		IIp = II(:,:,t)';

		% Sine Filter
		Tsx = conv2(IIp, FSx, 'same')';
		T2 = conv2(Tsx, FCy, 'same');
		Tcx = conv2(IIp, FCx, 'same')';
		T4 = conv2(Tcx, FSy, 'same');
		AS(:,:,t) = T2 + T4;

		% Cosine Filter
		%Tcx = conv2(IIp, FCx, 'same')';
		T2 = conv2(Tcx, FCy, 'same');
		%Tsx = conv2(IIp, FSx, 'same')';
		T4 = conv2(Tsx, FSy, 'same');
		AC(:,:,t) = T2 - T4;
	end

	% Compute and Unwrap Phase
	Mcos = (AC==0);
	P = atan(AS./(AC+Mcos))+pi.*(AC<0);
	P(Mcos) = NaN;
	k = 2;
	while (k<=st)
		D = P(:,:,k) - P(:,:,k-1);
		A = abs(D)>pi;
		P(:,:,k:st) = P(:,:,k:st) - repmat(pi2.*sign(D).*A,[1 1 st-k+1]);
		k = k + (sum(sum(A))==0);
	end

	% Compute Filter Component Velocity
	Sxy = sum(repmat(xx3,[sy sx 1]).*P,3);
	Sy = sum(P,3);
	a = (Sxx.*Sy-Sx.*Sxy)./den;
	b = (st.*Sxy-Sx.*Sy)./den;
	Reg = repmat(a,[1 1 st])+repmat(b,[1 1 st]).*repmat(xx3,[sy sx 1]);
	LE(n,:,:) = mean((Reg-P).^2,3)./abs(b+(b==0));
	FV(n,:,:) = -b./(pi2*sum(W(n,:).^2)).*(W(n,1)+sqrt(-1)*W(n,2));

% 	fprintf ('*');

end
tclock2 = clock;
time1 = etime(tclock2,tclock1);

		%%%%%%%%%%%%%%%%%%%%%%%%%
		% Compute Full Velocity %
		%%%%%%%%%%%%%%%%%%%%%%%%%
O = repmat(NaN, [sy sx 2]);
for i=offset+1:jmp:(sy-offset)
  for j=offset+1:jmp:(sx-offset)

	% Linearity Check
	IND1 = find(LE(:,i,j)<thres_lin);
	V = FV(IND1,i,j);
	nc = length(IND1);

	if (nc>=nc_min)
		L_2 = V.*conj(V);
		X = real(V);
		Y = imag(V);
		sumX = sum(X);
		sumY = sum(Y);
		sumXYL_2 = sum(X.*Y./L_2);
		sumXXL_2 = sum(X.^2./L_2);
		sumYYL_2 = sum(Y.^2./L_2);
		den = (sumXYL_2^2-sumXXL_2*sumYYL_2);
		xr = -(sumX*sumYYL_2-sumY*sumXYL_2) / den;
		yr = (sumX*sumXYL_2-sumY*sumXXL_2) / den;
		O(i,j,:) = [xr yr];

	end
  end
%   fprintf ('*');
end
% fprintf ('\n');
tclock3 = clock;
time2 = etime(tclock3, tclock2);
% fprintf ('\tElapsed time: %.2f + %.2f = %.2f [sec]\n', time1, time2, time1+time2);
