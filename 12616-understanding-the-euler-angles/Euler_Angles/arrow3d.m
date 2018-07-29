 function [ hHead,hTail,hPlate ] = arrow3d( orgin,r,h1,h2,dir)
%ARROW3D Summary of this function goes here
%  Detailed explanation goes here

% 
% orgin=[0 0 0.2]';
% r=1;
% h=90;
% dir='y';

n=25;
% p=0.15;

hTail=Cylinder(orgin,r/2,h1,dir,n,'open');
hold on

if dir=='x'
    org=orgin+[h1; 0; 0];
elseif dir=='y'
    org=orgin+[0; h1; 0];
elseif dir=='z'
    org=orgin+[0; 0; h1];
end

xlabel('x')
ylabel('y')
zlabel('z')

[hHead hPlate]=Cone( org,r,h2,dir,n,'closed' );
set(hTail,'EdgeAlpha',0)