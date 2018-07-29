function [F10xcp, F01xcp] = Q1001xcpowp(F10, F01, p, c)
%------------------------------------------------------------------------------
%
% This function computes the gridfunction {F10xcp U F01xcp} of size {F10 U F01}
% with values (x-c)^p at its gridpoints. Piecewise constant approximation is 
% assumed.
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
% Last Revision: December 12, 2000.
% (c) 1999-2000 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
if isempty(F10) || isempty(F01)
  error(' Q1001xcpowp - at least one colour not present (empty) ')
else
  [n10, m10] = size(F10);
  [n01, m01] = size(F01);  
  if p == 0
    F10xcp = ones(n10, m10);
    F01xcp = ones(n01, m01);    
  else  
    [hx, hy] = Q1001gridfdims(F10, F01);
%    
    xfirst =  0 + hx/2 - c;
    xlast  =  xfirst + (m10 - 1) * 2 * hx;
    lineofxcp = linspace(xfirst, xlast, m10);
    F10xcp = lineofxcp(ones(1,n10),:);   % Tony's trick
    if p ~= 1
      F10xcp = F10xcp.^p;
    end
%    
    xfirst = 0 + 3*hx/2 - c;
    xlast  = xfirst + (m01 - 1) * 2 * hx;
    lineofxcp = linspace(xfirst, xlast, m01);
    F01xcp = lineofxcp(ones(1,n01),:);   % Tony's trick
    if p ~= 1
      F01xcp = F01xcp.^p;
    end  
  end  
end  
%------------------------------------------------------------------------------
