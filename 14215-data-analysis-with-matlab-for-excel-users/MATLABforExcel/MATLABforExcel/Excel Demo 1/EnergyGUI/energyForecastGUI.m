function varargout = energyForecastGUI(varargin)
% ENERGYFORECASTGUI M-file for energyForecastGUI.fig
%      ENERGYFORECASTGUI, by itself, creates a new ENERGYFORECASTGUI or raises the existing
%      singleton*.
%
%      H = ENERGYFORECASTGUI returns the handle to a new ENERGYFORECASTGUI or the handle to
%      the existing singleton*.
%
%      ENERGYFORECASTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENERGYFORECASTGUI.M with the given input arguments.
%
%      ENERGYFORECASTGUI('Property','Value',...) creates a new ENERGYFORECASTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before energyForecastGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to energyForecastGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help energyForecastGUI

% Last Modified by GUIDE v2.5 08-Feb-2007 15:11:32
% Copyright 2006-2009 The MathWorks, Inc.

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @energyForecastGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @energyForecastGUI_OutputFcn, ...
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


% --- Executes just before energyForecastGUI is made visible.
function energyForecastGUI_OpeningFcn(hObject, eventdata, handles, varargin) %#ok
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to energyForecastGUI (see VARARGIN)

% Choose default command line output for energyForecastGUI
handles.output = hObject;

if ~isfield(handles, 'zoomBtn')
  handles = createToolbarBtns(handles);
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes energyForecastGUI wait for user response (see UIRESUME)
% uiwait(handles.energyForecastGUI);

% Optional argument calls
if nargin == 5
  ln = length(varargin{2});
  if ln > 0
    vars = varargin{2};
    Open_Callback(handles.Open, [], handles, vars{1});
    if ln > 1
      set(handles.days, 'Value', vars{2});
      if ln > 2
        switch vars{3}
          case 1
            set(handles.onestd, 'Value', 1);
          case 2
            set(handles.twostd, 'Value', 1);
          case 3
            set(handles.threestd, 'Value', 1);
        end
        if ln > 3
          switch vars{4}
            case 1
              set(handles.totalgrid, 'Value', 1);
            case 2
              set(handles.liability, 'Value', 1);
          end
          if ln > 4
            set(handles.hours, 'String', vars{5});
          end
        end
      end
      estimate_Callback(handles.estimate, [], handles);
    end
  end
end   
  

% --- Outputs from this function are returned to the command line.
function varargout = energyForecastGUI_OutputFcn(hObject, eventdata, handles) %#ok
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in estimate.
function estimate_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to estimate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Retreived data from workspace

histData       = getappdata(handles.energyForecastGUI, 'historical');

totalgrid      = get(handles.totalgrid, 'Value');
liability      = get(handles.liability, 'Value');

if    (totalgrid == 1 && liability == 0)
   data = histData.gridDemand  ;
elseif(totalgrid == 0 && liability == 1)
   data = histData.powerOutput ;
else
   error('Invalid setting for "total grid" and "liability"')
end

% Pull selected days from GUI

choiceDays     = get(handles.days ,'String');
selection      = get(handles.days ,'Value' );
selectedDays   = {choiceDays{selection}    };

% Pull selected hours from GUI

selectedHours  = str2num(get(handles.hours,'String')); %#ok

% Pull standard deviation from GUI

config.std_one = get(handles.onestd  , 'Value');
config.std_two = get(handles.twostd  , 'Value');
config.std_thr = get(handles.threestd, 'Value');

% Call estimation function

h = plotEstimate(data           , histData.dayType, ...
                 selectedDays   , selectedHours   , config  );

set(handles.onestd,   'UserData', h(1));
set(handles.twostd  , 'UserData', h(2));
set(handles.threestd, 'UserData', h(3));


% --- Executes during object creation, after setting all properties.
function days_CreateFcn(hObject, eventdata, handles) %#ok
% hObject    handle to days (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function hours_CreateFcn(hObject, eventdata, handles) %#ok
% hObject    handle to hours (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function Open_Callback(hObject, eventdata, handles, fn) %#ok
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if nargin < 3
  handles = guidata(hObject);
end
if nargin < 4
  [fileName, pathName] = uigetfile('*.xls');
else
  [pathName, fileName, ext] = fileparts(fn);
  fileName = [fileName, ext];
end

if isnumeric(fileName)
  return;
end

set(handles.forecastpanel, 'Title', ['Forecast: ', fileName]);

dayType     = xlsread(fullfile(pathName, fileName), 'Weather'   , 'B2:B32');
hdd         = xlsread(fullfile(pathName, fileName), 'Weather'   , 'C2:C32');
gridDemand  = xlsread(fullfile(pathName, fileName), 'Total'     , 'B2:Y32'); 
powerOutput = xlsread(fullfile(pathName, fileName), 'Liability' , 'B2:Y32');

data.gridDemand  = gridDemand ;
data.powerOutput = powerOutput;
data.dayType     = dayType    ;
data.hdd         = hdd        ;

set(handles.estimate, 'enable', 'on');

setappdata(handles.energyForecastGUI, 'historical', data);

set(handles.onestd,   'UserData', []);
set(handles.twostd  , 'UserData', []);
set(handles.threestd, 'UserData', []);

if get(handles.totalgrid, 'Value')
  dat = data.gridDemand';
else
  dat = data.powerOutput';
end
plot(dat);
xlabel('Hour of Day'              );
ylabel('System Load (MW)'         );
title ('Daily Profile');
grid  ('on');

xlim  ([ 1  24]                   );
ylim  ([25 120]                   );
set   (gca, 'xtick', [ 1 3 6 9 12 15 18 21 24 ]);

% --- Executes on button press in onestd.
function onestd_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to onestd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of onestd

switch get(hObject, 'Value')
  case 0
   set(get(hObject, 'UserData'), 'Visible', 'off');
  case 1
   set(get(hObject, 'UserData'), 'Visible', 'on' );
end

% --- Executes on button press in twostd.
function twostd_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to twostd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of twostd

switch get(hObject, 'Value')
  case 0
   set(get(hObject, 'UserData'), 'Visible', 'off');
  case 1
   set(get(hObject, 'UserData'), 'Visible', 'on' );
end


% --- Executes on button press in threestd.
function threestd_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to threestd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of threestd

switch get(hObject, 'Value')
  case 0
   set(get(hObject, 'UserData'), 'Visible', 'off');
  case 1
   set(get(hObject, 'UserData'), 'Visible', 'on' );
end


% create toolbar buttons
function handles = createToolbarBtns(handles)

% load button icons
load GUIicons

ht = uitoolbar(...
  'Parent'          , handles.energyForecastGUI);
handles.openBtn = uipushtool(ht , ...
  'CData'           , OpenCData, ...
  'ClickedCallback' , @Open_Callback, ...
  'TooltipString'   , 'Open File');
handles.printBtn = uipushtool(ht , ...
  'CData'           , PrintCData, ...
  'ClickedCallback' , @print_fcn, ...
  'TooltipString'   , 'Print Figure');
handles.zoomBtn = uitoggletool(ht , ...
  'CData'           , ZoomCData, ...
  'ClickedCallback' , @zoom_fcn, ...
  'Separator'       , 'on', ...
  'TooltipString'   , 'Zoom');
handles.panBtn = uitoggletool(ht , ...
  'CData'           , PanCData, ...
  'ClickedCallback' , @pan_fcn, ...
  'TooltipString'   , 'Pan');
handles.datatipBtn = uitoggletool(ht , ...
  'CData'           , DataTipCData, ...
  'ClickedCallback' , @datatip_fcn, ...
  'TooltipString'   , 'Data Tip');


% zoom button callback
function zoom_fcn(hObject, eventdata) %#ok
% hObject    handle to Zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

handles = guidata(hObject);
if strcmpi(get(hObject, 'State'), 'off')
  zoom off;
else
  set(handles.datatipBtn, 'State', 'off');
  set(handles.panBtn, 'State', 'off');
  datacursormode off;
  pan off;
  zoom yon;
end

% datatip button callback
function datatip_fcn(hObject, eventdata) %#ok
% hObject    handle to DataTip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

handles = guidata(hObject);
if strcmpi(get(hObject, 'State'), 'off')
  datacursormode off;
else
  set(handles.zoomBtn, 'State', 'off');
  set(handles.panBtn, 'State', 'off');
  zoom off;
  pan off;
  datacursormode on;
end

% pan button callback
function pan_fcn(hObject, eventdata) %#ok
% hObject    handle to Pan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

handles = guidata(hObject);
if strcmpi(get(hObject, 'State'), 'off')
  pan off;
else
  set(handles.zoomBtn, 'State', 'off');
  set(handles.datatipBtn, 'State', 'off');
  zoom off;
  datacursormode off;
  pan on;
end

% print button callback
function print_fcn(hObject, eventdata, handles) %#ok
% hObject    handle to Print (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

handles = guidata(hObject);
printdlg(handles.energyForecastGUI);


function File_Callback(varargin)
function days_Callback(varargin)
