function  dy = bolzmeq2(ct, y, k, om, omb, omt, h)
% function for the bolzman equations, Einstein equations and evolution of the inverse: the integration variable is
%  the conformal time ct in Mpc.
% input: ct, conformal time, y, variables to be solved see below, k see below, om resp omb, matter resp 
% baryoncontent of the universe, omt, curvature density of space, h, Hubble factor.
% k1 resp k are the wavenumber and help variable (k resp beta in the paper of Zaldarriaga et al. and beta^2 = k^2 + K) 
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
% 24-33 the polarised radiation multipoles (tetap0-tetap8)
% truncation is applied
% additional inputs : k the wavenumber, om is the matter density, omb is the baryon density, h the Hubble factor
% and fv = density of neutrinos divided by the sum of the radiation and neutrino densities
% table is a table of values for the optical depth (dtau) in the range 1e-5 <= a <= 3e-3 
% see Zaldarriaga, Seljak and Bertschinger, ApJ nr 494, 491 (1998).
%
% D Vangheluwe 20 mrt 2005
% remark1 : we use massless neutrinos, of 3 kinds.
% remark2 : we use the synchronic gauge for the perturbation of the Einstein equations (0- and 1-order are used)
% remark3: attention : k is NOT the wavenumber, k1 is the wavenumber and k (or beta) is derived from the formula 
%   k^2 = k1^2 + K (k is beta in the paper of Zaldarriaga et al.) such that its range is from 0-> inf, as k1 has
%   a limited range (sqrt(-K) < k1 < inf)
% remark4: in the synchronic gauge, the dark matter velocity is zero: this variable has been omitted from the eq
% remark5: the truncation is done with the help of the recursive relation for ultra-spherical Bessel functions 
%    Abbott and Schaeffer, ApJ, nr 308, 546 (1986) A24, see also Ma and Bertschinger, ApJ nr 455 (1995) eq (51) 
%    for the truncation of the Bolzman equations in flat space.
% remark6: the equations below are from the article of M.Zaldarriaga,et al, ApJ 494,491-502(1998) with a correction
% in the two Einstein equations (4) ->
% the first equation (4) to the right of the + sign: -8*pi should be -4*pi
% the second equation (4) : the term 0.5*K*hdot should have a minus sign, 
% for the correct Einstein equations see also W Hu, PhysRev D57, 3290-3301 (1998) equations (A8) with 6*hL = h
% and hL + hT/3 = -eta.

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
K = (omt - 1) * (h0 * h)^2;
k1 = sqrt(k^2 - K);
k2 = sqrt(abs(K));
if K == 0
   trf = 1./(k*ct');
elseif K < 0
   trf = (k2/k) * coth(k2*ct');
else
   trf = (k2/k) * cot(k2*ct');
end

% find the optical length by interpolation from table (Peebles result)
%dtau = spline(GL_dt_table(1,:), GL_dt_table(3,:), a);
%dtau = interp1(GL_dt_table(1,:), GL_dt_table(3,:), a);
%dtau = interp1q(GL_dt_table(1,:)', GL_dt_table(3,:)', a')';
dtau = ppval(GL_pp_dtau, a);
%dtau = 0;
b1 = sqrt(1 - K/k^2);
b2 = sqrt(1 - 4*K/k^2);
bst = b2/b1;
if (1 - 9*K/k^2) > 0,   b3 = sqrt(1 - 9*K/k^2);  else, b3 = 0; end
if (1 - 16*K/k^2) > 0,   b4 = sqrt(1 - 16*K/k^2);  else, b4 = 0; end
if (1 - 25*K/k^2) > 0,   b5 = sqrt(1 - 25*K/k^2);  else, b5 = 0; end
if (1 - 36*K/k^2) > 0,   b6 = sqrt(1 - 36*K/k^2);  else, b6 = 0; end
if (1 - 49*K/k^2) > 0,   b7 = sqrt(1 - 49*K/k^2);  else, b7 = 0; end
if (1 - 64*K/k^2) > 0,   b8 = sqrt(1 - 64*K/k^2);  else, b8 = 0; end

ppi = y(17,:) - 12* y(26,:);
dy(1,:) = h0 * h * a.^2 .* sqrt(omr./a.^4 + om./a.^3 + (omt - omr - om)  + (1 - omt)./a.^2);
dy(2,:) = ((k1^2 - 3*K) * y(3,:) + (h0 * h)^2 * ... 
 ( (1.5 ./a) .* ((om - omb) * y(4,:) + omb * y(5,:)) +  ...
 (6 ./a.^2) .* (omp * y(15,:) + omn * y(7,:)) ))./(0.5 * dy(1,:)./a);
dy(3,:) = (0.5 * K * dy(2,:) + (h0 * h)^2 * k1 * ...
    ( (1.5 ./a) .* (omb * y(6,:)) + (6 ./a.^2) .* (omp * y(16,:) + omn * y(8,:)) ))./(k1^2 - 3*K);
dy(4,:) = -0.5 * dy(2,:);
dy(5,:) = (-k1) * y(6,:) - 0.5 * dy(2,:);
dy(6,:) = (-dy(1,:)./a) .* y(6,:) + (dtau./R) .* (3 * y(16,:) - y(6,:));
% derivatives of the neutrino multipoles and the truncation
dy(7,:) = -k * b1 *y(8,:) - dy(2,:)/6;
dy(8,:) = (k/3) * (b1 *y(7,:) - 2 * b2 *y(9,:));
dy(9,:) =  (k/5) * (2 * b2 *y(8,:) - 3 * b3 *y(10,:)) + (1/15) * bst *(dy(2,:) + 6* dy(3,:));
dy(10,:) = (k/7) * (3 * b3 *y(9,:) - 4 * b4 *y(11,:));
dy(11,:) = (k/9) * (4 * b4 *y(10,:) - 5 * b5 *y(12,:));
dy(12,:) = (k/11) * (5 * b5 *y(11,:) - 6 * b6 *y(13,:));
dy(13,:) = (k/13) * (6 * b6 *y(12,:) - 7 * b7 *y(14,:));
dy(14,:) = (k/15) * (7 * b7 *y(13,:) - 8 * (15 * trf .* y(14,:) - b7 *y(13,:)));
% derivatives of the photon multipoles and the truncation
dy(15,:) = -k * b1 *y(16,:) - dy(2,:)/6;
dy(16,:) = (k/3) * (b1 *y(15,:) - 2 * b2 *y(17,:)) + dtau .* (y(6,:)/3 - y(16,:));
dy(17,:) = (k/5) * (2 * b2 *y(16,:) - 3 * b3 *y(18,:)) + (1/15) * bst *(dy(2,:) + 6* dy(3,:)) - ...
     dtau .* (y(17,:) - 0.1 * ppi);
dy(18,:) = (k/7) * (3 * b3 *y(17,:) - 4 * b4 *y(19,:)) - dtau .* y(18,:);
dy(19,:) = (k/9) * (4 * b4 *y(18,:) - 5 * b5 *y(20,:)) - dtau .* y(19,:);
dy(20,:) = (k/11) * (5 * b5 *y(19,:) - 6 * b6 *y(21,:)) - dtau .* y(20,:);
dy(21,:) = (k/13) * (6 * b6 *y(20,:) - 7 * b7 *y(22,:)) - dtau .* y(21,:);
dy(22,:) = (k/15) * (7 * b7 *y(21,:) - 8 * b8 *y(23,:)) - dtau .* y(22,:);
dy(23,:) = (k/17) * (8 * b8 *y(22,:) - 9 * (17 * trf .* y(23,:) - b8 *y(22,:))) ...
     - dtau .* y(23,:);
% derivatives of polarised photon multipoles
%dy(24,:) = -3*k * y(25,:) - dtau .* y(24,:);
%dy(25,:) = (k/3) * (-b1 * y(24,:) - 4 * b2 *y(26,:)) - dtau .* y(25,:);
dy(24,:) = 0;
dy(25,:) = 0;
dy(26,:) = (k/5) * (- 5 * b3 *y(27,:)) - dtau .* (y(26,:) + 0.05 *ppi);
dy(27,:) = (k/7) * (b3 * y(26,:) - 6 * b4 * y(28,:)) - dtau .* y(27,:);
dy(28,:) = (k/9) * (2 * b4 * y(27,:) - 7 * b5 * y(29,:)) - dtau .* y(28,:);
dy(29,:) = (k/11) * (3 * b5 * y(28,:) - 8 * b6 * y(30,:)) - dtau .* y(29,:);
dy(30,:) = (k/13) * (4 * b6 * y(29,:) - 9 * b7 * y(31,:)) - dtau .* y(30,:);
dy(31,:) = (k/15) * (5 * b7 * y(30,:) - 10 * b8 * y(32,:)) - dtau .* y(31,:);
dy(32,:) = (k/17) * (6 * b8 * y(31,:) - 11 * (17 * trf .* y(32,:) - b8 *y(31,:))) ...
    - dtau .* y(32,:);

return


