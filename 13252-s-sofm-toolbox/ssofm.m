function varargout = ssofm(varargin)
% SSOFM M-file for ssofm.fig
%      SSOFM, by itself, creates a new SSOFM or raises the existing
%      singleton*.
%
%      H = SSOFM returns the handle to a new SSOFM or the handle to
%      the existing singleton*.
%
%      SSOFM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SSOFM.M with the given input arguments.
%
%      SSOFM('Property','Value',...) creates a new SSOFM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ssofm_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ssofm_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help ssofm

% Last Modified by GUIDE v2.5 10-Jun-2006 02:13:27


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ssofm_OpeningFcn, ...
                   'gui_OutputFcn',  @ssofm_OutputFcn, ...
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


% --- Executes just before ssofm is made visible.
function ssofm_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ssofm (see VARARGIN)

% Choose default command line output for ssofm
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ssofm wait for user response (see UIRESUME)
% uiwait(handles.ssofmFigure);


% --- Outputs from this function are returned to the command line.
function varargout = ssofm_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function loaddata_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filenameData, pathnameData]=uigetfile('*.mat','Load data...','MultiSelect', 'off');
set(handles.data2Text,'String',filenameData);
handles.Data = [pathnameData filenameData];
guidata(ssofm,handles)
a = get(handles.data2Text,'String');
b = get(handles.ssofm2Text,'String');
if a(1:3)~='...' & b(1:3)~='...'
    set(handles.trainButton,'Enable','on')
end

function epochsEdit_Callback(hObject, eventdata, handles)
% hObject    handle to epochsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epochsEdit as text
%        str2double(get(hObject,'String')) returns contents of epochsEdit as a double


% --- Executes during object creation, after setting all properties.
function epochsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in trainButton.
function trainButton_Callback(hObject, eventdata, handles)
% hObject    handle to trainButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Enable','off');
set(handles.plotglyphButton,'Enable','off');
set(handles.retrainButton,'Enable','off');
s = str2num(get(handles.sizeEdit,'String'));
epochs = str2num(get(handles.epochsEdit,'String'));
if get(handles.plotRadio,'Value') == 1
    showglyph = 'plot';
end
if get(handles.glyphRadio,'Value') == 1
    showglyph = 'glyph';
end
if get(handles.aviRadio,'Value') == 1
    showglyph = get(handles.aviText,'String');
    if isempty(showglyph)
        showglyph = 'test.avi';
    else
        showglyph = [get(handles.aviText,'String') '.avi'];
    end
end
load(handles.Data);
load(handles.Ssofm);
[w,g,r,c,freq]=trainGlyph(P,X,C,s,epochs,showglyph);
handles.w = w;
handles.g = g;
handles.r = r;
handles.c = c;
handles.freq = freq;
handles.X = X;
guidata(ssofm,handles);
set(hObject,'Enable','on');
set(handles.plotglyphButton,'Enable','on');
set(handles.retrainButton,'Enable','on');

function sizeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to sizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sizeEdit as text
%        str2double(get(hObject,'String')) returns contents of sizeEdit as a double


% --- Executes during object creation, after setting all properties.
function sizeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --------------------------------------------------------------------
function loadssofm_Callback(hObject, eventdata, handles)
% hObject    handle to loadssofm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filenameSsofm, pathnameSsofm]=uigetfile('*.mat','Load S-SOFM...','MultiSelect', 'off');
set(handles.ssofm2Text,'String',filenameSsofm);
handles.Ssofm = [pathnameSsofm filenameSsofm];
guidata(ssofm,handles);
a = get(handles.data2Text,'String');
b = get(handles.ssofm2Text,'String');
if a(1:3)~='...' & b(1:3)~='...'
    set(handles.trainButton,'Enable','on')
end

% --------------------------------------------------------------------
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ssofmAbout;

% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





function aviText_Callback(hObject, eventdata, handles)
% hObject    handle to aviText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aviText as text
%        str2double(get(hObject,'String')) returns contents of aviText as a double


% --- Executes during object creation, after setting all properties.
function aviText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aviText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on button press in plotglyphButton.
function plotglyphButton_Callback(hObject, eventdata, handles)
% hObject    handle to plotglyphButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure;
glyph(handles.X,handles.r);



% --- Executes on button press in aviRadio.
function aviRadio_Callback(hObject, eventdata, handles)
% hObject    handle to aviRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of aviRadio
if get(hObject,'Value')==1
    set(handles.aviText,'Enable','on');
else
    set(handles.aviText,'Enable','off');
end



% --- Executes on button press in retrainButton.
function retrainButton_Callback(hObject, eventdata, handles)
% hObject    handle to retrainButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

w = handles.w;
freq = handles.freq;
X = handles.X;
load(handles.Data);
load(handles.Ssofm);
s = str2num(get(handles.sizeEdit,'String'));
if get(handles.plotRadio,'Value') == 1
    showglyph = 'plot';
end
if get(handles.glyphRadio,'Value') == 1
    showglyph = 'glyph';
end
if get(handles.aviRadio,'Value') == 1
    showglyph = get(handles.aviText,'String');
    if isempty(showglyph)
        showglyph = 'test.avi';
    else
        showglyph = [get(handles.aviText,'String') '.avi'];
    end
end

j=1;
% For each epoch
epochs = str2num(get(handles.epochsEdit,'String'));
for i=1:max(epochs)
    % Define the learning rate
    a=0.1*exp(-i/max(epochs));
    % Update the weights
    [w,freq]=updateGlyph(P,X,C,w,a,s,freq);
    % Update g
    g(i+1,:)=[mean(stdrc(w)) 1.96*std(stdrc(w))/sqrt(size(X,1))];
    if strcmp(showglyph,{'none','plot'})==0
        % Standardize the range
        r=stdrc(w);
        % Draw the glyph
        glyph(X,r);
        drawnow
        if strcmp(showglyph,'glyph')==0
            % Add another frame
            aviobj = addframe(aviobj,getframe(gcf));
        end
    elseif showglyph=='plot'
        %plot(0:i,g(1:i+1),'.-','LineWidth',2);
        errorbar(0:i,g(1:i+1,1),g(1:i+1,2),'.-','LineWidth',2);
        axis([0 max(1,i) 1 1.2])
        xlabel('epoch #');
        ylabel('convergence');
        if i<=10
            if i==1
                set(gca,'XTick',0:2);
            else
                set(gca,'XTick',1:i);
            end
        else
            set(gca,'XTickMode','auto');
        end
        drawnow
    else
        % Show progress
        if i==epochs(j)
            fprintf('Epoch %4.0f, log10(convergence) %9.4f\n',i,log10(g(i)));
            j=j+1;
        end
    end
end

[r,c]=stdrc(w);

if strcmp(showglyph,{'none','plot','glyph'})==0
    % Close the avi file
    aviobj = close(aviobj);
end

handles.w = w;
handles.freq = freq;
handles.X = X;
