function ph=phase4(cp,mode)
% PHASE4 4 Quadrant arctangent.
%        PHASE4 provides a 4 quadrant arctangent of a complex number such
%        that -360 < PH <= 0.  It also takes care of wrapping when
%        necessary.

% Author: Craig Borghesani
% Date: 8/17/94
% Revised: 10/24/94
% Copyright (c) 1999, Prentice-Hall

ph = atan2(imag(cp),real(cp));

if nargin == 1, % normal phase computation for frequency response plots

 ph = ph - 2*pi*(ph>1e-5);

else % unwrap phase values for gain (phase) plot

 [r,c] = size(ph);
 for k = 1:c,
  dph = diff(ph(:,k));
  loc_brk = find(abs(dph)>pi);
  if length(loc_brk),
   brks = loc_brk;
   if dph(loc_brk(1)) > 0, brks = [0;brks]; end
   if dph(loc_brk(length(loc_brk))) < 0, brks = [brks;length(ph)]; end
   for k2 = 1:2:length(brks),
    ph((brks(k2)+1):(brks(k2+1)),k) = ph((brks(k2)+1):(brks(k2+1)),k) + 2*pi;
   end
  end
 end

end

