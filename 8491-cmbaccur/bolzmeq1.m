function  dy = bolzmeq1(ct, y, k, om, omb, omt, h)
% function for the bolzman equations, Einstein equations and evolution of the inverse:
% the integration variable is the conformal time (length) ct in Mpc.
% k is the wavenumber (beta in the paper of Zaldarriaga et al.) and k1 is the modfied wavenumber k^2 = k1^2 + K.
% ht, ht + 6*eta are the trace- and the traceless part of the metric perturbation in the synchronic gauge.
% The output dy are the derivatives of (9 columns):
% 1. the scale factor a
% 2. the trace part of the metric perturbation (ht, see above, h in the paper of Zaldarriaga et al.)
% 3. the traceless part (see above) of the metric perturbation (eta) 
% 4. the darkmatter density disturbance (delta)
% 5. the baryon density disturbance (delta_b)
% 6. the baryon velocity (v_b)
% 7. the neutrino monopole (n0)
% 8-14. the neutrino multipoles (n1-n7)
% 15. the radiation monopole (teta0)
% 16-23. the radiation multipoles (teta1-teta8)
% truncation is applied
% additional inputs : k the wavenumber, om is the matter denisty, omb is the baryon density, h the Hubble factor
% and fv = density of neutrinos divided by the sum of the radiation and neutrino densities
% table is a table of values for the optical depth (dtau) in the range 1e-5 <= a <= 3e-3 
% see Zaldarriaga, Seljak and Bertschinger, ApJ nr 494, 491 (1998).
%
% D Vangheluwe 20 mrt 2005
% remark1 : we use massless neutrinos
% remark2 : we use the synchronic gauge for the perturbation of the Einstein equations (0- and 1-order are used)
% remark3: k is the wavenumber and k1 is derived from the formula k1^2 = k^2 + K (k1 is beta in the
%  paper of Zaldarriaga et al.)
% remark4: in the synchronic gauge, the dark matter velocity is zero: this has variable has been omittedfrom the eq

global GL_dt_table  GL_pp_dtau  GL_cmb_h0  GL_cmb_fv  GL_cmb_kg1;
[ny ly] = size(y);

% the hubble constant at present in h Mpc^-1, see my notes p71
h0 = GL_cmb_h0;
% the ratio of the photon density to the critical density, see Dodelson (2.70)
omp = GL_cmb_kg1/h^2;
% total omega of the radiation (radiation + massless neutrinos)
omr = omp/(1 - GL_cmb_fv);
% omega of radiation and neutrinos separately
omn = omp * GL_cmb_fv/(1 - GL_cmb_fv);

dy = zeros(ny, ly);
a = y(1,:);
% the square of the baryon sound speed
R = 0.75* omb * a/omp;
cs2 = 1./(3*(1 + R));
K = (omt - 1) * (h0 * h)^2;
k1 = sqrt(k^2 - K);

% find the optical length by interpolation from table (Peebles result)
%dtau = spline(GL_dt_table(1,:), GL_dt_table(3,:), a);
%dtau = interp1(GL_dt_table(1,:), GL_dt_table(3,:), a);
%dtau = interp1q(GL_dt_table(1,:)', GL_dt_table(3,:)', a')';
dtau = ppval(GL_pp_dtau, a);
%dtau = 0;
dy(1,:) = h0 * h * a.^2 .* sqrt(omr./a.^4 + om./a.^3 + (omt - omr - om)  + (1 - omt)./a .^2);
dy(2,:) = ((k1^2 - 3*K) * y(3,:) + (h0 * h)^2 * ... 
 ( (1.5 ./a) .* ((om - omb) * y(4,:) + omb * y(5,:)) +  ...
 (6 ./a.^2) .* (omp * y(15,:) + omn * y(7,:)) ))./(0.5 * dy(1,:)./a);
dy(3,:) = (-0.5 * K * dy(2,:) + (h0 * h)^2 * k1 * ...
 ( (1.5 ./a) .* (omb * y(6,:)) + (6 ./a.^2) .* (omp * y(16,:) + omn * y(8,:)) ))./(k1^2 - 3*K);
dy(4,:) = -0.5 * dy(2,:);
dy(5,:) = (-k1) * y(6,:) - 0.5 * dy(2,:);
dy(6,:) = (-dy(1,:)./a) .* y(6,:) + (dtau./R) .* (3 * y(16,:) - y(6,:));
% derivatives of the neutrino multipoles and the truncation
dy(7,:) = -k * y(8,:) - dy(2,:)/6;
dy(8,:) = (k/3) * (y(7,:) - 2 * y(9,:));
dy(9,:) =  (k/5) * (2 * y(8,:) - 3 * y(10,:)) + (1/15) * (dy(2,:) + 6* dy(3,:));
dy(10,:) = (k/7) * (3 * y(9,:) - 4 * y(11,:));
dy(11,:) = (k/9) * (4 * y(10,:) - 5 * y(12,:));
dy(12,:) = (k/11) * (5 * y(11,:) - 6 * y(13,:));
dy(13,:) = (k/13) * (6 * y(12,:) - 7 * y(14,:));
dy(14,:) = (k/15) * (7 * y(13,:) - 8 * (15 * y(14,:)./(k*ct') - y(13,:)));
% derivatives of the photon multipoles and the truncation
dy(15,:) = -k * y(16,:) - dy(2,:)/6;
dy(16,:) = (k/3) * (y(15,:) - 2 * y(17,:)) + dtau .* (y(6,:)/3 - y(16,:));
dy(17,:) = (k/5) * (2 * y(16,:) - 3 * y(18,:)) + (1/15) * (dy(2,:) + 6* dy(3,:)) - 0.9* dtau .* y(17,:);
%dy(17,:) = (k/5) * (2 * y(16,:) - 3 * y(18,:)) - dtau .* y(17,:);
dy(18,:) = (k/7) * (3 * y(17,:) - 4 * y(19,:)) - dtau .* y(18,:);
dy(19,:) = (k/9) * (4 * y(18,:) - 5 * y(20,:)) - dtau .* y(19,:);
dy(20,:) = (k/11) * (5 * y(19,:) - 6 * y(21,:)) - dtau .* y(20,:);
dy(21,:) = (k/13) * (6 * y(20,:) - 7 * y(22,:)) - dtau .* y(21,:);
dy(22,:) = (k/15) * (7 * y(21,:) - 8 * y(23,:)) - dtau .* y(22,:);
dy(23,:) = (k/17) * (8 * y(22,:) - 9 * (17 * y(23,:)./(k*ct') - y(22,:))) - dtau .* y(23,:);

return


