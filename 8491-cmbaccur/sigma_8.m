function   s1 = sigma_8(k, k1, psm1, h)
% sigma_8.m calculates  the integrant for the expected rms mass overdensity in a sphere of radius 8 Mpc/h.
% input : k, wavenumber in units h/Mpc and the vectors k1 resp psm1, the mass power spectrum as a 
% function of k1
% output : the integrant to obtain sigma_8, the rms mass overdensity sampled with
% a sphere of radius 8/h Mpc.

% D Vangheluwe 15 july 2005

% radius of the sphere in units Mpc/h
r0 = 8/h;
x = k * r0;
% calculate the point in the mass power spectrum at k :
psm = spline(k1, psm1, k);

% calculate the integrant:
s1 = (3*(sin(x) - x .* cos(x)) ./ (x .^3)) .^2 .* psm .* k .^2; 

return
