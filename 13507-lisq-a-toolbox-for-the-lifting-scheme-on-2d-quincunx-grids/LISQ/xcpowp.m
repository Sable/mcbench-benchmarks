function xcp = xcpowp(F, p, c)
%------------------------------------------------------------------------------
%
% This function computes the gridfunction xcp of size F with values (x-c)^p at
% its gridpoints. Piecewise constant approximation is assumed.
%
%   Orientation
%
%         x
%     o---->
%     |
%   y |
%     v
%    
% 
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: November 27, 2000.
% (c) 1999-2000 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
if isempty(F)
  error(' xcpowp - gridfunction is empty ')
else
  [n, m] = size(F);
  if p == 0
    xcp = ones(n,m);
  else  
    [hx, dummy1, lx, dummy2] = gridfdims(F);
    xfirst =  0 + hx/2 - c;
    xlast  = lx - hx/2 - c;
    lineofxcp = linspace(xfirst, xlast, m);
    xcp = lineofxcp(ones(1,n),:);   % Tony's trick
    if p ~= 1
      xcp = xcp.^p;
    end
  end
end  
%------------------------------------------------------------------------------
