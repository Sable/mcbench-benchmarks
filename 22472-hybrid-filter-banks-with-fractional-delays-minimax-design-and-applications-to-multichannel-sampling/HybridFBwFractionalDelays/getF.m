function [num, den] = getF(Af, Bf, Cf, Df, M)

% getF: get the IIR filters F_1(z),..., F_N(z) from the system F
%
% Usage:    [num, den] = getF(Af, Bf, Cf, Df, M)
%
% INPUTS: 
%   Af, Bf, Cf, Df:     state space matrices of the designed system F
%   M:  superresolution factor (integer)
%
% OUTPUTS: 
%   num: numerator vectors
%   den: denominator vectors
%
% filter F_i(z) will be an IIR filter with num{i} is the coefficients of
% the numerator and den{i} is the coefficients of the denominator.
%
% See also: designIIR

% system for F(z^M)
Am = eye( (M-1) * size(Af,1) );
Am = [zeros( size(Am,1), size(Af,2) )       Am;
      Af           zeros( size(Af,1), size(Am,2) )];

Bm = [Bf;  zeros( (M-1)*size(Bf,1), size(Bf,2) )];  
Cm = [Cf,  zeros( size(Cf,1), (M-1)*size(Cf,2))];
Dm = Df;

syso = tf(1, [1 zeros(1,M-1)], -1);   
sysm = syso * ss(Am, Bm, Cm, Dm, -1);


% system for [1 z^{-1} ... z^{-M+1}]
Az = [zeros(M-1,1)  eye(M-1);    zeros(1,M)];
Bz = Az;
Cz = [1 zeros(1,M-1)];
Dz = [1 zeros( 1, size(Bz,2)-1 )];

sysz = ss(Az, Bz, Cz, Dz, -1);

%% Connect both system to get the synthesis filters
[As,Bs,Cs,Ds] = ssdata(sysz * sysm);

num = cell(1, size(Ds,2));
den = cell(1, size(Ds,2));

for i = 1:size(Ds,2)
    [A, B, C, D] = minreal(As, Bs(:,i), Cs, Ds(:,i));
    [num{i}, den{i}] = ss2tf(A, B, C, D); 
end

