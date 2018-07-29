function r = mpower(p,q)
% MEAS/MPOWER  Implement p^q for meas.

% make a meas called r
r = meas();

% give it the right entries
r.value = p.value^q;
r.error = r.value * q * (p.error / p.value);