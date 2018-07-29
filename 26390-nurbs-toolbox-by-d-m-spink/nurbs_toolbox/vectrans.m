function dd = vectrans(vector) 
%  
% Function Name: 
%  
%   vectrans - Transformation matrix for a translation. 
%  
% Calling Sequence: 
%  
%   st = vectrans(tvec) 
%  
% Parameters: 
%  
%   tvec	: A vectors defining the translation along the x,y and 
%                   z axes. i.e. [tx, ty, ty] 
%  
%   st		: Translation Transformation Matrix 
%  
% Description: 
%  
%   Returns a (4x4) Transformation matrix for translation. 
%  
%   The matrix is: 
%  
%         [ 1   0   0   tx ] 
%         [ 0   0   0   ty ] 
%         [ 0   0   0   tz ] 
%         [ 0   0   0   1  ] 
%  
% Examples: 
%  
%   Translate the NURBS line (0.0,0.0,0.0) - (1.0,1.0,1.0) by 3 along 
%   the x-axis, 2 along the y-axis and 4 along the z-axis. 
% 
%   line = nrbline([0.0 0.0 0.0],[1.0 1.0 1.0]); 
%   trans = vectrans([3.0 2.0 4.0]); 
%   tline = nrbtform(line, trans); 
%  
% See: 
%  
%    nrbtform 
 
%  Dr D.M. Spink 
%  Copyright (c) 2000. 
 
if nargin < 1 
  error('Translation vector required'); 
end    
 
v = [vector(:);0;0]; 
dd = [1 0 0 v(1); 0 1 0 v(2); 0 0 1 v(3); 0 0 0 1]; 
