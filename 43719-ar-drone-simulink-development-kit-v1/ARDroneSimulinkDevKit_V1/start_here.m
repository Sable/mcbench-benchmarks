%% =======================================================================
%  Start Here Script
%  =======================================================================
%  
%  This script guides the user through examples of both simulations and
%  Wi-Fi control models for the Parrot ARDrone.
%  Authors:
%       David Escobar Sanabria -> descobar@aem.umn.edu
%       Pieter J. Mosterman -> pieter.mosterman@mathworks.com
%  =======================================================================

%%
%  Cleaning workspace
bdclose all;
clear all;
bdclose all;
clc

%%
disp('This script guides the user through examples of both simulations and');
disp('Wi-Fi control Simulink models for the Parrot ARDrone ');
disp(' '); 

disp('Swlect one of the following options:'); 
disp('    (1) Simulation'); 
disp('    (2) Wi-Fi control. The computer shoud be connected to the drone'); 

option = input('');


%%
switch option
    case 1
        
        disp('Swlect one of the following options for simulation:'); 
        disp('    (1) Baseline simulation: The ARDrone block with inputs and scopes to visualize outputs'); 
        disp('    (2) Hover: Vehicle is held at constant position'); 
        disp('    (3) Waypoint tracking: Vehicle tracks a list of waypoints'); 
        option2 = input(' ');
        
        switch option2
            case 1
                cd simulation; 
                setupBaseModel; 
            case 2
                cd simulation; 
                setupHoverSim; 
            case 3
                cd simulation; 
                setupWPTrackingSim;
            otherwise
                disp('An incorrect option was selected')
                
        end
        
        
    case 2
        disp('Swlect one of the following options for Wi-Fi control:'); 
        disp('    (1) Hover: Vehicle is held at constant position'); 
        disp('    (2) Waypoint tracking: Vehicle tracks a list of waypoints'); 
        option2 = input(' ');
        
        switch option2
            case 1
                cd wifiControl; 
                setupHover; 
                % Building model using RTWT. Install rtwt if not installed 
                % using 'rtwintgt -setup'
                rtwbuild('ARDroneHover');
            case 2
                cd wifiControl; 
                setupWPTracking;  
                % Building model using RTWT. Install rtwt if not installed 
                % using 'rtwintgt -setup'
                rtwbuild('ARDroneWPTracking');
            otherwise
                disp('An incorrect option was selected')
        end
        
    otherwise
       disp('An incorrect option was selected')

end





