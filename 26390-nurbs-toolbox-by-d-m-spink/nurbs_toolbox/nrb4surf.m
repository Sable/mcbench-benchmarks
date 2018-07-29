function srf = nrb4surf(p11,p12,p21,p22) 
%  
% Function Name: 
%  
%   nrb4surf - Constructs a NURBS bilinear surface. 
%  
% Calling Sequence: 
%  
%   srf = nrb4surf(p11,p12,p21,p22) 
%  
% Parameters: 
%  
%   p11		: Cartesian coordinate of the lhs bottom corner point. 
%  
%   p12		: Cartesian coordinate of the rhs bottom corner point. 
%  
%   p21		: Cartesian coordinate of the lhs top corner point. 
%   
%   p22		: Cartesian coordinate of the rhs top corner point. 
%  
%   srf		: NURBS bilinear surface, see nrbmak.  
%  
% Description: 
%  
%   Constructs a bilinear surface defined by four coordinates. 
%  
%   The position of the corner points 
%  
%          ^ V direction 
%          | 
%          ---------------- 
%          |p21        p22| 
%          |              | 
%          |    SRF       | 
%          |              | 
%          |p11        p12| 
%          -------------------> U direction 
%  
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
if nargin < 4 
  error('Four corner points must be defined');  
end 
 
coefs = [zeros(3,2,2); ones(1,2,2)]; 
coefs(1:length(p11),1,1) = p11(:);     
coefs(1:length(p12),1,2) = p12(:); 
coefs(1:length(p21),2,1) = p21(:); 
coefs(1:length(p22),2,2) = p22(:); 
              
knots  = {[0 0 1 1] [0 0 1 1]};  
srf = nrbmak(coefs, knots); 
            
