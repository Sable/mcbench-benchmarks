function [I] = corrindex(XData, YData, YDataM, par_number)
%
% Function for calculation of the correlation index
%
% Inputs:   XData:  x data
%           YData:  y data
%           YDataM: model data
%           par_number: number of model parameters
% Output:   I: correlation index
%
% Authors:
% Ivo Petras (ivo.petras@tuke.sk)
% Dagmar Bednarova (dagmar.bednarova@tuke.sk)
%
% Date: 21/002/2007
%
kx=length(XData);
ky=length(YData);
kym=length(YDataM);
if kx ~= ky 
    disp('Incompatible X and Y data.');
    close all;
end
n=kym;
sey=(sum((YData-YDataM).^2))/(n-par_number);
sy=var(YData);
I=(1-(sey./sy))^0.5;
%