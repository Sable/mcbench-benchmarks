function mag = vecmag2(vec) 
%  
% Function Name: 
%  
%   vecmag - Squared magnitude of the vectors 
%  
% Calling Sequence: 
%  
%   mvec = vecmag2(vec) 
%  
% Parameters: 
%  
%   vec		: An array of column vectors represented by a matrix of 
% 		size (dim,nv), where is the dimension of the vector and 
% 		nv the number of vectors. 
%  
%   mvec	: Squared magnitude of the vectors, vector of size (1,nv). 
%  
% Description: 
%  
%   Determines the squared magnitude of the vectors. 
%  
% Examples: 
%  
%   Find the squared magnitude of the two vectors (0.0,2.0,1.3) 
%   and (1.5,3.4,2.3) 
%  
%   mvec = vecmag2([0.0 1.5; 2.0 3.4; 1.3 2.3]); 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
mag = sum(vec.^2); 
 
