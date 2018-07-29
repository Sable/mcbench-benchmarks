function [ hCone, hPlate1 ] = Cone( orgin,r,h,dir,n,closed )
%CONE Summary of this function goes here
%  Detailed explanation goes here

x=[r 0]';
y=[0 h]';

[hCone hPlate1 hPlate2]=Revolve(orgin,x,y,dir,n,closed);