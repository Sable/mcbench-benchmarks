function ry = vecroty(angle) 
%  
% Function Name: 
%  
%   vecroty - Transformation matrix for a rotation around the y axis.  
%  
% Calling Sequence: 
%  
%   ry = vecroty(angle); 
%  
% Parameters: 
%  
%   angle		: rotation angle defined in radians 
%  
%   ry		: (4x4) Transformation matrix. 
%  
%  
% Description: 
%  
%   Return the (4x4) Transformation matrix for a rotation about the y axis 
%   by the defined angle. 
%  
%   The matrix is: 
%  
%         [  cos(angle)       0        sin(angle)       0] 
%         [      0            1            0            0] 
%         [ -sin(angle)       0        cos(angle)       0] 
%         [      0            0            0            1] 
%  
% Examples: 
%  
%    Rotate the NURBS line (0.0 0.0 0.0) - (3.0 3.0 3.0) by 45 degrees 
%    around the y-axis 
%  
%    line = nrbline([0.0 0.0 0.0],[3.0 3.0 3.0]); 
%    trans = vecroty(%pi/4); 
%    rline = nrbtform(line, trans); 
%  
% See: 
%  
%    nrbtform 
 
%  Dr D.M. Spink 
%  Copyright (c) 2000. 
 
sn = sin(angle); 
cn = cos(angle); 
ry = [cn 0 sn 0; 0 1 0 0; -sn 0 cn 0; 0 0 0 1]; 
