function  lt = ageuniv(z, om, omt, h)
% integrant to calculate the age of the universe via int(dz/H(z))
%
% D Vangheluwe 31 mrt 2005
% modified for curved space with extra parameter omt for curvature


global GL_cmb_ka1
ka1 = GL_cmb_ka1;

ha = sqrt(om * (1 + z) .^3 + (ka1/h^2) * (1 + z) .^4 + (omt - om - ka1/h^2) + (1 - omt) * (1 + z) .^2);
lt = -1 ./((z + 1) .* ha); 
