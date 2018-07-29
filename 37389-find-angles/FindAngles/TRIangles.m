function Angles = TRIangles(vertices)

% Purpose: To find the angles of Triangle when vertices are known 
% Synopsis: Angles = FindAngles(vertices)
% Variable description:
% INPUT: vertices - coordinates of Triangle in order 3X2. The vertices are
%                   given input in anticlock wise direction.
% OUTPUT: Angles - Row vector of angles of Triangle in degrees of order 3X1
% 
% Example: vertices = [4 0;5 1;4 1]                 
%          angles = FindAngles(vertices);             
%          angles = [45.0000   45.0000   90.0000]   
%  
% Algorithm: Calculates the angles using dot product
%            theta = arccos((a.b)/(|a||b|)
%   
% Release : 1.0
% Release Date: 03/07/2012  
%--------------------------------------------------------------------------
% Author : Siva Srinivas Kolukula                                
%          Senior Research Fellow                                
%          Structural Mechanics Laboratory                       
%          Indira Gandhi Center for Atomic Research              
%          India                                                 
% E-mail : allwayzitzme@gmail.com                                         
%          http://sites.google.com/site/kolukulasivasrinivas/                 
%--------------------------------------------------------------------------

Angles = zeros(1,3) ;
order = [1 2 3; 2 1 3;3 1 2] ;
for i = 1:3
    % Form the vectors along the vertices
    data1 = [vertices(i,:); vertices(order(i,2),:)];
    data2 = [vertices(i,:); vertices(order(i,3),:)];
    % Use dor ptodict to find the angle between vector1 and vector2
    Angles(i) = acos((diff(data1)*diff(data2)')/.....
        (sqrt(sum(diff(data1,[],1).^2,2))*sqrt(sum(diff(data2,[],1).^2,2)))) ;    
end
% Convert the angles in radians to degrees
Angles = Angles*180./pi ;        %