function varargout = inviscidChannelGUI(varargin)
% INVISCIDCHANNELGUI MATLAB code for inviscidChannelGUI.fig
%      INVISCIDCHANNELGUI, by itself, creates a new INVISCIDCHANNELGUI or raises the existing
%      singleton*.
%
%      H = INVISCIDCHANNELGUI returns the handle to a new INVISCIDCHANNELGUI or the handle to
%      the existing singleton*.
%
%      INVISCIDCHANNELGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INVISCIDCHANNELGUI.M with the given input arguments.
%
%      INVISCIDCHANNELGUI('Property','Value',...) creates a new INVISCIDCHANNELGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before inviscidChannelGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to inviscidChannelGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help inviscidChannelGUI

% Last Modified by GUIDE v2.5 20-Feb-2013 10:37:02

% Copyright 2013 The MathWorks, Inc.

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @inviscidChannelGUI_OpeningFcn, ...
    'gui_OutputFcn',  @inviscidChannelGUI_OutputFcn, ...
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


% --- Executes just before inviscidChannelGUI is made visible.
function inviscidChannelGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to inviscidChannelGUI (see VARARGIN)

% Initialize the GUI layout
sketchplot(gcf);
set(get(handles.plotstreamline,'XLabel'),'String','x (m)')
set(get(handles.plotstreamline,'YLabel'),'String','y (m)')
set(get(handles.plotstreamline,'Title'),'String','Normalized Stream Function \Psi')
set(get(handles.plotvector,'XLabel'),'String','x (m)')
set(get(handles.plotvector,'YLabel'),'String','y (m)')
set(get(handles.plotvector,'Title'),'String','Velocity Profile')
% Create the help button on toolbar
[X, map] = imread(fullfile(...
    matlabroot,'toolbox','matlab','icons','csh_icon.gif'));
icon = ind2rgb(X,map);
uipushtool(handles.uitoolbar1,'CData',icon,...
    'TooltipString','Help',...
    'ClickedCallback',@AppHelp);


% Choose default command line output for inviscidChannelGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes inviscidChannelGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = inviscidChannelGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inviscidchannel(handles);

function handles = getpara(handles)
% Get user input parameters from the GUI
handles.para.D1 = str2double(get(handles.D1,'String'));
handles.para.D2 = str2double(get(handles.D2,'String'));
handles.para.L1 = str2double(get(handles.L1,'String'));
handles.para.L2 = str2double(get(handles.L2,'String'));
handles.para.U1 = str2double(get(handles.U1,'String'));
handles.para.nx = str2double(get(handles.nx,'String'));
handles.para.ny = str2double(get(handles.ny,'String'));
handles.para.nmax = str2double(get(handles.nmax,'String'));
cla(handles.plotstreamline),cla(handles.plotvector),
axis([handles.plotstreamline handles.plotvector], [0 handles.para.L1+handles.para.L2 0 max(handles.para.D1,handles.para.D2)]),
% Draw the channel shape according to input
if handles.para.D1 < handles.para.D2 % converging channel
    cornerposition = [0 handles.para.D1 handles.para.L1 handles.para.D2-handles.para.D1];
elseif handles.para.D1 > handles.para.D2 % diverging channel
    cornerposition = [handles.para.L1 handles.para.D2 handles.para.L2 handles.para.D1-handles.para.D2];
else
    cornerposition = [0 handles.para.D1 1 1]; % straight channel
end
rectangle('Parent',handles.plotstreamline,'Position',cornerposition,'FaceColor',[0.94 0.94 0.94])
rectangle('Parent',handles.plotvector,'Position',cornerposition,'FaceColor',[0.94 0.94 0.94])


function inviscidchannel(handles)
%% Initialization
% get input parameters
handles = getpara(handles);
% store input parameters with shorter names
D1 = handles.para.D1;
D2 = handles.para.D2;
L1 = handles.para.L1;
L2 = handles.para.L2;
U1 = handles.para.U1;
nx = handles.para.nx;
ny = handles.para.ny;
nmax = handles.para.nmax;
% compute grid length
dx = (L1+L2)/(nx-1);
dy = max(D1,D2)/(ny-1);
% nondimensionalization
dX = dx/D1;
dY = dy/D1;
PSI = ones(ny,nx);
%% Boundary conditions
PSI(1,:) = 0; % bottom
PSI(floor(D1/dy+1),1:floor(L1/dx+1)) = 1; % left part of top
PSI(floor(D2/dy+1),floor(L1/dx+1):nx) = 1; % right part of top
for j = 1:floor(D1/dy+1)
    PSI(j,1) = (j-1)*dY; % inlet
end
for j = 1:floor(D2/dy+1)
    PSI(j,nx) = D1/D2*(j-1)*dY; % outlet
end
%% Iteration to solve for stream function PSI
err = 1e-6; % convergence criteria
n = 0;
while n < nmax
    n = n + 1;
    tempPSI = PSI;
    % left part of the channel
    for i = 2:floor(L1/dx+1)
        for j = 2:(floor(D1/dy+1)-1)
            PSI(j,i) = 1/(2/dX^2+2/dY^2)*((tempPSI(j,i+1)+PSI(j,i-1))/dX^2+(tempPSI(j+1,i)+PSI(j-1,i))/dY^2);
        end
    end
    % right part of the channel
    for i = floor(L1/dx+1):nx-1
        for j = 2:(floor(D2/dy+1)-1)
            PSI(j,i) = 1/(2/dX^2+2/dY^2)*((tempPSI(j,i+1)+PSI(j,i-1))/dX^2+(tempPSI(j+1,i)+PSI(j-1,i))/dY^2);
        end
    end
    % checking for convergence
    if max(max(abs(PSI-tempPSI))) <= err
        break
    end
end
%% Prompt convergence result in a message box
if n < nmax
    helpdlg({'Converged.';sprintf('Total number of iterations: %g\n',n)},...
        'Converged');
else
    warndlg({'NOT Converged!';sprintf('Change n_x, n_y, n_max or convergence criteria.\n')},...
        'NOT Converged');
end
%% Solve for velocity u and v from stream function
u = zeros(ny,nx);
v = zeros(ny,nx);
psi = PSI*U1*D1; % dimentionalization
for j = 2:ny-1
    u(j,:) = (psi(j+1,:)-psi(j-1,:))/2/dy;
end
for i = 2:nx-1
    v(:,i) = -(psi(:,i+1)-psi(:,i-1))/2/dx;
end
% velocity at boundaries (inviscid, so slip occurs)
u(1,:) = u(2,:);
u(ny,:) = u(ny-1,:);
v(:,1) = v(:,2);
v(:,nx) = v(:,nx-1);
%% Plot results
[X, Y] = meshgrid(0:dx:(L1+L2),0:dy:max(D1,D2));
% contour plot of stream function
contourf(handles.plotstreamline,X,Y,PSI),colormap(handles.plotstreamline,'jet')
% vector plot of velocity u and v
quiver(handles.plotvector,X,Y,u,v),
axis([handles.plotstreamline handles.plotvector],[0 L1+L2 0 max(D1,D2)]),
% plot the shape of the channel based on input parameters
if D1 < D2
    cornerposition = [0 D1 L1 D2-D1];
elseif D1 > D2
    cornerposition = [L1 D2 L2 D1-D2];
else
    cornerposition = [0 D1 1 1];
end
rectangle('Parent',handles.plotstreamline,'Position',cornerposition,'FaceColor',[0.94 0.94 0.94])
rectangle('Parent',handles.plotvector,'Position',cornerposition,'FaceColor',[0.94 0.94 0.94])
set(get(handles.plotstreamline,'XLabel'),'String','x (m)')
set(get(handles.plotstreamline,'YLabel'),'String','y (m)')
set(get(handles.plotstreamline,'Title'),'String','Normalized Stream Function \Psi')
set(get(handles.plotvector,'XLabel'),'String','x (m)')
set(get(handles.plotvector,'YLabel'),'String','y (m)')
set(get(handles.plotvector,'Title'),'String','Velocity Profile')

function sketchplot(h)
%Sketch the plot of the channel to show geometric parameters
% and governing equations. You can learn how to draw sketches
% programmatically and write LaTeX. Don't worry about it otherwise,
% since it has nothing to do with computation.

% Create doublearrow
d1 = annotation(h,'doublearrow',[0.06 0.06],...
    [0.6 0.8]);

% Create doublearrow
l1 = annotation(h,'doublearrow',[0.06 0.15],...
    [0.6 0.6]);

% Create doublearrow
l2 = annotation(h,'doublearrow',[0.15 0.3],...
    [0.6 0.6]);

% Create doublearrow
d2 = annotation(h,'doublearrow',[0.3 0.3],...
    [0.7 0.6]);

% Create arrow U
annotation(h,'arrow',[0.02 0.06],...
    [0.7 0.7],...
    'HeadStyle','Plain',...
    'HeadWidth',5);

% Create textbox U
annotation(h,'textbox',...
    [0.02 0.67 0.03 0.07],...
    'String',{'U'},...
    'FitBoxToText','off',...
    'LineStyle','none');


% Create textbox
annotation(h,'textbox',...
    [0.06 0.65 0.03 0.07],...
    'String',{'D1'},...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(h,'textbox',...
    [0.1 0.58 0.03 0.07],...
    'String',{'L1'},...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(h,'textbox',...
    [0.22 0.58 0.03 0.07],...
    'String',{'L2'},...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(h,'textbox',...
    [0.25 0.61 0.03 0.07],...
    'String',{'D2'},...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create channel
annotation(h,'line',...
    [0.05 0.15],[0.8 0.8],...
    'LineWidth',2);

% Create channel
annotation(h,'line',...
    [0.15 0.31],[0.7 0.7],...
    'LineWidth',2);

% Create channel
annotation(h,'line',...
    [0.15 0.15],[0.7 0.8],...
    'LineWidth',2);

% Create channel
annotation(h,'line',...
    [0.05 0.31],[0.58 0.58],...
    'LineWidth',2);

% Create textbox equations
annotation(h,'textbox',[0.32 0.73 0.03 0.07],...
    'String',{'\partial^2\psi/\partialx^2 + \partial^2\psi/\partialy^2 = 0','','u = \partial\psi/\partialy','', 'v = -\partial\psi/\partialx'},...
    'FitBoxToText','on',...
    'LineStyle','none');

function AppHelp(varargin)
% Create help message
dlgname = 'About Inviscid Channel App';
txt = {'Inviscid flow in a channel (Laplace equation of stream function)';
    'solved with explicit method';
    '';
    'Start - Start the simulation';
    'Solution Code - Open a pre-written script to show the solution code';
    '';
    '* Try D1 > D2, D1 < D2 or D1 = D2.';
    '* Use zoom, pan and data curser in the toolbar to interact with the';
    '  plots as usual';
    '* If result does not  converge, try:';
    '       a) increasing n_max (total number of iterations)';
    '       b) decreasing n_x, n_y (number of grids in each direction)';
    '';
    'Copyright 2013 The MathWorks, Inc.'};
helpdlg(txt,dlgname);

function D1_Callback(hObject, eventdata, handles)
% hObject    handle to D1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
getpara(handles);
% Hints: get(hObject,'String') returns contents of D1 as text
%        str2double(get(hObject,'String')) returns contents of D1 as a double



function D2_Callback(hObject, eventdata, handles)
% hObject    handle to D2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
getpara(handles);
% Hints: get(hObject,'String') returns contents of D2 as text
%        str2double(get(hObject,'String')) returns contents of D2 as a double



function L1_Callback(hObject, eventdata, handles)
% hObject    handle to L1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
getpara(handles);
% Hints: get(hObject,'String') returns contents of L1 as text
%        str2double(get(hObject,'String')) returns contents of L1 as a double



function L2_Callback(hObject, eventdata, handles)
% hObject    handle to L2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
getpara(handles);
% Hints: get(hObject,'String') returns contents of L2 as text
%        str2double(get(hObject,'String')) returns contents of L2 as a double


% --- Executes on button press in solution.
function solution_Callback(hObject, eventdata, handles)
% hObject    handle to solution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open('inviscidChannelScript.m');
