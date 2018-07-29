function inurbs = nrbkntins(nurbs,iknots) 
%  
% Function Name: 
%  
%   nrbkntins - Insert a single or multiple knots into a NURBS curve or 
%               surface. 
%  
% Calling Sequence: 
%  
%   icrv = nrbkntins(crv,iuknots); 
%   isrf = nrbkntins(srf,{iuknots ivknots}); 
%  
% Parameters: 
%  
%   crv		: NURBS curve, see nrbmak. 
%  
%   srf		: NURBS surface, see nrbmak. 
%  
%   iuknots	: Knots to be inserted along U direction. 
%  
%   ivknots	: Knots to be inserted along V direction. 
%  
%   icrv	: new NURBS structure for a curve with knots inserted. 
%  
%   isrf	: new NURBS structure for a surface with knots inserted. 
%  
% Description: 
%  
%   Inserts knots into the NURBS data structure, these can be knots at 
%   new positions or at the location of existing knots to increase the 
%   multiplicity. Note that the knot multiplicity cannot be increased 
%   beyond the order of the spline. Knots along the V direction can only 
%   inserted into NURBS surfaces, not curve that are always defined along 
%   the U direction. This function use the B-Spline function bspkntins, 
%   which interfaces to an internal 'C' routine. 
%  
% Examples: 
%  
%   Insert two knots into a curve, one at 0.3 and another 
%   twice at 0.4 
% 
%   icrv = nrbkntins(crv, [0.3 0.4 0.4]) 
%  
%   Insert into a surface two knots as (1) into the U knot 
%   sequence and one knot into the V knot sequence at 0.5. 
% 
%   isrf = nrbkntins(srf, {[0.3 0.4 0.4] [0.5]}) 
%  
% Also see: 
%  
%   bspkntins 
% 
% Note: 
% 
%   No knot multiplicity will be increased beyond the order of the spline. 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
if nargin < 2 
  error('Input argument must include the NURBS and knots to be inserted'); 
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
  num1 = nurbs.number(1); 
  num2 = nurbs.number(2); 
 
  % Insert knots along the v direction 
  if isempty(iknots{2}) 
    coefs = nurbs.coefs; 
    knots{2} = nurbs.knots{2}; 
  else 
    coefs = reshape(nurbs.coefs,4*num1,num2); 
    [coefs,knots{2}] = bspkntins(degree(2),coefs,nurbs.knots{2},iknots{2}); 
    num2 = size(coefs,2); 
    coefs = reshape(coefs,[4 num1 num2]); 
  end 
 
  % Insert knots along the u direction 
  if isempty(iknots{1}) 
    knots{1} = nurbs.knots{1}; 
  else    
    coefs = permute(coefs,[1 3 2]); 
    coefs = reshape(coefs,4*num2,num1); 
    [coefs,knots{1}] = bspkntins(degree(1),coefs,nurbs.knots{1},iknots{1}); 
    coefs = reshape(coefs,[4 num2 size(coefs,2)]); 
    coefs = permute(coefs,[1 3 2]); 
  end 
else 
 
  % NURBS represents a curve 
  if isempty(iknots) 
    coefs = nurbs.coefs; 
    knots = nurbs.knots; 
  else 
    [coefs,knots] = bspkntins(degree,nurbs.coefs,nurbs.knots,iknots);   
  end 
 
end 
 
% construct new NURBS 
inurbs = nrbmak(coefs,knots);  
 
 
 
 
 
 
