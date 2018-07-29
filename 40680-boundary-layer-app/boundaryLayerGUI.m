function varargout = boundaryLayerGUI(varargin)
% BOUNDARYLAYERGUI MATLAB code for boundaryLayerGUI.fig
%      BOUNDARYLAYERGUI, by itself, creates a new BOUNDARYLAYERGUI or raises the existing
%      singleton*.
%
%      H = BOUNDARYLAYERGUI returns the handle to a new BOUNDARYLAYERGUI or the handle to
%      the existing singleton*.
%
%      BOUNDARYLAYERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BOUNDARYLAYERGUI.M with the given input arguments.
%
%      BOUNDARYLAYERGUI('Property','Value',...) creates a new BOUNDARYLAYERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before boundaryLayerGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to boundaryLayerGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help boundaryLayerGUI

% Last Modified by GUIDE v2.5 07-Mar-2013 17:39:09

% Copyright 2013 The MathWorks, Inc.

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @boundaryLayerGUI_OpeningFcn, ...
    'gui_OutputFcn',  @boundaryLayerGUI_OutputFcn, ...
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


% --- Executes just before boundaryLayerGUI is made visible.
function boundaryLayerGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to boundaryLayerGUI (see VARARGIN)

% Create the help button on toolbar
[X, map] = imread(fullfile(...
    matlabroot,'toolbox','matlab','icons','csh_icon.gif'));
icon = ind2rgb(X,map);
uipushtool(handles.uitoolbar1,'CData',icon,...
                 'TooltipString','Help',...
                 'ClickedCallback',@AppHelp);
% Set up the label and range of axes
H = str2double(get(handles.H,'String'));
L = str2double(get(handles.L,'String'));
set(handles.contour,'XLim',[0 L],'YLim',[0 H])
title(handles.contour,'u/U Velocity Contour')
xlabel(handles.contour,'x (m)'),ylabel(handles.contour,'y (m)')
set(handles.vector,'XLim',[0 L],'YLim',[0 H])
title(handles.vector,'Velocity Profile and Boundary Layer Thickness (0.99U)')
xlabel(handles.vector,'x (m)'),ylabel(handles.vector,'y (m)')
set(handles.strline,'XLim',[0 L],'YLim',[0 H])
title(handles.strline,'Streamlines')
xlabel(handles.strline,'x (m)'),ylabel(handles.strline,'y (m)')
annotation(gcf,'textbox',get(handles.Re,'Position'),....
    'String',{'      Re_x = \rhoUx/\mu       \delta_x ~= 5x/{\surd}Re_x'},...
    'LineStyle','none')

% Choose default command line output for boundaryLayerGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes boundaryLayerGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = boundaryLayerGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function boundarylayer(handles)
% Read in the input parameters
rho = str2double(get(handles.rho,'String')); % kg/m^3
U = str2double(get(handles.U,'String'));   % m/s
mu = str2double(get(handles.mu,'String')); % kg/(m*s)
nu = mu/rho; % m^2/s
H = str2double(get(handles.H,'String')); % m
L = str2double(get(handles.L,'String')); % m
nx = str2double(get(handles.nx,'String'));
ny = str2double(get(handles.ny,'String'));

% Initialize and preallocate
dx = L/(nx-1);
dy = H/(ny-1);
[X,Y] = meshgrid(0:dx:L,0:dy:H);
Re_L = U*L/nu;
delta_L = 5/sqrt(U/nu/L);
v = zeros(ny,nx);
u = zeros(ny,nx);

% Set boundary conditions
u(:,1) = U; % Incoming
v(:,1) = 0; % Incoming
u(1,:) = 0; % Bottom
v(1,:) = 0; % Bottom
u(ny,:) = U; % Top, free stream

% March in x direction
i = 0;
while i < nx-1
    i = i+1;
    % Determine parameters A,B,C,D in TDMA method
    for j = 2:ny-1
        if j == 2
            A(j) = 0;
            B(j) = 2*nu/dy^2 + u(j,i)/dx;
            C(j) = - nu/dy^2 + v(j,i)/2/dy;
            D(j) = u(j,i)^2/dx - (- nu/dy^2 - v(j,i)/2/dy)*u(j-1,i+1);
        elseif j > 2 && j < ny-1
            A(j) = - nu/dy^2 - v(j,i)/2/dy;
            B(j) = 2*nu/dy^2 + u(j,i)/dx;
            C(j) = - nu/dy^2 + v(j,i)/2/dy;
            D(j) = u(j,i)^2/dx ;
        elseif j == ny-1
            A(j) = - nu/dy^2 - v(j,i)/2/dy;
            B(j) = 2*nu/dy^2 + u(j,i)/dx;
            C(j) = 0;
            D(j) = u(j,i)^2/dx - (- nu/dy^2 + v(j,i)/2/dy)*u(j+1,i+1);
        end
    end
    % solve for u with TDMA method
    usol = tdma(A(2:end),B(2:end),C(2:end),D(2:end));
    u(2:ny-1,i+1) = usol;
    % solve for v(j,i+1) based on known u
    for j = 2:ny
        v(j,i+1) = v(j-1,i+1) - dy/2/dx*(u(j,i+1)-u(j,i)+u(j-1,i+1)-u(j-1,i));
    end
end
% Plotting
% Reynodes number and boundary layer thickness at x = L
annotation(gcf,'textbox',get(handles.Re,'Position'),...
    'LineStyle','none','BackgroundColor',[0.941 0.941 0.941]);
annotation(gcf,'textbox',get(handles.Re,'Position'),....
    'String',{'      Re_x = \rhoUx/\mu       \delta_x ~= 5x/{\surd}Re_x',...
             ['      Re_L = ',num2str(Re_L),'       \delta_L ~=',num2str(delta_L)]},...
    'LineStyle','none');
% u/U velocity contour
set(handles.contour,'XLim',[0 L],'YLim',[0 H],'NextPlot','replacechildren');
contourf(handles.contour,X,Y,u/U,[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.99]);
colorbar('peer',handles.contour,'SouthOutside');
% velocity vector profile
set(handles.vector,'XLim',[0 L],'YLim',[0 H],'NextPlot','replacechildren');
[~,hdelta] = contour(handles.vector,X,Y,u/U,0.99);
set(hdelta,'Color','r','LineWidth',3,'ShowText','On');hold(handles.vector,'on');
quiver(handles.vector,X,Y,u,v,'b'),hold(handles.vector,'off');
% streamlines
[strx,stry] = meshgrid(0,0:2*dy:H);
cla(handles.strline);
set(handles.strline,'XLim',[0 L],'YLim',[0 H],'NextPlot','replacechildren');
streamline(handles.strline,X,Y,u,v,strx,stry);


function X = tdma(A,B,C,D)
%TriDiagonal Matrix Algorithm (TDMA) or Thomas Algorithm
% A_i*X_(i-1) + B_i*X_i + C_i*X_(i+1) = D_i (where A_1 = 0, C_n = 0)
% A,B,C,D are input vectors. X is the solution, also a vector. 
Cp = C;
Dp = D;
n = length(A);
X = zeros(n,1);
% Performs Gaussian elimination
Cp(1) = C(1)/B(1);
Dp(1) = D(1)/B(1); 
for i = 2:n
Cp(i) = C(i)/(B(i)-Cp(i-1)*A(i));
Dp(i) = (D(i)-Dp(i-1)*A(i))/(B(i)-Cp(i-1)*A(i));
end
% Backward substitution, since X(n) is known first.
X(n) = Dp(n);
for i = n-1:-1:1
X(i) = Dp(i)-Cp(i)*X(i+1);
end

function AppHelp(varargin)
% Create help message
dlgname = 'About Boundary Layer App';
txt = {'Laminar boundary layer problem solved numerically with TDMA method';
    '';
    'Start - Start the simulation';
    'Open Code - Open a pre-written script to show the solution code';
    '';
    '* Play with flow property and geometry information to study the change';
    '  in velocity profile.';
    '* Use zoom, pan and data curser in the toolbar to interact with the';
    '  plots as usual';
    '* Equation of boundary layer thickness printed on the App is based on';
    '  analytical solution.';
    '* If Reynolds number is too high (>500,000 for flow over flat plate),';
    '  the computation is not valid, since flow becomes turbulent.';
    '';
    'Copyright 2013 The MathWorks, Inc.'};
helpdlg(txt,dlgname);

% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
boundarylayer(handles);


% --- Executes on button press in showcode.
function showcode_Callback(hObject, eventdata, handles)
% hObject    handle to showcode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open('boundaryLayerScript.m');
