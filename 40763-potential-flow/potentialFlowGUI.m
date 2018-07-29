function varargout = potentialFlowGUI(varargin)
% POTENTIALFLOWGUI MATLAB code for potentialFlowGUI.fig
%      POTENTIALFLOWGUI, by itself, creates a new POTENTIALFLOWGUI or raises the existing
%      singleton*.
%
%      H = POTENTIALFLOWGUI returns the handle to a new POTENTIALFLOWGUI or the handle to
%      the existing singleton*.
%
%      POTENTIALFLOWGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POTENTIALFLOWGUI.M with the given input arguments.
%
%      POTENTIALFLOWGUI('Property','Value',...) creates a new POTENTIALFLOWGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before potentialFlowGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to potentialFlowGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help potentialFlowGUI

% Last Modified by GUIDE v2.5 11-Mar-2013 22:31:07

% Copyright 2013 The MathWorks, Inc.

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @potentialFlowGUI_OpeningFcn, ...
    'gui_OutputFcn',  @potentialFlowGUI_OutputFcn, ...
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


% --- Executes just before potentialFlowGUI is made visible.
function potentialFlowGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to potentialFlowGUI (see VARARGIN)

% Initialize the GUI layout
set(handles.start,'ToolTipString','Add a potential: Pick a location WITHIN the axes');
handles.data.xlim = [-2 2];
handles.data.ylim = [-2 2];
set(handles.axes_flow,'Xlim',handles.data.xlim,'Ylim',handles.data.ylim,...
    'DataAspectRatio',[1 1 1]);
xlabel(handles.axes_flow,'X');ylabel(handles.axes_flow,'Y');
annotation(gcf,'textbox',[0.17 0.9 0.03 0.07],...
    'String',{'Superposition of Elementary Plane Flows (u, v, \Phi, \Psi)'},...
    'FitBoxToText','on',...
    'LineStyle','-','BackgroundColor',[0.08 0.17 0.55],...
    'Color',[1 1 1],'FontSize',12,'FontWeight','bold');
ngrid = 21;
xrange = linspace(handles.data.xlim(1),handles.data.xlim(2),ngrid);
yrange = linspace(handles.data.ylim(1),handles.data.ylim(2),ngrid);
[handles.data.x, handles.data.y] = meshgrid(xrange,yrange);
handles.data.v_x = str2double(get(handles.v_x,'String'));
handles.data.v_y = str2double(get(handles.v_y,'String'));
handles.data.u = handles.data.v_x.*ones(ngrid,ngrid);
handles.data.v = handles.data.v_y.*ones(ngrid,ngrid);
handles.data.psi = handles.data.u.*handles.data.y + handles.data.v.*handles.data.x;
handles.data.phi = -handles.data.u.*handles.data.x - handles.data.v.*handles.data.y;
% Create the help button on toolbar
[X, map] = imread(fullfile(...
    matlabroot,'toolbox','matlab','icons','csh_icon.gif'));
icon = ind2rgb(X,map);
uipushtool(handles.uitoolbar1,'CData',icon,...
    'TooltipString','Help',...
    'ClickedCallback',@AppHelp);

% Choose default command line output for potentialFlowGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes potentialFlowGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = potentialFlowGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function [x,y,u,v,psi,phi] = potentialFlow(handles)
% Create potential flow based on user input

% Read in x,y and previous u,v,psi,phi values 
x = handles.data.x;
y = handles.data.y;
u = handles.data.u;
v = handles.data.v;
psi = handles.data.psi;
phi = handles.data.phi;
% Check if the Add Potential Flow button is pressed
proceed = get(handles.start,'Value');
% If pressed, wait for user to pick a location, 
% then prompt user to input type of flow and its strength,
% then linearly add the potential flows to reflect the superposition. 
while proceed == 1
    [x_c,y_c,click] = ginput(1);
    if click == 1
        prompt = {'Enter the {\bftype} of elementary plane flow (source,sink,vortex,or doublet):';...
            'Enter the {\bfstrength} of the flow:'};
        name = 'Enter elementary plane flow parameters';
        numlines = 1;
        defaultanswer = {'source','1'}; % provide default answers
        options.Resize = 'on';
        options.WindowSylte = 'normal';
        options.Interpreter = 'tex'; 
        answer = inputdlg(prompt,name,numlines,defaultanswer,options);
        if ~isempty(answer)
            type = answer{1};
            q = str2num(answer{2});
            [addu,addv,addpsi,addphi] = addPotential(x,y,x_c,y_c,q,type);
            u = u + addu;
            v = v + addv;
            psi = psi + addpsi;
            phi = phi + addphi;
            updatePlot(handles,x,y,u,v,psi,phi);
        end
    else
        break;
    end
end




function updatePlot(handles,x,y,u,v,psi,phi)
% Update the plot based on new superpositioned potential flows
cla(handles.axes_flow);
set(handles.axes_flow,'Xlim',1.1*handles.data.xlim,...
    'Ylim',1.1*handles.data.ylim,...
    'DataAspectRatio',[1 1 1],...
    'NextPlot','replacechildren');
u_s = u./sqrt(u.^2+v.^2);
v_s = v./sqrt(u.^2+v.^2);
% Check whether to show vector plots
if get(handles.showvector,'Value')
    h.v = quiver(handles.axes_flow,x,y,u_s,v_s);
    set(h.v,'AutoScaleFactor',0.5,'Color','k');
end
hold on
% Check whether to show velocity potential
if get(handles.showpotential,'Value')
    [~,h.c] = contour(handles.axes_flow,x,y,phi,20);
    colormap(handles.axes_flow,'Autumn');
    colorbar('peer',handles.axes_flow);
else
    colorbar('off');
end
hold off
% Check whether to show streamlines
[strx, stry] = meshgrid(-2:0.4:2,-2:0.4:2); % where to draw the streamlines
if get(handles.showstreamline,'Value')
    h.str = streamline(handles.axes_flow,x,y,u,v,strx,stry);
    set(h.str,'Color','b');
end

function AppHelp(varargin)
% Create help message
dlgname = 'About Potential Flow App';
txt = {'Superposition of elementary potential flows';
    '          --uniform flow, source, sink, vortex, doublet';
    '';
    '* Modify values of uniform flow velocity u and v';
    '  and observe the streamlines and velocity potential';
    '* Add Potential Flow - the mouse becomes a cursor:';
    '  a) Pick a point WITHIN the axes and LEFT click;';
    '  b) Enter the type and strength of potential flow in the prompt window';
    '  c) Keep adding different potential flows to the existing flow field';
    '  d) RIGHT click to EXIT the add potential mode';
    '* Again modify values of uniform flow velocity u and v:';
    '  the existing potential flows remain';
    '* Toggle the plot options to choose what to plot';
    '* Clear Plot - clear the plot and existing data';
    '* Open Code - open the function that computes the potential flows';
    '';
    '* Source + Uniform Flow = Flow past a Half-Body';
    '* Source + Sink = Doublet';
    '* Source + Sink + Uniform Flow = Flow past a Rankine Body';
    '* Doublet + Uniform Flow = Flow past a cylinder';
    '* Doublet + Uniform Flow + Vortex = Flow past a rotating cylinder';
    '* Source + Vortex = Spiral Vortex';
    '* Try your own!';
    '';
    'Copyright 2013 The MathWorks, Inc.'};
helpdlg(txt,dlgname);


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[x,y,u,v,psi,phi]= potentialFlow(handles);
handles.data.x = x;
handles.data.y = y;
handles.data.u = u;
handles.data.v = v;
handles.data.psi = psi;
handles.data.phi = phi;

guidata(hObject, handles);


function v_x_Callback(hObject, eventdata, handles)
% hObject    handle to v_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
v_x = str2double(get(handles.v_x,'String'));
v_y = str2double(get(handles.v_y,'String'));
v_x0 = handles.data.v_x;
v_y0 = handles.data.v_y;
x = handles.data.x;
y = handles.data.y;
u = handles.data.u + (v_x-v_x0)*ones(size(handles.data.u,1),size(handles.data.u,2));
v = handles.data.v + (v_y-v_y0)*ones(size(handles.data.u,1),size(handles.data.u,2));
psi = u.*y + v.*x;
phi = -u.*x - v.*y;
updatePlot(handles,x,y,u,v,psi,phi);
handles.data.x = x;
handles.data.y = y;
handles.data.u = u;
handles.data.v = v;
handles.data.psi = psi;
handles.data.phi = phi;
handles.data.v_x = v_x;
handles.data.v_y = v_y;
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of v_x as text
%        str2double(get(hObject,'String')) returns contents of v_x as a double

function v_y_Callback(hObject, eventdata, handles)
% hObject    handle to v_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
v_x = str2double(get(handles.v_x,'String'));
v_y = str2double(get(handles.v_y,'String'));
v_x0 = handles.data.v_x;
v_y0 = handles.data.v_y;
x = handles.data.x;
y = handles.data.y;
u = handles.data.u + (v_x-v_x0)*ones(size(handles.data.u,1),size(handles.data.u,2));
v = handles.data.v + (v_y-v_y0)*ones(size(handles.data.u,1),size(handles.data.u,2));
psi = u.*y + v.*x;
phi = -u.*x - v.*y;
updatePlot(handles,x,y,u,v,psi,phi);
handles.data.x = x;
handles.data.y = y;
handles.data.u = u;
handles.data.v = v;
handles.data.psi = psi;
handles.data.phi = phi;
handles.data.v_x = v_x;
handles.data.v_y = v_y;
guidata(hObject, handles);

% guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of v_y as text
%        str2double(get(hObject,'String')) returns contents of v_y as a double


% --- Executes on button press in showstreamline.
function showstreamline_Callback(hObject, eventdata, handles)
% hObject    handle to showstreamline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updatePlot(handles,handles.data.x,handles.data.y,handles.data.u,handles.data.v,...
    handles.data.psi,handles.data.phi);
% potentialFlow(handles);

% Hint: get(hObject,'Value') returns toggle state of showstreamline


% --- Executes on button press in showvector.
function showvector_Callback(hObject, eventdata, handles)
% hObject    handle to showvector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updatePlot(handles,handles.data.x,handles.data.y,handles.data.u,handles.data.v,...
    handles.data.psi,handles.data.phi);
% Hint: get(hObject,'Value') returns toggle state of showvector


% --- Executes on button press in showpotential.
function showpotential_Callback(hObject, eventdata, handles)
% hObject    handle to showpotential (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updatePlot(handles,handles.data.x,handles.data.y,handles.data.u,handles.data.v,...
    handles.data.psi,handles.data.phi);
% Hint: get(hObject,'Value') returns toggle state of showpotential


% --- Executes on button press in clearplot.
function clearplot_Callback(hObject, eventdata, handles)
% hObject    handle to clearplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Clear the plot AND the previous u,v,psi,phi data
handles.data.v_x = str2double(get(handles.v_x,'String'));
handles.data.v_y = str2double(get(handles.v_y,'String'));
handles.data.u = handles.data.v_x.*ones(size(handles.data.x,1),size(handles.data.y,2));
handles.data.v = handles.data.v_y.*ones(size(handles.data.x,1),size(handles.data.y,2));
handles.data.psi = handles.data.u.*handles.data.y + handles.data.v.*handles.data.x;
handles.data.phi = -handles.data.u.*handles.data.x - handles.data.v.*handles.data.y;
cla(handles.axes_flow);
colorbar('off');
guidata(hObject, handles);


% --- Executes on button press in solution.
function solution_Callback(hObject, eventdata, handles)
% hObject    handle to solution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open('addPotential.m');
