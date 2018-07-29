function nurbs = nrbtform(nurbs,tmat) 
%  
% Function Name: 
%  
%   nrbtform - Apply transformation matrix to the NURBS. 
%  
% Calling Sequence: 
%  
%   tnurbs = nrbtform(nurbs,tmatrix); 
%  
% Parameters: 
%  
%   nurbs	: NURBS data structure (see nrbmak for details). 
%  
%   tmatrix     : Transformation matrix, a matrix of size (4,4) defining 
%                 a single or multiple transformations. 
%  
%   tnurbs	: The return transformed NURBS data structure. 
%  
% Description: 
%  
%   The NURBS is transform as defined a transformation matrix of size (4,4), 
%   such as a rotation, translation or change in scale. The transformation 
%   matrix can define a single transformation or multiple series of 
%   transformations. The matrix can be simple constructed by the functions 
%   vecscale, vectrans, vecrotx, vecroty, and vecrotz. 
%      
% Examples: 
%  
%   Rotate a square by 45 degrees about the z axis. 
% 
%   rsqr = nrbtform(nrbrect(), vecrotz(deg2rad(45))); 
%   nrbplot(rsqr, 10); 
%  
% See: 
%  
%   vecscale, vectrans, vecrotx, vecroty, vecrotz 
 
%  D.M. Spink 
%  Copyright (c) 2000 
 
if nargin < 2 
  error('Not enough input arguments!'); 
end; 
 
if iscell(nurbs.knots) 
  % NURBS is a surface 
  [dim,nu,nv] = size(nurbs.coefs); 
  nurbs.coefs = reshape(tmat*reshape(nurbs.coefs,dim,nu*nv),[dim nu nv]); 
else 
  % NURBS is a curve 
  nurbs.coefs = tmat*nurbs.coefs; 
end 
