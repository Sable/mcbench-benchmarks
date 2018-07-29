function nurbs = nrbmak(coefs,knots) 
% 
% Function Name: 
%  
%   nrbmak - Construct the NURBS structure given the control points 
%            and the knots. 
%  
% Calling Sequence: 
%  
%   nurbs   = nrbmak(cntrl,knots); 
%  
% Parameters: 
%  
%   cntrl       : Control points, these can be either Cartesian or 
% 		homogeneous coordinates. 
%  
% 		For a curve the control points are represented by a 
% 		matrix of size (dim,nu) and for a surface a multidimensional 
% 		array of size (dim,nu,nv). Where nu is number of points along 
% 		the parametric U direction, and nv the number of points 
%               along the V direction. Dim is the dimension valid options 
% 		are 
% 		2 .... (x,y)        2D Cartesian coordinates 
% 		3 .... (x,y,z)      3D Cartesian coordinates 
% 		4 .... (wx,wy,wz,w) 4D homogeneous coordinates 
%  
%   knots	: Non-decreasing knot sequence spanning the interval 
%               [0.0,1.0]. It's assumed that the curves and surfaces 
%               are clamped to the start and end control points by knot 
%               multiplicities equal to the spline order. 
%               For curve knots form a vector and for a surface the knot 
%               are stored by two vectors for U and V in a cell structure. 
%               {uknots vknots} 
%                
%   nurbs 	: Data structure for representing a NURBS curve. 
%  
% NURBS Structure: 
%  
%   Both curves and surfaces are represented by a structure that is 
%   compatible with the Spline Toolbox from Mathworks 
%  
% 	nurbs.form   .... Type name 'B-NURBS' 
% 	nurbs.dim    .... Dimension of the control points 
% 	nurbs.number .... Number of Control points 
%       nurbs.coefs  .... Control Points 
%       nurbs.order  .... Order of the spline 
%       nurbs.knots  .... Knot sequence 
%  
%   Note: the control points are always converted and stored within the 
%   NURBS structure as 4D homogeneous coordinates. A curve is always stored  
%   along the U direction, and the vknots element is an empty matrix. For 
%   a surface the spline degree is a vector [du,dv] containing the degree 
%   along the U and V directions respectively. 
%  
% Description: 
%  
%   This function is used as a convenient means of constructing the NURBS 
%   data structure. Many of the other functions in the toolbox rely on the  
%   NURBS structure been correctly defined as shown above. The nrbmak not 
%   only constructs the proper structure, but also checks for consistency. 
%   The user is still free to build his own structure, in fact a few 
%   functions in the toolbox do this for convenience. 
%  
% Examples: 
%  
%   Construct a 2D line from (0.0,0.0) to (1.5,3.0). 
%   For a straight line a spline of order 2 is required. 
%   Note that the knot sequence has a multiplicity of 2 at the 
%   start (0.0,0.0) and end (1.0 1.0) in order to clamp the ends. 
%  
%   line = nrbmak([0.0 1.5; 0.0 3.0],[0.0 0.0 1.0 1.0]); 
%   nrbplot(line, 2); 
%  
%   Construct a surface in the x-y plane i.e 
%      
%     ^  (0.0,1.0) ------------ (1.0,1.0) 
%     |      |                      | 
%     | V    |                      | 
%     |      |      Surface         | 
%     |      |                      | 
%     |      |                      | 
%     |  (0.0,0.0) ------------ (1.0,0.0) 
%     | 
%     |------------------------------------> 
%                                       U  
% 
%   coefs = cat(3,[0 0; 0 1],[1 1; 0 1]); 
%   knots = {[0 0 1 1]  [0 0 1 1]} 
%   plane = nrbmak(coefs,knots); 
%   nrbplot(plane, [2 2]); 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
nurbs.form   = 'B-NURBS'; 
nurbs.dim    = 4; 
np = size(coefs); 
dim = np(1); 
if iscell(knots) 
  % constructing a surface  
  nurbs.number = np(2:3); 
  if (dim < 4) 
    nurbs.coefs = repmat([0.0 0.0 0.0 1.0]',[1 np(2:3)]); 
    nurbs.coefs(1:dim,:,:) = coefs;   
  else 
    nurbs.coefs = coefs; 
  end 
  uorder = size(knots{1},2)-np(2); 
  vorder = size(knots{2},2)-np(3); 
  uknots = sort(knots{1}); 
  vknots = sort(knots{2}); 
  uknots = (uknots-uknots(1))/(uknots(end)-uknots(1)); 
  vknots = (vknots-vknots(1))/(vknots(end)-vknots(1)); 
  nurbs.knots = {uknots vknots}; 
  nurbs.order = [uorder vorder]; 
 
else 
 
  % constructing a curve 
  nurbs.number = np(2); 
  if (dim < 4) 
    nurbs.coefs = repmat([0.0 0.0 0.0 1.0]',[1 np(2)]); 
    nurbs.coefs(1:dim,:) = coefs;   
  else 
    nurbs.coefs = coefs; 
  end 
  nurbs.order = size(knots,2)-np(2); 
  knots = sort(knots); 
  nurbs.knots = (knots-knots(1))/(knots(end)-knots(1)); 
 
end 
 
 
 
