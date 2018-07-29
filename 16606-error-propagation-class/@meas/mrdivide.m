function r = mrdivide(p,q)
% MEAS/MRDIVIDE  Implement p / q for meas.

% make a meas called r
r = meas();

% give it the right entries
r.value = p.value / q.value;
r.error = r.value * sqrt((p.error/p.value)^2 + (q.error/q.value)^2);