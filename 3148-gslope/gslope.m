function m = gslope(ignored)
%GSLOPE Estimate a slope from two mouse clicks.
%   GSLOPE creates a crosshair in the current figure and waits for two mouse
%   clicks. The slope of the line through the two click locations is
%   returned. Logarithmic scales are automatically accounted for.
%   
%   See also GINPUT.

% Copyright 1999-2003 by Toby Driscoll (driscoll@math.udel.edu).

[x,y]=ginput(2);
if nargin > 0
  line(x,y,'linesty','none','marker','x','linestyle','--','color','k')
end
if strcmp(get(gca,'xsc'),'log'), x = log10(x); end
if strcmp(get(gca,'ysc'),'log'), y = log10(y); end
m = diff(y)/diff(x);
