function InitGUI(handles)
% InitGUI - Initialization function for GUI (runs only once)
% -------------------------------------------------------------
% Abstract: Initialization function for GUI, which performs the
%           following tasks:
%   Set up GUI defaults, including initial GUI data and selections
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

% Copyright 2008 The MathWorks, Inc.
%
% Auth/Revision:  VAH
%                 The MathWorks Consulting Group 
%                 $Id$
% -------------------------------------------------------------------------

% Get the handle to the main GUI
hFigure = handles.MainFigure;

% Get all the children
% figureCh = get(hFigure, 'Children');
% [c1, curvePropsPanelIdx, ib1] = intersect(get(figureCh(1:end), 'Tag'), 'CurvePropsPanel');
% curvePropPanelCh = get(figureCh(curvePropsPanelIdx), 'Children');
% [c2, degOfPolyPMIdx, ib2] = intersect(get(curvePropPanelCh(1:end), 'Tag'), 'degreeOfPolyPopupmenu');
% 
% uistack(curvePropPanelCh(degOfPolyPMIdx), 'bottom');

% Set the GUI to normal/modal
set(hFigure, 'WindowStyle', 'normal');

% Center the GUI on the screen
movegui(hFigure, 'center')

%**********************************
%% Get some initialization variables
%**********************************

% Define the list of available degree of polynomial options
DegreeOfPolyOptions = {'Line', ...
                       '2nd Degree', ...
                       '3rd Degree', ...
                       '4th Degree', ...
                       '5th Degree'};
                                      
%******************************
%% Initialize some appdatas
%******************************
% delta X
setappdata(hFigure, 'DeltaX', 1.0);

% Selected type of curve
setappdata(hFigure, 'SelectedTypeofCurve', 'Example');

% Selected degree of polynomial
setappdata(hFigure, 'SelectedDegreeOfPoly', 2);

% Coefficients
setappdata(hFigure, 'CoefficientsArray', [0 0 0 0 0 0]);    % [a0 a1 a2 a3 a4 a5]

% Integration limits
setappdata(hFigure, 'IntegrationLimits', [-10 10]);    % [xmin xmax]

% MATLAB codes
mCodeStr{1,1} = '%Get the coefficients of the curve f(x)';
mCodeStr{2,1} = ['a0 = get(handles.a0Edit,' '''String''' ');'];
mCodeStr{3,1} = ['a1 = get(handles.a1Edit,' '''String''' ');'];
mCodeStr{4,1} = ['a2 = get(handles.a2Edit,' '''String''' ');'];
mCodeStr{5,1} = ['a3 = get(handles.a3Edit,' '''String''' ');'];
mCodeStr{6,1} = ['a4 = get(handles.a4Edit,' '''String''' ');'];
mCodeStr{7,1} = ['a5 = get(handles.a2Edit,' '''String''' ');'];
mCodeStr{8,1} = '%Get the limits of integration';
mCodeStr{9,1} = ['xmin = get(handles.lowerLimitEdit,' '''String''' ');'];
mCodeStr{10,1} = ['xmax = get(handles.upperLimitEdit,' '''String''' ');'];
mCodeStr{11,1} = '';
mCodeStr{12,1} = '%Compute the area under the curve';
mCodeStr{13,1} = 'AnalyticalAreaUnderCurve = analyticalIntegration(...';
mCodeStr{14,1} = '                           a0, a1, a2, a3, a4, a5, xmin, xmax);';
mCodeStr{15,1} = 'ApproximateAreaUnderCurve = approxIntegration(delta_x, ...';
mCodeStr{16,1} = '                           a0, a1, a2, a3, a4, a5), xmin, xmax);';
mCodeStr{17,1} = 'Error = AnalyticalAreaUnderCurve - ApproximateAreaUnderCurve;';

setappdata(hFigure, 'MATLABCode', mCodeStr);

%******************************************
%% Draw GUI Items
%******************************************
% Set the max of the deltaX slider
set(handles.deltaXSlider,'Max',1.0);
set(handles.deltaXSlider,'Value',1.0);
set(handles.deltaXEdit, 'String', '1.0');

% Populate the degree of polynomial popup
set(handles.exampleRadiobutton,'Value',1.0);
set(handles.customRadiobutton,'Value',0.0);

set(handles.degreeOfPolyPopupmenu,'String',DegreeOfPolyOptions);
%set(handles.limitAsText,'CData',img);

set(handles.lowerLimitSlider, 'Min', -10);
set(handles.lowerLimitSlider, 'Max', 9);

set(handles.upperLimitSlider, 'Min', -9);
set(handles.upperLimitSlider, 'Max', 10);

% x Text
axes(handles.x1TextAxes)
x1Str = {['$$x$$']};

text('Interpreter','latex', ...
     'String',x1Str,...
     'Position',[.05 .5],...
     'FontSize',11);

% x^2 Text
axes(handles.x2TextAxes)
x2Str = {['$$x^2$$']};

text('Interpreter','latex', ...
     'String',x2Str,...
     'Position',[.05 .5],...
     'FontSize',11);
 
% x^3 Text
axes(handles.x3TextAxes)
x3Str = {['$$x^3$$']};

text('Interpreter','latex', ...
     'String',x3Str,...
     'Position',[.05 .5],...
     'FontSize',11);

% x^4 Text
axes(handles.x4TextAxes)
x4Str = {['$$x^4$$']};

text('Interpreter','latex', ...
     'String',x4Str,...
     'Position',[.05 .5],...
     'FontSize',11); 
 
% x^5 Text
axes(handles.x5TextAxes)
x5Str = {['$$x^5$$']};

text('Interpreter','latex', ...
     'String',x5Str,...
     'Position',[.05 .5],...
     'FontSize',11);  
 
%******************************************
%% Finish the rest of the GUI initializations
%******************************************

% Refresh the GUI
RefreshGUI(handles);