function [pnt,jac] = nrbdeval(nurbs, dnurbs, tt) 
% Evaluation of the derivative NURBS curve or surface. 
% 
%     [pnt, jac] = nrbdeval(crv, dcrv, tt) 
%     [pnt, jac] = nrbdeval(srf, dsrf, {tu tv}) 
% 
% INPUTS: 
% 
%   crv    - original NURBS curve. 
% 
%   srf    - original NUBRS surface 
% 
%   dcrv   - NURBS derivative represention of crv 
% 
%   dsrf   - NURBS derivative represention of surface 
% 
%   tt     - parametric evaluation points 
%            If the nurbs is a surface then tt is a cell 
%            {tu, tv} are the parametric coordinates 
% 
%   pnt  - evaluated points. 
%   jac  - evaluated first derivatives (Jacobian). 
% 
% Examples: 
%  
%   // Determine the first derivatives a NURBS curve at 9 points for 0.0 to 
%   // 1.0 
%   tt = linspace(0.0, 1.0, 9); 
%   dcrv = nrbderiv(crv); 
%   [pnts,jac] = nrbdeval(crv, dcrv, tt); 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
if ~isstruct(nurbs) 
  error('NURBS representation is not structure!'); 
end 
 
if ~strcmp(nurbs.form,'B-NURBS') 
  error('Not a recognised NURBS representation'); 
end 
 
[cp,cw] = nrbeval(nurbs, tt); 
 
if iscell(nurbs.knots) 
 
  % NURBS structure represents a surface 
  temp = cw(ones(3,1),:,:); 
  pnt = cp./temp; 
   
  [cup,cuw] = nrbeval(dnurbs{1}, tt); 
  tempu = cuw(ones(3,1),:,:); 
  jac{1} = (cup-tempu.*pnt)./temp; 
   
  [cvp,cvw] = nrbeval(dnurbs{2}, tt); 
  tempv = cvw(ones(3,1),:,:); 
  jac{2} = (cvp-tempv.*pnt)./temp; 
 
else 
 
  % NURBS is a curve 
  temp = cw(ones(3,1),:); 
  pnt = cp./temp; 
   
  % first derivative 
  [cup,cuw] = nrbeval(dnurbs,tt); 
  temp1 = cuw(ones(3,1),:); 
  jac = (cup-temp1.*pnt)./temp; 
 
end 
 
