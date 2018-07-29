function [F00xcp, F11xcp] = Q0011xcpowp(F00, F11, p, c)
%------------------------------------------------------------------------------
%
% This function computes the gridfunction {F00xcp U F11xcp} of size {F00 U F11}
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
% Last Revision: February 5, 2001.
% (c) 1999-2001 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
if isempty(F00) || isempty(F11)
  error(' Q0011xcpowp - at least one colour not present (empty) ')
else
  [n00, m00] = size(F00);
  [n11, m11] = size(F11);  
  if p == 0
    F00xcp = ones(n00, m00);
    F11xcp = ones(n11, m11);    
  else  
    [hx, hy] = Q0011gridfdims(F00, F11);
%    
    xfirst =  0 + hx/2 - c;
    xlast  =  xfirst + (m00 - 1) * 2 * hx;
    lineofxcp = linspace(xfirst, xlast, m00);
    F00xcp = lineofxcp(ones(1,n00),:);   % Tony's trick
    if p ~= 1
      F00xcp = F00xcp.^p;
    end
%    
    xfirst = 0 + 3*hx/2 - c;
    xlast  = xfirst + (m11 - 1) * 2 * hx;
    lineofxcp = linspace(xfirst, xlast, m11);
    F11xcp = lineofxcp(ones(1,n11),:);   % Tony's trick
    if p ~= 1
      F11xcp = F11xcp.^p;
    end  
  end  
end  
%------------------------------------------------------------------------------
