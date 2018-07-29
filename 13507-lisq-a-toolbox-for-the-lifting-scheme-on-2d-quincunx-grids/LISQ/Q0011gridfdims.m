function [hx, hy, lx, ly] = Q0011gridfdims(F00, F11)
%------------------------------------------------------------------------------
%
% This function determines the dimensions of quincunx gridfunction {F00 U F11}.
%
% [hx, hy] = Q0011gridfdims(F00, F11) yields meshwidths in x- and y-dir.
%
% [hx, hy, lx, ly] = Q0011gridfdims(F00, F11) yields meshwidths
%                    in x- and y-dir
%                    and dimensions of domain of {F00 U F11}.
%
%         x m
%     o---->
%     |
%   y |            
%     v
%   n
%
% See also: gridfdims, Q1001gridfdims
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: February 1, 2001.
% (c) 1999-2001 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
[n00, m00]=size(F00);
[n11, m11]=size(F11);
if n11 > n00
  error(' Q0011gridfdims - dimensions do not match for n11 > n00 ')
end
if m11 > m00
  error(' Q0011gridfdims - dimensions do not match for m11 > m00 ')
end
if n00 > n11+1
  error(' Q0011gridfdims - dimensions do not match for n00 > n11+1 ')
end
if m00 > m11+1
  error(' Q0011gridfdims - dimensions do not match for m00 > m11+1 ')
end
%
% m11 <= m00 <= m11+1 is satisfied
% n11 <= n00 <= n11+1 is satisfied
%
%------------------------------------------------------------------------------
n = n00 + n11;
m = m00 + m11;
if nargout == 2
  if m<n
    hx = 1.0/m;
    hy = hx;
  else
    hy = 1.0/n;
    hx = hy;
  end
elseif nargout == 4
  if m<n
    lx = 1.0;
    ly = (n*lx)/m;
    hx = lx/m;
    hy = hx;
  else
    ly = 1.0;
    lx = (m*ly)/n;
    hy = ly/n;
    hx = hy;
  end
else
  error(' Q0011gridfdims - wrong number of output arguments ')
end
%------------------------------------------------------------------------------
