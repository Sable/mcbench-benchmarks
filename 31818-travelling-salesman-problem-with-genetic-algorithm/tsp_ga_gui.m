function varargout = tsp_ga_gui(varargin)
% TSP_GA_GUI MATLAB code for tsp_ga_gui.fig
%      TSP_GA_GUI, by itself, creates a new TSP_GA_GUI or raises the existing
%      singleton*.
%
%      H = TSP_GA_GUI returns the handle to a new TSP_GA_GUI or the handle to
%      the existing singleton*.
%
%      TSP_GA_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TSP_GA_GUI.M with the given input arguments.
%
%      TSP_GA_GUI('Property','Value',...) creates a new TSP_GA_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tsp_ga_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tsp_ga_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tsp_ga_gui

% Last Modified by GUIDE v2.5 25-Feb-2011 15:15:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tsp_ga_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @tsp_ga_gui_OutputFcn, ...
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


% --- Executes just before tsp_ga_gui is made visible.
function tsp_ga_gui_OpeningFcn(hObject, eventdata, handles, varargin)
global hnds
global r nn dsm asz G
global startf



% Choose default command line output for tsp_ga_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tsp_ga_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

hnds=handles;

startf=false; % start flag

asz=10; % area size   asx x asz
nn=str2num(get(handles.nn,'string')); % number of cities
ps=str2num(get(handles.ps,'string')); % population size

r=asz*rand(2,nn); % randomly distribute cities
% r(1,:) -x coordinaties of cities
% r(2,:) -y coordinaties of cities

dsm=zeros(nn,nn); % matrix of distancies
for n1=1:nn-1
    r1=r(:,n1);
    for n2=n1+1:nn
        r2=r(:,n2);
        dr=r1-r2;
        dr2=dr'*dr;
        drl=sqrt(dr2);
        dsm(n1,n2)=drl;
        dsm(n2,n1)=drl;
    end
end

% start from random closed pathes:
G=zeros(ps,nn); % genes, G(i,:) - gene of i-path, G(i,:) is row-vector with cities number in the path
for psc=1:ps
    G(psc,:)=randperm(nn);
end

update_plots;

% --- Outputs from this function are returned to the command line.
function varargout = tsp_ga_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in randomize.
function randomize_Callback(hObject, eventdata, handles)
global r nn dsm asz

nn=str2num(get(handles.nn,'string')); % number of cities

r=asz*rand(2,nn); % randomly distribute cities
% r(1,:) -x coordinaties of cities
% r(2,:) -y coordinaties of cities

dsm=zeros(nn,nn); % matrix of distancies
for n1=1:nn-1
    r1=r(:,n1);
    for n2=n1+1:nn
        r2=r(:,n2);
        dr=r1-r2;
        dr2=dr'*dr;
        drl=sqrt(dr2);
        dsm(n1,n2)=drl;
        dsm(n2,n1)=drl;
    end
end


update_plots;


% --- Executes on button press in circle.
function circle_Callback(hObject, eventdata, handles)
global r nn dsm asz

nn=str2num(get(handles.nn,'string')); % number of cities

r=zeros(2,nn);

% circle
al1=linspace(0,2*pi,nn+1);
al=al1(1:end-1);
r(1,:)=0.5*asz+0.45*asz*cos(al);
r(2,:)=0.5*asz+0.45*asz*sin(al);

% r(1,:) -x coordinaties of cities
% r(2,:) -y coordinaties of cities

dsm=zeros(nn,nn); % matrix of distancies
for n1=1:nn-1
    r1=r(:,n1);
    for n2=n1+1:nn
        r2=r(:,n2);
        dr=r1-r2;
        dr2=dr'*dr;
        drl=sqrt(dr2);
        dsm(n1,n2)=drl;
        dsm(n2,n1)=drl;
    end
end


update_plots;



function nn_Callback(hObject, eventdata, handles)
update_plots_nn_ps;


% --- Executes during object creation, after setting all properties.
function nn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ps_Callback(hObject, eventdata, handles)
update_plots_nn_ps;

% --- Executes during object creation, after setting all properties.
function ps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ng_Callback(hObject, eventdata, handles)
% hObject    handle to ng (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ng as text
%        str2double(get(hObject,'String')) returns contents of ng as a double


% --- Executes during object creation, after setting all properties.
function ng_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ng (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in elitism.
function elitism_Callback(hObject, eventdata, handles)
% hObject    handle to elitism (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of elitism



function pm_Callback(hObject, eventdata, handles)
% hObject    handle to pm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pm as text
%        str2double(get(hObject,'String')) returns contents of pm as a double


% --- Executes during object creation, after setting all properties.
function pm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pm2_Callback(hObject, eventdata, handles)
% hObject    handle to pm2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pm2 as text
%        str2double(get(hObject,'String')) returns contents of pm2 as a double


% --- Executes during object creation, after setting all properties.
function pm2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pmf_Callback(hObject, eventdata, handles)
% hObject    handle to pmf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pmf as text
%        str2double(get(hObject,'String')) returns contents of pmf as a double


% --- Executes during object creation, after setting all properties.
function pmf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pmf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
global nn ps G r hpb ht hi dsm
global stopf startf

set(handles.nn,'Enable','off');
set(handles.ps,'Enable','off');

if ~startf
    startf=true;

    stopf=false; % stop flag

    ng=str2num(get(handles.ng,'string')); % number of cities

    pthd=zeros(ps,1); %path lengths
    p=zeros(ps,1); % probabilities
    for gc=1:ng % generations loop
        % find paths length:
        for psc=1:ps
            Gt=G(psc,:);
            pt=0; % path length summation
            for nc=1:nn-1
                pt=pt+dsm(Gt(nc),Gt(nc+1));
            end
            % last and first:
            pt=pt+dsm(Gt(nn),Gt(1));
            pthd(psc)=pt;
        end
        ipthd=1./pthd; % inverse path lengths, we want to maximize inverse path length
        p=ipthd/sum(ipthd); % probabilities

        [mbp bp]=max(p); 
        Gb=G(bp,:); % best path 

        % update best path on figure:
        if mod(gc,5)==0
            set(hpb,'Xdata',[r(1,Gb) r(1,Gb(1))],'YData',[r(2,Gb) r(2,Gb(1))]);
            set(ht,'string',['generation: ' num2str(gc)  '  best path length: ' num2str(pthd(bp))]);
            set(hi,'CData',G);
            drawnow;
        end


        % crossover:
        ii=roulette_wheel_indexes(ps,p); % genes with cities numers in ii will be put to crossover
        % length(ii)=ps, then more probability p(i) of i-gene then more
        % frequently it repeated in ii list
        Gc=G(ii,:); % genes to crossover
        Gch=zeros(ps,nn); % childrens
        for prc=1:(ps/2) % pairs counting
            i1=1+2*(prc-1);
            i2=2+2*(prc-1);
            g1=Gc(i1,:); %one gene
            g2=Gc(i2,:); %another gene
            cp=ceil((nn-1)*rand); % crossover point, random number form range [1; nn-1]


            % two childrens:
            g1ch=insert_begining(g1,g2,cp);
            g2ch=insert_begining(g2,g1,cp);
            Gch(i1,:)=g1ch;
            Gch(i2,:)=g2ch;
        end
        G=Gch; % now children


        % mutation of exchange 2 random cities:
        pm=str2num(get(handles.pm,'string'));
        for psc=1:ps
            if rand<pm
                rnp=ceil(nn*rand); % random number of sicies to permuation
                rpnn=randperm(nn);
                ctp=rpnn(1:rnp); %chose rnp random cities to permutation
                Gt=G(psc,ctp); % get this cites from the list
                Gt=Gt(randperm(rnp)); % permutate cities
                G(psc,ctp)=Gt; % % return citeis back
             end
        end

        % mutation of exchange 2 peices of path:
        pm2=str2num(get(handles.pm2,'string'));
        for psc=1:ps
            if rand<pm2
                cp=1+ceil((nn-3)*rand); % range [2 nn-2]
                G(psc,:)=[G(psc,cp+1:nn) G(psc,1:cp)];
            end
        end

        % mutation  of flip randm pece of path:
        pmf=str2num(get(handles.pmf,'string'));
        for psc=1:ps
            if rand<pmf
                n1=ceil(nn*rand);
                n2=ceil(nn*rand);
                G(psc,n1:n2)=fliplr(G(psc,n1:n2));
            end
        end



        if get(handles.elitism,'value')
            G(1,:)=Gb; % elitism
        end

        if stopf
            break;
        end



    end
    startf=false;
    stopf=true;
end

set(handles.nn,'Enable','on');
set(handles.ps,'Enable','on');




% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
global stopf
stopf=true;
