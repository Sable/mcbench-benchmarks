%%%%% Author Muhammad Adil Farooqi %%%%
%%%%% E-mail: engr.adilfarooqi@gmail.com %%%%%
%%%%% OCR_ANN GUI %%%%%


%%
function varargout = OCR_ANN(varargin)
% OCR_ANN M-file for OCR_ANN.fig
%      
%
%      
% % Last Modified by GUIDE v2.5 28-May-2011 04:54:03

% Begin initialization code - 
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OCR_ANN_OpeningFcn, ...
                   'gui_OutputFcn',  @OCR_ANN_OutputFcn, ...
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
% End initialization code - 

%%
% --- Executes just before OCR_ANN is made visible.
%%
function OCR_ANN_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OCR_ANN (see VARARGIN)

% Choose default command line output for OCR_ANN
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes OCR_ANN wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%%
% --- Outputs from this function are returned to the command line.
function varargout = OCR_ANN_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%
% --- Executes on button press in plot1_pushbutton.
function plot1_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to plot1_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%%%% step# 01 Image Acquisition %%%%%%

clc;  
[filename, pathname] = uigetfile({'*.jpg';'*.bmp';'*.gif';'*.*'}, 'Pick an Image File');
TestIm = imread([pathname,filename]);

axes(handles.axes1);
imshow(TestIm);

save('TestIm','TestIm');
clear all;


%%
% --- Executes on button press in Axes2_pushbutton.
function Axes2_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Axes2_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%%% step# 02 Preprocessing %%%%
load TestIm

%Convert to gray scale
if size(TestIm,3)==3 %RGB image
    TestIm = rgb2gray(TestIm);
end
%Convert to binary image
threshold = graythresh(TestIm);
TestIm =~im2bw(TestIm,threshold);


%Remove Salt and paper noise
TestIm = medfilt2(TestIm);

axes(handles.axes2);
imshow(TestIm)

save('TestIm','TestIm');
clc; clear all;

%%
% --- Executes on button press in axes3_pushbutton.
function axes3_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to axes3_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%%%% step# 03 Segmentation %%%%%
load TestIm

%Label and Count Connected components
[L Ne] = bwlabel(TestIm);
glyphs = []  %%%Initilize glyphs matrix

   for n=1:Ne
    [r c] =find(L==n);
    
    glyph = TestIm(min(r):max(r),min(c):max(c));
   
    glyph = imresize(glyph,[35 35]); 
   
    % Again convert to binaray image
    glyph = double(glyph);
    thresh = graythresh(glyph);
    glyph = im2bw(glyph,thresh); 
    
    glyphs = [glyphs glyph]
  
    
    axes(handles.axes3);
    imshow(glyph)
    
   end
   [m n] = size(glyphs)
   set(handles.text6,'string',n/35)
   save('glyphs','glyphs');
   clear all;
%%
% --- Executes on button press in axes4_pushbutton.
function axes4_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to axes4_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%%%% step# 04 Classification %%%%

load glyphs;
load net;
[r c] = size(glyphs);

    glyphsclass = [];performance = [];%%initilize matrix
    for n = 0:35:(c-35)
        glyph = glyphs(1:35,1+n:(n+35));
        glyph = mat2vect(glyph);
        [glyphclass,PF,AF,E,Perf] = sim(net,glyph);
        
        performance = [performance Perf]
        axes(handles.axes4)
       plot(performance,'-.b*','LineWidth',2,'MarkerSize',10)
        glyphsclass = [glyphsclass glyphclass]
        
    end

save('glyphsclass','glyphsclass');
clear all;

%%
% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%%% step# 04 Output %%%%%

load glyphsclass

[r c] = size(glyphsclass);
alphabets = [];space = ' ';haroof = [] %%%initilize matrix

for n=1:c
    
    glyphclass = glyphsclass(1:r,n) %%% individiual alphabet
    
    [i j] = max(glyphclass); %%% alphabet???


if j==5 | j==6 | j== 7 | j== 8 | j==9 | j==10 | j==11 | j==12 | j==13 | j==14 | j==15 | j==16 |...
        j==17 | j==18 | j==19 |j==20 | j==21 | j==22 | j==23 | j==24 | j==25 
    
    
    
if j==5
    alphabet = '0627'
    harf='alif      '
end
if j==6
    alphabet = '0628'
    harf = 'bay       ';
end

if j==7
    alphabet = '062D'
    harf = 'bari he   ';
end 

if j==8
    alphabet = '062F'
    harf = 'dal       ';
end 

if j==9
    alphabet = '0631'
    harf = 're        ';
end 

if j==10
    alphabet = '0633'
    harf = 'sin       ';
end 

if j==11
    alphabet = '0635'
    harf = 'suad      ';
end

if j==12
    alphabet = '0637';
    harf = 'toe       ';
end

if j==13
    alphabet = '0639';
    harf = 'ain       ';
end  

if j==14
    alphabet = '0641';
    harf = 'fe        ';
end
if j==15
    alphabet = '0642';
    harf = 'qaf       ';
end
if j==16
    alphabet = '06A9';
    harf = 'kaf       ';
end

if j==17
    alphabet = '0644';
    harf = 'lam       ';
end 
if j==18
    alphabet ='0645';
    harf = 'mim       ';
end
if j==19
    alphabet = '0646';
    harf = 'nun       ';
end

if j==20
    alphabet = '0648';
    harf = 'vao       ';
end
if j==21
    alphabet = '06C1';
    harf = 'choti he  ';
end
if j==22
    alphabet = '06BE';
    harf = 'DoCashmiHe';
end
if j==23
    alphabet = '0621';
    harf = 'hamzah    ';
end
if j==24
    alphabet = '06CC';
    harf = 'choti ye  ';
end
if j==25
    alphabet = '06D2';
    harf = 'bari ye   ';
end




alphabets = [alphabets space alphabet]
haroof = [haroof space harf]
end


%%%If glyph is Diacritics then...
[x y] = size(alphabets);
[m n] = size(haroof);
 
    if j==1 & alphabet=='0628' %%%%bay
        alphabets(1,(y-3):y) ='0628'%%%each alphabet is of length 4
        haroof(1,(n-9):n) = 'bay       '%%%each harf is of length 10
    end
    if j==2 & alphabet=='0628'
        alphabets(1,(y-3):y) = '062A'%%te
        haroof(1,(n-9):n) = 'te        '
    end
    if j==1 & alphabet== '062A'%%te
        alphabets(1,(y-3):y) = '062B'%%se
        haroof(1,(n-9):n) = 'se        '
    end
    if j==3 & alphabet =='0628'%%bay
        alphabets(1,(y-3):y) = '0679'%%te
        haroof(1,(n-9):n) = 'te        '
        
    end
    if j==1 & alphabet == '062D' %%%%bar? he
        alphabets(1,(y-3):y) = '062C'%%j?m
        haroof(1,(n-9):n) = 'jim       '
    end
    if j==2 & alphabet =='062D'
        alphabets(1,(y-3):y) = '0686'%%chay
        haroof(1,(n-9):n) = 'chay      '
    end
    if j==1 & alphabet =='062F'  %%%d?l 
        alphabets(1,(y-3):y) = '0630'%%z?l
        haroof(1,(n-9):n) = 'zal       '
     end
    if j==3 & alphabet=='062F'
        alphabets(1,(y-3):y) = '0688'%%dd?l
        haroof(1,(n-9):n) = 'ddal      '
     end
    if j == 1 & alphabet =='0631' %%%raa
        alphabets(1,(y-3):y) = '0632'%%ze 
        haroof(1,(n-9):n) = 'ze        '
     end
    if j==2 & alphabet =='0631' 
        alphabets(1,(y-3):y) = '0698'%%zhe
        haroof(1,(n-9):n) = 'zhe       '
    end
    if j== 3 & alphabet =='0631'
        alphabets(1,(y-3):y) ='0691'%%%rre
        haroof(1,(n-9):n) = 'rre       '
     end
    if j==1 & alphabet == '0635'%%%soad
        alphabets(1,(y-3):y) = '0636'%%%zu'?d
        haroof(1,(n-9):n) = 'zuad      '
     end
    if j==2 & alphabet== '0633'%%%seen
        alphabets(1,(y-3):y) = '0634'%%%sh?n
        haroof(1,(n-9):n) = 'shin      '
     end
    if j==1 & alphabet== '0637'%%%toa
        alphabets(1,(y-3):y)='0638'%%%zo'e
        haroof(1,(n-9):n) = 'zoe       '
    
    end
     if j ==1 & alphabet== '0639'%%%aaen
        alphabets(1,(y-3):y) = '063A'%%ghain
        haroof(1,(n-9):n) = 'ghain     '
     end
     if j ==4 & alphabet== '06A9'%%%kaaf
        alphabets(1,(y-3):y) = '06AF'%%g?f
        haroof(1,(n-9):n) = 'gaf       '
     end
     


 
end
[m n] = size(alphabets)
set(handles.text5,'string',n/5)
set(handles.text4,'string',haroof)



save('alphabets','alphabets')


%%
%--- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%%%% step# 05 Export Alphabets %%%
load alphabets

fid = fopen('text.RTF','w');

fprintf(fid,alphabets);
fclose(fid)


    winopen('text.RTF')
    
function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

%%
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

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double

%%
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

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double

%%
% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

%%
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


