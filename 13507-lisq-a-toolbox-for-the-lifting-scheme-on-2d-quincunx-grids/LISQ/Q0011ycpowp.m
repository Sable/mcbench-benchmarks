function [F00ycp, F11ycp] = Q0011ycpowp(F00, F11, p, c)
%------------------------------------------------------------------------------
%
% This function computes the gridfunction {F00ycp U F11ycp} of size {F00 U F11}
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
% Last Revision: February 5, 2002.
% (c) 1999-2002 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
if isempty(F00) || isempty(F11)
  error(' Q0011ycpowp - at least one colour not present (empty) ')
else
  [n00, m00] = size(F00);
  [n11, m11] = size(F11);  
  if p == 0
    F00ycp = ones(n00, m00);
    F11ycp = ones(n11, m11);    
  else  
    [hx, hy] = Q0011gridfdims(F00, F11);
%    
    yfirst =  0 + 3*hy/2 - c;
    ylast  =  yfirst + (m11 - 1) * 2 * hy;
    lineofycp = linspace(yfirst, ylast, n11)';
    F11ycp = lineofycp(:,ones(m11,1)); 
    if p ~= 1
      F11ycp = F11ycp.^p;
    end
%    
    yfirst =  0 + hy/2 - c;
    ylast  =  yfirst + (m00 - 1) * 2 * hy;
    lineofycp = linspace(yfirst, ylast, n00)';
    F00ycp = lineofycp(:,ones(m00,1)); 
    if p ~= 1
      F00ycp = F00ycp.^p;
    end 
  end  
end  
%------------------------------------------------------------------------------
