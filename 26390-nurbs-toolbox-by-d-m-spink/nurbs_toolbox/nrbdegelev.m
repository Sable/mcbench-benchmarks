function inurbs = nrbdegelev(nurbs, ntimes) 
%  
% Function Name: 
%  
%   nrbdegelev - Elevate the degree of the NURBS curve or surface. 
%  
% Calling Sequence: 
%  
%   ecrv = nrbdegelev(crv,utimes); 
%   esrf = nrbdegelev(srf,{utimes,vtimes}); 
%  
% Parameters: 
%  
%   crv		: NURBS curve, see nrbmak. 
%  
%   srf		: NURBS surface, see nrbmak. 
%  
%   utimes	: Increase the degree along U direction utimes. 
%  
%   vtimes	: Increase the degree along V direction vtimes. 
%  
%   ecrv	: new NURBS structure for a curve with degree elevated. 
%  
%   esrf        : new NURBS structure for a surface with degree elevated. 
%  
%  
% Description: 
%  
%   Degree elevates the NURBS curve or surface. This function uses the 
%   B-Spline function bspdegelev, which interface to an internal 'C' 
%   routine. 
%  
% Examples: 
%  
%   Increase the NURBS surface twice along the V direction. 
%   esrf = nrbdegelev(srf, 0, 1);  
%  
% See: 
%  
%   bspdegelev 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
if nargin < 2 
  error('Input argument must include the NURBS and degree increment.'); 
end 
 
if ~isstruct(nurbs) 
  error('NURBS representation is not structure!'); 
end 
 
if ~strcmp(nurbs.form,'B-NURBS') 
  error('Not a recognised NURBS representation'); 
end 
 
degree = nurbs.order-1; 
 
if iscell(nurbs.knots) 
  % NURBS represents a surface 
  [dim,num1,num2] = size(nurbs.coefs); 
 
  % Degree elevate along the v direction 
  if ntimes(2) == 0 
    coefs = nurbs.coefs; 
    knots{2} = nurbs.knots{2}; 
  else 
    coefs = reshape(nurbs.coefs,4*num1,num2); 
    [coefs,knots{2}] = bspdegelev(degree(2),coefs,nurbs.knots{2},ntimes(2)); 
    num2 = size(coefs,2); 
    coefs = reshape(coefs,[4 num1 num2]); 
  end 
 
  % Degree elevate along the u direction 
  if ntimes(1) == 0 
    knots{1} = nurbs.knots{1}; 
  else 
    coefs = permute(coefs,[1 3 2]); 
    coefs = reshape(coefs,4*num2,num1); 
    [coefs,knots{1}] = bspdegelev(degree(1),coefs,nurbs.knots{1},ntimes(1)); 
    coefs = reshape(coefs,[4 num2 size(coefs,2)]); 
    coefs = permute(coefs,[1 3 2]); 
  end  
   
else 
 
  % NURBS represents a curve 
  if isempty(ntimes) 
    coefs = nurbs.coefs; 
    knots = nurbs.knots; 
  else 
    [coefs,knots] = bspdegelev(degree,nurbs.coefs,nurbs.knots,ntimes); 
  end 
   
end 
 
% construct new NURBS 
inurbs = nrbmak(coefs,knots); 
