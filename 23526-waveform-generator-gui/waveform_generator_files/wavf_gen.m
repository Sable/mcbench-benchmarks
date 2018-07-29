function varargout = wavf_gen(varargin)
% WAVF_GEN M-file for wavf_gen.fig
%      WAVF_GEN, by itself, creates a new WAVF_GEN or raises the existing
%      singleton*.
%
%      H = WAVF_GEN returns the handle to a new WAVF_GEN or the handle to
%      the existing singleton*.
%
%      WAVF_GEN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WAVF_GEN.M with the given input arguments.
%
%      WAVF_GEN('Property','Value',...) creates a new WAVF_GEN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wavf_gen_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wavf_gen_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wavf_gen

% Last Modified by GUIDE v2.5 02-Apr-2009 18:21:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wavf_gen_OpeningFcn, ...
                   'gui_OutputFcn',  @wavf_gen_OutputFcn, ...
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


% --- Executes just before wavf_gen is made visible.
function wavf_gen_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to wavf_gen (see VARARGIN)

% Choose default command line output for wavf_gen
handles.output = hObject;



set(handles.axes1,'NextPlot','add');

global r xys sp iscnt p mth res hc f

f=440; % initial frequency
T=1/f;

mth='spline'; % intial method is spline

res=200; % curve resolution

iscnt=get(handles.cnt,'value'); 

r=0.015*T;

sp=1*r; % span between markers



% xys(:,1)=[0.5;
%           0.5];
% xys(:,2)=[0.5;
%           0.7];

% p(1)=create_marker(handles.axes1,xys(1,1),xys(2,1),r,[0 1 0],'a',1);
% p(2)=create_marker(handles.axes1,xys(1,2),xys(2,2),r,[1 0 0],'a',2);
nm=str2num(get(handles.nm,'string'));
p=zeros(1,nm);
%p=zeros(1,2);
xys=zeros(2,nm);
for n=1:nm
    stp=T/nm; % step
    xys(1,n)=stp/2+stp*(n-1);
    p(n)=create_marker(handles.axes1,xys(1,n),xys(2,n),r,[0 1 0],'a',n);
end

set(handles.axes1,'XLim',[0 T]);
set(handles.axes1,'YLim',[-1 1]);


% % axis equal:
% set(handles.axes1,'DataAspectRatio',[2 1 1]);
% set(handles.axes1,'DataAspectRatioMode','manual');
set(handles.axes1,'PlotBoxAspectRatio',[6 4 4]);
set(handles.axes1,'PlotBoxAspectRatioMode','manual');


for n=1:nm
    make_round(p(n),handles.axes1);
end

% get(handles.axes1,'DataAspectRatio')

% draw curve:
xl=get(handles.axes1,'Xlim');
yl=get(handles.axes1,'Ylim');
dxl=xl(2)-xl(1);
dyl=yl(2)-yl(1);


xc=xl(1):(dxl/res):xl(2);
yc=interp1(xys(1,:),xys(2,:),xc,mth,'extrap');
handles.cr=plot(xc,yc,'k-');
hc=handles.cr;
set(handles.cr,'hittest','off');

drawnow;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes wavf_gen wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = wavf_gen_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function nm_Callback(hObject, eventdata, handles)

global p xys r iscnt sp res hc mth

% delete old:
for pc=1:length(p)
    delete(p(pc));
end

ha=handles.axes1;
xl=get(ha,'Xlim');
dxl=xl(2)-xl(1);
yl=get(ha,'Ylim');
    
% create new:
nm=str2num(get(handles.nm,'string'));
p=zeros(1,nm);
%p=zeros(1,2);
xys=zeros(2,nm);
if iscnt
    stp=dxl/nm; % step
    for n=1:nm
        xys(1,n)=stp/2+stp*(n-1);
        p(n)=create_marker(handles.axes1,xys(1,n),xys(2,n),r,[0 1 0],'a',n);
    end
else
    stp=dxl/(nm-1); % step
    for n=1:nm
        xys(1,n)=stp*(n-1);
        p(n)=create_marker(handles.axes1,xys(1,n),xys(2,n),r,[0 1 0],'a',n);
    end
end
    

% set(handles.axes1,'XLim',[0 3]);
% set(handles.axes1,'YLim',[-1 1]);


% % axis equal:
% set(handles.axes1,'DataAspectRatio',[2 1 1]);
% set(handles.axes1,'DataAspectRatioMode','manual');
% set(handles.axes1,'PlotBoxAspectRatio',[6 4 4]);
% set(handles.axes1,'PlotBoxAspectRatioMode','manual');


for n=1:nm
    make_round(p(n),handles.axes1);
end



% update curve:
update_curve;


% --- Executes during object creation, after setting all properties.
function nm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cnt.
function cnt_Callback(hObject, eventdata, handles)

global iscnt xys p sp res hc mth

iscnt=get(hObject,'Value');

ha=handles.axes1;
xl=get(ha,'Xlim');
dxl=xl(2)-xl(1);
yl=get(ha,'Ylim');


if iscnt
    % if from not continius to continius
    
    xdt=get(p(end),'XData');
    
    nm=length(xys(1,:));
    if (dxl-xys(1,nm-1))>sp
        dx=xl(2)-sp-xys(1,end);
    else
        sp1=(xys(1,nm)-xys(1,nm-1))/2;
        dx=xl(2)-sp1-xys(1,end);
    end
    
    xdt=xdt+dx;
    set(p(end),'XData',xdt);
    xys(1,end)=xys(1,end)+dx;
    
else
    % if from continius to not continius
    
    xdt=get(p(1),'XData');
    dx=xl(1)-xys(1,1);
    xdt=xdt+dx;
    set(p(1),'XData',xdt);
    xys(1,1)=xl(1);
    
    xdt=get(p(end),'XData');
    dx=xl(2)-xys(1,end);
    xdt=xdt+dx;
    set(p(end),'XData',xdt);
    xys(1,end)=xl(end);
    
    
    %xys(1,end)=xl(2);
    
end


update_curve;



% --- Executes when uipanel1 is resized.
function uipanel1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)

global mth hc xys res iscnt

if get(handles.nearest,'value')
    mth='nearest';
end

if get(handles.linear,'value')
    mth='linear';
end

if get(handles.spline,'value')
    mth='spline';
end


xl=get(handles.axes1,'Xlim');
yl=get(handles.axes1,'Ylim');
dxl=xl(2)-xl(1);
dyl=yl(2)-yl(1);
update_curve;



function fr_Callback(hObject, eventdata, handles)

global f p xys r sp res mth hc iscnt

f_old=f; % old value of f
T_old=1/f_old;


frs=get(handles.fr,'string');
f=str2num(frs);
T=1/f;

xys(1,:)=T*xys(1,:)/T_old; % scretch data as T

r=0.015*T;

sp=1*r; % span between markers

set(handles.axes1,'XLim',[0 T]);
set(handles.axes1,'YLim',[-1 1]);

nm=length(xys(1,:));

for n=1:nm
    make_round(p(n),handles.axes1);
end

xl=get(handles.axes1,'Xlim');
yl=get(handles.axes1,'Ylim');
dxl=xl(2)-xl(1);
dyl=yl(2)-yl(1);
update_curve;


% --- Executes during object creation, after setting all properties.
function fr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sl_Callback(hObject, eventdata, handles)
% hObject    handle to sl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sl as text
%        str2double(get(hObject,'String')) returns contents of sl as a double


% --- Executes during object creation, after setting all properties.
function sl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pl.
function pl_Callback(hObject, eventdata, handles)

global xys iscnt mth f

prepare_signal;

sound(yc,Fs); % play


% --- Executes on button press in sv.
function sv_Callback(hObject, eventdata, handles)

[filename, pathname] = uiputfile(...
 {'*.wav'},...
 'Save sound as wav file');

filename1=[pathname filename];

global xys iscnt mth f

prepare_signal;

wavwrite(yc,Fs,filename1);


% --- Executes on selection change in prs.
function prs_Callback(hObject, eventdata, handles)
% hObject    handle to prs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns prs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from prs

global p xys r iscnt sp res hc mth f

spr=get(hObject,'Value'); % selected preset

T=1/f;

if spr~=1
    % delete old:
    for pc=1:length(p)
        delete(p(pc));
    end

    ha=handles.axes1;
    xl=get(ha,'Xlim');
    dxl=xl(2)-xl(1);
    yl=get(ha,'Ylim');
end
    
% create new:




switch spr
    case 1 % nothing
    
    case 2 % zero
        np=5; % number of points
        set(handles.nm,'string',num2str(np));
        stp=T/np;
        p=zeros(1,np);
        xys=zeros(2,np);
        for n=1:np
            xys(1,n)=(n-1)*stp;
            xys(2,n)=0;
        end

        % set continius:
        iscnt=true;
        set(handles.cnt,'value',iscnt);
        
        % set spline method:
        mth='spline';
        set(handles.nearest,'value',0);
        set(handles.linear,'value',0);
        set(handles.spline,'value',1);
    case 3 % sine
        snrs=8; % sine resolution
        set(handles.nm,'string',num2str(snrs));
        stp=T/snrs;
        p=zeros(1,snrs);
        xys=zeros(2,snrs);
        for n=1:snrs
            xys(1,n)=(n-1)*stp;
            xys(2,n)=0.9*sin(2*pi*f*xys(1,n));
        end

        % set continius:
        iscnt=true;
        set(handles.cnt,'value',iscnt);
        
        % set spline method:
        mth='spline';
        set(handles.nearest,'value',0);
        set(handles.linear,'value',0);
        set(handles.spline,'value',1);
        
    case 4 % square
        np=2; % number of points
        set(handles.nm,'string',num2str(np));
        stp=T/np;
        p=zeros(1,np);
        xys=zeros(2,np);
        for n=1:np
            xys(1,n)=(n-1)*stp+T/4;
            if n==1
                xys(2,n)=-0.9;
            else
                xys(2,n)=0.9;
            end
        end

        % set continius:
        iscnt=true;
        set(handles.cnt,'value',iscnt);
        
        % set nearest method:
        mth='nearest';
        set(handles.nearest,'value',1);
        set(handles.linear,'value',0);
        set(handles.spline,'value',0);
        
    case 5 % triangle
        np=2; % number of points
        set(handles.nm,'string',num2str(np));
        stp=T/np;
        p=zeros(1,np);
        xys=zeros(2,np);
        for n=1:np
            xys(1,n)=(n-1)*stp+T/4;
            if n==1
                xys(2,n)=-0.9;
            else
                xys(2,n)=0.9;
            end
        end

        % set continius:
        iscnt=true;
        set(handles.cnt,'value',iscnt);
        
        % set linear method:
        mth='linear';
        set(handles.nearest,'value',0);
        set(handles.linear,'value',1);
        set(handles.spline,'value',0);
        
    case 6 % sawtooth
        np=2; % number of points
        set(handles.nm,'string',num2str(np));
        stp=T/np;
        p=zeros(1,np);
        xys=zeros(2,np);
                
        xys(1,1)=0;
        xys(2,1)=-0.9;
        
        xys(1,2)=T;
        xys(2,2)=0.9;

        % set not continius:
        iscnt=false;
        set(handles.cnt,'value',iscnt);
        
        % set linear method:
        mth='linear';
        set(handles.nearest,'value',0);
        set(handles.linear,'value',1);
        set(handles.spline,'value',0);
end

if spr~=1

    nm=length(xys(1,:));
    for n=1:nm
        p(n)=create_marker(handles.axes1,xys(1,n),xys(2,n),r,[0 1 0],'a',n);
    end

    for n=1:nm
        make_round(p(n),handles.axes1); % use make_round to update circles positions
    end

    update_curve;
end

% --- Executes during object creation, after setting all properties.
function prs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in p3p.
function p3p_Callback(hObject, eventdata, handles)

global xys f res mth iscnt

plot_3p;




