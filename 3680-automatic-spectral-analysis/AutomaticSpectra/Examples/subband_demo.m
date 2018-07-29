%subband_demo

% S. de Waele, March 2003.

clear
close all

n_spec = 500;

%Process
p1 = exp(-1/2000+i*pi*1/100);
p2 = exp(-1/2000+i*pi*1/140);
a1 = poly([p1 conj(p1)]);
a2 = poly([p2 conj(p2)]);
[a,b] = sumARMA(a1,1,1,a2,1,1);
n_obs = 10000;
Lmax = min(n_obs/2,1000);

%Subband
bs = 0; %Start band
bw = .02; %Bandwidth;
n_spec_sb = n_spec/bw;
subband = bs*n_spec_sb+1:(bs+bw)*n_spec_sb;
n_obs_sb = bw*n_obs;

%AR model of true subband spectrum
[h,f] = arma2psd(a,b,n_spec_sb);
Lt = 100;
ar_sb  = psd2ar(h(subband),Lt);
[h_sb,f_sb] = arma2psd(ar_sb,1,n_spec);

disp('Automatic inference for a subband of the sum of 2 AR(2) proceses.')
x = gendata(a,b,n_obs);

%Standard ARMAsel
[ah,bh] = armasel(x);

%Subband ARMAsel
Lmax = floor(n_obs/2);
arh = sig2ar(x,Lmax);

h_arh = arma2psd(arh,1,n_spec_sb);
h_arh_sb = h_arh(subband);
arh_subband = psd2ar(h_arh_sb,bw*Lmax);

[ah_sb,bh_sb,sellog] = armasel_rs(arh_subband,bw*n_obs);

%Comparison of results
%AR model of ARMAsel spectrum
[h_as,f] = arma2psd(ah,bh,n_spec_sb);
Lt = 100;
h_as_sb  = h_as(subband);
arh_as_sb  = psd2ar(h_as_sb,Lt);

%Model Error
meas = moderr(arh_as_sb,1,ar_sb,1,bw*n_obs);
meas_sb = moderr(ah_sb,bh_sb,ar_sb,1,bw*n_obs);
disp(['Process: ' modeltype(a,b)])
disp(['ARMAsel: ' modeltype(ah,bh) '; subband-error = ' int2str(meas)])
disp(['ARMAsel-subband: ' modeltype(ah_sb,bh_sb) '; subband-error = ' int2str(meas_sb)])

%Spectra
h_as_sb = arma2psd(arh_as_sb,1,n_spec);
h_h_sb = arma2psd(ah_sb,bh_sb,n_spec);
p_in_sb = mean((h(subband)));

figure
semilogy(f,[h' h_as'],f(subband),p_in_sb*h_h_sb')

xlabel('\nu')
ylabel('h')
legend('True','ARMAsel','ARMAsel-sb')
title('Entire spectrum.')

figure
semilogy(f(subband),[h_sb' h_as_sb' h_h_sb'])
xlabel('\nu')
ylabel('h')
legend('True-sb','ARMAsel','ARMAsel-sb')
title('Subband.')