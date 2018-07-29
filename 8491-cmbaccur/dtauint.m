function  tau = dtauint(z, pp, om, omb, omt, h)
% calculates the integrant for integration of the optical length dtau over the redshift z
% dtau in Mpc^-1 is extracted from interpolation in a table which has been splined.
% pp is the spline of the interpolation for tau values as f of the redshift in this table.
% futher arguments in dtau_tabel are :matter fraction (om), baryon fraction (omb and rel Hubble constant (h)
% ha is the full Hubble factor = sqrt(rho/rho_crit)
%
% D Vangheluwe 31 mrt 2005
% modified for curved space with extra argument omt

global GL_cmb_ka1
ka1 = GL_cmb_ka1;
ha = (1e5 * h) * sqrt(om * (1 + z) .^3 + (ka1/h^2) * (1 + z) .^4 + (omt - om - ka1/h^2) + (1 - omt) * (1 + z) .^2);
tau = ppval(pp, z) .* (1 + z) .^ 2 ./ha;

