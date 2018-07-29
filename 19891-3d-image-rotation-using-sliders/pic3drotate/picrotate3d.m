function varargout = picrotate3d(varargin)
% PICROTATE3D M-file for picrotate3d.fig
%      PICROTATE3D, by itself, creates a new PICROTATE3D or raises the existing
%      singleton*.
%
%      H = PICROTATE3D returns the handle to a new PICROTATE3D or the handle to
%      the existing singleton*.
%
%      PICROTATE3D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PICROTATE3D.M with the given input arguments.
%
%      PICROTATE3D('Property','Value',...) creates a new PICROTATE3D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before picrotate3d_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to picrotate3d_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help picrotate3d

% Last Modified by GUIDE v2.5 06-May-2008 19:15:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @picrotate3d_OpeningFcn, ...
                   'gui_OutputFcn',  @picrotate3d_OutputFcn, ...
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


% --- Executes just before picrotate3d is made visible.
function picrotate3d_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to picrotate3d (see VARARGIN)

% Choose default command line output for picrotate3d
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes picrotate3d wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = picrotate3d_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% ................the following code edited by user.......
% the elevation slider                                   %
set(handles.slider1,'value',0);                          %
set(handles.slider1,'max',30);                           %
set(handles.slider1,'min',-30);                          %
% the Azimuth slider                                     %
set(handles.slider2,'value',0);                          %
set(handles.slider2,'max',180);                          %
set(handles.slider2,'min',-180);                         %     
% the x-axis rotation slider                             %       
set(handles.slider3,'value',0);                          %   
set(handles.slider3,'max',180);                          %         
set(handles.slider3,'min',-180);                         %  
% the y-axis rotation slider                             %     
set(handles.slider4,'value',0);                          %          
set(handles.slider4,'max',180);                          %        
set(handles.slider4,'min',-180);                         %           
% the z-axis slider                                      %  
set(handles.slider5,'value',0);                          %     
set(handles.slider5,'max',180);                          %          
set(handles.slider5,'min',-180);                         %         
pic3d                                                    %       
% ................the end of code edited by user.........%

% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
pic3d

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
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
% ..........the following code edited by user
set(hObject,'value',0);                      %
set(hObject,'max',180);                      %  
set(hObject,'min',-180);                     %   
% ..........the end of code edited by user...%

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
pic3d

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
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
% ..........the following code edited by user%
set(hObject,'value',0);                      %     
set(hObject,'max',30);                       %      
set(hObject,'min',-30);                      %    
% ..........the end of code edited by user...%

% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
pic3d

% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
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
% ..........the following code edited by user%
set(hObject,'value',0);                      %   
set(hObject,'max',180);                      %    
set(hObject,'min',-180);                     %   
% ..........the end of code edited by user...%

% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
pic3d

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
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
% ..........the following code edited by user%
set(hObject,'value',0);                      %  
set(hObject,'max',180);                      %    
set(hObject,'min',-180);                     %     
% ..........the end of code edited by user...%

% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
pic3d

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
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
% ..........the following code edited by user%
set(hObject,'value',0);                      %    
set(hObject,'max',180);                      %       
set(hObject,'min',-180);                     %     
% ..........the end of code edited by user...%

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ..........the following code edited by user%
set(handles.slider1,'value',0);              %     
set(handles.slider1,'max',30);               %          
set(handles.slider1,'min',-30);              %           
% the Azimuth slider                         %   
set(handles.slider2,'value',0);              %          
set(handles.slider2,'max',10);               %         
set(handles.slider2,'min',-10);              %          
% the x-axis rotation slider                 %           
set(handles.slider3,'value',0);              %           
set(handles.slider3,'max',180);              %            
set(handles.slider3,'min',-180);             %            
% the y-axis rotation slider                 %          
set(handles.slider4,'value',0);              %              
set(handles.slider4,'max',180);              %           
set(handles.slider4,'min',-180);             %         
% the z-axis slider                          %      
set(handles.slider5,'value',0);              %          
set(handles.slider5,'max',180);              %               
set(handles.slider5,'min',-180);             %                
                                             %      
pic3d                                        %      
% ..........the end of code edited by user...%

