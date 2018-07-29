function varargout = software(varargin)
% SOFTWARE MATLAB code for software.fig
%      SOFTWARE, by itself, creates a new SOFTWARE or raises the existing
%      singleton*.
%
%      H = SOFTWARE returns the handle to a new SOFTWARE or the handle to
%      the existing singleton*.
%
%      SOFTWARE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SOFTWARE.M with the given input arguments.
%
%      SOFTWARE('Property','Value',...) creates a new SOFTWARE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before software_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to software_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help software

% Last Modified by GUIDE v2.5 08-Sep-2013 23:48:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @software_OpeningFcn, ...
                   'gui_OutputFcn',  @software_OutputFcn, ...
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


% --- Executes just before software is made visible.
function software_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to software (see VARARGIN)

% Choose default command line output for software
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes software wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = software_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in push_simulation.
function push_simulation_Callback(hObject, eventdata, handles)
% hObject    handle to push_simulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear T Y

cla(handles.axes_time)
cla(handles.axes_flowrate)

global K_S S_0 mu_max Y_XS Y_PX D X_0 P_0 mu_0 D_crit

K_S = str2double(get(handles.K_S_edit,'String'));
S_0 = str2double(get(handles.S_0_edit,'String'));
mu_max = str2double(get(handles.mu_max_edit,'String'));
Y_XS = str2double(get(handles.Y_XS_edit,'String'));
Y_PX = str2double(get(handles.Y_PX_edit,'String'));
D = str2double(get(handles.D_edit,'String'));
X_0 = str2double(get(handles.X_0_edit,'String'));
P_0 = str2double(get(handles.P_0_edit,'String'));
cult_length = str2double(get(handles.length_edit,'String'));
mu_0 = mu_max * S_0 / (K_S + S_0);

[T,Y]=ode45(@calculator1,[0 cult_length],[X_0 S_0 P_0 mu_0]);

axes(handles.axes_time);

hold all

plot(T,Y(:,1),'b');
plot(T,Y(:,2),'k');
plot(T,Y(:,3),'m');
plot(T,Y(:,4),'r');
hleg1 = legend('Biomass [g/L]','Substrate [g/L]','Product [g/L]','\mu [1/h]');
set(hleg1,'Location','NorthWest','FontSize',10);
xlabel('Time [h]');
ylabel('Concentration [g/l] or Rate [1/h]');
plot(T,Y(:,1)/3,'g');

D_crit = mu_max * S_0 / (K_S + S_0);

if isnan(K_S) || isnan(S_0) || isnan(mu_max) || isnan(Y_XS) || isnan(Y_XS) || isnan(Y_XS)
    warndlg('Please enter all process parameters or the planet will explode in 30 seconds.','Holy shit, an error has occured!');
end

x = 0:.01:D_crit;
[X,S] = calculator2(x);
Pr = x .* X;

axes(handles.axes_flowrate);

hold all

plot(x,X,'b');
plot(x,S,'k');
plot(x,Pr,'r');
xlabel('Flow rate D [1/h]');
ylabel('Biomass [g/L], Substrate [g/L], Productivity');
hleg1 = legend('Biomass [g/L]','Substrate [g/L]','Productivity');
set(hleg1,'Location','NorthWest','FontSize',10);
title('Flow rate');

D_opt = mu_max * (1 - (K_S / (K_S + S_0))^.5);

set(handles.D_opt_edit,'String', num2str(D_opt));
set(handles.D_crit_edit,'String',num2str(D_crit));
