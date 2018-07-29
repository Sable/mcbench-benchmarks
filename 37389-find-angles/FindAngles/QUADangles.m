function Angles = QUADangles(vertices)

% Purpose: To find the angles of Quadrilateral when vertices are known 
% Synopsis: Angles = FindAngles(vertices)
%  
% Variable description:
% INPUT: vertices - coordinates of Quadrilateral in order 4X2 . The vertices 
%                   are given input in anticlock wise direction.
%   
% OUTPUT: Angles - Row vector of angles of Quadrilateral in degrees of order 4X1
%   
% Example: vertices = [4  4;4  6;5 6; 5  4]       
%          angles = FindAngles(vertices);    
%          angles = [90 90 90 90]
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

Angles = zeros(1,4) ;
order = [ 1 2 4; 2 1 3; 3 4 2;4 3 1] ;
for i = 1:4
    % Form the vectors along the vertices
    data1 = [vertices(i,:); vertices(order(i,2),:)];
    data2 = [vertices(i,:); vertices(order(i,3),:)];
    % Use dor ptodict to find the angle between vector1 and vector2
    Angles(i) = acos((diff(data1)*diff(data2)')/.....
        (sqrt(sum(diff(data1,[],1).^2,2))*sqrt(sum(diff(data2,[],1).^2,2)))) ;    
end
% Convert the angles in radians to degrees
Angles = Angles*180./pi ;        %