function tsrf = nrbtransp(srf) 
%  
% Function Name: 
%  
%   nrbtransp - Transpose a NURBS surface, by swapping U and V directions. 
%  
% Calling Sequence: 
%  
%   tsrf = nrbtransp(srf) 
% 
% Parameters: 
%  
%   srf		: NURBS surface, see nrbmak. 
%  
%   tsrf	: NURBS surface with U and V diretions transposed. 
%  
% Description: 
%  
%   Utility function that transposes a NURBS surface, by swapping U and 
%   V directions. NURBS curves cannot be transposed. 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
if ~iscell(srf.knots) 
  error(' A NURBSs curve cannot be transposed.'); 
end   
 
tsrf = nrbmak(permute(srf.coefs,[1 3 2]), fliplr(srf.knots)); 
