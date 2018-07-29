function out = draw_arrow(startpoint,endpoint,headsize)
%by Ryan Molecke
% accepts two [x y] coords and one double headsize

   v1 = headsize*(startpoint-endpoint)/2.5;

   theta = 22.5*pi/180;
   theta1 = -1*22.5*pi/180;
   rotMatrix = [cos(theta)  -sin(theta) ; sin(theta)  cos(theta)];
   rotMatrix1 = [cos(theta1)  -sin(theta1) ; sin(theta1)  cos(theta1)];
   
   v2 = v1*rotMatrix;
   v3 = v1*rotMatrix1;
   x1 = endpoint;
   x2 = x1 + v2;
   x3 = x1 + v3;
hold on;
   fill([x1(1) x2(1) x3(1)],[x1(2) x2(2) x3(2)],[0 0 0]);     % this fills the arrowhead (black)
   plot([startpoint(1) endpoint(1)],[startpoint(2) endpoint(2)],'linewidth',2,'color',[0 0 0]);