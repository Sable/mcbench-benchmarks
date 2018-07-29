% Plot a projection of the vector of spherical
% harmonics with coefficients by the two degree 5
% and order 3 terms set to 1
vec = SHCreateVec(6);
vec = SHSetValue(vec,2.2,0,0);
vec = SHSetValue(vec,1,5,3);
vec = SHSetValue(vec,1,5,-3);
SHPlotProj(vec,10,'interp');

% Obtain the value of the spherical harmonic term
% degree 5 order 3 by sin(m*phi) at longitude 90
% and co-latitude -60 degrees
Ylm = SHCreateYVec(6,90,-60,'deg');
val = Ylm(SHlm2n(5,-3));