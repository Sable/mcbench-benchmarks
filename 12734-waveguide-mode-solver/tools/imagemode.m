function [xf,yf,modebmp] = imagemode(x,y,mode,dx,dy);

% Produces a properly scaled color plot of a two-dimensional
% mode.  This routine is especially useful when x and y are
% non-uniformly spaced vectors.  In this case, the mode is
% interpolated over a uniformly-spaced grid before producing
% an image plot.  The output can be directly saved to a file
% using the imwrite() function.
% 
% USAGE:
% 
% [xf,yf,modebmp] = imagemode(x,y,mode);
% [xf,yf,modebmp] = imagemode(x,y,mode,dx,dy);
% 
% INPUT:
% 
% x,y - vectors describing horizontal and vertical grid points
% mode - the mode or field component to be plotted
% dx, dy (optional) - fine grid spacing at which to oversample
%   (interpolate) the mode.  If left unspecified, this routine
%   will use the smallest value of diff(x) and diff(y).
% 
% OUTPUT:
% 
% xf,yf - points at which the mode was interpolated
% modebmp - 8-bit unsigned integer array representing the mode
%    image

x = real(x);
y = real(y);

if (size(mode) == [length(x)-1,length(y)-1])
    x = (x(1:end-1) + x(2:end))/2;
    y = (y(1:end-1) + y(2:end))/2;
end

if (nargin == 3)
  [dx,ix] = min(diff(x));
  [dy,iy] = min(diff(y));
  xf = (min(x):dx:max(x))';
  yf = (min(y):dy:max(y));
  % line up with finest portion of grid
  delta = dx*(interp1(xf,(1:length(xf)),x(ix+1)) - ...
              round(interp1(xf,(1:length(xf)),x(ix+1))));
  xf = xf + delta;
  delta = dy*(interp1(yf,(1:length(yf)),y(iy+1)) - ...
              round(interp1(yf,(1:length(yf)),y(iy+1))));
  yf = yf + delta;
  % eliminate points outside of range
  kv = find((min(x) < xf) & (xf < max(x)));
  xf = xf(kv);
  kv = find((min(y) < yf) & (yf < max(y)));
  yf = yf(kv);
else
  xf = (min(x):dx:max(x))';
  yf = (min(y):dy:max(y));
end

cmax = size(colormap,1)-1;

modebmp = uint8(transpose(interp2(y,x, ...
                abs(cmax*mode),yf,xf)));
image(xf,yf,modebmp);
set(gca,'YDir','normal');
v = [min(xf),max(xf),min(yf),max(yf)];
axis(v);
set(gca,'PlotBoxAspectRatio',[v(2)-v(1) v(4)-v(3) 1]);
