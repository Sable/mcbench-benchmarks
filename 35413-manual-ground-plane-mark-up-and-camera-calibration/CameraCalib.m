function varargout = CameraCalib(varargin)
%CAMERACALIB M-file for CameraCalib.fig
%      CAMERACALIB, by itself, creates a new CAMERACALIB or raises the existing
%      singleton*.
%
%      H = CAMERACALIB returns the handle to a new CAMERACALIB or the handle to
%      the existing singleton*.
%
%      CAMERACALIB('Property','Value',...) creates a new CAMERACALIB using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to CameraCalib_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      CAMERACALIB('CALLBACK') and CAMERACALIB('CALLBACK',hObject,...) call the
%      local function named CALLBACK in CAMERACALIB.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CameraCalib

% Last Modified by GUIDE v2.5 29-Feb-2012 13:54:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CameraCalib_OpeningFcn, ...
                   'gui_OutputFcn',  @CameraCalib_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before CameraCalib is made visible.
function CameraCalib_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for CameraCalib
handles.output = hObject;
%setDefaultCamera(hObject, handles)
% Update handles structure


guidata(hObject, handles);





% UIWAIT makes CameraCalib wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CameraCalib_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in toggleDisplayAxis.
function toggleDisplayAxis_Callback(hObject, eventdata, handles)
% hObject    handle to toggleDisplayAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleDisplayAxis
refreshImage(handles)

% --- Executes on button press in toggleDispGrid.
function toggleDispGrid_Callback(hObject, eventdata, handles)
% hObject    handle to toggleDispGrid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleDispGrid
refreshImage(handles);

% --- Executes on button press in toggleDispScale.
function toggleDispScale_Callback(hObject, eventdata, handles)
% hObject    handle to toggleDispScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleDispScale
refreshImage(handles);

% --- Executes on button press in pbLoadImage.
function pbLoadImage_Callback(hObject, eventdata, handles)
% hObject    handle to pbLoadImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname]=uigetfile(['*'],'Select image to load');

if filename ~= 0
   % = guidata(handles.figure1);
    handles.Image = imread([pathname filename]);
    handles.ImSize = size(handles.Image);
    handles.ImLoaded = 1;
    handles.P1 = [0,0,0]';
    handles.P2 = [0,0,1]';
    handles.Origin = [0,0,0]';
    handles.offset = [handles.ImSize(1)/2, handles.ImSize(2)/2];
    handles.R = [1 0 0 0; 0 1 0 0; 0 0 1 0];
   
    guidata(hObject, handles);
    setDefaultCamera(hObject, handles);
     handles = guidata(hObject);
    refreshImage(handles);
    
end

function setDefaultCamera(hObject, handles)

focalLength = sscanf(get(handles.edtFocalLength, 'String'), '%f');
SensorHeight = sscanf(get(handles.edtSensorHeight, 'String'), '%f');
conversionFactor = handles.ImSize(1)/SensorHeight;

handles.F = [conversionFactor*focalLength 0 handles.ImSize(2)/2.0; 0 conversionFactor*focalLength handles.ImSize(1)/2.0; 0 0 1];

guidata(hObject, handles);

function Test_ButtonDownFcn(hObject)



pos = get(gca, 'CurrentPoint');
handles = guidata(gcf);
depth = sscanf(get(handles.edtDepth, 'String'), '%f');

if (get(handles.cbEdit, 'Value'))
    handles.offset = [pos(1,2), pos(1,1)];

    if (get(handles.cbP1, 'Value'))
        X = getPosition(pos(1,2), pos(1,1), depth, handles.F);
        handles.P1 = X;
    end
    if (get(handles.cbP2, 'Value'))
         X = getPosition(pos(1,2), pos(1,1), depth, handles.F);
        handles.P2 = X;
    end
    if (get(handles.cbOrigin, 'Value'))
        X = getPosition(pos(1,2), pos(1,1), depth, handles.F);
        handles.Origin = X;
    end
    guidata(hObject, handles);
    handles = guidata(hObject);
    refreshImage(handles);
end

function refreshImage(handles)
hold on;
cla;
h = imshow(handles.Image, 'Parent', handles.axes1);
hold on;
set(h,'ButtonDownFcn', 'CameraCalib(''Test_ButtonDownFcn'',gcbo)');

%set(h,'HitTest','off')

set(handles.cbP1, 'String', ['P1 = [' num2str(handles.P1(1)) ',' num2str(handles.P1(2)) ',' num2str(handles.P1(3)) ']']);
 set(handles.cbP2, 'String', ['P2 = [' num2str(handles.P2(1)) ',' num2str(handles.P2(2)) ',' num2str(handles.P2(3)) ']']);
 set(handles.cbOrigin, 'String', ['Origin = [' num2str(handles.Origin(1)) ',' num2str(handles.Origin(2)) ',' num2str(handles.Origin(3)) ']']);

 
 handles.R = updateR(handles);
 
P = handles.F*handles.R;
ImDims = handles.ImSize;

if get(handles.toggleDispScale,'Value')
    depth = sscanf(get(handles.edtDepth, 'String'), '%f');
    tickWidth = sscanf(get(handles.edtTickSep, 'String'), '%f');
    
    [xScale, yScale] = buildScaleXY(handles.F, depth, tickWidth, handles.offset(2), handles.offset(1), ImDims);
    plot(xScale(1,:), xScale(2,:),'.r');
    plot(yScale(1,:), yScale(2,:), '.g');
end

if get(handles.toggleDispGrid,'Value')
    
    tickWidth = sscanf(get(handles.edtTickGP, 'String'), '%f');
    length = sscanf(get(handles.edtLength, 'String'), '%f');
     height = sscanf(get(handles.edtHeight, 'String'), '%f');
    [xLines, yLines] = buildGridXY(P, tickWidth, length, height, handles);
    plot([xLines(1,1:end/2); xLines(1,end/2+1:end)], [xLines(2,1:end/2); xLines(2,end/2+1:end)],'r');
     plot([yLines(1,1:end/2); yLines(1,end/2+1:end)], [yLines(2,1:end/2); yLines(2,end/2+1:end)],'r');
    %plot(yScale(1,:), yScale(2,:), '.g');
end

if get(handles.toggleDisplayAxis,'Value')
    [aX aY aZ] = buildGridAxis(P);
    plot(aX(1,:),aX(2,:), 'r');
    text(aX(1,2),aX(2,2),'x');

    
    plot(aY(1,:),aY(2,:), 'g');
    text(aY(1,2),aY(2,2),'y');
    
    plot(aZ(1,:),aZ(2,:), 'b');
    text(aZ(1,2),aZ(2,2),'z');
    %plot(yScale(1,:), yScale(2,:), '.g');
end

function X = getPosition(yPos, xPos, depth, F)

Y = [xPos; yPos; 1];
R = [F(:,1), F(:,2) F(:,3)*depth];
X = inv(R)*Y;
X = X/X(3);
X(3) = depth;

function [X Y Z] = buildGridAxis(P)

x = [1000, 0,0]';

Axis3 = ones(4,4);
Axis3(1:3,1) = 0;
Axis3(1:3,2) = x;

y = [0, 1000, 0]';
Axis3(1:3,3) = y;

z = [0,0,1000]';
Axis3(1:3,4) = z;

Axis2 = zeros(3,4);
for i = 1:4
    Axis2(:,i) = P*Axis3(:,i);
end 
Axis2 = Axis2./(Axis2(ones(3,1)*3,:));

X = Axis2([1:2],[1,2]);
Y = Axis2([1:2],[1,3]);
Z = Axis2([1:2],[1,4]);


function R = updateR(handles)
x = [1, 0,0]';
y = handles.P2-handles.P1;
y(1) = 0;
y = y/norm(y);
z = cross(x,y);
R = [x, y, z];
c = handles.Origin;
R = [R, c];

function [xLines, yLines] = buildGridXY(P, tickWidth, length, height, handles)

%calc X and Y coord

ticks = 0:tickWidth:height;



nTicks = size(ticks,2);

xAxis = zeros(4, nTicks*2);
xAxis(4,:) = 1.0;
xAxis(2, 1:end/2) = ticks;
xAxis(2, end/2+1:end) = ticks;
xAxis(1, end/2+1:end) = length;

xLines = zeros(3,nTicks*2);
for i = 1:nTicks*2
    xLines(:,i) = P*xAxis(:,i);
end
xLines = xLines./(xLines(ones(3,1)*3, :));


% now do y axis
ticks = 0:tickWidth:length;

%ticks(4,:) = 1;

nTicks = size(ticks,2);

yAxis = zeros(4, nTicks*2);
yAxis(4,:) = 1.0;
yAxis(1, 1:end/2) = ticks;
yAxis(1, end/2+1:end) = ticks;
yAxis(2, end/2+1:end) = height;

yLines = zeros(3,nTicks*2);
for i = 1:nTicks*2
    yLines(:,i) = P*yAxis(:,i);
end
yLines = yLines./(yLines(ones(3,1)*3, :));

function [xScale, yScale] = buildScaleXY(F, depth, tickWidth, xOfset, YOfset, ImDims)

scales = F(1)*tickWidth/depth;

xScale = 0:abs(scales):ImDims(2);
[val pos] =  min(abs(xScale - xOfset));
xScale = xScale - (xScale(pos) - xOfset);
xScale(xScale < 0) = [];
xScale(xScale > ImDims(2)) = [];
xScale(2,:) = YOfset;



yScale = 0:abs(scales):ImDims(1);
[val pos] =  min(abs(yScale - YOfset));
yScale = yScale - min(yScale(pos)- YOfset);

yScale(2,:) = yScale;
yScale(:,yScale(2,:) < 0) = [];
yScale(:, yScale(2,:) > ImDims(1)) = [];
yScale(1,:) = xOfset;

% --- Executes on button press in pbSaveCalibration.
function pbSaveCalibration_Callback(hObject, eventdata, handles)
% hObject    handle to pbSaveCalibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = UIPUTFILE('*.mat', 'Save Calibration Data', 'Image1.mat');

if (filename ~= 0)
   Camera.F = handles.F;
    handles.R = updateR(handles);
   Camera.R = handles.R;
   Camera.P = handles.F*handles.R;
   
   Camera.length = sscanf(get(handles.edtLength, 'String'), '%f');
   Camera.height = sscanf(get(handles.edtHeight, 'String'), '%f');
   Camera.focalLength = sscanf(get(handles.edtFocalLength, 'String'), '%f');
   Camera.sensorHeight = sscanf(get(handles.edtSensorHeight, 'String'), '%f');
   Camera.conversionFactor = handles.ImSize(1)/Camera.sensorHeight;
   
   save([pathname filename], 'Camera');
   
end

% --- Executes on button press in cbEdit.
function cbEdit_Callback(hObject, eventdata, handles)
% hObject    handle to cbEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbEdit



function edtFocalLength_Callback(hObject, eventdata, handles)
% hObject    handle to edtFocalLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtFocalLength as text
%        str2double(get(hObject,'String')) returns contents of edtFocalLength as a double
setDefaultCamera(hObject, handles);
handles = guidata(hObject);
refreshImage(handles);

% --- Executes during object creation, after setting all properties.
function edtFocalLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtFocalLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called





function edtTickSep_Callback(hObject, eventdata, handles)
% hObject    handle to edtTickSep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtTickSep as text
%        str2double(get(hObject,'String')) returns contents of edtTickSep as a double
setDefaultCamera(hObject, handles);
handles = guidata(hObject);
refreshImage(handles);

% --- Executes during object creation, after setting all properties.
function edtTickSep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtTickSep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function edtSensorHeight_Callback(hObject, eventdata, handles)
% hObject    handle to edtSensorHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtSensorHeight as text
%        str2double(get(hObject,'String')) returns contents of edtSensorHeight as a double
setDefaultCamera(hObject, handles);
handles = guidata(hObject);
refreshImage(handles);

% --- Executes during object creation, after setting all properties.
function edtSensorHeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtSensorHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edtDepth_Callback(hObject, eventdata, handles)
% hObject    handle to edtDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtDepth as text
%        str2double(get(hObject,'String')) returns contents of edtDepth as a double
setDefaultCamera(hObject, handles);
handles = guidata(hObject);
refreshImage(handles);

% --- Executes during object creation, after setting all properties.
function edtDepth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on scroll wheel click while the figure is in focus.
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)


P = handles.F*handles.R;

if (get(handles.cbEdit, 'Value'))
    depth = sscanf(get(handles.edtDepth, 'String'), '%f');
    depthInc = sscanf(get(handles.edtDepthInc, 'String'), '%f');
     
    depth = depth+ eventdata.VerticalScrollCount*depthInc;
    set(handles.edtDepth, 'String', num2str(depth));
    
    
    if (get(handles.cbP1, 'Value'))
        X = getPosition(handles.offset(1), handles.offset(2), depth, handles.F);
        handles.P1 = X;
    end
    if (get(handles.cbP2, 'Value'))
         X = getPosition(handles.offset(1), handles.offset(2), depth, handles.F);
        handles.P2 = X;
    end
    
    if (get(handles.cbOrigin, 'Value'))
         X = getPosition(handles.offset(1), handles.offset(2), depth, handles.F);
        handles.Origin = X;
    end
    guidata(hObject, handles);
    handles = guidata(hObject);
    refreshImage(handles);
    
    
end

function edtDepthInc_Callback(hObject, eventdata, handles)
% hObject    handle to edtDepthInc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtDepthInc as text
%        str2double(get(hObject,'String')) returns contents of edtDepthInc as a double
refreshImage(handles);

% --- Executes during object creation, after setting all properties.
function edtDepthInc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtDepthInc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.toggleDispScale,'Value')
   handles.offset = a; 
    
end



function edtTickGP_Callback(hObject, eventdata, handles)
% hObject    handle to edtTickGP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtTickGP as text
%        str2double(get(hObject,'String')) returns contents of edtTickGP as a double
refreshImage(handles);

% --- Executes during object creation, after setting all properties.
function edtTickGP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtTickGP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edtLength_Callback(hObject, eventdata, handles)
% hObject    handle to edtLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtLength as text
%        str2double(get(hObject,'String')) returns contents of edtLength as a double
refreshImage(handles);

% --- Executes during object creation, after setting all properties.
function edtLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cbP1.
function cbP1_Callback(hObject, eventdata, handles)
% hObject    handle to cbP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbP1


% --- Executes on button press in cbP2.
function cbP2_Callback(hObject, eventdata, handles)
% hObject    handle to cbP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbP2


% --- Executes on button press in cbOrigin.
function cbOrigin_Callback(hObject, eventdata, handles)
% hObject    handle to cbOrigin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbOrigin



function edtHeight_Callback(hObject, eventdata, handles)
% hObject    handle to edtHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtHeight as text
%        str2double(get(hObject,'String')) returns contents of edtHeight as a double
refreshImage(handles);

% --- Executes during object creation, after setting all properties.
function edtHeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
