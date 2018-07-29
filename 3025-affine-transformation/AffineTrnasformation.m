function varargout = AffineTrnasformation(varargin)
% AFFINETRNASFORMATION M-file for AffineTrnasformation.fig
% Affine_Transf computes and applies the geometric affine transformation to a 2-D image.
%
% The program main functions are:
% - Load Image: Load the image to be transformed.
% - Transform Image: Computes the transformation matrix from the transformation parameters specified by the user, then it applies the transformation to the loaded image.
% - Save Image: Save the transformed image.
% - Quit: Exit the program.
% The transformation parameters are specified by the user by editing the
% values of the rotation, scale (x and y), and shear (x and y). The
% translation is not icluded because it can be easily (normalized or) removed from image by
% subtracting the shape cetroid.
%
% The affine matrix and the transformation are computed using Matlab Image Processing Toolbox
% functions: maketform and imtransform, so this program is only demonstrates the computation and the applying of these functions to a 2-D image.
%
% Version 1.0
% Copyright Feb 2003, Ibrahim El Rube
% ielrube@yahoo.com

% Begin initialization code - DO NOT EDIT
global gg gc;
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AffineTrnasformation_OpeningFcn, ...
                   'gui_OutputFcn',  @AffineTrnasformation_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before AffineTrnasformation is made visible.
function AffineTrnasformation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AffineTrnasformation (see VARARGIN)

% Choose default command line output for AffineTrnasformation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AffineTrnasformation wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = AffineTrnasformation_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gg
% Get default command line output from handles structure
varargout{1} = handles.output;

gg=2;
% --- Executes on button press in Load_image.
function Load_image_Callback(hObject, eventdata, handles)
% hObject    handle to Load_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gg gc;

h=guidata(gcbo);
set(h.message_text,'String','');  % Clear Messages
gg=gg+2;
h.image_filename=1;
h.image_pathname=1;
[filename, pathname] = uigetfile( ...
       {'*.bmp;*.tif;*.jpg;*.pcx;*.png;*.hdf;*.xwd;*.ras;*.pbm;*.pgm;*.ppm;*.pnm', 'All MATLAB SUPPORTED IMAGE Files (*.bmp,*.tif,*.jpg,*.pcx,*.png,*.hdf,*.xwd,*.ras,*.pbm,.pgm,*.ppm,*.pnm)'} ...
        ,'Pick a file');     % Load Image file and path names
    if filename~=0
        gg=1;
        h.gg=1;
        h.image_filename=filename;  % Image file name
        h.image_pathname=pathname;  % Image path name
        set(h.Showaxes,'visible','off');
        axes(h.axes1);
        set(h.figure1_title,'Visible','on');
        image_1=imread([pathname filename]); % Load Image
        imshow(image_1);                     % Show Loaded Image
        h.image_1=image_1;
        set(h.axes2,'Visible','off');
        axes(h.axes2);
        cla;
        set(h.figure2_title,'Visible','off');
        gc=0;
        h.axis12=0;
        guidata(gcbo,h);
    end
% --- Executes during object creation, after setting all properties.
function xscale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function xscale_Callback(hObject, eventdata, handles)
% hObject    handle to xscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xscale as text
%        str2double(get(hObject,'String')) returns contents of xscale as a
%        double

% --- Executes during object creation, after setting all properties.
function rot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function rot_Callback(hObject, eventdata, handles)
% hObject    handle to rot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rot as text
%        str2double(get(hObject,'String')) returns contents of rot as a double


% --- Executes during object creation, after setting all properties.
function xshear_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xshear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function xshear_Callback(hObject, eventdata, handles)
% hObject    handle to xshear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xshear as text
%        str2double(get(hObject,'String')) returns contents of xshear as a double


% --- Executes during object creation, after setting all properties.
function xtrans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xtrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function xtrans_Callback(hObject, eventdata, handles)
% hObject    handle to xtrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xtrans as text
%        str2double(get(hObject,'String')) returns contents of xtrans as a double


% --- Executes on button press in deg.
function deg_Callback(hObject, eventdata, handles)
% hObject    handle to deg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of deg
h=guidata(gcbo);
%set(h.rad,'Value',0);
ch=get(hObject,'Value');
switch ch
case 0
   set(h.rad,'Value',1)
case 1
   set(h.rad,'Value',0)
end
guidata(gcbo,h);
% --- Executes on button press in rad.
function rad_Callback(hObject, eventdata, handles)
% hObject    handle to rad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rad
h=guidata(gcbo);
%set(h.rad,'Value',0);
ch=get(hObject,'Value');
switch ch
case 0
  set(h.deg,'Value',1)
case 1
  set(h.deg,'Value',0)
end
guidata(gcbo,h);
% --- Executes on button press in bshear.
function bshear_Callback(hObject, eventdata, handles)
% hObject    handle to bshear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bshear


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes during object creation, after setting all properties.
function ytrans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ytrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ytrans_Callback(hObject, eventdata, handles)
% hObject    handle to ytrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ytrans as text
%        str2double(get(hObject,'String')) returns contents of ytrans as a double


% --- Executes on button press in btrans.
function btrans_Callback(hObject, eventdata, handles)
% hObject    handle to btrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of btrans


% --- Executes during object creation, after setting all properties.
function yscale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function yscale_Callback(hObject, eventdata, handles)
% hObject    handle to yscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yscale as text
%        str2double(get(hObject,'String')) returns contents of yscale as a double


% --- Executes on button press in bscale.
function bscale_Callback(hObject, eventdata, handles)
% hObject    handle to bscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bscale


% --- Executes on button press in Transform.
function Transform_Callback(hObject, eventdata, handles)
% hObject    handle to Transform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gg gc;
gc=0;
h=guidata(gcbo);
if  gg~=2 
    h=guidata(gcbo);
    image_1=h.image_1;  % Get Image 1
    hb(1)=num_check(h.rot); % Rotation
    hb(2)=num_check(h.xscale); % Scale in x-direction
    hb(3)=num_check(h.yscale); % Scale in y-direction
    hb(4)=num_check(h.xshear); % Shear
    hb(5)=num_check(h.yshear);
    hc=sum(hb);
    switch hc
        case 0
            a=str2num(get(h.xscale,'String'));  
            b=str2num(get(h.xshear,'String'));
            c=str2num(get(h.yshear,'String'));
            d=str2num(get(h.yscale,'String'));
            th=str2num(get(h.rot,'String'));  %2*pi/10;
            ch=get(h.deg,'Value');
            switch ch
                case 0
                    th=th;
                otherwise
                    th=th*pi/180;;
            end   
            k=1;
            TT=k*[cos(th) -sin(th); sin(th) cos(th)]*[a b; c d];
            TTT=[ 1 0 0; 0 1 0; 0 0 1];
            TTT(1:2,1:2)=TT;
            set(h.message_text,'String','Transformaing .... Please Wait');
            tform=maketform('affine',TTT);
            [image_2] = imtransform(image_1,tform);
            h.image_2=image_2;
            axes(h.axes2);
            set(h.figure2_title,'Visible','on');
            imshow(image_2,[]);
            gc=1;
            axes(h.axes2);
            g2=h.axis12;
            switch g2
                case 0
                    axes(h.axes1);   
                    axis on;
                    axes(h.axes2);   
                    axis on;
                otherwise
                    axes(h.axes1);   
                    axis off;
                    axes(h.axes2);   
                    axis off;
            end
            set(h.message_text,'String','Done');
            set(h.Showaxes,'Visible','on');
            guidata(gcbo,h);    
        otherwise
            set(h.message_text,'String','Invalid value: enter a real number only');
    end
end


% --- Executes on button press in Save_image.
function Save_image_Callback(hObject, eventdata, handles)
% hObject    handle to Save_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gg gc;
h=guidata(gcbo);
set(h.message_text,'String',''); 
if   gc~=0
    dot='.';
    pathname=h.image_pathname;
    [filename, pathname] = uiputfile('*.*', 'Save Transformed Image');
    if filename~=0 
        try_again=find(filename==dot);
        if ~isempty(try_again) 
            image_ex=filename(try_again+1:end);
            valid_ex=['BMP'; 'TIF'; 'JPG'; 'PCX'; 'PNG'; 'HDF'; 'XWD'; 'RAS'; 'PBM'; 'PGM'; 'PPM'; 'PNM';];
            p=['\<' image_ex '\>'];
            g=regexpi(valid_ex,p);  % Match Exact extension, ignoring case.      
            b=cell2mat(g);           % Convert cell to matrix  
            if b~=0 & length(image_ex)==3
                  CMap=colormap(h.axes1);
                  h.savedimage_filename=filename;
                  h.savedimage_pathname=pathname;
                  imwrite(h.image_2,CMap,[pathname filename]);
                  savedto=['Image Saved to:    ' pathname filename];
                  set(h.message_text,'String',savedto); 
             else
                  set(h.message_text,'String','Invalid file extension: Image NOT saved, use one of these extensions, BMP TIF JPG PCX PNG HDF XWD RAS PBM PGM PPM PNM');      
            end
        else
            set(h.message_text,'String','Empty file extension: Image NOT saved, use one of these extensions, BMP TIF JPG PCX PNG HDF XWD RAS PBM PGM PPM PNM'); 
        end
   
    end
end
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% --- Executes during object creation, after setting all properties.
function yshear_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yshear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function yshear_Callback(hObject, eventdata, handles)
% hObject    handle to yshear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yshear as text
%        str2double(get(hObject,'String')) returns contents of yshear as a double

function hb=num_check(ha);
% This function checks the validation of the entered transformation
% parameters
% ha is the handle to be checked
% hb is a flag, 1 for correct range, 0 for incorrect range.
h=guidata(gcbo);
ba=get(ha,'String');
bb=str2num(ba);
hb=0;
if isempty(bb) | ba=='i' | ba=='j'
    axes(h.axes2);
    cla;
    set(h.message_text,'String','Invalid value: enter a real number only');
    switch ha
        case h.xscale
            set(ha,'String','1');
        case h.yscale
            set(ha,'String','1');
        otherwise
            set(ha,'String','0');
    end
    hb=1;
    %break
end
%hb=ha;
%guidata(gcbo,h);


% --- Executes on button press in Showaxes.
function Showaxes_Callback(hObject, eventdata, handles)
% hObject    handle to Showaxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=guidata(gcbo);
sh=get(h.Showaxes,'String');
switch sh
    case 'Show Axes'
        set(h.Showaxes,'String','Hide Axes');
        h.axis12=0;
    otherwise
        set(h.Showaxes,'String','Show Axes'); 
        h.axis12=1;
end
g1=get(h.axes1,'visible');
axes(h.axes1);
switch g1
    case 'off'
        axis on;
        set(h.axes1,'visible','on');
    otherwise
        axis off;
        set(h.axes1,'visible','off');
end
g2=get(h.axes2,'visible');
axes(h.axes2);
switch g2
    case 'off'     
        axis on;
        set(h.axes2,'visible','on');
    otherwise
        axis off;
        set(h.axes2,'visible','off');
end;
guidata(gcbo,h);