%                               431-400 Year Long Project 
%                           LA1 - Medical Image Processing 2003
%  Supervisor     :  Dr Lachlan Andrew
%  Group Members  :  Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%                    Lee Siew Teng   102519  s.lee1@ugrad.unimelb.edu.au
%                    Loh Jien Mei    103650  j.loh1@ugrad.unimelb.edu.au
% 
%  File and function name : euclidean_distance
%  Version                : 1.0
%  Date of completion     : 22 September 2003   
%  Written by    :   Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%
%  Inputs        :  
%               Coord1,Coord2 - Coordinates to be calculated. Each of them in [X,Y]
%
%  Outputs       :  
%               distance - The calculated distance between each pair of coordinates
%
%  Description   : 
%       Calculates the euclidean_distance between 2 points
%
%  To Run >> distance = euclidean_distance(Coord1,Coord2)
%
%  Example >> distance = euclidean_distance([2,4;5,6],[4,6;5,7]);

function distance = euclidean_distance(Coord1,Coord2)
if isempty(Coord1) | isempty(Coord2)
    error('No data input');
end
[r1,c1] = size(Coord1);
[r2,c2] = size(Coord2);
if ([r1,c1] ~= [r2,c2]) | (c1~=2) | (c2 ~= 2) | (r1 ~= r2)
    error('Invalid matrix dimensions');
end
distance = sqrt((Coord1(:,1)-Coord2(:,1)).^2 + (Coord1(:,2)-Coord2(:,2)).^2);