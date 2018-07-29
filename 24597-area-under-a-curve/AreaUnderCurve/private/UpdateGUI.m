function UpdateGUI(handles)
% UpdateGUI - Update function for GUI
% -------------------------------------------------------------
% Abstract: Update function for GUI, which performs the
%           following tasks:
%   Draws the area under a curve
%
% Syntax:
%           UpdateGUI(handles)
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

% Copyright 2008 The MathWorks, Inc.
%
% Auth/Revision:  VAH
%                 The MathWorks Consulting Group 
%                 $Id$
% -------------------------------------------------------------------------

% Get the handle to the main GUI
hFigure = handles.MainFigure;

% Get some appdatas
deltaX = getappdata(hFigure, 'DeltaX');
SelectedTypeOfCurve = getappdata(hFigure, 'SelectedTypeofCurve');
SelectedDOP = getappdata(hFigure, 'SelectedDegreeOfPoly');
Coefficients = getappdata(hFigure, 'CoefficientsArray');     % [a0 a1 a2 a3 a4 a5]
IntegrationLimits = getappdata(hFigure, 'IntegrationLimits');    % [xmin xmax]
mCodeStr = getappdata(hFigure, 'MATLABCode');

%*******************************
%% Save non-GUI State information
%*******************************


%***********************************************
%% Draw items in the GUI and finish the GUI chain
%***********************************************
% Set the max of the deltaX slider
deltaX_max = get(handles.deltaXSlider,'Max');
if IntegrationLimits(2) == 0
    deltaX_max = abs(IntegrationLimits(2) - IntegrationLimits(1))/10;
else
    deltaX_max = abs(IntegrationLimits(2))/10;
end
set(handles.deltaXSlider,'Max',deltaX_max);
set(handles.deltaXSlider,'Value',deltaX);
set(handles.deltaXEdit, 'String', num2str(deltaX, 2));

% Set coefficients 
set(handles.a0Slider,'Value',Coefficients(1));
set(handles.a0Edit,'String',num2str(Coefficients(1),3));
set(handles.a1Slider,'Value',Coefficients(2));
set(handles.a1Edit,'String',num2str(Coefficients(2),3));
set(handles.a2Slider,'Value',Coefficients(3));
set(handles.a2Edit,'String',num2str(Coefficients(3),3));
set(handles.a3Slider,'Value',Coefficients(4));
set(handles.a3Edit,'String',num2str(Coefficients(4),3));
set(handles.a4Slider,'Value',Coefficients(5));
set(handles.a4Edit,'String',num2str(Coefficients(5),3));
set(handles.a5Slider,'Value',Coefficients(6));
set(handles.a5Edit,'String',num2str(Coefficients(6),3));

% Set the radio buttons - Example and Custom
if strcmp(SelectedTypeOfCurve, 'Example')
    set(handles.exampleRadiobutton,'Value',1.0);
    set(handles.customRadiobutton,'Value',0.0);
elseif strcmp(SelectedTypeOfCurve, 'Custom')
    set(handles.exampleRadiobutton,'Value',0.0);
    set(handles.customRadiobutton,'Value',1.0);
end 

% Set the degree of polynomial popup selection
set(handles.degreeOfPolyPopupmenu,'Value',SelectedDOP);

% Set the integration limits
% Set the max and min of the lower and upper limits sliding bars
set(handles.lowerLimitSlider, 'Max', IntegrationLimits(2));
set(handles.upperLimitSlider, 'Min', IntegrationLimits(1));
set(handles.lowerLimitSlider, 'Value', IntegrationLimits(1));
set(handles.upperLimitSlider, 'Value', IntegrationLimits(2));
set(handles.lowerLimitEdit,'String',num2str(IntegrationLimits(1)));
set(handles.upperLimitEdit,'String',num2str(IntegrationLimits(2)));

% Equation of Curve text
fxStr = {CreateFxText(SelectedDOP, Coefficients)};        
axes(handles.fxAxes)

% First find all the children of this handle
chText = get(handles.fxAxes, 'Children');

if isempty(chText)
    text('Interpreter','latex', ...
         'String',fxStr,...
         'Position',[.05 .5],...
         'FontSize',11);
else
    set(chText, 'String', fxStr);
end

% Create a plot showing approximations
plotApproxAreaUnderACurve(handles, IntegrationLimits, Coefficients,deltaX);

% Match the axes in both the plots
plot1_xAxis = get(handles.approximationPlotAxes, 'XTick');
plot1_yAxis = get(handles.approximationPlotAxes, 'YTick');

% Create a plot showing smooth curve
plotAreaUnderACurve(handles, IntegrationLimits, Coefficients, plot1_xAxis, plot1_yAxis);

% Set the text 
% Compute area numerically
xRectpts = (IntegrationLimits(1)+0.5*deltaX:deltaX:IntegrationLimits(2));
yRectpts = Coefficients(1)+Coefficients(2)*xRectpts+Coefficients(3)*xRectpts.^2+Coefficients(4)*xRectpts.^3+Coefficients(5)*xRectpts.^4+Coefficients(6)*xRectpts.^5;
approxArea = 0.0;
for idx = 1:length(yRectpts)
    approxArea = yRectpts(idx)*deltaX+approxArea;
end

axes(handles.approxAreaTextAxes)
approxAreatextStr = {['$$\textit{\textbf {Approx. Area}} = \lim_{\Delta x\to0} \sum_{i=1}^{\it N \rm} f_i(x) \Delta x = $$' num2str(approxArea)]};

% First find all the children of this handle
chText = get(handles.approxAreaTextAxes, 'Children');

if isempty(chText)
    text('Interpreter','latex', ...
         'String',approxAreatextStr,...
         'Position',[.05 .5],...
         'FontSize',11, ...
         'Color', [0.14, 0.09, 0.51]);
else
    set(chText, 'String', approxAreatextStr);
end

% Calculate the area analytically
inputPoly = Coefficients(end:-1:1);
integPoly = polyint(inputPoly, 0);
xMaxVec = (IntegrationLimits(2)*ones(size(integPoly))).^(length(integPoly)-1:-1:0);
xMinVec = (IntegrationLimits(1)*ones(size(integPoly))).^(length(integPoly)-1:-1:0);
realArea = dot(integPoly, xMaxVec) - dot(integPoly, xMinVec);

approximationError = realArea-approxArea;
if abs(realArea) > 0
    approximationError = approximationError/realArea;
end

axes(handles.realAreaTextAxes)
realAreatextStr = {['$$\textit{\textbf {Area}} = \int_{xmin}^{xmax} f(x)\, dx = $$' num2str(realArea)]; ...
               '';
               ['$$\textit{\textbf {Error}} = \textit{\textbf {Area}} - \textit{\textbf {Approx. Area}}  = $$' num2str(approximationError) '$$ \% $$']};
           
% First find all the children of this handle
chText = get(handles.realAreaTextAxes, 'Children');

if isempty(chText)
    text('Interpreter','latex', ...
         'String',realAreatextStr,...
         'Position',[.05 .5],...
         'FontSize',11, ...
         'Color', [0.14, 0.09, 0.51]) 
else
    set(chText, 'String', realAreatextStr);
end
           
% Fill the MATLAB Code
set(handles.mCodeText, 'String', mCodeStr);


%%
function [fxStr] = CreateFxText(degreeOfPoly, Coefficients)
% Function to compute the f(x) string from the coefficients
%   f(x)=a0+a1*x+a2x^2+a3^x3+a4*x^4+a5*x^5  based of the degree of curve
%   where  a0 = Coefficients(1)
%          a1 = Coefficients(2)
%          a2 = Coefficients(3)
%          a3 = Coefficients(4)
%          a4 = Coefficients(5)
%          a5 = Coefficients(6)

fxStr = ['$$ f(x) = ']; 

numCoeffs = length(Coefficients);
firstTerm = true;
for idx = numCoeffs:-1:1
    if ~firstTerm
        if Coefficients(idx) > 0
            fxStr = [fxStr ' + '];
        end        
    end

    if (Coefficients(idx) ~= 0)
        if idx == 6
            if Coefficients(idx) ~=1
                fxStr = [fxStr num2str(Coefficients(idx))];
            end
            fxStr = [fxStr 'x^5 '];
        elseif idx == 5
            if Coefficients(idx) ~=1
                fxStr = [fxStr num2str(Coefficients(idx))];
            end
            fxStr = [fxStr 'x^4 '];
        elseif idx == 4
            if Coefficients(idx) ~=1
                fxStr = [fxStr num2str(Coefficients(idx))];
            end
            fxStr = [fxStr 'x^3 '];
        elseif idx == 3
            if Coefficients(idx) ~=1
                fxStr = [fxStr num2str(Coefficients(idx))];
            end
            fxStr = [fxStr 'x^2 '];
        elseif idx == 2
            if Coefficients(idx) ~=1
                fxStr = [fxStr num2str(Coefficients(idx))];
            end
            fxStr = [fxStr 'x '];
        else
            fxStr = [fxStr num2str(Coefficients(idx))];
        end  
        firstTerm = false;
    end
end

fxStr = [fxStr '$$'];