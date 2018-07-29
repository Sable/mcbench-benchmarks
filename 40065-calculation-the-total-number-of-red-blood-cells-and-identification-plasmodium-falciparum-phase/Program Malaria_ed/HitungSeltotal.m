function varargout = hitungseltotal(varargin)
% HITUNGSELTOTAL M-file for hitungseltotal.fig
%      HITUNGSELTOTAL, by itself, creates a new HITUNGSELTOTAL or raises the existing
%      singleton*.
%
%      H = HITUNGSELTOTAL returns the handle to a new HITUNGSELTOTAL or the handle to
%      the existing singleton*.
%
%      HITUNGSELTOTAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HITUNGSELTOTAL.M with the given input arguments.
%
%      HITUNGSELTOTAL('Property','Value',...) creates a new HITUNGSELTOTAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hitungseltotal_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hitungseltotal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help hitungseltotal

% Last Modified by GUIDE v2.5 25-Jul-2012 14:54:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',  mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @hitungseltotal_OpeningFcn, ...
    'gui_OutputFcn',  @hitungseltotal_OutputFcn, ...
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


% --- Executes just before hitungseltotal is made visible.
function hitungseltotal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hitungseltotal (see VARARGIN)

% Choose default command line output for hitungseltotal
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
setappdata(0,'datacontainer',hObject);

% UIWAIT makes hitungseltotal wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = hitungseltotal_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in BUKA_CITRA_BT.
function BUKA_CITRA_BT_Callback(hObject, eventdata, handles)
% hObject    handle to BUKA_CITRA_BT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[nama_file1,nama_path1]=uigetfile( ...
    {'*.bmp;*.jpg','File Citra (*.bmp,*.jpg)';
    '*.bmp','File Bitmap (*.bmp)';...
    '*.jpg','File jpeg (*.jpg)';
    '*.*','Semua File (*.*)'},...
    'Buka File Citra Asli');

if ~isequal(nama_file1,0)
    handles.data1 = imread(fullfile(nama_path1,nama_file1));
    guidata(hObject,handles);
    axes(handles.axes1);
    imshow(handles.data1),title('Citra Asli','Color','r',...
        'FontName','Maiandra GD','FontSize',14,'FontWeight','bold');
    mydatacontainer=getappdata(0,'datacontainer');
    setappdata(mydatacontainer,'gambaroriginal',handles.data1);
else
    return;
end

set (handles.NAMA_CITRA_ST,'String',nama_file1);
set (handles.LEBAR_CITRA_ST,'String',size(handles.data1,1));
set (handles.PANJANG_CITRA_ST,'String',size(handles.data1,2));
diary Stepbystep_data.txt;
Nama_Citra = nama_file1

% --- Executes on button press in NORMALISASI_BT.
function NORMALISASI_BT_Callback(hObject, eventdata, handles)
% hObject    handle to NORMALISASI_BT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mydatacontainer = getappdata(0,'datacontainer');
gambarasli = getappdata(mydatacontainer,'gambaroriginal');
J = rgb2gray(gambarasli);
M = medfilt2(J);
setappdata(mydatacontainer,'M',M);
axes(handles.axes2);
imshow(M),title('Citra Normalisasi','Color','r',...
    'FontName','Maiandra GD','FontSize',14,'FontWeight','bold');

% --- Executes on button press in BINERISASI1_BT.
function BINERISASI1_BT_Callback(hObject, eventdata, handles)
% hObject    handle to BINERISASI1_BT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datacontainer = getappdata(0,'datacontainer');
M = getappdata(datacontainer,'M');
K = imadjust(M,stretchlim(M),[1 0]);
q = 1.28*graythresh(K);
r = im2bw(K,q);
axes(handles.axes3);
imshow(r),title('Citra Biner','Color','r',...
    'FontName','Maiandra GD','FontSize',14,'FontWeight','bold');
setappdata(datacontainer,'r',r);

% --- Executes on button press in PEMISAHAN_SEL_BT.
function PEMISAHAN_SEL_BT_Callback(hObject, eventdata, handles)
% hObject    handle to PEMISAHAN_SEL_BT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datacontainer = getappdata(0,'datacontainer');
r = getappdata(datacontainer,'r');
fill = imfill(r,'holes');
se = strel('disk',5);
erodedBW = imerode(fill,se);
bw = imdilate(erodedBW,se);
setappdata(datacontainer,'bw',bw);

% MENAMPILKAN CITRA SEL TOTAL
axes(handles.axes4);
imshow(bw),title('Citra Sel Total','Color','r',...
    'FontName','Maiandra GD','FontSize',14,'FontWeight','bold');
hold on

% MENGHITUNG RATA-RATA LUAS SEL
clear = imclearborder(bw,4);
[B,L] = bwboundaries(clear,'noholes');
hold on

stats = regionprops(L,'Area');

for k = length(B)
    area = [stats.Area];
    rata2 = sum(area)/numel(area);
    setappdata(datacontainer,'rata2',rata2);
end

% --- Executes on button press in HITUNG_SEL_TOTAL_BT.
function HITUNG_SEL_TOTAL_BT_Callback(hObject, eventdata, handles)
% hObject    handle to HITUNG_SEL_TOTAL_BT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datacontainer = getappdata(0,'datacontainer');
bw = getappdata(datacontainer,'bw');
L = bwlabel(bw);
Jumlah_Sel_Total = max(max(L))
nilai = num2str(Jumlah_Sel_Total);
set(handles.JUMLAH_SEL_TOTAL_ED,'String',nilai);

% --- Executes on button press in BINERISASI2_BT.
function BINERISASI2_BT_Callback(hObject, eventdata, handles)
% hObject    handle to BINERISASI2_BT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datacontainer = getappdata(0,'datacontainer');
M = getappdata(datacontainer,'M');
q = 255*graythresh(M);
num_citra = double(handles.data1);
[m n] = size(handles.data1);
for i = 1:m
    for j = 1:n
        num_citra(i,j) = num_citra(i,j)+q;
        if num_citra(i,j) > 255
            num_citra(i,j) = 0;
        end;
        if num_citra(i,j) < 0
            num_citra(i,j) = 255;
        end;
    end;
end;
P = uint8(num_citra);
gambar = im2bw(P);
setappdata(datacontainer,'gambar',gambar);
axes(handles.axes3);
imshow(gambar),title('Citra Biner','Color','r',...
    'FontName','Maiandra GD','FontSize',14,'FontWeight','bold');

% --- Executes on button press in IDENTIFIKASI_BT.
function IDENTIFIKASI_BT_Callback(hObject, eventdata, handles)
% hObject    handle to IDENTIFIKASI_BT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datacontainer = getappdata(0,'datacontainer');
gambar = getappdata(datacontainer,'gambar');
Q = imclearborder(gambar);
se = strel('disk',15);
fc = imclose(Q,se);
I6 = bwareaopen(fc,7);
L = bwlabel(I6);
Jumlah_Parasit = max(max(L))
[B,L] = bwboundaries(I6,'noholes');
axes(handles.axes4);
imshow(L),title('Citra Parasit','Color','r',...
    'FontName','Maiandra GD','FontSize',14,'FontWeight','bold');
hold on
setappdata(datacontainer,'Jumlah_Parasit',Jumlah_Parasit);

% MENGHITUNG PERBANDINGAN LUAS PARASIT DENGAN LUAS RATA-RATA SEL
rata2 = getappdata(datacontainer,'rata2');
for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end

stats = regionprops(L,'Area','centroid','Perimeter');

threshold = 0.94;

% loop over the boundaries
for k = 1:length(B)

    % obtain (X,Y) boundary coordinates corresponding to label 'k'
    boundary = B{k};

    % compute a simple estimate of the object's perimeter
    perimeter = stats(k).Perimeter;

    % obtain the area calculation corresponding to label 'k'
    area = stats(k).Area;
    perbandingan = area/rata2;

    % compute the roundness metric
    metric = 4*pi*area/perimeter^2;

    % mark objects above the threshold with a black circle
    if metric > threshold;
        centroid = stats(k).Centroid;
        plot(centroid(1),centroid(2),'ko');
    end

    % MENGIDENTIFIKASI JENIS FASE PLASMODIUM FALCIPARUM
    if perbandingan <= 0.08;
        text(boundary(2,2),boundary(1,1)+40,'trophozoite','Color','g',...
            'FontName','Maiandra GD','FontSize',12,'FontWeight','bold');
        Fase = 'trophozoite'

    elseif metric > 0.826;
        text(boundary(2,2),boundary(1,1)+40,'schizont','Color','y',...
            'FontName','Maiandra GD','FontSize',12,'FontWeight','bold');
        Fase = 'schizont'

    else
        text(boundary(2,2),boundary(1,1)+40,'gametocyte','Color','r',...
            'FontName','Maiandra GD','FontSize',12,'FontWeight','bold');
        Fase ='gametocyte'
    end
end

% --- Executes on button press in RESET_BT.
function RESET_BT_Callback(hObject, eventdata, handles)
% hObject    handle to RESET_BT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(HitungSeltotal);
guidata(HitungSeltotal);

% --- Executes on button press in HITUNG_PARASIT_BT.
function HITUNG_PARASIT_BT_Callback(hObject, eventdata, handles)
% hObject    handle to HITUNG_PARASIT_BT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datacontainer = getappdata(0,'datacontainer');
Jumlah_Parasit = getappdata(datacontainer,'Jumlah_Parasit');
nilai = num2str(Jumlah_Parasit);
set(handles.JUMLAH_PARASIT_ED,'String',nilai);
diary off;

% --- Executes during object creation, after setting all properties.
function JUMLAH_PARASIT_ED_CreateFcn(hObject, eventdata, handles)
% hObject    handle to JUMLAH_PARASIT_ED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in KEMBALI_BT.
function KEMBALI_BT_Callback(hObject, eventdata, handles)
% hObject    handle to KEMBALI_BT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(ProgramPerhitunganSel);
close (HitungSeltotal);

% --- Executes on button press in PANDUAN_BT.
function PANDUAN_BT_Callback(hObject, eventdata, handles)
% hObject    handle to PANDUAN_BT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(infostep);

function JUMLAH_PARASIT_ED_Callback(hObject, eventdata, handles)
% hObject    handle to JUMLAH_PARASIT_ED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of JUMLAH_PARASIT_ED as text
%        str2double(get(hObject,'String')) returns contents of JUMLAH_PARASIT_ED as a double

function JUMLAH_SEL_TOTAL_ED_Callback(hObject, eventdata, handles)
% hObject    handle to JUMLAH_SEL_TOTAL_ED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of JUMLAH_SEL_TOTAL_ED as text
%        str2double(get(hObject,'String')) returns contents of JUMLAH_SEL_TOTAL_ED as a double

% --- Executes during object creation, after setting all properties.
function axes5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes5
axes (hObject);
imshow('Step by step.jpg');

% --- Executes during object creation, after setting all properties.
function JUMLAH_SEL_TOTAL_ED_CreateFcn(hObject, eventdata, handles)
% hObject    handle to JUMLAH_SEL_TOTAL_ED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end