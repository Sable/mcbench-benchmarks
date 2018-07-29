function [num, den, gamma] = designIIR(phi, D, m0, h, M)

% designIIR: design filters F_i(z) (as in Section III.B.)
%
% Usage:    [num, den, gamma] = designIIR(phi, D, m0, h, M)
%
% INPUTS: 
%   phi: input rational transfer functions
%   D:   vector of fractional delays
%   m0:  system delay tolerance
%   h:   fast sampling interval
%   M:   superresolution factor (integer)
%
% OUTPUTS: 
%   gamma:  the H infinity norm of the induced error system K
%   num: numerator vectors
%   den: denominator vectors
%
% filter F_i(z) will be an IIR filter with num{i} is the coefficients of
% the numerator and den{i} is the coefficients of the denominator.
%
% See also: getF, demo

% Get the ingeter and residual of the delays
m = floor(D(:)/h);
d = D(:) - m * h;

% Get the digital system as in Prop. 1 and 2
Ad = getAd(phi, h, d);
Bd = getBd(phi, h, d);
Cd = getCd(phi, h, d);
Dd = zeros(size(Cd,1), size(Bd,2));

% The Integer Delay Operator
sysd = IntDelayOp([m0; m]);

% Get the digital system as in Prop. 3 by taking into account the integer
% delay operators
sys = sminreal( sysd * ss(Ad, Bd, Cd, Dd, -1) );    % sminreal to reduce the system's dimension on the fly 
% sys = sysd * ss(Ad, Bd, Cd, Dd, -1);

% Get the system P (see Fig. 6)
[Ap, Bp, Cp, Dp, p, q] = getP(sys, M);

% Convert P into analog, since hinfsyn works in analog domain
[Ac, Bc, Cc, Dc] = Digital2Analog(Ap, Bp, Cp, Dp);

% Design in continuous time
P = pck(Ac, Bc, Cc, Dc);

ubd = 1;
lbd = 0;
inc = .0001;

[F, g, gamma] = hinfsyn(P,p,q,lbd,ubd,inc);

% Get the synthesis system F
[Af, Bf, Cf, Df] = unpck(F);

% Convert F back to digital domain
[Af, Bf, Cf, Df] = Analog2Digital(Af, Bf, Cf, Df);

% Convert to filter coefficients
[num, den] = getF(Af, Bf, Cf, Df, M);
