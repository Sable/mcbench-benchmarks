function r = uminus(p)
% MEAS/UMINUS  Implement -p for meas.

% make a meas called r
r = meas();

% give it the right entries
r.value = (-p.value);
r.error = p.error;