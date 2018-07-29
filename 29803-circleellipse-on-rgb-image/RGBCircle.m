function image = RGBCircle(image, x, y, rad, col , pointnum, phase)
%RGBCircle  Draws a circle or ellipse on a RGB image.   
%   image = RGBCircle(image, x, y, rad, rgbcol) 
%   Returns the image with a circle centerd at x ,y drawn.
%
%   image = RGBCircle(image, x, y, [radx rady], rgbcol) draws a ellipse.
%   image = RGBCircle(image, x, y, rad, [r g b]) draws a circle colored by
%   r g b values.  
%   image = RGBCircle(image, x, y, [radx rady]) draws a white ellipse.
%
%   If the ellipse is outside the image it will be drawn on the edge

%   Made by Kobi Nistel
%   $Revision: 1 $  $Date: 2010/21/12 17:05:47 $


% Setting default values
if nargin < 5 
    col = 255;
end

if nargin < 6 
    delta = 1/max([rad,0.1]);
else
    delta = 2*pi/pointnum;
end;

if nargin < 7 
  phaseX = 0;
  phaseY = 0;
else
  phaseX = phase(1);
  phaseY = phase(min(length(phase),2)); 
end
    
radx = rad(1);
rady = rad(min(length(rad),2));
r = col(1);
g = col(min(length(col),2));
b = col(min(length(col),3));

% Drawing the ellipse
deg = 0:delta:2*pi;
[sy sx ~] = size(image);
vy = min(max(round(y + cos(deg + phaseY)*rady),1),sy);
vx = min(max(round(x + sin(deg + phaseX)*radx),1),sx);
index = (vy-1) + (vx-1)*sy + 1;
image(index) = r;
image(index+sx*sy) = g;
image(index+2*sx*sy) = b;
end