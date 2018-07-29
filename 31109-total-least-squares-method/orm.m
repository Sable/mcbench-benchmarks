function [Err, P]  = orm(XData, YData, order)
%
% [Err, P] = orm(XData, YData, order)
%
% Orthogonal Regression Method (ORM) based on
% the QR decomposition for the linear model :
% YM = XData.^order.*P
%
% Input parameters:
%  - XData: input data block (m x nx)
%  - YData: output data block (m x nx)
%  - order: polynomial degree 
% Return parameters:
%  - P: mapping matrix, 
%  - Err: error - sum of orthogonal distances 
%
% Authors:
% Ivo Petras (ivo.petras@tuke.sk)
% Dagmar Bednarova (dagmar.bednarova@tuke.sk)
%
kx=length(XData);
ky=length(YData);
if kx ~= ky
   disp('Incompatible X and Y data.');  
   close all;
end
[Q,R] = qr(YData,0);
P = R/(Q'.*XData.^order);
YM = XData.^order.*P; 
XM = (YM./P).^(1/order);
alpha = atan(abs((YM-YData)/(XM-XData)));
d=abs(YM-YData)/sin(alpha);
Err=sum((d).^2);
%