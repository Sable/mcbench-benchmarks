function mag = vecmag(vec) 
%  
% Function Name: 
%  
%   vecmag - Magnitude of the vectors 
%  
% Calling Sequence: 
%  
%   mvec = vecmag(vec) 
%  
% Parameters: 
%  
%   vec		: An array of column vectors represented by a matrix of 
% 		size (dim,nv), where is the dimension of the vector and 
% 		nv the number of vectors. 
%  
%   mvec		: Magnitude of the vectors, vector of size (1,nv). 
%  
% Description: 
%  
%   Determines the magnitude of the vectors. 
%  
% Examples: 
%  
%   Find the magnitude of the two vectors (0.0,2.0,1.3) and (1.5,3.4,2.3) 
%  
%   mvec = vecmag([0.0 1.5; 2.0 3.4; 1.3 2.3]); 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
mag = sqrt(sum(vec.^2)); 
 