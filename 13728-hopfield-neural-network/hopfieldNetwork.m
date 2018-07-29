function varargout = hopfieldNetwork(varargin)
% HOPFIELDNETWORK M-file for hopfieldNetwork.fig
%      HOPFIELDNETWORK, by itself, creates a new HOPFIELDNETWORK or raises the existing
%      singleton*.
%
%      H = HOPFIELDNETWORK returns the handle to a new HOPFIELDNETWORK or the handle to
%      the existing singleton*.
%
%      HOPFIELDNETWORK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HOPFIELDNETWORK.M with the given input arguments.
%
%      HOPFIELDNETWORK('Property','Value',...) creates a new HOPFIELDNETWORK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hopfieldNetwork_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hopfieldNetwork_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help hopfieldNetwork

% Last Modified by GUIDE v2.5 21-Jan-2007 15:45:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hopfieldNetwork_OpeningFcn, ...
                   'gui_OutputFcn',  @hopfieldNetwork_OutputFcn, ...
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


% --- Executes just before hopfieldNetwork is made visible.
function hopfieldNetwork_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hopfieldNetwork (see VARARGIN)

% Choose default command line output for hopfieldNetwork
handles.output = hObject;
N = str2num(get(handles.imageSize,'string'));
handles.W = [];
handles.hPatternsDisplay = [];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes hopfieldNetwork wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = hopfieldNetwork_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% cleans all data and enables the change of the number of neurons used
    for n=1 : length(handles.hPatternsDisplay)
        delete(handles.hPatternsDisplay(n));
    end
    handles.hPatternsDisplay = [];
    set(handles.imageSize,'enable','on');
    handles.W = [];
    guidata(hObject, handles);


function imageSize_Callback(hObject, eventdata, handles)
% hObject    handle to imageSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    num = get(hObject,'string');
    n = str2num(num);
    if isempty(n)
        num = '32';
        set(hObject,'string',num);
    end
    if n > 32
        warndlg('It is strongly recomended NOT to work with networks with more then 32^2 neurons!','!! Warning !!')
    end


% --- Executes during object creation, after setting all properties.
function imageSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in loadIm.
function loadIm_Callback(hObject, eventdata, handles)
    [fName dirName] = uigetfile('*.bmp;*.tif;*.jpg;*.tiff');
    if fName
        set(handles.imageSize,'enable','off');
        cd(dirName);
        im = imread(fName);
        N = str2num(get(handles.imageSize,'string'));
        im = fixImage(im,N);
        imagesc(im,'Parent',handles.neurons);
        colormap('gray');
    end


% --- Executes on button press in train.
function train_Callback(hObject, eventdata, handles)
    
    Npattern = length(handles.hPatternsDisplay);
    if Npattern > 9 
        msgbox('more then 10 paterns isn''t supported!','error');
        return
    end
    
    im = getimage(handles.neurons);
    N = get(handles.imageSize,'string');
    N = str2num(N);
    W = handles.W;  %weights vector
    avg = mean(im(:));   %removing the cross talk part
    if ~isempty(W)
        %W = W +( kron(im,im))/(N^2);
        W = W + ( kron(im-avg,im-avg))/(N^2)/avg/(1-avg);
    else
        % W = kron(im,im)/(N^2);
        W = ( kron(im-avg,im-avg))/(N^2)/avg/(1-avg);
    end
    % Erasing self weight
    ind = 1:N^2;
    f = find(mod(ind,N+1)==1);
    W(ind(f),ind(f)) = 0;
    
    handles.W = W;
    
    % Placing the new pattern in the figure...
    xStart = 0.01;
    xEnd = 0.99;
    height = 0.65;
    width = 0.09;
    xLength = xEnd-xStart;
    xStep = xLength/10;
    offset = 4-ceil(Npattern/2);
    offset = max(offset,0);
    y = 0.1;
    
    if Npattern > 0
        for n=1 : Npattern
            x = xStart+(n+offset-1)*xStep;
            h = handles.hPatternsDisplay(n);
            set(h,'units','normalized');
            set(h,'position',[x y width height]);
        end
        x = xStart+(n+offset)*xStep;
        h = axes('units','normalized','position',[x y width height]);
        handles.hPatternsDisplay(n+1) = h;
        imagesc(im,'Parent',h);
    else
        x = xStart+(offset)*xStep;
        h = axes('units','normalized','position',[x y width height]);
        handles.hPatternsDisplay = h;
    end
    
    imagesc(im,'Parent',h);
    set(h, 'YTick',[],'XTick',[],'XTickMode','manual','Parent',handles.learnedPaterns);
  
    guidata(hObject, handles);

% --- Executes on button press in addNoise.
function addNoise_Callback(hObject, eventdata, handles)
    im = getimage(handles.neurons);
    % N = get(handles.imageSize,'string'); 
    % N = floor(str2num(N)/2)+1;
    noisePercent = get( handles.noiseAmount, 'value' );
    N = round( length(im(:))* noisePercent );
    N = max(N,1);   %minimum change one neuron
    ind = ceil(rand(N,1)*length(im(:)));
%    im(ind) = -1*im(ind); %!!!!
    im(ind) = ~im(ind);
    imagesc(im,'Parent',handles.neurons);
    colormap('gray');
    


% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
    im = getimage(handles.neurons);
    [rows cols] = size(im);
    if rows ~= cols
        msgbox('I don''t support non square images','error');
        return;
    end
    N = rows;
    W = handles.W;
    if isempty(W)
        msgbox('No train data - doing nothing!','error');
        return;        
    end
    %figure; imagesc(W)
    mat = repmat(im,N,N);
    mat = mat.*W;
    mat = im2col(mat,[N,N],'distinct');
    networkResult = sum(mat);
    networkResult = reshape(networkResult,N,N);
    im = fixImage(networkResult,N);
    imagesc(im,'Parent',handles.neurons);
    
    
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function im = fixImage(im,N)
%    if isrgb(im)
	if length( size(im) ) == 3
        im = rgb2gray(im);
    end
    im = double(im);
    m = min(im(:));
    M = max(im(:));
    im = (im-m)/(M-m);  %normelizing the image
    im = imresize(im,[N N],'bilinear');
    %im = (im > 0.5)*2-1;    %changing image values to -1 & 1
    im = (im > 0.5);    %changing image values to 0 & 1



% --- Executes on slider movement.
function noiseAmount_Callback(hObject, eventdata, handles)
% hObject    handle to noiseAmount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    percent = get(hObject,'value');
    percent = round(percent*100);
    set(handles.noisePercent,'string',num2str(percent));

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function noiseAmount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noiseAmount (see GCBO)
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


