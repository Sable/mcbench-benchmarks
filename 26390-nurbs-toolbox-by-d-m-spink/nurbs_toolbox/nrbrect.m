function curve = nrbrect(w,h) 
%  
% Function Name: 
%  
%   nrbrect - Construct NURBS representation of a rectangle. 
%  
% Calling Sequence: 
%  
%   crv = nrbrect() 
%   crv = nrbrect(size) 
%   crv = nrbrect(width, height) 
%  
% Parameters: 
%  
%   size		: Size of the square (width = height). 
%  
%   width		: Width of the rectangle (along x-axis). 
%  
%   height	: Height of the rectangle (along y-axis). 
%  
%   crv		: NURBS curve, see nrbmak.  
%   
%  
% Description: 
%  
%   Construct a rectangle or square in the x-y plane with the bottom 
%   lhs corner at (0,0,0). If no rhs arguments provided the function 
%   constructs a unit square. 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
if nargin < 1 
   w = 1; 
   h = 1; 
end 
 
if nargin < 2 
   h = w; 
end 
 
coefs  = [0 w w w w 0 0 0; 
          0 0 0 h h h h 0; 
          0 0 0 0 0 0 0 0; 
          1 1 1 1 1 1 1 1]; 
 
knots  = [0 0 0.25 0.25 0.5 0.5 0.75 0.75 1 1]; 
 
curve = nrbmak(coefs, knots); 
