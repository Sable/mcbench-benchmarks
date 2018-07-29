function [hCylinder,hPlate1,hPlate2] = Cylinder( orgin,r,h,dir,n,closed )
% This Function plots a cylinder at specified orgin, with specified radius, height, direction(axis), no of points along the circumference
% 
%   Typical Call Cylinder( orgin,r,h,dir,n ), Note: there is a matlab function "cylinder"
% 
%   orgin: vector of order 3 x 1 specifies orgin
%   h    : Height of the Cylinder
%   dir  : String to specify axis of extrution 'x' or 'y' or 'z' (Only along these axes...!)
%   n    : no of points along the circumference
% 
   

t=linspace(0,2*pi,n)';

x1=r*cos(t);
x2=r*sin(t);
h1=orgin(3);
h2=h1+h;


if dir=='y'
    xx1=[[x1;x1(1)] [x1;x1(1)]]+orgin(1);
    xx2=[repmat(h1,length(x1)+1,1) repmat(h2,length(x1)+1,1)]+orgin(2);
    xx3=[[x2;x2(1)] [x2;x2(1)]]+orgin(3);
elseif dir =='x'
    xx1=[repmat(h1,length(x1)+1,1) repmat(h2,length(x1)+1,1)]+orgin(1);
    xx2=[[x1;x1(1)] [x1;x1(1)]]+orgin(2);
    xx3=[[x2;x2(1)] [x2;x2(1)]]+orgin(3);
else
    xx1=[[x1;x1(1)] [x1;x1(1)]]+orgin(1);
    xx2=[[x2;x2(1)] [x2;x2(1)]]+orgin(2);
    xx3=[repmat(h1,length(x1)+1,1) repmat(h2,length(x1)+1,1)]+orgin(3);
end
hCylinder=surf(xx1,xx2,xx3,repmat(3,size(xx1)));

if strcmp(closed,'closed')==1
    hold on
    hPlate1=fill3(xx1(:,1),xx2(:,1),xx3(:,1),'g');
    hPlate2=fill3(xx1(:,2),xx2(:,2),xx3(:,2),'g');
end