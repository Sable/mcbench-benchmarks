% recomb1.m : this program investigates an accurate calculation of the recombination of electrons
% and protons to be used in my version of cmbfast, see P Peebles ApJ nr 153, 1 (1968) and
% S Seager,..ApJ nr 128, 407 (2000)
% input : om, the matter content of the universe, omb, the relative number density of baryons
% omt, the curvature density of space, h, the relative Hubble constant (divided by 100 km/s/Mpc), 
% (radiation density (ka1), helium fraction etc.. are internal in the program)
% output : dt_table = [ata; xe1; dtau1; tau1; vsb1], contains in order 1. scale factor, 
% 2.electron fraction, 3.optical depth, 4.tau, 5.visibility function.. 
%
% D Vangheluwe 17 nov 2004
% remark 1 : eta is the conformal time or lenght variable in units Mpc
% remark 2 : recomb1 is a development program : the final version is in recomb.m which is
% called by cmbaccur.m which calculates the temperature anistropy spectrum, look at the
% pictures, they are nice!
% remark 3 (14 jan 2005) : reionisation (zri) has been added : notice that this increases tau at
%  recombination time (if you want to see tau==1 at recombination then input zri=0)
% remark 4: at reionisation, xe=1
% remark 5: modified for curvature of space with extra input for curvature : omt (dd 31 mrt 2005) :
%  dependent subroutines are : dtauint.m, confdist.m, ageuniv.m, freceq.m

clear all

tol = 1e-8;
trace = [];
l10 = log(10);

global  GL_cmb_c  GL_cmb_h0   GL_cmb_t0   GL_cmb_T0   GL_cmb_rv   GL_cmb_fv   GL_cmb_kg1   GL_cmb_ka1   ...
  GL_cmb_yp   GL_cmb_ncr   GL_cmb_cr   GL_cmb_pcm   GL_cmb_dha;
% give the global physical constants a value
cmbglobl;

% velocity of light in m/s
c = GL_cmb_c;
% the hubble constant at present in h Mpc^-1, see my notes p71
h0 = GL_cmb_h0;
% the present temperature of the CMB now in degr K (t0) and in eV (T0)
t0 = GL_cmb_t0;
T0 = GL_cmb_T0;
% radiation density/critical density, see Dodelson (2.87)
rv = GL_cmb_rv;
fv = GL_cmb_fv;
kg1 = GL_cmb_kg1;
ka1 = GL_cmb_ka1;
% the primordial helium mass fraction
yp = GL_cmb_yp;
% critical density in m^-3
ncr = GL_cmb_ncr;
% compton cross section in m^2, see Dodelson p 72
cr = GL_cmb_cr;
% conversion of Parsec to meters
pcm = GL_cmb_pcm;


% relative number density of baryons omb
omb = 0.0444   % value of wmap+others fit, see Spergel 2003 table 10
%omb = 0.046
% matter content of the universe
om = 0.269   % value of wmap+others fit, see Spergel 2003 table 10
%om = 0.27
% relative curvature of space
omt = 1.0
% relative Hubble constant (divided by 100 km/s/Mpc)
h = 0.71   % value of wmap+others fit, see Spergel 2003 table 10
%h = 0.72
% redshift for reionisation : where xe=1 again : calculate the redshift for reionisation
zri = 0
%tauri = 0.17
%zri = 100*tauri^(1/3)*om^(1/3)*(0.025/(omb * h))^(2/3)
%zri = 18
%zri = 17.28   % tauri = 0.170
%zri = 50

% constants introduced in Hu and Sugiyama, ApJ nr444 p489 (1995) formula C-1:
c1 = 0.43;
c2 = 16 + 1.8 * log(omb);

% range of the scale factor and the redshift
ea= -3.3:0.01:0;
%ea= -3.3:0.2:-1;
ar = 10 .^ea;
%ar = 5e-4 : 5e-5 : 0.01;
%ar = 5e-4 : 0.5e-5 : 5e-3;
%ar = 5e-4 : 2e-5 : 0.01;
[nar lar] = size(ar);
% some initial value of the variable to solve : free electron fraction y :
y0 = [1; t0/ar(1)];
% the first value is the proton fraction, the second the primary ionised HeII fraction
%y0 = [1; (yp/4)/(1- yp); t0/ar(1)]


% electron fraction at reionisation
xei = 1;

% calculate the fractional abundance Xe as a function of x or 1/T :
options = odeset('RelTol', 1e-12, 'AbsTol', 1e-8, 'NormControl','on');
%[a1 xe1] = ode23s(@freceq, ar, xe0, options, om, omb, omt, h);
[a1 y1] = ode23tb(@freceq, ar, y0, options, om, omb, omt, h);
%[a1 y1] = ode23tb(@freceq1, ar, y0, options, om, omb, h);
xe = [y1(:,1)]';
%xe = [y1(:,1) + y1(:,2)]';
tm = [y1(:,2)]';

% introduce reionisation (xe==1) in xe: zritr is a treshold value for zri
z1 = 1./ar - 1;
iz1 = find(z1 < zri);
zritr = 0;
if ~isempty(iz1), zritr = z1(iz1(1) - 10); end
xe(iz1) = xei * ones(1, length(iz1));

% calculate the inverse optical depth, d(tau)d(eta) in Mpc^-1
coeftau = cr * omb * h^2 * (1 - yp) *ncr * pcm;
dtau = coeftau * xe .* (z1 + 1) .^2;

% make a table for interpolation of dtau
dtau_table = [z1; xe];

% find tau as function of the redshift by integrating xe (integrant : dtauint)
pp = spline(dtau_table(1,:), dtau_table(2,:));
for i = 1:lar-1
   tau(i) = quadl(@dtauint, 0, z1(i), tol, trace, pp, om, omb, omt, h) * coeftau *c;
end;
tau(lar) = 0;
% calculate the optical length (tauri) for reionisation
tauri = 0
if zri > 0
  tauri = quadl(@dtauint, 0, zri, tol, trace, pp, om, omb, omt, h) * coeftau *c
end

figure(1)
clf
%plot(x, cf)
%loglog(z1, xe(:,1), z2, xe(:,2), z1, t0 ./ a1, '--')
%loglog(z1, xe)
%axis([1e2 1e4 1e-4 1])
semilogy(z1, xe, z1, tm/1e4, z1, t0/1e4 ./ ar, '--')
%semilogy(1 ./a1, xe)
ylabel('10log of free electron fraction')
xlabel('redshift z')
title('electron fraction in recombination to H atom')

% find the coefficient for dtau/deta as f of y=a/aeq and compare with the approximation of Hu and Sugiyama
% see Hu and Sugiyama ApJ nr 444 p 489 (1995) formula C3-C4
% compare also with the results of P.Peebles (dtau3) of his article in ApJ nr153, p1 (1968), table 1
% and with the approximation of B.Jones, F.Wyse (dtau4) in Astron Astrophys nr149 p150 (1985)
aeq = ka1/(om * h^2);
keq = h0 * h * sqrt(om*2/aeq);
% for the formula dtau = (y0/y)^(c2+0.5) see my notes p103
y0 = (c2 *omb^c1 *keq/(sqrt(2) * (1e3*aeq)^c2))^(1/(c2+0.5));
y = ar/aeq;

dtau1 = 2.3e-5* (1 - yp/2)* omb* h^2 * xe ./ (ar .^2);
dtau2 = (y0 ./ y) .^ (c2 + 0.5);
t_pbls = 1e3*[5 4.5 4 3.5 3 2.5 2 1.5];
xe_pbls = [0.996 0.92 0.4 0.072 0.0098 9.2e-4 1.23e-4 5.3e-5];
a_pbls = (T0*11605) ./ t_pbls;
ypbls = a_pbls/aeq;
zpbls = 1 ./a_pbls;
dtau3 = 2.3e-5* (1 - yp/2)* omb* h^2 * xe_pbls ./ (a_pbls .^2);
z_jones = [2000 1900 1800 1700 1600 1500 1400 1300 1200 1100 1000 900 800 700 600 500];
xe_jones = [1  1 0.999 0.994 0.96 0.807 0.498 0.227 0.0872 0.0295 8.56e-3 2.19e-3 6.72e-4 3.25e-4 2.1e-4 1.55e-4];
a_jones = 1 ./ (z_jones + 1);
yjs = a_jones/aeq;
zjs = 1 ./a_jones;
dtau4 = 2.3e-5* (1 - yp/2)* omb* h^2 * xe_jones ./ (a_jones .^2);

% calculate the optical depth formula (C-1) of Hu and S.
tau_hs = omb^c1 * (z1/1e3).^c2;
figure(2)
clf
loglog(z1, tau, 'r', z1, dtau1, z1, dtau2, '--', zpbls, dtau3, '+', zjs, dtau4, '.')
%loglog(z1, tau, z1, tau_hs, '--')
title('optical depth (dtau) and tau from different authors')
ylabel('dtau in Mpc^-1')
xlabel('redshift z')

figure(3)
clf
subplot(2,2,1)
% calculate the visibility function
vsb = dtau .* exp(-tau);
plot(z1, vsb, 'r')
%loglog(z1, tau, z1, dtau, '--', z1, vsb)

subplot(2,2,2)
[mb ib] = max(vsb);
zdec = z1(ib);
% the redshift for decoupling is found at ~1089
plot(z1, vsb, 'r', 1089*ones(1, 11), [0:10])
axis([1040, 1130, max(vsb)*0.7, max(vsb)*1.2])

subplot(2,2,3)
% find a better max by interpolation
% make a spline of the result
z3 = 860:0.1:1260;
vsb3 = interp1(z1, vsb, z3, 'spline');
plot(z3, vsb3, 'r', 1089*ones(1, 11), 1.1*max(vsb)*[0:10])
axis([1065, 1110, max(vsb)*0.95, max(vsb)*1.05])
title('the maximum in the visibility function, with wmap data')
xlabel('redshift z')

subplot(2,2,4)
% search for the point where tau==1
plot(z1, tau, z1, ones(1, lar))
axis([1080, 1100, 0, 2])

%calculate the maximum of the visibility function and the redshift for decoupling
[mb3 ib3] = max(vsb3);
zdec = z3(ib3);
% calculate the full width at half maximum of the visibility function :ea the thickness of the
% decoupling surface
ids = find(vsb3 >= 0.5* mb3);
tds = z3(ids(length(ids))) - z3(ids(1));

% calculate the age of the universe in kyear at z=zrec
%tdec = 13.7e6/(3 * sqrt(1 - om)) * acosh(2 *(1 - om)/(om * zdec^3) + 1);
tdec = (9.786e9/(h * 1e3)) * quadl(@ageuniv, 1e8, zdec, tol, trace, om, omt, h);
% calculate the age of the universe in kyear at z=zri
%tdec = 13.7e6/(3 * sqrt(1 - om)) * acosh(2 *(1 - om)/(om * zdec^3) + 1);
tri = (9.786e9/(h * 1e3)) * quadl(@ageuniv, 1e8, zri, tol, trace, om, omt, h);
% calculate the current age of the universe in Gy
trc = (9.786e9/(h * 1e9)) * quadl(@ageuniv, 1e8, 0, tol, trace, om, omt, h);

%calculate the conformal distance in Mpc at the moment of decoupling = -int(dz/((z+1)*H(z))
% etadec1 is the most accurate: etadec2 is valid only in the radiation era
etadec = (c/(1e5 * h))* quadl(@confdist, 1e8, zdec, tol, trace, om, omt, h);
etadec2 = sqrt(8) * (sqrt(1/(zdec *aeq) + 1) - 1)/keq;

fid = 1;
fprintf(fid, 'the maximum of the visibility function and the redshift for decoupling = %g\n', zdec);
fprintf(fid, 'the thickness of the decoupling surface (half width of vsb in redshift) = %g\n', tds);
fprintf(fid, 'estimated conformal distance at decoupling = %g Mpc\n', etadec2);
fprintf(fid, 'the conformal distance at decoupling, the most accurate result = %g Mpc\n', etadec);
fprintf(fid, 'the age of the universe at decoupling = %g kyear\n', tdec);
fprintf(fid, 'the current age of the universe = %g Gyear\n', trc);

% make a table of xe values over the range 1e-8 <= a <= 1 : include the previous calculated
% xe values of Peebles and the visibility function
ea1 = -8 : 0.005 :0;
ata = 10 .^ea1;
[nat lat] = size(ata);
xe1 = ones(1, lat);
clear('dtau1')
dtau1 = ones(1, lat);
% as always exp(-tau) is calculated, we limit tau1 to a max tau(1)
tau1 = ones(1, lat)* tau(1);
vsb1 = zeros(1, lat);
for i = 1:lat
   if ata(i) >= ar(1)
      z3 = 1/ata(i) - 1;
      if ata(i) < 1/(zritr + 1)
        xe1(i) = interp1(dtau_table(1,:), dtau_table(2,:), z3, 'spline');
        tau1(i) = interp1(ar, tau, ata(i), 'spline');
        is1 = find(ar < ata(i));
        if  vsb(is1(end)) < 1e-15
           vsb1(i) = 0;
        else
           vsb1(i) = interp1(ar, vsb, ata(i), 'spline');
        end
      else
        xe1(i) = interp1(dtau_table(1,:), dtau_table(2,:), z3, 'linear');
        tau1(i) = interp1(ar, tau, ata(i), 'linear');
        vsb1(i) = interp1(ar, vsb, ata(i), 'linear');
      end   
   end
   dtau1(i) = coeftau * xe1(i)/ata(i)^2;
end

% save in order 1. scale factor, electron fraction, optical depth, tau, visibility function..
dt_table = [ata; xe1; dtau1; tau1; vsb1];

% save in order 1. scale factor, electron fraction, optical depth, tau, visibility function..
dt_table = [ata; xe1; dtau1; tau1; vsb1];
dt.dt_table = dt_table;
dt.tauri = tauri;
dt.zri = zri;
dt.tri = tri;
dt.trc = trc;
dt.tds = tds;
dt.etadec = etadec;
dt.tdec = tdec;
dt.zdec = zdec;
dt.xei = xei;

figure(4)
clf
loglog(ata, xe1, 'k--', ata, dtau1, ata, tau1)
title('electron fraction (xe), dtau and optical depth (tau) as f of the scalefactor')

save cmbxe  dt
%sdata =load('cmbxe');
tbl = dt_table;
figure(5)
clf
semilogx(tbl(1,:), tbl(2,:), 'x', ar, xe, tbl(1,:), tbl(4,:)/max(tbl(4,:)), '--', ...
                 tbl(1,:), 10*tbl(5,:)/max(tbl(5,:)));
axis([1e-4 1 0 2])
%loglog(tbl(1,:), tbl(4,:))
%loglog(tbl(1,:), tbl(3,:))
title('electron fraction (xe), tau (--) and visibility function')
xlabel('scalefactor of the universe, a')

return


