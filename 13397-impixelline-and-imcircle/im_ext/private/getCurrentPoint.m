function [x,y] = getCurrentPoint(h)
%getCurrentPoint Return current point.
%   [X,Y] = getCurrentPoint(H) returns the x and y coordinates of the current
%   point. H can be a handle to an axes or a figure.
%
%   This function performs no validation on H.

%   Copyright 2005 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2005/05/27 14:07:16 $

p = get(h,'CurrentPoint');

hType = get(h,'Type');
isHandleFigure = strcmp(hType,'figure');

if isHandleFigure
  x = p(1);
  y = p(2);
else
  % handle is axes
  x = p(1,1);
  y = p(1,2);
end

