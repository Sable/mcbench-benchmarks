function [p,w] = nrbeval(nurbs,tt) 
%  
% Function Name: 
%  
%   nrbeval - Evaluate a NURBS at parameteric points 
%  
% Calling Sequence: 
%  
%   [p,w] = nrbeval(crv,ut) 
%   [p,w] = nrbeval(srf,{ut,vt}) 
%  
% Parameters: 
%  
%   crv		: NURBS curve, see nrbmak. 
%  
%   srf		: NURBS surface, see nrbmak. 
%  
%   ut		: Parametric evaluation points along U direction. 
% 
%   vt		: Parametric evaluation points along V direction. 
%  
%   p		: Evaluated points on the NURBS curve or surface as cartesian 
% 		coordinates (x,y,z). If w is included on the lhs argument list 
% 		the points are returned as homogeneous coordinates (wx,wy,wz). 
%  
%   w		: Weights of the homogeneous coordinates of the evaluated 
% 		points. Note inclusion of this argument changes the type  
% 		of coordinates returned in p (see above). 
%  
% Description: 
%  
%   Evaluation of NURBS curves or surfaces at parametric points along the  
%   U and V directions. Either homogeneous coordinates are returned if the  
%   weights are requested in the lhs arguments, or as cartesian coordinates. 
%   This function utilises the 'C' interface bspeval. 
%  
% Examples: 
%  
%   Evaluate the NURBS circle at twenty points from 0.0 to 1.0 
%  
%   nrb = nrbcirc; 
%   ut = linspace(0.0,1.0,20); 
%   p = nrbeval(nrb,ut); 
%  
% See: 
%   
%     bspeval 
% 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
if nargin < 2 
  error('Not enough input arguments'); 
end 
 
foption = 1;    % output format 3D cartesian coordinates 
if nargout == 2 
  foption = 0;  % output format 4D homogenous coordinates  
end 
    
if ~isstruct(nurbs) 
  error('NURBS representation is not structure!'); 
end 
 
if ~strcmp(nurbs.form,'B-NURBS') 
  error('Not a recognised NURBS representation'); 
end 
 
if iscell(nurbs.knots) 
  % NURBS structure represents a surface 
 
  num1 = nurbs.number(1); 
  num2 = nurbs.number(2); 
  degree = nurbs.order-1; 
 
  if iscell(tt) 
    % Evaluate over a [u,v] grid 
    % tt{1} represents the u direction 
    % tt{2} represents the v direction 
 
    nt1 = length(tt{1}); 
    nt2 = length(tt{2}); 
     
    % Evaluate along the v direction 
    val = reshape(nurbs.coefs,4*num1,num2); 
    val = bspeval(degree(2),val,nurbs.knots{2},tt{2}); 
    val = reshape(val,[4 num1 nt2]); 
     
    % Evaluate along the u direction 
    val = permute(val,[1 3 2]); 
    val = reshape(val,4*nt2,num1); 
    val = bspeval(degree(1),val,nurbs.knots{1},tt{1}); 
    val = reshape(val,[4 nt2 nt1]); 
    val = permute(val,[1 3 2]); 
 
    w = val(4,:,:); 
    p = val(1:3,:,:); 
    if foption 
      p = p./repmat(w,[3 1 1]); 
    end 
 
  else 
 
    % Evaluate at scattered points 
    % tt(1,:) represents the u direction 
    % tt(2,:) represents the v direction 
 
    nt = size(tt,2); 
 
    val = reshape(nurbs.coefs,4*num1,num2); 
    val = bspeval(degree(2),val,nurbs.knots{2},tt(2,:)); 
    val = reshape(val,[4 num1 nt]); 
 
 
    % evaluate along the u direction 
    pnts = zeros(4,nt); 
    for v = 1:nt 
      coefs = squeeze(val(:,:,v)); 
      pnts(:,v) = bspeval(degree(1),coefs,nurbs.knots{1},tt(1,v)); 
    end 
 
    w = pnts(4,:); 
    p = pnts(1:3,:); 
    if foption 
       p = p./w; 
    end 
         
  end 
 
else 
 
  % NURBS structure represents a curve 
  %  tt represent a vector of parametric points in the u direction 
 
  val = bspeval(nurbs.order-1,nurbs.coefs,nurbs.knots,tt);    
 
  w = val(4,:); 
  p = val(1:3,:); 
  if foption 
    p = p./repmat(w,3,1); 
  end 
 
end 
 
 
