function curve = nrbline(p1,p2) 
%  
% Function Name: 
%  
%   nrbline - Construct a straight line. 
%  
% Calling Sequence: 
%  
%   crv = nrbline() 
%   crv = nrbline(p1,p2) 
%  
% Parameters: 
%  
% p1		: 2D or 3D cartesian coordinate of the start point. 
%  
% p2            : 2D or 3D cartesian coordinate of the end point. 
%  
% crv		: NURBS curve for a straight line. 
%  
% Description: 
%  
%   Constructs NURBS data structure for a straight line. If no rhs  
%   coordinates are included the function returns a unit straight 
%   line along the x-axis. 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
coefs = [zeros(3,2); ones(1,2)]; 
 
if nargin < 2 
  coefs(1,2) = 1.0;   
else 
  coefs(1:length(p1),1) = p1(:);     
  coefs(1:length(p2),2) = p2(:); 
end 
 
curve = nrbmak(coefs, [0 0 1 1]); 
