function varargout = utemization(varargin)
% utemization M-file for utemization.fig
%      Transformation form Geographic to UTM coordinates
%      

% Inicialization
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @geo2utm_OpeningFcn, ...
                   'gui_OutputFcn',  @geo2utm_OutputFcn, ...
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
% End initialization 


function geo2utm_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);

function varargout = geo2utm_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function edarchin_Callback(hObject, eventdata, handles)

function edarchin_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edarchsal_Callback(hObject, eventdata, handles)

function edarchsal_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% *************************************************************************
function pbconvert_Callback(hObject, eventdata, handles)
% *************************************************************************
% Name of the input file:
filiin=get(handles.edarchin,'string');

% Check the presence of the inputfile
hayarch=dir(filiin);
%hayf=strcmpi(hayarch(1).name,filiin);
hyf=length(hayarch);

if hyf==0
    msgbox('The input file was not found','Error')
elseif hyf==1
    % outputfile
    salida=get(handles.edarchsal,'string');
    % Ellipsoid option
    idelips=opelipso(handles);
    % option for plot transformation
    oppltt=get(handles.chplres,'value');
    
    % ---- Read input coordinates:
    Aux=load(filiin);
    longitud=Aux(:,1);              %  longitude      latitude      data(eg. h)
    latitud=Aux(:,2);               %  longitude and latitude must be in [deg]
    if size(Aux,2)>2
        ndatos=size(Aux,2)-2;
        opdat = questdlg('Extra data detected, write them to the output file?','Extra data','yes','no','yes');
        if strcmpi(opdat,'yes')==1
            opz=1;
        else 
            opz=0;
        end
    elseif size(Aux,2)<=2
        opz=0;
    end
    if opz==1                       %  expressed in decimal notation  (eg. 12.50 YES, 12º30'0'' NO)
        dato=Aux(:,3:3+ndatos-1);       %  with signs, no letters (eg. -12.5 YES, 12.5W NO)
    end
    np=length(longitud);            
    
    [x,y,nel]=calcoord(longitud,latitud,np,idelips); % Transformation routine
      
    % ---- Output to a file
    if opz==0
        Baux=[x y];
    elseif opz==1
        Baux=[x y dato];
    end
    %dlmwrite(salida,Baux,'delimiter','\t','precision','%12.2f');
    save(salida,'Baux','-ascii')
    
    % ---- Plot of the transformation (optional)
    if oppltt==1
        figure
        subplot(2,2,1);plot(longitud,x,'.k');title(strcat('Longitude Vs x, ellipsoid:',nel));xlabel('Longitude [º]');ylabel('x [m]');
        subplot(2,2,2);plot(latitud,y,'.k');title(strcat('Latitude Vs y, ellipsoid:',nel));xlabel('Latitude [º]');ylabel('y [m]');
        subplot(2,2,3);plot(longitud,latitud,'.b');title('Original points');xlabel('Longitude [º]');ylabel('Latitude [º]'); axis equal
        subplot(2,2,4);plot(x,y,'.b');title('Transformed points');xlabel('x [m]');ylabel('y [m]'); axis equal
    end
end


function chz_Callback(hObject, eventdata, handles)

% *************************************************************************
function pbfilein_Callback(hObject, eventdata, handles)
% *************************************************************************

[fileinname,ruta]=uigetfile({'*.txt';'*.dat'},'Input file: Geographic coordinates');
dirac=[pwd '\'];
tins=strcmpi(ruta,dirac); % Check if the file is in the current directory
if tins==0
    filennw=[ruta fileinname];
elseif tins==1
    filennw=fileinname;
end
set(handles.edarchin,'string',filennw);

function edsplong_Callback(hObject, eventdata, handles)

function edsplong_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edsplat_Callback(hObject, eventdata, handles)

function edsplat_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edspx_Callback(hObject, eventdata, handles)

function edspx_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% *************************************************************************
function pushbutton3_Callback(hObject, eventdata, handles)
% *************************************************************************

% Ellipsoid
idelips=opelipso(handles);
longitud1p=str2num(get(handles.edsplong,'string'));
latitud1p=str2num(get(handles.edsplat,'string'));
[x1p,y1p,nel]=calcoord(longitud1p,latitud1p,1,idelips); % Transformation routine

set(handles.edspx,'string',num2str(x1p))
set(handles.edspy,'string',num2str(y1p))

function chplres_Callback(hObject, eventdata, handles)

function edspy_Callback(hObject, eventdata, handles)

function edspy_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% *************************************************************************
function pushbutton4_Callback(hObject, eventdata, handles)
% *************************************************************************

credtx=['            Coded by Alberto Avila Armella            ';...
        '                                                      ';...
        '    With the collaboration of Gabriel Ruiz Martinez   ';...
        '                                                      ';...
        '            Method from www.gabrielortiz.com          ';...
        '                                                      ';...
        '  Please report errors and suggest improvements to    ';...
        '               aavilaa@correo.ugr.es                  '];
helpdlg(credtx,'Credits')

% *************************************************************************
function [x,y,nel]=calcoord(longitud,latitud,np,idelips); % Transformation routine
% *************************************************************************

% ---- Calculos of the ellipsoid parameters
[a b nel e ep ep2 c alfa]=elipsoideg(idelips); % Parametros of the ellipsoid chosen
lonm=mean(longitud);latm=mean(latitud); % mean points
L=longitud*pi/180;fi=latitud*pi/180;    % Angles in radians
huso=fix(lonm/6+31); % huso calculus
L0=huso*6-183;          % Central meridian of the huso
dL= L-(L0*pi/180);   % angular dinstance of each point to the central meridian
% ---- Calculus of the form parameters, Coticchia-Surace
A=cos(fi).*sin(dL);
xi=0.5*log((1+A)./(1-A));
eta=atan(tan(fi)./cos(dL))-fi;
v=0.9996*c./sqrt(1+ep2*(cos(fi)).^2);
z=ep2*xi.^2.*(cos(fi)).^2/2;
A1=sin(2*fi);
A2=A1.*(cos(fi)).^2;
J2=fi+A1/2;
J4=(3*J2+A2)/4;
J6=(5*J4+A2.*(cos(fi)).^2)/3;
alfa2=3*ep2/4;
beta=5*alfa2^2/3;
gama=35*alfa2^3/27;
Bfi=0.9996*c*(fi-alfa2*J2+beta*J4-gama*J6);
% ---- Final calculus of the UTM coordinates:
x=xi.*v.*(1+z/3)+500000;
if latm<0
    sur=10000000;
else
    sur=0;
end
y=eta.*v.*(1+z)+Bfi+sur;

% *************************************************************************    
function [a b nel e ep ep2 c alfa]=elipsoideg(idelips)   % Ellipsoid parameters
% *************************************************************************

if idelips==1
    a=6377563.396000;b=6356256.910000;nel='Airy (1830)';
elseif idelips==2
    a=6377340.189000;b=6356034.447900;nel='Airy modified (1965)';
elseif idelips==3
    a=6377397.155000;b=6356078.962840;nel='Bessel (1841)';
elseif idelips==4
    a=6378206.400000;b=6356583.800000;nel='Clarke (1866)';
elseif idelips==5
    a=6378249.145000;b=6356514.869550;nel='Clarke (1880)';
elseif idelips==6
    a=6378166.000000;b=6356784.280000;nel='Fischer (1960)';
elseif idelips==7
    a=6378150.000000;b=6356768.330000;nel='Fischer (1968)';
elseif idelips==8
    a=6378137.000000;b=6356752.314140;nel='GRS80 (1980)';
elseif idelips==9
    a=6378388.000000;b=6356911.946130;nel='Hayford (1909)';
elseif idelips==10
    a=6378200.000000;b=6356818.170000;nel='Helmert (1906)';
elseif idelips==11
    a=6378270.000000;b=6356794.343479;nel='Hough (1960)';
elseif idelips==12
    a=6378388.000000;b=6356911.946130;nel='International (1909)';
elseif idelips==13
    a=6378388.000000;b=6356911.946130;nel='International (1924)';
elseif idelips==14
    a=6378245.000000;b=6356863.018800;nel='Krasovsky (1940)';
elseif idelips==15
    a=6378166.000000;b=6356784.283666;nel='Mercury (1960)';
elseif idelips==16
    a=6378150.000000;b=6356768.337303;nel='Mercury modified (1968)';
elseif idelips==17
    a=6378157.500000;b=6356772.200000;nel='Nuevo International (1967)';
elseif idelips==18
    a=6378160.000000;b=6356774.720000;nel='South American (1969)';
elseif idelips==19
    a=6376896.000000;b=6355834.846700;nel='Walbeck (1817)';
elseif idelips==20
    a=6378145.000000;b=6356759.769356;nel='WGS66 (1966)';
elseif idelips==21
    a=6378135.000000;b=6356750.519915;nel='WGS72 (1972)';
elseif idelips==22
    a=6378137.000000;b=6356752.314245;nel='WGS84 (1984)';
end

e=sqrt(a^2-b^2)/a;  % Excentricity
ep=sqrt(a^2-b^2)/b; % Second excentricity
ep2=ep^2;
c=a^2/b;            % Polar curvature ratio
alfa=(a-b)/a;       % plain

% *************************************************************************
function idelips=opelipso(handles)    % Read option chosen for the ellipsoid
% *************************************************************************

if get(handles.rb1,'value')==1; idelips=1;
elseif get(handles.rb2,'value')==1; idelips=2;
elseif get(handles.rb3,'value')==1; idelips=3;
elseif get(handles.rb4,'value')==1; idelips=4;
elseif get(handles.rb5,'value')==1; idelips=5;
elseif get(handles.rb6,'value')==1; idelips=6;
elseif get(handles.rb7,'value')==1; idelips=7;
elseif get(handles.rb8,'value')==1; idelips=8;
elseif get(handles.rb9,'value')==1; idelips=9;
elseif get(handles.rb10,'value')==1; idelips=10;
elseif get(handles.rb11,'value')==1; idelips=11;
elseif get(handles.rb12,'value')==1; idelips=12;
elseif get(handles.rb13,'value')==1; idelips=13;
elseif get(handles.rb14,'value')==1; idelips=14;
elseif get(handles.rb15,'value')==1; idelips=15;
elseif get(handles.rb16,'value')==1; idelips=16;
elseif get(handles.rb17,'value')==1; idelips=17;
elseif get(handles.rb18,'value')==1; idelips=18;
elseif get(handles.rb19,'value')==1; idelips=19;
elseif get(handles.rb20,'value')==1; idelips=20;
elseif get(handles.rb21,'value')==1; idelips=21;
elseif get(handles.rb22,'value')==1; idelips=22;
end    

% *************************************************************************
function pbfileout_Callback(hObject, eventdata, handles)
% *************************************************************************

[fileout,rutaout]=uiputfile({'*.txt';'*.dat'},'Output file: UTM coordinates','outUTM.txt');
diraqui=[pwd '\'];
tinso=strcmpi(rutaout,diraqui); % Check if the file is in the current directory
if tinso==0
    filennwout=[rutaout fileout];
elseif tinso==1
    filennwout=fileout;
end
set(handles.edarchsal,'string',filennwout);

