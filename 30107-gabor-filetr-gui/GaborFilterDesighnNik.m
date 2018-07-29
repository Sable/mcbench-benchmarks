function varargout = GaborFilterDesighnNik(varargin)
%% 
%function varargout = GaborFilterDesighnNik(varargin)
%
% Functional purpose: I've made this GUI for a couple of students, which were learning the Gabor Filtering, and had hard
% time to understand the sunbject. This helped them to get some intuition about what Gabor Filtering is, what are it's
% benefits and what are it's uses. This GUI allowes you to play with Gabor filters in order to understand this important
% topic. The user may define a Gabor Filter with all possible parameters, and to filter an image he wishes to. He then
% can see the filtered image, in spatial and frewquncy domain, it's phase and amplitude (as it's unreal signal). The
% filtered can beviewed in spatioal/frequncy domain, and it can be saved for future use. 
%
% Input arguments: None. (Actually GUI settings defned by user).
%
% Output Arguments: None
%
% Issues & Comments: None
%
% Author and Date:  Nikolay Skarbnik 7/07/2008.

%% 
% GABORFILTERDESIGHNNIK M-file for GaborFilterDesighnNik.fig
%      GABORFILTERDESIGHNNIK, by itself, creates a new GABORFILTERDESIGHNNIK or raises the existing
%      singleton*.
%
%      H = GABORFILTERDESIGHNNIK returns the handle to a new GABORFILTERDESIGHNNIK or the handle to
%      the existing singleton*.
%
%      GABORFILTERDESIGHNNIK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GABORFILTERDESIGHNNIK.M with the given input arguments.
%
%      GABORFILTERDESIGHNNIK('Property','Value',...) creates a new GABORFILTERDESIGHNNIK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GaborFilterDesighnNik_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GaborFilterDesighnNik_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GaborFilterDesighnNik

% Last Modified by GUIDE v2.5 15-Mar-2011 23:05:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GaborFilterDesighnNik_OpeningFcn, ...
                   'gui_OutputFcn',  @GaborFilterDesighnNik_OutputFcn, ...
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

% --- Executes just before GaborFilterDesighnNik is made visible.
function GaborFilterDesighnNik_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GaborFilterDesighnNik (see VARARGIN)

% Choose default command line output for GaborFilterDesighnNik
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using GaborFilterDesighnNik.
if strcmp(get(hObject,'Visible'),'off')
    imagesc(peaks(200));
    text(100,20,'Gabor filter visual GUI','FontSize',28,'FontName','Castellar','HorizontalAlignment','center','FontWeight','Bold');
    Str_array={'          Dear user, please do the following:','1) Define the filter, by changing the Mother Gabor parameters',...
        '  or, by loading a previoly saved filter','  (you can view your filter in both time and frequency domains)',...
        '2) Load an image','3) Finally, apply the filter','4) Using the "Show" and "Filtered Image" ',...
        '   button combination you can see the resulting image... '};
    text(10,80,Str_array,'FontSize',20,'FontName','Kartika');
    text(20,180,'\copyright Nikolay S.','FontSize',14,'HorizontalAlignment','center');
end

% UIWAIT makes GaborFilterDesighnNik wait for user response (see UIRESUME)
% uiwait(handles.GaborFiltGUINik);


% --- Outputs from this function are returned to the command line.
function varargout = GaborFilterDesighnNik_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.GaborFiltGUINik)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.GaborFiltGUINik,'Name') '?'],...
                     ['Close ' get(handles.GaborFiltGUINik,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.GaborFiltGUINik)


% --- Executes on selection change in Graph_type_popup.
function Graph_type_popup_Callback(hObject, eventdata, handles)
% hObject    handle to Graph_type_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Graph_type_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Graph_type_popup

n=get(handles.N_edit,'Value') ;
x=linspace(get(handles.X_min_edit,'Value'),get(handles.X_max_edit,'Value'),n);
y=linspace(get(handles.Y_min_edit,'Value'),get(handles.Y_max_edit,'Value'),n);

G=real(handles.FilterData);     %real(get(hObject,'UserData'));
if (get(handles.Frequency_radiobutton,'Value'))
    G=abs(fftshift(fft2(G)));
end

if (get(handles.Hold_on_checkbox,'Value'))
    hold on;
else
    hold off;
end

switch (get(handles.Graph_type_popup,'Value'))
    case (1)
        imagesc(x,y,G);
    case (2)
        mesh(x,y,G);
    case (3)
        surf(x,y,G);
end


% --- Executes during object creation, after setting all properties.
function Graph_type_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Graph_type_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'imagesc', 'mesh', 'surf'});



function N_edit_Callback(hObject, eventdata, handles)
% hObject    handle to N_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of N_edit as text
%        str2double(get(hObject,'String')) returns contents of N_edit as a double

parameter_changed(hObject)

% --- Executes during object creation, after setting all properties.
function N_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to N_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function X_min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to X_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of X_min_edit as text
%        str2double(get(hObject,'String')) returns contents of X_min_edit as a double

parameter_changed(hObject)

% --- Executes during object creation, after setting all properties.
function X_min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to X_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function X_max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to X_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of X_max_edit as text
%        str2double(get(hObject,'String')) returns contents of X_max_edit as a double

parameter_changed(hObject)

% --- Executes during object creation, after setting all properties.
function X_max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to X_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Y_min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Y_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Y_min_edit as text
%        str2double(get(hObject,'String')) returns contents of Y_min_edit as a double

parameter_changed(hObject)

% --- Executes during object creation, after setting all properties.
function Y_min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Y_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Y_max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Y_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Y_max_edit as text
%        str2double(get(hObject,'String')) returns contents of Y_max_edit as a double

parameter_changed(hObject)

% --- Executes during object creation, after setting all properties.
function Y_max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Y_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Frequency_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Frequency_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Frequency_edit as text
%        str2double(get(hObject,'String')) returns contents of Frequency_edit as a double

parameter_changed(hObject)

% --- Executes during object creation, after setting all properties.
function Frequency_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Frequency_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Rotation_Angle_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Rotation_Angle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rotation_Angle_edit as text
%        str2double(get(hObject,'String')) returns contents of Rotation_Angle_edit as a double

parameter_changed(hObject)

% --- Executes during object creation, after setting all properties.
function Rotation_Angle_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rotation_Angle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Sigma_x_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Sigma_x_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Sigma_x_edit as text
%        str2double(get(hObject,'String')) returns contents of Sigma_x_edit as a double

parameter_changed(hObject)

% --- Executes during object creation, after setting all properties.
function Sigma_x_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sigma_x_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Sigma_y_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Sigma_y_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Sigma_y_edit as text
%        str2double(get(hObject,'String')) returns contents of Sigma_y_edit as a double

parameter_changed(hObject)

% --- Executes during object creation, after setting all properties.
function Sigma_y_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sigma_y_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
set(hObject,'FontSize',1e-3);



function Phase_shift_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Phase_shift_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Phase_shift_edit as text
%        str2double(get(hObject,'String')) returns contents of Phase_shift_edit as a double
parameter_changed(hObject)

% --- Executes during object creation, after setting all properties.
function Phase_shift_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Phase_shift_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Time_radiobutton.
function Time_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to Time_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Time_radiobutton
eventdata='datachanged';
Graph_type_popup_Callback(handles.Graph_type_popup, eventdata, handles)


% --- Executes on button press in Frequency_radiobutton.
function Frequency_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to Frequency_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Frequency_radiobutton
eventdata='datachanged';
Graph_type_popup_Callback(handles.Graph_type_popup, eventdata, handles)

function parameter_changed(hObject)
set(hObject,'Value',str2double(get(hObject,'String'))); % "edit" object value, is the numeric value of the string.

handles=guidata(hObject);

n=get(handles.N_edit,'Value') ;

Sigma_x=get(handles.Sigma_x_edit,'Value') ;
Sigma_y=get(handles.Sigma_y_edit,'Value') ;

x=linspace(get(handles.X_min_edit,'Value'),get(handles.X_max_edit,'Value'),n);
y=linspace(get(handles.Y_min_edit,'Value'),get(handles.Y_max_edit,'Value'),n);
% set(handles.axes1,'XLim',[x(1), x(end)]);
% set(handles.axes1,'YLim',[y(1), y(end)]);
axis([x(1), x(end), y(1), y(end)]);


F=get(handles.Frequency_edit,'Value') ; % modulation freq

Theta= get(handles.Rotation_Angle_edit,'Value')*pi/180;

Phase_shift=get(handles.Phase_shift_edit,'Value');
% [x_rot,y_rot]=my_rotate(x,y,Theta);
[X,Y]=meshgrid(x,y);
X_rot=X*cos(Theta)+Y*sin(Theta);
Y_rot=-X*sin(Theta)+Y*cos(Theta);
GaussianMat=1/(2*pi*Sigma_x*Sigma_y)*exp((-((X_rot)/Sigma_x).^2-((Y_rot)/Sigma_y).^2)/2);%exp((-(X_rot)/(Sigma_x)^2-(Y_rot)/(Sigma_y)^2)/2);
% GaussianMat=myGaussian(x_rot, Sigma_x)'*myGaussian(y_rot, Sigma_y);

% FreqModulation=zeros(size(GaussianMat));
% 
% for n=1:length(y)
%     for m=1:length(x)
%         FreqModulation(n,m)=exp(j*F*2*pi*(x(m)*cos(Theta)+y(n)*sin(Theta)));
%     end
% end
FreqModulation=exp(j*(F*2*pi*X_rot+Phase_shift));

% FreqModulation=exp(2*pi*i*F*repmat(x_rot,length(y_rot),1));%'*ones(size(x_rot));
% FreqModulation=exp(2*pi*i*F*x_rot)'*exp(2*pi*i*F*y_rot+Phase_shift); %repmat(exp(2*i*pi*F*x),m,1);
GaborFilter=GaussianMat.*FreqModulation;

handles.FilterData=GaborFilter; % Save the resulting Gabor filter
%set(handles.Graph_type_popup,'UserData',GaborFilter);
guidata(hObject,handles);
eventdata='datachanged';
Graph_type_popup_Callback(handles.Graph_type_popup, eventdata, handles)

function G=myGaussian(x, sigma,mean)
if nargin<3
    mean=0;
    if nargin<2
        sigma=1;
    end
end

G=1/(2*pi)*exp(-((x-mean)/sigma).^2/2);

function [x_rot,y_rot]=my_rotate(x,y,Theta)
%function [x_rot,y_rot]=my_rotate(x,y,Theta) 
% Rotates X and Y by agle Theta (Theta is given in rad)
x_rot=x*cos(Theta)+y*sin(Theta);
y_rot=-x*sin(Theta)+y*cos(Theta);

function error_accured(handles, error_String)
% function error_accured(handles, error_String)
% the function desplays an error string on the GUI screen, once an error
% accures.
set (handles.ErrorText,'String',error_String);
set (handles.ErrorPanel,'Visible','On');%set ([handles.ErrorText, handles.ErrorOffButton],'Visible','On');


% --- Executes on button press in Hold_on_checkbox.
function Hold_on_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to Hold_on_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Hold_on_checkbox


% --- Executes on button press in LoadButton.
function LoadButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=guidata(hObject);

switch (get(handles.FileTypeMenu,'Value'))
    case(1)                  %('Image')
        FilterSpec={'*.jpg;*.jpeg;*.gif;*.bmp;*.png;*.tiff','Image Files  (*.jpg;*.jpeg;*.gif;*.bmp;*.png;*.tiff)'};
        DialogTitle='Select an Image file';
    case(2)                  %('Filter')
        FilterSpec='*.mat';
        DialogTitle='Select a previolsy saved  Filter file';
    case(3)                 %('Filtered Image')
        FilterSpec='*.mat';
        DialogTitle='Select a previolsy saved  Filtered Image file';
end
        
    
[FileName,PathName,FilterIndex] = uigetfile(FilterSpec,DialogTitle);
if isequal(FileName,0)
    error_accured(handles, 'No such file exists. Choose a file.')
    if strcmpi(get(handles.ApplyFilterButton,'Enable'),'On')
        set(handles.ApplyFilterButton,'Enable','Off');
    end

else
    set(handles.FilePathEdit,'String',PathName);
    set(handles.FileNameEdit,'String',FileName);
    if strcmpi(get(handles.ApplyFilterButton,'Enable'),'Off')
        set(handles.ApplyFilterButton,'Enable','On');
    end
end

switch (get(handles.FileTypeMenu,'Value'))
    case(1)                  %('Image')
        ImageDataTmp=imread([PathName,FileName]); 
        if (size(ImageDataTmp,3)==3)           %work with Gray iamges only!!!
            ImageDataTmp=rgb2gray(ImageDataTmp);
        end
        handles.ImageData=double(ImageDataTmp);
    case(2)                  %('Filter')
        FilterDataTmp=load([PathName,FileName]);
        handles.FilterData=FilterDataTmp.tmp;
    case{3,4}                 %('Filtered Image')
        FilteredImageDataTmp=load([PathName,FileName]);
        handles.FilteredImageData=FilteredImageDataTmp.tmp;
end

guidata(hObject,handles);

% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileName=get(handles.FileNameEdit,'String');
PathName=get(handles.FilePathEdit,'String');

if isempty(strfind(FileName,'.mat'))
    % Error, trying to save .mat output in a non *.mat file!!!
    error_accured(handles, 'Attempt to save .mat output in a non *.mat file!!!')
end
tmp=[];
switch (get(handles.FileTypeMenu,'Value'))
    case(1)                  %('Image')
 %Do nothing here. Saving the image is obsolite at this point
    case(2)                  %('Filter')
        tmp=handles.FilterData;
    case{3,4}                 %('Filtered Image')
        tmp=handles.FilteredImageData;
end
if ~isempty(tmp)  save([PathName,FileName],'tmp'); end;

function FilePathEdit_Callback(hObject, eventdata, handles)
% hObject    handle to FilePathEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FilePathEdit as text
%        str2double(get(hObject,'String')) returns contents of FilePathEdit as a double


% --- Executes during object creation, after setting all properties.
function FilePathEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilePathEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FileNameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to FileNameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FileNameEdit as text
%        str2double(get(hObject,'String')) returns contents of FileNameEdit as a double


% --- Executes during object creation, after setting all properties.
function FileNameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileNameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in FileTypeMenu.
function FileTypeMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileTypeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns FileTypeMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FileTypeMenu


% --- Executes during object creation, after setting all properties.
function FileTypeMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileTypeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ShowButton.
function ShowButton_Callback(hObject, eventdata, handles)
% hObject    handle to ShowButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.NewFigCheckBox,'Value'))
    figure; % if checkbox is on, plot graph in a new window
%     title(['Image of ', get(handles.FileTypeMenu,'String')]);
%     hold on;
end

switch (get(handles.FileTypeMenu,'Value'))
    case(1)                  %('Image')
        imshow(uint8(handles.ImageData));
%         if (get(handles.Frequency_radiobutton,'Value'))
%             image(abs(fft2(handles.ImageData)));
%         else
%             imshow(uint8(handles.ImageData));
%         end
    case(2)                  %('Filter')
       eventdata='Show Button was pressed';
       Graph_type_popup_Callback(hObject, eventdata, handles)
    case(3)                 %('Filtered ImageAmplitude')
        if isempty(handles.FilteredImageData)
            eventdata='Filtered Image data is needed';
            ApplyFilterButton_Callback(hObject, eventdata, handles);
%             guidata(hObject,handles);
%             handles=guidata(hObject); % update handle structure
        end
%         if (get(handles.Frequency_radiobutton,'Value'))
%             image(abs(fft2(handles.FilteredImageData)));
%         else
%             imshow(uint8(real(handles.FilteredImageData))); % Showing only real part of filtered image
%         end
       
       imshow(Scale2Uint(abs(handles.FilteredImageData))); % Showing only absolute value of the filtered image
    case(4)   %('Filtered Image Phaze')
        if isempty(handles.FilteredImageData)
            eventdata='Filtered Image data is needed';
            ApplyFilterButton_Callback(hObject, eventdata, handles);
        end
%        imshow(uint8(angle(handles.FilteredImageData))); % Showing only real part of filtered image
        scalled_amp=Scale2Uint(abs(handles.FilteredImageData));
        scalled_phase=Scale2Uint(angle(handles.FilteredImageData));
%         ind=scalled_amp==0;
%         scalled_phase(ind)=0;%set phase for low amplitudes to zero
        scalled_phase(scalled_amp<1)=0;%set phase for low amplitudes to zero
        
        imshow(scalled_phase); % Showing the angle value of the filtered image
    case(5)   %('Laplasina(Filtered Image Phaze)')
        if isempty(handles.FilteredImageData)
            eventdata='Filtered Image data is needed';
            ApplyFilterButton_Callback(hObject, eventdata, handles);
        end
%        imshow(uint8(angle(handles.FilteredImageData))); % Showing only real part of filtered image 
       imshow(Scale2Uint(del2(angle(handles.FilteredImageData)))); % Showing the angle value of the filtered image
    case(6)   %('Gaussian(Filtered Image Phaze)')
        if isempty(handles.FilteredImageData)
            eventdata='Filtered Image data is needed';
            ApplyFilterButton_Callback(hObject, eventdata, handles);
        end
%        imshow(uint8(angle(handles.FilteredImageData))); % Showing only real part of filtered image 
       imshow(Scale2Uint(gradient(angle(handles.FilteredImageData)))); % Showing the angle value of the filtered image

end
if (get(handles.NewFigCheckBox,'Value'))
    temp_str_arr=get(handles.FileTypeMenu,'String');
    temp_str=temp_str_arr(get(handles.FileTypeMenu,'Value'));
    title(temp_str,'FontSize',18);
end



% --- Executes on button press in ApplyFilterButton.
function ApplyFilterButton_Callback(hObject, eventdata, handles)
% hObject    handle to ApplyFilterButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject);
if isempty(handles.ImageData)
    error_accured(handles, 'No Image file loaded');
end

set(handles.GaborFiltGUINik,'Pointer','watch'); drawnow;
% uiwait(handles.GaborFiltGUINik);

if size(handles.ImageData,3)==3
    handles.FilteredImageData=[];
    for i=1:3
        handles.FilteredImageData(:,:,i)=filter2(handles.FilterData,handles.ImageData(:,:,i),'same');
    end
else
    handles.FilteredImageData=filter2(handles.FilterData,handles.ImageData,'same');%conv2(handles.FilterData,handles.ImageData);
end
set(handles.GaborFiltGUINik,'Pointer','arrow');drawnow;
guidata(hObject,handles);
    


% --- Executes during object creation, after setting all properties.
function GaborFiltGUINik_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GaborFiltGUINik (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles=guidata(hObject);
home; % scrole screen up
fprintf('\n\n %s \n\n','(NikolayS) Gabor Filter generation and application GUI started ');
handles.ImageData=[];       % Init vriables, so isempty function can be applied to them.
handles.FilterData=[];
handles.FilteredImageData=[];
guidata(hObject,handles);


% --- Executes on button press in ErrorOffButton.
function ErrorOffButton_Callback(hObject, eventdata, handles)
% hObject    handle to ErrorOffButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set ([handles.ErrorText, handles.ErrorOffButton],'Visible','Off');
set (handles.ErrorPanel,'Visible','Off');


% --- Executes on button press in NewFigCheckBox.
function NewFigCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to NewFigCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of NewFigCheckBox


% --------------------------------------------------------------------
function AboutMenu_Callback(hObject, eventdata, handles)
% hObject    handle to AboutMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web('GaborFilterDesighnNikAbout.htm');


% --------------------------------------------------------------------
function HelpMenu_Callback(hObject, eventdata, handles)
% hObject    handle to HelpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web('GaborFilterDesighnNikHelp.htm');



%% Servise sub functions
function scaled_mat=Scale2Uint(temp) % rescale data to be in margins of UINT8[0-255]
temp=double(temp);
temp_min=min(temp(:));
temp_max=max(temp(:));
temp=temp-temp_min;
temp=255*temp/(temp_max-temp_min);
scaled_mat=uint8(temp);
