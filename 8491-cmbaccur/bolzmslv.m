function [table_srt, table_srp, deltam, a2] =bolzmslv(ct2, k1, tol_ode23, om, omb, omt, h, ctc0, ctad, zri, ctri, K, one_percent)
% bolzmslv.m solves the Bolzmanequations for different k-values given in k1 and calculates the sources
% for integration over the past light cone of resp temperature and polarisation.
%
% input : a conformal timeseries of points (ct2), with sufficient small stepsize for later integration : 
% we must have at least 40 points over the thickness of the recombination surface, the k-values for
% solving the Bolzman equations (k1), the tolerance for the ode23 routine, further cosmological constants,
% see cmbaccur.m, the present conformal time (ctc0), conformal time at decoupling (ctad), 
% redshift at reionisation (zri), conformal time at reionisation (ctri), the option for accuracy: 1% or 0.1% (one_percent)
%
% output: a table of source values for the temperature fluctuations (table_srt), where the rows match
% k1 and the columns match ct2, a table of source values for the polarisation (table_srp), where the rows match
% k1 and the columns match ct2, an array of the matter density fluctuations at present, matching k1 (deltam),
% the evolution of the scale factor which results from our universe model (a2), see the first equation 
% in bolzmeq2.m
%
% side effect : the routine makes 4 plots in figure(1)

% define the table of recombination values(xe)
global  GL_cmb_h0   GL_cmb_fv  GL_cmb_kg1  GL_cmb_ka1  GL_dt_table;

% the hubble constant at present in h Mpc^-1, see my notes p71
h0 = GL_cmb_h0;
% the ratio of neutrino to total radiation density fv, assuming three massless neutrinos
fv = GL_cmb_fv;
% the ratio of the radiation density and the critical density, see Dodelson (omega_gamma) 
kg1 = GL_cmb_kg1;
ka1 = GL_cmb_ka1;

% omega of radiation and neutrinos separately
omp = kg1/h^2;
omr = omp/(1 - fv);
omn = omp * fv/(1 - fv);

warning off MATLAB:nearlySingularMatrix
lk1 = size(k1, 2);
ct2step = ct2(2) - ct2(1);

% solve the Bolzman equations for different values of k1
for i = 1:lk1

kw = k1(i)

% kw should be equal to or larger than 3*sqrt(K) which is the lowest azimutal mode of K>0 and l==2
if K > 0  &  kw < 3*sqrt(K), 
   message('kw below lowest boundary');
   return;
end

% range of the conformal time ct in Mpc, take two ranges for the solution of the dv 's :
% ct1min -> ct1int and ct1int -> ct1max.
ct1min = ct2(1);
ct1max = ctc0;
%ct1int = 400;
ct1int = ctad + 200;
ctr1 = [ct1min, ct1int];
ctr2 = [ct1int, ct1max];
ctr = [ct1min ct1max];

% some initial value of the variables to solve from the Bolzman equations, see Ma and Bertschinger formula (98) : 
% the order of the variables is : scale factor (a), Newton potential (phi), variance in the darkmatter density (delta),
% and velocity (v), variance in the baryon density (db), and velocity (vb), 
% neutrino multipoles (n0-n7), radiation multipoles (teta0- teta8) : teta0 = x(15) (total of 23)
kww = sqrt(kw^2 - K);
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
CC = -(15 + 4*fv)/20 *bst^2;
y0(2 : end) = CC * y0(2 : end);

% solve the equations in two steps: in connection to the accuracy needed for the source the first step must
% be smaller up to recombination ctime + 4*width of vsb2
tolbe = tol_ode23;
if kw < 1e-3, tolbe = 1e-7, end;
maxstep1 = 1;
maxstep2 = 8;
if one_percent == 1
  options = odeset('RelTol', tolbe, 'AbsTol', tolbe, 'Vectorized','on', 'Stats', 'on');
  [ct1, y1] = ode23s(@bolzmeq2, ctr', y0', options, kw, om, omb, omt, h);
else
  options = odeset('RelTol', tolbe, 'AbsTol', tolbe, 'Vectorized','on', 'MaxStep', maxstep1, 'Stats', 'on');
  [ct11, y11] = ode23s(@bolzmeq2, ctr1', y0', options, kw, om, omb, omt, h);
  options = odeset('RelTol', tolbe, 'AbsTol', tolbe, 'Vectorized','on', 'MaxStep', maxstep2, 'Stats', 'on');
  [ct12, y12] = ode23s(@bolzmeq2, ctr2', y11(end,:)', options, kw, om, omb, omt, h);
  ct1 = [ct11; ct12(2:end)];
  y1 = [y11; y12(2:end,:)];
end

a1 = y1(:, 1);
ht1 = y1(:, 2);
eta1 = y1(:, 3);
deltam1 = y1(:, 4);
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

% find teta+psi and teta1 at recombination as f of k (take the zrec of anspect1.m =1134)
arec = 1/1089;

% save the present matter density fluctuations (return value)
deltam(i) = deltam1(end);

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

% the derivatives : take account for a shift of step/2, resp step for the 1th and 2th derivatives
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

end  % k1 forloop

% plot some results of ode23
figure(1)
clf
subplot(2,2,1)
semilogx(ct2, eta2);
title(['the equivalent for psi-phi : eta+dalpha ', num2str(kw), ' Mpc^-1'])
xlabel('conformal time in Mpc')
%xlabel('scale factor a')
%axis([1e-5 0.01 0 1.3])

subplot(2,2,2)
semilogx(ct2, eta2 + dalpha,'r', ct2, vb2 + alpha*kw, 'b', ct2, 10*vsb2, 'k', ct2, 10*ppi2, 'k--');
%semilogx(ct1, teta2, 'r', ct1, teta4, 'b', ct1, vsb1, 'k--');
xlabel('conformal time ct1')
%axis([10 2e3 -1.5 1.5])
%axis([1e-2 1e3 -2 2])
%axis([ctri-100 ctri+100 -1 1])

subplot(2,2,3)
semilogx(ct2, dddht/(2 * kww^2), 'k--', ct2, 6*dddeta/(2 * kww^2), 'r--', ct2, ddalpha, 'r');
%semilogx(ct2, deta, 'k', ct2, ddalpha, 'r', ct2, eta2, 'k--', ct2, dalpha, 'r--');
xlabel('conformal time ct1')

subplot(2,2,4)
% zoom in at recombination
plot(ct2, src)
axis([0 600 -0.05 0.05])

if zri > 0
% zoom in at reionisation
   semilogx(ct2, st1, 'k', ct2, st2/sqrt(kw), 'm--', ct2, dvsb .* (vb2/kw + alpha), 'b', ...
      ct2, ddvsb .* ppi2/kw^2, 'k--', [ctri - 100, ctri], [0, 0], 'x');
   title('source, st1, st2')
   axis([200 400 -0.1 0.1])
end

return
