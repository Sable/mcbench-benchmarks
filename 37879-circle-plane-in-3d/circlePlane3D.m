function H = circlePlane3D( center, normal, radious, theintv, normalon, color, style )
%CIRCLEPLANE3D Summary of this function goes here
%--------------------------------------------------------------------------
%Generate a circle plane in 3D with the given center and radious
%The plane is defined by the normal vector
%theintv is the interval theta which allow you to control your polygon
%shape
% Example:,
%
%   circlePlane3D([0 0 0], [1 -1 2], 5, 0.2, 1, [0 0 1], '-'); 
%   circlePlane3D([3 3 -3],[0 1 1], 3, 0.1, 1, 'y', '-');
%   
%   Cheng-Yuan Wu <ieda_wind@hotmail.com>
%   Version 1.00
%   Aug, 2012
%--------------------------------------------------------------------------
%generate circle polygon
t = 0:theintv:2*pi;
x = radious*cos(t);
y = radious*sin(t);
z = zeros(size(x));
%compute rotate theta and axis
zaxis = [0 0 1];
normal = normal/norm(normal);
ang = acos(dot(zaxis,normal));
axis = cross(zaxis, normal)/norm(cross(zaxis, normal));
% A skew symmetric representation of the normalized axis 
axis_skewed = [ 0 -axis(3) axis(2) ; axis(3) 0 -axis(1) ; -axis(2) axis(1) 0]; 
% Rodrigues formula for the rotation matrix 
R = eye(3) + sin(ang)*axis_skewed + (1-cos(ang))*axis_skewed*axis_skewed;
fx = R(1,1)*x + R(1,2)*y + R(1,3)*z;
fy = R(2,1)*x + R(2,2)*y + R(2,3)*z;
fz = R(3,1)*x + R(3,2)*y + R(3,3)*z;
%translate center
fx = fx+center(1);
fy = fy+center(2);
fz = fz+center(3);
H = fill3(fx, fy, fz, color);
if normalon == 1
    hold on;
    H = plot3([center(1) center(1)+normal(1)],[center(2) center(2)+normal(2)],[center(3) center(3)+normal(3)],style);
end



end

