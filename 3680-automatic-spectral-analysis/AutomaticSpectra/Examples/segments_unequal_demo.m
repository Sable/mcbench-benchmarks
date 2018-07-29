%segments_unequal_demo

% S. de Waele, March 2003.

clear
close all

n_spec = 500;

disp('Automatic inference from segments of unequal length.')
a = rc2arset([1 .44 -.33 .22 .11]);
b = rc2arset([1 -.4 -.3]);
n_obs1 = 100*ones(1,10);
n_obs2 = 500;
x = {gendata(a,b,n_obs1) gendata(a,b,n_obs2)};
n_obs = [n_obs1 n_obs2];
rc = burg_su(x,floor(n_obs2/2));

arh = rc2arset(rc);

[ah,bh,sellog] = armasel_rs(arh,n_obs);
me = moderr(ah,bh,a,b,sum(n_obs))

%ARMAsel using using only the last segment
xl = x{end}(:,end);
[ah2,bh2] = armasel(xl);
me2 = moderr(ah2,bh2,a,b,sum(n_obs))
me_h_h2 = moderr(ah2,bh2,ah,bh,n_obs(end))

[h,f] = arma2psd(a,b,n_spec);
hold on
hh = arma2psd(ah,bh,n_spec);
h_arh = arma2psd(arh,1,n_spec);
hh2 = arma2psd(ah2,bh2,n_spec);

semilogy(f,h_arh,'y',f,[h' hh' hh2'])
xlabel('\nu')
ylabel('h')
legend('AR high','True',['Red.Stat. : ' modeltype(ah,bh)],['ARMAsel last seg : ' modeltype(ah2,bh2)])
title('True power spectrum and estimate from reduced statistics.')