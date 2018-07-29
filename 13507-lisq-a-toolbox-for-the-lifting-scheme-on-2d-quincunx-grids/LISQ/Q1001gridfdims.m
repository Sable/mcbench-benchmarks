function [hx, hy, lx, ly] = Q1001gridfdims(F10, F01)
%------------------------------------------------------------------------------
%
% This function determines the dimensions of quincunx gridfunction {F10 U F01}.
%
% [hx, hy] = Q1001gridfdims(F10, F01) yields meshwidths in x- and y-dir.
%
% [hx, hy, lx, ly] = Q1001gridfdims(F10, F01) yields meshwidths
%                    in x- and y-dir
%                    and dimensions of domain of {F10 U F01}.
%
%         x m
%     o---->
%     |
%   y |            
%     v
%   n
%
% See also: gridfdims
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: December 12, 2000.
% (c) 1999-2000 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
[n10, m10]=size(F10);
[n01, m01]=size(F01);
if m01 > m10
  error(' Q1001gridfdims - dimensions do not match for m01 > m10 ')
end 
if n10 > n01
  error(' Q1001gridfdims - dimensions do not match for n10 > n01 ')
end 
if m10 > m01+1
  error(' Q1001gridfdims - dimensions do not match for m10 > m01+1 ')
end 
if n01 > n10+1
  error(' Q1001gridfdims - dimensions do not match for n01 > n10+1 ')
end 
%
% m01 <= m10 <= m01+1 is satisfied
% n10 <= n01 <= n10+1 is satisfied
%
%------------------------------------------------------------------------------
n = n10 + n01;
m = m10 + m01;
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
  error(' Q1001gridfdims - wrong number of output arguments ')
end
%------------------------------------------------------------------------------
