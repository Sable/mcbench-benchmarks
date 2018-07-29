function InitGUI(handles)
% InitGUI - Initialization function for GUI (runs once only)
% -------------------------------------------------------------
% Abstract: Initialization function for GUI
%
% Syntax:
%           InitGUI(handles)
%
% Inputs:
%           handles - handles structure for the GUI
%
% Outputs:
%           none
%
% Examples:
%           none
%
% Notes: none
%

% Copyright 2007 - 2009 The MathWorks, Inc.
%
% Auth/Revision: 
%	The MathWorks Consulting Group 
%	$Author: rjackey $
%	$Revision: 35 $  $Date: 2008-10-07 10:08:43 -0400 (Tue, 07 Oct 2008) $
% -------------------------------------------------------------------------

% Get the handle to the main GUI
hFigure = handles.MainFig;

%**********************************
%% GET SOME INITIALIZATION VALUES
%**********************************

% Initialize the Waveform Types and Selected Type
WaveformTypes = {
    'Constant (DC)'
    'Sine 60Hz (AC)'
    'Square 60Hz'
    'Triangle 60Hz'
    };
WaveForm = 1;

% Initialize Current Magnitude
CurrentMag = 1;

% Initialize Coil Properties
CoilOn = false;
CoilDist = 0.3;
CoilWidth = 0.4;
CoilHeight = 0.6;

% Initialize Coil Resistance Slider Value
CoilRExp = 3; % 10^-x


%**********************************
%% DRAW GUI OBJECTS
%**********************************

% Get zoom, pan, rotate objects for the figure
% hZoom = zoom(hFigure);
% hPan = pan(hFigure);
hRotate = rotate3d(hFigure);

% Set axes properties for current plots
set(handles.Current2_AX,'Color','none')
% setAllowAxesZoom(hZoom,[handles.Current1_AX,handles.Current2_AX],false);
% setAllowAxesPan(hPan,[handles.Current1_AX,handles.Current2_AX],false);
setAllowAxesRotate(hRotate,[handles.Current1_AX,handles.Current2_AX],false);
title(handles.Current1_AX,'Straight Wire and Loop Current');

% Turn on 3D rotation
rotate3d on

% Set axes properties for the magnetic field drawing
xlabel(handles.MagPlot_AX,'X','Color',[1 0 0],'FontWeight','bold','VerticalAlignment','bottom')
ylabel(handles.MagPlot_AX,'Y','Color',[0 0.5 0],'FontWeight','bold','VerticalAlignment','bottom')
zlabel(handles.MagPlot_AX,'Z','Color',[0 0 1],'FontWeight','bold','VerticalAlignment','bottom')

% Add empty lines for the current waveforms
hCurrent(1) = line('XData',[],'YData',[],...
    'LineWidth',1.5,'LineStyle','-','Color','k','Parent',handles.Current1_AX);
hCurrent(2) = line('XData',[],'YData',[],...
    'LineWidth',2,'LineStyle','--','Color','r','Parent',handles.Current2_AX);

% Add empty line for the wire
hWire = line('XData',[],'YData',[],'ZData',[],...
    'LineWidth',2,'Color',[0 0 0],'Parent',handles.MagPlot_AX);

% Add empty line for the coil
hCoil = line('XData',[],'YData',[],'ZData',[],...
    'LineWidth',2,'Color',[1 0 0],'Parent',handles.MagPlot_AX);

% Set the Waveform Type choices in the Popup Menu
set(handles.Waveform_PUP,'String',WaveformTypes);

%**********************************
%% INITIALIZE SOME APPDATAS
%**********************************

% setappdata(hFigure,'WaveformTypes',WaveformTypes);
setappdata(hFigure,'WaveForm',WaveForm);
setappdata(hFigure,'CurrentMag',CurrentMag);
setappdata(hFigure,'CoilOn',CoilOn);
setappdata(hFigure,'CoilDist',CoilDist);
setappdata(hFigure,'CoilWidth',CoilWidth);
setappdata(hFigure,'CoilHeight',CoilHeight);
setappdata(hFigure,'CoilRExp',CoilRExp);

setappdata(hFigure,'hCurrent',hCurrent);
setappdata(hFigure,'hWire',hWire);
setappdata(hFigure,'hCoil',hCoil);
setappdata(hFigure,'hField',[]);
setappdata(hFigure,'hWireArrows',[]);
setappdata(hFigure,'hCoilArrows',[]);
setappdata(hFigure,'hFieldArrows',[]);

%**********************************
%% FINISH THE REST OF THE GUI INITIALIZATIONS
%**********************************

%Set the GUI window type to normal or modal
set(hFigure,'WindowStyle','normal');

%Center the GUI on the screen
movegui(hFigure,'center')

%**********************************
%% GUI CHAIN
%**********************************

%Refresh the GUI
RefreshGUI(handles);