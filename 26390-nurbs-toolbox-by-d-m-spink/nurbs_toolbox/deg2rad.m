function rad = deg2rad(deg) 
%  
% Function Name: 
%  
%   deg2rad - Convert degrees to radians. 
%  
% Calling Sequence: 
%  
%   rad = deg2rad(deg); 
%  
% Parameters: 
%  
%   deg		: Angle in degrees. 
%  
%   rad		: Angle in radians.  
%  
% Description: 
%  
%   Convenient utility function for converting degrees to radians, which are 
%   often the required angular units for functions in the NURBS toolbox. 
%  
% Examples: 
%  
%   // Convert 35 degrees to radians 
%   rad = deg2rad(35); 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
rad = pi*deg/180.0; 
 