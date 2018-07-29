
function [SD Ang]= shortestdistance(O,V,Q)

%  
% [SD Angle]= shortestdistance(O,V,Q);
% 
% To find the shortest (perpendicular) distance between two vectors O and V in 3 dimensions..
% Q is a vector joining O and V. One point on each vector also needs to be known to comupte Q (Q=Point1-Point2) 
% SD is the shortest distance returned by the function.
% Angle is the angle between the two vectors.
% 
% Example:
%   O = [-0.012918 0.060289 0.998097];
%   V = [47.9083   -3.8992   65.6425];
%   Point1 = [35.4 5.6 -49.4]; //A point on O
%   Point2 = [37.4 5.8 32.8]; // A point on V
%   Q = Point1 - Point 2;
%   [SD Angle]= shortestdistance(O,V,Q);
%
%
% The Algorithm:
%  
% In 3D space, the shortest distance between two skew lines is in the direction of the common perpendicular.  
% 
% To find a vector, P=(Px,Py,Pz), perpendicular to both  vectors (O  and P), we need to solve the two simultaneous equations, O.P=0 and V.P=0.  
% 
% Although two equations in three unknowns cannot generally be solved analytically, these homogenous equations can be transformed into a series of
% two equations in two unknowns by using the ratios Px/Pz and Py/Pz, which can then be solved using normal methods. 
%  
% Choosing an arbitrary value for Pz, we can determine a valid P, as well as the corresponding unit vector U = P /|P|.  
% 
% Then to find the shortest distance, the scalar product can be used to find the projection of any vector Q (connecting the two skew lines and
%Q can be computed  by knowing one point on each of the skew lines )onto the unit vector U. Thus the shortest distance   SD= Q .U , 

% The angle between the two vectos is computed by taking the arccosine of the scalar product of 
% V and O divided by the product of the magnitudes of V and O , i.e. Angle = acos( (V.0)/|V||O| )*180/pi

%   Copyright 2013 Mathew Philip. 
%   $Date: 2013/09/04  

Pz=1;

A=[O(1) O(2);
    V(1) V(2)];

Az=[O(3);
    V(3)];

Pxy=-inv(A)*Az;

Px=Pxy(1);
Py=Pxy(2);


U=[Px Py Pz]/norm([Px Py Pz],2);

SD=abs(dot(U,Q));

Ang= acos( ( dot(O,V)/(norm(O,2)*norm(V,2))))*180/pi;
