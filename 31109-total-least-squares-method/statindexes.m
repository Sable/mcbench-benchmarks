function [F, Srez, Scel]=statindexes(XData, YData, a, b)
%
% [F, Srez, Scel]=statindexes(xdata, ydata, a, b)
%
% Computation of statistical indicators for linear model
%
% Input parameters:
%  - xdata: input data block -- x: axis
%  - ydata: input data block -- y: axis
%  - a: parameter of linear model \  y = bx + a
%  - b: parameter of linear model /
% 
% Return parameters:
%  - F: value for F-test
%  - Srez: residual dispersion
%  - Scel: total dispersion
%
% Authors:
% Ivo Petras (ivo.petras@tuke.sk)
% Dagmar Bednarova (dagmar.bednarova@tuke.sk)
%
% Date: 25/05/2009
%
kx=length(XData);
ky=length(YData);;
if kx ~= ky
   disp('Incompatible X and Y data.');
   close all;
end
n=size(YData,2);
Srez = sum((YData-(a+b*XData)/(sqrt(1+b^2))).^2)/(n-2);
Scel=sum((YData-mean(YData)).^2+(XData-mean(XData)).^2)/(n-1);
F=Scel/Srez;
%