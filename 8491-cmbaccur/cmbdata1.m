function  [asc, lmin, lmax] = cmbdata1(as, pm, h, omt, om, omb, ns, tauri, bmark)
% this function does data processing on cmb data in a matlab datafile fn.mat
% use it with a datafile after running cmbaccur.m
% inputs are: the cmb data (as), the power spectrum of matter(pm), the Hubble factor (h),
% the matter content of the universe (om), the relative number density of baryons (omb),
% the spectral index (ns), optical depth at reionisation (tauri) and the name of the cmbfast benchmark to compare with.
% the function returns the normalisation constant (asc) and the positions of the peaks (minima and maxima) in the 
% temperature anisotropy spectrum (lm)
%
% D Vangheluwe 5 jan 2005
% remark1 : our data have to be squared and multiplied with 1e12 before to be compared with the wmap data!!
% remark 2: 'h72' and 'h82' are obtained from the cmbfast site
% remark 3: the normalisation constant c1==1 is for the perfect fit to wmap2003.


c10f = 6.64;

% last results
ctt = as.ctt;
cee = as.cee;
cte = as.cte;
la = as.la;
lmax = la(end);
lmin = la(1);
lla = size(la);
kh = pm.k;
psm = pm.psm;

% compare with a previous result (at the moment 0.1% accuracy)  : cmban1 is from h72i with 0.1% accuracy
fname = 'cmban1.mat';   %default 'cmban1.mat'
if  exist(fname)== 2 
   data1 = load(fname);  
   lap = data1.as.la;
   cttp = data1.as.ctt;
else
   lap = la;
   cttp = as.ctt;
end

        switch bmark
          case 'h72'
%(h0=72/omegab=0.046/omegac=0.224/omegav=0.73/an=0.99/tau=0)
% ofwel om = 0.27, omb = 0.046, nprimtilt = 0.99, tauri = 0 (no reionisation)
	load -ascii cmbfast5.dat
	bm = cmbfast5;

          case 'h72o1'
%(h0=72/omegab=0.046/omegac=0.224/omegav=0.63/an=0.99/tau=0)(omegav = omt - om)
% ofwel omt = 0.9, om = 0.27, omb = 0.046, nprimtilt = 0.99, tauri = 0 (no reionisation) 
	load -ascii h72o1.dat
	bm = h72o1;

          case 'h72o2'
%(h0=72/omegab=0.046/omegac=0.224/omegav=0.43/an=0.99/tau=0)(omegav = omt - om)
% ofwel omt = 0.7, om = 0.27, omb = 0.046, nprimtilt = 0.99, tauri = 0 (no reionisation) 
	load -ascii h72o2.dat
	bm = h72o2;

          case 'h72c1'
%(h0=72/omegab=0.046/omegac=0.224/omegav=0.83/an=0.99/tau=0)(omegav = omt - om)
% ofwel omt = 1.1, om = 0.27, omb = 0.046, nprimtilt = 0.99, tauri = 0 (no reionisation) 
	load -ascii h72c1.dat
	bm = h72c1;

          case 'h72c2'
%(h0=72/omegab=0.046/omegac=0.224/omegav=0.103/an=0.99/tau=0)(omegav = omt - om)
% ofwel omt = 1.3, om = 0.27, omb = 0.046, nprimtilt = 0.99, tauri = 0 (no reionisation) 
	load -ascii h72c2.dat
	bm = h72c2;

          case 'h72i'
% (h0=72/omegab=0.046/omegac=0.224/omegav=0.73/an=0.99/tau=0.17)
% ofwel om = 0.27, omb = 0.046, nprimtilt = 0.99, reionisation at z=31
	load -ascii cmbfast6.dat
	bm = cmbfast6;

          case 'h82'
% (h0=82/omegab=0.046/omegac=0.194/omegav=0.76/an=0.98/tau=0/annur=3)
% ofwel om = 0.24, omb = 0.046, nprimtilt = 0.98, tauri = 0, (no reionisation)
	load -ascii cmbf82.dat
	bm = cmbf82;

	  case 'h82i'
% (h0=82/omegab=0.046/omegac=0.194/omegav=0.76/an=0.98/tau=0/annur=3/tau=0.210)
% ofwel h = 0.82, om = 0.24, omb = 0.046, nprimtilt = 0.98, tauri = 0, reionisation  :zri = 17.3
	load -ascii cmbf82i.dat
	bm = cmbf82i;

	  case  'cdm'
% (h0=50/omegab=0.046/omegac=0/omegav=omegab/an=a/annur=3/tau=0)
% ofwel om=omb, omb = 0.046, nrpimtilt = 1, tauri = 0, no reionisation
        load -ascii cdmspec.dat
        bm = cdmspec;

          otherwise
%(h0=72/omegab=0.046/omegac=0.224/omegav=0.73/an=0.99/tau=0)
% ofwel om = 0.27, omb = 0.046, nprimtilt = 0.99, tauri = 0 (no reionisation)
	load -ascii cmbfast5.dat
	bm = cmbfast5;
%         bm = [];
            disp('Unknown bench')
        end

if ~isempty(bm)
   la_b = bm(:,1);
   ctt_b = bm(:,2);
   cee_b = bm(:,3);
   cte_b = bm(:,4);
end

s1 = load('cmbbench');  %load the super accurate benchmark cmb values;
% (h=72/om=0.27/omb=0.046/ns=0.99/tauri=0 : maxstep =1, tol_ode23=1e-5, tstep =0.5, ct1max=eta0, lk1=100)
la001 = s1.as.la;
ctt001 = s1.as.ctt;

% load a 0.1% calculation of h72
%data3 = load('cmbansp');
la01 = lap;
ctt01 = cttp;

%load the wmap results for the temperature spectrum (TT) from the wmap site (9 nov 2004)
load -ascii wmapdata.dat;

%load the wmap results for the cross-polarisation spectrum (TE) from the wmap site (1 feb 2005)
load -ascii wmap_pol.dat;
          
[nla lla] = size(la);
[nlw llw] = size(wmapdata);
[nlc llc] = size(bm);
la_p = wmap_pol(:,1);
wa_p = (la_p + 1) .* wmap_pol(:,2)/(2*pi);

la3 = 2:lmax;
ctt3 = spline(la, ctt, la3);
cee3 = spline(la, cee, la3);
cte3 = spline(la, cte, la3);

% find the normalisation factor by regression
iw1 = find(wmapdata(:,1) <= lmax);
b0 = spline(la, 1e12*ctt, wmapdata(iw1,1));
b1 = spline(la_b, 1e12*ctt_b, wmapdata(iw1,1));
b2 = spline(la_b, cee_b, la);
[c1, flag] = lsqr(wmapdata(iw1,4), b0);
[c10, flag] = lsqr(wmapdata(iw1,4), b1);
[c10p, flag] = lsqr(cee', b2');

figure(2)
% plot the power spectrum of dark matter
% measured points from L Verde et al Astr J 2004?
k1 = [0.011 0.038 0.060 0.10 0.22 0.405 0.7 1.02];
mp1 = [3e4 2e4 1.3e4 6e3 1.5e3 4e2 1.5e2 4e1];
loglog(kh, psm/c1, k1, mp1, '+')
axis([1e-2 k1(end) 1e2 1e5])
title('power spectrum of dark matter in (Mpc/h)^3')
xlabel('wave number (kh) in units h/Mpc')

figure(3)
clf
% the factor 1e12 is because we plot in microKelvin^2 thus not in K^2
plot(la3, 1e12*ctt3/c1, wmapdata(:,1), wmapdata(:,4), '+', la_b, 1e12* ctt_b/c10, '--')
title(['anisotropy spectrum (wmap=+):omt=', num2str(omt), ',h=', num2str(h), ',om=', num2str(om), ...
   ',omb=', num2str(omb), ',ns=', num2str(ns), ',tauri=', num2str(tauri)])
ylabel('l*(l+1)*Cl/(2*pi) in microKelvin^2')
xlabel('anglenumber l')

figure(4)
clf
% plot the anistropy data in microKelvin^2
%semilogx(la3, 1e12*ctt3/c1, wmapdata(:,1), wmapdata(:,4), '+', la_b, 1e12* ctt_b/c10,'--')
semilogx(la3, 1e12*ctt3/c1, wmapdata(:,1), wmapdata(:,4), '+', la_b, 1e12* ctt_b/c10,'--')
%semilogx(la3, 1e12*ctt3/c1, '--')
title(['anisotropy spectrum (wmap=+):omt=', num2str(omt), ',h=', num2str(h), ',om=', num2str(om), ...
   ',omb=', num2str(omb), ',ns=', num2str(ns), ',tauri=', num2str(tauri)])
ylabel('l*(l+1)*Cl/(2*pi) in microKelvin^2')
xlabel('anglenumber l')

figure(5)
clf
% plot the polarisation spectrum in microKelvin^2
plot(la3, c10p*1e12*cee3, la_b, 1e12* cee_b, '--')
title(['polarisation spectrum (wmap=+):omt=', num2str(omt), ' h=', num2str(h), ',om=', num2str(om), ...
   ',omb=', num2str(omb), ',ns=', num2str(ns), ',tauri=', num2str(tauri)])
ylabel('l*(l+1)*Cl/(2*pi) in microKelvin^2')
xlabel('anglenumber l')

%plot the temperature_polarisation cross-correlation spectrum
figure(6)
clf
semilogx(la3, (1e12/c1)*cte3 ./la3, la_b, (1e12/c10)* cte_b ./la_b, '--', la_p , wa_p, '+')
title(['cross-correlation spectrum (wmap=+):omt=', num2str(omt), ' h=', num2str(h), ',om=', num2str(om), ...
   ',omb=', num2str(omb), ',ns=', num2str(ns), ',tauri=', num2str(tauri)])
ylabel('(l+1)*Cl/(2*pi) in microKelvin^2')
xlabel('anglenumber l')

figure(7)
clf
% compare the data with cmbfast
ctt5 = spline(la_b, ctt_b/c10, la);
ctta = ctt/c1;
[ctta;  ctt5];
plot(la, (ctta - ctt5) ./ctt5)
title(['temperature spectrum compared to internet:omt=', num2str(omt), ' h=', num2str(h), ',om=', num2str(om), ...
   ',omb=', num2str(omb), ',ns=', num2str(ns), ',tauri=', num2str(tauri)])
ylabel('deviation in %')
xlabel('anglenumber l')

figure(8)
%cttl = spline(la, ctt, lap);
il1 = find(la01 <= lmax);
cttl = spline(la, ctt, la01(il1));
semilogx(la01(il1), (cttl - ctt01(il1)) ./ cttl);
title(['temp spectrum for 1% accuracy compared to 0.1%: omt=', num2str(omt), ' h=', num2str(h), ',om=', num2str(om), ...
   ',omb=', num2str(omb), ',ns=', num2str(ns), ',tauri=', num2str(tauri)])
ylabel('deviation in %')
ylabel('l*(l+1)*Cl/(2*pi)')
xlabel('anglenumber l')

% calculate the peak positions (minima and maxima) in the anisotropy spectrum in the series [la4, cmb4]
la4 = lmin:0.1:lmax;
ctt4 = spline(la, ctt, la4);
lla4 = size(la4, 2);
sign1 = -1;
psr = ctt4(1);
k1 = 1;
k2 = 1;
for i = 2:lla4
  if sign(ctt4(i) - psr) ~= sign1
     sign1 = sign(ctt4(i) - psr);
     if sign1 > 0
       lmin(k1) = la4(i);
       k1 = k1 + 1;
     else
       lmax(k2) = la4(i);
       k2 = k2 + 1;
     end
     
  end
  psr = ctt4(i);
end
llm1 = size(lmin, 2);
llm2 = size(lmax, 2);
%lmin
%lmax

asc = 1/c1;


