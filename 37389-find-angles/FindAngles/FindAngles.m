function Angles = FindAngles(vertices)

% Purpose: To find the angles of Triangle or Quadrilateral 
% Synopsis: Angles = FindAngles(vertices)
% Variable description:
% INPUT: vertices - coordinates of Triangle and Quadrilateral
%                   order 3X2 if vertices are of Triangle and 4X2 if vertices
%                   are of Quadrilateral. The vertices are given input in 
%                   anticlock wise direction.
% OUTPUT: Angles - Row vector of angles of Triangle/ Quadrilateral in degrees.
%                  3X1 for Trianle and 4X1 for Quadrilateral
% Example: vertices = [4 0;5 1;4 1]                 } Triangle vertices  
%          angles = FindAngles(vertices);             
%          angles = [45.0000   45.0000   90.0000]   
%       
%          vertices = [4  4;4  6;5 6; 5  4]         } Quadrilateral vertices
%          angles = FindAngles(vertices);    
%          angles = [90 90 90 90]
%  
% Algorithm: Calculates the angles using dot product
%            theta = arccos((a.b)/(|a||b|)
% Release : 1.0
% Release Date: 03/07/2012  
%---------------------------------------------------------------------------
% Author : Siva Srinivas Kolukula                                
%          Senior Research Fellow                                
%          Structural Mechanics Laboratory                       
%          Indira Gandhi Center for Atomic Research              
%          India                                                 
% E-mail : allwayzitzme@gmail.com                                         
%          http://sites.google.com/site/kolukulasivasrinivas/                 
%---------------------------------------------------------------------------

N = length(vertices) ;
if N == 3
    disp('vertices are of Triangle')
    order = [1 2 3; 2 1 3;3 1 2] ;
elseif N == 4   
    disp('Vertices are of Quadrilateral')
    order = [ 1 2 4; 2 1 3; 3 4 2;4 3 1] ;
else 
    error('Wrong input')
end
 
    
    Angles = zeros(1,N) ;
    
for i = 1:N
    % Form the vectors along the vertices
    vec1 = [vertices(i,:); vertices(order(i,2),:)];
    vec2 = [vertices(i,:); vertices(order(i,3),:)];
    % Use dor ptodict to find the angle between vector1 and vector2
    Angles(i) = acos((diff(vec1)*diff(vec2)')/.....
        (sqrt(sum(diff(vec1,[],1).^2,2))*sqrt(sum(diff(vec2,[],1).^2,2)))) ;    
end

% Convert the angles in radians to degrees
Angles = Angles*180./pi ;        %