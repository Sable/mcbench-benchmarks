function srf = nrbextrude(curve,vector) 
% 
% Function Name: 
%  
%   nrbextrude - Construct a NURBS surface by extruding a NURBS curve. 
%  
% Calling Sequence: 
%  
%   srf = nrbextrude(crv,vec); 
%  
% Parameters: 
%  
%   crv		: NURBS curve to extrude, see nrbmak. 
%  
%   vec		: Vector along which the curve is extruded. 
%  
%   srf		: NURBS surface constructed. 
%  
% Description: 
%  
%   Constructs a NURBS surface by extruding a NURBS curve along a defined  
%   vector. The NURBS curve forms the U direction of the surface edge, and 
%   extruded along the vector in the V direction. Note NURBS surfaces cannot 
%   be extruded. 
%  
% Examples: 
%  
%   Form a hollow cylinder by extruding a circle along the z-axis. 
% 
%   srf = nrbextrude(nrbcirc, [0,0,1]); 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
if iscell(curve.knots) 
  error('Nurb surfaces cannot be extruded!'); 
end 
 
if nargin < 2 
  error('Error too few input arguments!'); 
end 
 
if nargin == 3 
  dz = 0.0; 
end 
 
coefs = cat(3,curve.coefs,vectrans(vector)*curve.coefs); 
srf = nrbmak(coefs,{curve.knots [0 0 1 1]}); 
 
