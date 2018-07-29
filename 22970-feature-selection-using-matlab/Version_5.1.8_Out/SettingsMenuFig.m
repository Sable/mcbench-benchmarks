function varargout = SettingsMenuFig(varargin)

% Input: none
% Output: varargout{1} = FSSettings; with
%         FSSettings.GammaParam
%         FSSettings.PercTest
%         FSSettings.ConfMatSwitch
%         FSSettings.TotalNStepsThres
%         FSSettings.LogViewOfIntStep
%         FSSettings.MahalInfoLossMethod
%         FSSettings.NHits
%         FSSettings.NCorePatterns 

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                  'gui_OpeningFcn', @SettingsMenuFig_OpeningFcn,...
                   'gui_OutputFcn',  @SettingsMenuFig_OutputFcn,...
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

%------------------------------------------------------------------
function SettingsMenuFig_OpeningFcn(hObject, eventdata, handles,...
                                                          varargin)
handles.output = hObject;
guidata(hObject, handles);

function varargout = SettingsMenuFig_OutputFcn(hObject, ...
                                                eventdata, handles) 
global FSSettings
uiwait
varargout{1} = FSSettings;
%------------------------------------------------------------------          
function GammaSelectionMenu_CreateFcn(hObject, eventdata, handles)
global FSSettings 
contents = get(hObject,'String');
FSSettings.GammaParam = str2num(contents{get(hObject,'Value')});
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
                                'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);

function GammaSelectionMenu_Callback(hObject, eventdata, handles)
global FSSettings
contents = get(hObject,'String');
FSSettings.GammaParam = str2num(contents{get(hObject,'Value')});
guidata(hObject, handles);

%------------------------------------------------------------------
function PercTestMenu_CreateFcn(hObject, eventdata, handles)
global FSSettings
contents = get(hObject,'String');
FSSettings.PercTest = str2num(contents{get(hObject,'Value')});
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
                                'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);

function PercTestMenu_Callback(hObject, eventdata, handles)
global FSSettings
contents = get(hObject,'String');
FSSettings.PercTest = str2num(contents{get(hObject,'Value')});
guidata(hObject, handles);
%------------------------------------------------------------------

function ConfMatSwitchBox_Callback(hObject, eventdata, handles)
global FSSettings
FSSettings.ConfMatSwitch = get(hObject,'Value');
guidata(hObject, handles);

%-----------------------------------------------------------------
function TotalFSStepsThresMenu_Callback(hObject,eventdata, handles)
global FSSettings
contents = get(hObject,'String'); 
FSSettings.TotalNStepsThres=str2num(contents{get(hObject,'Value')});
guidata(hObject, handles);

function TotalFSStepsThresMenu_CreateFcn(hObject,eventdata,handles)
global FSSettings
contents = get(hObject,'String');
FSSettings.TotalNStepsThres = ...
                           str2num(contents{get(hObject,'Value')});
if ispc && isequal(get(hObject,'BackgroundColor'), ...
                        get(0,'defaultUicontrolBackgroundColor'));
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);
%------------------------------------------------------------------
function LogViewOfIntStep_Callback(hObject, eventdata, handles)
global FSSettings
FSSettings.LogViewOfIntStep = get(hObject,'Value');
%------------------------------------------------------------------
function MahalInfoLossMethod_Callback(hObject, eventdata, handles)
global FSSettings
FSSettings.MahalInfoLossMethod = get(hObject,'Value');
%------------------------------------------------------------------

function NCorePatternsMenu_Callback(hObject, eventdata, handles)
global FSSettings
contents = get(hObject,'String');
FSSettings.NCorePatterns = str2num(contents{get(hObject,'Value')});

function NCorePatternsMenu_CreateFcn(hObject, eventdata, handles)
global FSSettings
contents = get(hObject,'String');
FSSettings.NCorePatterns = str2num(contents{get(hObject,'Value')});
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
                               'defaultUicontrolBackgroundColor'));
    set(hObject,'BackgroundColor','white');
end

%------------------------------------------------------------------
function NHitsMenu_Callback(hObject, eventdata, handles)
global FSSettings
contents = get(hObject,'String');
FSSettings.NHits = str2num(contents{get(hObject,'Value')});

function NHitsMenu_CreateFcn(hObject, eventdata, handles)
global FSSettings
contents = get(hObject,'String');
FSSettings.NHits = str2num(contents{get(hObject,'Value')});
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
                               'defaultUicontrolBackgroundColor'));
    set(hObject,'BackgroundColor','white');
end
%------------------------------------------------------------------

function ReturnButton_Callback(hObject, eventdata, handles)
delete(gcf)
