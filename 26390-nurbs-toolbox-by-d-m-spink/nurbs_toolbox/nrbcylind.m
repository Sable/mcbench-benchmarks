function surf = nrbcylind(height,radius,center,sang,eang) 
%  
% Function Name: 
%  
%   nrbcylind - Construct a cylinder or cylindrical patch. 
%  
% Calling Sequence: 
%  
%   srf = nrbcylind() 
%   srf = nrbcylind(height) 
%   srf = nrbcylind(height,radius) 
%   srf = nrbcylind(height,radius,center) 
%   srf = nrbcylind(height,radius,center,sang,eang) 
%  
% Parameters: 
%  
%   height	: Height of the cylinder along the axis, default 1.0 
%  
%   radius	: Radius of the cylinder, default 1.0 
%  
%   center	: Center of the cylinder, default (0,0,0) 
%  
%   sang        : Start angle relative to the origin, default 0. 
%  
%   eang	: End angle relative to the origin, default 2*pi. 
%  
%  
% Description: 
%  
%   Construct a cylinder or cylindrical patch by extruding a circular arc. 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
if nargin < 1 
  height = 1; 
end 
 
if nargin < 2 
  radius = 1; 
end 
 
if nargin < 3 
  center = []; 
end 
    
if nargin < 5 
  sang = 0; 
  eang = 2*pi; 
end 
 
surf = nrbextrude(nrbcirc(radius,center,sang,eang),[0.0 0.0 height]); 
