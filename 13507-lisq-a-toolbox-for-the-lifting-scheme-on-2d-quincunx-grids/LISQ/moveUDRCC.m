function M = moveUDRCC(F, d)
%------------------------------------------------------------------------------
% Moves gridfunction F in vertical direction.
% Excess area is filled by Cell-Centered (CC) Reflection across boundaries.
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: June 23, 2000.
% (c) 1999-2002 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
[n, m] = size(F);
if d > 0
  if d > (n-1)
    error(' moveUDRCC    d >= n ')
  else
    M = [flipud(F(1:d,:)); F(1:(n-d),:)];
  end
elseif d < 0
  if -d >= n
    error(' moveUDRCC   -d >= n ')  
  else  
    M = [F((-d+1):n,:); flipud(F((n+1+d):n,:))];
  end
else
  M = F;
end
%------------------------------------------------------------------------------
