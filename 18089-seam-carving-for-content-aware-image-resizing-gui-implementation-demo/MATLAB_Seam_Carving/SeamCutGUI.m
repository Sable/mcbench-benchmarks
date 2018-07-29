function varargout = SeamCutGUI(varargin)
% SEAMCUTGUI M-file for SeamCutGUI.fig
%      SEAMCUTGUI, by itself, creates a new SEAMCUTGUI or raises the existing
%      singleton*.
%
%      H = SEAMCUTGUI returns the handle to a new SEAMCUTGUI or the handle to
%      the existing singleton*.
%
%      SEAMCUTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEAMCUTGUI.M with the given input arguments.
%
%      SEAMCUTGUI('Property','Value',...) creates a new SEAMCUTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SeamCutGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SeamCutGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SeamCutGUI

% Last Modified by GUIDE v2.5 18-Dec-2007 18:51:51
%
% Author: Danny Luong
%         http://danluong.com
%
% Last updated: 12/20/07


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SeamCutGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SeamCutGUI_OutputFcn, ...
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


% --- Executes just before SeamCutGUI is made visible.
function SeamCutGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SeamCutGUI (see VARARGIN)


% Choose default command line output for SeamCutGUI
handles.output = hObject;

% Add toolbar to figure
% set(hObject,'toolbar','figure');

disableButtons(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SeamCutGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SeamCutGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.X = handles.rgbX;
handles.dispX=handles.X;

[handles.rows handles.cols handles.dim]=size(handles.X);


handles.E=findEnergy(handles.X);    %Finds the gradient image
handles.dispE=handles.E;
handles.dispS=zeros(handles.rows,handles.cols);

set(handles.popupmenu1,'Value',1);
set(handles.checkbox1,'Value',0);

ImagePlot(handles);
guidata(hObject,handles);

% --- Executes on button press in RemVerSeam.
function RemVerSeam_Callback(hObject, eventdata, handles)
% hObject    handle to RemVerSeam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.rows>1&&handles.cols>1)
    
    disableButtons(handles);
    set(handles.figure1,'Pointer','watch');
    refresh(SeamCutGUI) %redraws the GUI to reflect changes

    %find "energy map" image used for seam calculation given the gradient image
    handles.S=findSeamImg(handles.E);

    %find seam vector given input "energy map" seam calculation image
    handles.SeamVector=findSeam(handles.S);

    %remove seam from image
    handles.X=SeamCut(handles.X,handles.SeamVector);
    handles.E=SeamCut(handles.E,handles.SeamVector);
    handles.S=SeamCut(handles.S,handles.SeamVector);
    
    %updates size of image
    [handles.rows handles.cols handles.dim]=size(handles.X);

    %plot image
    if get(handles.checkbox1,'Value')==1
        %creates image with seam line for visualization purposes
        handles.dispX=SeamPlot(handles.X,handles.SeamVector);
        handles.dispE=SeamPlot(handles.E,handles.SeamVector);
        handles.dispS=SeamPlot(handles.S,handles.SeamVector);
    else
        handles.dispX=handles.X;
        handles.dispE=handles.E;
        handles.dispS=handles.S;
    end

    ImagePlot(handles);
    
    set(handles.figure1,'Pointer','arrow');
    enableButtons(handles); 
    %updates handles struct
    guidata(hObject,handles);
end

% --------------------------------------------------------------------
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to OpenImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

% 
% NewVal = get(hObject,'String');
% handles.edit1 = NewVal;
% guidata(hObject,handles);


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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
% 
% NewVal = str2double(get(hObject,'String'));
% handles.edit2 = NewVal;
% guidata(hObject,handles);

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




% --- Executes on button press in RemHorizSeam.
function RemHorizSeam_Callback(hObject, eventdata, handles)
% hObject    handle to RemHorizSeam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.rows>1&&handles.cols>1)
    
    disableButtons(handles);
    set(handles.figure1,'Pointer','watch');
    refresh(SeamCutGUI) %redraws the GUI to reflect changes

    %for horizontal seam, take normal and gradient image and transpose.
    % NOTE: transpose of a 3-dim image must be done using permute fn. 
    handles.X=permute(handles.X,[2,1,3]);
    handles.E=handles.E.';
        
    %find "energy map" image used for seam calculation given the gradient image
    handles.S=findSeamImg(handles.E);

    %find seam vector given input "energy map" seam calculation image
    handles.SeamVector=findSeam(handles.S);

    %remove seam from image
    handles.X=SeamCut(handles.X,handles.SeamVector);
    handles.E=SeamCut(handles.E,handles.SeamVector);
    handles.S=SeamCut(handles.S,handles.SeamVector);
    
    %for horizontal seam, take normal and gradient image and transpose.
    handles.X=permute(handles.X,[2,1,3]);
    handles.E=handles.E.';
    handles.S=handles.S.';
    
    %plot image
    if get(handles.checkbox1,'Value')==1
        %creates image with seam line for visualization purposes
        handles.dispX=permute(SeamPlot(permute(handles.X,[2,1,3]),handles.SeamVector),[2,1,3]);
        handles.dispE=SeamPlot(handles.E.',handles.SeamVector).';
        handles.dispS=SeamPlot(handles.S.',handles.SeamVector).';
    else
        handles.dispX=handles.X;
        handles.dispE=handles.E;
        handles.dispS=handles.S;
    end

    %updates size of image
    [handles.rows handles.cols handles.dim]=size(handles.X);
    
    ImagePlot(handles);
    
    set(handles.figure1,'Pointer','arrow');
    enableButtons(handles); 
    %updates handles struct
    guidata(hObject,handles);

end

% --- Executes on button press in Resize.
function Resize_Callback(hObject, eventdata, handles)
% hObject    handle to Resize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newcols=str2double(get(handles.edit1,'String'));
newrows=str2double(get(handles.edit2,'String'));
Rcols = handles.cols-newcols;
Rrows = handles.rows-newrows;

if abs(Rcols)>=handles.cols || abs(Rrows)>=handles.rows
    errordlg('Specified dimensions cannot be calculated, minimum image size is 1x1, and maximum is (2xCurrentSize)-1')
    set(handles.edit1,'String',handles.cols);
    set(handles.edit2,'String',handles.rows);
    return
elseif Rrows==0 && Rcols==0
    return
end

disableButtons(handles)
set(handles.figure1,'Pointer','watch');
set(handles.checkbox1,'Value',0);

refresh(SeamCutGUI) %redraws the GUI to reflect changes

if Rcols>0
    clear M
    %downsize image by removing vertical seams
    M=removalMap(handles.X,Rcols);
    handles.X=SeamCut(handles.X,M);
    handles.E=SeamCut(handles.E,M);
    handles.S=findSeamImg(handles.E);
    [handles.rows handles.cols handles.dim]=size(handles.X);
elseif Rcols<0
    clear M
    %increase image size by adding vertical seams
    M=removalMap(handles.X,abs(Rcols));
    handles.X=SeamPut(handles.X,M);
    handles.E=SeamPut(handles.E,M);
    handles.S=findSeamImg(handles.E);
    [handles.rows handles.cols handles.dim]=size(handles.X);
end

if Rrows>0
    clear M
    %downsize image by removing horizontal seams
    Y=permute(handles.X,[2,1,3]);
    M=removalMap(Y,Rrows);
    handles.X=permute(SeamCut(Y,M),[2,1,3]);
    handles.E=SeamCut(handles.E.',M).';
    handles.S=findSeamImg(handles.E);
    [handles.rows handles.cols handles.dim]=size(handles.X);
elseif Rrows<0
    clear M
    %increase image size by adding horizontal seams
    Y=permute(handles.X,[2,1,3]);
    M=removalMap(Y,abs(Rrows));
    handles.X=permute(SeamPut(Y,M),[2,1,3]);
    handles.E=SeamPut(handles.E.',M).';
    handles.S=findSeamImg(handles.E);
    [handles.rows handles.cols handles.dim]=size(handles.X);
end

handles.dispX=handles.X;
handles.dispE=handles.E;
handles.dispS=handles.S;
[handles.rows handles.cols handles.dim]=size(handles.X);

ImagePlot(handles)
set(handles.figure1,'Pointer','arrow');
enableButtons(handles);

guidata(hObject,handles);

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

ImagePlot(handles);



% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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
% axis off



% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


function disableButtons(handles) 
    %disable all the buttons so they cannot be pressed
    set(handles.Reset,'Enable','off');
    set(handles.RemVerSeam,'Enable','off');
    set(handles.RemHorizSeam,'Enable','off');
    set(handles.Resize,'Enable','off');
    set(handles.popupmenu1,'Enable','off'); 
    set(handles.checkbox1,'Enable','off'); 
    set(handles.edit1,'Enable','off'); 
    set(handles.edit2,'Enable','off'); 

function enableButtons(handles)
    %enable all the buttons so they can be pressed
    set(handles.Reset,'Enable','on');
    set(handles.RemVerSeam,'Enable','on');
    set(handles.RemHorizSeam,'Enable','on');
    set(handles.Resize,'Enable','on');
    set(handles.popupmenu1,'Enable','on'); 
    set(handles.checkbox1,'Enable','on'); 
    set(handles.edit1,'Enable','on'); 
    set(handles.edit2,'Enable','on'); 

function ImagePlot(handles)
    figure(handles.SI);
    value=get(handles.popupmenu1,'Value');
    switch value
        case 1
            imshow(handles.dispX,[min(handles.dispX(:)) max(handles.dispX(:))]);
        case 2
            imshow(handles.dispE,[min(handles.dispE(:)) max(handles.dispE(:))]);
        case 3
            imshow(handles.dispS,[min(handles.dispS(:)) max(handles.dispS(:))]);
    end

        set(handles.edit1,'String',num2str(handles.cols));
        set(handles.edit2,'String',num2str(handles.rows));

return


% --- Executes on button press in OpenImg.
function OpenImg_Callback(hObject, eventdata, handles)
% hObject    handle to OpenImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.SI=figure(1);
% Get file name
[FileName,PathName] = uigetfile('*.*','Select Image');

if (FileName)==0
    return
end

enableButtons(handles);

FullPathName = [PathName,'\',FileName];

%read in image and get size
rgbX = imread(FullPathName);
handles.rgbX = double(rgbX)/255;
handles.X = (handles.rgbX);
handles.dispX=handles.X;

[handles.Orows handles.Ocols handles.Odim]=size(handles.X);
[handles.rows handles.cols handles.dim]=size(handles.X);

handles.E=findEnergy(handles.X);    %Finds the gradient image
handles.dispE=handles.E;

handles.dispS=zeros(handles.rows, handles.cols);

iptsetpref('ImshowBorder','tight')  %removes figure broder
ImagePlot(handles);

guidata(hObject,handles);


return;
