%subband_demo

% S. de Waele, March 2003.

clear
close all

n_spec = 500;

%Process
a = rc2arset([1 -.1 -.3 .77 0 .2 -.15]);
b = rc2arset([1 -.4 -.5]);
n_obs = 1000;

disp('Automatic inference from reduced statistics.')
x = gendata(a,b,n_obs);

%Standard ARMAsel
[ahas,bhas] = armasel(x);

%Reduced statistics ARMAsel
Lmax = min(floor(n_obs/2),1000);
arh = sig2ar(x,Lmax);
[ahrs,bhrs,sellog] = armasel_rs(arh,n_obs);

mers = moderr(ahrs,bhrs,a,b,n_obs);
meas = moderr(ahas,bhas,a,b,n_obs);
disp(['Process: ' modeltype(a,b)])
disp(['ARMAsel:    ' modeltype(ahas,bhas) '; error = ' int2str(meas)])
disp(['ARMAsel_rs: ' modeltype(ahrs,bhrs) '; error = ' int2str(mers)])

[h,f] = arma2psd(a,b,n_spec);
hh_rs = arma2psd(ahrs,bhrs,n_spec);
h_arh = arma2psd(arh,1,n_spec);
hh_as = arma2psd(ahas,bhas,n_spec);
semilogy(f,h_arh,'y',f,[h' hh_rs' hh_as'])
xlabel('\nu')
ylabel('h')
legend('True',['Red.Stat. : ' modeltype(ahrs,bhrs)],['ARMAsel : ' modeltype(ahas,bhas)])
title('True power spectrum and estimate from reduced statistics.')

