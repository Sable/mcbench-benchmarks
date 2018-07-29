function varargout = IMComp(varargin)
%
%
% IMComp is an Image COmpression Software used to compress various JPEG
% images This software is primarilly useful for compressing images which
% are being taken with the help of Digital Cameras and Mobile Phones
% 
% Though using IMComp deteriotes the quality of images. So use of compressed
% images in not recommended for printing purposes. Image quality is not
% being sacrifised if to be used for viewing purposes.
% 
% This could be a handy software for compressing images and using the
% compressed images to E-Mail which comes out to be a major drawback of
% Digital Cameras which produce image size depending on the resolution of
% image and image being taken.
% 
% Using this software compression ratio of 8 to 10 has been achieved during
% testing of the software.
% 
% Users are requested to report bugs at saurabh.nitj@gmail.com

% Last Modified by GUIDE v2.5 31-Dec-2008 02:05:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IMComp_OpeningFcn, ...
                   'gui_OutputFcn',  @IMComp_OutputFcn, ...
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


% --- Executes just before IMComp is made visible.
function IMComp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IMComp (see VARARGIN)

% Choose default command line output for IMComp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes IMComp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = IMComp_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
imagecompression;

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
close(gcf);

