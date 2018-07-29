%segments_demo

% S. de Waele, March 2003.

clear
close all

n_spec = 500;

disp('Automatic inference from 3 segments of equal length of an MA(6) process')
disp('using reduced statistics ARMAsel.')
a = 1;
b = rc2arset([1 -.1 -.3 .3 0 .2 -.15]);
n_obs = 500*ones(1,10); %10 segments of 500 observations

x = gendata(a,b,n_obs);

warning off  %To suppress unharmful ARMASA warning 36
rc = burg_s(x,floor(n_obs(1)/2));
warning on
arh = rc2arset(rc);

[ah,bh,sellog] = armasel_rs(arh,n_obs,0:200,0:10,0:10);

me = moderr(ah,bh,a,b,sum(n_obs))

[h,f] = arma2psd(a,b,n_spec);
hold on
hh = arma2psd(ah,bh,n_spec);
h_arh = arma2psd(arh,1,n_spec);
semilogy(f,h_arh,'y',f,[h' hh'])
xlabel('\nu')
ylabel('h')
legend('AR high','True',['Red.Stat. : ' modeltype(ah,bh)])
title('True power spectrum and estimate from reduced statistics.')

