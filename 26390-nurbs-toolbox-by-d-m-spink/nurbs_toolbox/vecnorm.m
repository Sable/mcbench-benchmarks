function nvec = vecnorm(vec) 
%  
% Function Name: 
%  
%   vecnorm - Normalise the vectors. 
%  
% Calling Sequence: 
%  
%   nvec = vecnorn(vec); 
%  
% Parameters: 
%  
%   vec		: An array of column vectors represented by a matrix of 
% 		size (dim,nv), where is the dimension of the vector and 
% 		nv the number of vectors. 
%  
%   nvec		: Normalised vectors, matrix the smae size as vec. 
%  
% Description: 
%  
%   Normalises the array of vectors, returning the unit vectors. 
%  
% Examples: 
%  
%   Normalise the two vectors (0.0,2.0,1.3) and (1.5,3.4,2.3) 
% 
%   nvec = vecnorm([0.0 1.5; 2.0 3.4; 1.3 2.3]); 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
nvec = vec./repmat(sqrt(sum(vec.^2)),[size(vec,1) ones(1,ndims(vec)-1)]); 
 
