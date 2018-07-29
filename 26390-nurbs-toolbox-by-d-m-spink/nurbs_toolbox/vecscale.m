function ss = vecscale(vector) 
% 
% Function Name: 
%  
%   vecscale - Transformation matrix for a scaling. 
%  
% Calling Sequence: 
%  
%   ss = vecscale(svec) 
%  
% Parameters: 
%  
%   svec    : A vectors defining the scaling along the x,y and z axes. 
%             i.e. [sx, sy, sy] 
%  
%   ss	    : Scaling Transformation Matrix 
%  
% Description: 
%  
%   Returns a (4x4) Transformation matrix for scaling. 
%  
%   The matrix is: 
%  
%         [ sx  0   0   0] 
%         [ 0   sy  0   0] 
%         [ 0   0   sz  0] 
%         [ 0   0   0   1] 
%  
% Example: 
%  
%   Scale up the NURBS line (0.0,0.0,0.0) - (1.0,1.0,1.0) by 3 along 
%   the x-axis, 2 along the y-axis and 4 along the z-axis. 
%  
%   line = nrbline([0.0 0.0 0.0],[1.0 1.0 1.0]); 
%   trans = vecscale([3.0 2.0 4.0]); 
%   sline = nrbtform(line, trans); 
%  
% See: 
%  
%    nrbtform 
 
%  Dr D.M. Spink 
%  Copyright (c) 2000. 
 
if nargin < 1 
  error('Scaling vector not specified'); 
end    
 
s = [vector(:);0;0]; 
ss = [s(1) 0 0 0; 0 s(2) 0 0; 0 0 s(3) 0; 0 0 0 1]; 
