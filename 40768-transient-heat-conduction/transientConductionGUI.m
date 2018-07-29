function varargout = transientConductionGUI(varargin)
% TRANSIENTCONDUCTIONGUI MATLAB code for transientConductionGUI.fig
%      TRANSIENTCONDUCTIONGUI, by itself, creates a new TRANSIENTCONDUCTIONGUI or raises the existing
%      singleton*.
%
%      H = TRANSIENTCONDUCTIONGUI returns the handle to a new TRANSIENTCONDUCTIONGUI or the handle to
%      the existing singleton*.
%
%      TRANSIENTCONDUCTIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRANSIENTCONDUCTIONGUI.M with the given input arguments.
%
%      TRANSIENTCONDUCTIONGUI('Property','Value',...) creates a new TRANSIENTCONDUCTIONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before transientConductionGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to transientConductionGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help transientConductionGUI

% Last Modified by GUIDE v2.5 12-Mar-2013 17:57:52

% Copyright 2013 The MathWorks, Inc.

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @transientConductionGUI_OpeningFcn, ...
    'gui_OutputFcn',  @transientConductionGUI_OutputFcn, ...
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


% --- Executes just before transientConductionGUI is made visible.
function transientConductionGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to transientConductionGUI (see VARARGIN)

% Create the help button on toolbar
[X, map] = imread(fullfile(...
    matlabroot,'toolbox','matlab','icons','csh_icon.gif'));
icon = ind2rgb(X,map);
uipushtool(handles.uitoolbar1,'CData',icon,...
    'TooltipString','Help',...
    'ClickedCallback',@AppHelp);

% Choose default command line output for transientConductionGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes transientConductionGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = transientConductionGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function handles = getpara(handles)
% Obtain the input to show the current Fo Number
handles.data.T_int = str2double(get(handles.T_int,'String'));
handles.data.T_top = str2double(get(handles.T_top,'String'));
handles.data.T_btm = str2double(get(handles.T_btm,'String'));
handles.data.T_lft = str2double(get(handles.T_lft,'String'));
handles.data.T_rht = str2double(get(handles.T_rht,'String'));
handles.data.L = str2double(get(handles.L,'String'));
handles.data.H = str2double(get(handles.H,'String'));
handles.data.dx = str2double(get(handles.dx,'String')); 
handles.data.dy = str2double(get(handles.dy,'String')); 
handles.data.tmax = str2double(get(handles.tmax,'String')); 
handles.data.dt = str2double(get(handles.dt,'String'));
handles.data.epsilon = str2double(get(handles.epsilon,'String'));
% Preset the thermal diffusivity of the medium chosen from list
listStrings = get(handles.listalp,'String');
domaintype = listStrings{get(handles.listalp,'Value')};
switch domaintype
    case 'Air'
        domainalp = 1.9e-5;
    case 'Water'
        domainalp = 1.43e-7;
    case 'Copper'
        domainalp = 1.11e-4;
end
handles.data.alp = domainalp;
set(handles.alp,'String',handles.data.alp);
% Compute the Fo number
handles.data.r_x = handles.data.alp*handles.data.dt/handles.data.dx^2;
handles.data.r_y = handles.data.alp*handles.data.dt/handles.data.dy^2;
fo = handles.data.r_x + handles.data.r_y;
set(handles.rx,'String',...
    sprintf('Note: Numerical stability requires Fo=alpha*dt*(1/dx^2+1/dy^2)<=1/2 \n Current Fo = %g',fo));
if fo > 1/2
    warndlg({'Numerical stability requires Fo <= 1/2';
        sprintf('Current Fo = %g',fo)},'Numerically Unstable');
end



function conduction(handles)
% Numerically solve for transient conducton problem

% check if the Stop button is pressed: if not, proceed
set(handles.stop,'UserData',0);
% obtain the input parameters
L = handles.data.L;
H = handles.data.H;
dx = handles.data.dx;
dy = handles.data.dy;
tmax = handles.data.tmax;
dt = handles.data.dt;
epsilon = handles.data.epsilon;
r_x = handles.data.r_x;
r_y = handles.data.r_y;
% create the x, y meshgrid based on dx, dy
nx = uint32(L/dx + 1);
ny = uint32(H/dy + 1);
[X,Y] = meshgrid(linspace(0,L,nx),linspace(0,H,ny));
% take the center point of the domain
ic = uint32((nx-1)/2+1);
jc = uint32((ny-1)/2+1);   
% set initial and boundary conditions
T = handles.data.T_int*ones(ny,nx);
T(:,1) = handles.data.T_lft;
T(:,end) = handles.data.T_rht;
T(1,:) = handles.data.T_btm;
T(end,:) = handles.data.T_top;
Tmin = min(min(T));
Tmax = max(max(T));
% iteration, march in time
n = 0; 
nmax = uint32(tmax/dt);
while n < nmax
    if get(handles.stop,'UserData') == 1 
        break
    end
    n = n + 1;
    T_n = T;
    for j = 2:ny-1
        for i = 2:nx-1
            T(j,i) = T_n(j,i) + r_x*(T_n(j,i+1)-2*T_n(j,i)+T_n(j,i-1))...
                + r_y*(T_n(j+1,i)-2*T_n(j,i)+T_n(j-1,i));
        end
    end
    if uint16(n/50) == n/50 % refresh the plot every 50 time steps to save time     
        % plot temperature Tcontour
        handles.fig.cont = contourf(handles.Tcontour,X,Y,T,20);
        title(handles.Tcontour,sprintf('Time = %g s',n*dt)),
        colorbar('peer',handles.Tcontour),
        xlabel(handles.Tcontour,'x (m)'),ylabel(handles.Tcontour,'y (m)')
        axis(handles.Tcontour,'equal','tight'),
        % plot temperature at center point
        handles.fig.pl = scatter(handles.Tplot,n*dt,T(jc,ic),'r.');
        xlim(handles.Tplot,[0 tmax]),xlabel(handles.Tplot,'t (s)'),ylabel(handles.Tplot,'Tcenter')
        hold(handles.Tplot,'on')
        pause(0.01)
    end
    % check for convergence
    err = max(max(abs((T-T_n))));
    if err <= epsilon
        break
    end
   
end


function AppHelp(varargin)
% Create help message
dlgname = 'About Transient Heat Conduction App';
txt = {'Transient heat conduction solved numerically, ';
    'and steady-state heat conduction solved analytically.';
    '';
    'x - total length in the x direction';
    'y - total length in the y direction';
    'dx - step size in the x direction';
    'dy - step size in the y direction';
    'alpha - thermal diffusivity,';
    '            updated automatically when medium in list is picked';
    'dt - time step size';
    '';
    'Start - start the numerical computation';
    'Stop - terminate the numerical computation';
    'Analytical Solution - open a MuPAD script that computes analytical';
    '                      solution of steady-state problem';
    '';
    '* Computation stops when convergence criterion is met';
    '  OR when total time is reached';
    '* Bottom plot monitors the CENTER point of the domain';
    '  and shows temperature change in time';
    '* Numerical instability occurs when Fo number is larger than 1/2,';
    '  modify dx, dy, dt, and alpha to insure numerical stability';
    '';
    'Copyright 2013 The MathWorks, Inc.'};
helpdlg(txt,dlgname);


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.Tplot);
cla(handles.Tcontour,'reset');
handles = getpara(handles);
conduction(handles);
guidata(hObject,handles);

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.stop,'UserData',1);


% --- Executes on selection change in listalp.
function listalp_Callback(hObject, eventdata, handles)
% hObject    handle to listalp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
getpara(handles);
% guidata(hObject,handles);

% Hints: contents = cellstr(get(hObject,'String')) returns listalp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listalp


function dt_Callback(hObject, eventdata, handles)
% hObject    handle to dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
getpara(handles);
% Hints: get(hObject,'String') returns contents of dt as text
%        str2double(get(hObject,'String')) returns contents of dt as a double



function dx_Callback(hObject, eventdata, handles)
% hObject    handle to dx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
getpara(handles);
% Hints: get(hObject,'String') returns contents of dx as text
%        str2double(get(hObject,'String')) returns contents of dx as a double



function dy_Callback(hObject, eventdata, handles)
% hObject    handle to dy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
getpara(handles);
% Hints: get(hObject,'String') returns contents of dy as text
%        str2double(get(hObject,'String')) returns contents of dy as a double


% --- Executes on button press in mupad.
function mupad_Callback(hObject, eventdata, handles)
% hObject    handle to mupad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open('ss_conduction_analytical.mn');
