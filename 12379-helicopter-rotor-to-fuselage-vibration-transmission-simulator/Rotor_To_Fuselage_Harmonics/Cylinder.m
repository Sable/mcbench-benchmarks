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

% Typical Inputs
% orgin=[0 0 -5];
% r=8;
% h=10;
% dir='z';
% n=25;
% closed='closed';


t=linspace(0,2*pi,n)';

x1=r*cos(t);
x2=r*sin(t);

if dir=='y'
    xx1=[[x1;x1(1)] [x1;x1(1)]]+orgin(1);
    xx2=[repmat(orgin(2),length(x1)+1,1) repmat(orgin(2)+h,length(x1)+1,1)];
    xx3=[[x2;x2(1)] [x2;x2(1)]]+orgin(3);
elseif dir =='x'
    xx1=[repmat(orgin(1),length(x1)+1,1) repmat(orgin(1)+h,length(x1)+1,1)];
    xx2=[[x1;x1(1)] [x1;x1(1)]]+orgin(2);
    xx3=[[x2;x2(1)] [x2;x2(1)]]+orgin(3);
elseif dir =='z'
    xx1=[[x1;x1(1)] [x1;x1(1)]]+orgin(1);
    xx2=[[x2;x2(1)] [x2;x2(1)]]+orgin(2);
    xx3=[repmat(orgin(3),length(x1)+1,1) repmat(orgin(3)+h,length(x1)+1,1)];
end
hCylinder=surf(xx1,xx2,xx3,repmat(3,size(xx1)));

if strcmp(closed,'closed')==1
    hold on
    hPlate1=fill3(xx1(:,1),xx2(:,1),xx3(:,1),[0.5020    0.5020    0.5020]);
    hPlate2=fill3(xx1(:,2),xx2(:,2),xx3(:,2),[0.5020    0.5020    0.5020]);
end