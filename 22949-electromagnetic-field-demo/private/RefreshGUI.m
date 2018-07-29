function RefreshGUI(handles)
% RefreshGUI - Refresh function for GUI
% -------------------------------------------------------------
% Abstract: Refresh function for GUI, which performs the
%           following tasks:
%   
%   
%
% Syntax:
%           RefreshGUI(handles)
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
%	$Revision: 33 $  $Date: 2008-10-06 15:25:17 -0400 (Mon, 06 Oct 2008) $
% -------------------------------------------------------------------------

% Get the handle to the main GUI
hFigure = handles.MainFig;

%**********************************
%% GET SOME APPDATAS
%**********************************

WaveForm = getappdata(hFigure,'WaveForm');
CurrentMag = getappdata(hFigure,'CurrentMag');
CoilOn = getappdata(hFigure,'CoilOn');
CoilDist = getappdata(hFigure,'CoilDist');
CoilHeight = getappdata(hFigure,'CoilHeight');
CoilWidth = getappdata(hFigure,'CoilWidth');
CoilRExp = getappdata(hFigure,'CoilRExp');

hCurrent = getappdata(hFigure,'hCurrent');
hWire = getappdata(hFigure,'hWire');
hCoil = getappdata(hFigure,'hCoil');
hField = getappdata(hFigure,'hField');
hWireArrows = getappdata(hFigure,'hWireArrows');
hCoilArrows = getappdata(hFigure,'hCoilArrows');
hFieldArrows = getappdata(hFigure,'hFieldArrows');

%**********************************
%% PROCESS DATA
%**********************************

% Initialize the wire coordinates
Wire_Z = (-1:0.2:1);
Wire_X = zeros(size(Wire_Z));
Wire_Y = zeros(size(Wire_Z));

% Set axes properties
% xLim = [-1 1];
% yLim = [-1 1];
% zLim = [-1 1];
% ScaleFactor = mean(range([xLim;yLim;zLim],2))/2;
ScaleFactor = 1;

Coil_X = CoilDist + CoilWidth*[0 0 1 1 0];
Coil_Y = [0 0 0 0 0];
Coil_Z = 0.5*CoilHeight*[-1 1 1 -1 -1];

% Coordinates and properties for straight wire arrows
Aw_freq = 3;
Aw_P1 = [Wire_X(2:Aw_freq:end-1)' Wire_Y(2:Aw_freq:end-1)' Wire_Z(2:Aw_freq:end-1)'];
Aw_P2 = [Wire_X(3:Aw_freq:end)'   Wire_Y(3:Aw_freq:end)'   Wire_Z(3:Aw_freq:end)'];
Aw_scale = 0.5;
Aw_Color = [0 0 0];

% Coordinates and properties for coil wire arrows
Ac_freq = 1;
Ac_P1 = [Coil_X(1:Ac_freq:end-1)' Coil_Y(1:Ac_freq:end-1)' Coil_Z(1:Ac_freq:end-1)'];
Ac_P2 = [Coil_X(2:Ac_freq:end)'   Coil_Y(2:Ac_freq:end)'   Coil_Z(2:Ac_freq:end)'];
Ac_scale = 0.7;
Ac_Color = [1 0 0];

% Coordinates of field lines
r = ScaleFactor ./ [16 8 4 2 1]; % locations of field lines (1/r decay)
theta = 0:pi/10:2*pi; % angles of points on the line
Field_X = cos(theta)'*r;
Field_Y = sin(theta)'*r;

% Coordinates and properties for field arrows
Af_freq = 4;
Af_P1 = [];
Af_P2 = [];
for i=1:numel(r)
    Af_P1 = [Af_P1; Field_X(1:Af_freq:end-1,i) Field_Y(1:Af_freq:end-1,i) zeros(floor((size(Field_X,1)-1)/4),1)]; %#ok<AGROW>
    Af_P2 = [Af_P2; Field_X(2:Af_freq:end,i)   Field_Y(2:Af_freq:end,i)   zeros(floor((size(Field_X,1)-1)/4),1)]; %#ok<AGROW>
end
Af_Scale = [0.08 0.04];
Af_Color = [0 0 1];
    
% Calculate current waveform in the straight wire
Fs = 1/60; %period (sec)
t = 0:Fs/100:6*Fs;
switch WaveForm
    case 1 %dc
        I_wire = CurrentMag * ones(size(t));
    case 2 %sin
        I_wire = CurrentMag * sin(2*pi*t/Fs);
    case 3 %square
        I_wire = CurrentMag * 2*((mod(t,Fs) < Fs/2)-0.5);
    case 4 %triangle
        I_wire = CurrentMag * 2*(mod(t,Fs)/Fs - 0.5);
end

% Calculate the current induced in the coil
% (Derived from Ampere's / Biot-Savart Law)
%   B = magnetic field (Tesla)
%   mu_0 = magnetic constant / permeability of free space (T*m/A)
%   I = current (Amps)
%   r = distance from wire (m)
%   phi_m = flux
mu_0 = pi*4e-7;
R = 10^-(CoilRExp);
phi_m = (CoilHeight*mu_0.*I_wire/(2*pi)) * (log(CoilDist)-log(CoilDist+CoilWidth));
EMF = [0, -( diff(phi_m)./diff(t) )];
I_coil =  EMF/R;


%**********************************
%% DRAW GUI ITEMS
%**********************************

%---- GUI Controls ----%

% Set popup values
set(handles.Waveform_PUP,'Value',WaveForm);

% Set slider values
set(handles.Current_SLDR,'Value',CurrentMag);
set(handles.CoilDist_SLDR,'Value',CoilDist);
set(handles.CoilHeight_SLDR,'Value',CoilHeight);
set(handles.CoilWidth_SLDR,'Value',CoilWidth);
set(handles.CoilR_SLDR,'Value',CoilRExp);

% Set textbox values
set(handles.Current_ET,'String',[num2str(CurrentMag) 'A']);
set(handles.CoilDist_ET,'String',[num2str(CoilDist) 'm']);
set(handles.CoilHeight_ET,'String',[num2str(CoilHeight) 'm']);
set(handles.CoilWidth_ET,'String',[num2str(CoilWidth) 'm']);
set(handles.CoilR_ET,'String',[num2str(R) ' Ohms']);

%---- Current Plots ----%

% Update the Wire Current plot
set(hCurrent(1),'XData',t,'YData',I_wire);

% Update the Loop Current Plot
set(hCurrent(2),'XData',t,'YData',I_coil);

%---- Magnetic Field Plot ----%

% Straight Wire
set(hWire,'XData',Wire_X,'YData',Wire_Y,'ZData',Wire_Z);

% Straight Wire Arrows
delete(hWireArrows(ishandle(hWireArrows)));
hWireArrows = cone(Aw_P1,Aw_P2,Aw_scale,'FaceVertexCData',Aw_Color,...
    'FaceLighting','Phong');

% Coil Wire
set(hCoil,'XData',Coil_X,'YData',Coil_Y,'ZData',Coil_Z);

% Coil Wire Arrows
delete(hCoilArrows(ishandle(hCoilArrows)));
hCoilArrows = cone(Ac_P1,Ac_P2,Ac_scale,'FaceVertexCData',Ac_Color,...
    'FaceLighting','Phong');

% Draw field lines
delete(hFieldArrows(ishandle(hFieldArrows)));
delete(hField(ishandle(hField)))
for i=1:numel(r)
    hField(i) = line(Field_X(:,i),Field_Y(:,i),'Parent',handles.MagPlot_AX);
end
hFieldArrows = cone(Af_P1,Af_P2,Af_Scale,'FaceVertexCData',Af_Color,...
    'FaceLighting','Phong');


%---- Visibility of Plot Items ----%

% Toggle coil related visibilities on/off
CoilHandles = [
    hCurrent(2)
    hCoil
    hCoilArrows
    ];
if CoilOn
    set(CoilHandles,'Visible','on');
else
    set(CoilHandles,'Visible','off');
end

%**********************************
%% SAVE GUI STATE INFORMATION
%**********************************

setappdata(hFigure,'hField',hField);
setappdata(hFigure,'hWireArrows',hWireArrows);
setappdata(hFigure,'hCoilArrows',hCoilArrows);
setappdata(hFigure,'hFieldArrows',hFieldArrows);
