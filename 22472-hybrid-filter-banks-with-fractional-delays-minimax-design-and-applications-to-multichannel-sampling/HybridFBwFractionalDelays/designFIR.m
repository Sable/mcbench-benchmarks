function [num, den, gamma] = designFIR(phi, D, m0, h, M, n)

% designFIR: design filters F_i(z) (as in Section IV.B.)
%
% Usage:    [num, den, gamma] = designFIR(phi, D, m0, h, M, n)
%
% INPUTS: 
%   phi: input rational transfer functions
%   D:   vector of fractional delays
%   m0:  system delay tolerance
%   h:   fast sampling interval
%   M:   superresolution factor (integer)
%   n:   nM will be the maximum length of designed FIR filters
%
% OUTPUTS: 
%   gamma:  the H infinity norm of the induced error system K
%   num: numerator vectors
%   den: denominator vectors
%
% filter F_i(z) will be an IIR filter with num{i} is the coefficients of
% the numerator and den{i} is the coefficients of the denominator.
%
% See also: getF, demo, lmi_opt

% Get the integer and residualof the delays
m = floor(D(:)/h);
d = D(:) - m * h;

% Get the digital system as in Prop. 2
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

% design of the system F
[Af, Bf, Cf, Df, gamma] = lmi_opt(sys, M, n);

% Convert to the coefficients
[num, den] = getF(Af, Bf, Cf, Df, M);
