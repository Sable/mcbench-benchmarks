function RefreshGUI(handles)
% RefreshGUI - Refresh function for GUI
% -------------------------------------------------------------
% Abstract: Refresh function for GUI, which performs the
%           following tasks:
%   Update fields when the Concept or degree of polynomial is changed
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

% Copyright 2008 The MathWorks, Inc.
%
% Auth/Revision:  VAH
%                 The MathWorks Consulting Group 
%                 $Id$
% -------------------------------------------------------------------------

% Get the handle to the main GUI
hFigure = handles.MainFigure;

% Get some appdatas
SelectedTypeOfCurve = getappdata(hFigure, 'SelectedTypeofCurve');
SelectedDOP = getappdata(hFigure, 'SelectedDegreeOfPoly');
mCodeStr = getappdata(hFigure, 'MATLABCode');

%***************************
%% Save GUI State information
%***************************

% Set appdata

%***********************************************
%% Draw items in the GUI and finish the GUI chain
%***********************************************

% Enable/Disable the coefficients based on the Selected Degree of
% Polynomial
% And create the MATLAB Code
Coefficients = getappdata(hFigure, 'CoefficientsArray');     % [a0 a1 a2 a3 a4 a5]

if strcmp(SelectedTypeOfCurve, 'Custom')
    set(handles.degreeOfPolyText, 'String', 'Degree of Polynomial:');
    set(handles.degreeOfPolyText, 'TooltipString', 'Specify the degree of polynomial/curve');
    switch SelectedDOP
        case 1                            %'Line'
            % Update the Coefficients 
            Coefficients(3:end) = 0;
            setappdata(hFigure, 'CoefficientsArray', Coefficients);

            % Enable the following 
            setDefaulta0(handles, 'on',hFigure);    % a0        
            setDefaulta1(handles, 'on',hFigure);    % a1

            % Disable the following and set their value to 0
            setDefaulta2(handles, 'off',hFigure);   % a2
            setDefaulta3(handles, 'off',hFigure);   % a3
            setDefaulta4(handles, 'off',hFigure);   % a4
            setDefaulta5(handles, 'off',hFigure);   % a5

            % MATLAB Code
            mCodeStr{4,1} = 'a2 = 0;';
            mCodeStr{5,1} = 'a3 = 0;';
            mCodeStr{6,1} = 'a4 = 0;';
            mCodeStr{7,1} = 'a5 = 0;';


        case 2                            %'2nd Degree'
            % Update the Coefficients 
            Coefficients(4:end) = 0;
            setappdata(hFigure, 'CoefficientsArray', Coefficients);

            % Enable the following 
            setDefaulta0(handles, 'on',hFigure);    % a0        
            setDefaulta1(handles, 'on',hFigure);    % a1
            setDefaulta2(handles, 'on',hFigure);    % a2

            % Disable the following and set their value to 0       
            setDefaulta3(handles, 'off',hFigure);   % a3
            setDefaulta4(handles, 'off',hFigure);   % a4
            setDefaulta5(handles, 'off',hFigure);   % a5

            % MATLAB Code
            mCodeStr{5,1} = 'a3 = 0;';
            mCodeStr{6,1} = 'a4 = 0;';
            mCodeStr{7,1} = 'a5 = 0;';

        case 3                            %'3rd Degree'
            % Update the Coefficients 
            Coefficients(5:end) = 0;
            setappdata(hFigure, 'CoefficientsArray', Coefficients);

            % Enable the following 
            setDefaulta0(handles, 'on',hFigure);    % a0        
            setDefaulta1(handles, 'on',hFigure);    % a1
            setDefaulta2(handles, 'on',hFigure);    % a2
            setDefaulta3(handles, 'on',hFigure);    % a3

            % Disable the following and set their value to 0               
            setDefaulta4(handles, 'off',hFigure);   % a4
            setDefaulta5(handles, 'off',hFigure);   % a5   

            % MATLAB Code
            mCodeStr{6,1} = 'a4 = 0;';
            mCodeStr{7,1} = 'a5 = 0;';

        case 4                            %'4th Degree'
            % Update the Coefficients 
            Coefficients(6:end) = 0;
            setappdata(hFigure, 'CoefficientsArray', Coefficients);

            % Enable the following 
            setDefaulta0(handles, 'on',hFigure);    % a0        
            setDefaulta1(handles, 'on',hFigure);    % a1
            setDefaulta2(handles, 'on',hFigure);    % a2
            setDefaulta3(handles, 'on',hFigure);    % a3
            setDefaulta4(handles, 'on',hFigure);    % a4

            % Disable the following and set its value to 0                       
            setDefaulta5(handles, 'off',hFigure);   % a5    

            % MATLAB Code
            mCodeStr{7,1} = 'a5 = 0;';

        case 5                            %'5th Degree'
            % Enable the following 
            setDefaulta0(handles, 'on',hFigure);    % a0        
            setDefaulta1(handles, 'on',hFigure);    % a1
            setDefaulta2(handles, 'on',hFigure);    % a2
            setDefaulta3(handles, 'on',hFigure);    % a3
            setDefaulta4(handles, 'on',hFigure);    % a4
            setDefaulta5(handles, 'on',hFigure);    % a5    
    end
    
elseif strcmp(SelectedTypeOfCurve, 'Example')
    set(handles.degreeOfPolyText, 'String', 'Example Curves:');
    set(handles.degreeOfPolyText, 'TooltipString', 'Select an example polynomial/curve');
    switch SelectedDOP
        case 1                            %'Example1: Line'
            % Update the Coefficients 
            Coefficients = [0 1 0 0 0 0];
            setappdata(hFigure, 'CoefficientsArray', Coefficients);

            % Enable the following 
            setDefaulta0(handles, 'on',hFigure);    % a0        
            setDefaulta1(handles, 'on',hFigure);    % a1

            % Reset the edit box state
            set(handles.a0Edit, 'Enable', 'off');
            set(handles.a0Edit, 'FontWeight', 'bold');
            set(handles.a0Slider, 'Enable', 'off');
            set(handles.a1Edit, 'Enable', 'off');
            set(handles.a1Edit, 'FontWeight', 'bold');
            set(handles.a1Slider, 'Enable', 'off');

            % Disable the following and set their value to 0
            setDefaulta2(handles, 'off');   % a2
            setDefaulta3(handles, 'off');   % a3
            setDefaulta4(handles, 'off');   % a4
            setDefaulta5(handles, 'off');   % a5

            % MATLAB Code
            mCodeStr{4,1} = 'a2 = 0;';
            mCodeStr{5,1} = 'a3 = 0;';
            mCodeStr{6,1} = 'a4 = 0;';
            mCodeStr{7,1} = 'a5 = 0;';

        case 2                            %'Example2: 2nd Degree'
            % Update the Coefficients 
            Coefficients = [1 1 2 0 0 0];    % [a0 a1 a2 a3 a4 a5]  
            setappdata(hFigure, 'CoefficientsArray', Coefficients);

            % Enable the following 
            setDefaulta0(handles, 'on',hFigure);    % a0        
            setDefaulta1(handles, 'on',hFigure);    % a1
            setDefaulta2(handles, 'on',hFigure);    % a2

            % Reset the edit box state
            set(handles.a0Edit, 'Enable', 'off');
            set(handles.a0Edit, 'FontWeight', 'bold');
            set(handles.a0Slider, 'Enable', 'off');
            set(handles.a1Edit, 'Enable', 'off');
            set(handles.a1Edit, 'FontWeight', 'bold');
            set(handles.a1Slider, 'Enable', 'off');
            set(handles.a2Edit, 'Enable', 'off');
            set(handles.a2Edit, 'FontWeight', 'bold');
            set(handles.a2Slider, 'Enable', 'off');

            % Disable the following and set their value to 0
            setDefaulta3(handles, 'off',hFigure);   % a3
            setDefaulta4(handles, 'off',hFigure);   % a4
            setDefaulta5(handles, 'off',hFigure);   % a5

            % MATLAB Code
            mCodeStr{5,1} = 'a3 = 0;';
            mCodeStr{6,1} = 'a4 = 0;';
            mCodeStr{7,1} = 'a5 = 0;';  

        case 3                            %'Example3: 3rd Degree'
            % Update the Coefficients 
            Coefficients = [1 1 2 3 0 0];    % [a0 a1 a2 a3 a4 a5]  
            setappdata(hFigure, 'CoefficientsArray', Coefficients);

            % Enable the following 
            setDefaulta0(handles, 'on',hFigure);    % a0        
            setDefaulta1(handles, 'on',hFigure);    % a1
            setDefaulta2(handles, 'on',hFigure);    % a2
            setDefaulta3(handles, 'on',hFigure);    % a3

            % Reset the edit box state
            set(handles.a0Edit, 'Enable', 'off');
            set(handles.a0Edit, 'FontWeight', 'bold');
            set(handles.a0Slider, 'Enable', 'off');
            set(handles.a1Edit, 'Enable', 'off');
            set(handles.a1Edit, 'FontWeight', 'bold');
            set(handles.a1Slider, 'Enable', 'off');
            set(handles.a2Edit, 'Enable', 'off');            
            set(handles.a2Edit, 'FontWeight', 'bold');
            set(handles.a2Slider, 'Enable', 'off');
            set(handles.a3Edit, 'Enable', 'off');
            set(handles.a3Edit, 'FontWeight', 'bold');
            set(handles.a3Slider, 'Enable', 'off');

            % Disable the following and set their value to 0
            setDefaulta4(handles, 'off',hFigure);   % a4
            setDefaulta5(handles, 'off',hFigure);   % a5

            % MATLAB Code
            mCodeStr{6,1} = 'a4 = 0;';
            mCodeStr{7,1} = 'a5 = 0;';      

        case 4                            %'Example4: 4th Degree'
            % Update the Coefficients 
            Coefficients = [1 1 2 3 4 0];    % [a0 a1 a2 a3 a4 a5]  
            setappdata(hFigure, 'CoefficientsArray', Coefficients);

            % Enable the following 
            setDefaulta0(handles, 'on',hFigure);    % a0        
            setDefaulta1(handles, 'on',hFigure);    % a1
            setDefaulta2(handles, 'on',hFigure);    % a2
            setDefaulta3(handles, 'on',hFigure);    % a3
            setDefaulta4(handles, 'on',hFigure);    % a4

            % Reset the edit box state
            set(handles.a0Edit, 'Enable', 'off');
            set(handles.a0Edit, 'FontWeight', 'bold');
            set(handles.a0Slider, 'Enable', 'off');
            set(handles.a1Edit, 'Enable', 'off');
            set(handles.a1Edit, 'FontWeight', 'bold');
            set(handles.a1Slider, 'Enable', 'off');
            set(handles.a2Edit, 'Enable', 'off');
            set(handles.a2Edit, 'FontWeight', 'bold');
            set(handles.a2Slider, 'Enable', 'off');
            set(handles.a3Edit, 'Enable', 'off');
            set(handles.a3Edit, 'FontWeight', 'bold');
            set(handles.a3Slider, 'Enable', 'off');
            set(handles.a4Edit, 'Enable', 'off');
            set(handles.a4Edit, 'FontWeight', 'bold');    
            set(handles.a4Slider, 'Enable', 'off');

            % Disable the following and set their value to 0
            setDefaulta5(handles, 'off',hFigure);   % a5

            % MATLAB Code
            mCodeStr{7,1} = 'a5 = 0;';  

        case 5                            %'Example5: 5th Degree'
            % Update the Coefficients 
            Coefficients = [1 1 2 3 4 5];    % [a0 a1 a2 a3 a4 a5]  
            setappdata(hFigure, 'CoefficientsArray', Coefficients);

            % Enable the following 
            setDefaulta0(handles, 'on',hFigure);    % a0        
            setDefaulta1(handles, 'on',hFigure);    % a1
            setDefaulta2(handles, 'on',hFigure);    % a2
            setDefaulta3(handles, 'on',hFigure);    % a3
            setDefaulta4(handles, 'on',hFigure);    % a4
            setDefaulta5(handles, 'on',hFigure);    % a5       

            % Reset the edit box state
            set(handles.a0Edit, 'Enable', 'off');
            set(handles.a0Edit, 'FontWeight', 'bold');
            set(handles.a0Slider, 'Enable', 'off');
            set(handles.a1Edit, 'Enable', 'off');
            set(handles.a1Edit, 'FontWeight', 'bold');
            set(handles.a1Slider, 'Enable', 'off');
            set(handles.a2Edit, 'Enable', 'off');
            set(handles.a2Edit, 'FontWeight', 'bold');
            set(handles.a2Slider, 'Enable', 'off');
            set(handles.a3Edit, 'Enable', 'off');
            set(handles.a3Edit, 'FontWeight', 'bold');
            set(handles.a3Slider, 'Enable', 'off');
            set(handles.a4Edit, 'Enable', 'off');
            set(handles.a4Edit, 'FontWeight', 'bold');   
            set(handles.a4Slider, 'Enable', 'off');
            set(handles.a5Edit, 'Enable', 'off');
            set(handles.a5Edit, 'FontWeight', 'bold');                
            set(handles.a5Slider, 'Enable', 'off');
    end
end

setappdata(hFigure, 'MATLABCode', mCodeStr);


%***********************************************
%% Finish the GUI chain
%***********************************************

% Update the GUI
UpdateGUI(handles);


%**************************************************************************
%% Additional functions to enable/disable Coefficients and set their default value to 0
%**************************************************************************
%%
function setDefaulta0(handles, state,hFigure)
switch state
    case 'on'
        set(handles.a0Text, 'ForegroundColor', [0 0 0]);            
    case 'off'
        set(handles.a0Text, 'ForegroundColor', [0.5 0.5 0.5]);            
end

set(handles.a0Edit, 'Enable', state);
set(handles.a0Edit, 'FontWeight', 'normal');
set(handles.a0Slider, 'Enable', state);
if strcmp(state, 'on')
    % Get some appdata
    Coefficients = getappdata(hFigure, 'CoefficientsArray');     % [a0 a1 a2 a3 a4 a5]
    set(handles.a0Edit, 'String', num2str(Coefficients(1)));
    set(handles.a0Slider, 'Value', Coefficients(1));
else
    set(handles.a0Edit, 'String', '0');
    set(handles.a0Slider, 'Value', 0);
end

%%
function setDefaulta1(handles, state,hFigure)
%set(handles.a1Text, 'Enable', state);
set(handles.a1Edit, 'Enable', state);
set(handles.a1Edit, 'FontWeight', 'normal');

% Set the color of x^2 Text
chText = get(handles.x1TextAxes, 'Children');
if ~isempty(chText)
    switch state
        case 'on'
            set(chText, 'Color', [0 0 0]);  
            set(handles.a1Text, 'ForegroundColor', [0 0 0]);
        case 'off'
            set(chText, 'Color', [0.5 0.5 0.5]);            
            set(handles.a1Text, 'ForegroundColor', [0.5 0.5 0.5]);
    end
end

set(handles.a1Slider, 'Enable', state);
if strcmp(state, 'on')
    % Get some appdata
    Coefficients = getappdata(hFigure, 'CoefficientsArray');     % [a0 a1 a2 a3 a4 a5]
    set(handles.a1Edit, 'String', num2str(Coefficients(2)));
    set(handles.a1Slider, 'Value', Coefficients(2));
else
    set(handles.a1Edit, 'String', '0');
    set(handles.a1Slider, 'Value', 0);
end

%%
function setDefaulta2(handles, state,hFigure)
%set(handles.a2Text, 'Enable', state);
set(handles.a2Edit, 'Enable', state);
set(handles.a2Edit, 'FontWeight', 'normal');

% Set the color of x^2 Text
chText = get(handles.x2TextAxes, 'Children');
if ~isempty(chText)
    switch state
        case 'on'
            set(chText, 'Color', [0 0 0]);
            set(handles.a2Text, 'ForegroundColor', [0 0 0]);
        case 'off'
            set(chText, 'Color', [0.5 0.5 0.5]);            
            set(handles.a2Text, 'ForegroundColor', [0.5 0.5 0.5]);
    end
end

set(handles.a2Slider, 'Enable', state);
if strcmp(state, 'on')
    % Get some appdata
    Coefficients = getappdata(hFigure, 'CoefficientsArray');     % [a0 a1 a2 a3 a4 a5]
    set(handles.a2Edit, 'String', num2str(Coefficients(3)));
    set(handles.a2Slider, 'Value', Coefficients(3));
else
    set(handles.a2Edit, 'String', '0');
    set(handles.a2Slider, 'Value', 0);
end

%%
function setDefaulta3(handles, state,hFigure)
%set(handles.a3Text, 'Enable', state);
set(handles.a3Edit, 'Enable', state);
set(handles.a3Edit, 'FontWeight', 'normal');

% Set the color of x^3 Text
chText = get(handles.x3TextAxes, 'Children');
if ~isempty(chText)
    switch state
        case 'on'
            set(chText, 'Color', [0 0 0]);            
            set(handles.a3Text, 'ForegroundColor', [0 0 0]);
        case 'off'
            set(chText, 'Color', [0.5 0.5 0.5]);            
            set(handles.a3Text, 'ForegroundColor', [0.5 0.5 0.5]);
    end
end

set(handles.a3Slider, 'Enable', state);
if strcmp(state, 'on')
    % Get some appdata
    Coefficients = getappdata(hFigure, 'CoefficientsArray');     % [a0 a1 a2 a3 a4 a5]
    set(handles.a3Edit, 'String', num2str(Coefficients(4)));
    set(handles.a3Slider, 'Value', Coefficients(4));
else
    set(handles.a3Edit, 'String', '0');
    set(handles.a3Slider, 'Value', 0);
end

%%
function setDefaulta4(handles, state,hFigure)
%set(handles.a4Text, 'Enable', state);
set(handles.a4Edit, 'Enable', state);
set(handles.a4Edit, 'FontWeight', 'normal');

% Set the color of x^4 Text
chText = get(handles.x4TextAxes, 'Children');
if ~isempty(chText)
    switch state
        case 'on'
            set(chText, 'Color', [0 0 0]);  
            set(handles.a4Text, 'ForegroundColor', [0 0 0]);         
        case 'off'
            set(chText, 'Color', [0.5 0.5 0.5]);                       
            set(handles.a4Text, 'ForegroundColor', [0.5 0.5 0.5]);
    end
end

set(handles.a4Slider, 'Enable', state);
if strcmp(state, 'on')
    % Get some appdata
    Coefficients = getappdata(hFigure, 'CoefficientsArray');     % [a0 a1 a2 a3 a4 a5]
    set(handles.a4Edit, 'String', num2str(Coefficients(5)));
    set(handles.a4Slider, 'Value', Coefficients(5));
else
    set(handles.a4Edit, 'String', '0');
    set(handles.a4Slider, 'Value', 0);
end

%%
function setDefaulta5(handles, state,hFigure)
%set(handles.a5Text, 'Enable', state);
set(handles.a5Edit, 'Enable', state);
set(handles.a5Edit, 'FontWeight', 'normal');

% Set the color of x^5 Text
chText = get(handles.x5TextAxes, 'Children');
if ~isempty(chText)
    switch state
        case 'on'
            set(chText, 'Color', [0 0 0]); 
            set(handles.a5Text, 'ForegroundColor', [0 0 0]);
        case 'off'
            set(chText, 'Color', [0.5 0.5 0.5]);   
            set(handles.a5Text, 'ForegroundColor', [0.5 0.5 0.5]);
    end
end

set(handles.a5Slider, 'Enable', state);
if strcmp(state, 'on')
    % Get some appdata
    Coefficients = getappdata(hFigure, 'CoefficientsArray');     % [a0 a1 a2 a3 a4 a5]
    set(handles.a5Edit, 'String', num2str(Coefficients(6)));
    set(handles.a5Slider, 'Value', Coefficients(6));
else
    set(handles.a5Edit, 'String', '0');
    set(handles.a5Slider, 'Value', 0);
end
