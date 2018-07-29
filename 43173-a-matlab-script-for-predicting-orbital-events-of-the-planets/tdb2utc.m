function jdutc = tdb2utc (jdtdb)

% convert TDB julian date to UTC julian date

% input

%  jdtdb = TDB julian date

% output

%  jdutc = UTC julian date 

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global jdsaved

jdsaved = jdtdb;

% convergence tolerance

rtol = 1.0d-8;

% set lower and upper bounds

x1 = jdsaved - 0.1;

x2 = jdsaved + 0.1;

% solve for UTC julian date using Brent's method

[xroot, froot] = brent ('jdfunc', x1, x2, rtol);

jdutc = xroot;

end


