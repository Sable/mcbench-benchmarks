function varargout = image_features(varargin)
% GUI for calculating 1st and 2nd order staistics of images.
% 
% Calculates Average, RMS, Skewness and Kurtosis - 1st order statistics.
% Has an option of filtering low-frequency and high-frequency components of
% images and calculating 1st order statistic for for each of the separated images
% (waviness and roughness components).
%
% Calculates 4 GLCM texture parameters from images (contrast,correlation, energy
% and homogeneity) (requires Image Processing toolbox)
%
% Has an option to apply PCA model to 1sr order statistis, 2nd order statistics and combined parameters (requires PLS
% Toolbox).
%
% Basic image processing:
%	- cropping, resizing
%	- histogram equalization
% Filtering:
%	- averaging
%	- contrast enhancement
%
%  Works with most types of Image formats:
% 	JPEG, TIFF, BMP and more (see imread for format types)
%  	RGB images are converted to grayscale 
%  Opens MAT files containing variable IMAGES
%  	
%
%  To run, type:
%  image_features
%
%  created by K.Artyushkova
%  April 2010

% Kateryna Artyushkova
% Research Associate Professor
% Department of Chemical and Nuclear Engineering
% The University of New Mexico
% (505) 277-0750
% kartyush@unm.edu 


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @image_features_OpeningFcn, ...
                   'gui_OutputFcn',  @image_features_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before image_features is made visible.
function image_features_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to image_features (see VARARGIN)

% Choose default command line output for image_features
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes image_features wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = image_features_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function open_image_Callback(hObject, eventdata, handles)
% hObject    handle to open_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname]=uigetfile('*.*','MultiSelect','on','Open images');
cd(pathname)
[N,M]=size(filename);
    image=imread(char(filename{1}));
    [n,m,p]=size(image);
     if p==3
         image=rgb2gray(image);
         data(:,:,1)=double(image);
         data(:,:,M)=double(image);
     else
         data(:,:,1)=double(image);
         data(:,:,M)=double(image);
     end
 for i=2:M
        image=imread(char(filename{i}));
       [n,m,p]=size(image);
     if p==3
         image=rgb2gray(image);
         data(:,:,i-1)=double(image);
     else
         data(:,:,i-1)=double(image);
     end
 end

handles.or_image=data;
handles.image=uint8(data);
handles.waviness=data;
handles.roughness=data;
handles.texture=[];
handles.first_param=[];
handles.combined=[];
handles.pca=[];
handles.model1st=[];
handles.model2nd=[];
handles.comb=[];
handles.N=1;
[n,m,p]=size(data);
set(handles.Min,'string',1);
set(handles.Max,'string',p);
set(handles.current,'string',1);
axes(handles.axes1)
iptsetpref('ImshowAxesVisible', 'on')
imagesc(data(:,:,1)), colormap(gray)
set(handles.current,'string',1);
guidata(hObject,handles)


% --------------------------------------------------------------------
function open_mat_Callback(hObject, eventdata, handles)
% hObject    handle to open_mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname]=uigetfile('*.mat','Open mat files. Images should be saved in variable IMAGES');
cd(pathname)
D=load (filename, 'images');
data=D.images;
data=double(data);
handles.image=data;
handles.waviness=data;
handles.roughness=data;
handles.or_image=data;
handles.texture=[];
handles.first_param=[];
handles.combined=[];
handles.pca=[];
handles.model1st=[];
handles.model2nd=[];
handles.comb=[];
handles.N=1;
axes(handles.axes1)
iptsetpref('ImshowAxesVisible', 'on')
imagesc(data(:,:,1)), colormap(gray)
[n,m,p]=size(data);
set(handles.Min,'string',1);
set(handles.Max,'string',p);
set(handles.current,'string',1);
guidata(hObject,handles)


    
% --------------------------------------------------------------------
function save_spectra_Callback(hObject, eventdata, handles)
% hObject    handle to save_images (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datapath = uigetdir;
cd(datapath)
images=handles.image;

[filename, pathname] = uiputfile('*.mat', 'Save images as');
save(filename, 'images')


% --- Executes during object creation, after setting all properties.
function image_selection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to image_selection (see GCBO)
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
function image_selection_Callback(hObject, eventdata, handles)
% hObject    handle to image_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


images=handles.image;
roughness=handles.roughness;
waviness=handles.waviness;
[n,m,p]=size(images);

set(handles.Min,'string',1);
set(handles.Max,'string',p);

step=1/p;
slider_step(1)=step;
slider_step(2)=step;
if step==1;
    set(handles.image_selection, 'SliderStep', slider_step, 'Max', 2, 'Min',0,'Value',1)
    i=1;
else
    set(handles.image_selection, 'SliderStep', slider_step, 'Max', p, 'Min',0)
    i=get(hObject,'Value');
    i=round(i);
    if i==0
        i=1;
    elseif i>=p
        i=p;
    else i=i;
    end
end
set(handles.current,'string',i);

axes(handles.axes1)
iptsetpref('ImshowAxesVisible', 'on')
if p==1;
   imagesc(images), colormap(gray)

else
   imagesc(images(:,:,i)), colormap(gray)
    if waviness==roughness;
    else
      axes(handles.axes4)  
       imagesc(waviness(:,:,i)), colormap(gray)
       set(handles.current2,'string',i);
       axes(handles.axes2)  
       imagesc(roughness(:,:,i)), colormap(gray)
       set(handles.current1,'string',i);
    end
end
    
handles.N=i;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function pca_Ncomp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pca_Ncomp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function pca_Ncomp_Callback(hObject, eventdata, handles)
% hObject    handle to pca_Ncomp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pca_Ncomp as text
%        str2double(get(hObject,'String')) returns contents of pca_Ncomp as a double

Npca=str2double(get(hObject,'String')) ;
handles.Npca=Npca;
guidata(hObject,handles)


% --- Executes on button press in pca_main.
function pca_main_Callback(hObject, eventdata, handles)
% hObject    handle to pca_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Npca=handles.Npca;
type=questdlg('Which dataset to apply PCA to?','PCA dataset selection','1st order statistics', '2nd order statistics', 'Combined            ', '1st order statistics');
if type=='1st order statistics'
    data=handles.first_param;
elseif type=='2nd order statistics'
    data=handles.texture;
else
    data1=handles.first_param;
    data2=handles.texture;
    data=[data1 data2];
    handles.combined=data;
end
h = waitbar(0,'Please wait while PCA is performed...');
options = pca('options');
options.display='off';
options.preprocessing='autoscale';
model=pca(data,2,options);
scores=model.loads{1};
loads=model.loads{2};
handles.scores=scores;
handles.loads=loads;
handles.modelpca=model;
if type=='1st order statistics'
    handles.model1st=model;
elseif type=='2nd order statistics'
    handles.model2nd=model;
else
    handles.comb=model;
end
close(h)
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function pca_disp_N_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pca_disp_N (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function pca_disp_N_Callback(hObject, eventdata, handles)
% hObject    handle to pca_disp_N (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pca_disp_N as text
%        str2double(get(hObject,'String')) returns contents of pca_disp_N as a double


Icomp=str2double(get(hObject,'String')) ;
handles.Icomp=Icomp;
guidata(hObject,handles)



% --- Executes on button press in pca_display.
function pca_display_Callback(hObject, eventdata, handles)
% hObject    handle to pca_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
scores=handles.scores;
loads=handles.loads;
Icomp=handles.Icomp;

H.Position=[633 109 274 414];
figure(H)
subplot(2,1,1)
plot(scores(:,Icomp),'-*')
plot([0 1],[0 0],'--r')
title('Score plot')
xlabel('Sample/image #')
subplot(2,1,2)
plot(loads(:,Icomp),'-*')
plot([0 1],[0 0],'--r')
title('Loading plot')
xlabel('roughness parameters')




% --------------------------------------------------------------------
function save_pca_Callback(hObject, eventdata, handles)
% hObject    handle to save_pca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
modelpca=handles.modelpca;
datapath = uigetdir;
cd(datapath)
[filename, pathname] = uiputfile('*.mat', 'save pca model into mat file');
save(filename, 'modelpca')



% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function normalize_Callback(hObject, eventdata, handles)
% hObject    handle to normalize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=handles.image;
N=handles.N;
[n,p,q]=size(data);
figure(1)
[a,rect]=imcrop(uint8(data(:,:,N)));
for i=1:q;
   image_crop(:,:,i)=imcrop(data(:,:,i),rect);
end
close(1)
axes(handles.axes1)
iptsetpref('ImshowAxesVisible', 'on')
imagesc(image_crop(:,:,N)), colormap(gray)
handles.image=image_crop;
guidata(hObject,handles)

% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function smooth_Callback(hObject, eventdata, handles)
% hObject    handle to smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=handles.image;
[n,p,q]=size(data);
type=questdlg('How do you want resize the image?','Image resize','Increase', 'Shrink  ', 'Increase');
if type=='Increase'
    N=inputdlg('Enter N times to increase the image');  
    N=str2double(N);
    data_res(:,:,1) = imresize(data(:,:,1),N,'bicubic');
    data_res(:,:,q) = imresize(data(:,:,q),N,'bicubic');
    for i=1:q;
        data_res(:,:,i) = imresize(data(:,:,i),N,'bicubic');
    end
else
    N=inputdlg('Enter N times to shrink the image');  
    N=str2double(N);
    data_res(:,:,1) = imresize(data(:,:,1),1/N,'bicubic');
    data_res(:,:,q) = imresize(data(:,:,q),1/N,'bicubic');
    for i=1:q;
        data_res(:,:,i) = imresize(data(:,:,i),1/N,'bicubic');
    end
end
axes(handles.axes1)
iptsetpref('ImshowAxesVisible', 'on')
imagesc(data_res(:,:,1)), colormap(gray)
handles.image=data_res;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --------------------------------------------------------------------

% --- Executes when figure1 window is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------

% --------------------------------------------------------------------
function histogram_Callback(hObject, eventdata, handles)
% hObject    handle to histogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data=handles.image;
data_eq=histogram(data,'1');
handles.image=data_eq;
guidata(hObject,handles);

% --------------------------------------------------------------------

% --------------------------------------------------------------------
function Undo_Callback(hObject, eventdata, handles)
% hObject    handle to Undo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=handles.or_image;
axes(handles.axes1)
iptsetpref('ImshowAxesVisible', 'on')
N=handles.N;
imagesc(data(:,:,N)),colormap(gray)
handles.image=data;
guidata(hObject,handles)


% --------------------------------------------------------------------
function enhance_Callback(hObject, eventdata, handles)
% hObject    handle to enhance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function filter_ave_Callback(hObject, eventdata, handles)
% hObject    handle to filter_ave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=handles.image;
[m,n,p]=size(data);
Hsize=inputdlg('Enter the kernel size');  
Hsize=str2double(Hsize);
H = fspecial('average',Hsize);
for i=1:p
    data_filt(:,:,i) = imfilter(data(:,:,i),H);
end
N=handles.N;
imagesc(data_filt(:,:,N)),colormap(gray)
handles.image=data_filt;
guidata(hObject,handles)


% --------------------------------------------------------------------
function fil_gaussian_Callback(hObject, eventdata, handles)
% hObject    handle to fil_gaussian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data=handles.image;
[m,n,p]=size(data);
Hsize=inputdlg('Enter the kernel size');  
Hsize=str2double(Hsize);
H = fspecial('gaussian',Hsize,Hsize/6);
for i=1:p
    data_filt(:,:,i) = imfilter(data(:,:,i),H);
end
N=handles.N;
imagesc(data_filt(:,:,N)),colormap(gray)
handles.image=data_filt;
guidata(hObject,handles)

% --------------------------------------------------------------------
function unsharp_Callback(hObject, eventdata, handles)
% hObject    handle to unsharp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=handles.image;
[m,n,p]=size(data);
alpha=inputdlg('Enter the alpha parameter of Laplacian filter (from 0.1-1) (default=0.2)');  
alpha=str2double(alpha);
H = fspecial('unsharp',alpha);
for i=1:p
    data_filt(:,:,i) = imfilter(data(:,:,i),H);
end
N=handles.N;
imagesc(data_filt(:,:,N)),colormap(gray)
handles.image=data_filt;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.



% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles 


% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
roughness=handles.roughness;
images=handles.image;
waviness=handles.waviness;
[n,m,p]=size(roughness);

set(handles.Min1,'string',1);
set(handles.Max1,'string',p);

step=1/p;
slider_step(1)=step;
slider_step(2)=step;
if step==1;
    set(handles.slider2, 'SliderStep', slider_step, 'Max', 2, 'Min',0,'Value',1)
    i=1;
else
    set(handles.slider2, 'SliderStep', slider_step, 'Max', p, 'Min',0)
    i=get(hObject,'Value');
    i=round(i);
    if i==0
        i=1;
    elseif i>=p
        i=p;
    else i=i;
    end
end
set(handles.current1,'string',i);
set(handles.current2,'string',i);
set(handles.current,'string',i);

axes(handles.axes2)
iptsetpref('ImshowAxesVisible', 'on')
if p==1;
   imagesc(roughness), colormap(gray)

else
   imagesc(roughness(:,:,i)), colormap(gray)
   axes(handles.axes1)
   imagesc(images(:,:,i)), colormap(gray)
   axes(handles.axes4)
   imagesc(waviness(:,:,i)), colormap(gray)

end
handles.N=i;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2



% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
waviness=handles.waviness;
roughness=handles.roughness;
images=handles.image;
[n,m,p]=size(waviness);

set(handles.Min2,'string',1);
set(handles.Max2,'string',p);

step=1/p;
slider_step(1)=step;
slider_step(2)=step;
if step==1;
    set(handles.slider4, 'SliderStep', slider_step, 'Max', 2, 'Min',0,'Value',1)
    i=1;
else
    set(handles.slider4, 'SliderStep', slider_step, 'Max', p, 'Min',0)
    i=get(hObject,'Value');
    i=round(i);
    if i==0
        i=1;
    elseif i>=p
        i=p;
    else i=i;
    end
end
set(handles.current2,'string',i);
set(handles.current1,'string',i);
set(handles.current,'string',i);
axes(handles.axes4)
iptsetpref('ImshowAxesVisible', 'on')
if p==1;
   imagesc(waviness), colormap(gray)

else
   imagesc(waviness(:,:,i)), colormap(gray)
   axes(handles.axes2)
   imagesc(roughness(:,:,i)), colormap(gray)
   axes(handles.axes1)
   imagesc(images(:,:,i)), colormap(gray)
end
handles.N=i;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




% --- Executes during object creation, after setting all properties.
function Max1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called





% --------------------------------------------------------------------
function save_roughness_Callback(hObject, eventdata, handles)
% hObject    handle to save_roughness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
first_param=handles.first_param;
data=first_param.data;
datapath = uigetdir;
cd(datapath)
[filename, pathname] = uiputfile('*.mat', 'save 1st order statistics into mat file');
save(filename, 'data')



% --------------------------------------------------------------------
function crop_Callback(hObject, eventdata, handles)
% hObject    handle to crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

images=handles.image;
N=handles.N;
[n,p,q]=size(images);
figure(2)
[a,rect]=imcrop(uint8(images(:,:,N)));
close(2)
for i=1:q;
   image_crop(:,:,i)=imcrop(images(:,:,i),rect);
end

axes(handles.axes1)
iptsetpref('ImshowAxesVisible', 'on')
imagesc(image_crop(:,:,N)), colormap(gray)
handles.image=image_crop;
guidata(hObject,handles)


% --------------------------------------------------------------------
function uipushtool5_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

images=handles.image;
[a,b,c]=size(images);
images=double(images);
method=questdlg('Do you want to separate Low and High frequency components', '1st order statistics', 'Yes','No ','Yes');
if method=='Yes'
prompt={'Enter the size of the Gaussian filter:','Enter the Standard deviation for filter:'};
   name='Input for Filtering';
   numlines=1;
   defaultanswer={'100','20'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    answer=str2double(answer);
    for i=1:c
        PSF = fspecial('gaussian',answer(1),answer(2));
        waviness(:,:,i) = imfilter(images(:,:,i),PSF,'conv');
        roughness(:,:,i)=images(:,:,i)-waviness(:,:,i);
        handles.waviness=waviness;
        handles.roughness=roughness;
    end
    set(handles.Min1,'string',1);
    set(handles.Max1,'string',c);
    axes(handles.axes2)
    iptsetpref('ImshowAxesVisible', 'on')
    imagesc(roughness(:,:,1)), colormap(gray)
    set(handles.current1,'string',1);       
    set(handles.Min2,'string',1);
    set(handles.Max2,'string',c);
    axes(handles.axes4)
    iptsetpref('ImshowAxesVisible', 'on')
    imagesc(waviness(:,:,1)), colormap(gray)
    set(handles.current2,'string',1);       
    n=a*b;
    for i=1:c
        vectorR(:,i)=reshape(roughness(:,:,i), [1,n]);
        vectorW(:,i)=reshape(waviness(:,:,i), [1,n]);
        MR(i)=sum(sum(abs(roughness(:,:,i))))/n; %aveMge 
        RMSR(i)=sqrt(mean(vectorR(:,i).^2)); %RMS 
        SkR(i)=sum(sum(roughness(:,:,i).^3))/(n*RMSR(i)^3); %skewness
        KuR(i)=sum(sum(roughness(:,:,i).^4))/(n*RMSR(i)^4); % kurtosis
        MW(i)=sum(sum(abs(waviness(:,:,i))))/n; %aveMge roughness
        RMSW(i)=sqrt(mean(vectorW(:,i).^2)); %RMS roughness
        SkW(i)=sum(sum(waviness(:,:,i).^3))/(n*RMSW(i)^3); %skewness
        KuW(i)=sum(sum(waviness(:,:,i).^4))/(n*RMSW(i)^4); % kurtosis
    end
        first_param(:,1)=MR;
        first_param(:,2)=RMSR;
        first_param(:,3)=SkR;
        first_param(:,4)=KuR;
        first_param(:,5)=MW;
        first_param(:,6)=RMSW;
        first_param(:,7)=SkW;
        first_param(:,8)=KuW;
        first_param=dataset(first_param);
        first_param.label{2}={'Mean_h';'RMS_h';'Skew_h';'Kurt_h';'Mean_l';'RMS_l';'Skew_l';'Kurt_l'};
else
  n=a*b;
  for i=1:c
      vector(:,i)=reshape(images(:,:,i), [1,n]);
      M(i)=sum(sum(abs(images(:,:,i))))/n; %aveMge roughness
      RMS(i)=sqrt(mean(vector(:,i).^2)); %RMS roughness
      Sk(i)=sum(sum(images(:,:,i).^3))/(n*RMS(i)^3); %skewness
      Ku(i)=sum(sum(images(:,:,i).^4))/(n*RMS(i)^4); % kurtosis
  end
      first_param(:,1)=M;
      first_param(:,2)=RMS;
      first_param(:,3)=Sk;
      first_param(:,4)=Ku;
      first_param=dataset(first_param);
      first_param.label{2}={'Mean';'RMS';'Skew';'Kurt'};
end
handles.first_param=first_param;
data=first_param.data;
label=first_param.label{2};
t=uitable(image_features,'Data', data, 'ColumnName',label,'Position', [10 0 650 600]);
h = msgbox('Please copy the 1st order statistics data into clipboard or save into MAT file');
guidata(hObject,handles)



% --------------------------------------------------------------------
function texture_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to texture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

images=handles.image;
images=uint8(images);
[a,b,c]=size(images);
for i=1:c
    glcms=graycomatrix(images(:,:,i),'Offset', [5 0]);
    stats = graycoprops(glcms);
    texture(1,i)= stats.Contrast;
    texture(2,i)=stats.Correlation;
    texture(3,i)=stats.Energy;
    texture(4,i)=stats.Homogeneity;
end
texture=texture';
data=texture;
texture=dataset(texture);
texture.label{2}={'Contr';'Corr';'Energ';'Homog'};
handles.texture=texture;
first_param=handles.first_param;
combined=[first_param texture];
handles.combined=combined;
t=uitable(image_features,'Data', data, 'ColumnName',texture.label{2},'Position', [670 -20 350 500]);
h = msgbox('Please copy the 2nd order statistics data into clipboard or save into MAT file');
guidata(hObject,handles)


% --------------------------------------------------------------------
function save_texture_Callback(hObject, eventdata, handles)
% hObject    handle to save_texture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
texture=handles.texture;
data=texture.data;
datapath = uigetdir;
cd(datapath)
[filename, pathname] = uiputfile('*.mat', 'save 1st order statistics into mat file');
save(filename, 'data')




% --------------------------------------------------------------------
function save_all_Callback(hObject, eventdata, handles)
% hObject    handle to save_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

images=handles.image;
texture=handles.texture;
first_param=handles.first_param;
combined=handles.combined;
model1=handles.model1st;
model2=handles.model2nd;
model_comb=handles.comb;
datapath = uigetdir;
cd(datapath)
[filename, pathname] = uiputfile('*.mat', 'save all data into mat file');
save(filename)





% --------------------------------------------------------------------
function save_param_Callback(hObject, eventdata, handles)
% hObject    handle to save_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=handles.combined;
datapath = uigetdir;
cd(datapath)
[filename, pathname] = uiputfile('*.mat', 'save all statistics into mat file');
save(filename, 'data')