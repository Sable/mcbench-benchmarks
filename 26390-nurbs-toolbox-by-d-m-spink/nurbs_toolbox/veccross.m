function cross = veccross(vec1,vec2) 
%  
% Function Name: 
%  
%   veccross - The cross product of two vectors. 
%  
% Calling Sequence: 
%  
%   cross = veccross(vec1,vec2); 
%  
% Parameters: 
%  
%   vec1	: An array of column vectors represented by a matrix of 
%   vec2	size (dim,nv), where is the dimension of the vector and 
% 		nv the number of vectors. 
%  
%   cross	: Array of column vectors, each element is corresponding 
% 		to the cross product of the respective components in vec1 
% 		and vec2. 
%  
% Description: 
%  
%   Cross product of two vectors. 
%  
% Examples: 
%  
%   Determine the cross products of: 
%   (2.3,3.4,5.6) and (1.2,4.5,1.2) 
%   (5.1,0.0,2.3) and (2.5,3.2,4.0) 
%  
%   cross = veccross([2.3 5.1; 3.4 0.0; 5.6 2.3],[1.2 2.5; 4.5 3.2; 1.2 4.0]); 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
if size(vec1,1) == 2 
  % 2D vector 
  cross = zeros(size(vec1)); 
  cross(3,:) = vec1(1,:).*vec2(2,:)-vec1(2,:).*vec2(1,:); 
else 
  % 3D vector 
  cross = [vec1(2,:).*vec2(3,:)-vec1(3,:).*vec2(2,:); 
           vec1(3,:).*vec2(1,:)-vec1(1,:).*vec2(3,:); 
           vec1(1,:).*vec2(2,:)-vec1(2,:).*vec2(1,:)]; 
end 
