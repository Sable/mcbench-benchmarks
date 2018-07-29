% Polar to Rectangular Conversion
% [RECT] = RECT2POL(RHO, THETA)
% RECT - Complex matrix or number, RECT = A + jB, A = Real, B = Imaginary
% RHO - Magnitude
% THETA - Angle in radians

function rect = pol2rect(rho,theta)
rect = rho.*cos(theta) + j*rho.*sin(theta);