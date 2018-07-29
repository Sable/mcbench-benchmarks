function varargout = scan2data(varargin)
% SCAN2DATA M-file for scan2data.fig
%      SCAN2DATA, by itself, creates a new SCAN2DATA or raises the existing
%      singleton*.
%
%      H = SCAN2DATA returns the handle to a new SCAN2DATA or the handle to
%      the existing singleton*.
%
%      SCAN2DATA('Property','Value',...) creates a new SCAN2DATA using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to scan2data_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SCAN2DATA('CALLBACK') and SCAN2DATA('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SCAN2DATA.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help scan2data

% Last Modified by GUIDE v2.5 07-Jan-2004 11:06:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @scan2data_OpeningFcn, ...
                   'gui_OutputFcn',  @scan2data_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before scan2data is made visible.
function scan2data_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for scan2data
handles.output = hObject;
handles.etape=0;
handles.finish=0;
guidata(hObject, handles);
% Barre d'outils
    load('toolbar_icon');
    ut=uitoolbar(hObject);

    
    toolbar.open = uipushtool('cdata',       toolbar_icon.open_btn, ...
                                 'parent',          ut,...
                                 'clickedcallback', 'scan2data(''OpenMenuItem_Callback'',gcbo,[],guidata(gcbo))' ,...
                                 'tooltipstring',   'Open image');

    toolbar.save = uipushtool('cdata',       toolbar_icon.save, ...
                                 'parent',          ut,...
                                 'clickedcallback', 'scan2data(''SaveMenuItem_Callback'',gcbo,[],guidata(gcbo))' ,...
                                 'tooltipstring',   'Save curve');
    toolbar.debut = uipushtool('cdata',       toolbar_icon.forward_btn, ...
                                 'Enable',    'Off',... 
                                 'parent',          ut,...
                                 'clickedcallback', 'scan2data(''start_Callback'',gcbo,[],guidata(gcbo))' ,...
                                 'tooltipstring',   'beginning of reconstitution');                             
    toolbar.undo = uipushtool('cdata',       toolbar_icon.undo_btn, ...
                                 'Enable',    'Off',... 
                                 'parent',          ut,...
                                 'clickedcallback', 'scan2data(''undo_Callback'',gcbo,[],guidata(gcbo))' ,...
                                 'tooltipstring',   'Undo'); 
    toolbar.gomme = uipushtool('cdata',       toolbar_icon.zoomXY, ...
                                  'Enable',  'Off',...
                                 'parent',          ut,...
                                 'clickedcallback', 'scan2data(''efface_Callback'',gcbo,[],guidata(gcbo))' ,...
                                 'tooltipstring',   'Eraser'); 
    toolbar.fin = uipushtool('cdata',       toolbar_icon.start_btn, ...
                                  'Enable',  'Off',...
                                 'parent',          ut,...
                                 'clickedcallback', 'scan2data(''finish_Callback'',gcbo,[],guidata(gcbo))' ,...
                                 'tooltipstring',   'build the curve');                               
                      

% Initialisation des variables

handles.taille_hor=150;
handles.taille_ver=60;
handles.length_x=10;
handles.length_y=100;
handles.echellex=[0 1];
handles.echelley=[0 1];
handles.echellex_log=0;
handles.echelley_log=0;

handles.toolbar=toolbar;
handles.v=0;
set(handles.reconstitution,'Enable','Off');

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = scan2data_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Menu servant à ouvrir le fichier image contenant la courbe
[file,rep]=uigetfile({'*.jpg','File jpeg (*.jpg)';'*.tif','File Tiff (*.tif)';...
        '*.gif','File gif (*.gif)';'*.bmp','File bmp (*.bmp)';'*','All Files'},'File name');

if isequal(file, 0)|isequal(rep,0)
   return;
end

fichier(1,:)=cat(2,rep(1,:),file(1,:));        
set(gcf,'CurrentAxes',handles.axes1)
set(handles.text11,'Visible','Off')
RGB=imread(fichier);
imshow(RGB);
zoom on;
I = rgb2gray(RGB);
threshold = graythresh(I);
% taille de l'image en pixels
handles.n=size(I,1);
handles.p=size(I,2);
% bw image en noir et blanc
bw = im2bw(I,threshold);
% complémentaire de l'image initiale
bw1=~bw;
handles.bw1=bw1;
Name=get(handles.figure1,'Name');
set(handles.figure1,'Name',[Name,' : ',file]);
set(handles.toolbar.debut,'Enable','On');
set(handles.reconstitution,'Enable','On');

% Update handles structure
guidata(hObject,handles);

% --------------------------------------------------------------------
function SaveMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to SaveMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Menu servant à enregistrer la courbe obtenue après traitement d'image
[filename, pathname] = uiputfile('*.txt', 'Save the curve');
% Si le fichier n'est pas bon ou si on souhaite annuler => retour sans erreur
% au menu précédent

if isequal(filename,0)|isequal(pathname,0)
    return
end
if (strfind(filename,'.txt')>=1)
  fichier(1,:)=cat(2,pathname(1,:),filename(1,:));
 else
  fichier(1,:)=cat(2,pathname(1,:),filename(1,:),'.txt');
 end 

 if isfield(handles,'v')
     v=handles.v
     save(fichier,'v','-ASCII','-tabs');
 else
     errordlg('No curve in memory ! ');
 end    
 

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['    Close ' get(handles.figure1,'Name') '?'],...
                     ['  Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
 if strcmp(selection,'No')
    return;
 end

 delete(handles.figure1)



function undo_Callback(hObject, eventdata, handles)
% hObject    handle to reconstitution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Elimination des grilles horizontales

% Sert à afficher l'image précédente
if handles.etape==1
 imshow(handles.bw6_prec);
 handles.bw6=handles.bw6_prec;
 
 % Update handles structure
 guidata(hObject, handles);
end


% --------------------------------------------------------------------
function reconstitution_Callback(hObject, eventdata, handles,varargin)
% hObject    handle to reconstitution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Elimination des grilles horizontales

    
% --------------------------------------------------------------------
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Reset l'affichage graphique
set(gcf,'CurrentAxes',handles.axes1)
cla;
set(gcf,'CurrentAxes',handles.axes3)
cla;
set(handles.text11,'Visible','On')
% Initialisation des variables
handles.taille_hor=150;
handles.taille_ver=60;
handles.length_x=10;
handles.length_y=100;
handles.echellex=[0 1];
handles.echelley=[0 1];
handles.echellex_log=0;
handles.echelley_log=0;
set(handles.figure1,'Name','Scan2data');
set(handles.toolbar.undo,'Enable','Off');
set(handles.toolbar.gomme,'Enable','Off');
set(handles.toolbar.fin,'Enable','Off');
set(handles.toolbar.debut,'Enable','Off');
set(handles.reconstitution,'Enable','Off');

handles.etape=0;
% Update handles structure
guidata(hObject,handles);


% --------------------------------------------------------------------
function helpMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to helpMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Lance l'aide
!help.pdf
return;

% --------------------------------------------------------------------
function rms_Callback(hObject, eventdata, handles)
% hObject    handle to rms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Calcul de la valeur RMS pour une PSD
if size(handles.v,1)>1
	x=handles.v(:,1);
	y=handles.v(:,2);
	n=size(x,1);
	q=0;
	for k=1:n-1
        q=q+(y(k)+y(k+1))/2*(x(k+1)-x(k)); 
	end
	q=sqrt(q);
    str=['RMS Value = ',num2str(q)];
	warndlg(str);
else
    errordlg('No curve in memory !');
end    


% --------------------------------------------------------------------
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   
% Débute le traitement d'image
	taille_objet_hor=handles.taille_hor;
	taille_objet_ver=handles.taille_ver;
	lengthx=handles.length_x;
	lengthy=handles.length_y;
    bw1=handles.bw1;
    question(1)=cellstr('Do you want to eliminate the horizontal grid ?');
    question(2)=cellstr(' ');
    question(3)=cellstr('WARNING : the elimination of the grid may cause a loss of information');
	buttonh = questdlg(char(question),'Horizontal grid','Yes');
	if strcmp(buttonh,'Yes')
        % on supprime les grilles horizontales 
        bw3=imtophat(bw1,strel('line',lengthx,0));
		bw4=imdilate(bw3,[strel('line',2,90)]);
        bw5=bwareaopen(bw4,taille_objet_hor);
	else
		% on supprime les objets de moins de taille_objet_hor pixels (tirets des grilles)
        bw4=bw1;
		bw5=bwareaopen(bw4,taille_objet_hor);
	end
    question(1)=cellstr('Do you want to eliminate the vertical grid ?');
    question(2)=cellstr(' ');
    question(3)=cellstr('WARNING : the elimination of the grid may cause a loss of information');
	buttonv = questdlg(char(question),'Vertical grid','Yes');
	if strcmp(buttonv,'Yes')
        % on supprime les grilles verticales
		bw21=imtophat(bw1,strel('line',lengthy,90));
		bw41=imdilate(bw21,[strel('line',2,0)]);
        bw51=bwareaopen(bw41,taille_objet_ver);
	else
        % on supprime les objets de moins de taille_objet_ver pixels (tirets des grilles)
        bw41=bw1;
		bw51=bwareaopen(bw41,taille_objet_hor);
	end
    % Addition des deux images précédentes
	bw6=bw5 & bw51;
	bw6=bwareaopen(bw6,max(taille_objet_hor,taille_objet_ver));
	clear('bw4','bw5','bw41','bw51');
	set(gcf,'CurrentAxes',handles.axes3)
	imshow(bw6)
	zoom on;
	handles.bw6=bw6;
    handles.etape=1;
	set(handles.toolbar.undo,'Enable','On');
    set(handles.toolbar.gomme,'Enable','On');
    set(handles.toolbar.fin,'Enable','On');
    % Update handles structure
	guidata(hObject, handles);

% --------------------------------------------------------------------
function finish_Callback(hObject, eventdata, handles)
% hObject    handle to finish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Termine le traitement d'image et trace la courbe obtenue
logx=handles.echellex_log;
logy=handles.echelley_log;
echellex=handles.echellex;
echelley=handles.echelley;
p=handles.p;
n=handles.n;
bw6=handles.bw6;

% On recherche les 0 dans la matrice bw6. Ils représentent l'info utile
[j i]=find(flipud(bw6));
% On supprime les multiples occurrences de 0 par colonne pour ne garder
% qu'un point représentant a priori le maximum de la courbe en ce point.
	[b,m,k] = unique(i);
	i=b;
	j=j(m);
% Traitement des échelles    
		if logy==0 & logx==0
            i= i./p.*(echellex(2)-echellex(1));
            j=(j)./n.*(echelley(2)-echelley(1));
		elseif logy==1 & logx==1
            i= echellex(1)*(echellex(2)/echellex(1)).^(i./p) ;
            j= echelley(1)*(echelley(2)/echelley(1)).^((j)./n);
		elseif logy==0 & logx==1
            i= echellex(1)*(echellex(2)/echellex(1)).^(i./p);
            j=(j)./n.*(echelley(2)-echelley(1));
		elseif logy==1 & logx==0
            i=(i)./p.*(echellex(2)-echellex(1)) ;
            j=echelley(1)*(echelley(2)/echelley(1)).^((j)./n);
		end    
  % Affichage sur une 3ème courbe      
		figure(3)
		if logy==0 & logx==0
           h=plot(i,j,'r','LineWidth',1);
		elseif logy==1 & logx==1
           h=loglog(i,j,'r','LineWidth',1);
		elseif logy==0 & logx==1
           h=semilogx(i,j,'r','LineWidth',1);
		elseif logy==1 & logx==0
           h=semilogy(i,j,'r','LineWidth',1);
		end   
		grid on;  
%         pntedit on;
%     i=get(h,'xdata')';
%     j=get(h,'ydata')';
	v=[i j];    
	handles.v=v;
    % Update handles structure
	guidata(hObject, handles);

function efface_Callback(hObject, eventdata, handles)
% hObject    handle to finish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Fonction gomme
	set(gcf,'CurrentAxes',handles.axes3); 
	bw6=handles.bw6;
	handles.bw6_prec=handles.bw6;   
	bw8=roipoly(bw6);
	bw6=bw6 & ~ bw8;
	imshow(bw6)
	zoom on;
	handles.bw6=bw6;
	% Update handles structure
	guidata(hObject, handles); 
  


% --------------------------------------------------------------------
function ParameterMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ParameterMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Scale_Callback(hObject, eventdata, handles)
% hObject    handle to Scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Scale X','Scale Y','Log scale X','Log Scale Y'};
dlg_title = 'Input for Scale';
num_lines= 1;
def     = {num2str(handles.echellex),num2str(handles.echelley),num2str(handles.echellex_log),num2str(handles.echelley_log)};
answer  = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(answer)
    return;
else
	handles.echellex=str2num(char(answer(1)));
	handles.echelley=str2num(char(answer(2)));
	handles.echellex_log=str2num(char(answer(3)));
	handles.echelley_log=str2num(char(answer(4)));
end
% Update handles structure
	guidata(hObject, handles); 

% --------------------------------------------------------------------
function graph_param_Callback(hObject, eventdata, handles)
% hObject    handle to graph_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Horizontal object size','Vertical object size','Horizontal grid length','Vertical grid length'};
dlg_title = 'Input for image processing';
num_lines= 1;
def     = {num2str(handles.taille_hor),num2str(handles.taille_ver),num2str(handles.length_x),num2str(handles.length_y)};
answer  = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(answer)
    return;
else    
	handles.taille_hor=str2num(char(answer(1)));
	handles.taille_ver=str2num(char(answer(2)));
	handles.length_x=str2num(char(answer(3)));
	handles.length_y=str2num(char(answer(4)));
end
% Update handles structure
	guidata(hObject, handles); 

