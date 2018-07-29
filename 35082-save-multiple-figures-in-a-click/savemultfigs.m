function varargout = savemultfigs(varargin)
% SAVEMULTFIGS is a simple GUI that allows to easily and quickly save 
% multiple figures in several formats in just a few clicks!
%
% Author: Nicolas Beuchat, EPFL/HMS
%         nicolas.beuchat [at] gmail.com
% Creation date: 2-14-2012
% Last update:   2-17-2012
%      
% TO-DO:
%   - Ask user if erase existing figures
%   - Default filename = title
%   - Clean code (remove unnecessary callbacks)
%   - Options to saveas (another window. Ex: resolution, etc.)
%   - Load figures directly from gui (to save in different formats)
%   - Problematic display in Mac OS X
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help savemultfigs

% Last Modified by GUIDE v2.5 14-Feb-2012 15:26:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @savemultfigs_OpeningFcn, ...
                   'gui_OutputFcn',  @savemultfigs_OutputFcn, ...
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


% --- Executes just before savemultfigs is made visible.
function savemultfigs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to savemultfigs (see VARARGIN)

% Choose default command line output for savemultfigs
handles.output = hObject;

% UIWAIT makes savemultfigs wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Create checkbox and edit object for each opened figure
parentPanel = findobj(hObject,'Tag','uipanelFiles');
figlist = findall(0,'Type','fig');
figlist(figlist == hObject) = [];
figlist = sort(figlist,'ascend');

% Default value of parameters
defaultfilename = 'filename';
handles.figlist     = figlist;
handles.numberFig   = length(figlist);
handles.maxFigPerPage = 16;
handles.currentPage = 1;
handles.numberPage  = ceil(handles.numberFig / handles.maxFigPerPage);

% Set some of the objects properties/values
handles.visibleFig = ones(1,handles.numberFig);
if handles.numberFig > handles.maxFigPerPage + 1
    set(findobj('Tag','sliderPageNumber'),'Value',handles.currentPage,...
        'Max',max(handles.numberPage,2),'Visible','on')
    set(findobj('Tag','textPageNumber'),'Visible','on',...
        'String',[num2str(handles.currentPage) '/' num2str(handles.numberPage)])
    
    handles.visibleFig((handles.maxFigPerPage+1):handles.numberFig) = 0;
else
    set(findobj('Tag','sliderPageNumber'),'Visible','off')
    set(findobj('Tag','textPageNumber'),'Visible','off')
end

% Chose a default filename based on name of figure
defaultfilenames=cell(length(figlist),1); 
for i=1:length(figlist) 
    if isempty(get(figlist(i),'Name')) 
        defaultfilenames{i} = [defaultfilename num2str(figlist(i))]; 
    else 
        defaultfilenames{i} = get(figlist(i),'Name'); 
    end 
end

% Display panel with figures name
for i=1:length(figlist)
    if handles.numberFig > handles.maxFigPerPage + 1
        j = mod(i-1,handles.maxFigPerPage) + 1;
    else
        j = i;
    end
    
    visible = {'off','on'};
    uicontrol(parentPanel,'Style','checkbox',...
        'String',['Figure ' num2str(figlist(i))],...
        'Position',[12 415-25*(j-1) 100 20],...
        'Value',1.0,...
        'Tag',['checkboxFigure' num2str(figlist(i))],...
        'Callback',@checkboxFigure_Callback,...
        'Visible',visible{1+handles.visibleFig(i)})
    uicontrol(parentPanel,'Style','edit',...
        'String',[defaultfilenames{i}],...
        'Position',[88 415-25*(j-1) 300 20],...
        'Tag',['editFigure' num2str(figlist(i))],...
        'Callback',@editFigure_Callback,...
        'Visible',visible{1+handles.visibleFig(i)})
end

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = savemultfigs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in checkboxFigureX.
function checkboxFigure_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxFig

function editFigure_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOutputDir as text
%        str2double(get(hObject,'String')) returns contents of editOutputDir as a double


% --- Executes on button press in checkboxFig.
function checkboxFig_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxFig


% --- Executes on button press in checkboxBmp.
function checkboxBmp_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxBmp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxBmp


% --- Executes on button press in checkboxEps.
function checkboxEps_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxEps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxEps


% --- Executes on button press in checkboxEmf.
function checkboxEmf_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxEmf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxEmf


% --- Executes on button press in checkboxJpg.
function checkboxJpg_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxJpg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxJpg


% --- Executes on button press in checkboxPcx.
function checkboxPcx_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxPcx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxPcx


% --- Executes on button press in checkboxPbm.
function checkboxPbm_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxPbm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxPbm


% --- Executes on button press in checkboxPdf.
function checkboxPdf_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxPdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxPdf


% --- Executes on button press in checkboxPgm.
function checkboxPgm_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxPgm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxPgm


% --- Executes on button press in checkboxPng.
function checkboxPng_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxPng (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxPng


% --- Executes on button press in checkboxPpm.
function checkboxPpm_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxPpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxPpm


% --- Executes on button press in checkboxTif.
function checkboxTif_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxTif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxTif



function editOutputDir_Callback(hObject, eventdata, handles)
% hObject    handle to editOutputDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOutputDir as text
%        str2double(get(hObject,'String')) returns contents of editOutputDir as a double


% --- Executes during object creation, after setting all properties.
function editOutputDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOutputDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonBrowse.
function pushbuttonBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pathname = uigetdir;
if pathname ~= 0
    set(findobj('Tag','editOutputDir'),'String',pathname);
end

% --- Executes on button press in checkboxDirType.
function checkboxDirType_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxDirType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxDirType


% --- Executes on button press in pushbuttonSave.
function pushbuttonSave_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filetype = {};
j = 0;
child = get(findobj('Tag','uipanelFigType'),'children');
for i=1:length(child)
    if get(child(i),'Value')
        j = j + 1;
        filetype{j} = get(child(i),'String');
    end
end

if isempty(filetype)
    errordlg('No format selected! Aborted.')
    return
end

pn = get(findobj('Tag','editOutputDir'),'String');
saveinsubdir = get(findobj('Tag','checkboxDirType'),'Value');
if ~isdir(pn)
    errordlg('Specified directory is not a directory!')
    return
elseif saveinsubdir
    for j=1:length(filetype)
        if ~isdir(fullfile(pn,filetype{j}))
            mkdir(fullfile(pn,filetype{j}))
        end
    end
end

% Check for double names
n = 0;
strname = cell(0);
% errstr = cell(0);
for i=1:handles.numberFig
    dosave = get(findobj('Tag',['checkboxFigure' num2str(handles.figlist(i))]),'Value');
    if dosave
        n = n+1;
        fn = get(findobj('Tag',['editFigure' num2str(handles.figlist(i))]),'String');
        strname{n} = fn;
        ind(n) = i;
%         if ~isempty(ind)
%             errstr{k} = [fn ' is already used (Fig. )'];
%         end
    end
end

errstr{1} = '';
k = 1;
for i=1:n
    indrep = find(strcmp(strname{i},strname));
    if length(indrep) > 1
        k = k+1;
        errstr{k} = [strname{i} ' was used ' num2str(length(indrep)) ' times. Renamed to ' strname{i} '_#'];
        for j=1:length(indrep)
            strname{indrep(j)} = strcat(strname{indrep(j)},'_',num2str(j));
        end
    end
end


% Save figures
for i=1:n
    for j=1:length(filetype)
        fn = strname{i};
        if saveinsubdir
            saveas(handles.figlist(ind(i)),fullfile(pn,filetype{j},fn),filetype{j})
        else
            saveas(handles.figlist(ind(i)),fullfile(pn,fn),filetype{j})
        end
    end
end
nfigsave = n;

% nfigsave = 0;
% for i=1:handles.numberFig
%     dosave = get(findobj('Tag',['checkboxFigure' num2str(handles.figlist(i))]),'Value');
%     if dosave
%         for j=1:length(filetype)
%             fn = get(findobj('Tag',['editFigure' num2str(handles.figlist(i))]),'String');
%             if saveinsubdir
%                 saveas(handles.figlist(i),fullfile(pn,filetype{j},fn),filetype{j})
%             else
%                 saveas(handles.figlist(i),fullfile(pn,fn),filetype{j})
%             end
%         end
%         nfigsave = nfigsave + 1;
%     end
% end

msgbox([{[num2str(nfigsave) ' figures saved in ' num2str(length(filetype)) ' different formats'],...
    '','(Pressing ok will not close the GUI)'},errstr]);

% --- Executes on button press in pushbuttonAbout.
function pushbuttonAbout_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonAbout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox({'Save Multiple Figure','','Created by:','Nicolas Beuchat',...
    'EPFL/HMS','','February 14th 2012','Version 1.0'},'About','help')


% --- Executes on slider movement.
function sliderPageNumber_Callback(hObject, eventdata, handles)
% hObject    handle to sliderPageNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.currentPage = get(hObject,'Value');

handles.visibleFig = zeros(1,handles.numberFig);
handles.visibleFig(((handles.currentPage-1)*handles.maxFigPerPage+1):min(handles.currentPage*handles.maxFigPerPage,handles.numberFig)) = 1;

for i=1:handles.numberFig
    j = mod(i-1,handles.maxFigPerPage) + 1;
    
    visible = {'off','on'};
    Tag1 = ['checkboxFigure' num2str(handles.figlist(i))];
    Tag2 = ['editFigure' num2str(handles.figlist(i))];
    set(findobj('Tag',Tag1),'Visible',visible{1+handles.visibleFig(i)})
    set(findobj('Tag',Tag2),'Visible',visible{1+handles.visibleFig(i)})
end

set(findobj('Tag','textPageNumber'),...
    'String',[num2str(handles.currentPage) '/' num2str(handles.numberPage)])

% Update handles structure
guidata(hObject, handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderPageNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderPageNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in checkboxAi.
function checkboxAi_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxAi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxAi


% --- Executes on button press in checkboxM.
function checkboxM_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxM
