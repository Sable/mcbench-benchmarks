function r = uplus(p)
% MEAS/UPLUS  Implement +p for meas.

% make a meas called r
r = meas();

% give it the right entries
r.value = p.value;
r.error = p.error;