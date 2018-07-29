% cmbacc3.m : no inputs
% this program calculates the radiation and matter spectra to an accuracy of 1% or 0.1% for the open, flat and
% closed Friedman-Robertson-Walker universe.
% The radiation spectra include the temperature- polarisation and cross-polarisation spectra.
% We follow the method of Uros Seljak amd Matias Zaldarriaga in 'A line-of-sight integration approach
% to Cosmic microwave background anisotropies', ApJ, nr 469, 437-444 (1996), see also :
% Ma and Bertschinger, ApJ nr 455, 7-25 (1995) and Zaldarriaga, Seljak, Bertschinger ApJ nr 494, 491 (1998) 
% and Zaldarriaga and Seljak, ApJ nr129, 431 (2000) and W Hu e.a, 'A complete treatment
% of CMB anisotropies in a FRW universe', Phys Rev D57, 3290-3301 (1998), for reionisation see N Sugiyama, 
% ApJ nr 419 L1-L4 (1993) and ApjS nr 100, 281 (1995)
%
% D Vangheluwe 29 jun 2005
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
% remark 5 (4 aug 2005): if the spectrum needs only to be calculated for a multipole range smaller than the 
%  default lmax0=1500, specify this range by giving lmax in the text a value <1500, the accuracy is
%  kept in line with this choice (several changes are necessary such as : smaller nkst, extended k1max etc.)
%  The calculation time is now proportional to sqrt(lmax), not with lmax!

clear all

global GL_dt_table   GL_pp_dtau;
global  GL_cmb_c  GL_cmb_h0   GL_cmb_t0   GL_cmb_T0   GL_cmb_rv   GL_cmb_fv   GL_cmb_kg1   GL_cmb_ka1   ...
  GL_cmb_yp   GL_cmb_ncr   GL_cmb_cr   GL_cmb_pcm   GL_cmb_dha;
% give the global physical constants a value
cmbglobl;

% option develop == 0 for development : does stop after solving the Bolzman equations
develop = 0

% option one_percent results in an accuracy of 1% for the anisotropy spectrum, the default accuracy is 0.1%.
one_percent = 1
% option reload takes the solution of the dv's from datafile
reload = 0;

% tolerance
tol = 1e-6;
trace = [];

% h72i : h = 0.72, om = 0.27, omb = 0.046, nprimtilt = 0.99, tauri = 0, reionisation  :zri = 17.28
% benchmark calculations to compare : available are cmbfast for h=0.72: 'h72', 'h72i' for reionisation with zri = 17.3
%  'h82' for h = 0.82, and 'h82i' for reionisation with zri = 17.3, 'cdm', for the CDM-model (critical density model) 
% (see for more info cmbdata1.m)
%bmark = 'h72c1';
bmark = 'h72i';

% define the input 'vanilla parameters' instead of h,om,omb etc.
van = [1, 0.73, 0.1161216, 0.0238464, 0.99, 0.17295];  %standard with omt=1, h=0.72 etc.
%van = [1, 0.684, 0.1254, 0.0232, 0.977, 0.23];
%van = [1, 0.725, 0.09, 0.0263, 1.10, 0.41]
%van = [1, 0.695, 0.115, 0.0230, 0.979, 0.143]
%van = [1, 0.707, 0.1233, 0.0238, 1, 0.165]
%van =[1, 0.691,0.1231,0.0228,0.966,0.103]
%van = [1, 0.699, 0.1222, 0.0232, 0.977, 0.124]
%van = [1, 0.53, 0.108, 0.0241, 1.01, 0.22]

% curvature density of space, open universe 1-omt > 0, closed universe : 1-omt < 0 , oml = omt - omr - om
%omt = 1
%omt = 1.199
omt = 1.0

% the hubble factor h
%h = 0.71
h = sqrt((van(3) + van(4))/(omt - van(2)))
%h = 0.72

% baryon content of the universe
%omb = 0.0444
omb = van(4)/h^2
%omb = 0.046

% matter content of the universe
%om = 0.27
om = (van(3) + van(4))/h^2
%om = 0.27

% redshift for reionisation
%zri = 0
%zri = 17.28   % tauri = 0.170
zri = 92*(0.03 * h * van(6)/van(4))^(2/3) * om^(1/3)
%zri = 0

% primordial tilt : the exponent of the power spectrum of matter
%nprimtilt = 0.99;
nprimtilt = van(5)
%nprimtilt = 0.99;

% normalisation of the anisotropy spectrum
c10 = van(1);
%c10 = 1.00;

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

% define the default startfile name (the file which contains the startvalues for the ultra spherical f)
if K > 0 
   stfname = 'stfile1';
else
   stfname = 'stfile';
end
% find the maximum multipole number in the startfile for K>0 (lmax0 =default 1500)
stv1 = load(stfname);
lmax0 = stv1.ust.la(end);

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
tauri = dt.tauri;
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
    if  (2*ct4sym < ctc0),  message('the spectrum is isotropic, break'); return; end
    if sqrt(K) * ctc0 > 2, message('curvature K * ctc0 > 2'); end
end

% define the range of l (angle number)
lmax = 1500;
%lmax = 900
lmin = 2;

% the wavenumber kw in Mpc^1 (range : 0.2 < kw < 2e-4)
% define the k-range
if one_percent == 1
%  nkst = 44
  nkst = 30 + 10*(lmax - 900)/600;   % adapt the k1step for lmax~1500
else
  nkst = 88
end

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
% find the maximum multipole number in the startfile for K<=0 (lmax0 =default 1500)
    k1max = 2*sqrt(lmax*lmax0)/ctc0;
    k1step = 0.0012;
    k1step2 = (k1max - k1int)/nkst;
    k1 = [k1min, 4e-5, 8e-5, 2e-4, 4e-4, 6e-4, 8e-4 : k1step : k1int, k1int+k1step2 : k1step2 : k1max];
end  %define k1 range
lk1 = size(k1, 2)

if reload == 1, lk1 = 1, end

%warning off MATLAB:nearlySingularMatrix
for i = 1:lk1
kw = k1(i)

%###########
%for i = 1:1
%kw = 0.2263

% kw should be equal to or larger than 3*sqrt(K) which is the lowest azimutal mode of K>0 and l==2
if K > 0  &  kw < 3*sqrt(K), 
   message('kw below lowest boundary');
   break;
end

%kw = k1(169);   % hier gaat ode23s de mist in  25 dec 2004 : daarvoor een term 1e-10 erbij

% range of the conformal time ct in Mpc, take two ranges for the solution of the dv 's :
% ct1min -> ct1int and ct1int -> ct1max.
ct1min = 0.5;
ct1max = ctc0;
%ct1int = 400;
ct1int = ctad + 200;
ctr1 = [ct1min, ct1int];
ctr2 = [ct1int, ct1max];
ctr = [ct1min ct1max];

% some initial value of the variables to solve from the Bolzman equations, see Ma and Bertschinger formula (98) :  
% the order of the variables is : scale factor (a), the trace part of the metric perturbation (ht), 
% the traceless part of the metric perturbation (eta), disturbance in the darkmatter density (delta),
% the disturbance in the baryon density (db), and velocity (vb), neutrino multipoles (n0-n7), 
% radiation multipoles (teta0- teta8) : teta0 = x(15) and polarisation radiation multipoles (tetap0-tetap8)
kww = sqrt(kw^2 - K);
% bst = b_streep = b2/b1, from Zaldarriaga et al. formulas (40) and (44)
a0 = h0 *sqrt(ka1)* ctr1(1);
b1 = sqrt(1 - K/kw^2);
b2 = sqrt(1 - 4*K/kw^2);
bst = b2/b1;
ke0 = kw * ctr1(1);
ke1 = kww * ctr1(1);
be0 = (20* bst^2 + 10*K/kww^2)/(20 *bst^2 + bst^3 *fv);
nf0 = 1 + 0.8 * (b2/b1)^2
y0 = [a0, 10, 2/(1-4*K/kw^2), -0.5*ke0^2, -0.5*ke0^2, -ke1*ke0^2/18, -ke0^2/6, -nf0*ke1*ke0^2/54, bst*be0*ke0^2/15, 0, ...
      0,   0,         0,            0,       -ke0^2/6,   -ke1*ke0^2/54,     0,            0,               0,      0, ...
      0,   0,         0,            0,           0,           0,            0,            0,               0,      0, ...
      0,   0];
% in order to bring he solution of the synchronous gauge in agreement with the solution of the Newton gauge,
% we normalize the Einstein and the Bolzman equations (equations 2:end) for the synchronous gauge with a constant CC, 
% such that dalpha == psi,  (psi(0) == -1 in our program for the Newton solution (see directory cmb), 
% see also Zaldarriaga et al. formulas (96) and (98) (attention!!: the first equation needs no normalisation)
CC = -(15 + 4*fv)/20 *bst^2;
y0(2 : end) = CC * y0(2 : end);
% solve the equations in two steps: in connection to the accuracy needed for the source the first step must
% be smaller up to recombination ctime + 4*width of vsb2
tolbe = tol_ode23;
% an efficient way to make the ctime step of the odesolver a bit smaller for large scales:
if kw < 1e-3, tolbe = 1e-7, end;
%maxstep1 = 2;
%maxstep2 = 16;
maxstep1 = 1;
maxstep2 = 8;
%options = odeset('RelTol', tolbe, 'AbsTol', tolbe, 'Vectorized','on','JPattern', Stifm, 'Stats', 'on');
%options = odeset('RelTol', 1e-4, 'AbsTol', 1e-4, 'Vectorized','on','JPattern', Stifm);
if one_percent == 1
  options = odeset('RelTol', tolbe, 'AbsTol', tolbe, 'Vectorized','on', 'Stats', 'on');
  [ct1, y1] = ode23s(@bolzmeq2, ctr', y0', options, kw, om, omb, omt, h);
else
  options = odeset('RelTol', tolbe, 'AbsTol', tolbe, 'Vectorized','on', 'MaxStep', maxstep1, 'Stats', 'on');
  [ct11, y11] = ode23s(@bolzmeq2, ctr1', y0', options, kw, om, omb, omt, h);
  options = odeset('RelTol', tolbe, 'AbsTol', tolbe, 'Vectorized','on', 'MaxStep', maxstep2, 'Stats', 'on');
%  options = odeset('RelTol', tolbe, 'AbsTol', tolbe, 'Vectorized','on', 'Stats', 'on');
  [ct12, y12] = ode23s(@bolzmeq2, ctr2', y11(end,:)', options, kw, om, omb, omt, h);
  ct1 = [ct11; ct12(2:end)];
  y1 = [y11; y12(2:end,:)];
end

a1 = y1(:, 1);
ht1 = y1(:, 2);
eta1 = y1(:, 3);
deltam = y1(:, 4);
deltab = y1(:, 5);
vb = y1(:, 6);
n0 = y1(:, 7);
n1 = y1(:, 8);
n2 = y1(:, 9);
teta0 = y1(:, 15);
teta1 = y1(:, 16);
teta2 = y1(:, 17);
teta4 = y1(:, 19);
teta6 = y1(:, 21);
ppi1 = y1(:,17) - 12* y1(:,26);

% save the current deltam:
deltamc(i) = deltam(end);
%teta2m(i) = teta2(end);

% take smaller steps in the same range of the conformal time now ct2:
step0 = ctc0/7000;
if one_percent == 1
  ct2step = step0;
else
  ct2step = step0/2;
end
ct2min = ct1min;
ct2max = ct1max;
ct2 = ct2min : ct2step : ct2max;
lct2 = size(ct2, 2);

% find the visibility function and tau on the range ct2 by interpolation
a2 = spline(ct1, a1, ct2);
dtau2 = spline(GL_dt_table(1,:), GL_dt_table(3,:), a2);
vsb2 = spline(GL_dt_table(1,:), GL_dt_table(5,:), a2);
tau2 = spline(GL_dt_table(1,:), GL_dt_table(4,:), a2);
ht2 = spline(ct1, ht1, ct2);
eta2 = spline(ct1, eta1, ct2);
teta02 = spline(ct1, teta0, ct2);
teta12 = spline(ct1, teta1, ct2);
teta22 = spline(ct1, teta2, ct2);
n22 = spline(ct1, n2, ct2);
vb2 = spline(ct1, vb, ct2);
ppi2 = spline(ct1, ppi1, ct2) * b1/b2;

% the derivatives : take account for a shift of step/2, resp step for the 1th and 2th derivative
da2 = [diff(a2)/ct2step];
da = interpl([ct2(1) - ct2step, ct2], [da2(1), da2, da2(end)]', (ct2 - ct2step/2)')';
dvb2 = [diff(vb2)/ct2step];
dvb = interpl([ct2(1) - ct2step, ct2], [dvb2(1), dvb2, dvb2(end)]', (ct2 - ct2step/2)')';
dht2 = [diff(ht2)/ct2step];
ddht2 = [diff(dht2)/ct2step];
dddht2 = [diff(ddht2)/ct2step];
dht = interpl([ct2(1) - ct2step, ct2], [dht2(1), dht2, dht2(end)]', (ct2 - ct2step/2)')';
ddht = interpl([ct2(1) - ct2step, ct2], [ddht2(1), ddht2, ddht2(end) *ones(1,2)]', (ct2 - ct2step)')';
dddht = interpl([ct2(1) - ct2step, ct2], [dddht2(1), dddht2, dddht2(end)* ones(1,3)]', (ct2 - ct2step)')';
deta2 = [diff(eta2)/ct2step];
ddeta2 = [diff(deta2)/ct2step];
dddeta2 = [diff(ddeta2)/ct2step];
deta = interpl([ct2(1) - ct2step, ct2], [deta2(1), deta2, deta2(end)]', (ct2 - ct2step/2)')';
ddeta = interpl([ct2(1) - ct2step, ct2], [ddeta2(1), ddeta2, ddeta2(end)* ones(1,2)]', (ct2 - ct2step)')';
dddeta = interpl([ct2(1) - ct2step, ct2], [dddeta2(1), dddeta2, dddeta2(end)* ones(1,3)]', (ct2 - ct2step)')';
alpha = (dht + 6 *deta)/(2 * kww^2);
dalpha = (ddht + 6 *ddeta)/(2 * kww^2);
ddalpha = (dddht + 6 *dddeta)/(2 * kww^2);

dppi2 = [diff(ppi2)/ct2step];
dppi = interpl([ct2(1) - ct2step, ct2], [dppi2(1), dppi2, dppi2(end)]', (ct2 - ct2step/2)')';
ddppi2 = [diff(dppi2)/ct2step];
ddppi = interpl([ct2(1) - ct2step, ct2], [ddppi2(1), ddppi2, ddppi2(end)* ones(1,2)]', (ct2 - ct2step)')';
dvsb2 = [diff(vsb2)/ct2step];
dvsb = interpl([ct2(1) - ct2step, ct2], [dvsb2(1), dvsb2, dvsb2(end)]', (ct2 - ct2step/2)')';
ddvsb2 = [diff(dvsb2)/ct2step];
ddvsb = interpl([ct2(1) - ct2step, ct2], [ddvsb2(1), ddvsb2, ddvsb2(end)* ones(1,2)]', (ct2 - ct2step)')';

% calculate the source as a function of ctime and k
st11 = vsb2 .* (teta02 + 2* dalpha + dvb/kww) + dvsb .* (vb2/kww + alpha);
st1 = vsb2 .* (teta02 + 2* dalpha + dvb/kww + 0.25* ppi2 + 0.75* ddppi/kww^2) ...
   + dvsb .* (vb2/kww + alpha + 1.5* dppi/kww^2) + 0.75 * ddvsb .* ppi2/kww^2;
% the Sachs-Wolfe effect , see Dodelson (8.55) and p247
st2 = exp(-tau2) .* (deta + ddalpha);

% the polarisation source
if  K == 0
   rpb = ctc0 - ct2;
elseif K < 0
   rpb = sinh(sqrt(-K) * (ctc0 - ct2))/sqrt(-K);
else
   rpb = sin(sqrt(K) * (ctc0 - ct2))/sqrt(K);
end
stp = 0.75 * vsb2 .* ppi2 ./ (kww * rpb) .^2;

% check the visibility function
%gv1 = simpsint(ct2(1), ct2(end), vsb2');

src = st1 + st2;
% save the result for the integration over conformal time and k
table_srt(i,:) = src;
table_srp(i,:) = stp;

%save teta0+psi == teta0+dalpha at recombination
arec = 1/1089;
ttdec(i) = spline(a2, teta02+dalpha, arec);

end  % k1 forloop


%################### 
%save cmbtpsi k1 tpsi0  tpsi1
% save to cmbsrci1 a more extended and accurate solution
% save cmbsrci1 k1 ct2  table_srt  table_srp  ttdec deltamc  
% this is the save for calculations with one_percent == 1
% save cmbsrci k1 ct2  table_srt  table_srp  ttdec deltamc  
if reload == 1
  if one_percent == 1
    s1= load('cmbsrci');
  else
    s1= load('cmbsrci1');
  end
  k1 = s1.k1;
  table_srt = s1.table_srt;
  table_srp = s1.table_srp;
  ttdec = s1.ttdec;
  deltamc = s1.deltamc;
end
clear('s1');

figure(1)
clf
semilogx(ct2, eta2);
title(['the equivalent for psi-phi : eta+dalpha ', num2str(kw), ' Mpc^-1'])
xlabel('conformal time in Mpc')
%xlabel('scale factor a')
%axis([1e-5 0.01 0 1.3])
 
figure(2)
clf
semilogx(ct2, eta2 + dalpha,'r', ct2, vb2 + alpha*kw, 'b', ct2, vsb2, 'k', ct2, 10*ppi2, 'k--');
%semilogx(ct1, teta2, 'r', ct1, teta4, 'b', ct1, vsb1, 'k--');
xlabel('conformal time ct1')
%axis([10 2e3 -1.5 1.5])
%axis([1e-2 1e3 -2 2])
%axis([ctri-100 ctri+100 -1 1])

figure(3)
clf
semilogx(ct2, dddht/(2 * kww^2), 'k--', ct2, 6*dddeta/(2 * kww^2), 'r--', ct2, ddalpha, 'r');
%semilogx(ct2, deta, 'k', ct2, ddalpha, 'r', ct2, eta2, 'k--', ct2, dalpha, 'r--');
xlabel('conformal time ct1')

figure(4)
% zoom in at recombination
%semilogx(ct2, 50*vsb2, ct2, teta02 + dalpha);
%axis([100 1e3 -1.5 1.5])
%semilogx(ct2, st1,'k', ct2, st11, 'r--', ct2, vsb2 .*ddppi/kw^2, 'b');
%axis([2e2 1e3 -max(st1) max(st1)])
%semilogx(ct2, st1,'k', ct2, st2*100, 'r--', ct2, 0.25* vsb2 .*ppi2, 'b', ...
%    ct2, vsb2, 'k--', [200, 400], [0, 0], 'x');
plot(ct2, src)
axis([0 600 -0.05 0.05])

%axis([200, ct2(end) -1.5*max(abs(st1)), 1.5*max(abs(st1))])
%plot(ct2, teta22, ct2, ddpi)
%axis([4.1e2 4.2e2 -0.002 0.002])

figure(5)
% zoom in at reionisation
semilogx(ct2, st1, 'k', ct2, st2/sqrt(kw), 'm--', ct2, dvsb .* (vb2/kw + alpha), 'b', ...
    ct2, ddvsb .* ppi2/kw^2, 'k--', [ctri - 100, ctri], [0, 0], 'x');
%axis([ctri-100, ctri+100, -0.01, 0.01])
%semilogx(ct2, vsb2, ct2, 50*dvsb/kw, 'k', ct2, 1e6*[diff(dvsb),0], 'r', ct2, 0.1*ddvsb/kw^2,'b')
%axis([ctri-50, ctri+50, -1, 1])
axis([200 400 -1 1])

% find the conformal time at recombination :
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
% find an accurate value for the recombination time h
ct3 = hw1:0.01:hw2;
vsb3 = spline(ct2, vsb2, ct3);
[vsbm irm] = max(vsb3);
etar = ct3(irm);

fid = 1;
fprintf(fid, 'the maximum of the visibility function and the redshift for decoupling = %g\n', etar);
fprintf(fid, 'the thickness of the decoupling surface (half width of vsb in redshift) = %g\n', trs);
fprintf(fid, 'the number of ct2 points over the thickness of the decoupling surface = %g\n', 2*nphw);

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
%    ek2step = 0.004;
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
% this steps needs a lot of memory : if short of memory use srcpint.m with pp4, pp5 as argument
pp4 = spline(k1, table_srt(:, ict4)');
pp5 = spline(k1, table_srp(:, ict4)');
if one_percent == 1
   src4 = [ppval(pp4, k2(1:ik2)), ppval(pp4, k2(ik2+1:end))];
   src5 = [ppval(pp5, k2(1:ik2)), ppval(pp5, k2(ik2+1:end))];
end

if develop == 0

% calculate the anisotropy spectrum for l <= 100
if (one_percent == 1)  &  (K > 0 )
   lstep = 20;
else
   lstep = 10;
end
%la1 = 50;
if (K > 0)
   la1 = [2,6,10, 20:lstep:220];
   lla1 = size(la1,2);
   if one_percent == 1
      [cct1, ta1, te1] = srcintf1(la1, nn2, ct4, src4, src5, ctc0, ctad, nprimtilt, lmax, K, stfname);
   else
      [cct1, ta1, ta2] = srcint1(la1, nn2, ct4, pp4, pp5, ctc0, ctad, nprimtilt, lmax, K, stfname);
   end

else
%   la1 = [2,6,10:lstep:70];
   la1 = [2,6,10,20:lstep:90];
   lla1 = size(la1,2);
   if one_percent == 1
      [cct1, ta1, te1] = srcintf(la1, k2, ct4, src4, src5, ctc0, nprimtilt, lmax, K, stfname, logstep);
%      [cct1, ta1, te1] = srcint(la1, k2, ct4, pp4, pp5, ctc0, nprimtilt, lmax, K, stfname, logstep);
   else
      [cct1, ta1, ta2] = srcint(la1, k2, ct4, pp4, pp5, ctc0, nprimtilt, lmax, K, stfname, logstep);
   end
end

% change the stepsize in the k2 vector
if (K > 0)
   nksteps = 0.75* sqrt(lmax * lmax0);
% take care that in case the peak in the source region is splitup by the symmetry point, we take all
% modes (even and uneven nn2(i)) in the summation for the anistropy spectrum and nn2min==3
   if  ( (ctc0 - ct4sym) > 0  &  (ctc0 - ct4sym) < (ctad + 100) )
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
% we need to integrate the full timepath for 1% accuracy
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

% calculate the anisotropy spectrum for l >= 100
if one_percent == 1
   lstep = 50;
else
   lstep = 25;
end
%la2 = 1300
if (K > 0)
   la2 = 250:lstep:lmax;
   lla2 = size(la2,2);
   if  one_percent == 1
      [cct2, ta1] = srcintf1(la2, nn2, ct4, src4, src5, ctc0, ctad, nprimtilt, lmax, K, stfname);
   else
      [cct2, ta1] = srcint1(la2, nn2, ct4, pp4, pp5, ctc0, ctad, nprimtilt, lmax, K, stfname);
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
D1 = 2.5 * om * quadl(@cmd3, 0.0, 1.0, tol, trace, om, omt);
% calculate the proportionality factor of the temperature spectrum, see Sachs and Wolfe and
% Dodelson (8.74) :
cswl1 = (50/9) * cmbtemp^2* (h*h0)^(1-nprimtilt) * (om/D1)^2;

% calculate the power spectrum of matter psm in units (Mpc/h)^3 as a function of kh = k1/h in h/Mpc.
kh = k1/h;
% use deltamc(k) = delta(k)/psi, see Dodelson formulas (6.100) and (7.9) and delta is the mass overdensity.
psm1 = (50 *pi^2/9) .* (h./k1) .^3 .* (k1/(h*h0)) .^ (nprimtilt-1) .* (deltamc .^2) * (om/D1)^2;

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
[c1 lmin1 lmax1] = cmbdata1(as, pm, h, omt, om, omb, nprimtilt, tauri, bmark)
% sigma* has to be corrected with sqrt of the amplitude correction ,sqrt(c1) :standard case sig8 =0.915
sig8 = sig8 * sqrt(c1)

% save the anisotropy spectra (as/pm) and matter spectrum (pm) and make plots
%save cmbansp as pm


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
end  % develop if
