%Function to integrate the view factor
function sortie =functionintegral(s,t)

%Global variables: pt1 to pt4 are the points that define the segment to integrate, normale1 and normale2 are the unit normal vector.
global pt1;
global pt2;
global pt3;
global pt4;
global normale1;
global normale2;

%Parametric equations for the segment of figure 1
x1=pt1(1)+(pt2(1)-pt1(1)).*t;
y1=pt1(2)+(pt2(2)-pt1(2)).*t;
z1=pt1(3)+(pt2(3)-pt1(3)).*t;

%Parametric equations for the segment of figure 2
x2=pt3(1)+(pt4(1)-pt3(1)).*s;
y2=pt3(2)+(pt4(2)-pt3(2)).*s;
z2=pt3(3)+(pt4(3)-pt3(3)).*s;

%L is the length of the segment of figure 1
L=norm(pt2-pt1);

%R is the distance between the point on segment 1 and the point on segment 2 to which
%we add a little distance to prevent log(0).

R=sqrt((x2-x1).^2+(y2-y1).^2+(z2-z1).^2)+L*10^(-25);

%Function to integrate to calculate the view factor
%log(x)*(dx1*dx2+dy1*dy2+dz1*dz2)
sortie=log(R)*((pt2(1)-pt1(1))*(pt4(1)-pt3(1))+(pt2(2)-pt1(2))*(pt4(2)-pt3(2))+(pt2(3)-pt1(3))*(pt4(3)-pt3(3)));
