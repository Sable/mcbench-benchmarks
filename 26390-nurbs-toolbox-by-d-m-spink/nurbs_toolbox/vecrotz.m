function rz = vecrotz(angle) 
%  
% Function Name: 
%  
%   vecrotz - Transformation matrix for a rotation around the z axis.  
%  
% Calling Sequence: 
%  
%   rz = vecrotz(angle); 
%  
% Parameters: 
%  
%   angle	: rotation angle defined in radians 
%  
%   rz		: (4x4) Transformation matrix. 
%  
%  
% Description: 
%  
%   Return the (4x4) Transformation matrix for a rotation about the z axis 
%   by the defined angle. 
%  
%   The matrix is: 
%  
%         [  cos(angle)  -sin(angle)       0          0] 
%         [ -sin(angle)   cos(angle)       0          0] 
%         [      0            0            1          0] 
%         [      0            0            0          1] 
%  
% Examples: 
%  
%  Rotate the NURBS line (0.0 0.0 0.0) - (3.0 3.0 3.0) by 45 degrees 
%  around the z-axis 
%  
%    line = nrbline([0.0 0.0 0.0],[3.0 3.0 3.0]); 
%    trans = vecrotz(%pi/4); 
%    rline = nrbtform(line, trans); 
%  
% See: 
%  
%    nrbtform 
 
%  Dr D.M. Spink 
%  Copyright (c) 2000. 
 
sn = sin(angle); 
cn = cos(angle); 
rz = [cn -sn 0 0; sn cn 0 0; 0 0 1 0; 0 0 0 1]; 
