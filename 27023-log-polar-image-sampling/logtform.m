function t = logtform(rmin, rmax, nr, nw)
% LOGTFORM makes a log-polar transform structure for imtransform
%     T = LOGTFORM(RMIN, RMAX, NR, NW) returns the transform structure for
%     a system with minimum ring radius RMIN, maximum ring radius RMAX, NR
%     rings and NR wedges. The empty matrix may be given for any one (but
%     only one) of these in which case the circular-samples condition
%     RMAX=RMIN*exp(2*pi*(NR-1)/NW) will be applied (with an adjustment
%     to RMIN if necessary to make NR and NW integers.
%
% See also LOGSAMPLE, LOGSAMPBACK

% Copyright David Young 2010

[rmin, rmax, nr, nw, k] = complete_args(rmin, rmax, nr, nw);
tdata = struct('rmin', rmin, 'rmax', rmax, 'nr', nr, 'nw', nw, 'k', k);
t = maketform('custom', 2, 2, @contorth, @rthtocon, tdata);
end

function x = contorth(u, t)
% Conventional to log-polar. See maketform.
td = t.tdata;
[th, p] = cart2pol(u(:,1), u(:, 2));
p(~p) = td.rmin/2;            % Omit centre point
x = [td.k * log(p/td.rmin),  td.nw*mod(th/(2*pi), 1)];
end

function u = rthtocon(x, t)
% Log-polar to conventional. See maketform.
td = t.tdata;
p = td.rmin * exp(x(:, 1)/td.k);
th = (2*pi/td.nw) * x(:, 2);
[x, y] = pol2cart(th, p);
u = [x, y];
end

function [rmin, rmax, nr, nw, k] = complete_args(rmin, rmax, nr, nw)
% Circular pixels condition
if isempty(rmin)
    k = nw / (2*pi);
    rmin = rmax * exp((1-nr)/k);
elseif isempty(rmax)
    k = nw / (2*pi);
    rmax = rmin * exp((nr-1)/k);
elseif isempty(nw)
    k = (nr-1) / log(rmax/rmin);
    nw = round(2 * pi * k);
    k = nw / (2*pi);
    rmin = rmax * exp((1-nr)/k);
elseif isempty(nr)
    k = nw / (2*pi);
    nr = round(k * log(rmax/rmin) + 1);
    rmin = rmax * exp((1-nr)/k);
else
    k = (nr-1) / log(rmax/rmin);
end
end
