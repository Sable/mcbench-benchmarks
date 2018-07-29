function varargout = psn_3d_demo(varargin)
% PSN_3D_DEMO M-file for psn_3d_demo.fig
%      PSN_3D_DEMO, by itself, creates a new PSN_3D_DEMO or raises the existing
%      singleton*.
%
%      H = PSN_3D_DEMO returns the handle to a new PSN_3D_DEMO or the handle to
%      the existing singleton*.
%
%      PSN_3D_DEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PSN_3D_DEMO.M with the given input arguments.
%
%      PSN_3D_DEMO('Property','Value',...) creates a new PSN_3D_DEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before psn_2d_demo_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to psn_3d_demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help psn_3d_demo

% Last Modified by GUIDE v2.5 19-Apr-2010 16:53:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @psn_3d_demo_OpeningFcn, ...
                   'gui_OutputFcn',  @psn_3d_demo_OutputFcn, ...
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

% --- Executes just before psn_3d_demo is made visible.
function psn_3d_demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to psn_3d_demo (see VARARGIN)

% Choose default command line output for psn_3d_demo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using psn_3d_demo.
set(handles.listbox1,'Value',1);
set(handles.popupmenu2,'Value',2);
set(handles.listbox2,'Value',1);
if strcmp(get(hObject,'Visible'),'off')
   listbox1_Callback(hObject, eventdata, handles)
end

% UIWAIT makes psn_3d_demo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = psn_3d_demo_OutputFcn(hObject, eventdata, handles)
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
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'comet(cos(1:.01:10))', 'bar(1:10)', 'plot(membrane)', 'surf(peaks)'});

% --- Executes on selection change in popupmenu3.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

axes(handles.axes1);
cla;

INP_NX=1;        %Number of INTERIOR points in X-dirextion
   INP_NY=2;      %Number of INTERIOR points in Y-dirextion
   INP_NZ=3;

   INP_LX=4;        %X-size
   INP_LY=5;        %Y-size
   INP_LZ=6;

   INP_GRID=7;      %Grid: 0-standard, 1 - centered
   INP_METHOD=8;    %Solving method from PSN_METHODS
   INP_TOL=9;       %Tolerance
   INP_MAXSTEP=10;  %Max steps
   INP_OMEGA=11;    %Overrelaxation factor
   INP_CRD=12;      %Coord type: 0-cartesian, 1-cylindrical

   %Boundary conditions
   INP_ALPHAX0=13;
   INP_ALPHAX1=14;
   INP_BETAX0=15;
   INP_BETAX1=16;
   INP_ALPHAY0=17;
   INP_ALPHAY1=18;
   INP_BETAY0=19;
   INP_BETAY1=20;

   INP_ALPHAZ0=21;
   INP_ALPHAZ1=22;
   INP_BETAZ0=23;
   INP_BETAZ1=24;
   
   %Extended parameters
   INP_EQU=25;
   INP_DEBYE_LENGTH=26;
   INP_EPS_DEBYE=27;

cmCharge=1;
cmDipole=2
cmCircle=3;
cmCapacitor=4;
cmDam=5;
cmNiagara=6;
cmIonic=7;

cmIonic2=9;
cmCharge2=20;

% enum INPPARAM {
met = 0;;
crd=1;
grid=1;

N0=49;
Nx=N0;
Ny=N0;
Nz=N0;

% enum INPPARAM {
%global u;
global ux;
global uy;
global uz;
ux=[];
uy=[];
uz=[];

par(INP_NX)=Nx;%    INP_NX,        //Number of INTERIOR points in X-dirextion
par(INP_NY)=Ny;%    INP_NY,        //Number of INTERIOR points in Y-dirextion
par(INP_NZ)=Nz;

par(INP_LX)=1;%    INP_LX,        //X-size
par(INP_LY)=1;%    INP_LY,        //Y-size
par(INP_LZ)=1;

par(INP_GRID)=1;%    INP_GRID,      //Grid: 0-standard, 1 - centered
par(INP_METHOD)=met;%    INP_METHOD,    //Solving method from PSN_METHODS
par(INP_TOL)=1e-4;%    INP_TOL,       //Tolerance
par(INP_MAXSTEP)=4000;%    INP_MAXSTEP,   //Max steps
par(INP_OMEGA)=2-6/Nx; %INP_OMEGA 
par(INP_CRD)=0;   %CRD   //0 - cartesian, 1-cylindrical
%    //Boundary conditions
par(INP_ALPHAX0)=1;%    INP_ALPHAX0,
par(INP_ALPHAX1)=1;%    INP_ALPHAX1,
par(INP_BETAX0)=0;%    INP_BETAX0,
par(INP_BETAX1)=0;%    INP_BETAX1,

par(INP_ALPHAY0)=1; %    INP_ALPHAY0,
par(INP_ALPHAY1)=1;%    INP_ALPHAY1,
par(INP_BETAY0)=0;%    INP_BETAY0,
par(INP_BETAY1)=0;%   INP_BETAY1

par(INP_ALPHAZ0)=1; %    INP_ALPHAY0,
par(INP_ALPHAZ1)=1;%    INP_ALPHAY1,
par(INP_BETAZ0)=0;%    INP_BETAY0,
par(INP_BETAZ1)=0;%   INP_BETAY1


h=1/Nx;
v=zeros(Nx+2, Ny+2, Nz+2 );
e=ones(Nx+2,Ny+2,Nz+2);
u=zeros(Nx+2,Ny+2,Nz+2);
v1=ones(Nx+2,Ny+2,Nz+2);
u1=[];

ind = get(handles.listbox1, 'Value');
tol_ind = get(handles.popupmenu2, 'Value');
switch (tol_ind)
    case 1
       tol=1e-6; 
    case 2
       tol=1e-8; 
    case 3
       tol=1e-10; 
    case 4
       tol=1e-12;
   otherwise 
       tol=1e-6;
end    
par(INP_TOL)=tol;

xc=(Nx+3)/2;
yc=(Ny+3)/2;
zc=(Nz+3)/2;
L=10;
switch ind
    case {cmCharge, cmCharge2, cmCircle}
      if ind==cmCharge2
            v(xc,yc,zc+4)=1;
      else
          v(xc,yc,xc)=1;
      end
          if ind==cmCircle
         
         for i=1:Ny+2
            for j=1:Nx+2
              for k=1:Ny+2
                  
                  Rc=Nx*0.25;
                  r=sqrt((i-xc).^2+(j-yc).^2+(k-zc).^2);
                  if r<Rc 
                    e(i,j,k)=80;
                  else
                    e(i,j,k)=2;  
                  end;
              end;
            end;
         end;   
          end
    case cmDipole
        v(xc+1,yc,zc)=1;
        v(xc-1,yc, zc)=-1;    
    case cmCapacitor
       v(:,Nz+2,:)=1;
       par(INP_ALPHAY0)=0; %    INP_ALPHAY0,
       par(INP_ALPHAY1)=0;%    INP_ALPHAY1,
       par(INP_BETAY0)=1;%    INP_BETAY0,
       par(INP_BETAY1)=1;%   INP_BETAY1
       par(INP_ALPHAZ0)=0; %    INP_ALPHAY0,
       par(INP_ALPHAZ1)=0;%    INP_ALPHAY1,
       par(INP_BETAZ0)=1;%    INP_BETAY0,
       par(INP_BETAZ1)=1;%   INP_BETAY1
       %par(15)=0; %    INP_ALPHAY0,
       %par(16)=0;%    INP_ALPHAY1,
       %par(17)=1;%    INP_BETAY0,
       %par(18)=1;%   INP_BETAY1
     case cmDam
       v(:,Nz+2,:)=1;
       par(INP_ALPHAY0)=0; %    INP_ALPHAY0,
       par(INP_ALPHAY1)=0;%    INP_ALPHAY1,
       par(INP_BETAY0)=1;%    INP_BETAY0,
       par(INP_BETAY1)=1;%   INP_BETAY1
       par(INP_ALPHAZ0)=0; %    INP_ALPHAY0,
       par(INP_ALPHAZ1)=0;%    INP_ALPHAY1,
       par(INP_BETAZ0)=1;%    INP_BETAY0,
       par(INP_BETAZ1)=1;%   INP_BETAY1
%       v(:,Nx+2)=1;
%       par(15)=0; %    INP_ALPHAY0,
%       par(16)=0;%    INP_ALPHAY1,
%       par(17)=1;%    INP_BETAY0,
%       par(18)=-1;%   INP_BETAY1
       e(:,:,:)=80;
       for i=1:Ny+2
          for j=xc-L:xc+L
            for k=1:Nz+2
                e(i,j,k)=2;
            end    
          end; 
      end;   
     case {cmNiagara, cmIonic, cmIonic2}
       v(:,Ny+2,:)=1;
       par(INP_ALPHAY0)=0; %    INP_ALPHAY0,
       par(INP_ALPHAY1)=0;%    INP_ALPHAY1,
       par(INP_BETAY0)=1;%    INP_BETAY0,
       par(INP_BETAY1)=1;%   INP_BETAY1
       par(INP_ALPHAZ0)=0; %    INP_ALPHAY0,
       par(INP_ALPHAZ1)=0;%    INP_ALPHAY1,
       par(INP_BETAZ0)=1;%    INP_BETAY0,
       par(INP_BETAZ1)=1;%   INP_BETAY1
       R=5;
       e(:,:,:)=80;
       for j=xc-L:xc+L
          for i=1:Ny+2
           for k=1:Nz+2
                r2=(k-zc).^2+(i-yc).^2;
                if (r2>R.^2)
                   e(i,j,k)=2;
                 end;
            end;    
          end; 
      end;   

      if ind==cmIonic
         v(xc,yc,zc+2)=100; 
      end
      if ind==cmIonic2
         v(xc,yc, zc+3)=100;
         v(xc,yc+5, zc)=100;
      end
end

tic;
out_par=psn_3d_mex(par, v, u, e);
tm=toc;

ux=[];
uy=[];
uz=[];
ux(:,:)=u(xc,:,:);
uy(:,:)=u(:,yc,:);
uz(:,:)=u(:,:,zc);

ex(:,:)=1./e(xc,:,:);
ey(:,:)=1./e(:,yc,:);
ez(:,:)=1./e(:,:,zc);


s=sprintf('Iteration Num=%u',out_par(2));
set(handles.text3,'String',s);
s=sprintf('Elapsed time=%f s',tm);
set(handles.text4,'String',s);
%switch ind
%    case cmError
%      surf((u-u1));  
  %case cmConvergence
 %     semilogy(step_err);
 % otherwise
      surfl(handles.axes1,ex);
      surfl(handles.axes2,ey);
      surfl(handles.axes3,ez);
      
      surfc(handles.axes4,ux);
      surfc(handles.axes5,uy);
      surfc(handles.axes6,uz);
%end
colormap('jet');


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2
listbox1_Callback(hObject,eventdata,handles);


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
listbox1_Callback(hObject,eventdata,handles);




% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
