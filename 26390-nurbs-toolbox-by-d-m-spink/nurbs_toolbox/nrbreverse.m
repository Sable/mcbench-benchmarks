function rnrb = nrbreverse(nrb) 
% 
% Function Name: 
%  
%   nrbreverse - Reverse the evaluation direction of a NURBS curve or surface. 
%  
% Calling Sequence: 
%  
%   rnrb = nrbreverse(nrb); 
%  
% Parameters: 
%  
%   nrb		: NURBS data structure, see nrbmak. 
%  
%   rnrb		: Reversed NURBS. 
%  
% Description: 
%  
%   Utility function to reverse the evaluation direction of a NURBS 
%   curve or surface. 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
if nargin ~= 1 
  error('Incorrect number of input arguments'); 
end 
 
if iscell(nrb.knots) 
 
  % reverse a NURBS surface 
  coefs = nrb.coefs(:,:,end:-1:1); 
  rnrb = nrbmak(coefs(:,end:-1:1,:), {1.0-fliplr(nrb.knots{1}),... 
                1.0-fliplr(nrb.knots{2})});            
 
else 
 
  % reverse a NURBS curve 
  rnrb = nrbmak(fliplr(nrb.coefs), 1.0-fliplr(nrb.knots)); 
 
end 
