%% ========================================================================
%  ARDrone Transfer Functions Loading 
%  ========================================================================
%
%  This script initializes trasnfer functions and state space
%  representations of the ARDrone vehicle dynamics. 
%
%  Requirements:
%       Matlab
%
%  Authors:
%       David Escobar Sanabria -> descobar@aem.umn.edu
%       Pieter J. Mosterman -> pieter.mosterman@mathworks.com
%       
%  ========================================================================



%%
load tfRollAng3 ;
ssRoll = ss(tfRollAng3) ; 

load tfRoll2V ;
ssRoll2V = ss(tfRoll2V) ; 

load tfPitchAng3 ;
ssPitch = ss(tfPitchAng3) ; 

load tfPitch2U ;
ssPitch2U = ss(tfPitch2U) ; 

load tfYaw ;
ssYaw = ss(tfYaw) ; 

load tfH ;
ssH = ss(tfH) ; 
