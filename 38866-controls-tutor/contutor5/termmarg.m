function [gm, gc, pm, pc] = termmarg(dB,degrees,w)
%
% Utility Function: TERMMARG
%
% The purpose of this function is to compute the gain and phase margins
% from the frequency response data

% Author: Craig Borghesani
% Date: 9/19/94
% Revised: 10/27/94
% Copyright (c) 1999, Prentice-Hall

%
% DETERMINING GAIN MARGIN
%
% find where the phase is less than -180 degrees.  this is done by adding
% +180 degrees and looking for where the sign changes from +1 to -1

shift_degrees = degrees + 180;
sign_deg = sign(shift_degrees);
diff_sign = abs([0,diff(sign_deg)]);
cross_180 = find(diff_sign == 2);

% what if phase vector begins at -180 (or very close to)
if shift_degrees(1) < 1 & shift_degrees(1) > -1,
 cross_180 = [2,cross_180];
end

% determine frequencies that saddle the -180 degree point
if length(cross_180),
 loc1 = cross_180 - 1;
 loc2 = cross_180;

% eliminate ghost crossings
 loc1(abs(shift_degrees(loc1)) > 20) = [];
 loc2(abs(shift_degrees(loc2)) > 20) = [];

 if length(loc1),
  degrees1 = degrees(loc1);
  degrees2 = degrees(loc2);
  w1 = w(loc1);
  w2 = w(loc2);

  dB1      = dB(loc1);
  dB2      = dB(loc2);

% compute slope of line between the two points
  deg_slope = (degrees2 - degrees1)./(log10(w2) - log10(w1));
  mag_slope = (dB2 - dB1)./(log10(w2) - log10(w1));

% compute y-intercept
  deg_int = degrees1 - deg_slope.*log10(w1);
  mag_int = dB1 - mag_slope.*log10(w1);

% use phase line equation to interpolate crossover frequency at -180 degrees
  gc_vec = 10 .^((-180 - deg_int)./deg_slope);

% use magnitude line equation to interpolate gain margin in dB
  gm_vec = -(mag_slope.*log10(gc_vec) + mag_int);

% return smallest gain margin value in arithmetic
  gm_vec = 10 .^(gm_vec/20);
  [min_gm,loc_min] = min(gm_vec);
  gm = min_gm;
  gc = gc_vec(loc_min);

 else

  gc = NaN;
  gm = inf;

 end
else

 gc = NaN;
 gm = inf;

end

%
% DETERMINING PHASE MARGIN
%
% find where the magnitude is greater than 0 dB.  this is done by seeing
% where the sign changes from +1 to -1
sign_dB = sign(dB);
diff_sign = abs([0,diff(sign_dB)]);
cross_0 = find(diff_sign==2);

% determine frequencies that saddle the 0 dB point
if length(cross_0),

 loc1 = cross_0 - 1;
 loc2 = cross_0;

 w1 = w(loc1);
 w2 = w(loc2);

 dB1      = dB(loc1);
 dB2      = dB(loc2);
 degrees1 = degrees(loc1);
 degrees2 = degrees(loc2);

% compute slope of line between the two points
 mag_slope = (dB2 - dB1)./(log10(w2) - log10(w1));
 deg_slope = (degrees2 - degrees1)./(log10(w2) - log10(w1));

% compute y-intercept
 mag_int = dB1 - mag_slope.*log10(w1);
 deg_int = degrees1 - deg_slope.*log10(w1);

% use magnitude line equation to interpolate crossover frequency at 0 dB
 pc_vec = 10 .^((0 - mag_int)./mag_slope);

% use phase line equation to interpolate phase margin
 pm_vec = 180 + (deg_slope.*log10(pc_vec) + deg_int);

% determine smallest phase margin
 [min_pm,loc_min] = min(pm_vec);
 pm = min_pm;
 pc = pc_vec(loc_min);

else

 pc = NaN;
 pm = inf;

end
