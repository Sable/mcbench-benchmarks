function RGBnew = changeBrightness(RGB, brightness, contrast)

% function RGBnew = changeBrightness(RGB, brightness, contrast)
% 
% This function changes the brightness and contrast of an RGB image
%
% ARGUMENTS:
% - RGB: the RGB image
% - brightness: the brightness factor (-1..1)
% - contrast: the contrast factor (-1..1)
%
% RETURNS
% - RGBnew: the processed image
%
% Theodoros Giannakopoulos.
% www.di.uoa.gr/~tyiannak
% tyiannak@di.uoa.gr, tyannak@gmail.com
%

RGBnew = RGB;
if (brightness < 0.0)  
    RGBnew = RGBnew * ( 1.0 + brightness);
else
    RGBnew = RGBnew + ((1.0 - RGBnew) * brightness);
end
RGBnew = (RGBnew - 0.5) * (tan ((contrast + 1) * pi/4) ) + 0.5;