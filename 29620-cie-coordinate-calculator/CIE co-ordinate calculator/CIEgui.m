function varargout = CIEgui(varargin)
% CIEGUI M-file for CIEgui.fig
%      CIEGUI, by itself, creates a new CIEGUI or raises the existing
%      singleton*.
%
%      H = CIEGUI returns the handle to a new CIEGUI or the handle to
%      the existing singleton*.
%
%      CIEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CIEGUI.M with the given input arguments.
%
%      CIEGUI('Property','Value',...) creates a new CIEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CIEgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CIEgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CIEgui

% Last Modified by GUIDE v2.5 06-Oct-2010 13:51:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CIEgui_OpeningFcn, ...
                   'gui_OutputFcn',  @CIEgui_OutputFcn, ...
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


% --- Executes just before CIEgui is made visible.
function CIEgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CIEgui (see VARARGIN)

% Choose default command line output for CIEgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CIEgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CIEgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in BrowseFile.
function BrowseFile_Callback(hObject, eventdata, handles)
[FileName,PathName] = uigetfile('*.txt','Select the txt file');

if PathName ~= 0    %if user not select cancel
 PathNameFileName = [PathName FileName];   
set(handles.filepath, 'string',PathNameFileName);
%PathName = get(handles.filepath, 'string');
addpath(PathName);  %add path to file search

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%reading the color matching functions  
 data = csvread('ciexyz31_1.csv');
 wavelength = data(:,1);
 redCMF = data(:,2);
 greenCMF = data(:,3);
 blueCMF = data(:,4);
%plot(wavelength,redCMF);
 
% readint the PL data 
fid = fopen(FileName, 'r');
%PLdata = fscanf(fid, '%g %g', [2 inf]);    % It has two rows now.
hl = str2num(get(handles.headerline,'string'));
PLdata = textscan(fid,'%f %f','HeaderLines',hl);
 
%PLdata = dlmread(FileName, '', 40, 1)    %matrix = dlmread(filename, delimiter, firstRow, firstColumn) 
fclose(fid)

% PLwavelength = PLdata(1,:);
% PLIntensity = PLdata(2,:);

PLwavelength = PLdata{1,1};
PLIntensity = PLdata{1,2};

plot(handles.PLdataaxis,PLwavelength,PLIntensity);

% CIE coordinates calculation 
%PLIntensity = PLIntensity/max(PLIntensity);     %normalize Intensity

s = size(PLwavelength);
dataindex = 0; %index for ciexydata
for i=1:1:471   % i is for color function read from excel file
    for j=1:1:s(1,1)
        if wavelength(i,1)== PLwavelength(j,1);
            dataindex = dataindex + 1;
            CIEXydata(dataindex,1) = redCMF(i,1)*PLIntensity(j,1);
            CIEYydata(dataindex,1) = greenCMF(i,1)*PLIntensity(j,1);
            CIEZydata(dataindex,1) = blueCMF(i,1)*PLIntensity(j,1);
            wave(dataindex,1) = PLwavelength(j,1);
        end
    end
end


set(handles.Calculatepushbutton,'Enable','on');    %enable the push button for calculate

handles.X = trapz(wave,CIEXydata);
handles.Y = trapz(wave,CIEYydata);
handles.Z = trapz(wave,CIEZydata);


guidata(hObject, handles);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 


% --- Executes during object creation, after setting all properties.
function PLdataaxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CIEdiagram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate CIEdiagram



function filepath_Callback(hObject, eventdata, handles)

% hObject    handle to filepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filepath as text
%        str2double(get(hObject,'String')) returns contents of filepath as a double


% --- Executes during object creation, after setting all properties.
function filepath_CreateFcn(hObject, eventdata, handles)
%handles.filepath = hObject;
%guidata(hObject, handles);
% hObject    handle to filepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


 


% --- Executes on button press in Calculatepushbutton.
function Calculatepushbutton_Callback(hObject, eventdata, handles)
handles.smallx = handles.X / (handles.X + handles.Y + handles.Z);
handles.smally = handles.Y / (handles.X + handles.Y + handles.Z);
set(handles.CIEX,'string',handles.X);
set(handles.CIEY,'string',handles.Y);
set(handles.CIEZ,'string',handles.Z);
set(handles.CIEsmallx,'string',handles.smallx);
set(handles.CIEsmally,'string',handles.smally);

%plotting the locatino in CIE diagram
xx = handles.smallx;    %modified x,y cordinate with respect to the top left axis origin
yy = (0.9-handles.smally);

imsize = imread('CIExy1931.bmp');
simsize = size(imsize);
xaxis = (simsize(1,2)/0.9)*xx+1;     %getting axis cordinates
yaxis = (simsize(1,1)/0.9)*yy+1;
yaxis = round(yaxis);
xaxis = round(xaxis);
%calibration - the image is little shifted so calibrated by calulating CIE
%for 0.33,0.33 and matching that to white poinit pixel in the image used
%(700,385)
xaxis = xaxis + 22;
yaxis = yaxis + 5;



axes(handles.CIEdiagram);


hold on;%# Add subsequent plots to the image
cla
imshow('CIExy1931.bmp');
plot(xaxis,yaxis,'o');  %# NOTE: x_p and y_p are switched (see note below
hold off;           %# Any subsequent plotting will overwrite the image
%declare handles to be used in save window
handles.savexaxis = xaxis;
handles.saveyaxis = yaxis;
guidata(hObject, handles);
 %[filename, user_canceled] = imsave;
% axes.save('test.jpg');


%getting the RGB value
ximaxis = simsize(1,1) + (-simsize(1,1)/0.9)*handles.smally;
yimaxis = (simsize(1,2)/0.9)*handles.smallx;
ximaxis = round(ximaxis);
yimaxis = round(yimaxis);
%calibration - the image is little shifted so calibrated by calulating CIE
%for 0.33,0.33 and matching that to white poinit pixel in the image used
%(700,385)
ximaxis = ximaxis + 5;
yimaxis = yimaxis + 22;
image = imread('CIExy1931.bmp');
imager = image(ximaxis,yimaxis,1);
imageg = image(ximaxis,yimaxis,2);
imageb = image(ximaxis,yimaxis,3);

colorwind = imread('colorwindow.png');  %setting rgb for color window
colorwind(:,:,1) = imager;
colorwind(:,:,2) = imageg;
colorwind(:,:,3) = imageb;

axes(handles.colorwindowaxes);
imshow(colorwind);
set(handles.Calculatepushbutton,'Enable','off');    %disable the push button for calculate
set(handles.savepushbutton,'Enable','on');


 

 
 

 
% --- Executes during object creation, after setting all properties.
function CIEdiagram_CreateFcn(hObject, eventdata, handles)
handles.CIEdiagram = hObject;
guidata(hObject, handles);
imshow('CIExy1931.bmp');
%imshow('findpointer1.png');
% hold on;            %# Add subsequent plots to the image
% plot(1,460,'o');  %# NOTE: x_p and y_p are switched (see note below)!
% hold off;           %# Any subsequent plotting will overwrite the image!
% hObject    handle to CIEdiagram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate CIEdiagram


 

 


% --- Executes during object creation, after setting all properties.
function colorwindowaxes_CreateFcn(hObject, eventdata, handles)
handles.colorwindowaxes = hObject;
guidata(hObject, handles);
imshow('colorwindow.png')
% hObject    handle to CIEdiagram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate CIEdiagram


% --- Executes during object creation, after setting all properties.
function Calculatepushbutton_CreateFcn(hObject, eventdata, handles)
handles.Calculatepushbutton = hObject;
% Update handles structure
guidata(hObject, handles);
set(hObject,'Enable','off');    %disable the push button for calculate
 


% --- Executes on button press in saveimage.
function saveimage_Callback(hObject, eventdata, handles)
 %[filename, ext, user_canceled] = imputfile
 axes(handles.CIEdiagram);
 save(test.jpg);
 %[filename, user_canceled] = imsave;
 if user_canceled == 0
     
 end
% hObject    handle to saveimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function headerline_Callback(hObject, eventdata, handles)
%handles.headerline = hObject;
%guidata(hObject, handles);
% hObject    handle to headerline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of headerline as text
%        str2double(get(hObject,'String')) returns contents of headerline as a double


% --- Executes during object creation, after setting all properties.
function headerline_CreateFcn(hObject, eventdata, handles)
handles.headerline = hObject;
guidata(hObject, handles);

% hObject    handle to headerline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in savepushbutton.
function savepushbutton_Callback(hObject, eventdata, handles)
figure('Name','Save Image','NumberTitle','off')
image = imread('CIExy1931.bmp');
imshow(image);
hold on
plot(handles.savexaxis,handles.saveyaxis,'o');  %# NOTE: x_p and y_p are switched (see note below
hold off;           %# Any subsequent plotting will overwrite the image
% hObject    handle to savepushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function savepushbutton_CreateFcn(hObject, eventdata, handles)
handles.savepushbutton = hObject;
guidata(hObject, handles);
set(handles.savepushbutton,'Enable','off');
% hObject    handle to savepushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
