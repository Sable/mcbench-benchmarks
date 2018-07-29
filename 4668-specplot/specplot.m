function varargout = specplot(varargin)
% SPECPLOT M-file for specplot.fig
%      SPECPLOT, by itself, creates a new SPECPLOT or raises the existing
%      singleton*.
%
%      H = SPECPLOT returns the handle to a new SPECPLOT or the handle to
%      the existing singleton*.
%
%      SPECPLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPECPLOT.M with the given input arguments.
%
%      SPECPLOT('Property','Value',...) creates a new SPECPLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before specplot_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to specplot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help specplot

% Last Modified by GUIDE v2.5 18-Mar-2004 17:18:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @specplot_OpeningFcn, ...
    'gui_OutputFcn',  @specplot_OutputFcn, ...
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


% --- Executes just before specplot is made visible.
function specplot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to specplot (see VARARGIN)

% Choose default command line output for specplot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes specplot wait for user response (see UIRESUME)
% uiwait(handles.specplot);


% --- Outputs from this function are returned to the command line.
function varargout = specplot_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function Listscan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Listscan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in Listscan.
function Listscan_Callback(hObject, eventdata, handles)
% hObject    handle to Listscan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Listscan contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Listscan

s=get(hObject,'Value');
handles.currentscan=s;
guidata(hObject, handles);

s=s(1);
tmpcol=handles.colname;
col1=extractstr(tmpcol{s},'  ')';col1{1}=col1{1}(4:end); %to remove #L
for i=1:size(handles.data{s},2)
    col2{i}=[num2str(i) ' : ' col1{i}];
end

if ~isempty(handles.data{s})
    set(handles.message,'Visible','off')
    if get(handles.popx,'Value')>size(handles.data{s},2), set(handles.popx,'Value',size(handles.data{s},2));,end
    set(handles.popx,'String',col2,'Value',get(handles.popx,'Value'))
    if get(handles.popy,'Value')>size(handles.data{s},2), set(handles.popy,'Value',size(handles.data{s},2));,end
    set(handles.popy,'String',col2,'Value',get(handles.popy,'Value'))
    if get(handles.popmon,'Value')>size(handles.data{s},2), set(handles.popmon,'Value',size(handles.data{s},2));,end
    set(handles.popmon,'String',col2,'Value',get(handles.popmon,'Value'))
    
    plot_from_list(hObject, eventdata, handles)
    
else
    set(handles.message,'Visible','on','String','!! Scan is Empty')
end


% --- Executes during object creation, after setting all properties.
function popx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popx.
function popx_Callback(hObject, eventdata, handles)
% hObject    handle to popx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popx

plot_from_list(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popy.
function popy_Callback(hObject, eventdata, handles)
% hObject    handle to popy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popy contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popy

plot_from_list(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popmon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popmon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popmon.
function popmon_Callback(hObject, eventdata, handles)
% hObject    handle to popmon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popmon contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popmon

plot_from_list(hObject, eventdata, handles)


% --- Executes on button press in checkmon.
function checkmon_Callback(hObject, eventdata, handles)
% hObject    handle to checkmon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkmon

plot_from_list(hObject, eventdata, handles)

% --------------------------------------------------------------------
function menufile_Callback(hObject, eventdata, handles)
% hObject    handle to menufile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menufileopen_Callback(hObject, eventdata, handles)
% hObject    handle to menufileopen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[filename filepath]=uigetfile('*.*');
if filename~=0
    [scan,head,tmpcol,tmpsc]=specread3([filepath filename]);
    
    set(handles.Title,'String',['File : ' filename])
    set(handles.Listscan,'String',head,'Value',1)
    
    handles.data=scan;
    handles.colname=tmpcol;
    handles.file={filename filepath};
    handles.tmpsc=tmpsc;
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function menutool_Callback(hObject, eventdata, handles)
% hObject    handle to menutool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menutoolmotors_Callback(hObject, eventdata, handles)
% hObject    handle to menutoolmotors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%in case of multiple selection, look for the first one
handles.currentscan=handles.currentscan(1);

hm=specplot_motor_gui;
handlesm = guihandles(hm); 
[sn,sv]=specmot([handles.file{2} handles.file{1}],handles.tmpsc(handles.currentscan));
list=[];
for i=1:length(sv)
    list=strvcat(list,[sn{i} ': ' num2str(sv(i))]);
end

set(handlesm.listmotor,'String',list);
set(handlesm.textmotor,'String',['Scan # :' num2str(handles.tmpsc(handles.currentscan))]);


% --------------------------------------------------------------------
function menutoolabout_Callback(hObject, eventdata, handles)
% hObject    handle to menutoolabout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

specplot_about_gui;


% --------------------------------------------------------------------
function menufilereload_Callback(hObject, eventdata, handles)
% hObject    handle to menufilereload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[scan,head,tmpcol,tmpsc]=specread3([handles.file{2} handles.file{1}]);
set(handles.Listscan,'String',head,'Value',handles.currentscan)

handles.data=scan;
handles.colname=tmpcol;
handles.tmpsc=tmpsc;
guidata(hObject, handles);

plot_from_list(hObject, eventdata, handles)
drawnow

% --------------------------------------------------------------------
function Title_Callback(hObject, eventdata, handles)
% hObject    handle to Title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Title as text
%        str2double(get(hObject,'String')) returns contents of Title as a double


% --------------------------------------------------------------------
function menutoolextract_Callback(hObject, eventdata, handles)
% hObject    handle to menutoolextract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.currentscan;
for i=1:length(s);
    assignin('base',['scan_' num2str(s(i))],handles.data{s(i)})
    fprintf('current scan saved to ''%s'' \n',['scan_' num2str(s(i))]);
end

% --------------------------------------------------------------------
function plot_from_list(hObject, eventdata, handles)
% hObject    handle to menutoolextract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla
s=handles.currentscan;
colormap('lines');map=colormap;
for i=1:length(s)
    if length(s)>1,hold on,end
    if get(handles.checkmon,'Value')==0
        h=plot(handles.data{s(i)}(:,get(handles.popx,'Value')),handles.data{s(i)}(:,get(handles.popy,'Value')));
        set(h,'Color',map(1+mod((i-1)*8,64),:));
        zoom on
    else
        h=plot(handles.data{s(i)}(:,get(handles.popx,'Value')),handles.data{s(i)}(:,get(handles.popy,'Value'))./handles.data{s(i)}(:,get(handles.popmon,'Value')));
        set(h,'Color',map(1+mod((i-1)*8,64),:));
        zoom on
    end
end
hold off

if get(handles.radio_lin,'Value')==1,set(gca,'Yscale','lin'),else,set(gca,'Yscale','log');end


% --------------------------------------------------------------------
function axes_plot_style_Callback(hObject, eventdata, handles)
% hObject    handle to axes_plot_style (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function axes_plot_style_linear_Callback(hObject, eventdata, handles)
% hObject    handle to axes_plot_style_linear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(gca,'YScale','lin')

% --------------------------------------------------------------------
function axes_plot_style_log_Callback(hObject, eventdata, handles)
% hObject    handle to axes_plot_style_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(gca,'YScale','log')


% --- Executes on button press in radio_log.
function radio_log_Callback(hObject, eventdata, handles)
% hObject    handle to radio_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_log
set(handles.radio_log,'Value',1)
set(handles.radio_lin,'Value',0)
set(gca,'YScale','log')


% --- Executes on button press in radio_lin.
function radio_lin_Callback(hObject, eventdata, handles)
% hObject    handle to radio_lin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_lin
set(handles.radio_lin,'Value',1)
set(handles.radio_log,'Value',0)
set(gca,'YScale','lin')


%----------Extra functions
function word=extractstr(s,separator)

skip=length(separator);
count=0;

lf=findstr(s,separator);
lf=[1-skip lf length(s)+1];

for i=1:length(lf)-1
   tmp=s(lf(i)+skip:lf(i+1)-1);
   if ~isempty(tmp),count=count+1;word{count}=tmp;,end
end

%------------------------------------------
%-------------SpecRead 3 -------------------
%-------------------------------------------
function [data,com,colname,scan]=specread3(varargin)
%
%function [data,com]=specread(file,[scan])
%
%Read scans in SPEC files and save them into MATLAB cell.
%This macro is optimized for specplot
%Save scans headers in coms cells.
%
%Copyrigth Rueff 2000

tic
filename=varargin{1};

fid=fopen(filename);
F=fread(fid);FS=char(F');
fposS=findstr(FS,'#S');
fposL=findstr(FS,'#L');


%----in case there is no #L line (shit happens)---
if length(fposL)<length(fposS)
    for i=1:length(fposL)
        if ~(fposL(i)>fposS(i) & fposL(i)<fposS(i+1))
            fposL=[fposL(1:i-1) 0 fposL(i:end)]; %--add a 0 to fposL
        end
    end 
end
%------------------------------------------------

scan=[];

fprintf('Found %i scans ',length(fposS))
fposS=[fposS length(FS)];

%---- Read through data file ---------------------------------------
for k=1:length(fposS)-1
    
    %---- Get first column headers ----
    
    fseek(fid,fposS(k)-1,'bof');
    com{k}=fgetl(fid);	                 
    scan=[scan str2num(com{k}(3:6))];
    
    %----...and the counters names #L ----
    
    if fposL(k)~=0
        
        fseek(fid,fposL(k)-1,-1);
        colname{k}=fgetl(fid);
        % fgetl(fid);%Sp-8 special
        % fgetl(fid);%Sp-8 special
        
        %-----Read data -------------------
        
        st=ftell(fid);ed=fposS(k+1)-1;
        if st>ed
            data{k}=[];
        else
            Ftmp=char(fread(fid,ed-st)');
            fposC=findstr(Ftmp,'#');
            
            if isempty(fposC) 
                data{k}=str2num(Ftmp);          
            else
                fposC=[fposC length(Ftmp)];
                %--read first block
                data{k}=str2num(Ftmp(1:fposC-1));
                %--read the others if any
                for l=1:length(fposC)-1
                    fseek(fid,fposC(l)+st-1,-1);
                    fgetl(fid);
                    rest=ftell(fid)-st;
                    data{k}=[data{k};str2num(Ftmp(rest+1:fposC(l+1)-1))];
                end
            end
        end
    else
        data{k}=[];
        
    end
    %-----------------------------
    
    frewind(fid)
end

fclose(fid);

%---Renumbered scan in case of doublons---
db=unique(scan);
for i=1:length(db)
    fdb=find(scan==db(i));
    for j=1:length(fdb),scan(fdb(j))=scan(fdb(j))+j/10;end %add .1, .2, ...
end

et=toc;
fprintf(' in %f sec\n',et);

%-------------------------------------------
%------------SpecMot------------------------
%--------------------------------------------
function [motname,motval]=specmot(filename,scan);

fid=fopen(filename);
F=fread(fid);FS=char(F');
fposS1=findstr(FS,['#S 1']);
fposSc=findstr(FS,['#S ' num2str(floor(scan)) ' ']);
ranksc=round((scan-floor(scan))*10);
fposSc=fposSc(ranksc);


%---get motor names-----------------------------
fposO=findstr(FS,'#O0');
motname=[];
fseek(fid,fposO(1)-1,-1);
while ftell(fid)<min([fposS1])-1
    tmpmot=fgetl(fid);
    motname=[motname tmpmot(4:end) ' '];
end
motname=extractstr(motname,'  ');

%---get motor values-----------------------------
fseek(fid,fposSc-1,-1);
tmppos=ftell(fid);

fposP0=findstr(FS(tmppos:end),'#P0')+tmppos-1;
fposN=findstr(FS(tmppos:end),'#N')+tmppos-1;

motval=[];
fseek(fid,fposP0-1,-1);
counter=0;
while ftell(fid)<fposN-1
    tmpmot=fgetl(fid);
    if strmatch('#P',tmpmot) 
        counter=counter+1;
        if counter<10
            motval=[motval tmpmot(4:end) ' '];
        else 
            motval=[motval tmpmot(5:end) ' '];
        end
    end
end

motval=extractstr(motval,' ');
tmpval=[];
for i=1:length(motval);tmpval=[tmpval str2num(motval{i})];,end
motval=tmpval;

