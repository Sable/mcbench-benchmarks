function dnurbs = nrbderiv(nurbs) 
%  
% Function Name: 
%  
%   nrbderiv - Construct the first derivative representation of a 
%              NURBS curve or surface. 
%  
% Calling Sequence: 
%  
%   ders = nrbderiv(nrb); 
%  
% Parameters: 
%  
%   nrb		: NURBS data structure, see nrbmak. 
%  
%   ders	: A data structure that represents the first 
% 		  derivatives of a NURBS curve or surface. 
%  
% Description: 
%  
%   The derivatives of a B-Spline are themselves a B-Spline of lower degree, 
%   giving an efficient means of evaluating multiple derivatives. However, 
%   although the same approach can be applied to NURBS, the situation for 
%   NURBS is a more complex. I have at present restricted the derivatives 
%   to just the first. I don't claim that this implentation is 
%   the best approach, but it will have to do for now. The function returns 
%   a data struture that for a NURBS curve contains the first derivatives of 
%   the B-Spline representation. Remember that a NURBS curve is represent by 
%   a univariate B-Spline using the homogeneous coordinates. 
%   The derivative data structure can be evaluated later with the function 
%   nrbdeval. 
%  
% Examples: 
%  
%   See the function nrbdeval for an example. 
%  
% See: 
%  
%       nrbdeval 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
if ~isstruct(nurbs) 
  error('NURBS representation is not structure!'); 
end 
 
if ~strcmp(nurbs.form,'B-NURBS') 
  error('Not a recognised NURBS representation'); 
end 
 
degree = nurbs.order - 1; 
 
if iscell(nurbs.knots) 
  % NURBS structure represents a surface 
 
  num1 = nurbs.number(1); 
  num2 = nurbs.number(2); 
 
  % taking derivatives along the u direction 
  dknots = nurbs.knots; 
  dcoefs = permute(nurbs.coefs,[1 3 2]); 
  dcoefs = reshape(dcoefs,4*num2,num1); 
  [dcoefs,dknots{1}] = bspderiv(degree(1),dcoefs,nurbs.knots{1}); 
  dcoefs = permute(reshape(dcoefs,[4 num2 size(dcoefs,2)]),[1 3 2]); 
  dnurbs{1} = nrbmak(dcoefs, dknots); 
 
  % taking derivatives along the v direction 
  dknots = nurbs.knots; 
  dcoefs = reshape(nurbs.coefs,4*num1,num2); 
  [dcoefs,dknots{2}] = bspderiv(degree(2),dcoefs,nurbs.knots{2}); 
  dcoefs = reshape(dcoefs,[4 num1 size(dcoefs,2)]); 
  dnurbs{2} = nrbmak(dcoefs, dknots); 
 
else 
  % NURBS structure represents a curve 
 
  [dcoefs,dknots] = bspderiv(degree,nurbs.coefs,nurbs.knots); 
  dnurbs = nrbmak(dcoefs, dknots); 
 
end 
 
 
 
