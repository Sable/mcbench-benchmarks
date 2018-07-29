% function  [x,y,scaleFactor] = mercator(lon,lat), -> Mercator Projection
% Input:
%     lon: the longitude of the point or points
%     lat: the latitude of the point or points
% output: x,y values on the mercator projection. To get the values in units
% of distance you must multiply this by the radius of the earth and then divide
% by the scaleFactor. Note: radius of Earth = 6378.1 kilometers, and each
% point will have its own scalefactor, but you should choose only one to
% multiply all your points by.
% 
% [lon, lat] = mercator(x,y,1), -> Inverse Mercator Projection 
%                             (when you enter extra parameter 1, the
%                             inverse is calculated
% Input:
%     x: This must be the 'x' value output by the first call to the
%          mercator function. It cannot be scaled by anything at this point
%          if you had scaled it before, you must scale it back.
%     y: this must be the 'y' value output by the first call to mercator
%       1: this can be any parameter at all you feel like passing. It will
%          tell the function that it must compute the inverse mercator.
% Output:
%     lon: the longitude of the point or points
%     lat: the latitude of the point or points
% 
%% examples
% [x,y,scaleFactor] = mercator(lon,lat);
% meanSF = mean(scaleFactor); % use the mean scalefactor (a single number)
% x_km=x*6378.1/meanSF; % now x is in units of km
% y_km=y*6378.1/meanSF; % now y is in units of km
% 
% meanX=mean(x_km);
% meanY=mean(y_km);
% 
% x_km = x_km-meanX; % the absolute values here are meaningless so you may
% y_km = y_km-meanY; % subtract the mean from the data.
% 
% 
% plot(x_km,y_km);
% axis('equal'); % so that shapes will be preserved (the whole point of this)
% xlabel('km'); ylabel('km');
% 
%%
% note that may programs accept or display longitude and latitude in a
% diffferent order. I have chosen to use lon,lat in this order so that it
% can correspond to the standard for plotting, x,y
% 
% Note that you may wish to subtract the mean from the data before plotting
% it. The absolute x,y values outputted are entirely meaningless in the
% mercator projection. It is important though to add the mean back again if
% you would like to compute the inverse.
% 
function [x,y2,scaleFactor] = mercator(lon,lat,varargin)

if ischar(lon) || ischar(lat)
    warning('string input has been changed to numbers');
end

if ischar(lon)
    lon=str2double(lon);
end
if ischar(lat)
    lat=str2double(lat);
end



if isempty(varargin) % do the real projection
    x = deg2rad(lon);
    y = deg2rad(lat);
    % Projection:
    y2 = log(abs(tan(y)+sec(y)));
%   y2 = log(tan(pi/4+y/2));
    scaleFactor = sec(y);
    
else % do the inverse projection
    x = rad2deg(lon);
    y2 = atan(sinh(lat));
    y2 = rad2deg(y2);
    
    scaleFactor=sec(lat);
end

function deg = rad2deg(rad)
deg = rad*180/pi;

function rad = deg2rad(deg)
rad = deg*pi/180;
