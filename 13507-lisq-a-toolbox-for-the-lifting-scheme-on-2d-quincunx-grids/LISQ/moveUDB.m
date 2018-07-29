function M = moveUDB(F, d)
%------------------------------------------------------------------------------
% Moves gridfunction F in vertical direction.
% Excess area is filled by extension of boundaryvalues.
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: July 7, 2001.
% (c) 1999-2002 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
[n, m] = size(F);
if d > 0
  if (d+1) > n
    error(' moveUDB    d >= n ')
  else
%   M = [flipud(F(2:(d+1),:)); F(1:(n-d),:)];
    B = F(1,:);
    M = [B(ones(1,d),:); F(1:(n-d),:)];
  end
elseif d < 0
  if (-d+1) > n
    error(' moveUDB   -d >= n ')  
  else  
%   M = [F((-d+1):n,:); flipud(F((n+d):(n-1),:))];
    B = F(n,:);
    M = [F((-d+1):n,:); B(ones(1,-d),:)];
  end
else
  M = F;
end
%------------------------------------------------------------------------------
