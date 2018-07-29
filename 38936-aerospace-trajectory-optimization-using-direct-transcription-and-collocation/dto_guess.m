function xg = dto_guess(ti, tf, xi, xf, ngrid)

% compute linear guess

% required by dto_trap.m

% input

%   ti    = initial time
%   tf    = final time
%   xi    = initial state vector component
%   xf    = final state vector component
%   ngrid = number of grid points in guess

% output

%   xg = array of initial guesses

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% create array of time values at CGL grid points

[t, w] = cgl(ngrid, ti, tf);

% compute slope

xm = (xf - xi) / (tf - ti);

% compute data at grid points

xg(1) = xi;

xg(ngrid) = xf;

for i = 2: ngrid - 1
    
    xg(i) = xm * t(i) + xi;
    
end

