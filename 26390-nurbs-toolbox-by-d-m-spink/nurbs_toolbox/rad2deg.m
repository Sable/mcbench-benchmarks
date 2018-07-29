function deg = rad2deg(rad) 
%  
% Function Name: 
%  
%   rad2deg - Convert radians to degrees. 
%  
% Calling Sequence: 
%  
%   rad = rad2deg(deg); 
%  
% Parameters: 
%  
%   rad		: Angle in radians. 
% 
%   deg		: Angle in degrees. 
%  
% Description: 
%  
%   Convenient utility function for converting radians to degrees, which are 
%   often the required angular units for functions in the NURBS toolbox. 
%  
% Examples: 
%  
%   Convert 0.3 radians to degrees 
%  
%   rad = deg2rad(0.3); 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
deg = 180.0*rad/pi; 
