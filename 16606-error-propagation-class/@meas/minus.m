function r = minus(p,q)
% MEAS/MINUS  Implement p - q for meas.

% make a meas called r
r = meas();

% give it the right entries
r.value = p.value - q.value;
r.error = sqrt(p.error^2 + q.error^2);