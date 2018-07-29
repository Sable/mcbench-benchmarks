function srf = nrbcoons(u1, u2, v1, v2) 
%  
% Function Name: 
%  
%   nrbcoons - Construction of a Coons patch. 
%  
% Calling Sequence: 
%  
%   srf = nrbcoons(ucrv1, ucrv2, vcrv1, vcrv2) 
%  
% Parameters: 
%  
%  ucrv1	: NURBS curve defining the bottom U direction boundary of 
% 		the constructed NURBS surface. 
%  
%   ucrv2	: NURBS curve defining the top U direction boundary of 
% 		the constructed NURBS surface. 
%  
%   vcrv1	: NURBS curve defining the bottom V direction boundary of 
% 		the constructed NURBS surface. 
%  
%   vcrv2	: NURBS curve defining the top V direction boundary of 
% 		the constructed NURBS surface. 
%  
%   srf		: Coons NURBS surface patch. 
%  
% Description: 
%  
%   Construction of a bilinearly blended Coons surface patch from four NURBS 
%   curves that define the boundary. 
%  
%   The orientation of the four NURBS boundary curves. 
%  
%          ^ V direction 
%          | 
%          |     ucrv2 
%          ------->-------- 
%          |              | 
%          |              | 
%    vcrv1 ^   Surface    ^ vcrv2 
%          |              | 
%          |              | 
%          ------->-----------> U direction 
%                ucrv1 
%  
%  
% Examples: 
%  
%   // Define four NURBS curves and construct a Coons surface patch. 
%   pnts = [ 0.0  3.0  4.5  6.5 8.0 10.0; 
%            0.0  0.0  0.0  0.0 0.0  0.0;  
%            2.0  2.0  7.0  4.0 7.0  9.0];    
%   crv1 = nrbmak(pnts, [0 0 0 1/3 0.5 2/3 1 1 1]); 
%  
%   pnts= [ 0.0  3.0  5.0  8.0 10.0; 
%           10.0 10.0 10.0 10.0 10.0; 
%           3.0  5.0  8.0  6.0 10.0]; 
%   crv2 = nrbmak(pnts, [0 0 0 1/3 2/3 1 1 1]); 
%  
%   pnts= [ 0.0 0.0 0.0 0.0; 
%           0.0 3.0 8.0 10.0; 
%           2.0 0.0 5.0 3.0]; 
%   crv3 = nrbmak(pnts, [0 0 0 0.5 1 1 1]); 
%  
%   pnts= [ 10.0 10.0 10.0 10.0 10.0; 
%           0.0   3.0  5.0  8.0 10.0; 
%           9.0   7.0  7.0 10.0 10.0]; 
%   crv4 = nrbmak(pnts, [0 0 0 0.25 0.75 1 1 1]); 
%  
%   srf = nrbcoons(crv1, crv2, crv3, crv4); 
%   nrbplot(srf,[20 20],220,45); 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
if nargin ~= 4 
  error('Incorrect number of input arguments'); 
end 
 
r1 = nrbruled(u1, u2); 
r2 = nrbtransp(nrbruled(v1, v2)); 
t  = nrb4surf(u1.coefs(:,1), u1.coefs(:,end), u2.coefs(:,1), u2.coefs(:,end)); 
 
% raise all surfaces to a common degree 
du = max([r1.order(1), r2.order(1), t.order(1)]); 
dv = max([r1.order(2), r2.order(2), t.order(2)]); 
r1 = nrbdegelev(r1, [du - r1.order(1), dv - r1.order(2)]); 
r2 = nrbdegelev(r2, [du - r2.order(1), dv - r2.order(2)]); 
t  = nrbdegelev(t,  [du - t.order(1),  dv - t.order(2)]); 
 
% merge the knot vectors, to obtain a common knot vector 
 
% U knots 
k1 = r1.knots{1}; 
k2 = r2.knots{1}; 
k3 = t.knots{1}; 
k = unique([k1 k2 k3]); 
n = length(k); 
kua = []; 
kub = []; 
kuc = []; 
for i = 1:n 
  i1 = length(find(k1 == k(i))); 
  i2 = length(find(k2 == k(i))); 
  i3 = length(find(k3 == k(i))); 
  m = max([i1, i2, i3]); 
  kua = [kua k(i)*ones(1,m-i1)];   
  kub = [kub k(i)*ones(1,m-i2)]; 
  kuc = [kuc k(i)*ones(1,m-i3)]; 
end   
 
% V knots 
k1 = r1.knots{2}; 
k2 = r2.knots{2}; 
k3 = t.knots{2}; 
k = unique([k1 k2 k3]); 
n = length(k); 
kva = []; 
kvb = []; 
kvc = []; 
for i = 1:n 
  i1 = length(find(k1 == k(i))); 
  i2 = length(find(k2 == k(i))); 
  i3 = length(find(k3 == k(i))); 
  m = max([i1, i2, i3]); 
  kva = [kva k(i)*ones(1,m-i1)];   
  kvb = [kvb k(i)*ones(1,m-i2)]; 
  kvc = [kvc k(i)*ones(1,m-i3)]; 
end   
 
r1 = nrbkntins(r1, {kua, kva}); 
r2 = nrbkntins(r2, {kub, kvb}); 
t  = nrbkntins(t,  {kuc, kvc}); 
 
% combine coefficient to construct Coons surface 
coefs(1,:,:) = r1.coefs(1,:,:) + r2.coefs(1,:,:) - t.coefs(1,:,:); 
coefs(2,:,:) = r1.coefs(2,:,:) + r2.coefs(2,:,:) - t.coefs(2,:,:); 
coefs(3,:,:) = r1.coefs(3,:,:) + r2.coefs(3,:,:) - t.coefs(3,:,:); 
coefs(4,:,:) = r1.coefs(4,:,:) + r2.coefs(4,:,:) - t.coefs(4,:,:); 
srf = nrbmak(coefs, r1.knots); 
