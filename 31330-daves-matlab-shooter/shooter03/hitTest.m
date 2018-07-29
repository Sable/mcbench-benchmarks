%input: x, y, width, height for one rectangle,
%       EITHER x, y, for test point
%       OR, x, y, width, height, for test rectangle

function [hit] = hitTest (x1, y1, w1, h1, x2, y2, varargin)
if size(varargin, 2) == 0
  w2 = 0;
  h2 = 0;
elseif size(varargin, 2) == 2
  w2 = varargin{1};
  h2 = varargin{2};
end

hit = (x2 + w2) > x1 && ...
  x2 < (x1 + w1) && ...
  (y2 + h2) > y1 && ...
  y2 < (y1 + h1);
end