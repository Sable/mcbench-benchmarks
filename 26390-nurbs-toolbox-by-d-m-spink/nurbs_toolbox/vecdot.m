function dot = vecdot(vec1,vec2) 
%  
% Function Name: 
%  
%   vecdot - The dot product of two vectors. 
%  
% Calling Sequence: 
%  
%   dot = vecdot(vec1,vec2); 
%  
% Parameters: 
%  
%   vec1	: An array of column vectors represented by a matrix of 
%   vec2	size (dim,nv), where is the dimension of the vector and 
% 		nv the number of vectors. 
%  
%   dot		: Row vector of scalars, each element corresponding to 
% 		the dot product of the respective components in vec1 and 
% 		vec2. 
%  
% Description: 
%  
%   Scalar dot product of two vectors. 
%  
% Examples: 
%  
%   Determine the dot product of 
%   (2.3,3.4,5.6) and (1.2,4.5,1.2) 
%   (5.1,0.0,2.3) and (2.5,3.2,4.0) 
% 
%   dot = vecdot([2.3 5.1; 3.4 0.0; 5.6 2.3],[1.2 2.5; 4.5 3.2; 1.2 4.0]); 
 
%  D.M. Spink 
%  Copyright (c) 2000 
 
dot = sum(vec1.*vec2); 
 
