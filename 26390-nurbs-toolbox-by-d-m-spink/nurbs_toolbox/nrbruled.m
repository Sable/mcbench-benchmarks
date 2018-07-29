function srf = nrbruled(crv1, crv2) 
%  
% Function Name: 
%  
%   nrbruled - Constructs a ruled surface between two NURBS curves. 
%  
% Calling Sequence: 
%  
%   srf = nrbruled(crv1, crv2) 
%  
% Parameters: 
%  
%   crv1		: First NURBS curve, see nrbmak. 
%  
%   crv2		: Second NURBS curve, see nrbmak. 
%  
%   srf		: Ruled NURBS surface. 
%  
% Description: 
%  
%   Constructs a ruled surface between two NURBS curves. The ruled surface is 
%   ruled along the V direction. 
%  
% Examples: 
%  
%   Construct a ruled surface between a semicircle and a straight line. 
%  
%   cir = nrbcirc(1,[0 0 0],0,pi); 
%   line = nrbline([-1 0.5 1],[1 0.5 1]); 
%   srf = nrbruled(cir,line); 
%   nrbplot(srf,[20 20]); 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
if iscell(crv1.knots) | iscell(crv2.knots) 
  error('Both NURBS must be curves'); 
end 
 
% ensure both curves have a common degree 
d = max([crv1.order, crv2.order]); 
crv1 = nrbdegelev(crv1, d - crv1.order); 
crv2 = nrbdegelev(crv2, d - crv2.order); 
 
% merge the knot vectors, to obtain a common knot vector 
k1 = crv1.knots; 
k2 = crv2.knots; 
ku = unique([k1 k2]); 
n = length(ku); 
ka = []; 
kb = []; 
for i = 1:n 
  i1 = length(find(k1 == ku(i))); 
  i2 = length(find(k2 == ku(i))); 
  m = max(i1, i2); 
  ka = [ka ku(i)*ones(1,m-i1)]; 
  kb = [kb ku(i)*ones(1,m-i2)]; 
end 
crv1 = nrbkntins(crv1, ka); 
crv2 = nrbkntins(crv2, kb); 
 
coefs(:,:,1) = crv1.coefs; 
coefs(:,:,2) = crv2.coefs; 
srf = nrbmak(coefs, {crv1.knots [0 0 1 1]}); 
