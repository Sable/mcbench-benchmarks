function M = moveUDZ(F, d)
%------------------------------------------------------------------------------
% Moves gridfunction F in vertical direction.
% Excess area is filled by padding with zeroes.
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: June 23, 2000.
% (c) 1999-2002 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
[n, m] = size(F);
if d > 0
  if d > (n-1)
    error(' moveUDZ    d >= n ')
  else
    M = [reshape(linspace(0,0,m*d), d, m); F(1:(n-d),:)];
  end
elseif d < 0
  if -d > (n-1)
    error(' moveUDZ   -d >= n ')
  else
    M = [F((-d+1):n,:); reshape(linspace(0,0,-m*d), -d, m)];
  end
else
  M = F;
end
%------------------------------------------------------------------------------
