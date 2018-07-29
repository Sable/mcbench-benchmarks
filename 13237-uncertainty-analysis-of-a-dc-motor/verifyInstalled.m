function [doRTVCalc, doSimulink] = verifyInstalled
%VERIFYINSTALLED Checks for installed products
% VERIFYINSTALLED checks to ensure required products are installed.
% Required products incldue:
%   MATLAB
%   Simulink
%   Optimization Toolbox
%   Genetic Algorithm and Direct Search Toolbox
%   SimMechanics
%   Virtual Reality Toolbox

% Product List
product = {'MATLAB'
           'statistics_toolbox'
           'curve_fitting_toolbox'
           'control_toolbox'
           'Simulink'
           'power_system_blocks'
           'SimDriveline'
           'aerospace_blockset'
           'aerospace_toolbox'};

% Check for availability
doRTVCalc = false;
doSimulink = true;
showWarn = true;
for i = 1:length(product)
    switch i
        case { 1, 2, 3, 4}
            if ~license('test',product{i})
                error('You need to have %s installed or available to run this Demo',product{i})
            elseif i == 3 || i == 4
                doRTVCalc = true;
            end
        otherwise
            if ~license('test',product{i})
                if showWarn
                    disp('You may not have the ability to view and run the DC Motor Model')
                    disp('This Demo will run, but interaction with the Simulink Model is limited')
                    disp('You need all of the following products to run the model:')
                showWarn = false;
                end
                disp(product{i})
                doSimulink = false;
            end
    end
end