function  [c1, lmin1, lmax1, as, pm, sig8] = cmbaccur(van, omt, bmark, one_percent, lmax, stfname)
% cmbaccur.m :
% this program calculates the radiation and matter spectra to an accuracy of 1% or 0.1% for the open, flat and
% closed Friedman-Robertson-Walker universe.
% The radiation spectra include the temperature- polarisation and cross-polarisation spectra.
% We follow the method of Uros Seljak amd Matias Zaldarriaga in 'A line-of-sight integration approach
% to Cosmic microwave background anisotropies', ApJ, nr 469, 437-444 (1996), see also :
% Ma and Bertschinger, ApJ nr 455, 7-25 (1995) and Zaldarriaga, Seljak, Bertschinger
% ApJ nr 494, 491 (1998) and Zaldarriaga and Seljak, ApJ nr129, 431 (2000) and W Hu e.a, 'A complete treatment
% of CMB anisotropies in a FRW universe', Phys Rev D57, 3290-3301 (1998), for reionisation see N Sugiyama, 
% ApJ nr 419 L1-L4 (1993) and ApjS nr 100, 281 (1995)
%
% input : the "vanilla-set" of Cosmological parameters, omt, the curvature of the universe, 
%   bmark : a benchmark (file) to compare with (see remarks), one_percent: the accuracy  
%   is 1% resp 0.1% for ~one_percent==0 resp one_percent==0, the default is 1%, lmax, the maximum 
%   multipoint number, the default lmax value is lmax=1500 (lmax must be <= 1500. otherwise a special
%   la-vector has to be defined), name of the startfile for the ultra-spherical function. 
% no inputs : if no inputs are given the functions takes the default values (see remarks),
% if 5th argument (lmax) is missing, the default value lmax=1500 is taken
%
% output :the normalisation constant (asc), the positions of the peaks (minima and maxima)
% in the temperature anisotropy spectrum (lmin & lmax), as: the temperature anisotropy spectrum, as.ctt 
% the E-polarisation spectrum, as.cee and the cross-correlation spectrum, as.cte, pm: the matter spectrum

% D Vangheluwe 29 jun 2005 finished 4 july 2005
% remark 1: the vanilla-set is (As, omega_lambda, omega_d, omega_b, ns, tau), which are : the amplitude correction
% at l=10, dark energy density, dark matter density, baryon density, scalar spectral index, optical depth.
% The vanilla-set is converted internally to the parameters (c1, om, omt, omb, h, nprimtilt, zri), which are: 
% the amplitude correction at l=10, dark matter omega, total omega, baryon omega, Hubble factor, scalar spectral index, 
% reionisation redshift, see below for the default values. For example: omt = omega_lambda + omega_b + omega_d
% remark 1 this is a compilation of the programs cmbacc1.m and ambacc2.m for resp open (K<=0) and closed space (K>0)
% remark 2 the discrete values of la for closed space are chosen different from the ones for open space : reason that
%  for closed space the peaks in the spectrum shift to lower la and we need more points there : therefore the
%  step change in la is chosen at la =100 resp la = 250 for open/flat resp closed space.
% remark 3 :the lamda content of the universe is automatically : omt - omr -om, for example with omt = 1.1,
%  om = 0.27, h = 0.72 and omr = omp/(1 - fv)= 8.01e-5, we have oml = 0.83, we have chosen here not to
%  specify the lamda energy content of primordial space. For the Vanilla parameters see ambaccur(.)
% remark 4: the different path taken for closed resp open/flat space can be seen at the if (K>0) statements.
%  for K>0 we take a different set of k1 values to solve the Bolzamn equations and a different set of k2
%  (also 'beta' in the literature) values for the calculation of the anistropy spectrum
% remark 6: the connections with the input of cmbfast and our input is a bit difficult : we give the connection
%  for resp omega of the vacuum (omegav), cold dark matter (omegac) and baryons (omegab) :
%  omegav = omt - om, omegac = om - omb, omegab = omb (om is the omega for all matter, baryons+dark matter and omt
%  is the total omega)
% remark 7: try the vanilla-lite model from Tegmark et al. astro-ph/0310723, 15jan 2004:
%   van = [0.89, 0.72, 0.12, 0.024, 1, 0.17] and omt =1, it is the best fit to WMAP2003 +SDSS assuming ns==1 and tensor field zero.
%   or the old cdm model, a universe without dark energy : van = [1, 0.954, 0.0, 0.0115, 1, 0] and omt =1.
% remark 5 (4 aug 2005): if the spectrum needs only to be calculated for a multipole range smaller than the 
%  default lmax0=1500, specify this value <1500 as the last argument, the accuracy is
%  kept in line with this choice (several changes are necessary such as : smaller nkst, extended k1max etc.)
%  The calculation time is proportional to sqrt(lmax), not with lmax!


global GL_dt_table   GL_pp_dtau;
global  GL_cmb_c  GL_cmb_h0   GL_cmb_t0   GL_cmb_T0   GL_cmb_rv   GL_cmb_fv   GL_cmb_kg1   GL_cmb_ka1   ...
  GL_cmb_yp   GL_cmb_ncr   GL_cmb_cr   GL_cmb_pcm   GL_cmb_dha;
% give the global physical constants a value
cmbglobl;

% tolerance
tol = 1e-6;
trace = [];

%cosmological parameters : (As, omega_lambda, omega_d, omega_b, ns, zri) and omt for spacial curvature
if nargin == 0  %take the default vanilla-set (which gives the best fit to wmap2003)
% the default set is : c10=1, om=0.27, omb=0.046, h=0.72, ns=0.99, zri= 17.28
    van = [1, 0.73, 0.1161216, 0.0238464, 0.99, 0.17295];
    omt = 1;
    lmax = 1500;
% the default accuracy is : one_percent == 1, for an of accuracy 1%, the accuracy = 0.1% only for one_percent == 0.
    one_percent = 1
% benchmark calculations to compare : available are cmbfast for h=0.72: 'h72', 'h72i' for reionisation with zri = 17.3
%  'h72o1' for h = 0.72 open universe with omt=1.1, 'h72c1' for h = 0.72 closed universe with omt=0.9, 
% 'cdm', for the CDM model (flat space) (see for more info cmbdata3.m)
    bmark = 'h72i';
else 
   if nargin == 1, error('the benchmark must be defined'), return; end
   if nargin == 2, error('the accuracy must be defined'), return; end
   if nargin == 4, lmax = 1500; end
end
if  ~(one_percent == 0), one_percent = 1; end;

% the hubble factor h
%h = 0.71
%h = 0.72
if (omt - van(2) > 0)
   h = sqrt((van(3) + van(4))/(omt - van(2)))
else
   error('omt < van(2) not allowed');
   return
end

% baryon content of the universe
%omb = 0.0444
%omb = 0.046
omb = van(4)/h^2

% matter content of the universe
%om = 0.27
%om = 0.27
om = (van(3) + van(4))/h^2

% redshift for reionisation
%zri = 0
%zri = 17.28   % tauri = 0.170
%zri = 0
zri = 92*(0.03 * h * van(6)/van(4))^(2/3) * om^(1/3)

% primordial tilt : the exponent of the power spectrum of matter
%nprimtilt = 0.99;
%nprimtilt = 0.99;
nprimtilt = van(5)

% normalisation of the anisotropy spectrum
%c10 = 1.00;
c10 = van(1);

% the cmb temperature
%cmbtemp = 2.725;
cmbtemp = GL_cmb_t0;
% velocity of light in m/s
%c = 2.998e8;
c = GL_cmb_c;
% the hubble constant at present in h Mpc^-1, see my notes p71
%h0 = 1e5/c;
h0 = GL_cmb_h0;
% the ratio of neutrino to total radiation density fv, assuming three massless neutrinos
%rv = (21/8) * (4/11)^(4/3);
%fv = rv/(1 + rv);
fv = GL_cmb_fv;
% amplitude of the primordial density perturbation at the horizon, see Dodelson (8.76)
%dha = 4.6e-5;
dha = GL_cmb_dha;
dha2 = dha^2;
% the ratio of the radiation density and the critical density, see Dodelson (omega_gamma) 
%kg1 = 2.47e-5;
kg1 = GL_cmb_kg1;
%ka1 = kg1/(1 - fv);
ka1 = GL_cmb_ka1;

aeq = ka1/(om * h^2);
keq = h0 * h * sqrt(om*2/aeq);
% omega of radiation and neutrinos separately
omp = kg1/h^2;
omr = omp/(1 - fv);
omn = omp * fv/(1 - fv);
% the constant K for curvature energy content from the Friedman equation
K = (omt - 1) * (h0 * h)^2;

if  nargin < 6
  if K > 0, stfname = 'stfile1';
  else, stfname = 'stfile';
  end
end

tol_ode23 = 1e-5;
if one_percent == 1
  tol_ode23 = 2e-4;  % default 2e-4
end

% find the recombination curve and the inverse optical depth, dtau in Mpc^-1, 
% tau and the visibility function (vsb1) :
dt = recomb(om, omb, omt, h, zri);
%sdata = load('cmbxe');
%dt = sdata.dt;
GL_dt_table = dt.dt_table;
%tauri = dt.tauri;
tauri = van(6);

zdec = dt.zdec;
sizetable = size(GL_dt_table, 2)
at1 = GL_dt_table(1,:);
dtau1 = GL_dt_table(3,:);
%tau1 = GL_dt_table(4,:);
%vsb1 = GL_dt_table(5,:);
% make a spline of dtau
GL_pp_dtau = spline(GL_dt_table(1,:), GL_dt_table(3,:));

% calculate the current conformal time :ctc0 and ctime at reionisation and at decoupling
ctc0 = quadl(@conftim1, 0, 1, tol, trace, om, omr, omt, h);
ctad = quadl(@conftim1, 0, 1/(zdec + 1), tol, trace, om, omr, omt, h);
ctri = quadl(@conftim1, 0, 1/(zri + 1), tol, trace, om, omr, omt, h);

% if the spectrum has become isotropic for K > 0 (all photons are coming from one point) break off:
if (K > 0)
    ct4sym = 0.5 * pi/sqrt(K);
    if  (2*ct4sym < ctc0),  message('the spectrum is isotropic, return'); return; end
    if sqrt(K) * ctc0 > 2, message('curvature K * ctc0 > 2'); end
end

% define the range of l (angle number)
%lmax = 1500;
lmin = 2;

% the wavenumber kw in Mpc^1 (range : 0.2 < kw < 2e-4)
% define the k-range
if one_percent == 1
%  nkst = 44
  nkst = 30 + 10*(lmax - 900)/600;   % adapt the k1step for lmax~1500
else
  nkst = 88
end

% find the maximum multipole number in the startfile for K>0 (lmax0 =default 1500)
stv1 = load(stfname);
lmax0 = stv1.ust.la(end);
if (K > 0)
    k1min = 3*sqrt(K);
%    k1int = 4e-3;
    k1int = 8e-3;
% if K*ctc0 > 2, it is necessary to increase k1max : important change for K>0!!
% and extend the range of k1 in case lmax < maximum of the startfile (lmax0 is default 1500)
    k1max = max(2*sqrt(lmax*lmax0)/ctc0, 1.5*sqrt(lmax*lmax0)*sqrt(K));
    k1step = (k1int - k1min)/8;
    k1step2 = (k1max - k1int)/nkst;
    k1 = [[k1min : k1step : (k1int - k1step)], [k1int : k1step2 : k1max]];
else
    k1min = 1e-5;
    k1int = 8e-3;
% extend the range of k1 in case lmax < maximum of the startfile (lmax0 is default 1500)
    k1max = 2*sqrt(lmax*lmax0)/ctc0;
    k1step = 0.0012;
    k1step2 = (k1max - k1int)/nkst;
    k1 = [k1min, 4e-5, 8e-5, 2e-4, 4e-4, 6e-4, 8e-4 : k1step : k1int, k1int+k1step2 : k1step2 : k1max];
end  %define k1 range
lk1 = size(k1, 2)

% take smaller steps in the same range of the conformal time now ct2:
step0 = ctc0/7000;
if one_percent == 1
  ct2step = step0;
else
  ct2step = step0/2;
end
ct2min = 0.5;
ct2max = ctc0;
ct2 = ct2min : ct2step : ct2max;
lct2 = size(ct2, 2);

%555555555555555555
% solve the Bolzman equations :
[table_srt, table_srp, deltam, a2] = ...
        bolzmslv(ct2, k1, tol_ode23, om, omb, omt, h, ctc0, ctad, zri, ctri, K, one_percent);

% find the conformal time at recombination :
vsb2 = spline(GL_dt_table(1,:), GL_dt_table(5,:), a2);
[vsbm irm] = max(vsb2);
etar = ct2(irm);
% calculate the thickness of the recombination surface in conformal time
ids = find(vsb2 >= 0.5* vsbm);
% half width ct2 points are:
hw1 = ct2(ids(1));
hw2 = ct2(ids(end));
trs = hw2 - hw1;
% number of points over the half width of the visibility function :
nphw = length(ids)
% find an accurate value for the decoupling time (recombination)
ct3 = hw1:0.01:hw2;
vsb3 = spline(ct2, vsb2, ct3);
[vsbm irm] = max(vsb3);
ctad1 = ct3(irm);

% define a k2 range:
if (K > 0)
% define a k-range with more points ->k2  :where kb = 1/3..
    logstep = 0;
    nn2min = fix(k1min/sqrt(K));
    nn2max = fix(k1max/sqrt(K));
    nksteps = 1.5* sqrt(lmax * lmax0);
    nn2step = max(1, round((nn2max - nn2min)/nksteps));
    nn2step = min(2, nn2step);   % limit to nn2step==2
    nn2 = nn2min : nn2step : nn2max;
    k2 = nn2 * sqrt(K);
else

    logstep = 1;
    k2min = k1min;
    k2max = k1max;
    if one_percent == 1
       ek2step = 0.002;
    else
       ek2step = 0.0015;
    end
    ek2 = log(k2min)/log(10) : ek2step : log(k2max)/log(10);
    k2 = 10 .^ ek2;
end % define k2 range
lk2 = size(k2, 2);
ik2 = floor(lk2/2);
ik4 = floor(lk2/4);

% calculate the anisotropy- and polariation spectrum for l > 2 in 2 steps: step1 :l<100 and step2 :l>100
% for l > 100 :select the interval in the conformal time range ct2 where the source is none zero
% for l < 100 :the source extends over a rather large cf time range of 200-ctc0 and we found that
% the ctime integration range must be extended in order to achieve 0.1% accuracy for l < 100
% With reionisation (zri > 0) for 1% accuracy, integration should be extended over the total ct time range.

%##anisotropy spectrum, step1 : l < 100  (2 and lct2-1 to stay within interpolation limits)
ict4min = 2;
%ict4max = lct2 - 1;
ict4max = lct2;
if one_percent == 1
   ict4step = 2;
else
   ict4step = 1;
end 
ict4 = ict4min : ict4step : ict4max;
ct4 = ct2(ict4);
lct4 = size(ict4, 2);

% take as much splines ready for k2 interpolations as there are cftime points in ct4 :
% for each time we have one spline (the splines are in a column vector)
% this steps needs a lot of memory : if short of memory use srcpint.m with pp4, pp5 as argument : this
% is the case for one_percent ~= 1
pp4 = spline(k1, table_srt(:, ict4)');
pp5 = spline(k1, table_srp(:, ict4)');
if one_percent == 1
   src4 = [ppval(pp4, k2(1:ik2)), ppval(pp4, k2(ik2+1:end))];
   src5 = [ppval(pp5, k2(1:ik2)), ppval(pp5, k2(ik2+1:end))];
end

% calculate the anisotropy spectrum for l <= 100
if (one_percent == 1)  &  (K > 0 )
   lstep = 20;
else
   lstep = 10;
end
%la1 = 2;
if (K > 0)
   la1 = [2,6,10, 20:lstep:220];
   lla1 = size(la1,2);
   if one_percent == 1
      [cct1, ta1, te1] = srcintf1(la1, nn2, ct4, src4, src5, ctc0, ctad, nprimtilt, lmax, K, stfname);
   else
      [cct1, ta1, ta2] = srcint1(la1, nn2, ct4, pp4, pp5, ctc0, ctad, nprimtilt, lmax, K, stfname);
   end

else
   la1 = [2,6,10,20:lstep:90];
   lla1 = size(la1,2);
   if one_percent == 1
      [cct1, ta1, te1] = srcintf(la1, k2, ct4, src4, src5, ctc0, nprimtilt, lmax, K, stfname, logstep);
   else
      [cct1, ta1, ta2] = srcint(la1, k2, ct4, pp4, pp5, ctc0, nprimtilt, lmax, K, stfname, logstep);
   end

end

% change the stepsize in the k2 vector
if (K > 0)
   nksteps = 0.75* sqrt(lmax * lmax0);
% take care that in case the peak in the source region is splitup by the symmetry point, we take all
% modes (even and uneven nn2(i)) in the summation for the anistropy spectrum and nn2min==3
   if  ( (ctc0 - ct4sym) > 0 &  (ctc0 - ct4sym) < (ctad + 100) )
      nn2step = 1;
   else
      nn2step = max(1, round((nn2max - nn2min)/nksteps));
      nn2step = min(2, nn2step);   % limit to nn2step==2
   end
   nn2 = nn2min : nn2step : nn2max;
   k2 = nn2 * sqrt(K);
else

   clear('k2')
   logstep = 0;
   if one_percent == 1
     nksteps = 1.5*sqrt(lmax *lmax0);
   else
     nksteps = 2*sqrt(lmax *lmax0);
   end
   k2step = (k2max - k2min)/nksteps;
   k2 = k2min : k2step : k2max;
end % define k2 range
lk2 = size(k2, 2);
ik2 = floor(lk2/2);
ik4 = floor(lk2/4);

%##anisotropy spectrum, step 2 :l > 100, note that the cftime extends to the full range, ict4max= lt2-1
if one_percent == 1
   ict4step = 2;
else
   ict4step = 1;
end
ict4 = ict4min : ict4step : ict4max;
ct4 = ct2(ict4);
lct4 = size(ict4, 2);

% take the splines for all k2 interpolations within the conformal time interval ict4
% for each time we have one spline (the splines are in a column vector)
% this steps needs a lot of memory : if short of memory use srcpint.m with pp4, pp5 as argument
pp4 = spline(k1, table_srt(:, ict4)');
pp5 = spline(k1, table_srp(:, ict4)');
if one_percent == 1
   src4 = [ppval(pp4, k2(1:ik2)), ppval(pp4, k2(ik2+1:end))];
   src5 = [ppval(pp5, k2(1:ik2)), ppval(pp5, k2(ik2+1:end))];
end

% calculate the anisotropy spectrum for l > 100
if one_percent == 1
   lstep = 50;
else
   lstep = 25;
end
%la2 = 500
if (K > 0)
   la2 = 250:lstep:lmax;
   lla2 = size(la2,2);
   if  one_percent == 1
      [cct2, ta1] = srcintf1(la2, nn2, ct4, src4, src5, ctc0, ctad, nprimtilt, lmax, K,stfname);
   else
      [cct2, ta1] = srcint1(la2, nn2, ct4, pp4, pp5, ctc0, ctad, nprimtilt, lmax, K,stfname);
   end
else
   la2 = 100:lstep:lmax;
   lla2 = size(la2,2);
   if one_percent == 1
      [cct2, ta1] = srcintf(la2, k2, ct4, src4, src5, ctc0, nprimtilt, lmax, K, stfname, logstep);
   else
      [cct2, ta1] = srcint(la2, k2, ct4, pp4, pp5, ctc0, nprimtilt, lmax, K, stfname, logstep);
   end
end

% collect the results and go to the final step
la = [la1, la2];
ctth = [cct1.ctt, cct2.ctt];
ceeh = [cct1.cee, cct2.cee];
cteh = [cct1.cte, cct2.cte];

% calculate the amplitude of the anistropy spectrum in terms of the cmb temperature cmbtemp as
% cmbtemp^2*l*(l+1)*C1/(2*pi) in units of Kelvin^2 (including the effect of primordial tilt of the
% power spectrum)
% calculate the present (a==1) grow factor D1 by integration (see Dodelson 7.77)
D1 = 2.5 * om * quadl(@cmd3, 0, 1.0, tol, trace, om, omt);
% calculate the proportionality factor of the temperature spectrum, see Sachs and Wolfe and
% Dodelson (8.74) :
cswl1 = (50/9) * cmbtemp^2* (h*h0)^(1-nprimtilt) * (om/D1)^2;

% calculate the power spectrum of matter psm in units (Mpc/h)^3 as a function of kh = k1/h in h/Mpc.
kh = k1/h;
% use deltam(k) = delta(k)/psi, see Dodelson formulas (6.100) and (7.9) and delta is the mass overdensity.
psm1 =(50 *pi^2/9) .* (h./k1) .^3 .* (k1/(h*h0)) .^ (nprimtilt-1) .* (deltam .^2) * (om/D1)^2;
deltam(1)

% find psm at k1=0.05/Mpc and normalise the spectra with the density fluctuation at horizon crossing (dha)
% the c10 normalisation for the temperature spectrum is taken at l=10 :
% the best fit value for wmap2003 is 727 microKelvin^2, which gives C10 = 5.59e-12 and sqrt(C10) = 2.36e-6.
% the density fluctuation at the horizon for the best fit (dha) is in the global file of constants (cmbglobl.m)
% we use it to normalise both temperature and matter spectra. 
kfid = 0.05
% normalise the temperature and matter spectra:
psm = psm1 * dha2;
cswl = cswl1 * dha2;

% calculate sigma8, the extended rms mass overdensity, sampled with a sphere of radius of radius 8 Mpc/h
% extend the matter power spectrum from k1 into small scales with k3 > 0.2 Mpc^-1, 
k3step = 0.01;
k3max = 1.0;
k3 = (k1max+k3step) : k3step : k3max;
%for the extension use the asymptotic expansion of delta, see Dodelson formula (7.9) with the transfer function of (7.69)
% as psm is in units (Mpc/h)^3, we have to include the Hubble factor^3 in the Bolzman part of psm
psm2 = psm/h^3;
psm3 = psm2(end) * (k1(end) ./ k3) .^(4-nprimtilt) .* (log(k3/(8*keq))/log(k1(end)/(8*keq))) .^2;
k4 = [k1, k3];
psm4 = [psm2, psm3];
sig8h = (0.5/pi^2) * quadl(@sigma_8, k4(1), k4(end), tol, trace, k4, psm4, h);
sig8 = sqrt(sig8h);
% plot both psm from Bolzman calculation and the extension from formula (7.69)
figure(1)
loglog(k4, psm4)
%semilogy(k4, psm4)
title(['full range mass power spectrum: omt=', num2str(omt), ' h=', num2str(h), ',om=', num2str(om), ...
   ',omb=', num2str(omb), ',ns=', num2str(nprimtilt), ',tauri=', num2str(tauri)])
ylabel('P(k) in (Mpc/h)^3')
xlabel('log of the wavenumber in h/Mpc')

% compare with wmap results and find the normalisation constant c10
fn = 'cmbansp';
pm.k = kh;
pm.psm = psm;
as.la = la;  
as.ctt = ctth * cswl;
as.cee = ceeh * cswl;
as.cte = cteh * cswl;
% c1==1 gives a model with a perfect fit

[c1, lmin1, lmax1] = cmbdata1(as, pm, h, omt, om, omb, nprimtilt, tauri, bmark);
% sigma* has to be corrected with sqrt of the amplitude correction ,sqrt(c1) :standard case sig8 =0.915
sig8 = sig8 * sqrt(c1);

% save the anisotropy spectra (as/pm) and matter spectrum (pm) and make plots
%save cmbansp as pm
% bring the cosmological parameters and other data that have been used in the routine to the output:
fid = 1;
fprintf(fid, '\n');
fprintf(fid, 'the redshift at decoupling (maximum of the visibility function) = %g\n', dt.zdec);
fprintf(fid, 'the thickness of the decoupling surface (half width of vsb in redshift) = %g\n', dt.tds);
fprintf(fid, 'the age of the universe at decoupling = %g kyear\n', dt.tdec);
fprintf(fid, 'the age of the universe at reionisation = %g kyear\n', dt.tri);
fprintf(fid, 'the current age of the universe = %g Gyear\n', dt.trc);
fprintf(fid, '\n');
fprintf(fid, 'the conformal distance at decoupling = %g Mpc\n', dt.etadec);
fprintf(fid, 'the thickness of the decoupling surface (half width of vsb in redshift) = %g Mpc\n', trs);
fprintf(fid, 'the number of time integration points over the thickness of the decoupling surface = %g\n', 2*nphw);
fprintf(fid, '\n');
fprintf(fid, 'the cosmological parameter values used in the routine are :\n');
fprintf(fid, 'the density fluctuation at the horizon = %g\n', dha);
fprintf(fid, 'the amplitude correction (at l=10) = %g\n', c1);
fprintf(fid, 'total omega (omt) = %g\n', omt);
fprintf(fid, 'dark matter omega = %g\n', om);
fprintf(fid, 'baryon omega = %g\n', omb);
fprintf(fid, 'Hubble factor = %g\n', h);
fprintf(fid, 'spectral density index = %g\n', nprimtilt);
fprintf(fid, 'optical depth at reionisation = %g\n', tauri);
fprintf(fid, 'sigma8, rms mass overdensity sampled with a sphere of 8 Mpc/h = %g\n', sig8);
fprintf(fid, ['in the figures we compare the results with ', bmark, '\n'])
fprintf(fid, 'the minima in the temperature spectrum are at: ')
fprintf(fid, '%g,  ', lmin1)
fprintf(fid, '\n')
fprintf(fid, 'the maxima in the temperature spectrum are at: ')
fprintf(fid, '%g,  ', lmax1)
fprintf(fid, '\n')

