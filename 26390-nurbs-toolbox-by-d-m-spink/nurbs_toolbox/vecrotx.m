function rx = vecrotx(angle) 
%  
% Function Name: 
%  
%   vecrotx - Transformation matrix for a rotation around the x axis.  
%  
% Calling Sequence: 
%  
%   rx = vecrotx(angle); 
%  
% Parameters: 
%  
%   angle		: rotation angle defined in radians 
%  
%   rx		: (4x4) Transformation matrix. 
%  
%  
% Description: 
%  
%   Return the (4x4) Transformation matrix for a rotation about the x axis 
%   by the defined angle. 
%  
%   The matrix is: 
%  
%         [ 1         0            0          0] 
%         [ 0     cos(angle)  -sin(angle)     0] 
%         [ 0     sin(angle)   cos(angle)     0] 
%         [ 0         0            0          1] 
%  
% Examples: 
%  
%    Rotate the NURBS line (0.0 0.0 0.0) - (3.0 3.0 3.0) by 45 degrees 
%    around the x-axis 
%  
%    line = nrbline([0.0 0.0 0.0],[3.0 3.0 3.0]); 
%    trans = vecrotx(%pi/4); 
%    rline = nrbtform(line, trans); 
%  
% See: 
%  
%    nrbtform 
 
%  Dr D.M. Spink 
%  Copyright (c) 2000. 
 
sn = sin(angle); 
cn = cos(angle); 
rx = [1 0 0 0; 0 cn -sn 0; 0 sn cn 0; 0 0 0 1]; 
