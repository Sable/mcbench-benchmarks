function M = moveUDRVC(F, d)
%------------------------------------------------------------------------------
% Moves gridfunction F in vertical direction.
% Excess area is filled by Vertex-Centered (VC) Reflection across boundaries.
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: June 23, 2000.
% (c) 1999-2002 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
[n, m] = size(F);
if d > 0
  if (d+1) > n
    error(' moveUDRVC    d >= n ')
  else
    M = [flipud(F(2:(d+1),:)); F(1:(n-d),:)];
  end
elseif d < 0
  if (-d+1) > n
    error(' moveUDRVC   -d >= n ')  
  else  
    M = [F((-d+1):n,:); flipud(F((n+d):(n-1),:))];
  end
else
  M = F;
end
%------------------------------------------------------------------------------
